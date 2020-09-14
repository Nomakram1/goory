import 'package:foodie/bloc/base.bloc.dart';
import 'package:foodie/data/models/user.dart';
import 'package:foodie/data/repositories/auth.repository.dart';
import 'package:rxdart/rxdart.dart';

class ProfileBloc extends BaseBloc {
  //AuthRepository
  AuthRepository _authRepository = AuthRepository();
  //view entered data
  BehaviorSubject<User> _user = BehaviorSubject<User>();

  //entered data variables getter
  Stream<User> get user => _user.stream;

  Future<void> logout() async {
    await _authRepository.logout();
  }
}
