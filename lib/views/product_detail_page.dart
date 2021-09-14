import 'package:flutter/material.dart';
import 'package:flutter_store/models/product_model.dart';

class ProductDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ProductModel productModel =
        ModalRoute.of(context).settings.arguments as ProductModel;

    return Scaffold(
      appBar: AppBar(
        title: Text(productModel.title),
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            child: Image.network(
              productModel.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'R\$ ${productModel.price}',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15),
            width: double.infinity,
            child: Text(
              '${productModel.description}',
              textAlign: TextAlign.center,
              // style: TextStyle(
              //   color: Colors.grey,
              //   fontSize: 20,
              // ),
            ),
          )
        ],
      ),
    );
  }
}
