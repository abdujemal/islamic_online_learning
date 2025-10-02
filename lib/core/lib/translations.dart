class Translations {
  static final Map<String, String> translation = {
    "Friday": "ጁምዓ",
    "Saturday": "ቅዳሜ",
    "Sunday": "እሁድ",
    "Male": "ወንድ",
    "Female": "ሴት",
    "below30": "ከ30 በታች",
    "below50": "ከ50 በታች",
    "above50": "ከ50 በላይ",
    "AfterSubhi": "ከሱብሂ በኋላ",
    "AfterZuhur": "ከዙሁር በኋላ",
    "AfterAsr": "ከአስር በኋላ",
    "AfterMeghrib": "ከመግሪብ በኋላ",
    "AfterEsha": "ከኢሻ በኋላ",
  };
  static String get(String key) {
    return translation[key] ?? "";
  }
}
