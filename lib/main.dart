// lib/main.dartn
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // этот файл сгенерирует команда flutterfire

import 'models/app_settings.dart';
import 'theme.dart';
import 'pages/sessions_page.dart';
import 'pages/map_page.dart';
import 'pages/settings_page.dart'; // создадим далее
import 'providers/auth_provider.dart';

import 'providers/session_provider.dart';

import 'providers/connectivity_provider.dart';
import 'pages/loading_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/profile_page.dart';
import 'pages/create_session_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppSettings()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ConnectivityProvider()),
        ChangeNotifierProvider(create: (_) => SessionProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer2<AppSettings, AuthProvider>(
      builder:
          (context, settings, auth, _) => AnimatedTheme(
            data:
                settings.themeMode == ThemeMode.dark ? kDarkTheme : kLightTheme,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: kLightTheme,
              darkTheme: kDarkTheme,
              themeMode: settings.themeMode,
              locale: settings.locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              routes: {
                '/login': (_) => LoginPage(),
                '/register': (_) => RegisterPage(),
                '/profile': (_) => ProfilePage(),
                '/create_session': (_) => const CreateSessionPage(),
              },
              home:
                  auth.isLoading
                      ? const LoadingPage()
                      : auth.user == null
                      ? LoginPage()
                      : const MainScreen(),
            ),
          ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext c) {
    final auth = context.watch<AuthProvider>();
    final colorScheme = Theme.of(c).colorScheme;
    final isGuest = auth.user == null || auth.user?.email == null;
    final pages =
        isGuest
            ? [const SessionsPage(), const MapPage()]
            : [
              const ProfilePage(),
              const SessionsPage(),
              const MapPage(),
              const SettingsPage(),
            ];
    final items =
        isGuest
            ? const [
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule),
                label: 'Sessions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: 'Map',
              ),
            ]
            : const [
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Account',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.schedule),
                label: 'Sessions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.map_outlined),
                label: 'Map',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.settings_outlined),
                label: 'Settings',
              ),
            ];
    final safeIndex = _currentIndex.clamp(0, pages.length - 1);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive: если ширина большая — показываем боковую навигацию
        if (constraints.maxWidth > 700) {
          return Row(
            children: [
              NavigationRail(
                selectedIndex: safeIndex,
                onDestinationSelected: (i) => setState(() => _currentIndex = i),
                labelType: NavigationRailLabelType.all,
                destinations:
                    items
                        .map(
                          (item) => NavigationRailDestination(
                            icon: item.icon,
                            label: Text(item.label ?? ''),
                          ),
                        )
                        .toList(),
              ),
              const VerticalDivider(width: 1),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: pages[safeIndex],
                ),
              ),
            ],
          );
        } else {
          return Scaffold(
            body: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: pages[safeIndex],
            ),
            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: colorScheme.surface,
              selectedItemColor: colorScheme.secondary,
              unselectedItemColor: colorScheme.onSurface.withAlpha(
                (0.6 * 255).toInt(),
              ),
              currentIndex: safeIndex,
              onTap: (i) => setState(() => _currentIndex = i),
              items: items,
              type: BottomNavigationBarType.fixed,
            ),
          );
        }
      },
    );
  }
}
