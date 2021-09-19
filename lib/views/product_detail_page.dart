import 'package:flutter/material.dart';
import 'package:flutter_store/models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductModel productModel =
        ModalRoute.of(context)!.settings.arguments as ProductModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.name),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 300.0,
            width: double.infinity,
            child: Image.network(
              productModel.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'R\$ ${productModel.price.toStringAsFixed(2)}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20.0,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            width: double.infinity,
            child: Text(
              '${productModel.description}',
              textAlign: TextAlign.center,
              // style: TextStyle(
              //   color: Colors.grey,
              //   fontSize: 20.0,
              // ),
            ),
          ),
        ],
      ),
    );
  }
}
