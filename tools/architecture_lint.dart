import 'dart:io';

const packagePrefix = 'package:dereruministic/';

const allowedExternalInDomain = {
  'freezed_annotation',
  'json_annotation',
  'collection',
};

const allowedDartInDomain = {
  'dart:collection',
  'dart:convert',
  'dart:math',
};

void main() {
  final root = Directory.current;
  final lib = Directory('${root.path}${Platform.pathSeparator}lib');

  if (!lib.existsSync()) {
    stderr.writeln('architecture_lint: lib/ was not found.');
    exitCode = 2;
    return;
  }

  final findings = <Finding>[];

  for (final file
      in lib
          .listSync(recursive: true)
          .whereType<File>()
          .where((file) => file.path.endsWith('.dart'))) {
    final relativePath = _relativeTo(root, file);
    final layer = _layerOf(relativePath);

    if (layer == null) {
      continue;
    }

    final imports = _importsOf(file);

    for (final import in imports) {
      final importedLayer = _importedLayerOf(import.uri);

      switch (layer) {
        case 'domain':
          _checkDomainImport(findings, relativePath, import, importedLayer);
        case 'application':
          if (importedLayer == 'infrastructure' ||
              importedLayer == 'presentation') {
            findings.add(
              Finding.error(
                relativePath,
                import.lineNumber,
                'application must not import ${importedLayer!}: ${import.uri}',
              ),
            );
          }
        case 'presentation':
          if (importedLayer == 'infrastructure' || importedLayer == 'di') {
            findings.add(
              Finding.error(
                relativePath,
                import.lineNumber,
                'presentation must go through application/domain, not ${importedLayer!}: ${import.uri}',
              ),
            );
          }
        case 'infrastructure':
          if (importedLayer == 'presentation' ||
              importedLayer == 'application') {
            findings.add(
              Finding.error(
                relativePath,
                import.lineNumber,
                'infrastructure must not import ${importedLayer!}: ${import.uri}',
              ),
            );
          }
        case 'di':
          if (importedLayer == 'presentation' ||
              importedLayer == 'application') {
            findings.add(
              Finding.error(
                relativePath,
                import.lineNumber,
                'di providers must not depend on ${importedLayer!}: ${import.uri}',
              ),
            );
          }
      }
    }
  }

  if (findings.isEmpty) {
    stdout.writeln('architecture_lint: no layer findings.');
    return;
  }

  final errors = findings.where(
    (finding) => finding.severity == Severity.error,
  );
  final warnings = findings.where(
    (finding) => finding.severity == Severity.warning,
  );

  stdout.writeln(
    'architecture_lint: found ${errors.length} error(s), ${warnings.length} warning(s).',
  );
  findings.forEach(stdout.writeln);

  exitCode = errors.isEmpty ? 0 : 1;
}

void _checkDomainImport(
  List<Finding> findings,
  String relativePath,
  Import import,
  String? importedLayer,
) {
  if (importedLayer != null && importedLayer != 'domain') {
    findings.add(
      Finding.error(
        relativePath,
        import.lineNumber,
        'domain must not import $importedLayer: ${import.uri}',
      ),
    );
    return;
  }

  if (import.uri.startsWith('dart:') &&
      !allowedDartInDomain.contains(import.uri)) {
    findings.add(
      Finding.warning(
        relativePath,
        import.lineNumber,
        'domain imports a Dart library that should be reviewed: ${import.uri}',
      ),
    );
    return;
  }

  if (!import.uri.startsWith('package:')) {
    return;
  }

  if (import.uri.startsWith(packagePrefix)) {
    return;
  }

  final packageName = import.uri.substring('package:'.length).split('/').first;
  if (!allowedExternalInDomain.contains(packageName)) {
    findings.add(
      Finding.warning(
        relativePath,
        import.lineNumber,
        'domain imports external package $packageName: ${import.uri}',
      ),
    );
  }
}

List<Import> _importsOf(File file) {
  final imports = <Import>[];
  final lines = file.readAsLinesSync();
  final pattern = RegExp(r'''^\s*import\s+['"]([^'"]+)['"]''');

  for (var index = 0; index < lines.length; index++) {
    final match = pattern.firstMatch(lines[index]);
    if (match == null) {
      continue;
    }
    imports.add(Import(match.group(1)!, index + 1));
  }

  return imports;
}

String? _layerOf(String relativePath) {
  final normalized = relativePath.replaceAll(r'\', '/');
  final parts = normalized.split('/');
  if (parts.length < 2 || parts.first != 'lib') {
    return null;
  }
  final layer = parts[1];
  return switch (layer) {
    'domain' ||
    'application' ||
    'infrastructure' ||
    'presentation' ||
    'di' => layer,
    _ => null,
  };
}

String? _importedLayerOf(String uri) {
  if (!uri.startsWith(packagePrefix)) {
    return null;
  }

  final rest = uri.substring(packagePrefix.length);
  final layer = rest.split('/').first;
  return switch (layer) {
    'domain' ||
    'application' ||
    'infrastructure' ||
    'presentation' ||
    'di' => layer,
    _ => null,
  };
}

String _relativeTo(Directory root, File file) {
  final rootPath = root.path.endsWith(Platform.pathSeparator)
      ? root.path
      : '${root.path}${Platform.pathSeparator}';
  return file.path.replaceFirst(rootPath, '');
}

class Import {
  const Import(this.uri, this.lineNumber);

  final String uri;
  final int lineNumber;
}

enum Severity {
  error,
  warning,
}

class Finding {
  const Finding.error(this.path, this.lineNumber, this.message)
    : severity = Severity.error;

  const Finding.warning(this.path, this.lineNumber, this.message)
    : severity = Severity.warning;

  final String path;
  final int lineNumber;
  final String message;
  final Severity severity;

  @override
  String toString() => '$path:$lineNumber: ${severity.name}: $message';
}
