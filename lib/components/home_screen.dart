import 'package:taskmanager/components/task_tile.dart';
import 'package:taskmanager/controllers/task_controller.dart';
import 'package:taskmanager/models/task.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/components/notification.dart';
import 'package:taskmanager/components/tasks_page.dart';
import 'package:taskmanager/components/theme.dart';
import 'package:taskmanager/components/theme_notifier.dart';
import 'package:taskmanager/components/widget/button.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  NotificationServices notificationServices = NotificationServices();
  final ValueNotifier<int> _tasksUpdateNotifier = ValueNotifier<int>(0);
  final _taskController = Get.put(TaskController());
  String _selectedDate = DateFormat.yMMMEd().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Column(children: [
        _addTaskBar(context),
        _addDateBar(),
        const SizedBox(
          height: 10,
        ),
        _showTasks(),
      ]),
    );
  }

  _appBar(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return AppBar(
      leading: GestureDetector(
        onTap: () {
          themeNotifier.toggleTheme();
        },
        child: Icon(
          themeNotifier.isDarkMode ? Icons.light_mode : Icons.dark_mode,
          size: 23,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
      ),
      actions: [
        CircleAvatar(
          backgroundImage: const AssetImage("images/logo.png"),
          backgroundColor: Theme.of(context).colorScheme.background,
        ),
        const SizedBox(
          width: 20,
        )
      ],
      backgroundColor: Theme.of(context).colorScheme.background,
      // title: Text(widget.title),
    );
  }

  _addTaskBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 15, right: 15, top: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMEd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                "Today",
                style: headingStyle,
              ),
            ],
          ),
          MyButton(
            icon: true,
            label: 'Add task',
            onTap: () async {
              await Get.to(() => const AddTaskPage());
              _tasksUpdateNotifier
                  .value++; // Trigger a rebuild of the FutureBuilder
            },
          ),
        ],
      ),
    );
  }

  _addDateBar() {
    return Container(
      margin: const EdgeInsets.only(left: 5, top: 8),
      child: DatePicker(
        DateTime.now(),
        onDateChange: (selectedDate) {
          setState(() {
            _selectedDate = DateFormat.yMMMEd().format(selectedDate);
          });
        },
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryColor,
        dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: greyColor,
        )),
        monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: greyColor,
        )),
        dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: greyColor,
        )),
      ),
    );
  }

  _showTasks() {
    _taskController.getTasks();
    return Expanded(
      child: Obx(() {
        return AnimationLimiter(
          child: ListView.builder(
              itemCount: _taskController.taskList.length,
              itemBuilder: (_, index) {
                var task = _taskController.taskList[index];
                // print("task id : ${task.id} = ${task.selectedDate}");
                // print(" Selected Date = $_selectedDate");
                if (_selectedDate == task.selectedDate ||
                    task.selectedRepeat == "Daily" ||
                    (task.selectedRepeat == "Weekly" &&
                        task.selectedDate!
                            .startsWith(_selectedDate.substring(0, 3))) ||
                    (task.selectedRepeat == "Monthly" &&
                        task.selectedDate!.substring(8, 11) ==
                            _selectedDate.substring(8, 11)) ||
                    (task.selectedRepeat == "Yearly" &&
                        task.selectedDate!.substring(4, 11) ==
                            _selectedDate.substring(4, 11))) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: GestureDetector(
                          onTap: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        ),
                      ),
                    ),
                  );
                }
                return Container();
              }),
        );
      }),
    );
  }

  _showBottomSheet(BuildContext context, TaskToDo task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      width: double.maxFinite,
      height: 265,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(12), topRight: Radius.circular(12)),
        color: Theme.of(context).colorScheme.surface,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.secondaryContainer,
              ),
            ),
            task.isCompleted == 0
                ? _bottomSheetButton(
                    context: context,
                    label: "Task Completed",
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      _taskController.getTasks();
                      Get.back();
                    },
                    clr: primaryColor)
                : _bottomSheetButton(
                    context: context,
                    label: "Mark as Incomplete",
                    onTap: () {
                      _taskController.markTaskIncomplete(task.id!);
                      _taskController.getTasks();
                      Get.back();
                    },
                    clr: primaryColor),
            _bottomSheetButton(
                context: context,
                label: "Delete Task",
                onTap: () {
                  notificationServices.stopNotification(task.id!);
                  _taskController.delete(task);
                  _taskController.getTasks();
                  Get.back();
                },
                clr: pinkColor),
            _bottomSheetButton(
                context: context,
                label: "Close",
                onTap: () {
                  Get.back();
                },
                clr: Theme.of(context).colorScheme.secondary),
          ],
        ),
      ),
    ));
  }

  _bottomSheetButton({
    required BuildContext context,
    required String label,
    required Function()? onTap,
    required Color clr,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration:
            BoxDecoration(color: clr, borderRadius: BorderRadius.circular(12)),
        child: Center(
            child: Text(
          label,
          style: subHeadingStyle.copyWith(color: Theme.of(context).cardColor),
        )),
      ),
    );
  }
}
