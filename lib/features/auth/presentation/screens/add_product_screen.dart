import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:myfrontend/data/model/product.dart';
import 'package:myfrontend/features/auth/services/product_service.dart';

class AddProductScreen extends StatefulWidget {
  final String userId;
  final Product? product; // For edit mode
  const AddProductScreen({
    super.key,
    required this.userId,
    this.product,
  });

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _pickedImage;
  String? _uploadedImageUrl;
  String _selectedCategory = 'All';
  String? _selectedDemographic;

  final List<String> _categories = [
    'All', 'Jackets', 'Jeans', 'Shoes', 'Shirts', 'Accessories',
    'Dresses', 'Tops', 'Bottoms', 'Outerwear', 'Bags', 'Hats',
    'Sportswear', 'Vintage', 'Formal', 'Casual', 'Kids', 'Men', 'Women', 'Unisex', 'Others'
  ];

  final List<String> _demographics = [
    'Adult', 'Child', 'Teenage', 'Trend'
  ];

  final List<String> _allSizes = ['S', 'M', 'L', 'XL', 'XXL', 'XXXL'];
  List<String> _selectedSizes = [];
  List<TextEditingController> _colorControllers = [];

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _descriptionController.text = widget.product!.description ?? '';
      _uploadedImageUrl = widget.product!.imageUrl;
      _selectedCategory = widget.product!.category;
      _selectedDemographic = widget.product!.demographic; // Make sure your Product model has this field
      _selectedSizes = widget.product!.sizes ?? [];
      _colorControllers = (widget.product!.colors ?? [])
          .map((color) => TextEditingController(text: color))
          .toList();
    } else {
      _colorControllers = [TextEditingController()];
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    final uri = Uri.parse('http://192.168.1.115:3000/api/upload'); // Update with your backend URL
    final request = http.MultipartRequest('POST', uri);
    request.files.add(await http.MultipartFile.fromPath(
      'image',
      imageFile.path,
      filename: path.basename(imageFile.path),
    ));
    final response = await request.send();
    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      // Assuming backend returns: { "url": "http://..." }
      final url = RegExp(r'"url"\s*:\s*"([^"]+)"').firstMatch(respStr)?.group(1);
      return url;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Image Picker
              GestureDetector(
                onTap: _pickImage,
                child: _pickedImage != null
                    ? Image.file(_pickedImage!, height: 150)
                    : (_uploadedImageUrl != null
                    ? Image.network(_uploadedImageUrl!, height: 150)
                    : Container(
                  height: 150,
                  color: Colors.grey[200],
                  child: const Center(child: Text('Tap to pick image')),
                )),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) => value == null || value.trim().isEmpty ? 'Product name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) return 'Price is required';
                  final price = double.tryParse(value);
                  if (price == null || price <= 0) return 'Enter a valid price';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value!),
                validator: (value) => value == null ? 'Select a category' : null,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedDemographic,
                items: _demographics.map((demo) {
                  return DropdownMenuItem(
                    value: demo,
                    child: Text(demo),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedDemographic = value),
                validator: (value) => value == null ? 'Select a demographic' : null,
                decoration: const InputDecoration(labelText: 'Demographic'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              // Size selection
              const Text('Available Sizes', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 8,
                children: _allSizes.map((size) {
                  final selected = _selectedSizes.contains(size);
                  return FilterChip(
                    label: Text(size),
                    selected: selected,
                    onSelected: (val) {
                      setState(() {
                        if (val) {
                          _selectedSizes.add(size);
                        } else {
                          _selectedSizes.remove(size);
                        }
                      });
                    },
                    selectedColor: Colors.brown,
                    labelStyle: TextStyle(
                      color: selected ? Colors.white : Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              // Color input fields
              const Text('Available Colors', style: TextStyle(fontWeight: FontWeight.bold)),
              Column(
                children: [
                  ..._colorControllers.asMap().entries.map((entry) {
                    final idx = entry.key;
                    final controller = entry.value;
                    return Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: controller,
                            decoration: InputDecoration(
                              labelText: 'Color ${idx + 1}',
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                          onPressed: _colorControllers.length > 1
                              ? () {
                            setState(() {
                              _colorControllers.removeAt(idx);
                            });
                          }
                              : null,
                        ),
                      ],
                    );
                  }),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Add Color'),
                      onPressed: () {
                        setState(() {
                          _colorControllers.add(TextEditingController());
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text(widget.product == null ? 'Add Product' : 'Update Product'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        String? imageUrl = _uploadedImageUrl;
        if (_pickedImage != null) {
          imageUrl = await _uploadImage(_pickedImage!);
          if (imageUrl == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image upload failed')),
            );
            return;
          }
        }
        if (imageUrl == null || imageUrl.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select and upload an image')),
          );
          return;
        }
        final colors = _colorControllers
            .map((controller) => controller.text.trim())
            .where((color) => color.isNotEmpty)
            .toList();
        final product = Product(
          id: widget.product?.id ?? '',
          name: _nameController.text,
          price: double.parse(_priceController.text.trim()),
          imageUrl: imageUrl,
          category: _selectedCategory,
          description: _descriptionController.text,
          userId: widget.userId,
          sizes: _selectedSizes.isNotEmpty ? _selectedSizes : null,
          colors: colors.isNotEmpty ? colors : null,
          demographic: _selectedDemographic, // Make sure your Product model supports this
        );

        if (widget.product == null) {
          await ProductService().addProduct(product, context);
        } else {
          // Add updateProduct() to your ProductService
          // await _updateProduct(product, context);
        }

        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    for (final c in _colorControllers) {
      c.dispose();
    }
    super.dispose();
  }
}