import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseDatabaseProvider =
    Provider<FirebaseDatabase>((ref) => FirebaseDatabase.instance);
