import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emvigo_test/app.dart';
import 'package:emvigo_test/core/base/base_bloc/bloc_observer.dart';
import 'package:emvigo_test/core/enums/flavors.dart';
import 'package:emvigo_test/dependencies/dependencies.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() => runFlavor(Flavors.dev);

Future<void> runFlavor(Flavors flavor) async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const MyBlocObserver();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initInjections(flavor);
  runApp(const App());
}
