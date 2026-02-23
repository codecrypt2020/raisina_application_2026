import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({
    super.key,
    required this.profile,
  });

  final Map profile;

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> _passwordFormKey = GlobalKey<FormState>();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _hideOldPassword = true;
  bool _hideNewPassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String _asString(dynamic value) => value?.toString() ?? '';

  InputDecoration _fieldDecoration(
    BuildContext context, {
    String? hintText,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.elevatedOf(context),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.borderOf(context)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: AppColors.borderOf(context)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.gold),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _label(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: TextStyle(
          color: AppColors.textSecondaryOf(context),
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          fontSize: 13,
        ),
      ),
    );
  }

  void _updatePassword() {
    if (!_passwordFormKey.currentState!.validate()) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Update password UI ready')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 900;
    final String fullName = _asString(widget.profile['name']);
    final String email = _asString(widget.profile['primary_email']);
    final String displayName = fullName.isEmpty ? 'User' : fullName;
    final String initials = displayName
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .take(2)
        .map((part) => part[0].toUpperCase())
        .join();
    final bool isDarkMode = AppColors.isDark(context);
    final Color primaryButtonBg =
        isDarkMode ? AppColors.goldLight : AppColors.gold;

    return Scaffold(
      backgroundColor: AppColors.surfaceOf(context),
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 960),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.elevatedOf(context),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderOf(context)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'My Profile',
                        style: TextStyle(
                          color: AppColors.textPrimaryOf(context),
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 56,
                              backgroundColor: AppColors.goldDim,
                              child: Text(
                                initials.isEmpty ? 'U' : initials,
                                style: TextStyle(
                                  color: AppColors.textPrimaryOf(context),
                                  fontSize: 26,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.elevatedOf(context),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.borderOf(context),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit_outlined,
                                  size: 18,
                                  color: AppColors.gold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (isWide)
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label(context, 'NAME'),
                                  TextFormField(
                                    initialValue: displayName,
                                    readOnly: true,
                                    decoration: _fieldDecoration(context),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label(context, 'EMAIL'),
                                  TextFormField(
                                    initialValue:
                                        email.isEmpty ? 'Not available' : email,
                                    readOnly: true,
                                    decoration: _fieldDecoration(context),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      else ...[
                        _label(context, 'NAME'),
                        TextFormField(
                          initialValue: displayName,
                          readOnly: true,
                          decoration: _fieldDecoration(context),
                        ),
                        const SizedBox(height: 14),
                        _label(context, 'EMAIL'),
                        TextFormField(
                          initialValue: email.isEmpty ? 'Not available' : email,
                          readOnly: true,
                          decoration: _fieldDecoration(context),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Center(
                        child: SizedBox(
                          width: 210,
                          height: 48,
                          child: FilledButton(
                            onPressed: () {},
                            style: FilledButton.styleFrom(
                              backgroundColor: primaryButtonBg,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.elevatedOf(context),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderOf(context)),
                  ),
                  child: Form(
                    key: _passwordFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Change Password',
                          style: TextStyle(
                            color: AppColors.textPrimaryOf(context),
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (isWide)
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _label(context, 'OLD PASSWORD'),
                                    TextFormField(
                                      controller: _oldPasswordController,
                                      obscureText: _hideOldPassword,
                                      decoration: _fieldDecoration(
                                        context,
                                        hintText: 'Current Password',
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _hideOldPassword =
                                                  !_hideOldPassword;
                                            });
                                          },
                                          icon: Icon(
                                            _hideOldPassword
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Enter old password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _label(context, 'NEW PASSWORD'),
                                    TextFormField(
                                      controller: _newPasswordController,
                                      obscureText: _hideNewPassword,
                                      decoration: _fieldDecoration(
                                        context,
                                        hintText: 'New Password',
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _hideNewPassword =
                                                  !_hideNewPassword;
                                            });
                                          },
                                          icon: Icon(
                                            _hideNewPassword
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Enter new password';
                                        }
                                        if (value.length < 8) {
                                          return 'Use at least 8 characters';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _label(context, 'CONFIRM PASSWORD'),
                                    TextFormField(
                                      controller: _confirmPasswordController,
                                      obscureText: _hideConfirmPassword,
                                      decoration: _fieldDecoration(
                                        context,
                                        hintText: 'Confirm Password',
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _hideConfirmPassword =
                                                  !_hideConfirmPassword;
                                            });
                                          },
                                          icon: Icon(
                                            _hideConfirmPassword
                                                ? Icons.visibility_outlined
                                                : Icons.visibility_off_outlined,
                                          ),
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Confirm password';
                                        }
                                        if (value !=
                                            _newPasswordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )
                        else ...[
                          _label(context, 'OLD PASSWORD'),
                          TextFormField(
                            controller: _oldPasswordController,
                            obscureText: _hideOldPassword,
                            decoration: _fieldDecoration(
                              context,
                              hintText: 'Current Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _hideOldPassword = !_hideOldPassword;
                                  });
                                },
                                icon: Icon(
                                  _hideOldPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter old password';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          _label(context, 'NEW PASSWORD'),
                          TextFormField(
                            controller: _newPasswordController,
                            obscureText: _hideNewPassword,
                            decoration: _fieldDecoration(
                              context,
                              hintText: 'New Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _hideNewPassword = !_hideNewPassword;
                                  });
                                },
                                icon: Icon(
                                  _hideNewPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Enter new password';
                              }
                              if (value.length < 8) {
                                return 'Use at least 8 characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 14),
                          _label(context, 'CONFIRM PASSWORD'),
                          TextFormField(
                            controller: _confirmPasswordController,
                            obscureText: _hideConfirmPassword,
                            decoration: _fieldDecoration(
                              context,
                              hintText: 'Confirm Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _hideConfirmPassword =
                                        !_hideConfirmPassword;
                                  });
                                },
                                icon: Icon(
                                  _hideConfirmPassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Confirm password';
                              }
                              if (value != _newPasswordController.text) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                          ),
                        ],
                        const SizedBox(height: 18),
                        Center(
                          child: SizedBox(
                            width: 240,
                            height: 50,
                            child: FilledButton(
                              onPressed: _updatePassword,
                              style: FilledButton.styleFrom(
                                backgroundColor: primaryButtonBg,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Update Password',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
