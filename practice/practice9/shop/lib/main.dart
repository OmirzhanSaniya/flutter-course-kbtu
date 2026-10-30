import 'package:flutter/material.dart';

import 'books_screen.dart';
import 'cart_screen.dart';
import 'models/book.dart';
//import 'models/cart.dart';

void main() => runApp(const Shell());
/*void main() {
  final cart = Cart();
  cart.add(books[0]);
  cart.add(books[1]);
  cart.add(books[0]); // вторая попытка: корзина откажет, ничего не добавится
  cart.remove(books[0]);
  debugPrint('${cart.count} items, ${cart.total} ₸');
  //cart.items.add(books[0]);
  runApp(const Shell());
}*/

// Level 1: the owner of the cart. It sits ABOVE MaterialApp
// so that both routes can see the same list.
class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  final List<Book> _cart = [];

  void _add(Book b) => setState(() => _cart.add(b));
  void _remove(Book b) => setState(() => _cart.remove(b));

  @override
  Widget build(BuildContext context) {
    // The designer's request: the total in the badge. It is computed here,
    // by the owner, and passed down by hand.
    final total = _cart.fold(0, (sum, b) => sum + b.price);
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      routes: {
        '/': (_) => BooksScreen(cart: _cart, total: total, onAdd: _add),
        '/cart': (_) => CartScreen(items: _cart, onRemove: _remove),
      },
    );
  }
}
