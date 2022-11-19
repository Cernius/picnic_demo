import 'package:bloc/bloc.dart';
import 'package:flutter_demo/core/utils/bloc_extensions.dart';
import 'package:flutter_demo/core/utils/either_extensions.dart';
import 'package:flutter_demo/features/auth/domain/use_cases/log_in_use_case.dart';
import 'package:flutter_demo/features/auth/login/login_navigator.dart';
import 'package:flutter_demo/features/auth/login/login_presentation_model.dart';

class LoginPresenter extends Cubit<LoginViewModel> {
  LoginPresenter(
    LoginPresentationModel super.model,
    this.navigator,
    this.logInUseCase,
  );

  final LoginNavigator navigator;
  final LogInUseCase logInUseCase;

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

  Future<void> login({String? username, String? pw}) async {
    await await logInUseCase
        .execute(
          username: username ?? _model.username,
          password: pw ?? _model.password,
        )
        .observeStatusChanges(
          (result) => emit(_model.copyWith(loginUCResult: result)),
        )
        .asyncFold(
          (fail) => navigator.showError(fail.displayableFailure()),
          (success) => navigator.showAlert(
            title: "Congratulations",
            message: "You managed to log in successfully",
          ),
        );
  }
}
