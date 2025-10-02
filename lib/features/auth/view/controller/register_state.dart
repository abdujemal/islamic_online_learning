import 'package:islamic_online_learning/features/auth/model/group.dart';

class RegisterState {
  final bool isSaving, isLoadingGroups, isAddingNewGroup;
  final List<Group> groups;
  final String? error;

  RegisterState({
    this.isSaving = false,
    this.isLoadingGroups = false,
    this.isAddingNewGroup = false,
    this.groups =  const [],
    this.error,
  });

  RegisterState copyWith({
    bool? isSaving,
    bool? isLoadingGroups,
    bool? isAddingNewGroup,
    List<Group>? groups,
    String? error,
  }) {
    return RegisterState(
      isSaving: isSaving ?? this.isSaving,
      isLoadingGroups: isLoadingGroups ?? this.isLoadingGroups,
      isAddingNewGroup: isAddingNewGroup ?? this.isAddingNewGroup,
      groups: groups ?? this.groups,
      error: error,
    );
  }
}
