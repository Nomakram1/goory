import 'package:foodie/bloc/base.bloc.dart';
import 'package:foodie/data/models/notification_model.dart';

class NotificationsBloc extends BaseBloc {
  //BehaviorSubject stream getters
  Stream<List<NotificationModel>> get notifications =>
      appDatabase.notificationDao.findAllAsStream();
}
