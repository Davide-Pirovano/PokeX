import 'package:pokex/data/auth_data_source.dart';

class AuthRepo {
  final AuthDataSource _authDataSource = AuthDataSource();

  // sign in email and password
  Future<void> signInWithEmailPassword(String email, String password) async {
    await _authDataSource.signInWithEmailPassword(email, password);
  }

  // sign up email and password
  Future<void> signUpWithEmailPassword(String email, String password) async {
    await _authDataSource.signUpWithEmailPassword(email, password);
  }

  // sign out
  Future<void> signOut() async {
    await _authDataSource.signOut();
  }

  // get user email
  String? getCurrentUserEmail() {
    return _authDataSource.getCurrentUserEmail();
  }
}
