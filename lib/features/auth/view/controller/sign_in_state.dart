
class SignInState {
  final bool isLoading, isPhoneMode;
  final String? otpId;
  final String? error;

  SignInState({
    this.isLoading = false,
    this.isPhoneMode = false,
    this.otpId,
    this.error,
  });

  SignInState copyWith({
    bool? isLoading, isPhoneMode,
    String? otpId,
    String? error,
  }) {
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      isPhoneMode: isPhoneMode ?? this.isPhoneMode,
      otpId: otpId ?? this.otpId,
      error: error,
    );
  }
}
