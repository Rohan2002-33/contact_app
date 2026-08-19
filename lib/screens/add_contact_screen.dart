import 'package:flutter/material.dart';
import 'package:contact_app/db/database_helper.dart';
import 'package:contact_app/models/contact.dart';

class AddContactScreen extends StatefulWidget {
  @override
  _AddContactScreenState createState() => _AddContactScreenState();
}

class _AddContactScreenState extends State<AddContactScreen> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phone = '';
  String? _email;

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    await DatabaseHelper.instance.addContact(Contact(name: _name, phone: _phone, email: _email));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Contact')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter name' : null,
                onSaved: (v) => _name = v!.trim(),
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Phone'),
                validator: (v) => (v == null || v.isEmpty) ? 'Enter phone' : null,
                onSaved: (v) => _phone = v!.trim(),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
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
