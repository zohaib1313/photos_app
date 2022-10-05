import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:photos_app/common/app_pop_ups.dart';
import 'package:photos_app/models/group_member_response_model.dart';
import 'package:photos_app/models/groups_response_model.dart';

import '../dio_networking/api_client.dart';
import '../dio_networking/api_response.dart';
import '../dio_networking/api_route.dart';
import '../dio_networking/app_apis.dart';

class GroupNetworkRepo {
  static final GroupNetworkRepo _singleton = GroupNetworkRepo._internal();

  factory GroupNetworkRepo() {
    return _singleton;
  }

  GroupNetworkRepo._internal();

  ///loading friends from server....
  static Future<APIResponse<GroupListResponseModel>?> loadGroupsFromServer(
      {required Map<String, dynamic> queryMap}) async {
    try {
      final result =
          await APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
              .request(
                  route: APIRoute(
                    APIType.getAllGroups,
                    body: queryMap,
                  ),
                  create: () => APIResponse<GroupListResponseModel>(
                      create: () => GroupListResponseModel()),
                  apiFunction: loadGroupsFromServer);
      return result.response;
    } catch (e) {
      AppPopUps.showDialogContent(
          title: 'Error',
          description: e.toString(),
          dialogType: DialogType.ERROR);
      return null;
    }
  }

  static Future<APIListResponse<GroupMemberSearchResponseModel>?>
      searchMemberFromServer({required Map<String, dynamic> queryMap}) async {
    try {
      final result =
          await APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
              .request(
                  route: APIRoute(APIType.searchUserForGroup, body: queryMap),
                  create: () => APIListResponse<GroupMemberSearchResponseModel>(
                      create: () => GroupMemberSearchResponseModel()),
                  apiFunction: searchMemberFromServer);
      return result.response;
    } catch (e) {
      AppPopUps.showDialogContent(
          title: 'Error',
          description: e.toString(),
          dialogType: DialogType.ERROR);
      return null;
    }
  }

  ///search Members from the group
  static Future<APIResponse<GroupModel>?> addNewGroup(
      {required dio.FormData data}) async {
    try {
      final result = await APIClient(
              isCache: false, baseUrl: ApiConstants.baseUrl)
          .request(
              route: APIRoute(
                APIType.addNewGroup,
                body: data,
              ),
              create: () => APIResponse<GroupModel>(create: () => GroupModel()),
              apiFunction: addNewGroup);
      return result.response;
    } catch (e) {
      AppPopUps.showDialogContent(
          title: 'Error',
          description: e.toString(),
          dialogType: DialogType.ERROR);
      return null;
    }
  }

  ///add new group
  static Future<APIResponse<GroupModel>?> updateGroup(
      {required Map<String, dynamic> data}) async {
    try {
      final result = await APIClient(
              isCache: false, baseUrl: ApiConstants.baseUrl)
          .request(
              route: APIRoute(
                APIType.updateGroup,
                body: data,
              ),
              create: () => APIResponse<GroupModel>(create: () => GroupModel()),
              apiFunction: updateGroup);
      return result.response;
    } catch (e) {
      AppPopUps.showDialogContent(
          title: 'Error',
          description: e.toString(),
          dialogType: DialogType.ERROR);
      return null;
    }
  }

  ///delete group
  static Future<APIResponse?> deleteGroup(
      {required Map<String, dynamic> data}) async {
    try {
      final result =
          await APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
              .request(
                  route: APIRoute(
                    APIType.deleteGroup,
                    body: data,
                  ),
                  create: () => APIResponse(decoding: false),
                  apiFunction: deleteGroup);
      return result.response;
    } catch (e) {
      AppPopUps.showDialogContent(
          title: 'Error',
          description: e.toString(),
          dialogType: DialogType.ERROR);
      return null;
    }
  }

  ///delete member from group
  static Future<APIResponse?> deleteMemberFromGroup(
      {required Map<String, dynamic> data}) async {
    try {
      final result =
          await APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
              .request(
                  route: APIRoute(
                    APIType.removeMemberFromGroup,
                    body: data,
                  ),
                  create: () => APIResponse(decoding: false),
                  apiFunction: deleteGroup);
      return result.response;
    } catch (e) {
      AppPopUps.showDialogContent(
          title: 'Error',
          description: e.toString(),
          dialogType: DialogType.ERROR);
      return null;
    }
  }

  static Future<APIResponse?> addMemberInGroup(
      {required Map<dynamic, dynamic> data}) async {
    try {
      final result =
          await APIClient(isCache: false, baseUrl: ApiConstants.baseUrl)
              .request(
                  route: APIRoute(
                    APIType.addMemberInGroup,
                    body: data,
                  ),
                  create: () => APIResponse(decoding: false),
                  apiFunction: addNewGroup);
      return result.response;
    } catch (e) {
      AppPopUps.showDialogContent(
          title: 'Error',
          description: e.toString(),
          dialogType: DialogType.ERROR);
      return null;
    }
  }
}
