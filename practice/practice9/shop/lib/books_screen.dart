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
    //context.watch<Cart>();
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

/// A row is its own widget so that it has its own context: it subscribes
/// for itself, and only for what it shows.
class _BookRow extends StatelessWidget {
  const _BookRow({required this.book});

  final Book book;

  void _add(BuildContext context) {
    // read: a one-time action inside a callback. It does not subscribe.
    context.read<Cart>().add(book);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('row ${book.title}');
    // This row depends only on "is MY book in the cart". select rebuilds the
    // row only when that answer changes. (Level 3 used
    // context.watch<Cart>().items.contains(book).)
    final inCart = context.select<Cart, bool>((c) => c.qtyOf(book) > 0);
    return ListTile(
      title: Text(book.title),
      subtitle: Text(book.author),
      trailing: inCart
          ? const Text('Added')
          : OutlinedButton(
              onPressed: () => _add(context),
              child: const Text('Add'),
            ),
    );
  }
}
