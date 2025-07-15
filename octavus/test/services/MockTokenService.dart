import 'package:mockito/mockito.dart';
import 'package:octavus/services/Auth/Interfaces/ITokenService.dart';

class MockTokenService extends Mock implements ITokenService {
  @override
  Future<String?> getToken() => super.noSuchMethod(
        Invocation.method(#getToken, []),
        returnValue: Future.value(null),
        returnValueForMissingStub: Future.value(null),
      );
}
