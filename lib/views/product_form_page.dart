import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_store/utils/app_string.dart';
import 'package:flutter_store/models/product_model.dart';
import 'package:flutter_store/providers/products_provider.dart';

class ProductFormPage extends StatefulWidget {
  @override
  _ProductFormPageState createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  bool _isLoading = false;
  final _priceFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _form = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  @override
  void initState() {
    super.initState();
    _imageUrlFocusNode.addListener(_updateImage);
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImage);
    _imageUrlFocusNode.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final argument = ModalRoute.of(context)?.settings.arguments;

      if (argument != null) {
        final product = argument as ProductModel;
        _formData['id'] = product.id;
        _formData['name'] = product.name;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['imageUrl'] = product.imageUrl;
        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  void _updateImage() {
    if (isValidImageUrl(_imageUrlController.text)) {
      setState(() {});
    }
  }

  bool isValidImageUrl(String url) {
    bool isValidProtocol = url.toLowerCase().startsWith('http://') ||
        url.toLowerCase().startsWith('https://');
    // bool endsWithPng = url.toLowerCase().endsWith('.png');
    // bool endsWithJpg = url.toLowerCase().endsWith('.jpg');
    // bool endsWithJpeg = url.toLowerCase().endsWith('.jpeg');

    return isValidProtocol;
    // && (endsWithJpeg || endsWithJpg || endsWithPng);
  }

  Future<void> _saveForm() async {
    final isValid = _form.currentState?.validate() ?? false;

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<ProductsProvider>(
        context,
        listen: false,
      ).saveProduct(_formData);
      Navigator.of(context).pop();
    } catch (error) {
      await showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Erro de requisição.'),
          content: Text(error.toString()),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.titleProductForm),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: (_formData['name'] ?? '') as String,
                      decoration: InputDecoration(labelText: 'Nome'),
                      textInputAction:
                          TextInputAction.next, // Next Input keyboard.
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      onSaved: (value) => _formData['name'] = value ?? '',
                      validator: (value) {
                        final name = value ?? '';
                        if (name.trim().isEmpty) return 'Informar nome.';
                        if (name.trim().length < 3)
                          return 'Mínimo de 3 caracteres.';
                        else
                          return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price']?.toString(),
                      decoration: InputDecoration(labelText: 'Preço'),
                      textInputAction:
                          TextInputAction.next, // Next Input keyboard.
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) =>
                          _formData['price'] = double.parse(value ?? '0'),
                      validator: (value) {
                        final priceString = value ?? '';
                        final price = double.tryParse(priceString) ?? -1;
                        if (price <= 0) {
                          return 'Informe um preço válido.';
                        } else
                          return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      decoration: InputDecoration(labelText: 'Descrição'),
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (value) =>
                          _formData['description'] = value ?? '',
                      validator: (value) {
                        final description = value ?? '';
                        if (description.trim().isEmpty)
                          return 'Informar descrição.';
                        else
                          return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: 'URL Imagem',
                            ),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            focusNode: _imageUrlFocusNode,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) {
                              _saveForm;
                            },
                            onSaved: (value) =>
                                _formData['imageUrl'] = value ?? '',
                            validator: (value) {
                              final imageURL = value ?? '';
                              if (imageURL.trim().isEmpty ||
                                  !isValidImageUrl(imageURL))
                                return 'Informar uma url válida.';
                              else
                                return null;
                            },
                          ),
                        ),
                        Container(
                          width: 100.0,
                          height: 100.0,
                          margin: const EdgeInsets.only(
                            top: 8.0,
                            left: 10.0,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text(AppString.labelProductUrlInfo)
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
