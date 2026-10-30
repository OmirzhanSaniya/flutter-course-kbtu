import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

/// No constructor parameters: it reaches the Cart from where it stands.
class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    // watch: a verb of build. The badge says "I depend on the cart".
    final n = context.watch<Cart>().count;
    //final n = context.read<Cart>().count;
    return IconButton(
      icon: Badge(
        label: Text('$n'),
        child: const Icon(Icons.shopping_cart),
      ),
      tooltip: 'Cart',
      onPressed: () => Navigator.of(context).pushNamed('/cart'),
    );
  }
}
