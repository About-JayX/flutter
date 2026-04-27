import 'dart:io';

class ReportModel {
  final List<String> selectedTypes;
  final List<File> screenshots;

  ReportModel({
    this.selectedTypes = const [],
    this.screenshots = const [],
  });

  ReportModel copyWith({
    List<String>? selectedTypes,
    List<File>? screenshots,
  }) {
    return ReportModel(
      selectedTypes: selectedTypes ?? this.selectedTypes,
      screenshots: screenshots ?? this.screenshots,
    );
  }
}

class ReportType {
  final String id;
  final String label;

  const ReportType({
    required this.id,
    required this.label,
  });
}

class ReportConfig {
  static const List<ReportType> types = [
    ReportType(id: 'daily_life', label: 'Daily Life Sharing'),
    ReportType(id: 'threats', label: 'Threats'),
    ReportType(id: 'other', label: 'Other'),
    ReportType(id: 'sexual', label: 'Sexual content'),
    ReportType(id: 'privacy', label: 'Privacy violation'),
    ReportType(id: 'hate_speech', label: 'Hate speech'),
    ReportType(id: 'spam', label: 'Spam & scams'),
    ReportType(id: 'copyright', label: 'Copyright'),
    ReportType(id: 'underage', label: 'Underage user'),
    ReportType(id: 'violence', label: 'Violence & self-harm'),
  ];

  static const int maxSelections = 3;
  static const int maxScreenshots = 6;
  static const int minScreenshots = 1;
}
