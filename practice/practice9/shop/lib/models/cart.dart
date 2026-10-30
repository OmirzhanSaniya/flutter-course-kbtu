// The model imports only foundation.dart: it knows nothing about screens
// and could run without Flutter's widgets.
import 'package:flutter/foundation.dart';

import 'book.dart';

class Cart extends ChangeNotifier {
  // Private: outside code cannot change the cart behind its back.
  // book -> quantity. A Map key is unique, so there are no duplicates.
  final Map<Book, int> _qty = {};

  /// A read-only copy: cart.items.add(...) throws
  /// "Unsupported operation: Cannot add to an unmodifiable list".
  List<Book> get items => List.unmodifiable(_qty.keys);

  /// Distinct books (what the badge shows).
  int get count => _qty.length;

  int qtyOf(Book b) => _qty[b] ?? 0;

  /// Price times quantity, summed.
  int get total =>
      _qty.entries.fold(0, (sum, e) => sum + e.key.price * e.value);

  /// The rule "no duplicates" lives HERE and nowhere else.
  /// Returns false (and does nothing) when the book is already in the cart.
  /// The widget decides what to do with the answer.
  bool add(Book b) {
    if (_qty.containsKey(b)) return false;
    _qty[b] = 1;
    notifyListeners();
    return true;
  }

  void increment(Book b) {
    final q = _qty[b];
    if (q == null) return; // no such book here: nothing to increase
    _qty[b] = q + 1;
    notifyListeners();
  }

  void remove(Book b) {
    _qty.remove(b);
    notifyListeners();
  }

  void clear() {
    _qty.clear();
    notifyListeners();
  }
}
