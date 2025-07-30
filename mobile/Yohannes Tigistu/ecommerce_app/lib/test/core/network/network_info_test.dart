import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:mockito/mockito.dart';

import '../../../core/network/network_info.dart';
class MockNetworkInfoChecker extends Mock implements InternetConnection{

}
void main(){

  late NetworkInfoImpl  networkinfo ;
  late MockNetworkInfoChecker mockNetworkInfoChecker;

  setUp(() {
    mockNetworkInfoChecker = MockNetworkInfoChecker();
    networkinfo = NetworkInfoImpl(mockNetworkInfoChecker);
  });
  group('is connected', (){
    test('should forward the connection to internetconnection.hasconnection', (){
      final thasConnection = Future.value(true);
      when(mockNetworkInfoChecker.hasInternetAccess).thenAnswer((_) => thasConnection);

      final result = networkinfo.isConnected;
      verify(mockNetworkInfoChecker.hasInternetAccess);
      expect(result, thasConnection);
    });
  });
}