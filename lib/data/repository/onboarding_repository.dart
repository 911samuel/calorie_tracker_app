import '../../domain/user.dart';
import '../services/shared_prefs_service.dart';

class OnboardingRepository {
  final SharedPrefsService _sharedPrefsService;

  OnboardingRepository(this._sharedPrefsService);

  Future<void> saveUser(User user) async {
    await _sharedPrefsService.saveUser(user);
  }

  Future<User?> loadUser() async {
    return await _sharedPrefsService.loadUser();
  }
}
