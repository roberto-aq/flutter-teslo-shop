import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop_app/features/products/domain/domain.dart';
import 'package:teslo_shop_app/features/products/presentation/providers/providers.dart';

final productProvider = StateNotifierProvider.autoDispose
    .family<ProductNotifier, ProductState, String>((ref, productId) {
  final productsRepository = ref.watch(productsRepositoryProvider);

  return ProductNotifier(
      productsRepository: productsRepository, productId: productId);
});

class ProductNotifier extends StateNotifier<ProductState> {
  final ProductsRepository productsRepository;

  ProductNotifier({
    required this.productsRepository,
    required String productId,
  }) : super(ProductState(id: productId)) {
    loadProduct();
  }

  Product _newEmptyProduct() => Product(
      id: 'new',
      title: '',
      description: '',
      price: 0,
      slug: '',
      sizes: [],
      gender: '',
      images: [],
      stock: 0,
      tags: []);

  Future<void> loadProduct() async {
    try {
      if (state.id == 'new') {
        state = state.copyWith(
          product: _newEmptyProduct(),
          isLoading: false,
        );
        return;
      }

      final product = await productsRepository.getProductById(state.id);

      state = state.copyWith(
        product: product,
        isLoading: false,
      );
    } catch (e) {
      throw Exception('Error loading product');
    }
  }
}

class ProductState {
  final String id;
  final Product? product;
  final bool isLoading;
  final bool isSaving;

  ProductState({
    required this.id,
    this.product,
    this.isLoading = true,
    this.isSaving = false,
  });

  ProductState copyWith({
    String? id,
    Product? product,
    bool? isLoading,
    bool? isSaving,
  }) {
    return ProductState(
      id: id ?? this.id,
      product: product ?? this.product,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
