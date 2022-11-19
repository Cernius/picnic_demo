import 'package:bloc/bloc.dart';
import 'package:flutter_demo/features/auth/login/login_navigator.dart';
import 'package:flutter_demo/features/auth/login/login_presentation_model.dart';

class LoginPresenter extends Cubit<LoginViewModel> {
  LoginPresenter(
    LoginPresentationModel super.model,
    this.navigator,
  );

  final LoginNavigator navigator;

  LoginPresentationModel get _model => state as LoginPresentationModel;

  void alternateUsernameText(String text) {
    emit(
      _model.copyWith(
        username: text,
        isLoginEnabled: _model.password.isNotEmpty && text.isNotEmpty,
      ),
    );
  }

  void alternatePasswordText(String text) {
    emit(
      _model.copyWith(
        password: text,
        isLoginEnabled: text.isNotEmpty && _model.username.isNotEmpty,
      ),
    );
  }

  void login() {

  }
}
