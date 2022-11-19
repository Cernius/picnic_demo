import 'package:flutter_demo/core/domain/model/user.dart';
import 'package:flutter_demo/features/auth/domain/model/log_in_failure.dart';
import 'package:flutter_demo/features/auth/login/login_initial_params.dart';
import 'package:flutter_demo/features/auth/login/login_presentation_model.dart';
import 'package:flutter_demo/features/auth/login/login_presenter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import '../../../test_utils/test_utils.dart';
import '../mocks/auth_mock_definitions.dart';
import '../mocks/auth_mocks.dart';

void main() {
  late LoginPresentationModel model;
  late LoginPresenter presenter;
  late MockLoginNavigator navigator;

  test(
    'should show error when loginUC fails',
    () async {
      // GIVEN
      when(
        () => AuthMocks.logInUseCase.execute(
          username: any(
            named: "username",
          ),
          password: any(
            named: "password",
          ),
        ),
      ).thenAnswer(
        (_) => failFuture(
          const LogInFailure.unknown(),
        ),
      );
      when(() => navigator.showError(any())).thenAnswer((_) => Future.value());

      // WHEN
      await presenter.login();

      // THEN
      verify(() => navigator.showError(any()));
    },
  );
  test(
    'should show success alert when loginUC succeeds',
    () async {
      // GIVEN
      when(
        () => AuthMocks.logInUseCase.execute(
          username: any(
            named: "username",
          ),
          password: any(
            named: "password",
          ),
        ),
      ).thenAnswer(
        (_) => successFuture(const User(id: "0", username: '')),
      );
      when(
        () => navigator.showAlert(
          message: any(named: "message"),
          title: any(
            named: "title",
          ),
        ),
      ).thenAnswer((_) => Future.value());

      // WHEN
      await presenter.login();

      // THEN
      verify(
        () => navigator.showAlert(
          message: any(named: "message"),
          title: any(
            named: "title",
          ),
        ),
      );
    },
  );

  setUp(() {
    model = LoginPresentationModel.initial(const LoginInitialParams());
    navigator = MockLoginNavigator();
    presenter = LoginPresenter(
      model,
      navigator,
      AuthMocks.logInUseCase,
    );
  });
}
