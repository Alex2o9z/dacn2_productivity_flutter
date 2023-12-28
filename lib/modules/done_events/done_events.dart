import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:productivity_app/layout/todo_layoutcontroller.dart';
import 'package:productivity_app/shared/componets/componets.dart';

class DoneEventScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<TodoLayoutController>(
      init: Get.find<TodoLayoutController>(),
      builder: (todoController) => eventsBuilder(
          tasks: todoController.doneeventList,
          message: "No Finished Events",
          svgimage: "assets/done_task_svg.svg",
          context: context),
    );
  }
}
