import 'package:emvigo_test/core/constants/urls.dart';
import 'package:emvigo_test/core/utils/app_data.dart';
import 'package:emvigo_test/data/local/prefs.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

final sl = GetIt.instance;

AppData get appData => sl<AppData>();
Logger get logger => sl<Logger>();
Urls get urls => sl<Urls>();
Prefs get prefs => sl<Prefs>();
