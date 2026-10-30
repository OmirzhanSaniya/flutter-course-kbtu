import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'cart_badge.dart';
import 'models/book.dart';
import 'models/cart.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('BooksScreen build');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: const [CartBadge()],
      ),
      body: ListView(
        children: [
          for (final b in books) _BookRow(book: b),
        ],
      ),
    );
  }
}

class _BookRow extends StatelessWidget {
  const _BookRow({required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    debugPrint('row ${book.title}');
    // watch inside build: the row depends on the cart.
    final inCart = context.watch<Cart>().items.contains(book);
    return ListTile(
      title: Text(book.title),
      subtitle: Text(book.author),
      trailing: inCart
          ? const Text('Added')
          : OutlinedButton(
              // read inside a callback: a one-time action, no subscription.
              onPressed: () => context.read<Cart>().add(book),
              //onPressed: () => context.watch<Cart>().add(book),
              child: const Text('Add'),
            ),
    );
  }
}
