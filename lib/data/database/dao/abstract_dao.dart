import 'package:floor/floor.dart';

abstract class AbstractDao<T> {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertItem(T item);

  @update
  Future<int> updateItem(T item);

  @delete
  Future<int> deleteItem(T item);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<List<int>> insertItems(List<T> items);

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updateItems(List<T> items);

  @delete
  Future<int> deleteItems(List<T> items);
}
