import 'package:flutter/material.dart';
import 'package:myfrontend/features/auth/services/product_service.dart';

class AddProductScreen extends StatelessWidget {
  final String userId;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  AddProductScreen({super.key, required this.userId});

  Future<void> _submitProduct(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      try {
        final priceText = _priceController.text;
        final price = double.tryParse(priceText);

        if (price == null || price <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please enter a valid positive price')),
          );
          return;
        }

        await ProductService().addProduct(
          name: _nameController.text,
          price: price,
          description: _descriptionController.text,
        );

        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name*'),
                validator: (value) => value!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price*'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Required';
                  final parsedValue = double.tryParse(value);
                  if (parsedValue == null) return 'Invalid number';
                  if (parsedValue <= 0) return 'Must be > 0';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                  onPressed: () => _submitProduct(context),
                  child: const Text('Add Product')),
            ],
          ),
        ),
      ),
    );
  }
}