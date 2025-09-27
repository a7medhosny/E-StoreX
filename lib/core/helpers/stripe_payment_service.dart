import 'package:ecommerce/features/order/data/models/payment_response.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripePaymentService {
  // This map will hold the payment intent details received from the backend
  Map<String, dynamic>? paymentIntentData;

  // This function will handle the entire payment flow with Stripe
  static Future<void> makePayment({
    required PaymentResponse paymentResponse,
  }) async {
    try {
  
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentResponse.clientSecret,
          merchantDisplayName: 'E-StoreX',
        ),
      );

      //  Display the payment sheet to the user
      await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      if (e is StripeException) {
        // Handle Stripe specific errors
        print("Stripe Error: ${e.error.localizedMessage}");
        throw Exception("Payment Failed, try again later");
      } else {
        // Handle general errors
        print("An error occurred: $e");
        throw Exception("Payment Failed, try again later");
      }
    }
  }
}
