import './id_manager.dart';

// generates integer ids incrementally
class IntIDManager implements IDManager<int>{

  var  _idCounter = 0;

  IntIDManager({required int initialCounter}): _idCounter = initialCounter;

  @override
  int get newID => ++_idCounter;

}