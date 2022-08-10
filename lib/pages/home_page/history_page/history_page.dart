import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photos_app/common/helpers.dart';
import 'package:photos_app/common/styles.dart';
import '../../../../common/loading_widget.dart';
import '../../../common/my_search_bar.dart';
import '../../../controllers/history_controller.dart';

class HistoryPage extends GetView<HistoryController> {
  HistoryPage({Key? key}) : super(key: key);
  static const id = '/HistoryPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppBar(goBack: true, title: 'History', actions: [
        MyAnimSearchBar(
          width: context.width * 0.8,
          onSuffixTap: () {
            controller.searchController.clear();
          },
          closeSearchOnSuffixTap: true,
          textController: controller.searchController,
        ),
      ]),
      body: GetX<HistoryController>(
        initState: (state) {},
        builder: (_) {
          return SafeArea(
            child: Stack(
              children: [
                ListView.builder(
                    itemCount: 10,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          leading: const CircleAvatar(
                              child: Icon(Icons.picture_as_pdf)),
                          title: Text('John doe shared a file with you',
                              style: AppTextStyles.textStyleBoldBodyXSmall),
                          subtitle: Text('file_09.pdf',
                              style: AppTextStyles.textStyleNormalBodyXSmall),
                          trailing: Text("10:11 am\n2022",
                              style: AppTextStyles.textStyleNormalBodyXSmall),
                        ),
                      );
                    }),
                if (controller.isLoading.isTrue) LoadingWidget(),
              ],
            ),
          );
        },
      ),
    );
  }
}
