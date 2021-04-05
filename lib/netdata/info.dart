class Info {
  List<String> mirroredHosts;

  Info fromJson(Map<String, dynamic> json) {
    mirroredHosts = (json['mirrored_hosts'] as List)?.map((e) => e as String)?.toList();
    return this;
  }
}