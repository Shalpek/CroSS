import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/app_settings.dart';
import '../providers/connectivity_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();
    final loc = AppLocalizations.of(context)!;
    final isOnline = context.watch<ConnectivityProvider>().isOnline;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settings),
        bottom:
            !isOnline
                ? PreferredSize(
                  preferredSize: const Size.fromHeight(32),
                  child: Container(
                    color: Colors.red,
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    child: const Text(
                      'Нет подключения к интернету',
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
                : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text(loc.darkTheme),
              trailing: Switch(
                value: settings.themeMode == ThemeMode.dark,
                onChanged:
                    (value) => settings.setThemeMode(
                      value ? ThemeMode.dark : ThemeMode.light,
                    ),
                activeColor: Theme.of(context).colorScheme.secondary,
                inactiveThumbColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withAlpha((0.5 * 255).toInt()),
                inactiveTrackColor: Theme.of(
                  context,
                ).colorScheme.onSurface.withAlpha((0.2 * 255).toInt()),
              ),
            ),
            const SizedBox(height: 24),
            ListTile(
              title: Text(loc.language),
              subtitle: Text(_langName(settings.locale.languageCode, loc)),
              onTap: () => _showLanguageDialog(context, loc),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: isOnline ? _onSomeOnlineAction : null,
              child: const Text('Online Action'),
            ),
          ],
        ),
      ),
    );
  }
}

String _langName(String code, AppLocalizations loc) {
  switch (code) {
    case 'kk':
      return loc.kazakh;
    case 'ru':
      return loc.russian;
    default:
      return loc.english;
  }
}

void _showLanguageDialog(BuildContext context, AppLocalizations loc) {
  final settings = context.read<AppSettings>();
  showDialog(
    context: context,
    builder:
        (_) => AlertDialog(
          title: Text(loc.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children:
                ['en', 'ru', 'kk'].map((code) {
                  return RadioListTile<String>(
                    title: Text(
                      code == 'en'
                          ? loc.english
                          : code == 'ru'
                          ? loc.russian
                          : loc.kazakh,
                    ),
                    value: code,
                    groupValue: settings.locale.languageCode,
                    onChanged: (value) {
                      if (value != null) {
                        settings.setLocale(Locale(value));
                        Navigator.pop(context);
                      }
                    },
                  );
                }).toList(),
          ),
        ),
  );
}

void _onSomeOnlineAction() {
  // Implement the action to be performed when online
}
