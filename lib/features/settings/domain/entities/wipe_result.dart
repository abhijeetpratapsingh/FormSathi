import 'package:equatable/equatable.dart';

class WipeResult extends Equatable {
  const WipeResult({
    required this.deletedInfo,
    required this.deletedDocumentRecords,
    required this.deletedDocumentFiles,
    required this.deletedProcessedRecords,
    required this.deletedProcessedFiles,
    this.failedPaths = const [],
  });

  final bool deletedInfo;
  final int deletedDocumentRecords;
  final int deletedDocumentFiles;
  final int deletedProcessedRecords;
  final int deletedProcessedFiles;
  final List<String> failedPaths;

  bool get isComplete => failedPaths.isEmpty;

  @override
  List<Object?> get props => [
    deletedInfo,
    deletedDocumentRecords,
    deletedDocumentFiles,
    deletedProcessedRecords,
    deletedProcessedFiles,
    failedPaths,
  ];
}
