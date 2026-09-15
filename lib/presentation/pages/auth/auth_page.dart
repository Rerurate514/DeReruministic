import 'package:dereruministic/presentation/pages/auth/components/background/auth_background.dart';
import 'package:dereruministic/presentation/pages/auth/components/panel/auth_panel.dart';
import 'package:dereruministic/presentation/widgets/ui_page_wrapper.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return UiPageWrapper(
      child: Stack(
        children: [
          const AuthBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: const AuthPanel(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
