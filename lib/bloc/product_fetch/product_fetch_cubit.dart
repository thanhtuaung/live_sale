import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:live_sale/business/api_repo/product_api_repo/product_api_repo.dart';

part 'product_fetch_state.dart';

class ProductFetchCubit extends Cubit<ProductFetchState> {
  ProductFetchCubit() : super(ProductFetchInitial());

  void productFetch(String serialOrBarcode) async {
    try {
      Map<String, dynamic> value =
          await ProductApiRepo().getProduct(serialOrBarcode);

      if (value['result'].isEmpty) {
        emit(ProductFetchFail('Not found'));
      } else {
        emit(ProductFetchSuccess(
            product: value['result'].first,
            isBarcode: !serialOrBarcode.startsWith('000')));
      }
    } on Exception catch (e) {
      emit(ProductFetchFail('Connection error'));
    }
  }
}
