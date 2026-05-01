import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/di.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/widgets/section_card.dart';
import '../../../../core/widgets/app_top_header.dart';
import '../../../my_info/presentation/cubit/my_info_cubit.dart';
import '../../../my_info/presentation/cubit/my_info_state.dart';
import '../../../my_info/presentation/widgets/profile_overview_card.dart';
import '../../../my_info/presentation/widgets/profile_photo_flow.dart';
import '../cubit/app_lock_cubit.dart';
import '../cubit/privacy_cubit.dart';
import '../widgets/delete_all_data_dialog.dart';
import '../widgets/pin_setup_sheet.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final PrivacyCubit _privacyCubit;
  late final AppLockCubit _appLockCubit;
  late final MyInfoCubit _myInfoCubit;

  @override
  void initState() {
    super.initState();
    _privacyCubit = PrivacyCubit(
      getPrivacySettingsUseCase: sl(),
      markPrivacyIntroSeenUseCase: sl(),
      savePrivacySettingsUseCase: sl(),
      wipeLocalDataUseCase: sl(),
    )..load();
    _appLockCubit = AppLockCubit(
      enableAppLockUseCase: sl(),
      verifyAppLockUseCase: sl(),
      disableAppLockUseCase: sl(),
      shouldLockUseCase: sl(),
    )..refreshLockStatus();
    _myInfoCubit = MyInfoCubit(
      getUserInfoUseCase: sl(),
      saveUserInfoUseCase: sl(),
    )..loadUserInfo();
  }

  @override
  void dispose() {
    _privacyCubit.close();
    _appLockCubit.close();
    _myInfoCubit.close();
    super.dispose();
  }

  void _showDeleteAllDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => DeleteAllDataDialog(
        onConfirm: context.read<PrivacyCubit>().wipeLocalData,
      ),
    );
  }

  Future<void> _editProfilePhoto(MyInfoState state) async {
    try {
      final updatedPath = await pickProfilePhoto(context);
      if (updatedPath == null) return;
      await _myInfoCubit.saveUserInfo(
        state.userInfo.copyWith(profilePhotoPath: updatedPath),
        showFeedback: false,
      );
      if (!mounted) return;
      if (_myInfoCubit.state.status == MyInfoStatus.failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not save profile photo.')),
        );
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save profile photo.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _privacyCubit),
        BlocProvider.value(value: _appLockCubit),
        BlocProvider.value(value: _myInfoCubit),
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppTopHeader<_SettingsMenuAction>(
              title: 'Settings',
              automaticallyImplyLeading: false,
              rightActionType: AppTopHeaderRightActionType.menu,
              menuItems: const [
                AppTopHeaderMenuItem<_SettingsMenuAction>(
                  value: _SettingsMenuAction.deleteAllInfo,
                  label: AppStrings.deleteAllInfoAction,
                  icon: Icons.delete_forever_outlined,
                  destructive: true,
                ),
              ],
              onMenuAction: (action) {
                if (action == _SettingsMenuAction.deleteAllInfo) {
                  _showDeleteAllDialog(context);
                }
              },
            ),
            body: SafeArea(
                child: Padding(
                padding: const EdgeInsets.all(AppSizes.md),
                child: ListView(
                  children: [
                    BlocBuilder<MyInfoCubit, MyInfoState>(
                      builder: (context, infoState) {
                        if (infoState.isLoading || infoState.status == MyInfoStatus.initial) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: AppSizes.lg),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final userInfo = infoState.userInfo;
                        return ProfileIdentityCard(
                          profilePhotoPath: userInfo.profilePhotoPath,
                          displayName: userInfo.fullName.trim(),
                          title: 'Your Profile',
                          fallbackIdentityText: 'Add your name in Info',
                          supportingText:
                              'Update your photo here, then manage full profile details from Info.',
                          onTap: () => context.push('/my-info'),
                          onAvatarTap: () => _editProfilePhoto(infoState),
                        );
                      },
                    ),
                    const SizedBox(height: AppSizes.md),
                    BlocBuilder<AppLockCubit, AppLockState>(
                      builder: (context, lockState) {
                        final enabled = lockState.status != AppLockStatus.disabled;
                        return SectionCard(
                          child: SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            secondary: const Icon(Icons.lock_outline_rounded),
                            title: const Text(AppStrings.appLockTitle),
                            subtitle: const Text(AppStrings.appLockSubtitle),
                            value: enabled,
                            onChanged: (value) {
                              if (value) {
                                showModalBottomSheet<void>(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) => PinSetupSheet(
                                    onSubmit: context.read<AppLockCubit>().enable,
                                  ),
                                );
                              } else {
                                context.read<AppLockCubit>().disable();
                              }
                            },
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSizes.md),
                    BlocBuilder<PrivacyCubit, PrivacyState>(
                      builder: (context, privacyState) {
                        return SectionCard(
                          child: SwitchListTile(
                            contentPadding: EdgeInsets.zero,
                            secondary: const Icon(Icons.visibility_off_outlined),
                            title: const Text('Mask sensitive values'),
                            subtitle: const Text(
                              'Show Aadhaar and PAN in last-4 style by default.',
                            ),
                            value: privacyState.settings.sensitiveMaskingEnabled,
                            onChanged: context
                                .read<PrivacyCubit>()
                                .setMaskingEnabled,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

enum _SettingsMenuAction { deleteAllInfo }
