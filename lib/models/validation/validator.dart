import 'package:flutter/cupertino.dart';

abstract class Validator<T>{
  final StringBuffer _errorMessage = StringBuffer();

  @protected
  void initValidation() => _errorMessage.clear();

  @protected
  void throwIfAnyErrors() {
    if (_errorMessage.isNotEmpty) throw ValidationException(
        _errorMessage.toString());
  }

  @protected
  void appendToErrorMessage(String error){
    if(error.isNotEmpty) _errorMessage.write('\t$error\n');
  }

  void validate(T entity);

}

class ValidationException implements Exception{
  final String message;

  ValidationException(this.message);

  @override
  String toString() {
    return 'ValidationException{\n$message}';
  }
}