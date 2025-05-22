// lib/pages/sessions_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/modals.dart';
import 'session_detail_page.dart';
import '../providers/session_provider.dart';
import '../models/session.dart';

class SessionsPage extends StatelessWidget {
  const SessionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final sessions = context.watch<SessionProvider>().sessions;

    return Scaffold(
      appBar: AppBar(
        leading: const Padding(
          padding: EdgeInsets.all(8),
          child: CircleAvatar(backgroundColor: Colors.transparent),
        ),
        title: const Text('Активность'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.location_on, color: colorScheme.onSurface),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // фильтр
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                GestureDetector(
                  onTap:
                      () => showCitySelector(context, [
                        'Almaty',
                        'Astana',
                        'Karaganda',
                      ], 'Astana'),
                  child: Row(
                    children: [
                      Icon(Icons.calendar_today, color: colorScheme.onSurface),
                      const SizedBox(width: 8),
                      Text(
                        'April, 7',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => showSortModal(context),
                  child: Row(
                    children: [
                      Icon(Icons.sort, color: colorScheme.onSurface),
                      const SizedBox(width: 8),
                      Text(
                        'Time ↑',
                        style: textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Switch(value: false, onChanged: (_) {}),
              ],
            ),
          ),
          // хедер для колонок
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Time',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Adult',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Child',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'Student',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  'VIP',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ),
          Divider(color: Theme.of(context).dividerColor),
          // список
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: sessions.length,
              separatorBuilder:
                  (_, __) => Divider(color: Theme.of(context).dividerColor),
              itemBuilder: (context, i) {
                final session = sessions[i];
                return ListTile(
                  title: Text(session.name, style: textTheme.bodyLarge),
                  subtitle: Text(session.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SessionDetailPage(session: session),
                      ),
                    );
                  },
                  trailing: const Icon(Icons.chevron_right),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.pushNamed(context, '/create_session');
          // Здесь можно обработать результат создания сессии
        },
        icon: const Icon(Icons.add),
        label: const Text('Создать'),
      ),
    );
  }
}
