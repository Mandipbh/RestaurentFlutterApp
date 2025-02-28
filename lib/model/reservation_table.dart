class TableModel {
  String id;
  int seatCount;
  bool isMerged;
  bool isBooked;

  TableModel(
      {required this.id,
      required this.seatCount,
      this.isMerged = false,
      this.isBooked = false});
}
