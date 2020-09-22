import 'package:floor/floor.dart';
import 'package:Doory/data/database/dao/abstract_dao.dart';
import 'package:Doory/data/models/vendor.dart';

@dao
abstract class VendorDao extends AbstractDao<Vendor> {
  @Query('SELECT * FROM vendors')
  Future<List<Vendor>> findAllVendors();

  @Query('SELECT * FROM vendors')
  Stream<List<Vendor>> findAllVendorsAsStream();

  @Query('DELETE FROM vendors')
  Future<void> deleteAll();
}
