import 'package:flutter/material.dart';
import 'package:contact_app/db/database_helper.dart';
import 'package:contact_app/models/contact.dart';

class EditContactScreen extends StatefulWidget {
  final int? contactId;
  EditContactScreen({this.contactId});

  @override
  _EditContactScreenState createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  Contact? _contact;
  String _name = '';
  String _phone = '';
  String? _email;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final c = await DatabaseHelper.instance.getContactById(widget.contactId);
    setState(() {
      _contact = c;
      if (c != null) {
        _name = c.name;
        _phone = c.phone;
        _email = c.email;
      }
    });
  }

  void _save() async {
    if (!_formKey.currentState!.validate() || _contact == null) return;
    _formKey.currentState!.save();
    final updated = _contact!.copyWith(name: _name, phone: _phone, email: _email);
    await DatabaseHelper.instance.updateContact(updated);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    if (_contact == null) return Scaffold(body: Center(child: CircularProgressIndicator()));
    return Scaffold(
      appBar: AppBar(title: Text('Edit Contact')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter name' : null,
                onSaved: (v) => _name = v!.trim(),
              ),
              TextFormField(
                initialValue: _phone,
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter phone' : null,
                onSaved: (v) => _phone = v!.trim(),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                initialValue: _email,
                decoration: InputDecoration(labelText: 'Email (optional)'),
                onSaved: (v) => _email = v?.trim(),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              ElevatedButton(onPressed: _save, child: Text('Save')),
            ],
          ),
        ),
      ),
    );
  }
}
