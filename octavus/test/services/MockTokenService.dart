import 'package:mockito/mockito.dart';
import 'package:octavus/services/auth/interfaces/i_token_service.dart';

class MockTokenService extends Mock implements ITokenService {
  @override
  Future<String?> getToken() => super.noSuchMethod(
        Invocation.method(#getToken, []),
        returnValue: Future.value(null),
        returnValueForMissingStub: Future.value(null),
      );
}
