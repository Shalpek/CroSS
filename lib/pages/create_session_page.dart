import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../models/session.dart';
import '../providers/session_provider.dart';

class CreateSessionPage extends StatefulWidget {
  const CreateSessionPage({super.key});

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  DateTime? _date;
  TimeOfDay? _time;
  String _language = 'ru';
  bool _vipOnly = false;
  // Для карты: координаты маркера (заглушка)
  double? _lat;
  double? _lng;
  File? _imageFile;

  bool get _isValid =>
      _formKey.currentState?.validate() == true &&
      _date != null &&
      _time != null &&
      _lat != null &&
      _lng != null;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _time ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _time = picked);
  }

  void _pickLocation() async {
    // Здесь должен быть GoogleMap, но для примера — просто фиксированные координаты
    setState(() {
      _lat = 51.1694;
      _lng = 71.4491;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Местоположение выбрано (заглушка)')),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  void _submit() {
    if (!_isValid) return;
    final session = Session(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      dateTime: DateTime(
        _date!.year,
        _date!.month,
        _date!.day,
        _time!.hour,
        _time!.minute,
      ),
      language: _language,
      vipOnly: _vipOnly,
      lat: _lat!,
      lng: _lng!,
      imagePath: _imageFile?.path,
    );
    context.read<SessionProvider>().addSession(session);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Создать сессию')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Название'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Введите название' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descCtrl,
                decoration: const InputDecoration(labelText: 'Описание'),
                validator:
                    (v) => v == null || v.isEmpty ? 'Введите описание' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickDate,
                      child: Text(
                        _date == null
                            ? 'Выбрать дату'
                            : '${_date!.day}.${_date!.month}.${_date!.year}',
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickTime,
                      child: Text(
                        _time == null ? 'Время' : _time!.format(context),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _language,
                items: const [
                  DropdownMenuItem(value: 'ru', child: Text('Русский')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'kk', child: Text('Қазақша')),
                ],
                onChanged: (v) => setState(() => _language = v ?? 'ru'),
                decoration: const InputDecoration(labelText: 'Язык'),
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                value: _vipOnly,
                onChanged: (v) => setState(() => _vipOnly = v),
                title: const Text('Только для VIP'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _pickLocation,
                child: Text(_lat == null ? 'Выбрать место' : 'Место выбрано'),
              ),
              const SizedBox(height: 12),
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.file(
                      _imageFile!,
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              OutlinedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo),
                label: Text(
                  _imageFile == null
                      ? 'Прикрепить изображение'
                      : 'Изображение выбрано',
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isValid ? _submit : null,
                child: const Text('Создать'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
