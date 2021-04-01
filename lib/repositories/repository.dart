import 'dart:collection';

import 'package:optional/optional.dart';

import '../models/base_entity.dart';
import '../models/validation/validator.dart';

class Repository<ID,T extends BaseEntity<ID>> {

  final Validator<T> _entityValidator;
  final Map<ID, T> _entities = HashMap();

  Repository({required validator}):
        _entityValidator = validator;

  Optional<T> save(entity) {
    _entityValidator.validate(entity);
    return Optional.of(_entities.putIfAbsent(entity.id, () => entity));
  }

  Optional<T> update(updatedEntity) {
    _entityValidator.validate(updatedEntity);
    return _entities.containsKey(updatedEntity.id)
        ? Optional.of(_entities.update(updatedEntity.id, (oldEntity) => updatedEntity))
        : Optional.empty();
  }

  Optional<T> delete(entityID) => Optional.ofNullable(_entities.remove(entityID));


  Optional<T> findByID(entityID) => Optional.ofNullable(_entities[entityID]);

  List<T> getAll() {
    return _entities.values.toList();
  }



}