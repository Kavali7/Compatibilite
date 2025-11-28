import 'package:compatibilite_app/models/compatibility_models.dart';

class NumerologyService {
  static const Map<String, int> _letterValues = {
    'A': 1,
    'J': 1,
    'S': 1,
    'B': 2,
    'K': 2,
    'T': 2,
    'C': 3,
    'L': 3,
    'U': 3,
    'D': 4,
    'M': 4,
    'V': 4,
    'E': 5,
    'N': 5,
    'W': 5,
    'F': 6,
    'O': 6,
    'X': 6,
    'G': 7,
    'P': 7,
    'Y': 7,
    'H': 8,
    'Q': 8,
    'Z': 8,
    'I': 9,
    'R': 9,
  };

  String _normalizeName(String name) {
    final accentMap = {
      'à': 'a',
      'á': 'a',
      'â': 'a',
      'ä': 'a',
      'ã': 'a',
      'å': 'a',
      'æ': 'ae',
      'ç': 'c',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'í': 'i',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'ñ': 'n',
      'ó': 'o',
      'ò': 'o',
      'ô': 'o',
      'ö': 'o',
      'õ': 'o',
      'ú': 'u',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ý': 'y',
      'ÿ': 'y',
      'œ': 'oe',
    };
    final buffer = StringBuffer();
    for (final rune in name.runes) {
      final char = String.fromCharCode(rune);
      final lower = char.toLowerCase();
      if (accentMap.containsKey(lower)) {
        buffer.write(accentMap[lower]);
      } else {
        buffer.write(lower);
      }
    }
    final cleaned = buffer.toString().toUpperCase();
    final lettersOnly = cleaned.replaceAll(RegExp(r'[^A-Z]'), '');
    return lettersOnly;
  }

  int reduceToDigit(int value, {bool allowMasters = true}) {
    var current = value.abs();
    while (current > 9 && !(allowMasters && (current == 11 || current == 22 || current == 33))) {
      current = current
          .toString()
          .split('')
          .map(int.parse)
          .fold<int>(0, (sum, digit) => sum + digit);
    }
    return current;
  }

  int nameNumber(String rawName) {
    final normalized = _normalizeName(rawName);
    final total = normalized.split('').fold<int>(0, (sum, letter) {
      return sum + (_letterValues[letter] ?? 0);
    });
    return reduceToDigit(total);
  }

  int kabbalahNumber(String rawName) {
    final normalized = _normalizeName(rawName);
    final total = normalized.split('').fold<int>(0, (sum, letter) {
      final code = letter.codeUnitAt(0);
      return sum + (code - 64); // A=1, Z=26
    });
    final remainder = total % 9;
    return remainder == 0 ? 9 : remainder;
  }

  int intimateNumber(String rawName) {
    final normalized = _normalizeName(rawName);
    const vowels = {'A', 'E', 'I', 'O', 'U', 'Y'};
    final total = normalized.split('').where((c) => vowels.contains(c)).fold<int>(0, (sum, letter) {
      return sum + (_letterValues[letter] ?? 0);
    });
    return reduceToDigit(total);
  }

  int personalityNumber(String rawName) {
    final normalized = _normalizeName(rawName);
    const vowels = {'A', 'E', 'I', 'O', 'U', 'Y'};
    final total = normalized.split('').where((c) => !vowels.contains(c)).fold<int>(0, (sum, letter) {
      return sum + (_letterValues[letter] ?? 0);
    });
    return reduceToDigit(total);
  }

  int heredityNumber(String rawName) {
    final parts = rawName.trim().split(RegExp(r'\\s+')).where((p) => p.isNotEmpty).toList();
    final lastName = parts.isNotEmpty ? parts.last : rawName;
    final normalized = _normalizeName(lastName);
    final total = normalized.split('').fold<int>(0, (sum, letter) {
      return sum + (_letterValues[letter] ?? 0);
    });
    return reduceToDigit(total);
  }

  int lifePathNumber(DateTime birthDate) {
    int reduceComponent(int value) => reduceToDigit(value, allowMasters: true);
    final day = reduceComponent(birthDate.day);
    final month = reduceComponent(birthDate.month);
    final year = reduceComponent(birthDate.year);
    final sum = day + month + year;
    return reduceToDigit(sum, allowMasters: true);
  }

  int personalYear(DateTime birthDate, DateTime referenceDate) {
    final sum = birthDate.day + birthDate.month + referenceDate.year;
    return reduceToDigit(sum);
  }

  int personalMonth(int personalYearNumber, DateTime referenceDate) {
    return reduceToDigit(personalYearNumber + referenceDate.month);
  }

  int personalDay(int personalMonthNumber, DateTime referenceDate) {
    return reduceToDigit(personalMonthNumber + referenceDate.day);
  }

  CompatibilitySummary buildSummary(
    PartnerInput partnerA,
    PartnerInput partnerB, {
    DateTime? today,
  }) {
    final now = today ?? DateTime.now();
    final reportA = _buildPartnerReport(partnerA, now);
    final reportB = _buildPartnerReport(partnerB, now);
    // Nombre du couple base sur les chemins de vie (dates de naissance) pour rester coherent avec la logique du PDF.
    final coupleNumber = reduceToDigit(reportA.lifePath + reportB.lifePath);
    final coupleDailyNumber = reduceToDigit(coupleNumber + now.day + now.month);

    return CompatibilitySummary(
      partnerA: reportA,
      partnerB: reportB,
      coupleNumber: coupleNumber,
      coupleDailyNumber: coupleDailyNumber,
      generatedAt: now,
    );
  }

  PartnerReport _buildPartnerReport(PartnerInput input, DateTime referenceDate) {
    final nameNum = nameNumber(input.name);
    final lifePath = lifePathNumber(input.birthDate);
    final kabbalah = kabbalahNumber(input.name);
    final intimate = intimateNumber(input.name);
    final personality = personalityNumber(input.name);
    final heredity = heredityNumber(input.name);
    final pYear = personalYear(input.birthDate, referenceDate);
    final pMonth = personalMonth(pYear, referenceDate);
    final pDay = personalDay(pMonth, referenceDate);

    return PartnerReport(
      input: input,
      nameNumber: nameNum,
      lifePath: lifePath,
      kabbalahNumber: kabbalah,
      intimateNumber: intimate,
      personalityNumber: personality,
      heredityNumber: heredity,
      personalYear: pYear,
      personalMonth: pMonth,
      personalDay: pDay,
    );
  }


  static const Map<int, String> _archetypes = {
    1: 'Initiateur',
    2: 'Harmoniseur',
    3: 'Cr?atif',
    4: 'Architecte',
    5: 'Explorateur',
    6: 'Gardien',
    7: 'Analyste',
    8: 'B?tisseur',
    9: 'Humaniste',
    11: 'Visionnaire',
    22: 'Strat?ge',
    33: 'Inspireur',
  };

  static const Map<int, String> _archetypeDescriptions = {
    1: 'Initie et entra?ne, aime tracer une voie claire.',
    2: 'Cr?e l??quilibre et l??coute, relie les points de vue.',
    3: 'Apporte cr?ativit? et id?es nouvelles.',
    4: 'Structure et s?curise, construit sur du solide.',
    5: 'Curieux et adaptable, aime le mouvement.',
    6: 'Protecteur, soigne le lien et la loyaut?.',
    7: 'Analytique et pos?, cherche la profondeur.',
    8: 'Orient? impact, aime mat?rialiser les projets.',
    9: 'G?n?reux et empathique, ouvert aux autres.',
    11: 'Intuitif et inspirant, voit les possibilit?s.',
    22: 'Vision longue, organise avec pragmatisme.',
    33: 'Port? par le sens, ?l?ve et rassemble.',
  };

  String archetypeLabel(int number) => _archetypes[number] ?? 'Essentiel';

  String describeBaseNumber(int number) => _archetypeDescriptions[number] ?? '';

  String describeNameNumber(int number) => _archetypeDescriptions[number] ?? '';

  String describeCoupleNumber(int number) =>
      'Votre dynamique commune : ${archetypeLabel(number)}. ${_archetypeDescriptions[number] ?? ''}';

  String describeCoupleDeep(int number) =>
      'Ce qui renforce votre lien : ${archetypeLabel(number)}. ${_archetypeDescriptions[number] ?? ''}';

  String describeIntimateNumber(int number) => _archetypeDescriptions[number] ?? '';

  String describePersonalityNumber(int number) => _archetypeDescriptions[number] ?? '';

  String describeHeredityNumber(int number) => _archetypeDescriptions[number] ?? '';

  String describeGuide(int lifePath, int expression) {
    final lifeLabel = archetypeLabel(lifePath);
    final exprLabel = archetypeLabel(expression);
    return 'Votre socle : $lifeLabel. Votre style d?expression : $exprLabel.';
  }

  String describePersonalYear(int number) =>
      'Rythme annuel : ${archetypeLabel(number)}. ${_archetypeDescriptions[number] ?? ''}';

  String describeKabbalahNumber(int number) => _archetypeDescriptions[number] ?? '';

  String describePersonalDay(int number) =>
      '?nergie du moment : ${archetypeLabel(number)}. ${_archetypeDescriptions[number] ?? ''}';

  String describeCoupleDailyAction(int number) =>
      'Focus du jour : ${archetypeLabel(number)}. ${_archetypeDescriptions[number] ?? ''}';

}
