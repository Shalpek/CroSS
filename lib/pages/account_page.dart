// lib/pages/account_page.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext c) => Scaffold(
    body: Center(
      child: ElevatedButton(
        onPressed: () => _showLoginPhone(c),
        child: Text('Login'),
      ),
    ),
  );

  void _showLoginPhone(BuildContext c) {
    final colorScheme = Theme.of(c).colorScheme;
    showDialog(
      context: c,
      builder:
          (_) => Dialog(
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Login', style: Theme.of(c).textTheme.titleLarge),
                  SizedBox(height: 4),
                  Text(
                    'Access to purchased tickets',
                    style: Theme.of(c).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(
                        (0.7 * 255).toInt(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(hintText: 'Phone number'),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(c);
                      _showLoginCode(c);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      foregroundColor: colorScheme.onSurface, // <-- исправлено!
                    ),
                    child: Center(child: Text('Continue')),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showLoginCode(BuildContext c) {
    final colorScheme = Theme.of(c).colorScheme;
    showDialog(
      context: c,
      builder:
          (_) => Dialog(
            backgroundColor: colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Login', style: Theme.of(c).textTheme.titleLarge),
                  SizedBox(height: 4),
                  Text(
                    'Enter the password from the SMS',
                    style: Theme.of(c).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface.withAlpha(
                        (0.7 * 255).toInt(),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      4,
                      (_) => SizedBox(
                        width: 50,
                        height: 50,
                        child: TextField(
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            color: colorScheme.onSurface,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          decoration: InputDecoration(
                            counterText: '',
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: colorScheme.onSurface.withAlpha(
                                  (0.2 * 255).toInt(),
                                ),
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: colorScheme.secondary,
                              ),
                            ),
                          ),
                          maxLength: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(c);
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 48),
                      foregroundColor: colorScheme.onSurface, // <-- исправлено!
                    ),
                    child: Center(child: Text('Login')),
                  ),
                  SizedBox(height: 8),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(c);
                      _showLoginPhone(c);
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.secondary, // <-- цвет текста
                    ),
                    child: Text('Change number'),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: colorScheme.secondary, // <-- цвет текста
                    ),
                    child: Text('Resend (0:59)'),
                  ),
                ],
              ),
            ),
          ),
    );
  }
}
