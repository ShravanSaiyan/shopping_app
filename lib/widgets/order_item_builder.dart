import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/models/order.dart';

class OrderItemBuilder extends StatefulWidget {
  final OrderItem orderItem;

  const OrderItemBuilder({Key? key, required this.orderItem}) : super(key: key);

  @override
  State<OrderItemBuilder> createState() => _OrderItemBuilderState();
}

class _OrderItemBuilderState extends State<OrderItemBuilder> {
  var _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("\$${widget.orderItem.price}"),
            subtitle: Text(
                DateFormat("dd-MM-yyyy hh::mm").format(widget.orderItem.date)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
            ),
          ),
          if (_isExpanded)
            Container(
              padding: const EdgeInsets.all(10),
              height: min(widget.orderItem.products.length * 20.0 + 10, 180),
              child: ListView(
                children: widget.orderItem.products
                    .map((product) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "${product.quantity}* \$${product.price}",
                              style: const TextStyle(
                                fontSize: 19,
                                color: Colors.blueGrey,
                              ),
                            )
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
