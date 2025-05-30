// lib/pages/sessions_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'session_detail_page.dart';
import '../providers/session_provider.dart';

class SessionsPage extends StatefulWidget {
  const SessionsPage({super.key});

  @override
  State<SessionsPage> createState() => _SessionsPageState();
}

class _SessionsPageState extends State<SessionsPage> {
  String _search = '';
  DateTime? _selectedDate;
  String _city = '';
  double _minPrice = 0;
  double _maxPrice = 10000;
  TimeOfDay? _selectedTime;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    // Загрузка сессий из Firestore при первом запуске
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SessionProvider>().loadSessions();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final sessions = context.watch<SessionProvider>().sessions;
    final filtered =
        sessions.where((s) {
          final matchesName = s.name.toLowerCase().contains(
            _search.toLowerCase(),
          );
          final matchesDate =
              _selectedDate == null ||
              (s.dateTime.year == _selectedDate!.year &&
                  s.dateTime.month == _selectedDate!.month &&
                  s.dateTime.day == _selectedDate!.day);
          final matchesCity = _city.isEmpty || s.city == _city;
          final matchesPrice = s.price >= _minPrice && s.price <= _maxPrice;
          final matchesTime =
              _selectedTime == null ||
              (s.dateTime.hour == _selectedTime!.hour &&
                  s.dateTime.minute == _selectedTime!.minute);
          return matchesName &&
              matchesDate &&
              matchesCity &&
              matchesPrice &&
              matchesTime;
        }).toList();

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
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Поиск...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (v) => setState(() => _search = v),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _showFilters ? Icons.filter_alt : Icons.filter_alt_outlined,
                  ),
                  onPressed: () => setState(() => _showFilters = !_showFilters),
                ),
              ],
            ),
          ),
          // фильтр по дате и городу
          if (_showFilters)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DropdownButton<String>(
                              value: _city.isEmpty ? null : _city,
                              hint: const Text('Город'),
                              items: const [
                                DropdownMenuItem(
                                  value: '',
                                  child: Text('Все города'),
                                ),
                                DropdownMenuItem(
                                  value: 'Astana',
                                  child: Text('Astana'),
                                ),
                                DropdownMenuItem(
                                  value: 'Almaty',
                                  child: Text('Almaty'),
                                ),
                                DropdownMenuItem(
                                  value: 'Karaganda',
                                  child: Text('Karaganda'),
                                ),
                              ],
                              onChanged: (v) => setState(() => _city = v ?? ''),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final now = DateTime.now();
                                final picked = await showDatePicker(
                                  context: context,
                                  initialDate: _selectedDate ?? now,
                                  firstDate: DateTime(now.year - 1),
                                  lastDate: DateTime(now.year + 2),
                                );
                                if (picked != null)
                                  setState(() => _selectedDate = picked);
                              },
                              child: Text(
                                _selectedDate == null
                                    ? 'Любая дата'
                                    : '${_selectedDate!.day.toString().padLeft(2, '0')}.${_selectedDate!.month.toString().padLeft(2, '0')}.${_selectedDate!.year}',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final picked = await showTimePicker(
                                  context: context,
                                  initialTime: _selectedTime ?? TimeOfDay.now(),
                                );
                                if (picked != null)
                                  setState(() => _selectedTime = picked);
                              },
                              child: Text(
                                _selectedTime == null
                                    ? 'Любое время'
                                    : _selectedTime!.format(context),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Row(
                              children: [
                                const Text('Цена:'),
                                Expanded(
                                  child: Slider(
                                    min: 0,
                                    max: 10000,
                                    divisions: 100,
                                    value: _minPrice,
                                    label: 'от ${_minPrice.toInt()}₸',
                                    onChanged:
                                        (v) => setState(() => _minPrice = v),
                                  ),
                                ),
                                Expanded(
                                  child: Slider(
                                    min: 0,
                                    max: 10000,
                                    divisions: 100,
                                    value: _maxPrice,
                                    label: 'до ${_maxPrice.toInt()}₸',
                                    onChanged:
                                        (v) => setState(() => _maxPrice = v),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _city = '';
                                _selectedDate = null;
                                _selectedTime = null;
                                _minPrice = 0;
                                _maxPrice = 10000;
                              });
                            },
                            child: const Text('Сбросить'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Divider(color: Theme.of(context).dividerColor),
          // список
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: filtered.length,
              separatorBuilder:
                  (_, __) => Divider(color: Theme.of(context).dividerColor),
              itemBuilder: (context, i) {
                final session = filtered[i];
                return ListTile(
                  title: Text(session.name, style: textTheme.bodyLarge),
                  subtitle: Text(
                    session.city.isNotEmpty
                        ? '${session.description}\nГород: ${session.city}'
                        : session.description,
                  ),
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
          await Navigator.pushNamed(context, '/create_session');
        },
        icon: const Icon(Icons.add),
        label: const Text('Создать'),
      ),
    );
  }
}
