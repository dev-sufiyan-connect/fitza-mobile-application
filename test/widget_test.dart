import 'package:flutter_test/flutter_test.dart';

import 'package:fitza_mobile_application/core/router/route_names.dart';

void main() {
  test('route names are unique', () {
    final names = [
      RouteNames.splash,
      RouteNames.login,
      RouteNames.home,
    ];
    expect(names.toSet().length, names.length);
  });
}
