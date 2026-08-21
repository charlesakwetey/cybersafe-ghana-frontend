import 'package:flutter/material.dart';

class AppColors {
  // Ghana flag colors
  static const Color ghanaRed = Color(0xFFCE1126);
  static const Color ghanaGold = Color(0xFFFCD116);
  static const Color ghanaGreen = Color(0xFF006B3F);
  static const Color ghanaBlack = Color(0xFF1A1A1A);

  // Cybersecurity-toned neutrals
  static const Color navy = Color(0xFF0F2A43);
  static const Color charcoal = Color(0xFF1C2833);
  static const Color cream = Color(0xFFF7F3E8);
  static const Color jobScamPurple = Color(0xFF6B4C9A);

  // Semantic use
  static const Color danger = ghanaRed;
  static const Color warning = ghanaGold;
  static const Color success = ghanaGreen;
  static const Color primary = navy;
}

class ScamTypes {
  static const List<Map<String, String>> all = [
    {'value': 'mobile_money', 'label': 'Mobile Money Fraud'},
    {'value': 'phishing', 'label': 'Phishing'},
    {'value': 'sim_swap', 'label': 'SIM Swap'},
    {'value': 'romance_scam', 'label': 'Romance Scam'},
    {'value': 'job_scam', 'label': 'Job Scam'},
  ];

  static String labelFor(String value) {
    return all.firstWhere(
      (type) => type['value'] == value,
      orElse: () => {'label': value},
    )['label']!;
  }
}

class GhanaRegions {
  static const List<String> all = [
    'Greater Accra',
    'Ashanti',
    'Western',
    'Central',
    'Eastern',
    'Volta',
    'Northern',
    'Upper East',
    'Upper West',
    'Bono',
    'Bono East',
    'Ahafo',
    'Western North',
    'Oti',
    'Savannah',
    'North East',
  ];
}