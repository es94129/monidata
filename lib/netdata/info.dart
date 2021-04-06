class Info {
  List<String> mirroredHosts;
  int warnings;
  int criticals;

  Info fromJson(Map<String, dynamic> json) {
    mirroredHosts = (json['mirrored_hosts'] as List)?.map((e) => e as String)?.toList();
    warnings = json['alarms']['warning'] as int;
    criticals = json['alarms']['critical'] as int;
    return this;
  }
}