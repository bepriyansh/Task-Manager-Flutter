import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:taskmanager/components/notification.dart';
import 'package:taskmanager/components/theme.dart';
import 'package:taskmanager/components/widget/button.dart';
import 'package:taskmanager/components/widget/input_field.dart';
import 'package:taskmanager/controllers/task_controller.dart';
import 'package:taskmanager/models/task.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  int _selectedRemind = 0;
  List<int> remindList = [0, 5, 10, 15, 20];
  String _selectedRepeat = "Never";
  List<String> repeatList = ["Never", "Daily", "Weekly", "Monthly", "Yearly"];
  int _selectedColor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyInputField(
                title: "Title",
                hint: "Enter title here...",
                controller: _titleController,
              ),
              MyInputField(
                title: "Note",
                hint: "Enter note here...",
                controller: _noteController,
              ),
              MyInputField(
                title: "Date",
                hint: DateFormat.yMMMMEEEEd().format(_selectedDate),
                widget: IconButton(
                    onPressed: () {
                      _getDateFromUser();
                    },
                    icon: const Icon(Icons.calendar_month_rounded)),
              ),
              Row(
                children: [
                  Expanded(
                    child: MyInputField(
                      title: "Start Time",
                      hint: _startTime,
                      widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser("startTime");
                          },
                          icon: const Icon(Icons.access_time)),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Expanded(
                    child: MyInputField(
                      title: "End Time",
                      hint: _endTime,
                      widget: IconButton(
                          onPressed: () {
                            _getTimeFromUser("endTime");
                          },
                          icon: const Icon(Icons.access_time)),
                    ),
                  ),
                ],
              ),
              MyInputField(
                title: "Remind",
                hint: "$_selectedRemind minutes early",
                widget: DropdownButton(
                    padding: const EdgeInsets.only(right: 14),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconSize: 32,
                    elevation: 4,
                    underline: Container(
                      height: 0,
                    ),
                    items: remindList
                        .map<DropdownMenuItem<String>>((int remindValue) {
                      return DropdownMenuItem<String>(
                        value: remindValue.toString(),
                        child: Text(remindValue.toString()),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRemind = int.parse(newValue!);
                      });
                    }),
              ),
              MyInputField(
                title: "Repeat",
                hint: _selectedRepeat,
                widget: DropdownButton(
                    padding: const EdgeInsets.only(right: 14),
                    icon: const Icon(Icons.keyboard_arrow_down),
                    iconSize: 32,
                    elevation: 4,
                    underline: Container(
                      height: 0,
                    ),
                    items: repeatList
                        .map<DropdownMenuItem<String>>((String repeatValue) {
                      return DropdownMenuItem<String>(
                        value: repeatValue.toString(),
                        child: Text(repeatValue.toString()),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedRepeat = newValue!;
                      });
                    }),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorSelector(),
                  MyButton(
                      label: "Create Task",
                      onTap: () => _validateForm(),
                      icon: false)
                ],
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _validateForm() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDB();
      Get.back();
      _taskController.getTasks();
      Get.snackbar(
        "Done!",
        "Task added successfully!",
        snackPosition: SnackPosition.TOP,
        colorText: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        icon: Icon(
          Icons.done,
          size: 30,
          color: Theme.of(context).colorScheme.surface,
        ),
      );
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "All fields are mandatory",
        "Please fill all the fields",
        snackPosition: SnackPosition.TOP,
        colorText: Theme.of(context).colorScheme.surface,
        backgroundColor: Theme.of(context).colorScheme.inverseSurface,
        icon: Icon(
          Icons.warning,
          size: 30,
          color: Theme.of(context).colorScheme.surface,
        ),
      );
    }
  }

  _addTaskToDB() async {
    int id = await _taskController.addTask(
        task: TaskToDo(
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: 0,
      selectedDate: DateFormat.yMMMEd().format(_selectedDate).toString(),
      startTime: _startTime,
      endTime: _endTime,
      selectedRemind: _selectedRemind,
      selectedRepeat: _selectedRepeat,
      selectedColor: _selectedColor,
    ));

    _scheduleNotification(id, _titleController.text, _noteController.text);
  }

  _scheduleNotification(int id, String title, String body) {
    int hoursToAdd = 0;
    int minutesToAdd = 0;
    if (_startTime.substring(1, 2) == ":") {
      hoursToAdd = int.parse(_startTime.substring(0, 1));
      minutesToAdd = int.parse(_startTime.substring(2, 5));
    } else {
      hoursToAdd = int.parse(_startTime.substring(0, 2));
      minutesToAdd = int.parse(_startTime.substring(3, 5));
    }
    if (_startTime.endsWith("PM")) {
      hoursToAdd += 12;
    }
    if (_startTime.endsWith("AM") && hoursToAdd == 12) {
      hoursToAdd = 0;
    }
    DateTime scheduleTime = _selectedDate;
    if (scheduleTime.hour != 0 ||
        scheduleTime.minute != 0 ||
        scheduleTime.second != 0) {
      scheduleTime = scheduleTime.subtract(Duration(
          hours: scheduleTime.hour,
          minutes: scheduleTime.minute,
          seconds: scheduleTime.second));
    }
    scheduleTime =
        scheduleTime.add(Duration(hours: hoursToAdd, minutes: minutesToAdd));
    scheduleTime = scheduleTime.subtract(Duration(minutes: _selectedRemind));

    debugPrint(scheduleTime.toString());
    NotificationServices().scheduleNotification(
        id: id,
        title: title,
        body: body,
        scheduledNotificationDateTime: scheduleTime);
  }

  _appBar(BuildContext context) {
    return AppBar(
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Icon(
          Icons.arrow_back_ios,
          size: 23,
          color: Theme.of(context).colorScheme.inverseSurface,
        ),
      ),
      title: Text(
        "Add Task",
        style: headingStyle,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
    );
  }

  _getDateFromUser() async {
    DateTime? pickerDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2022),
        lastDate: DateTime(2100));

    if (pickerDate != null) {
      setState(() {
        _selectedDate = pickerDate;
      });
    }
  }

  _getTimeFromUser(String actionName) async {
    TimeOfDay? pickedTime = await _showTimePicker();

    if (pickedTime != null) {
      String formattedTime = pickedTime.format(context).toString();

      if (actionName == "startTime") {
        setState(() {
          _startTime = formattedTime;
        });
      } else {
        setState(() {
          _endTime = formattedTime;
        });
      }
    }
  }

  _showTimePicker() {
    return showTimePicker(
        context: context,
        initialTime: TimeOfDay(
            hour: DateTime.now().hour, minute: DateTime.now().minute));
  }

  _colorSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(
          height: 5,
        ),
        Wrap(
          children: List<Widget>.generate(3, (int index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: (Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  radius: 14,
                  backgroundColor: index == 0
                      ? primaryColor
                      : index == 1
                          ? pinkColor
                          : yellowColor,
                  child: index == _selectedColor
                      ? const Icon(
                          Icons.done,
                          color: whiteColor,
                        )
                      : Container(),
                ),
              )),
            );
          }),
        )
      ],
    );
  }
}
