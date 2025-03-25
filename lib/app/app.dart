import 'package:bek_shop/blocs/cart/cart_bloc.dart';
import 'package:bek_shop/blocs/category/category_bloc.dart';
import 'package:bek_shop/blocs/order/order_bloc.dart';
import 'package:bek_shop/blocs/product/product_bloc.dart';
import 'package:bek_shop/blocs/search_products/search_products_bloc.dart';
import 'package:bek_shop/blocs/tab/tab_cubit.dart';
import 'package:bek_shop/data/repositories/cart_repository.dart';
import 'package:bek_shop/data/repositories/category_repository.dart';
import 'package:bek_shop/data/repositories/order_repository.dart';
import 'package:bek_shop/data/repositories/product_repository.dart';
import 'package:bek_shop/data/repositories/upload_image_repository.dart';
import 'package:bek_shop/data/repositories/yandex_geo_repository.dart';
import 'package:bek_shop/screens/router.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (context) => CategoryRepository(firebaseFirestore: _firestore)),
        RepositoryProvider(create: (context) => UploadImageRepository()),
        RepositoryProvider(create: (context) => ProductRepository(firebaseFirestore: _firestore)),
        RepositoryProvider(create: (context) => CartRepository()),
        RepositoryProvider(create: (context) => YandexGeoRepository()),
        RepositoryProvider(create: (context) => OrderRepository(firebaseFirestore: _firestore)),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => SearchProductsBloc(context.read<ProductRepository>())),
          BlocProvider(
            create:
                (context) =>
                    OrderBloc(context.read<OrderRepository>(), context.read<ProductRepository>()),
          ),
          BlocProvider(create: (context) => TabCubit()),
          BlocProvider(
            create:
                (context) => CategoryBloc(
                  context.read<CategoryRepository>(),
                  context.read<UploadImageRepository>(),
                ),
          ),
          BlocProvider(create: (context) => CartBloc(context.read<CartRepository>())),
          BlocProvider(
            create:
                (context) => ProductBloc(
                  context.read<ProductRepository>(),
                  context.read<UploadImageRepository>(),
                ),
          ),
        ],
        child: MyApp(),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Bek Shop',
          theme: ThemeData(
            fontFamily: "YandexSans",
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(backgroundColor: Colors.white),
          ),
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.generateRoute,
          initialRoute: AppRouterNames.splashRoute,
        );
      },
    );
  }
}
