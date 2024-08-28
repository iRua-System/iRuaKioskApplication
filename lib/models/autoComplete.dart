class AutoCompleteText {
  final List<String> texts;

  AutoCompleteText(this.texts);

  List<String> getSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(texts);
    matches.retainWhere(
        (element) => element.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
