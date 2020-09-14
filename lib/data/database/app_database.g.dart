// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  ProductDao _productDaoInstance;

  ProductExtraDao _productExtraDaoInstance;

  UserDao _userDaoInstance;

  CurrencyDao _currencyDaoInstance;

  VendorDao _vendorDaoInstance;

  NotificationDao _notificationDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `products` (`id` INTEGER, `vendorId` INTEGER, `name` TEXT, `photoUrl` TEXT, `price` REAL, `priceWithExtras` REAL, `selectedQuantity` INTEGER, `description` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `product_extras` (`id` INTEGER, `productId` INTEGER, `price` REAL, `name` TEXT, `photo` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `users` (`id` INTEGER, `name` TEXT, `email` TEXT, `phone` TEXT, `photo` TEXT, `token` TEXT, `tokenType` TEXT, `role` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `currencies` (`id` INTEGER, `name` TEXT, `code` TEXT, `symbol` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `vendors` (`id` INTEGER, `name` TEXT, `slug` TEXT, `address` TEXT, `phoneNumber` TEXT, `latitude` TEXT, `longitude` TEXT, `featureImage` TEXT, `logo` TEXT, `rating` REAL, `total_rating_count` INTEGER, `minimumOrder` REAL, `deliveryFee` REAL, `deliveryRange` REAL, `categories` TEXT, `minimumDeliveryTime` INTEGER, `maxmumDeliveryTime` INTEGER, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `notifications` (`id` INTEGER, `title` TEXT, `body` TEXT, `timeStamp` INTEGER, `read` INTEGER, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  ProductDao get productDao {
    return _productDaoInstance ??= _$ProductDao(database, changeListener);
  }

  @override
  ProductExtraDao get productExtraDao {
    return _productExtraDaoInstance ??=
        _$ProductExtraDao(database, changeListener);
  }

  @override
  UserDao get userDao {
    return _userDaoInstance ??= _$UserDao(database, changeListener);
  }

  @override
  CurrencyDao get currencyDao {
    return _currencyDaoInstance ??= _$CurrencyDao(database, changeListener);
  }

  @override
  VendorDao get vendorDao {
    return _vendorDaoInstance ??= _$VendorDao(database, changeListener);
  }

  @override
  NotificationDao get notificationDao {
    return _notificationDaoInstance ??=
        _$NotificationDao(database, changeListener);
  }
}

class _$ProductDao extends ProductDao {
  _$ProductDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _productInsertionAdapter = InsertionAdapter(
            database,
            'products',
            (Product item) => <String, dynamic>{
                  'id': item.id,
                  'vendorId': item.vendorId,
                  'name': item.name,
                  'photoUrl': item.photoUrl,
                  'price': item.price,
                  'priceWithExtras': item.priceWithExtras,
                  'selectedQuantity': item.selectedQuantity,
                  'description': item.description
                },
            changeListener),
        _productUpdateAdapter = UpdateAdapter(
            database,
            'products',
            ['id'],
            (Product item) => <String, dynamic>{
                  'id': item.id,
                  'vendorId': item.vendorId,
                  'name': item.name,
                  'photoUrl': item.photoUrl,
                  'price': item.price,
                  'priceWithExtras': item.priceWithExtras,
                  'selectedQuantity': item.selectedQuantity,
                  'description': item.description
                },
            changeListener),
        _productDeletionAdapter = DeletionAdapter(
            database,
            'products',
            ['id'],
            (Product item) => <String, dynamic>{
                  'id': item.id,
                  'vendorId': item.vendorId,
                  'name': item.name,
                  'photoUrl': item.photoUrl,
                  'price': item.price,
                  'priceWithExtras': item.priceWithExtras,
                  'selectedQuantity': item.selectedQuantity,
                  'description': item.description
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _productsMapper = (Map<String, dynamic> row) => Product(
      id: row['id'] as int,
      vendorId: row['vendorId'] as int,
      name: row['name'] as String,
      description: row['description'] as String,
      price: row['price'] as double,
      priceWithExtras: row['priceWithExtras'] as double,
      selectedQuantity: row['selectedQuantity'] as int,
      photoUrl: row['photoUrl'] as String);

  final InsertionAdapter<Product> _productInsertionAdapter;

  final UpdateAdapter<Product> _productUpdateAdapter;

  final DeletionAdapter<Product> _productDeletionAdapter;

  @override
  Future<List<Product>> findAllProducts() async {
    return _queryAdapter.queryList('SELECT * FROM products',
        mapper: _productsMapper);
  }

  @override
  Stream<List<Product>> findAllProductsAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM products',
        queryableName: 'products', isView: false, mapper: _productsMapper);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM products');
  }

  @override
  Future<List<Product>> findAllByVendorWhereNot(int vendorId) async {
    return _queryAdapter.queryList('SELECT * FROM products WHERE vendorId != ?',
        arguments: <dynamic>[vendorId], mapper: _productsMapper);
  }

  @override
  Future<void> deleteAllByVendorWhereNot(int vendorId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM products WHERE vendorId != ?',
        arguments: <dynamic>[vendorId]);
  }

  @override
  Future<void> insertItem(Product item) async {
    await _productInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertItems(List<Product> items) {
    return _productInsertionAdapter.insertListAndReturnIds(
        items, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateItem(Product item) {
    return _productUpdateAdapter.updateAndReturnChangedRows(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateItems(List<Product> items) {
    return _productUpdateAdapter.updateListAndReturnChangedRows(
        items, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteItem(Product item) {
    return _productDeletionAdapter.deleteAndReturnChangedRows(item);
  }

  @override
  Future<int> deleteItems(List<Product> items) {
    return _productDeletionAdapter.deleteListAndReturnChangedRows(items);
  }
}

class _$ProductExtraDao extends ProductExtraDao {
  _$ProductExtraDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _productExtraInsertionAdapter = InsertionAdapter(
            database,
            'product_extras',
            (ProductExtra item) => <String, dynamic>{
                  'id': item.id,
                  'productId': item.productId,
                  'price': item.price,
                  'name': item.name,
                  'photo': item.photo
                },
            changeListener),
        _productExtraUpdateAdapter = UpdateAdapter(
            database,
            'product_extras',
            ['id'],
            (ProductExtra item) => <String, dynamic>{
                  'id': item.id,
                  'productId': item.productId,
                  'price': item.price,
                  'name': item.name,
                  'photo': item.photo
                },
            changeListener),
        _productExtraDeletionAdapter = DeletionAdapter(
            database,
            'product_extras',
            ['id'],
            (ProductExtra item) => <String, dynamic>{
                  'id': item.id,
                  'productId': item.productId,
                  'price': item.price,
                  'name': item.name,
                  'photo': item.photo
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _product_extrasMapper = (Map<String, dynamic> row) =>
      ProductExtra(
          id: row['id'] as int,
          productId: row['productId'] as int,
          price: row['price'] as double,
          name: row['name'] as String,
          photo: row['photo'] as String);

  final InsertionAdapter<ProductExtra> _productExtraInsertionAdapter;

  final UpdateAdapter<ProductExtra> _productExtraUpdateAdapter;

  final DeletionAdapter<ProductExtra> _productExtraDeletionAdapter;

  @override
  Future<List<ProductExtra>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM product_extras',
        mapper: _product_extrasMapper);
  }

  @override
  Future<void> deleteAllByProductId(int productId) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM product_extras WHERE productId = ?',
        arguments: <dynamic>[productId]);
  }

  @override
  Stream<List<ProductExtra>> findAllByProductIdAsStream(int productId) {
    return _queryAdapter.queryListStream(
        'SELECT * FROM product_extras WHERE productId = ?',
        arguments: <dynamic>[productId],
        queryableName: 'product_extras',
        isView: false,
        mapper: _product_extrasMapper);
  }

  @override
  Future<List<ProductExtra>> findAllByProductId(int productId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM product_extras WHERE productId = ?',
        arguments: <dynamic>[productId],
        mapper: _product_extrasMapper);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM product_extras');
  }

  @override
  Future<void> insertItem(ProductExtra item) async {
    await _productExtraInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertItems(List<ProductExtra> items) {
    return _productExtraInsertionAdapter.insertListAndReturnIds(
        items, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateItem(ProductExtra item) {
    return _productExtraUpdateAdapter.updateAndReturnChangedRows(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateItems(List<ProductExtra> items) {
    return _productExtraUpdateAdapter.updateListAndReturnChangedRows(
        items, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteItem(ProductExtra item) {
    return _productExtraDeletionAdapter.deleteAndReturnChangedRows(item);
  }

  @override
  Future<int> deleteItems(List<ProductExtra> items) {
    return _productExtraDeletionAdapter.deleteListAndReturnChangedRows(items);
  }
}

class _$UserDao extends UserDao {
  _$UserDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _userInsertionAdapter = InsertionAdapter(
            database,
            'users',
            (User item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'photo': item.photo,
                  'token': item.token,
                  'tokenType': item.tokenType,
                  'role': item.role
                },
            changeListener),
        _userUpdateAdapter = UpdateAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'photo': item.photo,
                  'token': item.token,
                  'tokenType': item.tokenType,
                  'role': item.role
                },
            changeListener),
        _userDeletionAdapter = DeletionAdapter(
            database,
            'users',
            ['id'],
            (User item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'email': item.email,
                  'phone': item.phone,
                  'photo': item.photo,
                  'token': item.token,
                  'tokenType': item.tokenType,
                  'role': item.role
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _usersMapper = (Map<String, dynamic> row) => User(
      id: row['id'] as int,
      name: row['name'] as String,
      email: row['email'] as String,
      phone: row['phone'] as String,
      photo: row['photo'] as String,
      role: row['role'] as String,
      token: row['token'] as String,
      tokenType: row['tokenType'] as String);

  final InsertionAdapter<User> _userInsertionAdapter;

  final UpdateAdapter<User> _userUpdateAdapter;

  final DeletionAdapter<User> _userDeletionAdapter;

  @override
  Future<User> findCurrent() async {
    return _queryAdapter.query('SELECT * FROM users LIMIT 1',
        mapper: _usersMapper);
  }

  @override
  Stream<User> findCurrentAsStream() {
    return _queryAdapter.queryStream('SELECT * FROM users LIMIT 1',
        queryableName: 'users', isView: false, mapper: _usersMapper);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM users');
  }

  @override
  Future<void> insertItem(User item) async {
    await _userInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertItems(List<User> items) {
    return _userInsertionAdapter.insertListAndReturnIds(
        items, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateItem(User item) {
    return _userUpdateAdapter.updateAndReturnChangedRows(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateItems(List<User> items) {
    return _userUpdateAdapter.updateListAndReturnChangedRows(
        items, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteItem(User item) {
    return _userDeletionAdapter.deleteAndReturnChangedRows(item);
  }

  @override
  Future<int> deleteItems(List<User> items) {
    return _userDeletionAdapter.deleteListAndReturnChangedRows(items);
  }
}

class _$CurrencyDao extends CurrencyDao {
  _$CurrencyDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _currencyInsertionAdapter = InsertionAdapter(
            database,
            'currencies',
            (Currency item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'code': item.code,
                  'symbol': item.symbol
                },
            changeListener),
        _currencyUpdateAdapter = UpdateAdapter(
            database,
            'currencies',
            ['id'],
            (Currency item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'code': item.code,
                  'symbol': item.symbol
                },
            changeListener),
        _currencyDeletionAdapter = DeletionAdapter(
            database,
            'currencies',
            ['id'],
            (Currency item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'code': item.code,
                  'symbol': item.symbol
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _currenciesMapper = (Map<String, dynamic> row) => Currency(
      id: row['id'] as int,
      name: row['name'] as String,
      code: row['code'] as String,
      symbol: row['symbol'] as String);

  final InsertionAdapter<Currency> _currencyInsertionAdapter;

  final UpdateAdapter<Currency> _currencyUpdateAdapter;

  final DeletionAdapter<Currency> _currencyDeletionAdapter;

  @override
  Future<List<Currency>> findAllCurrencys() async {
    return _queryAdapter.queryList('SELECT * FROM currencies',
        mapper: _currenciesMapper);
  }

  @override
  Stream<List<Currency>> findAllCurrenciesAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM currencies',
        queryableName: 'currencies', isView: false, mapper: _currenciesMapper);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM currencies');
  }

  @override
  Future<void> insertItem(Currency item) async {
    await _currencyInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertItems(List<Currency> items) {
    return _currencyInsertionAdapter.insertListAndReturnIds(
        items, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateItem(Currency item) {
    return _currencyUpdateAdapter.updateAndReturnChangedRows(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateItems(List<Currency> items) {
    return _currencyUpdateAdapter.updateListAndReturnChangedRows(
        items, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteItem(Currency item) {
    return _currencyDeletionAdapter.deleteAndReturnChangedRows(item);
  }

  @override
  Future<int> deleteItems(List<Currency> items) {
    return _currencyDeletionAdapter.deleteListAndReturnChangedRows(items);
  }
}

class _$VendorDao extends VendorDao {
  _$VendorDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _vendorInsertionAdapter = InsertionAdapter(
            database,
            'vendors',
            (Vendor item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'slug': item.slug,
                  'address': item.address,
                  'phoneNumber': item.phoneNumber,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'featureImage': item.featureImage,
                  'logo': item.logo,
                  'rating': item.rating,
                  'total_rating_count': item.total_rating_count,
                  'minimumOrder': item.minimumOrder,
                  'deliveryFee': item.deliveryFee,
                  'deliveryRange': item.deliveryRange,
                  'categories': item.categories,
                  'minimumDeliveryTime': item.minimumDeliveryTime,
                  'maxmumDeliveryTime': item.maxmumDeliveryTime
                },
            changeListener),
        _vendorUpdateAdapter = UpdateAdapter(
            database,
            'vendors',
            ['id'],
            (Vendor item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'slug': item.slug,
                  'address': item.address,
                  'phoneNumber': item.phoneNumber,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'featureImage': item.featureImage,
                  'logo': item.logo,
                  'rating': item.rating,
                  'total_rating_count': item.total_rating_count,
                  'minimumOrder': item.minimumOrder,
                  'deliveryFee': item.deliveryFee,
                  'deliveryRange': item.deliveryRange,
                  'categories': item.categories,
                  'minimumDeliveryTime': item.minimumDeliveryTime,
                  'maxmumDeliveryTime': item.maxmumDeliveryTime
                },
            changeListener),
        _vendorDeletionAdapter = DeletionAdapter(
            database,
            'vendors',
            ['id'],
            (Vendor item) => <String, dynamic>{
                  'id': item.id,
                  'name': item.name,
                  'slug': item.slug,
                  'address': item.address,
                  'phoneNumber': item.phoneNumber,
                  'latitude': item.latitude,
                  'longitude': item.longitude,
                  'featureImage': item.featureImage,
                  'logo': item.logo,
                  'rating': item.rating,
                  'total_rating_count': item.total_rating_count,
                  'minimumOrder': item.minimumOrder,
                  'deliveryFee': item.deliveryFee,
                  'deliveryRange': item.deliveryRange,
                  'categories': item.categories,
                  'minimumDeliveryTime': item.minimumDeliveryTime,
                  'maxmumDeliveryTime': item.maxmumDeliveryTime
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _vendorsMapper = (Map<String, dynamic> row) => Vendor(
      id: row['id'] as int,
      name: row['name'] as String,
      slug: row['slug'] as String,
      address: row['address'] as String,
      phoneNumber: row['phoneNumber'] as String,
      latitude: row['latitude'] as String,
      longitude: row['longitude'] as String,
      featureImage: row['featureImage'] as String,
      logo: row['logo'] as String,
      rating: row['rating'] as double,
      total_rating_count: row['total_rating_count'] as int,
      minimumOrder: row['minimumOrder'] as double,
      deliveryFee: row['deliveryFee'] as double,
      categories: row['categories'] as String,
      minimumDeliveryTime: row['minimumDeliveryTime'] as int,
      maxmumDeliveryTime: row['maxmumDeliveryTime'] as int);

  final InsertionAdapter<Vendor> _vendorInsertionAdapter;

  final UpdateAdapter<Vendor> _vendorUpdateAdapter;

  final DeletionAdapter<Vendor> _vendorDeletionAdapter;

  @override
  Future<List<Vendor>> findAllVendors() async {
    return _queryAdapter.queryList('SELECT * FROM vendors',
        mapper: _vendorsMapper);
  }

  @override
  Stream<List<Vendor>> findAllVendorsAsStream() {
    return _queryAdapter.queryListStream('SELECT * FROM vendors',
        queryableName: 'vendors', isView: false, mapper: _vendorsMapper);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM vendors');
  }

  @override
  Future<void> insertItem(Vendor item) async {
    await _vendorInsertionAdapter.insert(item, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertItems(List<Vendor> items) {
    return _vendorInsertionAdapter.insertListAndReturnIds(
        items, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateItem(Vendor item) {
    return _vendorUpdateAdapter.updateAndReturnChangedRows(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateItems(List<Vendor> items) {
    return _vendorUpdateAdapter.updateListAndReturnChangedRows(
        items, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteItem(Vendor item) {
    return _vendorDeletionAdapter.deleteAndReturnChangedRows(item);
  }

  @override
  Future<int> deleteItems(List<Vendor> items) {
    return _vendorDeletionAdapter.deleteListAndReturnChangedRows(items);
  }
}

class _$NotificationDao extends NotificationDao {
  _$NotificationDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database, changeListener),
        _notificationModelInsertionAdapter = InsertionAdapter(
            database,
            'notifications',
            (NotificationModel item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'body': item.body,
                  'timeStamp': item.timeStamp,
                  'read': item.read
                },
            changeListener),
        _notificationModelUpdateAdapter = UpdateAdapter(
            database,
            'notifications',
            ['id'],
            (NotificationModel item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'body': item.body,
                  'timeStamp': item.timeStamp,
                  'read': item.read
                },
            changeListener),
        _notificationModelDeletionAdapter = DeletionAdapter(
            database,
            'notifications',
            ['id'],
            (NotificationModel item) => <String, dynamic>{
                  'id': item.id,
                  'title': item.title,
                  'body': item.body,
                  'timeStamp': item.timeStamp,
                  'read': item.read
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _notificationsMapper = (Map<String, dynamic> row) =>
      NotificationModel(
          id: row['id'] as int,
          title: row['title'] as String,
          body: row['body'] as String,
          timeStamp: row['timeStamp'] as int,
          read: row['read'] as int);

  final InsertionAdapter<NotificationModel> _notificationModelInsertionAdapter;

  final UpdateAdapter<NotificationModel> _notificationModelUpdateAdapter;

  final DeletionAdapter<NotificationModel> _notificationModelDeletionAdapter;

  @override
  Future<List<NotificationModel>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM notifications',
        mapper: _notificationsMapper);
  }

  @override
  Stream<List<NotificationModel>> findAllAsStream() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM notifications ORDER BY timestamp DESC',
        queryableName: 'notifications',
        isView: false,
        mapper: _notificationsMapper);
  }

  @override
  Stream<List<NotificationModel>> findAllUnreadAsStream() {
    return _queryAdapter.queryListStream(
        'SELECT * FROM notifications WHERE read = 0 ORDER BY timestamp DESC',
        queryableName: 'notifications',
        isView: false,
        mapper: _notificationsMapper);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM notifications');
  }

  @override
  Future<void> insertItem(NotificationModel item) async {
    await _notificationModelInsertionAdapter.insert(
        item, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertItems(List<NotificationModel> items) {
    return _notificationModelInsertionAdapter.insertListAndReturnIds(
        items, OnConflictStrategy.replace);
  }

  @override
  Future<int> updateItem(NotificationModel item) {
    return _notificationModelUpdateAdapter.updateAndReturnChangedRows(
        item, OnConflictStrategy.abort);
  }

  @override
  Future<int> updateItems(List<NotificationModel> items) {
    return _notificationModelUpdateAdapter.updateListAndReturnChangedRows(
        items, OnConflictStrategy.replace);
  }

  @override
  Future<int> deleteNotifications(List<NotificationModel> person) {
    return _notificationModelDeletionAdapter
        .deleteListAndReturnChangedRows(person);
  }

  @override
  Future<int> deleteItem(NotificationModel item) {
    return _notificationModelDeletionAdapter.deleteAndReturnChangedRows(item);
  }

  @override
  Future<int> deleteItems(List<NotificationModel> items) {
    return _notificationModelDeletionAdapter
        .deleteListAndReturnChangedRows(items);
  }
}
