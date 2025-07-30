import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../../core/platform/network_info.dart';
import '../../../../../features/Products/data/datasources/products_local_data_source.dart';
import '../../../../../features/Products/data/datasources/products_remote_data_source.dart';

import '../../../../../features/Products/data/repositories/product_repository_impl.dart';
class mockRemoteDatasource extends Mock implements ProductsRemoteDataSource {
}
class mocklocalDatasource extends Mock implements ProductsLocalDataSource {
}
class mockNetworkInfo extends Mock implements NetworkInfo {
}
 
void main(){
  ProductRepositoryImpl repository;
  mockRemoteDatasource remoteDataSource;
  mocklocalDatasource localDataSource;
  mockNetworkInfo networkInfo;

  setUp(() {
    remoteDataSource = mockRemoteDatasource();
    localDataSource = mocklocalDatasource();
    networkInfo = mockNetworkInfo();
    repository = ProductRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
      networkInfo: networkInfo,
    );
  });
  

}