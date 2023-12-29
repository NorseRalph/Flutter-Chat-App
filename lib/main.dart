import 'package:chat_app/screens/chat.dart';
import 'package:chat_app/screens/splash.dart';
import 'package:chat_app/screens/auth.dart';
import 'package:chat_app/widgets/theme_notifier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  // Define a base theme data
  final ThemeData baseTheme = ThemeData(
    useMaterial3: true,
    // Define more theme properties if needed
  );

  @override
  Widget build(BuildContext context) {
    // Wrap MaterialApp with ChangeNotifierProvider for theming
    return ChangeNotifierProvider(
      create: (_) => ThemeNotifier(baseTheme),
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: themeNotifier.getTheme(), // Use theme from ThemeNotifier
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (ctx, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return SplashScreen(); // Removed const as SplashScreen might have dynamic content in the future
                }
                if (userSnapshot.hasData) {
                  return ChatScreen(); // If there's a user token, go to the chat screen
                }
                return AuthScreen(); // Otherwise, go to the authentication screen
              },
            ),
          );
        },
      ),
    );
  }
}
