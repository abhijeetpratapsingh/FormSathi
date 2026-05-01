import 'package:equatable/equatable.dart';

import '../../../documents/domain/entities/saved_document.dart';
import '../../../my_info/domain/entities/user_info.dart';
import '../../../tools/domain/entities/processed_file.dart';

enum HomeStatus { initial, loading, ready, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.userInfo = const UserInfo(),
    this.documents = const [],
    this.recentFiles = const [],
    this.errorMessage,
  });

  final HomeStatus status;
  final UserInfo userInfo;
  final List<SavedDocument> documents;
  final List<ProcessedFile> recentFiles;
  final String? errorMessage;

  bool get hasUserInfo => !userInfo.isEmpty;
  bool get hasDocuments => documents.isNotEmpty;
  bool get isLoading => status == HomeStatus.loading;

  SavedDocument? get latestDocument =>
      documents.isEmpty ? null : documents.first;

  ProcessedFile? get latestProcessedFile =>
      recentFiles.isEmpty ? null : recentFiles.first;

  int get completedInfoFieldCount {
    final values = [
      userInfo.fullName,
      userInfo.fatherName,
      userInfo.motherName,
      userInfo.gender,
      userInfo.phone,
      userInfo.email,
      userInfo.address,
      userInfo.city,
      userInfo.state,
      userInfo.pinCode,
      userInfo.aadhaar,
      userInfo.pan,
      userInfo.schoolCollege,
      userInfo.qualification,
      userInfo.category,
      userInfo.nationality,
      userInfo.profilePhotoPath,
      if (userInfo.dob != null) 'dob',
    ];

    final customFieldCount = userInfo.customSections
        .expand((section) => section.fields)
        .where((field) => field.value.trim().isNotEmpty)
        .length;

    return values.where((value) => value.trim().isNotEmpty).length +
        customFieldCount;
  }

  HomeState copyWith({
    HomeStatus? status,
    UserInfo? userInfo,
    List<SavedDocument>? documents,
    List<ProcessedFile>? recentFiles,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return HomeState(
      status: status ?? this.status,
      userInfo: userInfo ?? this.userInfo,
      documents: documents ?? this.documents,
      recentFiles: recentFiles ?? this.recentFiles,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [
    status,
    userInfo,
    documents,
    recentFiles,
    errorMessage,
  ];
}
