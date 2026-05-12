import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/models/category_model.dart';
import '../../../data/repositories/menu_repository.dart';
import '../../../core/error/error_mapper.dart';
import '../../../core/error/exceptions.dart';

// States
abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {}

class MenuLoading extends MenuState {}

class MenuLoaded extends MenuState {
  final List<CategoryModel> categories;
  final String tableId;
  final String searchQuery;

  const MenuLoaded({
    required this.categories,
    required this.tableId,
    this.searchQuery = '',
  });

  List<CategoryModel> get filteredCategories {
    if (searchQuery.isEmpty) return categories;
    return categories
        .map((cat) => CategoryModel(
              id: cat.id,
              name: cat.name,
              imageUrl: cat.imageUrl,
              sortOrder: cat.sortOrder,
              items: cat.items
                  .where((item) =>
                      item.name
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()) ||
                      item.description
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase()))
                  .toList(),
            ))
        .where((cat) => cat.items.isNotEmpty)
        .toList();
  }

  MenuLoaded copyWith({String? searchQuery}) {
    return MenuLoaded(
      categories: categories,
      tableId: tableId,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [categories, tableId, searchQuery];
}

class MenuError extends MenuState {
  final AppException exception;

  const MenuError(this.exception);

  @override
  List<Object?> get props => [exception];
}

// Cubit
class MenuCubit extends Cubit<MenuState> {
  final MenuRepository _menuRepository;

  MenuCubit(this._menuRepository) : super(MenuInitial());

  Future<void> loadMenu(String tableId) async {
    emit(MenuLoading());
    try {
      final categories = await _menuRepository.getMenu(tableId);
      emit(MenuLoaded(categories: categories, tableId: tableId));
    } on AppException catch (e) {
      emit(MenuError(e));
    } catch (e) {
      emit(MenuError(ErrorMapper.map(e)));
    }
  }

  void searchMenu(String query) {
    final currentState = state;
    if (currentState is MenuLoaded) {
      emit(currentState.copyWith(searchQuery: query));
    }
  }

  void clearSearch() {
    final currentState = state;
    if (currentState is MenuLoaded) {
      emit(currentState.copyWith(searchQuery: ''));
    }
  }
}
