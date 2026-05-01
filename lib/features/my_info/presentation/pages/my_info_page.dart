import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/sensitive_value_formatter.dart';
import '../../../../core/widgets/app_top_header.dart';
import '../../../../core/widgets/section_card.dart';
import '../../domain/entities/user_info.dart';
import '../cubit/my_info_cubit.dart';
import '../cubit/my_info_state.dart';
import '../widgets/my_info_date_field.dart';
import '../widgets/my_info_input_field.dart';
import '../widgets/profile_overview_card.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({required this.cubit, super.key});

  final MyInfoCubit cubit;

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _dobController = TextEditingController();
  final _genderController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pinCodeController = TextEditingController();
  final _aadhaarController = TextEditingController();
  final _panController = TextEditingController();
  final _schoolCollegeController = TextEditingController();
  final _qualificationController = TextEditingController();
  final _categoryController = TextEditingController();
  final _nationalityController = TextEditingController();
  final _personalKey = GlobalKey();
  final _contactKey = GlobalKey();
  final _sensitiveKey = GlobalKey();
  final _educationKey = GlobalKey();
  final _fullNameFieldKey = GlobalKey();
  final _fatherNameFieldKey = GlobalKey();
  final _motherNameFieldKey = GlobalKey();
  final _dobFieldKey = GlobalKey();
  final _genderFieldKey = GlobalKey();
  final _phoneFieldKey = GlobalKey();
  final _emailFieldKey = GlobalKey();
  final _addressFieldKey = GlobalKey();
  final _cityFieldKey = GlobalKey();
  final _stateFieldKey = GlobalKey();
  final _pinCodeFieldKey = GlobalKey();
  final _aadhaarFieldKey = GlobalKey();
  final _panFieldKey = GlobalKey();
  final _schoolCollegeFieldKey = GlobalKey();
  final _qualificationFieldKey = GlobalKey();
  final _categoryFieldKey = GlobalKey();
  final _nationalityFieldKey = GlobalKey();
  final _personalExpansionController = ExpansibleController();
  final _contactExpansionController = ExpansibleController();
  final _sensitiveExpansionController = ExpansibleController();
  final _educationExpansionController = ExpansibleController();
  final _fullNameFocusNode = FocusNode();
  final _fatherNameFocusNode = FocusNode();
  final _motherNameFocusNode = FocusNode();
  final _phoneFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _cityFocusNode = FocusNode();
  final _stateFocusNode = FocusNode();
  final _pinCodeFocusNode = FocusNode();
  final _aadhaarFocusNode = FocusNode();
  final _panFocusNode = FocusNode();
  final _schoolCollegeFocusNode = FocusNode();
  final _qualificationFocusNode = FocusNode();
  final _categoryFocusNode = FocusNode();
  final _nationalityFocusNode = FocusNode();

  DateTime? _selectedDob;
  String _profilePhotoPath = '';
  String _countryCode = '+91';
  bool _didSyncControllers = false;
  bool _isSyncingControllers = false;
  bool _hasPendingAutosave = false;
  DateTime? _lastAutosavedAt;
  Timer? _autosaveDebounce;
  final List<_CustomSectionControllers> _customSections = [];

  List<TextEditingController> get _trackedControllers => [
    _fullNameController,
    _fatherNameController,
    _motherNameController,
    _dobController,
    _genderController,
    _phoneController,
    _emailController,
    _addressController,
    _cityController,
    _stateController,
    _pinCodeController,
    _aadhaarController,
    _panController,
    _schoolCollegeController,
    _qualificationController,
    _categoryController,
    _nationalityController,
    for (final section in _customSections)
      for (final field in section.fields) field.valueController,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    for (final controller in _trackedControllers) {
      controller.addListener(_handleFormChange);
    }
    widget.cubit.loadUserInfo();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _autosaveDebounce?.cancel();
    for (final controller in _trackedControllers) {
      controller.removeListener(_handleFormChange);
    }
    _fullNameController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();
    _dobController.dispose();
    _genderController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pinCodeController.dispose();
    _aadhaarController.dispose();
    _panController.dispose();
    _schoolCollegeController.dispose();
    _qualificationController.dispose();
    _categoryController.dispose();
    _nationalityController.dispose();
    _fullNameFocusNode.dispose();
    _fatherNameFocusNode.dispose();
    _motherNameFocusNode.dispose();
    _phoneFocusNode.dispose();
    _emailFocusNode.dispose();
    _addressFocusNode.dispose();
    _cityFocusNode.dispose();
    _stateFocusNode.dispose();
    _pinCodeFocusNode.dispose();
    _aadhaarFocusNode.dispose();
    _panFocusNode.dispose();
    _schoolCollegeFocusNode.dispose();
    _qualificationFocusNode.dispose();
    _categoryFocusNode.dispose();
    _nationalityFocusNode.dispose();
    _personalExpansionController.dispose();
    _contactExpansionController.dispose();
    _sensitiveExpansionController.dispose();
    _educationExpansionController.dispose();
    for (final section in _customSections) {
      section.dispose();
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (_hasPendingAutosave) {
        _autosaveDebounce?.cancel();
        _performAutosave();
      }
    }
  }

  void _handleFormChange() {
    if (mounted) {
      setState(() {
        if (_didSyncControllers && !_isSyncingControllers) {
          _hasPendingAutosave = true;
        }
      });
      if (_didSyncControllers && !_isSyncingControllers) {
        _scheduleAutosave();
      }
    }
  }

  void _syncControllers(UserInfo userInfo) {
    _isSyncingControllers = true;
    _fullNameController.text = userInfo.fullName;
    _fatherNameController.text = userInfo.fatherName;
    _motherNameController.text = userInfo.motherName;
    _selectedDob = userInfo.dob;
    _dobController.text = _formatDate(userInfo.dob);
    _genderController.text = userInfo.gender;
    final parsedPhone = _parsePhone(userInfo.phone);
    _countryCode = parsedPhone.$1;
    _phoneController.text = parsedPhone.$2;
    _emailController.text = userInfo.email;
    _addressController.text = userInfo.address;
    _cityController.text = userInfo.city;
    _stateController.text = userInfo.state;
    _pinCodeController.text = userInfo.pinCode;
    _aadhaarController.text = userInfo.aadhaar;
    _panController.text = userInfo.pan;
    _schoolCollegeController.text = userInfo.schoolCollege;
    _qualificationController.text = userInfo.qualification;
    _categoryController.text = userInfo.category;
    _nationalityController.text = userInfo.nationality;
    _profilePhotoPath = userInfo.profilePhotoPath;
    for (final section in _customSections) {
      section.dispose();
    }
    _customSections
      ..clear()
      ..addAll(
        userInfo.customSections.map(
          (section) => _CustomSectionControllers.fromSection(
            section,
            onChanged: _handleFormChange,
          ),
        ),
      );
    _didSyncControllers = true;
    _hasPendingAutosave = false;
    _isSyncingControllers = false;
  }

  String _formatDate(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    final day = dateTime.day.toString().padLeft(2, '0');
    final month = dateTime.month.toString().padLeft(2, '0');
    return '$day-$month-${dateTime.year}';
  }

  UserInfo _buildUserInfo() {
    return UserInfo(
      fullName: _fullNameController.text.trim(),
      fatherName: _fatherNameController.text.trim(),
      motherName: _motherNameController.text.trim(),
      dob: _selectedDob,
      gender: _genderController.text.trim(),
      phone: _fullPhoneValue(),
      email: _emailController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      state: _stateController.text.trim(),
      pinCode: _pinCodeController.text.trim(),
      aadhaar: _aadhaarController.text.trim(),
      pan: _panController.text.trim(),
      schoolCollege: _schoolCollegeController.text.trim(),
      qualification: _qualificationController.text.trim(),
      category: _categoryController.text.trim(),
      nationality: _nationalityController.text.trim(),
      profilePhotoPath: _profilePhotoPath,
      customSections: _customSections
          .map((section) => section.toSection())
          .where(
            (section) =>
                section.title.trim().isNotEmpty || section.fields.isNotEmpty,
          )
          .toList(growable: false),
    );
  }

  (String, String) _parsePhone(String value) {
    final text = value.trim();
    const supportedCodes = ['+91', '+1', '+44', '+61', '+971'];
    for (final code in supportedCodes) {
      if (text.startsWith(code)) {
        return (code, text.substring(code.length).trim());
      }
    }
    return (_countryCode, text);
  }

  String _fullPhoneValue() {
    final number = _phoneController.text.trim();
    return number.isEmpty ? '' : '$_countryCode $number';
  }

  double _completionFor(List<TextEditingController> controllers) {
    if (controllers.isEmpty) {
      return 0;
    }
    final completed = controllers
        .where((controller) => controller.text.trim().isNotEmpty)
        .length;
    return completed / controllers.length;
  }

  List<bool> _completionSegments() {
    final segments = <bool>[
      _completionFor([
            _fullNameController,
            _fatherNameController,
            _motherNameController,
            _dobController,
            _genderController,
          ]) >=
          1,
      _completionFor([
            _phoneController,
            _emailController,
            _addressController,
            _cityController,
            _stateController,
            _pinCodeController,
          ]) >=
          1,
      _completionFor([_aadhaarController, _panController]) >= 1,
      _completionFor([
            _schoolCollegeController,
            _qualificationController,
            _categoryController,
            _nationalityController,
          ]) >=
          1,
    ];
    for (final section in _customSections) {
      segments.add(section.fields.isNotEmpty);
    }
    return segments;
  }

  String _autosaveLabel(MyInfoState state) {
    if (state.isSaving) return 'Saving...';
    if (state.status == MyInfoStatus.failure) return 'Offline changes pending';
    if (_hasPendingAutosave) return 'Changes pending';
    if (_lastAutosavedAt != null || state.hasUserInfo) return 'Saved just now';
    return 'Autosave on';
  }

  IconData _autosaveIcon(MyInfoState state) {
    if (state.isSaving) return Icons.sync_rounded;
    if (state.status == MyInfoStatus.failure || _hasPendingAutosave) {
      return Icons.cloud_off_outlined;
    }
    return Icons.check_circle_outline_rounded;
  }

  ProfileOverviewTone _autosaveTone(MyInfoState state) {
    if (state.status == MyInfoStatus.failure || _hasPendingAutosave) {
      return ProfileOverviewTone.warning;
    }
    return ProfileOverviewTone.success;
  }

  void _scheduleAutosave() {
    _autosaveDebounce?.cancel();
    _autosaveDebounce = Timer(
      const Duration(milliseconds: 900),
      _performAutosave,
    );
  }

  Future<void> _performAutosave() async {
    if (!mounted || !_didSyncControllers) return;
    if (!(_formKey.currentState?.validate() ?? true)) return;
    await widget.cubit.saveUserInfo(_buildUserInfo(), showFeedback: false);
    if (!context.mounted) return;
    setState(() {
      final failed = widget.cubit.state.status == MyInfoStatus.failure;
      _hasPendingAutosave = failed;
      if (!failed) {
        _lastAutosavedAt = DateTime.now();
      }
    });
  }

  Future<void> _showAddSectionSheet() async {
    final messenger = ScaffoldMessenger.of(context);
    final title = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => const _AddSectionSheet(),
    );
    if (title == null || title.trim().isEmpty) return;
    setState(() {
      _customSections.add(
        _CustomSectionControllers.empty(
          id: _newCustomId(),
          title: title.trim(),
          onChanged: _handleFormChange,
        ),
      );
      _hasPendingAutosave = true;
    });
    _scheduleAutosave();
    if (!mounted) return;
    messenger.showSnackBar(
      const SnackBar(content: Text('Section added. Autosaving...')),
    );
  }

  Future<void> _showAddInfoFieldSheet() async {
    final result = await showModalBottomSheet<_AddInfoFieldResult>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) => _AddInfoFieldSheet(sections: _customSections),
    );
    if (result == null) return;
    setState(() {
      var sectionIndex = _customSections.indexWhere(
        (section) => section.id == result.sectionId,
      );
      if (sectionIndex == -1) {
        _customSections.add(
          _CustomSectionControllers.empty(
            id: _newCustomId(),
            title: result.sectionTitle,
            onChanged: _handleFormChange,
          ),
        );
        sectionIndex = _customSections.length - 1;
      }
      _customSections[sectionIndex].fields.add(
        _CustomFieldControllers(
          label: result.label,
          value: result.value,
          fieldType: result.fieldType,
          isRequired: result.isRequired,
          onChanged: _handleFormChange,
        ),
      );
      _hasPendingAutosave = true;
    });
    _scheduleAutosave();
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Info added. Autosaving...')));
  }

  String _newCustomId() => DateTime.now().microsecondsSinceEpoch.toString();

  String _recommendedNextStep() {
    final sections = <({String label, double progress})>[
      (
        label: 'Complete personal details',
        progress: _completionFor([
          _fullNameController,
          _fatherNameController,
          _motherNameController,
          _dobController,
          _genderController,
        ]),
      ),
      (
        label: 'Complete contact details',
        progress: _completionFor([
          _phoneController,
          _emailController,
          _addressController,
          _cityController,
          _stateController,
          _pinCodeController,
        ]),
      ),
      (
        label: 'Add sensitive IDs if needed',
        progress: _completionFor([_aadhaarController, _panController]),
      ),
      (
        label: 'Complete education profile',
        progress: _completionFor([
          _schoolCollegeController,
          _qualificationController,
          _categoryController,
          _nationalityController,
        ]),
      ),
    ];

    final next =
        sections
            .where((section) => section.progress < 1)
            .toList(growable: false)
          ..sort((a, b) => a.progress.compareTo(b.progress));
    return next.isEmpty ? 'Profile is form-ready' : next.first.label;
  }

  _IncompleteTarget? _nextIncompleteTarget() {
    final targets = <_IncompleteTarget>[
      _IncompleteTarget(
        controller: _fullNameController,
        sectionKey: _personalKey,
        fieldKey: _fullNameFieldKey,
        expansionController: _personalExpansionController,
        focusNode: _fullNameFocusNode,
      ),
      _IncompleteTarget(
        controller: _fatherNameController,
        sectionKey: _personalKey,
        fieldKey: _fatherNameFieldKey,
        expansionController: _personalExpansionController,
        focusNode: _fatherNameFocusNode,
      ),
      _IncompleteTarget(
        controller: _motherNameController,
        sectionKey: _personalKey,
        fieldKey: _motherNameFieldKey,
        expansionController: _personalExpansionController,
        focusNode: _motherNameFocusNode,
      ),
      _IncompleteTarget(
        controller: _dobController,
        sectionKey: _personalKey,
        fieldKey: _dobFieldKey,
        expansionController: _personalExpansionController,
        action: _pickDate,
      ),
      _IncompleteTarget(
        controller: _genderController,
        sectionKey: _personalKey,
        fieldKey: _genderFieldKey,
        expansionController: _personalExpansionController,
        action: _showGenderPicker,
      ),
      _IncompleteTarget(
        controller: _phoneController,
        sectionKey: _contactKey,
        fieldKey: _phoneFieldKey,
        expansionController: _contactExpansionController,
        focusNode: _phoneFocusNode,
      ),
      _IncompleteTarget(
        controller: _emailController,
        sectionKey: _contactKey,
        fieldKey: _emailFieldKey,
        expansionController: _contactExpansionController,
        focusNode: _emailFocusNode,
      ),
      _IncompleteTarget(
        controller: _addressController,
        sectionKey: _contactKey,
        fieldKey: _addressFieldKey,
        expansionController: _contactExpansionController,
        focusNode: _addressFocusNode,
      ),
      _IncompleteTarget(
        controller: _cityController,
        sectionKey: _contactKey,
        fieldKey: _cityFieldKey,
        expansionController: _contactExpansionController,
        focusNode: _cityFocusNode,
      ),
      _IncompleteTarget(
        controller: _stateController,
        sectionKey: _contactKey,
        fieldKey: _stateFieldKey,
        expansionController: _contactExpansionController,
        focusNode: _stateFocusNode,
      ),
      _IncompleteTarget(
        controller: _pinCodeController,
        sectionKey: _contactKey,
        fieldKey: _pinCodeFieldKey,
        expansionController: _contactExpansionController,
        focusNode: _pinCodeFocusNode,
      ),
      _IncompleteTarget(
        controller: _aadhaarController,
        sectionKey: _sensitiveKey,
        fieldKey: _aadhaarFieldKey,
        expansionController: _sensitiveExpansionController,
        focusNode: _aadhaarFocusNode,
      ),
      _IncompleteTarget(
        controller: _panController,
        sectionKey: _sensitiveKey,
        fieldKey: _panFieldKey,
        expansionController: _sensitiveExpansionController,
        focusNode: _panFocusNode,
      ),
      _IncompleteTarget(
        controller: _schoolCollegeController,
        sectionKey: _educationKey,
        fieldKey: _schoolCollegeFieldKey,
        expansionController: _educationExpansionController,
        focusNode: _schoolCollegeFocusNode,
      ),
      _IncompleteTarget(
        controller: _qualificationController,
        sectionKey: _educationKey,
        fieldKey: _qualificationFieldKey,
        expansionController: _educationExpansionController,
        focusNode: _qualificationFocusNode,
      ),
      _IncompleteTarget(
        controller: _categoryController,
        sectionKey: _educationKey,
        fieldKey: _categoryFieldKey,
        expansionController: _educationExpansionController,
        focusNode: _categoryFocusNode,
      ),
      _IncompleteTarget(
        controller: _nationalityController,
        sectionKey: _educationKey,
        fieldKey: _nationalityFieldKey,
        expansionController: _educationExpansionController,
        focusNode: _nationalityFocusNode,
      ),
    ];

    for (final target in targets) {
      if (target.controller.text.trim().isEmpty) {
        return target;
      }
    }
    return null;
  }

  Future<void> _goToNextIncomplete() async {
    final target = _nextIncompleteTarget();
    if (target == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All core info sections are complete.')),
      );
      return;
    }

    target.expansionController.expand();
    await Future<void>.delayed(const Duration(milliseconds: 260));
    if (!mounted) return;

    final targetContext =
        target.fieldKey.currentContext ?? target.sectionKey.currentContext;
    if (targetContext == null || !targetContext.mounted) return;
    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      alignment: 0.16,
    );
    if (!mounted) return;

    await Future<void>.delayed(const Duration(milliseconds: 80));
    if (target.action != null) {
      await target.action!();
      return;
    }
    target.focusNode?.requestFocus();
  }

  void _copySection(String title, Map<String, String> fields) {
    final text = fields.entries
        .where((entry) => entry.value.trim().isNotEmpty)
        .map((entry) => '${entry.key}: ${entry.value.trim()}')
        .join('\n');
    context.read<MyInfoCubit>().copyField(label: title, value: text);
  }

  Future<void> _deleteCustomSection(_CustomSectionControllers section) async {
    final index = _customSections.indexOf(section);
    if (index == -1) return;
    final removed = section.toSection();
    setState(() {
      _customSections.removeAt(index);
      _hasPendingAutosave = true;
    });
    _scheduleAutosave();
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text('${removed.title} deleted.'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _customSections.insert(
                  index.clamp(0, _customSections.length),
                  _CustomSectionControllers.fromSection(
                    removed,
                    onChanged: _handleFormChange,
                  ),
                );
                _hasPendingAutosave = true;
              });
              _scheduleAutosave();
            },
          ),
        ),
      );
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final initialDate =
        _selectedDob ?? DateTime(today.year - 18, today.month, today.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: today,
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _selectedDob = picked;
      _dobController.text = _formatDate(picked);
    });
  }

  Future<void> _showGenderPicker() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) => _OptionPickerSheet(
        title: 'Select Gender',
        selectedValue: _genderController.text.trim(),
        options: const ['Male', 'Female', 'Other', 'Prefer not to say'],
      ),
    );
    if (selected == null) return;
    _genderController.text = selected;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? true)) {
      return;
    }
    await widget.cubit.saveUserInfo(_buildUserInfo());
    if (!mounted) return;
    setState(() {
      final failed = widget.cubit.state.status == MyInfoStatus.failure;
      _hasPendingAutosave = failed;
      if (!failed) {
        _lastAutosavedAt = DateTime.now();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: widget.cubit,
      child: BlocConsumer<MyInfoCubit, MyInfoState>(
        listenWhen: (previous, current) {
          return previous.feedbackVersion != current.feedbackVersion ||
              previous.userInfo != current.userInfo;
        },
        listener: (context, state) {
          if (!_didSyncControllers && state.status == MyInfoStatus.ready) {
            _syncControllers(state.userInfo);
          }

          final message = state.feedbackMessage;
          if (message != null && message.isNotEmpty) {
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  content: Text(message),
                  behavior: SnackBarBehavior.floating,
                ),
              );
          }
        },
        builder: (context, state) {
          if (!_didSyncControllers && state.status == MyInfoStatus.ready) {
            _syncControllers(state.userInfo);
          }

          return Scaffold(
            appBar: AppTopHeader<_InfoAddMenuAction>(
              title: 'Info',
              automaticallyImplyLeading: false,
              titleSpacing: AppSizes.md,
              secondaryActions: const [
                Padding(
                  padding: EdgeInsetsDirectional.only(end: AppSizes.xs),
                  child: Icon(Icons.shield_outlined, size: 20),
                ),
              ],
              rightActionType: AppTopHeaderRightActionType.menu,
              menuItems: const [
                AppTopHeaderMenuItem<_InfoAddMenuAction>(
                  value: _InfoAddMenuAction.addInfo,
                  label: 'Add info field',
                  icon: Icons.add_rounded,
                ),
                AppTopHeaderMenuItem<_InfoAddMenuAction>(
                  value: _InfoAddMenuAction.addSection,
                  label: 'Add section',
                  icon: Icons.create_new_folder_outlined,
                ),
              ],
              onMenuAction: (action) {
                switch (action) {
                  case _InfoAddMenuAction.addInfo:
                    _showAddInfoFieldSheet();
                  case _InfoAddMenuAction.addSection:
                    _showAddSectionSheet();
                }
              },
            ),
            body: SafeArea(
              child:
                  state.status == MyInfoStatus.loading ||
                      state.status == MyInfoStatus.initial
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: ListView(
                        padding: const EdgeInsets.fromLTRB(
                          AppSizes.md,
                          AppSizes.sm,
                          AppSizes.md,
                          AppSizes.lg,
                        ),
                        children: [
                          ProfileOverviewCard(
                            completion: _completionFor(_trackedControllers),
                            segments: _completionSegments(),
                            nextStep: _recommendedNextStep(),
                            autosaveLabel: _autosaveLabel(state),
                            autosaveIcon: _autosaveIcon(state),
                            autosaveTone: _autosaveTone(state),
                            displayName: _fullNameController.text.trim(),
                            onTap: _goToNextIncomplete,
                            onRetrySave: state.status == MyInfoStatus.failure
                                ? _save
                                : null,
                            onCopyAll: state.isBusy
                                ? null
                                : () => context.read<MyInfoCubit>().copyAllInfo(
                                    _buildUserInfo(),
                                  ),
                          ),
                          const SizedBox(height: AppSizes.md),
                          _SwipeableSection(
                            dismissKey: const ValueKey('personal-section'),
                            onCopy: () => _copySection('Personal Details', {
                              'Full Name': _fullNameController.text,
                              "Father's Name": _fatherNameController.text,
                              "Mother's Name": _motherNameController.text,
                              'DOB': _dobController.text,
                              'Gender': _genderController.text,
                            }),
                            child: _InfoExpansionSection(
                              key: _personalKey,
                              title: 'Personal Details',
                              controller: _personalExpansionController,
                              completion: _completionFor([
                                _fullNameController,
                                _fatherNameController,
                                _motherNameController,
                                _dobController,
                                _genderController,
                              ]),
                              initiallyExpanded: true,
                              child: Column(
                                children: [
                                  MyInfoInputField(
                                    fieldKey: _fullNameFieldKey,
                                    focusNode: _fullNameFocusNode,
                                    label: 'Full Name',
                                    controller: _fullNameController,
                                    prefixIcon: Icons.person_outline_rounded,
                                    textInputAction: TextInputAction.next,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: 'Full Name',
                                          value: _fullNameController.text,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  MyInfoInputField(
                                    fieldKey: _fatherNameFieldKey,
                                    focusNode: _fatherNameFocusNode,
                                    label: "Father's Name",
                                    controller: _fatherNameController,
                                    prefixIcon: Icons.person_outline_rounded,
                                    textInputAction: TextInputAction.next,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: "Father's Name",
                                          value: _fatherNameController.text,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  MyInfoInputField(
                                    fieldKey: _motherNameFieldKey,
                                    focusNode: _motherNameFocusNode,
                                    label: "Mother's Name",
                                    controller: _motherNameController,
                                    prefixIcon: Icons.person_outline_rounded,
                                    textInputAction: TextInputAction.next,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: "Mother's Name",
                                          value: _motherNameController.text,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  MyInfoDateField(
                                    fieldKey: _dobFieldKey,
                                    controller: _dobController,
                                    onPickDate: _pickDate,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: 'DOB',
                                          value: _dobController.text,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  MyInfoInputField(
                                    fieldKey: _genderFieldKey,
                                    label: 'Gender',
                                    controller: _genderController,
                                    prefixIcon: Icons.wc_outlined,
                                    helperText:
                                        'Use the value required by the form.',
                                    readOnly: true,
                                    onTap: _showGenderPicker,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: 'Gender',
                                          value: _genderController.text,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.md),
                          _SwipeableSection(
                            dismissKey: const ValueKey('contact-section'),
                            onCopy: () => _copySection('Contact Details', {
                              'Phone': _fullPhoneValue(),
                              'Email': _emailController.text,
                              'Address': _addressController.text,
                              'City': _cityController.text,
                              'State': _stateController.text,
                              'Pin Code': _pinCodeController.text,
                            }),
                            child: _InfoExpansionSection(
                              key: _contactKey,
                              title: 'Contact Details',
                              controller: _contactExpansionController,
                              completion: _completionFor([
                                _phoneController,
                                _emailController,
                                _addressController,
                                _cityController,
                                _stateController,
                                _pinCodeController,
                              ]),
                              child: Column(
                                children: [
                                  _PhoneInputField(
                                    fieldKey: _phoneFieldKey,
                                    focusNode: _phoneFocusNode,
                                    label: 'Mobile Number',
                                    controller: _phoneController,
                                    countryCode: _countryCode,
                                    onCountryCodeChanged: (value) {
                                      setState(() {
                                        _countryCode = value;
                                        _hasPendingAutosave = true;
                                      });
                                      _scheduleAutosave();
                                    },
                                    validator: _optionalPhoneValidator,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: 'Phone',
                                          value: _fullPhoneValue(),
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  MyInfoInputField(
                                    fieldKey: _emailFieldKey,
                                    focusNode: _emailFocusNode,
                                    label: 'Email',
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    prefixIcon: Icons.mail_outline_rounded,
                                    textInputAction: TextInputAction.next,
                                    validator: _optionalEmailValidator,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: 'Email',
                                          value: _emailController.text,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  MyInfoInputField(
                                    fieldKey: _addressFieldKey,
                                    focusNode: _addressFocusNode,
                                    label: 'Address',
                                    controller: _addressController,
                                    maxLines: 3,
                                    prefixIcon: Icons.home_outlined,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: 'Address',
                                          value: _addressController.text,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  MyInfoInputField(
                                    fieldKey: _cityFieldKey,
                                    focusNode: _cityFocusNode,
                                    label: 'City',
                                    controller: _cityController,
                                    prefixIcon: Icons.location_city_outlined,
                                    textInputAction: TextInputAction.next,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: 'City',
                                          value: _cityController.text,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  MyInfoInputField(
                                    fieldKey: _stateFieldKey,
                                    focusNode: _stateFocusNode,
                                    label: 'State',
                                    controller: _stateController,
                                    prefixIcon: Icons.map_outlined,
                                    textInputAction: TextInputAction.next,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: 'State',
                                          value: _stateController.text,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  MyInfoInputField(
                                    fieldKey: _pinCodeFieldKey,
                                    focusNode: _pinCodeFocusNode,
                                    label: 'Pin Code',
                                    controller: _pinCodeController,
                                    keyboardType: TextInputType.number,
                                    prefixIcon: Icons.pin_drop_outlined,
                                    helperText:
                                        'Usually 6 digits for Indian addresses.',
                                    validator: _optionalPinCodeValidator,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: 'Pin Code',
                                          value: _pinCodeController.text,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.md),
                          _SwipeableSection(
                            dismissKey: const ValueKey('sensitive-section'),
                            onCopy: () => _copySection('Sensitive Details', {
                              'Aadhaar': _aadhaarController.text,
                              'PAN': _panController.text,
                            }),
                            child: _InfoExpansionSection(
                              key: _sensitiveKey,
                              title: 'Sensitive Details',
                              controller: _sensitiveExpansionController,
                              subtitle: 'Masked by default for privacy.',
                              completion: _completionFor([
                                _aadhaarController,
                                _panController,
                              ]),
                              child: Column(
                                children: [
                                  MyInfoInputField(
                                    fieldKey: _aadhaarFieldKey,
                                    focusNode: _aadhaarFocusNode,
                                    label: 'Aadhaar',
                                    controller: _aadhaarController,
                                    keyboardType: TextInputType.number,
                                    prefixIcon: Icons.credit_card_outlined,
                                    helperText: state.isAadhaarObscured
                                        ? SensitiveValueFormatter.maskLast4(
                                            _aadhaarController.text,
                                          )
                                        : '12-digit Aadhaar number.',
                                    obscureText: state.isAadhaarObscured,
                                    validator: _optionalAadhaarValidator,
                                    onToggleVisibility: context
                                        .read<MyInfoCubit>()
                                        .toggleAadhaarVisibility,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: 'Aadhaar',
                                          value: _aadhaarController.text,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  MyInfoInputField(
                                    fieldKey: _panFieldKey,
                                    focusNode: _panFocusNode,
                                    label: 'PAN',
                                    controller: _panController,
                                    keyboardType: TextInputType.text,
                                    prefixIcon: Icons.badge_outlined,
                                    helperText: state.isPanObscured
                                        ? SensitiveValueFormatter.maskLast4(
                                            _panController.text,
                                          )
                                        : 'Format: ABCDE1234F',
                                    obscureText: state.isPanObscured,
                                    validator: _optionalPanValidator,
                                    onToggleVisibility: context
                                        .read<MyInfoCubit>()
                                        .togglePanVisibility,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: 'PAN',
                                          value: _panController.text,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.md),
                          _SwipeableSection(
                            dismissKey: const ValueKey('education-section'),
                            onCopy: () => _copySection('Education & Profile', {
                              'School/College': _schoolCollegeController.text,
                              'Qualification': _qualificationController.text,
                              'Category': _categoryController.text,
                              'Nationality': _nationalityController.text,
                            }),
                            child: _InfoExpansionSection(
                              key: _educationKey,
                              title: 'Education & Profile',
                              controller: _educationExpansionController,
                              completion: _completionFor([
                                _schoolCollegeController,
                                _qualificationController,
                                _categoryController,
                                _nationalityController,
                              ]),
                              child: Column(
                                children: [
                                  MyInfoInputField(
                                    fieldKey: _schoolCollegeFieldKey,
                                    focusNode: _schoolCollegeFocusNode,
                                    label: 'School/College',
                                    controller: _schoolCollegeController,
                                    prefixIcon: Icons.school_outlined,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: 'School/College',
                                          value: _schoolCollegeController.text,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  MyInfoInputField(
                                    fieldKey: _qualificationFieldKey,
                                    focusNode: _qualificationFocusNode,
                                    label: 'Qualification',
                                    controller: _qualificationController,
                                    prefixIcon:
                                        Icons.workspace_premium_outlined,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: 'Qualification',
                                          value: _qualificationController.text,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  MyInfoInputField(
                                    fieldKey: _categoryFieldKey,
                                    focusNode: _categoryFocusNode,
                                    label: 'Category',
                                    controller: _categoryController,
                                    prefixIcon: Icons.category_outlined,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: 'Category',
                                          value: _categoryController.text,
                                        ),
                                  ),
                                  const SizedBox(height: 12),
                                  MyInfoInputField(
                                    fieldKey: _nationalityFieldKey,
                                    focusNode: _nationalityFocusNode,
                                    label: 'Nationality',
                                    controller: _nationalityController,
                                    prefixIcon: Icons.flag_outlined,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    onCopy: () =>
                                        context.read<MyInfoCubit>().copyField(
                                          label: 'Nationality',
                                          value: _nationalityController.text,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSizes.md),
                          _CustomInfoSections(
                            sections: _customSections,
                            onDeleteSection: _deleteCustomSection,
                            onCopyField: (label, value) => context
                                .read<MyInfoCubit>()
                                .copyField(label: label, value: value),
                          ),
                          const SizedBox(height: AppSizes.md),
                          Text(
                            AppStrings.privacyMessage,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          const SizedBox(height: AppSizes.xl),
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  String? _optionalPhoneValidator(String? value) {
    final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
    if (digits.isEmpty) {
      return null;
    }
    final valid = digits.length >= 6 && digits.length <= 15;
    return valid ? null : 'Enter a valid phone number.';
  }

  String? _optionalEmailValidator(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return null;
    }
    final valid = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(text);
    return valid ? null : 'Enter a valid email address.';
  }

  String? _optionalPinCodeValidator(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    return RegExp(r'^[0-9]{6}$').hasMatch(text)
        ? null
        : 'Enter a 6 digit PIN code.';
  }

  String? _optionalAadhaarValidator(String? value) {
    final text = value?.replaceAll(RegExp(r'\s+'), '') ?? '';
    if (text.isEmpty) return null;
    return RegExp(r'^[0-9]{12}$').hasMatch(text)
        ? null
        : 'Enter a 12 digit Aadhaar number.';
  }

  String? _optionalPanValidator(String? value) {
    final text = value?.trim().toUpperCase() ?? '';
    if (text.isEmpty) return null;
    return RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(text)
        ? null
        : 'Enter a valid PAN, e.g. ABCDE1234F.';
  }
}

class _CustomSectionControllers {
  _CustomSectionControllers({
    required this.id,
    required String title,
    required this.fields,
    required VoidCallback onChanged,
  }) : titleController = TextEditingController(text: title) {
    titleController.addListener(onChanged);
    _onChanged = onChanged;
  }

  factory _CustomSectionControllers.empty({
    required String id,
    required String title,
    required VoidCallback onChanged,
  }) {
    return _CustomSectionControllers(
      id: id,
      title: title,
      fields: <_CustomFieldControllers>[],
      onChanged: onChanged,
    );
  }

  factory _CustomSectionControllers.fromSection(
    CustomInfoSection section, {
    required VoidCallback onChanged,
  }) {
    return _CustomSectionControllers(
      id: section.id,
      title: section.title,
      fields: section.fields
          .map(
            (field) => _CustomFieldControllers(
              label: field.label,
              value: field.value,
              fieldType: field.fieldType,
              isRequired: field.isRequired,
              onChanged: onChanged,
            ),
          )
          .toList(growable: true),
      onChanged: onChanged,
    );
  }

  final String id;
  final TextEditingController titleController;
  final List<_CustomFieldControllers> fields;
  late final VoidCallback _onChanged;

  CustomInfoSection toSection() {
    return CustomInfoSection(
      id: id,
      title: titleController.text.trim(),
      fields: fields
          .map((field) => field.toField())
          .where((field) => field.label.trim().isNotEmpty)
          .toList(growable: false),
    );
  }

  void dispose() {
    titleController.removeListener(_onChanged);
    titleController.dispose();
    for (final field in fields) {
      field.dispose();
    }
  }
}

class _CustomFieldControllers {
  _CustomFieldControllers({
    required String label,
    required String value,
    required this.fieldType,
    required this.isRequired,
    required VoidCallback onChanged,
  }) : labelController = TextEditingController(text: label),
       valueController = TextEditingController(text: value) {
    labelController.addListener(onChanged);
    valueController.addListener(onChanged);
    _onChanged = onChanged;
  }

  final TextEditingController labelController;
  final TextEditingController valueController;
  final String fieldType;
  final bool isRequired;
  late final VoidCallback _onChanged;

  CustomInfoField toField() {
    return CustomInfoField(
      label: labelController.text.trim(),
      value: valueController.text.trim(),
      fieldType: fieldType,
      isRequired: isRequired,
    );
  }

  void dispose() {
    labelController.removeListener(_onChanged);
    valueController.removeListener(_onChanged);
    labelController.dispose();
    valueController.dispose();
  }
}

enum _InfoAddMenuAction { addInfo, addSection }

class _IncompleteTarget {
  const _IncompleteTarget({
    required this.controller,
    required this.sectionKey,
    required this.fieldKey,
    required this.expansionController,
    this.focusNode,
    this.action,
  });

  final TextEditingController controller;
  final GlobalKey sectionKey;
  final GlobalKey fieldKey;
  final ExpansibleController expansionController;
  final FocusNode? focusNode;
  final Future<void> Function()? action;
}

class _InfoExpansionSection extends StatelessWidget {
  const _InfoExpansionSection({
    required this.title,
    required this.completion,
    required this.child,
    super.key,
    this.controller,
    this.subtitle,
    this.initiallyExpanded = false,
  });

  final String title;
  final String? subtitle;
  final double completion;
  final Widget child;
  final ExpansibleController? controller;
  final bool initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completed = completion >= 1;
    return SectionCard(
      backgroundColor: AppColors.surface,
      padding: EdgeInsets.zero,
      child: Theme(
        data: theme.copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          controller: controller,
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.md,
            vertical: AppSizes.xs,
          ),
          childrenPadding: const EdgeInsets.fromLTRB(
            AppSizes.md,
            0,
            AppSizes.md,
            AppSizes.md,
          ),
          title: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          subtitle: subtitle == null
              ? null
              : Text(
                  subtitle!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _StatusChip(
                icon: completed
                    ? Icons.check_circle_outline_rounded
                    : Icons.schedule_outlined,
                label: completed
                    ? 'Complete'
                    : '${(completion * 100).round()}%',
                tone: completed ? _StatusTone.success : _StatusTone.info,
              ),
              const SizedBox(width: AppSizes.xs),
              Icon(
                Icons.expand_more_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
          children: [child],
        ),
      ),
    );
  }
}

class _SwipeableSection extends StatefulWidget {
  const _SwipeableSection({
    required this.dismissKey,
    required this.child,
    required this.onCopy,
    this.onDelete,
  });

  final Key dismissKey;
  final Widget child;
  final VoidCallback onCopy;
  final VoidCallback? onDelete;

  @override
  State<_SwipeableSection> createState() => _SwipeableSectionState();
}

class _SwipeableSectionState extends State<_SwipeableSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Animation<double>? _animation;
  double _dragOffset = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 180),
        )..addListener(() {
          final animation = _animation;
          if (animation == null) return;
          setState(() => _dragOffset = animation.value);
        });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      key: widget.dismissKey,
      builder: (context, constraints) {
        final revealExtent = (constraints.maxWidth * 0.32).clamp(96.0, 132.0);
        final offset = _dragOffset.clamp(-revealExtent, revealExtent);
        return ClipRRect(
          borderRadius: AppSizes.cardRadius,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onHorizontalDragStart: (_) => _controller.stop(),
            onHorizontalDragUpdate: (details) {
              setState(() {
                _dragOffset = (_dragOffset + details.delta.dx).clamp(
                  -revealExtent,
                  revealExtent,
                );
              });
            },
            onHorizontalDragEnd: (_) => _settle(revealExtent),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Row(
                    children: [
                      SizedBox(
                        width: revealExtent,
                        child: _SwipeActionButton(
                          color: AppColors.infoContainer,
                          foreground: Theme.of(context).colorScheme.primary,
                          icon: Icons.copy_rounded,
                          label: 'Copy',
                          onTap: () {
                            widget.onCopy();
                            _animateTo(0);
                          },
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: revealExtent,
                        child: _SwipeActionButton(
                          color: widget.onDelete == null
                              ? AppColors.infoContainer
                              : AppColors.destructiveContainer,
                          foreground: widget.onDelete == null
                              ? Theme.of(context).colorScheme.primary
                              : AppColors.destructive,
                          icon: widget.onDelete == null
                              ? Icons.copy_rounded
                              : Icons.delete_outline_rounded,
                          label: widget.onDelete == null ? 'Copy' : 'Delete',
                          onTap: () {
                            final delete = widget.onDelete;
                            if (delete == null) {
                              widget.onCopy();
                            } else {
                              delete();
                            }
                            _animateTo(0);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.translate(
                  offset: Offset(offset, 0),
                  child: Material(
                    color: Colors.transparent,
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _settle(double revealExtent) {
    final threshold = revealExtent * 0.34;
    if (_dragOffset.abs() < threshold) {
      _animateTo(0);
      return;
    }
    _animateTo(_dragOffset.isNegative ? -revealExtent : revealExtent);
  }

  void _animateTo(double target) {
    _animation = Tween<double>(
      begin: _dragOffset,
      end: target,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
    _controller
      ..reset()
      ..forward();
  }
}

class _SwipeActionButton extends StatelessWidget {
  const _SwipeActionButton({
    required this.color,
    required this.foreground,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final Color color;
  final Color foreground;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: InkWell(
        onTap: onTap,
        child: Semantics(
          button: true,
          label: label,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: foreground, size: 21),
                const SizedBox(height: AppSizes.xs),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomInfoSections extends StatelessWidget {
  const _CustomInfoSections({
    required this.sections,
    required this.onDeleteSection,
    required this.onCopyField,
  });

  final List<_CustomSectionControllers> sections;
  final Future<void> Function(_CustomSectionControllers section)
  onDeleteSection;
  final void Function(String label, String value) onCopyField;

  @override
  Widget build(BuildContext context) {
    if (sections.isEmpty) {
      return SectionCard(
        backgroundColor: AppColors.surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const _SectionIcon(icon: Icons.note_add_outlined),
                const SizedBox(width: AppSizes.sm),
                Expanded(
                  child: Text(
                    'Custom Info Sections',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Optional details for application-specific requirements appear here.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            Text(
              'Use the top-right menu to add fields or sections.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (final section in sections) ...[
          _SwipeableSection(
            dismissKey: ValueKey('custom-section-${section.id}'),
            onCopy: () => onCopyField(
              section.titleController.text.trim().isEmpty
                  ? 'Custom Section'
                  : section.titleController.text.trim(),
              section.fields
                  .map(
                    (field) =>
                        '${field.labelController.text}: ${field.valueController.text}',
                  )
                  .join('\n'),
            ),
            onDelete: () => onDeleteSection(section),
            child: _InfoExpansionSection(
              title: section.titleController.text.trim().isEmpty
                  ? 'Custom Section'
                  : section.titleController.text.trim(),
              subtitle: section.fields.isEmpty
                  ? 'No fields yet. Add information for this section.'
                  : '${section.fields.length} saved fields',
              completion: section.fields.isEmpty ? 0 : 1,
              child: Column(
                children: [
                  TextFormField(
                    controller: section.titleController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Section name',
                      prefixIcon: Icon(Icons.folder_outlined),
                    ),
                  ),
                  if (section.fields.isEmpty) ...[
                    const SizedBox(height: AppSizes.md),
                    const _InlineEmptyState(),
                  ] else
                    for (final field in section.fields) ...[
                      const SizedBox(height: AppSizes.md),
                      TextFormField(
                        controller: field.labelController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Field label',
                          helperText:
                              '${field.fieldType} ${field.isRequired ? '• Required' : '• Optional'}',
                          prefixIcon: const Icon(Icons.label_outline_rounded),
                        ),
                      ),
                      const SizedBox(height: AppSizes.sm),
                      TextFormField(
                        controller: field.valueController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          labelText: 'Value',
                          prefixIcon: const Icon(Icons.notes_outlined),
                          suffixIcon: IconButton(
                            tooltip: 'Copy value',
                            constraints: const BoxConstraints(
                              minHeight: AppSizes.minTouchTarget,
                              minWidth: AppSizes.minTouchTarget,
                            ),
                            onPressed: () => onCopyField(
                              field.labelController.text,
                              field.valueController.text,
                            ),
                            icon: const Icon(Icons.copy_rounded),
                          ),
                        ),
                      ),
                    ],
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSizes.md),
        ],
      ],
    );
  }
}

class _InlineEmptyState extends StatelessWidget {
  const _InlineEmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSizes.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: AppSizes.fieldRadius,
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Icon(
            Icons.note_add_outlined,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: AppSizes.sm),
          Text(
            'No info in this section',
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: AppSizes.xs),
          Text(
            'Add a field when this form requires extra details.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionIcon extends StatelessWidget {
  const _SectionIcon({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      width: 36,
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
    );
  }
}

class _PhoneInputField extends StatelessWidget {
  const _PhoneInputField({
    required this.label,
    required this.controller,
    required this.countryCode,
    required this.onCountryCodeChanged,
    required this.validator,
    required this.onCopy,
    this.fieldKey,
    this.focusNode,
  });

  final String label;
  final TextEditingController controller;
  final String countryCode;
  final ValueChanged<String> onCountryCodeChanged;
  final String? Function(String?) validator;
  final VoidCallback onCopy;
  final Key? fieldKey;
  final FocusNode? focusNode;

  static const _countryCodes = <({String code, String label})>[
    (code: '+91', label: 'India'),
    (code: '+1', label: 'US / Canada'),
    (code: '+44', label: 'United Kingdom'),
    (code: '+61', label: 'Australia'),
    (code: '+971', label: 'United Arab Emirates'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 2, bottom: 7),
          child: Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.foreground.withValues(alpha: 0.76),
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: AppSizes.fieldRadius,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.025),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            key: fieldKey,
            controller: controller,
            focusNode: focusNode,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9\s-]')),
            ],
            validator: validator,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
              hintText: 'Mobile number',
              helperText: 'Select country code and enter mobile number.',
              prefixIcon: Padding(
                padding: const EdgeInsetsDirectional.only(start: AppSizes.sm),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: countryCode,
                    borderRadius: AppSizes.cardRadius,
                    selectedItemBuilder: (context) => [
                      for (final entry in _countryCodes) Text(entry.code),
                    ],
                    items: [
                      for (final entry in _countryCodes)
                        DropdownMenuItem(
                          value: entry.code,
                          child: Text('${entry.code}  ${entry.label}'),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) onCountryCodeChanged(value);
                    },
                  ),
                ),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 82,
                minHeight: AppSizes.minTouchTarget,
              ),
              suffixIcon: IconButton(
                tooltip: 'Copy phone',
                constraints: const BoxConstraints(
                  minHeight: AppSizes.minTouchTarget,
                  minWidth: AppSizes.minTouchTarget,
                ),
                onPressed: onCopy,
                icon: const Icon(Icons.copy_rounded),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OptionPickerSheet extends StatelessWidget {
  const _OptionPickerSheet({
    required this.title,
    required this.options,
    required this.selectedValue,
  });

  final String title;
  final List<String> options;
  final String selectedValue;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSizes.md,
          0,
          AppSizes.md,
          AppSizes.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSizes.sm),
            for (final option in options)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(option),
                trailing: option == selectedValue
                    ? Icon(
                        Icons.check_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    : null,
                onTap: () => Navigator.of(context).pop(option),
              ),
          ],
        ),
      ),
    );
  }
}

class _AddSectionSheet extends StatefulWidget {
  const _AddSectionSheet();

  @override
  State<_AddSectionSheet> createState() => _AddSectionSheetState();
}

class _AddSectionSheetState extends State<_AddSectionSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSizes.md,
          right: AppSizes.md,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSizes.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'New Section',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSizes.md),
            TextField(
              controller: _controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submit(),
              decoration: const InputDecoration(
                labelText: 'Section name',
                hintText: 'Exam details, Bank details, Work history',
                prefixIcon: Icon(Icons.folder_outlined),
              ),
            ),
            const SizedBox(height: AppSizes.md),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Section'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    Navigator.of(context).pop(title);
  }
}

class _AddInfoFieldResult {
  const _AddInfoFieldResult({
    required this.sectionId,
    required this.sectionTitle,
    required this.fieldType,
    required this.label,
    required this.value,
    required this.isRequired,
  });

  final String? sectionId;
  final String sectionTitle;
  final String fieldType;
  final String label;
  final String value;
  final bool isRequired;
}

class _AddInfoFieldSheet extends StatefulWidget {
  const _AddInfoFieldSheet({required this.sections});

  final List<_CustomSectionControllers> sections;

  @override
  State<_AddInfoFieldSheet> createState() => _AddInfoFieldSheetState();
}

class _AddInfoFieldSheetState extends State<_AddInfoFieldSheet> {
  static const _newSectionValue = '__new_section__';
  static const _fieldTypes = ['Text', 'Number', 'Date', 'ID'];

  final _formKey = GlobalKey<FormState>();
  late String _selectedSectionId;
  String _fieldType = 'Text';
  bool _isRequired = false;
  final _sectionController = TextEditingController(text: 'Additional Info');
  final _labelController = TextEditingController();
  final _valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedSectionId = widget.sections.isEmpty
        ? _newSectionValue
        : widget.sections.first.id;
  }

  @override
  void dispose() {
    _sectionController.dispose();
    _labelController.dispose();
    _valueController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: AppSizes.md,
          right: AppSizes.md,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSizes.lg,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add Info Field',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSizes.xs),
              Text(
                'Create a reusable detail and choose where it belongs.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSizes.md),
              DropdownButtonFormField<String>(
                initialValue: _fieldType,
                decoration: const InputDecoration(
                  labelText: 'Field type',
                  prefixIcon: Icon(Icons.tune_rounded),
                ),
                items: [
                  for (final type in _fieldTypes)
                    DropdownMenuItem(value: type, child: Text(type)),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _fieldType = value);
                },
              ),
              const SizedBox(height: AppSizes.sm),
              TextFormField(
                controller: _labelController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  final text = value?.trim() ?? '';
                  return text.isEmpty ? 'Enter a field label.' : null;
                },
                decoration: const InputDecoration(
                  labelText: 'Field label',
                  hintText: 'Registration number',
                  prefixIcon: Icon(Icons.label_outline_rounded),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              TextFormField(
                controller: _valueController,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: const InputDecoration(
                  labelText: 'Value',
                  hintText: 'Enter detail',
                  prefixIcon: Icon(Icons.notes_outlined),
                ),
              ),
              const SizedBox(height: AppSizes.sm),
              DropdownButtonFormField<String>(
                initialValue: _selectedSectionId,
                decoration: const InputDecoration(
                  labelText: 'Place in section',
                  prefixIcon: Icon(Icons.folder_outlined),
                ),
                items: [
                  for (final section in widget.sections)
                    DropdownMenuItem(
                      value: section.id,
                      child: Text(section.titleController.text),
                    ),
                  const DropdownMenuItem(
                    value: _newSectionValue,
                    child: Text('Create new section'),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _selectedSectionId = value);
                },
              ),
              if (_selectedSectionId == _newSectionValue) ...[
                const SizedBox(height: AppSizes.sm),
                TextFormField(
                  controller: _sectionController,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (_selectedSectionId != _newSectionValue) return null;
                    final text = value?.trim() ?? '';
                    return text.isEmpty ? 'Enter a section name.' : null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'New section name',
                    hintText: 'Additional Info',
                    prefixIcon: Icon(Icons.create_new_folder_outlined),
                  ),
                ),
              ],
              const SizedBox(height: AppSizes.sm),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Required for this form'),
                subtitle: const Text('Marks this custom field as required.'),
                value: _isRequired,
                onChanged: (value) => setState(() => _isRequired = value),
              ),
              const SizedBox(height: AppSizes.md),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Add Field'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final label = _labelController.text.trim();
    final sectionTitle = _selectedSectionId == _newSectionValue
        ? _sectionController.text.trim()
        : widget.sections
              .firstWhere((section) => section.id == _selectedSectionId)
              .titleController
              .text
              .trim();
    Navigator.of(context).pop(
      _AddInfoFieldResult(
        sectionId: _selectedSectionId == _newSectionValue
            ? null
            : _selectedSectionId,
        sectionTitle: sectionTitle.isEmpty ? 'Additional Info' : sectionTitle,
        fieldType: _fieldType,
        label: label,
        value: _valueController.text.trim(),
        isRequired: _isRequired,
      ),
    );
  }
}

enum _StatusTone { success, warning, info }

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.icon,
    required this.label,
    required this.tone,
  });

  final IconData icon;
  final String label;
  final _StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final Color foreground;
    final Color background;
    switch (tone) {
      case _StatusTone.success:
        foreground = AppColors.success;
        background = AppColors.successContainer;
      case _StatusTone.warning:
        foreground = AppColors.warning;
        background = AppColors.warningContainer;
      case _StatusTone.info:
        foreground = Theme.of(context).colorScheme.primary;
        background = AppColors.infoContainer;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: foreground),
          const SizedBox(width: AppSizes.xs),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
