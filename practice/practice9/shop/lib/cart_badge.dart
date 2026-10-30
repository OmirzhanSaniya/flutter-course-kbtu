import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

/// The badge on the cart icon. It has no constructor parameters: it reaches
/// the Cart from where it stands.
class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('badge build');
    // select: rebuild ONLY when count changes. A quantity change (+ on a
    // cart row) does not change count, so the badge stays still.
    // (Level 3 first used context.watch<Cart>().count here.)
    final n = context.select<Cart, int>((c) => c.count);
    //final n = context.watch<Cart>().count;
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
