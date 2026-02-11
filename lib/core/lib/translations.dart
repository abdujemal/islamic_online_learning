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
    "Under_13": "ከ13 በታች",
    "a13_17": "ከ13 እስከ17",
    "a18_29": "ከ18 እስከ29",
    "a30_49": "ከ30 እስከ49",
    "a50_plus": "ከ50 በላይ",
    "users_under_13_not_allowed": "ይህ መተግበሪያ ከ13 ዓመት በታች ለሆኑ ተጠቃሚዎች አይፈቀድም።",
    "H06M00_AM": "ከጧቱ 06፡00 በኢትዮ አቆጣጠር",
    "H10M00_AM": "ከጧቱ 10፡00 በኢትዮ አቆጣጠር",
    "H02M00_PM": "ከቀኑ 02፡00 በኢትዮ አቆጣጠር",
    "H06M00_PM": "ከምሽቱ 06፡00 በኢትዮ አቆጣጠር",
    "H10M00_PM": "ከምሽቱ 10፡00 በኢትዮ አቆጣጠር",
    "H02M00_AM": "ከለሊቱ 02፡00 በኢትዮ አቆጣጠር",
  };
  static String get(String key) {
    return translation[key] ?? "";
  }

  static String reverse(String value) {
    return translation.keys
        .toList()[translation.values.toList().indexOf(value)];
  }
}
