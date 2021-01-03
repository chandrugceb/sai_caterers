class Entry {
  final String entry;
  Entry({this.entry});

  factory  Entry.fromJson(Map<String, dynamic> json){
    return Entry(
      entry: json['entry']
    );
  }

  Map<String, dynamic> toMap(){
    return {
      'entry': entry
    };
  }
}