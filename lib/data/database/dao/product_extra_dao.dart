import 'package:floor/floor.dart';
import 'package:foodie/data/database/dao/abstract_dao.dart';
import 'package:foodie/data/models/food_extra.dart';

@dao
abstract class ProductExtraDao extends AbstractDao<ProductExtra> {
  @Query('SELECT * FROM product_extras')
  Future<List<ProductExtra>> findAll();

  @Query("DELETE FROM product_extras WHERE productId = :productId")
  Future<void> deleteAllByProductId(int productId);

  @Query('SELECT * FROM product_extras WHERE productId = :productId')
  Stream<List<ProductExtra>> findAllByProductIdAsStream(int productId);

  @Query('SELECT * FROM product_extras WHERE productId = :productId')
  Future<List<ProductExtra>> findAllByProductId(int productId);

  @Query('DELETE FROM product_extras')
  Future<void> deleteAll();
}
