import 'package:bikeminer/backend/api_connector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  APIConnector api = APIConnector();
  test('login in API and get token', () async {
    var res = await api.getlogintoken("testUser", "123");
    expect(res["statusCode"], 200);
  });

  test('riding', () async {
    var lat = [
      49.4740569,
      49.4739221,
      49.4737234,
      49.4735605,
      49.4736136,
      49.4736651,
      49.4737191,
      49.4737705,
      49.4738524,
      49.4739097
    ];
    var long = [
      8.5341459,
      8.5341212,
      8.5340837,
      8.5340475,
      8.5335204,
      8.5329048,
      8.5323362,
      8.5317341,
      8.5309079,
      8.53034
    ];

    for (int i = 0; i < lat.length; i++) {
      var res =
          await api.sendcoordinates(lat[i], long[i], '2022-03-30T14:15:00');
      expect(res, 200);
    }
  });

  test('stop riding', () async {
    var res = await api.stopriding();
    expect(res, 200);
  });
}
