import 'package:emvigo_test/core/base/base_data/base_urls.dart';
import 'package:emvigo_test/core/constants/urls.dart';
import 'package:emvigo_test/core/enums/flavors.dart';
import 'package:emvigo_test/core/network/app_services.dart';
import 'package:emvigo_test/core/styles/app_theme.dart';
import 'package:emvigo_test/core/utils/app_data.dart';
import 'package:emvigo_test/data/local/prefs.dart';
import 'package:emvigo_test/data/repo/auth_repo.dart';
import 'package:emvigo_test/data/repo_impl/auth_repo_impl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

Future<void> initInjections(Flavors flavor) async {
  final sl = GetIt.instance;

  sl.registerSingleton<Prefs>(Prefs());
  await sl<Prefs>().init();
  sl<Prefs>().setFlavor(flavor.name);

  sl.registerSingleton<AppData>(AppData(flavor: flavor));
  sl.registerSingleton<Logger>(Logger());
  sl.registerSingleton<Urls>(Urls(getBaseUrls(flavor)));
  sl.registerSingleton<AppTheme>(AppTheme());
  sl.registerLazySingleton<AppServices>(() => AppServices());

  // Register repos here using registerLazySingleton
  sl.registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance);
  sl.registerLazySingleton<AuthRepo>(() => AuthRepoImpl(sl()));
}
