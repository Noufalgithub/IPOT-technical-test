import 'package:get_it/get_it.dart';
import 'data/datasources/api_client.dart';
import 'data/repositories/menu_repository.dart';
import 'data/repositories/order_repository.dart';
import 'presentation/menu/cubit/menu_cubit.dart';
import 'presentation/cart/cubit/cart_cubit.dart';
import 'presentation/order/cubit/order_cubit.dart';

final GetIt sl = GetIt.instance;

void setupDependencies() {
  // Data sources
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Repositories
  sl.registerLazySingleton<MenuRepository>(() => MenuRepository(sl()));
  sl.registerLazySingleton<OrderRepository>(() => OrderRepository(sl()));

  // Cubits - registered as factories so each page gets a fresh instance
  sl.registerFactory<MenuCubit>(() => MenuCubit(sl()));
  sl.registerSingleton<CartCubit>(CartCubit()); // Singleton to persist cart across screens
  sl.registerFactory<OrderCubit>(() => OrderCubit(sl()));
}
