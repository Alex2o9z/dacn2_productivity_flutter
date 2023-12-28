import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productivity_app/layout/todo_layoutcontroller.dart';
import 'package:productivity_app/shared/componets/componets.dart';

class ArchiveEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodoLayoutController>(
      init: Get.find<TodoLayoutController>(),
      builder: (todoController) => eventsBuilder(
          tasks: todoController.archiveeventList,
          message: "No Archived Events ",
          svgimage: "assets/archived_task_svg.svg",
          context: context),
    );
  }
}
