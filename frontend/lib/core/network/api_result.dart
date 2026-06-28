/// Small wrapper for the outcome of an API call.
///
/// Lets callers handle success/failure without scattering try/catch:
/// ```dart
/// final result = await api.getClinics();
/// if (result.isSuccess) {
///   use(result.data!);
/// } else {
///   show(result.error!);
/// }
/// ```
class ApiResult<T> {
  final T? data;
  final String? error;

  const ApiResult.success(this.data) : error = null;
  const ApiResult.failure(this.error) : data = null;

  bool get isSuccess => error == null;
  bool get isFailure => error != null;
}
