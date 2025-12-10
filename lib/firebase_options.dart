import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    throw UnsupportedError('Not supported on this platform yet');
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCgPfxbAMDRftQqNiL4gLvKdiNqaJNb0Ps',          // ← your apiKey
    appId: '1:1013683707890:web:123d883bb171eacea4d56b',               // ← your appId
    messagingSenderId: '1013683707890',                          // ← your messagingSenderId
    projectId: 'character-ai-clone-b94af',                    // ← your projectId
    authDomain: 'character-ai-clone-b94af.firebaseapp.com',   // ← your authDomain
    storageBucket: 'character-ai-clone-b94af.firebasestorage.app',    // ← your storageBucket
  );
}