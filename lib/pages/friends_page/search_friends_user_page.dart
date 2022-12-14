import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/app_utils.dart';
import 'package:photos_app/controllers/search_friends_user_controller.dart';

import '../../../../../common/loading_widget.dart';
import '../../common/common_widgets.dart';
import '../../common/helpers.dart';
import '../../common/my_search_bar.dart';
import '../../common/styles.dart';

class SearchFriendsUserPage extends GetView<SearchFriendsUserController> {
  SearchFriendsUserPage({Key? key}) : super(key: key);
  static const id = '/SearchUserPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(
          backGroundColor: AppColor.primaryColor,
          goBack: true,
          title: 'Users',
          actions: [
            MyAnimSearchBar(
              width: context.width,
              color: AppColor.primaryColor,
              iconColor: AppColor.whiteColor,
              onSuffixTap: () {
                AppUtils.unFocusKeyboard();
                controller.searchController.clear();
                controller.lastQueryUserName = '';
              },
              closeSearchOnSuffixTap: true,
              textController: controller.searchController,
            ),
          ]),
      body: GetX<SearchFriendsUserController>(
        initState: (state) {
          controller.searchController.addListener(() async {
            String query = controller.searchController.text;
            if (query.isNotEmpty) {
              if (controller.lastQueryUserName != query &&
                  controller.isLoading.isFalse) {
                controller.lastQueryUserName = query;
                controller.filteredItemList.clear();
                controller.usersList.clear();
                controller.searchForFriendFromApi(userName: query);
              }
            }
          });
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: controller.filteredItemList.length,
                  controller: controller.listViewController,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return getUserItemCard(index: index);
                  },
                ),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getUserItemCard({required int index}) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(2),
        leading: Padding(
          padding: const EdgeInsets.all(4.0),
          child: NetworkCircularImage(
              url: controller.filteredItemList
                      .elementAt(index)
                      ?.searchedUser
                      ?.photo ??
                  ''),
        ),
        title: Text(
          controller.filteredItemList
                  .elementAt(index)
                  ?.searchedUser
                  ?.username ??
              '-',
          style: AppTextStyles.textStyleNormalBodyMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: controller.filteredItemList.elementAt(index)?.status == ''
            ? SizedBox(
                width: 100,
                height: 40,
                child: TextButton(
                    onPressed: () {
                      controller.sendFriendRequest(
                          searchUserModel: controller.filteredItemList
                              .elementAt(index)
                              ?.searchedUser);
                    },
                    child: Text('Send Request',
                        style: AppTextStyles.textStyleBoldBodyMedium)),
              )
            : Text('Already friend',
                style: AppTextStyles.textStyleNormalBodyXSmall),
      ),
    );
  }
}
