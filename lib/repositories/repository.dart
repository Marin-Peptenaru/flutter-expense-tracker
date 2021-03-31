import 'dart:collection';

import '../models/base_entity.dart';
import '../models/validation/validator.dart';

class Repository<ID,T extends BaseEntity<ID>> {

  final Validator<T> _entityValidator;
  final Map<ID, T> _entities = HashMap();

  Repository({required validator}):
        _entityValidator = validator;

  T save(entity) {
    _entityValidator.validate(entity);
    return _entities.putIfAbsent(entity.id, () => entity);
  }

  T? update(updatedEntity) {
    _entityValidator.validate(updatedEntity);
    return _entities.containsKey(updatedEntity.id)
        ? _entities.update(updatedEntity.id, (oldEntity) => updatedEntity)
        : null;
  }

  T? delete(entityID) => _entities.remove(entityID);


  T? findByID(entityID) => _entities[entityID];

  List<T> getAll() {
    return _entities.values.toList();

  }



}