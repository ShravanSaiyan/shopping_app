import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/models/product.dart';
import 'package:shopping_app/providers/product_provider.dart';

class AddOrEditUserProductScreen extends StatefulWidget {
  static const routeName = "/edit-product";

  const AddOrEditUserProductScreen({Key? key}) : super(key: key);

  @override
  State<AddOrEditUserProductScreen> createState() =>
      _AddOrEditUserProductScreenState();
}

class _AddOrEditUserProductScreenState
    extends State<AddOrEditUserProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  void _saveForm(BuildContext context, Product product) {
    var productProvider = Provider.of<ProductProvider>(context, listen: false);
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();
    productProvider.updateProduct(product);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    var arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    String? id = arguments["id"];
    String? title = arguments["title"];
    var formProductData = Product(id: id ?? DateTime.now().toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(title ?? "Edit Product"),
      ),
      floatingActionButton: IconButton(
          icon: const Icon(Icons.save),
          onPressed: () => _saveForm(context, formProductData)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Title"),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                onSaved: (title) {
                  formProductData.title = title!;
                },
                validator: (title) {
                  return (title == null || title.trim().isEmpty)
                      ? "Please enter the title "
                      : null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                onSaved: (price) {
                  formProductData.price = double.parse(price!);
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter the price";
                  }
                  var price = double.parse(value);
                  return (price <= 0) ? "Please enter a positive price " : null;
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Description"),
                keyboardType: TextInputType.multiline,
                maxLines: 1,
                focusNode: _descriptionFocusNode,
                onSaved: (description) {
                  formProductData.description = description!;
                },
                validator: (description) {
                  if ((description == null || description.trim().isEmpty)) {
                    return "Please enter the description ";
                  } else if (description.length <= 3) {
                    return "Description should be at least 4 characters";
                  } else {
                    return null;
                  }
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: const EdgeInsets.only(top: 8, right: 10),
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: _imageUrlController.text.isEmpty
                        ? const Text("Enter the URL")
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(labelText: "Image Url"),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      focusNode: _imageUrlFocusNode,
                      controller: _imageUrlController,
                      onFieldSubmitted: (_) {
                        _saveForm(context, formProductData);
                      },
                      onEditingComplete: () {
                        FocusScope.of(context).unfocus();
                        setState(() {});
                      },
                      onSaved: (imageUrl) {
                        formProductData.imageUrl = imageUrl!;
                      },
                      validator: (imageUrl) {
                        if ((imageUrl == null || imageUrl.trim().isEmpty)) {
                          return "Please enter the image URL ";
                        } else if (!imageUrl.startsWith("http") &&
                            !imageUrl.startsWith("https")) {
                          return "Please enter a valid image URL";
                        }
                        return null;
                      },
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
