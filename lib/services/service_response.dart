enum OperationStatus{
  SAVED,
  DELETED,
  UPDATED,
  RETRIEVED,
  ID_TAKEN,
  ID_NOT_FOUND
}

class ServiceResponse<T>{

  final T? _payload;
  final OperationStatus status;

  ServiceResponse(this.status, {T? payload}): _payload = payload;

  T? getPayloadIfStatus(OperationStatus status)
  => this.status == status? _payload : null;

  void ifStatus(OperationStatus status, Function callback) {
    if (this.status == status) callback(_payload);
  }

  T? getPayloadIfStatusOrElse(OperationStatus status,
      {required T? Function(T?) elseCallback})
  => this.status == status? _payload : elseCallback(_payload);

  void ifStatusOrElse(OperationStatus status,
      {required void Function(T?) desiredStatusCallback,
        required void Function(T?) elseCallback})
  => this.status == status
      ? desiredStatusCallback(_payload)
      : elseCallback(_payload);


}