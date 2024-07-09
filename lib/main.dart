import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'connectivity_service.dart';
import 'home_screen.dart';
import 'sign_in.dart';
import 'sign_up.dart';
import 'theme_provider.dart';
import 'authentication_service.dart';
import 'app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  ConnectivityService.instance.initialize();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        Provider(create: (_) => AuthenticationService()),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Calculator',
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: themeProvider.themeMode,
            locale: _locale ?? Locale('en'), // Default locale
            supportedLocales: const [
              Locale('en'),
              Locale('fr'),
            ],
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            home: const HomeScreen(),
            routes: {
              '/signin': (context) =>  SignIn(),
              '/signup': (context) =>  SignUp(),
            },
            scaffoldMessengerKey: ConnectivityService.instance.scaffoldMessengerKey,
          );
        },
      ),
    );
  }
}
