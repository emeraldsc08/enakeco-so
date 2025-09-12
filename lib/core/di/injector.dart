import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

// Auth Feature
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
// Main Menu Feature
import '../../features/main_menu/data/datasources/main_menu_remote_datasource.dart';
import '../../features/main_menu/data/repositories/main_menu_repository_impl.dart';
import '../../features/main_menu/domain/repositories/main_menu_repository.dart';
import '../../features/main_menu/domain/usecases/get_dashboard_stats_usecase.dart';
import '../../features/main_menu/presentation/providers/main_menu_provider.dart';
// RTL Feature
import '../../features/rtl/data/datasources/product_remote_datasource.dart';
import '../../features/rtl/data/repositories/product_repository.dart';
import '../../features/shared/providers/product_list_provider.dart';
// Stock Opname Feature
import '../../features/stock_opname/data/datasources/stock_opname_remote_datasource.dart';
import '../../features/stock_opname/data/repositories/stock_opname_repository_impl.dart';
import '../../features/stock_opname/domain/repositories/stock_opname_repository.dart';
import '../../features/stock_opname/domain/usecases/create_stock_opname_usecase.dart';
import '../../features/stock_opname/domain/usecases/get_list_so_usecase.dart';
import '../../features/stock_opname/domain/usecases/get_stock_opname_list_usecase.dart';
import '../../features/stock_opname/presentation/providers/stock_opname_provider.dart';
import '../constants/env.dart';
import '../network/auth_interceptor.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // Dio setup
  final dio = Dio(
    BaseOptions(
      baseUrl: Env.stockListBaseUrl,
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(milliseconds: 30000),
      receiveTimeout: const Duration(milliseconds: 45000),
      sendTimeout: const Duration(milliseconds: 60000),
      contentType: 'application/json',
      responseType: ResponseType.json, // Changed from ResponseType.plain to ResponseType.json
      headers: {
        'Accept': 'application/json',
        'Charset': 'utf-8',
        'app_name': 'EnakEco SO',
        'device_id': '', // Will be filled from device info
        'device_os': '',
        'device_os_version': '',
        'x-type-request': 'mobile',
      },
    ),
  )..interceptors.addAll([
      // Add auth interceptor
      AuthInterceptor(),
      // Add other interceptors here when needed
      // HttpFormatter(),
      // ChuckerDioInterceptor(),
    ]);

  // Dependency Injection Registration

  // External
  locator.registerLazySingleton(() => dio);

  // Data sources
  locator.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<StockOpnameRemoteDataSource>(
    () => StockOpnameRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<MainMenuRemoteDataSource>(
    () => MainMenuRemoteDataSourceImpl(client: locator()),
  );
  locator.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSource(client: locator()),
  );

  // Repositories
  locator.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<StockOpnameRepository>(
    () => StockOpnameRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<MainMenuRepository>(
    () => MainMenuRepositoryImpl(locator()),
  );
  locator.registerLazySingleton<ProductRepository>(
    () => ProductRepository(remoteDataSource: locator()),
  );

  // Use cases
  locator.registerLazySingleton(() => LoginUseCase(locator()));
  locator.registerLazySingleton(() => GetStockOpnameListUseCase(locator()));
  locator.registerLazySingleton(() => CreateStockOpnameUseCase(locator()));
  locator.registerLazySingleton(() => GetListSOUseCase(locator()));
  locator.registerLazySingleton(() => GetDashboardStatsUseCase(locator()));

  // Providers
  locator.registerFactory(
    () => AuthProvider(
      locator<LoginUseCase>(),
    ),
  );
  locator.registerFactory(
    () => StockOpnameProvider(
      locator<GetStockOpnameListUseCase>(),
      locator<CreateStockOpnameUseCase>(),
      locator<GetListSOUseCase>(),
    ),
  );
  locator.registerFactory(
    () => MainMenuProvider(
      locator<GetDashboardStatsUseCase>(),
    ),
  );
  locator.registerFactory(
    () => ProductListProvider(
      repository: locator<ProductRepository>(),
    ),
  );
}