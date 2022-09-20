import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/loading_widget.dart';
import '../../common/helpers.dart';
import '../../common/my_search_bar.dart';
import '../../common/styles.dart';
import '../../controllers/friends_page_controller.dart';

class FriendsPage extends GetView<FriendsPageController> {
  FriendsPage({Key? key}) : super(key: key);
  static const id = '/FriendsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          //_showBottomSheet();
        },
      ),
      appBar: myAppBar(goBack: true, title: 'Friends', actions: [
        MyAnimSearchBar(
          width: context.width,
          onSuffixTap: () {
            controller.searchController.clear();
          },
          closeSearchOnSuffixTap: true,
          textController: controller.searchController,
        ),
      ]),
      body: GetX<FriendsPageController>(
        initState: (state) {
          controller.loadFriendsList();
        },
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                ((controller.isLoading.value == false &&
                        controller.filteredList.isEmpty))
                    ? Center(
                        child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("No Friend Found",
                              style: AppTextStyles.textStyleBoldBodyMedium),
                          InkWell(
                            onTap: () {
                              controller.filteredList.clear();
                              controller.friendsList.clear();
                              controller.loadFriendsList(showAlert: true);
                            },
                            child: Text(
                              "Refresh",
                              style: AppTextStyles.textStyleBoldBodyMedium
                                  .copyWith(
                                      decoration: TextDecoration.underline),
                            ),
                          ),
                        ],
                      ))
                    : RefreshIndicator(
                        onRefresh: () {
                          controller.filteredList.clear();
                          controller.friendsList.clear();
                          controller.loadFriendsList(showAlert: true);
                          return Future.delayed(const Duration(seconds: 2));
                        },
                        child: ListView.builder(
                          itemCount: controller.filteredList.length,
                          controller: controller.listViewController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return getFriendItemCard(index: index);
                          },
                        ),
                      ),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget getFriendItemCard({required int index}) {
    return Card(
      child: ListTile(
        title: Text(
          controller.filteredList.elementAt(index).friendFk?.username ?? '-',
          style: AppTextStyles.textStyleNormalBodyMedium,
        ),
      ),
    );
  }
}
