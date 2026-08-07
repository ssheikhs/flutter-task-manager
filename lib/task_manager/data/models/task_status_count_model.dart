// {
//   "_id": "New",
//   "sum": 3
// }
//
// Field names kept exactly as `sId` / `sum` to match the confirmed usage
// seen in the source (`taskCountList[index].sId`, `taskCountList[index].sum`).

class TaskStatusCountModel {
  String? sId;
  int? sum;

  TaskStatusCountModel({this.sId, this.sum});

  factory TaskStatusCountModel.fromJson(Map<String, dynamic> jsonData) {
    return TaskStatusCountModel(
      sId: jsonData['_id'],
      sum: jsonData['sum'],
    );
  }
}
