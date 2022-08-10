import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/models/notification_model.dart';

import '../../common/app_utils.dart';
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
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: GetX<NotificationsController>(
            initState: (state) {},
            builder: (context) {
              controller.temp.value;
              return StreamBuilder(
                stream: controller.notificationStreamController.stream,
                builder:
                    (context, AsyncSnapshot<List<NotificationModel>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingWidget();
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Something went wrong',
                        style: AppTextStyles.textStyleBoldBodyMedium,
                      ),
                    );
                  }

                  if ((snapshot.data?.length ?? 0) < 1) {
                    return Center(
                      child: Text('No recent notification',
                          style: AppTextStyles.textStyleBoldBodyMedium),
                    );
                  }

                  return ListView.builder(
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        NotificationModel? notificationModel =
                            snapshot.data?[index];
                        return Card(
                          color: (notificationModel?.isRead ?? false)
                              ? AppColor.whiteColor
                              : AppColor.alphaGrey,
                          elevation: 10,
                          child: ListTile(
                            onTap: () {
                              ///click on the notification....
                            },
                            contentPadding: const EdgeInsets.all(15),
                            title: Text(notificationModel?.title ?? ''),
                            subtitle: Text(notificationModel?.body ?? ''),
                            trailing: Text(AppUtils.readTimestamp(
                                DateTime.now().millisecondsSinceEpoch)),
                          ),
                        );
                      });
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
