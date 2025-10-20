import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EditItinernaryScreen extends StatefulWidget {
  const EditItinernaryScreen({super.key});

  @override
  State<EditItinernaryScreen> createState() => _EditItinernaryScreenState();
}

class _EditItinernaryScreenState extends State<EditItinernaryScreen> {
  final List<Map<String, String>> _items = [
    {
      "title": "Breakfast at The Local Cafe",
      "subtitle": "9:00 AM - The Local Cafe",
    },
    {"title": "Visit the City Museum", "subtitle": "10:30 AM - City Museum"},
    {"title": "Lunch at Seaside Grill", "subtitle": "1:00 PM - Seaside Grill"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Itinerary',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save itinerary changes
        },
        backgroundColor: const Color(0xFFFFA000),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: ReorderableListView(
        children: _items.map((item) => _buildListItem(item)).toList(),

        onReorder: (newIndex, oldIndex) {
          setState(() {
            if (newIndex > oldIndex) {
              newIndex -= 1;
            }
            final item = _items.removeAt(oldIndex);
            _items.insert(newIndex, item);
          });
        },
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),

        child: ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00A3FF),
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 56),
          ),
          child: const Text('Save Changes'),
        ),
      ),
    );
  }

  Widget _buildListItem(Map<String, String> item) {
    return Card(
      key: ValueKey(item['title']),
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      color: Colors.white,
      shadowColor: Colors.grey.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: const Icon(Icons.drag_handle),
        title: Text(
          item['title']!,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          item['subtitle']!,
          style: const TextStyle(color: Color(0xFF00A3FF)),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.black),
          onPressed: () {
            setState(() {
              _items.remove(item);
            });
          },
        ),
      ),
    );
  }
}
