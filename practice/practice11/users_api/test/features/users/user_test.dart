import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:users_api/features/users/user.dart';

import 'user1_json.dart';

void main() {
  Map<String, dynamic> json() => jsonDecode(user1Json) as Map<String, dynamic>;

  test('fromJson reads user 1', () {
    final u = User.fromJson(json());
    expect(u.name, 'Leanne Graham');
    expect(u.address.city, 'Gwenborough');
    expect(u.address.geo.lat, -37.3159);
    expect(u.company.name, 'Romaguera-Crona');
    expect(u.phoneDigits, '1770736803156442');
  });

  test('toJson round-trips', () {
    final u = User.fromJson(json());
    final again = User.fromJson(u.toJson());
    expect(again, u);
    expect(again.address.geo.lng, u.address.geo.lng);
  });

  test('id as a String throws at the cast', () {
    final bad = json()..['id'] = '1';
    expect(() => User.fromJson(bad), throwsA(isA<TypeError>()));
  });
}
