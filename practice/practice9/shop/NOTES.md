# Practice 9 - Put It High, Subscribe Low

## Level 1: the cost of lifting state (commit `lifted`)

The designer asked for the total price in the badge too. The honest way is a
second parameter, `total`, from the owner all the way down:

- Constructors touched: **2** (`BooksScreen` and `CartBadge`), plus the one
  place that calls them in `Shell.build`.
- Files touched: **3** (`main.dart`, `books_screen.dart`, `cart_badge.dart`).
- `BooksScreen` does not use `total` at all. It only carries it to
  `CartBadge`. That is the price of "parameters down".

Rebuilds for ONE tap on Add: **7 lines** in the console: `BooksScreen build`
once and `row ...` six times. `setState` in `Shell` marks everything under it
dirty, so one tap rebuilt the whole screen and every row.

## Level 3: the two provider errors

Loud (`context.watch` inside `onPressed`):

    EXCEPTION CAUGHT BY GESTURE 
    The following assertion was thrown while handling a gesture:
    Tried to listen to a value exposed with provider, from outside of the widget tree.
    This is likely caused by an event handler (like a button's onPressed) that called
    Provider.of without passing listen: false.

Silent (`context.read<Cart>().count` in the badge): no error at all. It
compiles and runs, and the badge is frozen at 0 forever, because nobody said
"I depend on the cart".

## Level 4: rebuild counter (badge)

Pressing + on a cart row three times:

| Badge subscribes with | `badge build` printed |
|---|---|
| `context.watch<Cart>().count` | **3** (the count did not change, but the badge rebuilt) |
| `context.select<Cart, int>((c) => c.count)` | **0** (removing a book prints **1**) |

Same model, same taps, one line changed in one widget.

