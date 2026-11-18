import '../../core/api/api_exception.dart';
import 'user.dart';
import 'user_repository.dart';
import 'users_result.dart';

// Practice 13: a repository with no network, for tests and a demo mode.
// The two users are built from JSON maps, so a broken map breaks
// fromJson exactly like a broken server would (Level 5).
class FakeUserRepository implements UserRepository {
  FakeUserRepository({this.fail = false, this.delay = Duration.zero});

  final bool fail; // true -> every call throws NoConnectionException
  final Duration delay; // pretend the network is slow

  static const _json = <Map<String, dynamic>>[
    {
      'id': 1,
      'name': 'Aida Nurlanova',
      'username': 'aida',
      'email': 'aida@kbtu.kz',
      'phone': '+7 701 111 22 33',
      'website': 'kbtu.kz',
      'address': {
        'street': 'Tole bi 59',
        'suite': 'Room 101',
        'city': 'Almaty',
        'zipcode': '050000',
        // BREAK IT (Level 5): 'lat': 43.2567 (a number) -> fromJson crashes
        'geo': {'lat': '43.2567', 'lng': '76.9286'},
      },
      'company': {'name': 'KBTU', 'catchPhrase': 'Learn by building'},
    },
    {
      'id': 2,
      'name': 'Dias Seitkali',
      'username': 'dias',
      'email': 'dias@kbtu.kz',
      'phone': '+7 702 444 55 66',
      'address': {
        'street': 'Mangilik El 8',
        'suite': 'Apt. 12',
        'city': 'Astana',
        'zipcode': '010000',
        'geo': {'lat': '51.1282', 'lng': '71.4307'},
      },
      'company': {'name': 'Campus Labs', 'catchPhrase': 'Ship it'},
    },
  ];

  Future<void> _wait() async {
    await Future<void>.delayed(delay);
    if (fail) throw const NoConnectionException();
  }

  List<User> _users() => [for (final j in _json) User.fromJson(j)];

  @override
  Future<UsersResult> getAll() async {
    await _wait();
    return (items: _users(), fromCache: false);
  }

  @override
  Future<User> getById(int id) async {
    await _wait();
    for (final u in _users()) {
      if (u.id == id) return u;
    }
    throw const NotFoundException();
  }

  @override
  Future<User> create(User draft) async {
    await _wait();
    return User.fromJson({...draft.toJson(), 'id': 3});
  }
}
