import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_tasks/model/model.dart';
import 'package:google_tasks/util/util.dart';

import 'app.dart';
import 'model/notifier/notifier.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final originalFlutterError = FlutterError.onError;
  FlutterError.onError = (error) {
    originalFlutterError(error);
    Crashlytics.instance.recordFlutterError(error);
  };
  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: AppNavigator()),
        RouteObserverProvider(),
        Provider.value(value: Authenticator()),
        StreamProvider<FirebaseUser>(
          builder: (context) =>
              Provider.of<Authenticator>(context, listen: false)
                  .onAuthStateChanged
                  .distinct((a, b) => a?.uid == b?.uid),
        ),
        Provider.value(value: UserObserver()),
        ChangeNotifierProvider<AccountNotifier>(
          builder: (context) => AccountNotifier(
            authenticator: Provider.of(context, listen: false),
            userObserver: Provider.of(context, listen: false),
          ),
        ),
      ],
      child: const App(),
    ),
  );
}
