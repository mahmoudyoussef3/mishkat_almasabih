class HistoryItem {
  final String title;
  final String date;
  final String time;

  HistoryItem({
    required this.title,
    required this.date,
    required this.time,
  });

  // Convert object to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': date,
      'time': time,
    };
  }

  // Convert Map to object
  factory HistoryItem.fromMap(Map<String, dynamic> map) {
    return HistoryItem(
      title: map['title'],
      date: map['date'],
      time: map['time'],
    );
  }
}
