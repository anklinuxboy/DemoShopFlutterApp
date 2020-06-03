import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../providers/products.dart';

class ManageProduct extends StatefulWidget {
  static const ROUTE = '/manage-product';

  @override
  _ManageProductState createState() => _ManageProductState();
}

class _ManageProductState extends State<ManageProduct> {
  final _priceFocusNode = FocusNode();
  final _descriptionNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _product = Product(
    id: null,
    title: '',
    price: 0,
    description: '',
    imageUrl: '',
  );
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        _product =
            Provider.of<Products>(context, listen: false).findById(productId);
        _imageUrlController.text = _product.imageUrl;
      }
      _isInit = false;
    }
    super.didChangeDependencies();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _saveProduct() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<Products>(context, listen: false).addProduct(_product);
    } catch (error) {
      await showDialog<Null>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('An error occured'),
          content: Text('Something went wrong'),
          actions: <Widget>[
            FlatButton(
              child: Text('Okay'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Products'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveProduct,
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _product.title,
                      decoration: InputDecoration(labelText: 'Title'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a title.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _product = Product(
                            id: _product.id,
                            title: value,
                            price: _product.price,
                            imageUrl: _product.imageUrl,
                            isFavorite: _product.isFavorite,
                            description: _product.description);
                      },
                    ),
                    TextFormField(
                      initialValue:
                          _product.price == 0 ? '' : _product.price.toString(),
                      decoration: InputDecoration(labelText: 'Price'),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_descriptionNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a price.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }

                        if (double.parse(value) <= 0) {
                          return 'Please enter a minimum price above 0.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _product = Product(
                            id: _product.id,
                            title: _product.title,
                            price: double.parse(value),
                            imageUrl: _product.imageUrl,
                            isFavorite: _product.isFavorite,
                            description: _product.description);
                      },
                    ),
                    TextFormField(
                      initialValue: _product.description,
                      decoration: InputDecoration(labelText: 'Description'),
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      focusNode: _descriptionNode,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter a description.';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _product = Product(
                            id: _product.id,
                            title: _product.title,
                            price: _product.price,
                            imageUrl: _product.imageUrl,
                            isFavorite: _product.isFavorite,
                            description: value);
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(
                            top: 8,
                            right: 10,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child:
                                      Image.network(_imageUrlController.text),
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            decoration: InputDecoration(labelText: 'Image URL'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,
                            onFieldSubmitted: (_) => _saveProduct(),
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter an image url.';
                              }

                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Please enter a valid image url';
                              }

                              return null;
                            },
                            onSaved: (value) {
                              _product = Product(
                                id: _product.id,
                                title: _product.title,
                                price: _product.price,
                                description: _product.description,
                                imageUrl: value,
                                isFavorite: _product.isFavorite,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionNode.dispose();
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }
}
