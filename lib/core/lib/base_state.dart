abstract class BaseState {
  final bool isLoading;
  final String? error;
  final bool isErrorAuth;
  final bool isErrorPayment;

  const BaseState({
    this.isLoading = false,
    this.error,
    this.isErrorAuth = false,
    this.isErrorPayment = false,
  });

  BaseState copyWith({
    bool? isLoading,
    String? error,
    bool? isErrorAuth,
    bool? isErrorPayment,
  });
}
