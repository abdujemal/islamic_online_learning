class SignInState {
  final bool isLoading, isPhoneMode, isSigningWGoogle;
  final String? otpId;
  final String? error;

  SignInState({
    this.isLoading = false,
    this.isPhoneMode = false,
    this.isSigningWGoogle = false,
    this.otpId,
    this.error,
  });

  SignInState copyWith({
    bool? isLoading,
    bool? isPhoneMode,
    bool? isSigningWGoogle,
    String? otpId,
    String? error,
  }) {
    return SignInState(
      isLoading: isLoading ?? this.isLoading,
      isPhoneMode: isPhoneMode ?? this.isPhoneMode,
      isSigningWGoogle: isSigningWGoogle ?? this.isSigningWGoogle,
      otpId: otpId ?? this.otpId,
      error: error,
    );
  }
}
