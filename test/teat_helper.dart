import 'package:islamic_online_learning/features/main/data/main_data_src.dart';
import 'package:islamic_online_learning/features/main/domain/main_repo.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks(
  [
    MainDataSrc,
    MainRepo,
  ],
// customMocks: [
//   MockSpec<FirebaseDatabase>(as: #MFirebaseDatabase)
// ]
)
void main() {}
