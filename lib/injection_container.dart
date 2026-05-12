import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/locale_cubit.dart';
import 'data/datasources/api_client.dart';
import 'data/repositories/menu_repository.dart';
import 'data/repositories/order_repository.dart';
import 'presentation/menu/cubit/menu_cubit.dart';
import 'presentation/cart/cubit/cart_cubit.dart';
import 'presentation/order/cubit/order_cubit.dart';

final GetIt sl = GetIt.instance;

void setupDependencies(SharedPreferences prefs) {
  // External
  sl.registerSingleton<SharedPreferences>(prefs);

  // Data sources
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Repositories
  sl.registerLazySingleton<MenuRepository>(() => MenuRepository(sl()));
  sl.registerLazySingleton<OrderRepository>(() => OrderRepository(sl()));

  // Cubits
  sl.registerSingleton<LocaleCubit>(LocaleCubit(sl()));
  sl.registerFactory<MenuCubit>(() => MenuCubit(sl()));
  sl.registerSingleton<CartCubit>(CartCubit()); // Singleton to persist cart across screens
  sl.registerFactory<OrderCubit>(() => OrderCubit(sl()));
}
