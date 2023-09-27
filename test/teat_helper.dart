import 'package:firebase_database/firebase_database.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  // FirebaseAuth,
  DatabaseReference,
  MainRepo,
  DataSnapshot,
], customMocks: [
  MockSpec<FirebaseDatabase>(as: #MFirebaseDatabase)
])
void main() {}
