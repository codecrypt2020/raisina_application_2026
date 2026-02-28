import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:attendee_app/constants.dart';
import 'package:attendee_app/utility.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart';

import 'dart:convert';

import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
  var old_password;
  var tosattext;
  var profile_picture;
  var profileimageurl;
  File? _selectedImage;
  bool _isSaving = false;
  bool _isSavingimage = false;
  bool _isImagesize = false;
  bool _isPasswordDialogOpen = false;
  bool _isImageDialogOpen = false;
  bool _cancelPasswordSave = false;
  bool _cancelImageSave = false;
  var success;
  var successimage;

  final ImagePicker _picker = ImagePicker();

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
      hintStyle: TextStyle(
        fontSize: 13,
        color: AppColors.textMutedOf(context),
      ),
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

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);

    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      // Image size in bytes
      int imageSize = await imageFile.length();

      // Convert limits
      // int minSize = 200 * 1024; // 200 KB
      // int maxSize = 5 * 1024 * 1024; // 5 MB
      int minSize = 200000;
      int maxSize = 5242880;

      // Validation
      if (imageSize < minSize || imageSize > maxSize) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Image must be between 200KB and 5MB",
            ),
          ),
        );
        return;
      } else {
        _isImagesize = true;
        setState(() {
          _selectedImage = imageFile;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              "Don't forget to click Save to update your photo",
            ),
          ),
        );
      }
      print("Selected Image: $_selectedImage");
    }
  }

  Future<bool> _requestPermissions(ImageSource source) async {
    Permission permission;

    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      permission = Permission.photos;
    }

    var status = await permission.status;

    /// Already granted
    if (status.isGranted) {
      return true;
    }

    /// Request permission
    status = await permission.request();

    if (status.isGranted) {
      return true;
    }

    /// Permanently denied → open settings
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }

    return false;
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          top: false,
          minimum: const EdgeInsets.only(bottom: 12),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Choose from Gallery"),
                onTap: () async {
                  Navigator.pop(context);

                  bool granted = await _requestPermissions(ImageSource.gallery);

                  if (granted) {
                    _pickImage(ImageSource.gallery);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Permission denied. Please allow permission."),
                      ),
                    );
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Take Photo"),
                onTap: () async {
                  Navigator.pop(context);

                  bool granted = await _requestPermissions(ImageSource.camera);

                  if (granted) {
                    _pickImage(ImageSource.camera);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text("Permission denied. Please allow permission."),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
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

  Widget _readOnlyProfileText(BuildContext context, String value) {
    return Text(
      value,
      style: TextStyle(
        fontSize: 14,
        color: AppColors.textPrimaryOf(context),
        fontWeight: FontWeight.w500,
      ),
    );
  }

  void _dismissPasswordDialogIfOpen() {
    if (!_isPasswordDialogOpen || !mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    _isPasswordDialogOpen = false;
  }

  void _dismissImageDialogIfOpen() {
    if (!_isImageDialogOpen || !mounted) return;
    Navigator.of(context, rootNavigator: true).pop();
    _isImageDialogOpen = false;
  }

  void _updatePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;
    _cancelPasswordSave = false;
    setState(() => _isSaving = true);
    _isPasswordDialogOpen = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return PopScope(
          canPop: false, // Back button disable
          child: Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 8,
            child: SizedBox(
              height: 120,
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, top: 8),
                      child: IconButton(
                        icon: const Icon(Icons.close, color: Colors.black),
                        onPressed: () {
                          _cancelPasswordSave = true;
                          if (mounted) {
                            setState(() => _isSaving = false);
                          }
                          _dismissPasswordDialogIfOpen();
                        },
                      ),
                    ),
                  ),
                  const Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 15),
                        Text(
                          "Saving...",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    await password_change();
    if (!mounted) return;
    setState(() => _isSaving = false);
    if (_cancelPasswordSave) return;

    if (success) {
      _dismissPasswordDialogIfOpen();
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tosattext)),
      );

      return;
    } else {
      _dismissPasswordDialogIfOpen();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    Fetch_emp_profile();
    super.initState();
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

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                                backgroundImage: _selectedImage != null
                                    ? FileImage(_selectedImage!)
                                        as ImageProvider
                                    : (profile_picture != null &&
                                            profile_picture['emp_profilepic'] !=
                                                null &&
                                            profile_picture['emp_profilepic']
                                                .toString()
                                                .isNotEmpty)
                                        ? NetworkImage(profile_picture[
                                            'emp_profilepic']) as ImageProvider
                                        : null,
                                child: (_selectedImage == null &&
                                        (profile_picture == null ||
                                            profile_picture['emp_profilepic'] ==
                                                null ||
                                            profile_picture['emp_profilepic']
                                                .toString()
                                                .isEmpty))
                                    ? Text(
                                        initials.isEmpty ? 'U' : initials,
                                        style: TextStyle(
                                          color:
                                              AppColors.textPrimaryOf(context),
                                          fontSize: 26,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      )
                                    : null,
                              ),
                              Positioned(
                                right: -2,
                                bottom: -2,
                                child: GestureDetector(
                                  onTap: _showImagePickerOptions,
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
                                    _label(context, 'Name'),
                                    _readOnlyProfileText(context, displayName),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    _label(context, 'Email'),
                                    _readOnlyProfileText(
                                        context,
                                        email.isEmpty
                                            ? 'Not available'
                                            : email),
                                  ],
                                ),
                              ),
                            ],
                          )
                        else ...[
                          _label(context, 'Name'),
                          _readOnlyProfileText(context, displayName),
                          const SizedBox(height: 14),
                          _label(context, 'Email'),
                          _readOnlyProfileText(
                              context, email.isEmpty ? 'Not available' : email),
                        ],
                        const SizedBox(height: 16),
                        Center(
                          child: SizedBox(
                            width: 210,
                            height: 48,
                            child:
                                // FilledButton(
                                //   onPressed: () {
                                //   if(_selectedImage !=null){
                                //      profileImageUpload(_selectedImage!).then((value) {
                                //      Fetch_emp_profile();
                                //      Navigator.pop(context, true);
                                //      });
                                //   }
                                //   },
                                //   style: FilledButton.styleFrom(
                                //     backgroundColor: primaryButtonBg,
                                //     foregroundColor: Colors.white,
                                //     shape: RoundedRectangleBorder(
                                //       borderRadius: BorderRadius.circular(8),
                                //     ),
                                //   ),
                                //   child: const Text(
                                //     'Save Changes',
                                //     style: TextStyle(
                                //       fontWeight: FontWeight.w700,
                                //       fontSize: 16,
                                //     ),
                                //   ),
                                // ),
                                FilledButton(
                              onPressed: (_isImagesize == false)
                                  ? null
                                  : () async {
                                      _cancelImageSave = false;
                                      setState(() => _isSavingimage = true);
                                      _isImageDialogOpen = true;
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) {
                                          return PopScope(
                                            canPop:
                                                false, // Back button disable
                                            child: Dialog(
                                              backgroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              elevation: 8,
                                              child: SizedBox(
                                                height: 120,
                                                child: Stack(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          Alignment.topRight,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 8,
                                                                top: 8),
                                                        child: IconButton(
                                                          icon: const Icon(
                                                              Icons.close,
                                                              color:
                                                                  Colors.black),
                                                          onPressed: () {
                                                            _cancelImageSave =
                                                                true;
                                                            if (mounted) {
                                                              setState(() =>
                                                                  _isSavingimage =
                                                                      false);
                                                            }
                                                            _dismissImageDialogIfOpen();
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    const Center(
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          CircularProgressIndicator(),
                                                          SizedBox(height: 15),
                                                          Text(
                                                            "Saving...",
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );

                                      await profileImageUpload(_selectedImage!);
                                      if (_cancelImageSave || !mounted) return;
                                      await Fetch_emp_profile();
                                      if (_cancelImageSave || !mounted) return;
                                      if (!mounted) return;
                                      setState(() => _isSavingimage = false);
                                      if (_cancelImageSave) return;

                                      if (successimage) {
                                        _dismissImageDialogIfOpen();
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  'Profile updated successfully')),
                                        );

                                        return;
                                      } else {
                                        _dismissImageDialogIfOpen();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content:
                                                  Text('Something went wrong')),
                                        );
                                      }
                                    },
                              style: FilledButton.styleFrom(
                                backgroundColor: primaryButtonBg,
                                disabledBackgroundColor: Colors.grey,
                                disabledForegroundColor: Colors.white70,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _label(context, 'Old Password'),
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
                                                  : Icons
                                                      .visibility_off_outlined,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _label(context, 'New Password'),
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
                                                  : Icons
                                                      .visibility_off_outlined,
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null ||
                                              value.trim().isEmpty) {
                                            return 'Enter new password';
                                          }
                                          // if (value.length < 8) {
                                          //   return 'Use at least 8 characters';
                                          // }
                                          // return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _label(context, 'Confirm Password'),
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
                                                  : Icons
                                                      .visibility_off_outlined,
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
                            _label(context, 'Old Password'),
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
                            _label(context, 'New Password'),
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
                                // if (value.length < 8) {
                                //   return 'Use at least 8 characters';
                                // }
                                // return null;
                              },
                            ),
                            const SizedBox(height: 14),
                            _label(context, 'Confirm Password'),
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
      ),
    );
  }

  Future Fetch_emp_profile() async {
    try {
      var response = await http.post(
        Uri.parse(Constants.NODE_URL + Constants.emp_profile),
        headers: {
          "x-encrypted": "1",
          //   'x-access-token': '${Hive.box("LoginDetails").get("token")}',
          // 'x-access-type': '${Hive.box("LoginDetails").get("usertype")}',
          'x-access-token':
              '${Hive.box('LoginDetails').get("Profile_details")['token']}',
          'x-access-type':
              '${Hive.box('LoginDetails').get("Profile_details")['token']}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          encryptPayload(
            {"empId": null},
          ),
        ),
      );
      print(
          'this is the profile details ${Hive.box('LoginDetails').get("Profile_details")}');
      var jsonData = decryptResponse(response.body);
      if (response.statusCode == 200 && jsonData["success"] == true) {
        old_password = jsonData['data'][0]['password'];
        profile_picture = jsonData['emp_profilepic'][0];
        setState(() {});
        print("password test:${profile_picture}");
        var res = decryptResponse(response.body);
        return res["data"][0]["user_qr_img"];
      }
    } catch (e) {
      debugPrint(
          "this is the error in assignedUserDetailsApidvgdfgghgfjgghgdfdshjffdsffsds : $e");
    }
  }

  Future<void> profileImageUpload(File _selectedImage) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse(Constants.NODE_URL + Constants.profile_image),
      );

      // Headers
      request.headers.addAll({
        "x-encrypted": "1",
        'x-access-token':
            '${Hive.box('LoginDetails').get("Profile_details")['token']}',
        'x-access-type':
            '${Hive.box('LoginDetails').get("Profile_details")['token']}',
      });

      request.files.add(
        await http.MultipartFile.fromPath(
          "images",
          _selectedImage.path,
        ),
      );

      // Send request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = decryptResponse(response.body);
        profileimageurl = jsonData['image']['url'];
        successimage = true;
        emp_profile_save_photo();
        // Hive.box("LoginDetails")
        //     .put("Profile_details", jsonData["data"]);
        print("image url test done:${profileimageurl}");
        if (mounted) {
          setState(() {});
        }
      } else {
        successimage = false;
        print("Upload failed: ${response.statusCode}");
      }
    } catch (e) {
      print("This is the error $e");
    }
  }

//////////////////////////
  ///emp_profile_save_photo
  Future emp_profile_save_photo() async {
    try {
      var response = await http.post(
        Uri.parse(Constants.NODE_URL + Constants.emp_profile_save_photo),
        headers: {
          "x-encrypted": "1",
          //   'x-access-token': '${Hive.box("LoginDetails").get("token")}',
          // 'x-access-type': '${Hive.box("LoginDetails").get("usertype")}',
          'x-access-token':
              '${Hive.box('LoginDetails').get("Profile_details")['token']}',
          'x-access-type':
              '${Hive.box('LoginDetails').get("Profile_details")['token']}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          encryptPayload(
            {
              "name":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['name']}",
              "first_name":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['first_name']}",
              "last_name":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['last_name']}",
              "designation":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['designation']}",
              "organization":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['organization']}",
              "primary_phone":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['primary_phone']}",
              "country_code":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['country_code']}",
              "primary_email":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['primary_email']}",
              "bio":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['bio']}",
              "area_of_expertise":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['area_of_expertise']}",
              "social": {
                "twitter":
                    "${Hive.box('LoginDetails').get("imagsave")['profile']['social']['twitter']}"
              },
              "id":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['id']}",
              "qr_internal_id":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['qr_internal_id']}",
              "status":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['status']}",
              "title":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['title']}",
              "dietary_requirements":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['dietary_requirements']}",
              "dining_invites":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['dining_invites']}",
              "email":
                  "${Hive.box('LoginDetails').get("imagsave")['profile']['primary_email']}",
              "emp_profilepic": "${profileimageurl}",
            },
          ),
        ),
      );
      print(
          'this is the profile details ${Hive.box('LoginDetails').get("Profile_details")}');
      var jsonData = decryptResponse(response.body);
      if (response.statusCode == 200 && jsonData["success"] == true) {
        old_password = jsonData['data'][0]['password'];
        profile_picture = jsonData['emp_profilepic'][0];
        setState(() {});

        // var res = decryptResponse(response.body);
        // return res["data"][0]["user_qr_img"];
      }
    } catch (e) {
      debugPrint("this is the error in assignedUserDetailsApi: $e");
    }
  }

  Future password_change() async {
    try {
      var response = await http.post(
        Uri.parse(Constants.NODE_URL + Constants.Change_password),
        headers: {
          "x-encrypted": "1",
          //   'x-access-token': '${Hive.box("LoginDetails").get("token")}',
          // 'x-access-type': '${Hive.box("LoginDetails").get("usertype")}',
          'x-access-token':
              '${Hive.box('LoginDetails').get("Profile_details")['token']}',
          'x-access-type':
              '${Hive.box('LoginDetails').get("Profile_details")['token']}',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
          encryptPayload(
            {
              "oldPassword": "${_oldPasswordController.text}",
              "newPassword":
                  "${_newPasswordController.text}", //!= old_password ?_newPasswordController.text :old_password}",
              "confirmNewPassword":
                  "${_confirmPasswordController.text}", //!= old_password ?_confirmPasswordController.text :old_password}",
              "email": "${widget.profile['primary_email']}"
            },
          ),
        ),
      );
      print(
          'this is the profile details ${Hive.box('LoginDetails').get("Profile_details")}');
      var jsonData = decryptResponse(response.body);
      if (response.statusCode == 200 && jsonData["success"] == true) {
        success = true;
        tosattext = jsonData['message'];
        setState(() {});
      } else {
        success = false;
      }
    } catch (e) {
      debugPrint("this is the error in assignedUserDetailsApi: $e");
    }
  }
}
