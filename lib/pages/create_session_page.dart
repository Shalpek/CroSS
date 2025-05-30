import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
  String _city = 'Astana';
  double _price = 0;
  LatLng? _pickedLatLng;

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
    final LatLng? result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => _MapPickerPage(initial: _pickedLatLng)),
    );
    if (result != null) {
      setState(() {
        _pickedLatLng = result;
        _lat = result.latitude;
        _lng = result.longitude;
      });
    }
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
      city: _city,
      price: _price,
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
                        style: TextStyle(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withOpacity(0.85),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _pickTime,
                      child: Text(
                        _time == null ? 'Время' : _time!.format(context),
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
                child: Text(
                  _pickedLatLng == null
                      ? 'Выбрать место на карте'
                      : 'Место выбрано',
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.85),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _city,
                items: const [
                  DropdownMenuItem(value: 'Astana', child: Text('Astana')),
                  DropdownMenuItem(value: 'Almaty', child: Text('Almaty')),
                  DropdownMenuItem(
                    value: 'Karaganda',
                    child: Text('Karaganda'),
                  ),
                ],
                onChanged: (v) => setState(() => _city = v ?? 'Astana'),
                decoration: const InputDecoration(labelText: 'Город'),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _price == 0 ? '' : _price.toString(),
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Цена (KZT)'),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Введите цену';
                  final n = double.tryParse(v);
                  if (n == null || n < 0) return 'Некорректная цена';
                  return null;
                },
                onChanged:
                    (v) => setState(() => _price = double.tryParse(v) ?? 0),
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
                  style: TextStyle(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withOpacity(0.85),
                  ),
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

class _MapPickerPage extends StatefulWidget {
  final LatLng? initial;
  const _MapPickerPage({this.initial});
  @override
  State<_MapPickerPage> createState() => _MapPickerPageState();
}

class _MapPickerPageState extends State<_MapPickerPage> {
  LatLng? _selected;
  @override
  void initState() {
    super.initState();
    _selected = widget.initial ?? const LatLng(51.1694, 71.4491);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Выберите место')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(target: _selected!, zoom: 12),
        markers: {
          Marker(
            markerId: const MarkerId('picked'),
            position: _selected!,
            draggable: true,
            onDragEnd: (pos) => setState(() => _selected = pos),
          ),
        },
        onTap: (pos) => setState(() => _selected = pos),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pop(context, _selected),
        label: const Text('Выбрать'),
        icon: const Icon(Icons.check),
      ),
    );
  }
}
