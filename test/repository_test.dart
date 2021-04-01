import '../lib/models/validation/validator.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/models/expense.dart';
import '../lib/repositories/repository.dart';
import '../lib/models/validation/expense_validator.dart';

void main() {
  Repository<int, Expense> repository =
      Repository(validator: ExpenseValidator());

  group('Test repository class', () {
    setUp(() {
      repository = Repository(validator: ExpenseValidator());
    });

    test('Add entity to repository, valid entity, added entity returned', () {
      var e = Expense.now(id: 1, title: "exp", amount: 10);
      var addedE = repository.save(e);
      assert(addedE.contains(e));
    });

    test('Add entity to repository, invalid entity, ValidationExceptionThrown',
        () {
      try {
        var e = Expense(
            id: 1, title: "exp", amount: -10, date: DateTime(2023, 12, 25));
        repository.save(e);
        assert(false);
      } on Exception catch (e) {
        assert(e is ValidationException);
      }
    });

    test('Add entity, ID already in use, present entity returned', () {
      var e1 = Expense.now(id: 1, title: "abc", amount: 11);
      var e2 = Expense.now(id: 1, title: "xyz", amount: 12);
      repository.save(e1);
      assert(repository.save(e2).contains(e1));
    });

    test('Update entity, valid updated entity, updated entity returned', () {
      var e = Expense.now(id: 1, title: "exp", amount: 10);
      repository.save(e);
      var eUpdated = e.copyWith(title: "exp0", amount: 12);
      assert(repository.update(eUpdated).contains(eUpdated));
    });

    test('Update entity, invalid updated entity, ValidationException thrown',
        () {
      try {
        var e = Expense.now(id: 1, title: "exp", amount: 10);
        repository.save(e);
        repository
            .update(e.copyWith(amount: -10, date: DateTime(2100, 12, 20)));
        assert(false);
      } on Exception catch (e) {
        assert(e is ValidationException);
      }
    });

    test('Update entity, no entity to update in repo, null returned.', () {
      assert(repository
          .update(Expense.now(id: 1, amount: 10, title: "exp"))
          .isEmpty);
    });

    test('Delete entity from repo, entity is in repo, deleted entity returned.',
        () {
      var e = Expense.now(id: 1, title: "exp", amount: 10);
      repository.save(e);
      assert(repository.delete(e.id).contains(e));
    });

    test('Delete entity from repo, entity not in repo, null returned.', () {
      assert(repository.delete(0).isEmpty);
    });

    test('Get entity by id, entity in repo, entity returned.', () {
      var e = Expense.now(id: 1, title: "exp", amount: 10);
      repository.save(e);
      assert(repository.findByID(e.id).contains(e));
    });

    test('Get entity by id, entity not in repo, null returned.', () {
      assert(repository.findByID(0).isEmpty);
    });

    test('Get all entities, repo not empty, all inserted entities retrieved',
        () {
      var e1 = Expense.now(id: 1, title: "exp", amount: 11);
      var e2 = Expense.now(id: 2, title: "exp", amount: 12);
      repository.save(e1);
      repository.save(e2);
      var entities = repository.getAll();
      assert(entities.contains(e2));
      assert(entities.contains(e1));
    });
  });
}
