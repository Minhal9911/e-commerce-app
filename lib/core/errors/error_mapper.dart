import 'package:e_commerce_app/core/errors/exceptions.dart';

class ErrorMapper {
  static String map(Object e) {
    if (e is ServerException) return e.message;
    return "Something went wrong";
  }
}
