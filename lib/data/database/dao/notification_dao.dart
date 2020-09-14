import 'package:floor/floor.dart';
import 'package:foodie/data/database/dao/abstract_dao.dart';
import 'package:foodie/data/models/notification_model.dart';

@dao
abstract class NotificationDao extends AbstractDao<NotificationModel> {
  @Query('SELECT * FROM notifications')
  Future<List<NotificationModel>> findAll();

  @Query('SELECT * FROM notifications ORDER BY timestamp DESC')
  Stream<List<NotificationModel>> findAllAsStream();

  @Query('SELECT * FROM notifications WHERE read = 0 ORDER BY timestamp DESC')
  Stream<List<NotificationModel>> findAllUnreadAsStream();

  @Query('DELETE FROM notifications')
  Future<void> deleteAll();

  @delete
  Future<int> deleteNotifications(List<NotificationModel> person);
}
