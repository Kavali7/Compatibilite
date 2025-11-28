class PartnerInput {
  PartnerInput({
    required this.name,
    required this.birthDate,
    this.role,
  });

  final String name;
  final DateTime birthDate;
  final String? role;
}

class ContextInfo {
  ContextInfo({
    this.meetingDate,
    this.durationText,
    this.challenges = const [],
  });

  final DateTime? meetingDate;
  final String? durationText;
  final List<String> challenges;
}

class PartnerReport {
  PartnerReport({
    required this.input,
    required this.nameNumber,
    required this.lifePath,
    required this.kabbalahNumber,
    required this.intimateNumber,
    required this.personalityNumber,
    required this.heredityNumber,
    required this.personalYear,
    required this.personalMonth,
    required this.personalDay,
  });

  final PartnerInput input;
  final int nameNumber;
  final int lifePath;
  final int kabbalahNumber;
  final int intimateNumber;
  final int personalityNumber;
  final int heredityNumber;
  final int personalYear;
  final int personalMonth;
  final int personalDay;
}

class CompatibilitySummary {
  CompatibilitySummary({
    required this.partnerA,
    required this.partnerB,
    required this.coupleNumber,
    required this.coupleDailyNumber,
    required this.generatedAt,
  });

  final PartnerReport partnerA;
  final PartnerReport partnerB;
  final int coupleNumber;
  final int coupleDailyNumber;
  final DateTime generatedAt;
}
