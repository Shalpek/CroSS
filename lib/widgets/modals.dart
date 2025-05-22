// lib/widgets/modals.dart
import 'package:flutter/material.dart';

Future<String?> showCitySelector(
  BuildContext c,
  List<String> cities,
  String selected,
) {
  final colorScheme = Theme.of(c).colorScheme;
  return showModalBottomSheet<String>(
    context: c,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder:
        (_) => DraggableScrollableSheet(
          initialChildSize: 0.6,
          builder:
              (_, ctl) => Container(
                decoration: BoxDecoration(
                  color: colorScheme.surface,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Theme.of(c).iconTheme.color,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.separated(
                        itemCount: cities.length,
                        separatorBuilder:
                            (_, i) => Divider(color: Theme.of(c).dividerColor),
                        itemBuilder: (_, i) {
                          final name = cities[i];
                          return ListTile(
                            title: Text(
                              name,
                              style: Theme.of(c).textTheme.bodyLarge,
                            ),
                            trailing:
                                name == selected
                                    ? Icon(
                                      Icons.check,
                                      color: Theme.of(c).colorScheme.secondary,
                                    )
                                    : null,
                            onTap: () => Navigator.pop(c, name),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
        ),
  );
}

Future<void> showSortModal(BuildContext c) {
  final colorScheme = Theme.of(c).colorScheme;
  String sortBy = 'Time';
  String order = 'Ascending';
  return showModalBottomSheet(
    context: c,
    backgroundColor: colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder:
        (_) => Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Sort by', style: Theme.of(c).textTheme.bodyMedium),
              ),
              ...['Time', 'Distance', 'Price'].map(
                (o) => ListTile(
                  title: Text(o),
                  leading:
                      sortBy == o
                          ? Icon(Icons.check, color: colorScheme.secondary)
                          : null,
                  onTap: () => sortBy = o,
                ),
              ),
              SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Order', style: Theme.of(c).textTheme.bodyMedium),
              ),
              ...['Ascending', 'Descending'].map(
                (o) => ListTile(
                  title: Row(
                    children: [
                      Text(o),
                      if (o == 'Ascending')
                        Icon(
                          Icons.arrow_upward,
                          size: 16,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                      if (o == 'Descending')
                        Icon(
                          Icons.arrow_downward,
                          size: 16,
                          color: colorScheme.onSurface.withOpacity(0.7),
                        ),
                    ],
                  ),
                  leading:
                      order == o
                          ? Icon(Icons.check, color: colorScheme.secondary)
                          : null,
                  onTap: () => order = o,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(c),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 48),
                ),
                child: Center(child: Text('Apply')),
              ),
            ],
          ),
        ),
  );
}
