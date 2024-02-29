import 'dart:convert';

import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/screens/Query/query_form.dart';
import 'package:get/get.dart';

class NotificationRedirectionHandler{
  final allowedRoutes = ['query', 'updates'];
  late String route;
  late dynamic routeParams;
  NotificationRedirectionHandler({required Map<String,dynamic> notificationPayload}){
    if(notificationPayload['route_name'] != null && notificationPayload['route_params'] != null){
      route = notificationPayload['route_name'];
      routeParams = jsonDecode(notificationPayload['route_params']);
      init();
    }
  }

  init(){
    switch(route){
      case 'query':
        if((routeParams['query_id'] == null || routeParams['query_id'] == "") ||
            (routeParams['query_type'] == null || routeParams['query_type'] == "") ||
            (routeParams['query_step'] == null || routeParams['query_step'] == "")
            ){
          return;
        }
        int queryType = int.parse(routeParams['query_type']);
        int queryId = int.parse(routeParams['query_id']);
        int queryStep = int.parse(routeParams['query_step']);
        Get.to(QueryForm(queryType, queryId: queryId, queryStep: queryStep,));
      break;
      case 'updates':
        if((routeParams['query_id'] == null || routeParams['query_id'] == "") || (routeParams['family_user_id'] == null || routeParams['family_user_id'] == "")){
          return;
        }
        String queryId = routeParams['query_id'];
        String familyId = routeParams['family_user_id'];
        Get.toNamed(Routes.confirmedQuery, arguments: {'family_user_id': familyId, 'query_id': queryId});
      break;
      default:
    }
  }


}