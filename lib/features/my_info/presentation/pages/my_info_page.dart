import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/sensitive_value_formatter.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/empty_state_card.dart';
import '../../domain/entities/user_info.dart';
import '../cubit/my_info_cubit.dart';
import '../cubit/my_info_state.dart';
import '../widgets/my_info_date_field.dart';
import '../widgets/my_info_input_field.dart';
import '../widgets/my_info_section_card.dart';

class MyInfoPage extends StatefulWidget {
  const MyInfoPage({required this.cubit, super.key});

  final MyInfoCubit cubit;

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
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

  DateTime? _selectedDob;
  bool _didSyncControllers = false;

  @override
  void initState() {
    super.initState();
    widget.cubit.loadUserInfo();
  }

  @override
  void dispose() {
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
    super.dispose();
  }

  void _syncControllers(UserInfo userInfo) {
    _fullNameController.text = userInfo.fullName;
    _fatherNameController.text = userInfo.fatherName;
    _motherNameController.text = userInfo.motherName;
    _selectedDob = userInfo.dob;
    _dobController.text = _formatDate(userInfo.dob);
    _genderController.text = userInfo.gender;
    _phoneController.text = userInfo.phone;
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
    _didSyncControllers = true;
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
      phone: _phoneController.text.trim(),
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

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? true)) {
      return;
    }
    await widget.cubit.saveUserInfo(_buildUserInfo());
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
          final theme = Theme.of(context);
          if (!_didSyncControllers && state.status == MyInfoStatus.ready) {
            _syncControllers(state.userInfo);
          }

          return Scaffold(
            appBar: AppBar(title: const Text('My Info')),
            body: SafeArea(
              child:
                  state.status == MyInfoStatus.loading ||
                      state.status == MyInfoStatus.initial
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          SectionCard(
                            gradient: AppColors.primaryGradient(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'My Info',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  AppStrings.myInfoEmpty,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (!state.hasUserInfo) ...[
                            EmptyStateCard(
                              icon: Icons.badge_outlined,
                              title: 'My Info',
                              message: state.status == MyInfoStatus.failure
                                  ? 'Could not load saved details. Try again.'
                                  : AppStrings.myInfoEmpty,
                              action: state.status == MyInfoStatus.failure
                                  ? TextButton.icon(
                                      onPressed: state.isBusy
                                          ? null
                                          : widget.cubit.loadUserInfo,
                                      icon: const Icon(Icons.refresh_rounded),
                                      label: const Text('Try Again'),
                                    )
                                  : null,
                            ),
                            const SizedBox(height: 16),
                          ],
                          MyInfoSectionCard(
                            title: 'Quick Actions',
                            subtitle:
                                'Copy any field or save everything offline.',
                            trailing: state.isSaving
                                ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : null,
                            child: Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                FilledButton.icon(
                                  onPressed: state.isBusy ? null : _save,
                                  icon: const Icon(Icons.save_rounded),
                                  label: const Text('Save Details'),
                                ),
                                OutlinedButton.icon(
                                  onPressed: state.isBusy
                                      ? null
                                      : () => context
                                            .read<MyInfoCubit>()
                                            .copyAllInfo(_buildUserInfo()),
                                  icon: const Icon(Icons.copy_all_rounded),
                                  label: const Text('Copy All Info'),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          MyInfoSectionCard(
                            title: 'Personal Details',
                            child: Column(
                              children: [
                                MyInfoInputField(
                                  label: 'Full Name',
                                  controller: _fullNameController,
                                  textCapitalization: TextCapitalization.words,
                                  onCopy: () =>
                                      context.read<MyInfoCubit>().copyField(
                                        label: 'Full Name',
                                        value: _fullNameController.text,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                MyInfoInputField(
                                  label: "Father's Name",
                                  controller: _fatherNameController,
                                  textCapitalization: TextCapitalization.words,
                                  onCopy: () =>
                                      context.read<MyInfoCubit>().copyField(
                                        label: "Father's Name",
                                        value: _fatherNameController.text,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                MyInfoInputField(
                                  label: "Mother's Name",
                                  controller: _motherNameController,
                                  textCapitalization: TextCapitalization.words,
                                  onCopy: () =>
                                      context.read<MyInfoCubit>().copyField(
                                        label: "Mother's Name",
                                        value: _motherNameController.text,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                MyInfoDateField(
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
                                  label: 'Gender',
                                  controller: _genderController,
                                  textCapitalization: TextCapitalization.words,
                                  onCopy: () =>
                                      context.read<MyInfoCubit>().copyField(
                                        label: 'Gender',
                                        value: _genderController.text,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          MyInfoSectionCard(
                            title: 'Contact Details',
                            child: Column(
                              children: [
                                MyInfoInputField(
                                  label: 'Phone',
                                  controller: _phoneController,
                                  keyboardType: TextInputType.phone,
                                  validator: _optionalPhoneValidator,
                                  onCopy: () =>
                                      context.read<MyInfoCubit>().copyField(
                                        label: 'Phone',
                                        value: _phoneController.text,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                MyInfoInputField(
                                  label: 'Email',
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _optionalEmailValidator,
                                  onCopy: () =>
                                      context.read<MyInfoCubit>().copyField(
                                        label: 'Email',
                                        value: _emailController.text,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                MyInfoInputField(
                                  label: 'Address',
                                  controller: _addressController,
                                  maxLines: 3,
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
                                  label: 'City',
                                  controller: _cityController,
                                  textCapitalization: TextCapitalization.words,
                                  onCopy: () =>
                                      context.read<MyInfoCubit>().copyField(
                                        label: 'City',
                                        value: _cityController.text,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                MyInfoInputField(
                                  label: 'State',
                                  controller: _stateController,
                                  textCapitalization: TextCapitalization.words,
                                  onCopy: () =>
                                      context.read<MyInfoCubit>().copyField(
                                        label: 'State',
                                        value: _stateController.text,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                MyInfoInputField(
                                  label: 'Pin Code',
                                  controller: _pinCodeController,
                                  keyboardType: TextInputType.number,
                                  onCopy: () =>
                                      context.read<MyInfoCubit>().copyField(
                                        label: 'Pin Code',
                                        value: _pinCodeController.text,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          MyInfoSectionCard(
                            title: 'Sensitive Details',
                            subtitle: 'Masked by default for privacy.',
                            child: Column(
                              children: [
                                MyInfoInputField(
                                  label: 'Aadhaar',
                                  controller: _aadhaarController,
                                  keyboardType: TextInputType.number,
                                  displayText: state.isAadhaarObscured
                                      ? SensitiveValueFormatter.maskLast4(
                                          _aadhaarController.text,
                                        )
                                      : null,
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
                                  label: 'PAN',
                                  controller: _panController,
                                  keyboardType: TextInputType.text,
                                  displayText: state.isPanObscured
                                      ? SensitiveValueFormatter.maskLast4(
                                          _panController.text,
                                        )
                                      : null,
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
                          const SizedBox(height: 16),
                          MyInfoSectionCard(
                            title: 'Education & Profile',
                            child: Column(
                              children: [
                                MyInfoInputField(
                                  label: 'School/College',
                                  controller: _schoolCollegeController,
                                  textCapitalization: TextCapitalization.words,
                                  onCopy: () =>
                                      context.read<MyInfoCubit>().copyField(
                                        label: 'School/College',
                                        value: _schoolCollegeController.text,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                MyInfoInputField(
                                  label: 'Qualification',
                                  controller: _qualificationController,
                                  textCapitalization: TextCapitalization.words,
                                  onCopy: () =>
                                      context.read<MyInfoCubit>().copyField(
                                        label: 'Qualification',
                                        value: _qualificationController.text,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                MyInfoInputField(
                                  label: 'Category',
                                  controller: _categoryController,
                                  textCapitalization: TextCapitalization.words,
                                  onCopy: () =>
                                      context.read<MyInfoCubit>().copyField(
                                        label: 'Category',
                                        value: _categoryController.text,
                                      ),
                                ),
                                const SizedBox(height: 12),
                                MyInfoInputField(
                                  label: 'Nationality',
                                  controller: _nationalityController,
                                  textCapitalization: TextCapitalization.words,
                                  onCopy: () =>
                                      context.read<MyInfoCubit>().copyField(
                                        label: 'Nationality',
                                        value: _nationalityController.text,
                                      ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            AppStrings.privacyMessage,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
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
    final text = value?.trim() ?? '';
    if (text.isEmpty) {
      return null;
    }
    final valid = RegExp(r'^[0-9+\-\s]{8,15}$').hasMatch(text);
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
}
