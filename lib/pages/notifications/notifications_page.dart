import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/models/notification_response_model.dart';

import '../../common/helpers.dart';
import '../../common/loading_widget.dart';
import '../../common/styles.dart';
import '../../controllers/notification_controller.dart';

class NotificationsPage extends GetView<NotificationsController> {
  const NotificationsPage({Key? key}) : super(key: key);
  static const id = '/NotificationsPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(title: 'Notifications', goBack: true),
      body: GetX<NotificationsController>(
        initState: (state) {},
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
                          Text("No Record Found",
                              style: AppTextStyles.textStyleBoldBodyMedium),
                          InkWell(
                            onTap: () {
                              controller.clearLists();
                              controller.loadNotifications(showAlert: true);
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
                          controller.clearLists();
                          controller.loadNotifications(showAlert: true);
                          return Future.delayed(const Duration(seconds: 2));
                        },
                        child: ListView.builder(
                          itemCount: controller.filteredList.length,
                          controller: controller.listViewController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return gtNotificationItem(
                                model:
                                    controller.filteredList.elementAt(index));
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

  Widget gtNotificationItem({required NotificationModel model}) {
    return Card(
      child: Dismissible(
        key: UniqueKey(),
        background: const Icon(
          Icons.delete,
          color: Colors.red,
        ),
        onDismissed: (direction) {
          controller.deleteNotification(notification: model);
        },
        child: ListTile(
          title: Text(model.title ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.textStyleBoldBodyXSmall),
          subtitle: Text(model.title ?? '',
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.textStyleNormalBodyXSmall),
          trailing:
              Text(formatDateTime(DateTime.tryParse(model.createdAt ?? ''))),
        ),
      ),
    );
  }
}
