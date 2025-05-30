import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/session_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  DateTime? _birthDate;
  final _descCtrl = TextEditingController();
  List<String> _interests = [];
  final List<String> _interestOptions = ['Спорт', 'Музыка', 'Игры', 'Другое'];

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      _firstNameCtrl.text = user.firstName ?? '';
      _lastNameCtrl.text = user.lastName ?? '';
      _birthDate = user.birthDate;
      _descCtrl.text = user.description ?? '';
      _interests = List<String>.from(user.interests ?? []);
    }
  }

  void _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _birthDate ?? DateTime(now.year - 18),
      firstDate: DateTime(1900),
      lastDate: now,
    );
    if (picked != null) setState(() => _birthDate = picked);
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final auth = context.read<AuthProvider>();
    final user = auth.user;
    if (user != null) {
      user.firstName = _firstNameCtrl.text.trim();
      user.lastName = _lastNameCtrl.text.trim();
      user.birthDate = _birthDate;
      user.description = _descCtrl.text.trim();
      user.interests = List<String>.from(_interests);
      // Обновить имя/фамилию во всех сессиях, где пользователь — участник
      context.read<SessionProvider>().updateParticipantNames(
        user.uid,
        user.firstName ?? '',
        user.lastName ?? '',
      );
      setState(() {});
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Профиль сохранён')));
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Email: ${auth.user?.email ?? "Guest"}'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _firstNameCtrl,
                    decoration: const InputDecoration(labelText: 'Имя'),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Введите имя';
                      if (!RegExp(
                        r'^[a-zA-Zа-яА-ЯёЁ]+(?: [a-zA-Zа-яА-ЯёЁ]+)* $',
                      ).hasMatch(v + '\u0000')) {
                        return 'Только буквы';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Zа-яА-ЯёЁ ]'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _lastNameCtrl,
                    decoration: const InputDecoration(labelText: 'Фамилия'),
                    validator: (v) {
                      if (v == null || v.isEmpty) return 'Введите фамилию';
                      if (!RegExp(
                        r'^[a-zA-Zа-яА-ЯёЁ]+(?: [a-zA-Zа-яА-ЯёЁ]+)*\u0000$',
                      ).hasMatch(v + '\u0000')) {
                        return 'Только буквы';
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'[a-zA-Zа-яА-ЯёЁ ]'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _pickBirthDate,
                          child: Text(
                            _birthDate == null
                                ? 'Дата рождения'
                                : '${_birthDate!.day.toString().padLeft(2, '0')}.${_birthDate!.month.toString().padLeft(2, '0')}.${_birthDate!.year}',
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.onSurface.withOpacity(0.85),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(labelText: 'Описание'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Интересы:',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Wrap(
                    spacing: 8,
                    children:
                        _interestOptions
                            .map(
                              (interest) => FilterChip(
                                label: Text(interest),
                                selected: _interests.contains(interest),
                                onSelected: (selected) {
                                  setState(() {
                                    if (selected) {
                                      _interests.add(interest);
                                    } else {
                                      _interests.remove(interest);
                                    }
                                  });
                                },
                              ),
                            )
                            .toList(),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: _save,
                    child: const Text('Сохранить'),
                  ),
                  const SizedBox(height: 20),
                  if (auth.user != null)
                    ElevatedButton(
                      onPressed:
                          () => context.read<AuthProvider>().logout(context),
                      child: const Text('Выйти'),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
