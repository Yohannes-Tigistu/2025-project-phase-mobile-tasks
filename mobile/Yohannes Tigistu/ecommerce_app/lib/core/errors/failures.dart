class Failures {
  final String message;

  Failures(this.message);

  @override
  String toString() {
    return 'Failures: $message';
  }
}
  class ServerFailure extends Failures{
  ServerFailure(super.message);

  } 
   class CacheFailure extends Failures{
  CacheFailure(super.message);

  } 
