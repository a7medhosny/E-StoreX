import 'package:ecommerce/app.dart';
import 'package:ecommerce/core/DI/get_it.dart';
import 'package:ecommerce/core/helpers/cache_keys.dart';
import 'package:ecommerce/core/helpers/cache_network.dart';
import 'package:ecommerce/core/helpers/token_manager.dart';
import 'package:ecommerce/core/networking/dio_factory.dart';
import 'package:ecommerce/core/routing/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:uuid/uuid.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheNetwork.cacheInitialization();
  Stripe.publishableKey =
      "pk_test_51RqXVSASbSdfeqZyGBnXXoNrgvVnRNfdNCvFXYQWaezbMy5D1zuVVHnc5ic56oZDEEDmkrs5pWsgn1Pwuwhomz4s00tEbcsxml";
  setup();

  // Initialize Dio first
  DioFactory.getDio();

  // لو فيه توكين مخزن، ضيف الانترسبتور
  if (TokenManager.token != null && TokenManager.token!.isNotEmpty) {
    DioFactory.afterLoginInterceptor();
  }

  // if (TokenManager.token == null && TokenManager.guestId == null) {
  //   final uuid = Uuid();
  //   String guestId = uuid.v4();
  //   print("Geust Id $guestId");
  //   CacheNetwork.insertToCache(key: CacheKeys.guestId, value: guestId);
  // }

  runApp(MyApp(appRouter: AppRouter()));
}
