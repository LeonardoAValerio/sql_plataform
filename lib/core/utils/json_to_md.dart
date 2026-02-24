class JsonToMd {

  static String transform(List<Map<String, dynamic>> data) {
    if (data.isEmpty) return "";

    final headers = data.first.keys.toList();

    String headerRow = "| ${headers.join(" | ")} |";
    String separatorRow = "| ${headers.map((_) => "---").join(" | ")} |";

    List<String> valueRows = data.map((row) {
      final values = headers.map((h) => row[h]?.toString() ?? "").toList();
      return "| ${values.join(" | ")} |";
    }).toList();

    return "$headerRow\n$separatorRow\n${valueRows.join("\n")}";
  }
}