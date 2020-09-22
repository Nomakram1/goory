import 'package:Doory/bloc/base.bloc.dart';
import 'package:Doory/data/models/order.dart';
import 'package:Doory/data/repositories/order.repository.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart';

class OrdersBloc extends BaseBloc {
  //delivery address repository
  OrderRepository _ordersRepository = OrderRepository();
  int queryPage = 1;

  //BehaviorSubjects
  BehaviorSubject<List<Order>> _orders = BehaviorSubject<List<Order>>();

  //BehaviorSubject stream getters
  Stream<List<Order>> get orders => _orders.stream;

  RefreshController refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initBloc() {
    super.initBloc();
    fetchOrders();
  }

  @override
  void dispose() {
    super.dispose();
    _orders.close();
  }

  void fetchOrders({
    bool initialLoading = true,
  }) async {
    if (initialLoading) {
      _orders.add(null);
      queryPage = 1;
      refreshController.resetNoData();
    } else {
      queryPage++;
    }

    try {
      final mOrders = await _ordersRepository.myOrders(
        page: queryPage,
      );

      if (initialLoading) {
        //prevent pull to load more
        if (mOrders.length == 0) {
          print("No More data");
          refreshController.loadNoData();
        } else {
          refreshController.refreshCompleted();
        }
        _orders.add(mOrders);
      } else {
        //prevent pull to load more
        if (mOrders.length == 0) {
          print("No More data");
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }

        mOrders.insertAll(0, _orders.value);
        _orders.add(mOrders);
      }
    } catch (error) {
      print("Orders error ==> $error");
      _orders.addError(error);
    }
  }
}
