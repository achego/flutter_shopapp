import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/provider/product.dart';
import 'package:shop_app/provider/products.dart';

class EditProductSreen extends StatefulWidget {
  static String routeName = 'edit-product';

  @override
  _EditProductSreenState createState() => _EditProductSreenState();
}

class _EditProductSreenState extends State<EditProductSreen> {
  final _priceFocusNode = FocusNode();

  final _descriptionFocusNde = FocusNode();
  String imageUrl = '';
  final _formKey = GlobalKey<FormState>();

  String _id;
  String _title;
  double _price;
  String _description;
  String _imageUrl;
  bool _update = false;
  bool _isLoading = false;

  bool _isInit = false;

  @override
  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNde.dispose();
    super.dispose();
  }

  @override
  void initState() {
    print('Init State');
    _isInit = true;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('dependency changed');
    Product product = ModalRoute.of(context).settings.arguments;
    if (product != null) {
      _update = true;
    }
    if (_isInit) {
      if (product != null) {
        _id = product.id;
        _title = product.title;
        _price = product.price;
        _description = product.description;
        _imageUrl = product.imageUrl;
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _showLoadingDialogue() {
    setState(() {
      _isLoading = true;
    });
  }

  void _dismisLoadingDialogue() {
    setState(() {
      _isLoading = false;
    });
  }

  void _saveForm() async {
    Product _newProduct;
    final isValid = _formKey.currentState.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState.save();
    _newProduct = Product(
      id: _id,
      title: _title,
      description: _description,
      imageUrl: _imageUrl,
      price: _price,
    );

    _showLoadingDialogue();

    if (!_update) {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(_newProduct);
        Navigator.pop(context);
      } catch (error) {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('something went wrong.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context), child: Text('OK'))
            ],
          ),
        );
        print(error);
      } finally {
        _dismisLoadingDialogue();
      }
    } else {
      try {
        await Provider.of<Products>(
          context,
          listen: false,
        ).updateProduct(_newProduct);
        Navigator.pop(context);
      } catch (error) {
        print('this is the error $error');
        _dismisLoadingDialogue();
      }
    }

    // if(!_update)
    // Provider.of<Products>(context, listen: false)
    //     .addProduct(_newProduct)
    //     .then((value) {
    //   _dismisLoadingDialogue();
    //   Navigator.pop(context);
    // }).catchError((error) {
    //   _dismisLoadingDialogue();
    //   showDialog(
    //     context: context,
    //     builder: (_) => AlertDialog(
    //       title: Text('An error occured!'),
    //       content: Text('something went wrong.'),
    //       actions: [
    //         TextButton(
    //             onPressed: () => Navigator.pop(context), child: Text('OK'))
    //       ],
    //     ),
    //   );
    //   print(error);
    // });
  }

  @override
  Widget build(BuildContext context) {
    print('build method ran');
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Stack(children: [
        Container(
          margin: EdgeInsets.only(top: 10),
          padding: EdgeInsets.all(15),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    initialValue: _title,
                    decoration: InputDecoration(labelText: 'Title'),
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_priceFocusNode);
                    },
                    onSaved: (value) => _title = value,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a Valid title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _price != null ? _price.toString() : '',
                    decoration: InputDecoration(labelText: 'Price'),
                    focusNode: _priceFocusNode,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_descriptionFocusNde);
                    },
                    onSaved: (value) => _price = double.parse(value),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Enter a correct price without alphabets';
                      }
                      if (double.parse(value) <= 1) {
                        return 'minimum rice is 1';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: _description,
                    decoration: InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    keyboardType: TextInputType.multiline,
                    focusNode: _descriptionFocusNde,
                    onSaved: (value) => _description = value,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter a description';
                      }
                      if (value.length < 10) {
                        return 'description too short';
                      }

                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 8, top: 6),
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                            border: Border.all(
                          color: Colors.grey,
                        )),
                        child: Stack(alignment: Alignment.center, children: [
                          Text(
                            'Enter Valid Url',
                            textAlign: TextAlign.center,
                          ),
                          Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ]),
                      ),
                      Expanded(
                        child: TextFormField(
                          initialValue: _imageUrl,
                          onSaved: (value) => _imageUrl = value,
                          decoration: InputDecoration(labelText: 'Image Url'),
                          keyboardType: TextInputType.url,
                          onChanged: (text) {
                            setState(() {
                              imageUrl = text;
                            });
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'url cannot be empty';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              )),
        ),
        if (_isLoading) circularLoadingProgress(context),
      ]),
    );
  }

  Stack circularLoadingProgress(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              _isLoading = false;
            });
          },
          child: Container(
            decoration: BoxDecoration(color: Colors.black87),
          ),
        ),
        Center(
          child: Container(
              padding: EdgeInsets.all(10),
              height: 100,
              width: MediaQuery.of(context).size.width - 100,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Please Wait', style: TextStyle()),
                  CircularProgressIndicator.adaptive(),
                ],
              )),
        ),
      ],
    );
  }
}
