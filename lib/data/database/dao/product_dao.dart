import 'package:floor/floor.dart';
import 'package:foodie/data/database/dao/abstract_dao.dart';
import 'package:foodie/data/models/product.dart';

@dao
abstract class ProductDao extends AbstractDao<Product> {
  @Query('SELECT * FROM products')
  Future<List<Product>> findAllProducts();

  @Query('SELECT * FROM products')
  Stream<List<Product>> findAllProductsAsStream();

  @Query('DELETE FROM products')
  Future<void> deleteAll();

  @Query('SELECT * FROM products WHERE vendorId != :vendorId')
  Future<List<Product>> findAllByVendorWhereNot(int vendorId);

  @Query('DELETE FROM products WHERE vendorId != :vendorId')
  Future<void> deleteAllByVendorWhereNot(int vendorId);
}
