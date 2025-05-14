import 'package:flutter/services.dart';
import 'package:selleri/firebase_options.dart' as firebase_option;
import 'package:selleri/firebase_options_dev.dart' as firebase_option_dev;
import 'package:selleri/firebase_options_stage.dart' as firebase_option_stage;
import 'package:firebase_core/firebase_core.dart';

class FirebaseHelper {
  Future<void> init() async {
    var firebaseOptions =
        firebase_option.DefaultFirebaseOptions.currentPlatform;
    if (appFlavor == 'stage') {
      firebaseOptions =
          firebase_option_stage.DefaultFirebaseOptions.currentPlatform;
    } else if (appFlavor == 'dev') {
      firebaseOptions =
          firebase_option_dev.DefaultFirebaseOptions.currentPlatform;
    }

    await Firebase.initializeApp(
      name: 'selleri-$appFlavor',
      options: firebaseOptions,
    );
  }
}
