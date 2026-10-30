import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            // Consumer: inside the builder we already hold the cart, so no
            // watch / read verb is needed.
            child: Consumer<Cart>(
              builder: (context, cart, _) {
                if (cart.items.isEmpty) {
                  return const Center(child: Text('The cart is empty'));
                }
                return ListView(
                  children: [
                    for (final b in cart.items)
                      ListTile(
                        title: Text(b.title),
                        subtitle: Text('${b.price} ₸'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.add),
                              tooltip: 'One more',
                              onPressed: () => cart.increment(b),
                            ),
                            Text('×${cart.qtyOf(b)}'),
                            IconButton(
                              icon: const Icon(Icons.close),
                              tooltip: 'Remove',
                              onPressed: () => cart.remove(b),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          // The total line: the label never changes, so it is passed as
          // `child`, built once, and not rebuilt on every notify.
          Consumer<Cart>(
            builder: (context, cart, child) => Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  child!,
                  Text(
                    '${cart.total} ₸',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            child: const Row(
              children: [
                Icon(Icons.payments),
                SizedBox(width: 8),
                Text('Total'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
