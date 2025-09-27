import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/features/auth/login/data/models/auth_response_model.dart';
import 'package:ecommerce/features/basket/data/models/basket_response_model.dart';
import 'package:ecommerce/features/basket/data/repo/basket_repo.dart';
import 'package:ecommerce/features/basket/data/models/basket_item_model.dart';
import 'package:ecommerce/features/basket/data/models/basket_request_model.dart';
import 'package:meta/meta.dart';

part 'basket_state.dart';

class BasketCubit extends Cubit<BasketState> {
  BasketCubit({required this.basketRepo}) : super(BasketInitial());
  final BasketRepo basketRepo;
  List<BasketItemModel> basketItems = [];

  Future<void> initBasketItems() async {
    try {
      BasketResponseModel basket = await basketRepo.getBasketByCustomerId();
      basketItems = basket.basketItems ?? [];
    } catch (e) {
      print("Error init basket items in initBasketItems: $e");
    }
  }

  Future<void> addItemToBasket({required BasketRequestModel item}) async {
    try {
      await basketRepo.addOrUpdateCustomerBasket(item);
      emit(BasketItemAddedSuccess(message: 'Item added to basket!'));
      await getBasketByCustomerId();
    } catch (e) {
      emit(BasketItemAddedError(message: extractMessage(e)));
    }
  }

  Future<void> removeItemFromBasket({
    required String basketId,
    required String productId,
  }) async {
    try {
      await basketRepo.deleteItemFromBasketByProductId(
        basketId: basketId,
        productId: productId,
      );
      emit(BasketItemRemovedSuccess(message: 'Item removed from basket!'));
      await getBasketByCustomerId();
    } catch (e) {
      emit(BasketItemRemovedError(message: extractMessage(e)));
    }
  }

  Future<void> updateItemQuantity({
    required String basketId,
    required String productId,
    required bool increase,
  }) async {
    try {
      BasketResponseModel updatedBasket;
      if (increase) {
        updatedBasket = await basketRepo.increaseBasketItem(
          basketId: basketId,
          productId: productId,
        );
      } else {
        updatedBasket = await basketRepo.decreaseBasketItem(
          basketId: basketId,
          productId: productId,
        );
      }
      emit(BasketItemQuantityUpdatedSuccess(message: 'Item quantity updated!'));
      await getBasketByCustomerId();
    } catch (e) {
      emit(BasketItemOperationError(message: extractMessage(e)));
    }
  }

  // Future<void> validateDiscountCode(String code) async {
  //   // emit(BasketLoading());
  //   try {
  //     AuthResponseModel response = await basketRepo.validateDiscount(code);
  //     emit(DiscountValidated(message: response.message));
  //     getBasketByCustomerId();
  //   } catch (e) {
  //     emit(BasketError(message: extractMessage(e)));
  //   }
  // }
  Future<void> mergeBasketWithGuestBasket({required String guestId}) async {
    try {
      await basketRepo.mergeBasketWithGuestBasket(guestId: guestId);
      await getBasketByCustomerId();
    } catch (e) {
      emit(BasketError(message: extractMessage(e)));
    }
  }

  Future<void> applyDiscountCode({
    required String code,
    required String basketId,
  }) async {
    emit(ApplyDiscountCodeLoading());
    try {
      await basketRepo.validateDiscount(code);
      BasketResponseModel response = await basketRepo.applyDiscount(
        basketId: basketId,
        code: code,
      );
      emit(BasketLoaded(basketModel: response));
      // getBasketByCustomerId();
    } catch (e) {
      emit(ApplyDiscountCodeError(message: extractMessage(e)));
    }
  }

  Future<void> getBasketByCustomerId() async {
    emit(BasketLoading());
    try {
      BasketResponseModel basket = await basketRepo.getBasketByCustomerId();
      basketItems = basket.basketItems ?? [];
      emit(BasketLoaded(basketModel: basket));
    } catch (e) {
      emit(BasketError(message: extractMessage(e)));
    }
  }

  /// Helper
  String extractMessage(Object e) {
    return e.toString().replaceFirst('Exception: ', '');
  }
}
