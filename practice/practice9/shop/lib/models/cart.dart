// The model imports only foundation.dart: it knows nothing about screens
// and could run without Flutter's widgets.
import 'package:flutter/foundation.dart';

import 'book.dart';
//import 'package:flutter/widgets.dart';

class Cart extends ChangeNotifier {
  // Private: outside code cannot change the cart behind its back.
  //Cart(this.context);
  final List<Book> _items = [];
  //final BuildContext context;

  /// A read-only copy: cart.items.add(...) throws
  /// "Unsupported operation: Cannot add to an unmodifiable list".
  List<Book> get items => List.unmodifiable(_items);

  int get count => _items.length;

  int get total => _items.fold(0, (sum, b) => sum + b.price);

  /// The rule "no duplicates" lives HERE and nowhere else.
  /// Returns false (and does nothing) when the book is already there.
  bool add(Book b) {
    if (_items.contains(b)) return false;
    _items.add(b);
    notifyListeners();
    return true;
  }

  void remove(Book b) {
    _items.remove(b);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
