import 'package:flutter/material.dart';
import 'package:contact_app/db/database_helper.dart';
import 'package:contact_app/models/contact.dart';
import 'package:contact_app/widgets/contact_avatar.dart';

class ContactDetailsScreen extends StatefulWidget {
  final int? contactId;
  ContactDetailsScreen({this.contactId});

  @override
  _ContactDetailsScreenState createState() => _ContactDetailsScreenState();
}

class _ContactDetailsScreenState extends State<ContactDetailsScreen> {
  Contact? _contact;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final c = await DatabaseHelper.instance.getContactById(widget.contactId);
    setState(() => _contact = c);
  }

  void _delete() async {
    if (_contact?.id != null) await DatabaseHelper.instance.deleteContact(_contact!.id!);
    Navigator.of(context).pop();
  }

  void _toggleFavorite() async {
    if (_contact?.id != null) await DatabaseHelper.instance.toggleFavorite(_contact!.id!);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    if (_contact == null) return Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        actions: [
          IconButton(
            icon: Icon(_contact!.isFavorite ? Icons.star : Icons.star_border),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => Navigator.pushNamed(context, '/edit', arguments: {'id': _contact!.id}).then((_) => _load()),
          ),
          IconButton(icon: Icon(Icons.delete), onPressed: _delete),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [ContactAvatar(name: _contact!.name, isFavorite: _contact!.isFavorite), SizedBox(width: 12), Text(_contact!.name, style: TextStyle(fontSize: 20))]),
            SizedBox(height: 16),
            Text('Phone: ${_contact!.phone}'),
            if ((_contact!.email ?? '').isNotEmpty) ...[
              SizedBox(height: 8),
              Text('Email: ${_contact!.email}'),
            ]
          ],
        ),
      ),
    );
  }
}
