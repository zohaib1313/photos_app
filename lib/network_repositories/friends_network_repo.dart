import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:photos_app/dio_networking/api_response.dart';

import '../common/app_pop_ups.dart';
import '../dio_networking/api_client.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';
import '../models/friends_list_model_response.dart';

class FriendsNetworkRepo {
  static final FriendsNetworkRepo _singleton = FriendsNetworkRepo._internal();

  factory FriendsNetworkRepo() {
    return _singleton;
  }

  FriendsNetworkRepo._internal();

  ///loading friends from server....
  static Future<APIResponse<FriendsListModelResponse>?> loadFriendsFromServer(
      {required Map<String, dynamic> queryMap}) async {
    var result = await APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
        .request(
            route: APIRoute(
              APIType.getAllFriends,
              body: queryMap,
            ),
            create: () => APIResponse<FriendsListModelResponse>(
                create: () => FriendsListModelResponse()),
            apiFunction: loadFriendsFromServer);
    return result.response;
  }

  static Future<APIResponse?> removeFriend(
      {required Map<String, dynamic> data}) async {
    var result =
        await APIClient(isCache: false, baseUrl: ApiConstants.baseUrl).request(
            needToAuthenticate: true,
            route: APIRoute(
              APIType.deleteFriendRequest,
              body: data,
            ),
            create: () => APIResponse(decoding: false),
            apiFunction: removeFriend);
    return result.response;
  }
}
