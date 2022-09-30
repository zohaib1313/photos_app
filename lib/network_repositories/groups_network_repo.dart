import 'package:photos_app/models/groups_response_model.dart';

import '../dio_networking/api_client.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';
import '../models/friends_list_model_response.dart';

class GroupNetworkRepo {
  static final GroupNetworkRepo _singleton = GroupNetworkRepo._internal();

  factory GroupNetworkRepo() {
    return _singleton;
  }

  GroupNetworkRepo._internal();

  ///loading friends from server....
  static Future<APIResponse<GroupListResponseModel>?> loadGroupsFromServer(
      {required Map<String, dynamic> queryMap}) async {
    var result = await APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
        .request(
            route: APIRoute(
              APIType.getAllGroups,
              body: queryMap,
            ),
            create: () => APIResponse<GroupListResponseModel>(
                create: () => GroupListResponseModel()),
            apiFunction: loadGroupsFromServer);
    return result.response;
  }
}
