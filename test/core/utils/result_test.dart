import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/core/utils/result.dart';

void main() {
  test('Success wraps a value and exposes it via isSuccess', () {
    const result = Result<int, String>.success(42);
    expect(result.isSuccess, isTrue);
    expect(result.valueOrNull, 42);
  });

  test('Failure wraps an error and exposes it via errorOrNull', () {
    const result = Result<int, String>.failure('boom');
    expect(result.isSuccess, isFalse);
    expect(result.errorOrNull, 'boom');
  });

  test('when() dispatches to the matching branch', () {
    const success = Result<int, String>.success(1);
    const failure = Result<int, String>.failure('err');

    expect(
      success.when(success: (v) => 'ok:$v', failure: (e) => 'err:$e'),
      'ok:1',
    );
    expect(
      failure.when(success: (v) => 'ok:$v', failure: (e) => 'err:$e'),
      'err:err',
    );
  });
}
