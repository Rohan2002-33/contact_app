import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../db/database_helper.dart';
import '../widgets/contact_avatar.dart';
import 'edit_contact_screen.dart';

class ContactDetailsScreen extends StatefulWidget {
  final Contact contact;
  const ContactDetailsScreen({super.key, required this.contact});

  @override
  State<ContactDetailsScreen> createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  late Contact _contact;

  @override
  void initState() {
    super.initState();
    _contact = widget.contact;
  }

  Future<void> _toggleFavorite() async {
    final updated = _contact.copyWith(
      isFavorite: _contact.isFavorite == 1 ? 0 : 1,
    );
    await DatabaseHelper.instance.updateContact(updated);
    setState(() => _contact = updated);
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: const BoxDecoration(
                  color: Color(0xFFFFEBEE), shape: BoxShape.circle),
              child: const Icon(Icons.delete_outline, color: Colors.red, size: 28),
            ),
            const SizedBox(height: 12),
            const Text('Delete Contact', style: TextStyle(fontSize: 18)),
          ],
        ),
        content: Text(
          'Are you sure you want to delete ${_contact.name}?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await DatabaseHelper.instance.deleteContact(_contact.id!);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Details'),
        actions: [
          IconButton(
            icon: Icon(
              _contact.isFavorite == 1 ? Icons.star : Icons.star_border,
              color: _contact.isFavorite == 1 ? Colors.amber : Colors.white,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () async {
              final updated = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => EditContactScreen(contact: _contact)),
              );
              if (updated != null) {
                setState(() => _contact = updated as Contact);
              }
            },
          ),
          IconButton(
              icon: const Icon(Icons.delete_outline), onPressed: _confirmDelete),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ContactAvatar(name: _contact.name, radius: 50),
            const SizedBox(height: 14),
            Text(_contact.name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            Card(
              child: Column(
                children: [
                  _detailRow(Icons.phone, _contact.phone, 'Mobile'),
                  const Divider(height: 1, indent: 56),
                  _detailRow(Icons.email, _contact.email, 'Email'),
                  const Divider(height: 1, indent: 56),
                  _detailRow(Icons.location_on, _contact.address, 'Address'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String value, String label) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF5F5FEA)),
      title: Text(value.isEmpty ? '-' : value),
      subtitle: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
    );
  }
}