import 'package:flutter/material.dart';
import '../models/contact.dart';
import '../db/database_helper.dart';
import '../main.dart';

class EditContactScreen extends StatefulWidget {
  final Contact contact;
  const EditContactScreen({super.key, required this.contact});

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact.name);
    _phoneController = TextEditingController(text: widget.contact.phone);
    _emailController = TextEditingController(text: widget.contact.email);
    _addressController = TextEditingController(text: widget.contact.address);
  }

  Future<void> _updateContact() async {
    if (_formKey.currentState!.validate()) {
      final updated = widget.contact.copyWith(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        email: _emailController.text.trim(),
        address: _addressController.text.trim(),
      );
      await DatabaseHelper.instance.updateContact(updated);
      if (mounted) Navigator.pop(context, updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Contact'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _updateContact),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: const BoxDecoration(
                  color: kPrimaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt_outlined,
                    color: kPrimaryColor, size: 32),
              ),
              const SizedBox(height: 28),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Phone is required' : null,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _updateContact,
                  child: const Text('Update Contact'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}