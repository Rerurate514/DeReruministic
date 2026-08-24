import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

@riverpod
FirebaseFirestore firestoreProvider(Ref ref) {
  return FirebaseFirestore.instance;
}
