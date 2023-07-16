class TaskToDo {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? selectedDate;
  String? startTime;
  String? endTime;
  int? selectedRemind;
  String? selectedRepeat;
  int? selectedColor;

  TaskToDo({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.selectedDate,
    this.startTime,
    this.endTime,
    this.selectedRemind,
    this.selectedRepeat,
    this.selectedColor,
  });
  factory TaskToDo.fromJson(Map<String, dynamic> json) {
    return TaskToDo(
      id: json['id'],
      title: json['title'],
      note: json['note'],
      isCompleted: json['isCompleted'],
      selectedDate: json['selectedDate'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      selectedRemind: json['selectedRemind'],
      selectedRepeat: json['selectedRepeat'],
      selectedColor: json['selectedColor'],
    );
  }

  // TaskToDo.fromJson(Map<String, dynamic> json) {
  //   id = json[id];
  //   title = json[title];
  //   note = json[note];
  //   isCompleted = json[isCompleted];
  //   selectedDate = json[selectedDate];
  //   startTime = json[startTime];
  //   endTime = json[endTime];
  //   selectedRemind = json[selectedRemind];
  //   selectedRepeat = json[selectedRepeat];
  //   selectedColor = json[selectedColor];
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["id"] = id;
    data["title"] = title;
    data["note"] = note;
    data["isCompleted"] = isCompleted;
    data["selectedDate"] = selectedDate;
    data["startTime"] = startTime;
    data["endTime"] = endTime;
    data["selectedRemind"] = selectedRemind;
    data["selectedRepeat"] = selectedRepeat;
    data["selectedColor"] = selectedColor;

    return data;
  }
}
