part of 'product_fetch_cubit.dart';

@immutable
abstract class ProductFetchState {}

class ProductFetchInitial extends ProductFetchState {}

class ProductFetching extends ProductFetchState {}

class ProductFetchSuccess extends ProductFetchState {
  final Map<String, dynamic> product;
  final bool isBarcode;

  ProductFetchSuccess({
    required this.isBarcode,
    required this.product,
  });
}

class ProductFetchFail extends ProductFetchState {
  final String error;

  ProductFetchFail(this.error);
}
