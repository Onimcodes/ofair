 
 import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ofair/common/routing/router_config.dart';
import 'package:ofair/common/routing/router_names.dart';


 class AppRouter {


  static Future<T?> go<T>(
    context,
    RouterNames routerName, {
    Map<String, String> pathParameters = const {},
    }) {
      return GoRouter.of(context).pushNamed<T>(routerName.name,
      pathParameters: pathParameters
      );
    }


    
  static GoRouter config = routerConfig;
 }