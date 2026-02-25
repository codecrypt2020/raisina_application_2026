import 'dart:convert';
import 'package:attendee_app/main.dart';
import 'package:flutter/material.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:attendee_app/constants.dart';
import 'package:attendee_app/utility.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    required this.profile,
  });

  final Map profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isSaving = false;

  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _bioController;
  //late final TextEditingController _dietaryController;
  var _selectedDietary;
  var _primary_email;
  var _id;
  String _selectedCountryCode = "+91";

  // final List<String> _titles = ['Mr.', 'Ms.', 'Mrs.', 'Dr.'];
  final List<String> _titles = [
    'Mr.',
    'Ms.',
    'Mrs.',
    'Dr.',
    'Prof.',
    'Shri',
    'Smt.',
    'Amb.',
    'Senator',
    'Brig',
    'Maj. Gen.',
    'Lt. Gen.',
    'Air Mshl',
    'AVM',
    'VADM',
    'H.E. Mr.',
    'H.E. Ms.',
    'H.E. Amb.',
    'H.E. Dr.'
  ];
  String _selectedTitle = 'Mr.';

  @override
  void initState() {
    super.initState();
    final String fullName = _asString(widget.profile['name']);
    final List<String> nameParts = fullName.trim().split(RegExp(r'\s+'));
    final String firstName = _asString(widget.profile['first_name']).isNotEmpty
        ? _asString(widget.profile['first_name'])
        : "";
    // : (nameParts.isNotEmpty ? nameParts.first : '');
    final String lastName = _asString(widget.profile['last_name']).isNotEmpty
        ? _asString(widget.profile['last_name'])
        : "";
    // : (nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '');
    final String incomingTitle = _asString(widget.profile['title']);
    _selectedTitle =
        _titles.contains(incomingTitle) ? incomingTitle : _selectedTitle;

    _firstNameController = TextEditingController(text: firstName);
    _lastNameController = TextEditingController(text: lastName);
    _phoneController =
        TextEditingController(text: _asString(widget.profile['primary_phone']));
    _bioController =
        TextEditingController(text: _asString(widget.profile['bio']));
    // _dietaryController = TextEditingController(
    //   text: _asString(widget.profile['dietary_requirements']),
    // );
    _selectedDietary = _asString(widget.profile['dietary_requirements']);
    _primary_email = _asString(widget.profile['primary_email']);
    _id = _asString(widget.profile['id']);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    // _dietaryController.dispose();
    // _selectedDietary.dispose();
    super.dispose();
  }

  String _asString(dynamic value) => value?.toString() ?? '';

  int _wordCount(String value) {
    if (value.trim().isEmpty) {
      return 0;
    }
    return value.trim().split(RegExp(r'\s+')).length;
  }

  InputDecoration _fieldDecoration(BuildContext context) {
    return InputDecoration(
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
          letterSpacing: 1,
          fontSize: 13,
        ),
      ),
    );
  }

  bool _validateRequiredFields() {
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        // _dietaryController.text.trim().isEmpty
        _selectedDietary == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill in all required fields"),
          duration: Duration(seconds: 2),
        ),
      );

      return false;
    }

    return true;
  }

  Future<void> _saveProfile() async {
    if (_isSaving) return;

    if (!_validateRequiredFields()) {
      return;
    }

    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);
    final bool success = await Profile_edit_save();
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      Navigator.pop(context, true);
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Something went wrong')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isWide = MediaQuery.of(context).size.width >= 900;
    final int bioWords = _wordCount(_bioController.text);
    final bool isDarkMode = AppColors.isDark(context);
    final Color cancelBg =
        isDarkMode ? AppColors.surfaceSoftOf(context) : AppColors.red;
    final Color cancelFg =
        isDarkMode ? AppColors.textPrimaryOf(context) : Colors.white;
    final Color saveBg = isDarkMode ? AppColors.goldLight : AppColors.gold;
    return Scaffold(
      backgroundColor: AppColors.surfaceOf(context),
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 960),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: AppColors.elevatedOf(context),
                          borderRadius: BorderRadius.circular(14),
                          border:
                              Border.all(color: AppColors.borderOf(context)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (isWide)
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label(context, 'TITLE'),
                                        DropdownButtonFormField<String>(
                                          value: _selectedTitle,
                                          decoration: _fieldDecoration(context),
                                          dropdownColor:
                                              AppColors.elevatedOf(context),
                                          items: _titles
                                              .map(
                                                (title) => DropdownMenuItem(
                                                  value: title,
                                                  child: Text(title),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                _selectedTitle = value;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label(context, 'FIRST NAME'),
                                        TextFormField(
                                          controller: _firstNameController,
                                          decoration: _fieldDecoration(context),
                                          validator: (value) {
                                            if (value == null ||
                                                value.trim().isEmpty) {
                                              return 'First name is required';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 4,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _label(context, 'LAST NAME'),
                                        TextFormField(
                                          controller: _lastNameController,
                                          decoration: _fieldDecoration(context),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )
                            else ...[
                              _label(context, 'TITLE'),
                              DropdownButtonFormField<String>(
                                value: _selectedTitle,
                                decoration: _fieldDecoration(context),
                                dropdownColor: AppColors.elevatedOf(context),
                                items: _titles
                                    .map(
                                      (title) => DropdownMenuItem(
                                        value: title,
                                        child: Text(title),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedTitle = value;
                                    });
                                  }
                                },
                              ),
                              const SizedBox(height: 16),
                              _label(context, 'FIRST NAME'),
                              TextFormField(
                                controller: _firstNameController,
                                decoration: _fieldDecoration(context),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'First name is required';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              _label(context, 'LAST NAME'),
                              TextFormField(
                                controller: _lastNameController,
                                decoration: _fieldDecoration(context),
                              ),
                            ],
                            const SizedBox(height: 16),
                            // _label(context, 'PRIMARY PHONE'),
                            // TextFormField(
                            //   controller: _phoneController,
                            //   keyboardType: TextInputType.phone,
                            //   decoration: _fieldDecoration(context),
                            // ),
                            _label(context, 'PRIMARY PHONE'),

                            TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: _fieldDecoration(context).copyWith(
                                prefixIcon: CountryCodePicker(
                                  onChanged: (country) {
                                    _selectedCountryCode =
                                        country.dialCode ?? "+91";
                                  },
                                  initialSelection:
                                      widget.profile["country_code"] ?? 'IN',
                                  // favorite: const ['+91', 'US', 'GB'],
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  showFlag: true,
                                  alignLeft: false,
                                  padding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            _label(context, 'BIO (Not more than 50 Words)'),
                            TextFormField(
                              controller: _bioController,
                              maxLines: 5,
                              decoration: _fieldDecoration(context).copyWith(
                                alignLabelWithHint: true,
                                helperText: '$bioWords / 50 words',
                                helperStyle: TextStyle(
                                  color: AppColors.textMutedOf(context),
                                ),
                              ),
                              onChanged: (_) => setState(() {}),
                              validator: (value) {
                                final count = _wordCount(value ?? '');
                                if (count > 50) {
                                  return 'Bio should be 50 words or less';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            //   _label(context, 'DIETARY PREFERENCE'),
                            //   TextFormField(
                            //     controller: _dietaryController,
                            //     decoration: _fieldDecoration(context),
                            //  ),

                            _label(context, 'DIETARY PREFERENCE'),

                            DropdownButtonFormField<String>(
                              value: _selectedDietary,
                              decoration: _fieldDecoration(context),
                              items: const [
                                DropdownMenuItem(
                                    value: 'Vegetarian',
                                    child: Text('Vegetarian')),
                                DropdownMenuItem(
                                    value: 'Non-Vegetarian',
                                    child: Text('Non-Vegetarian')),
                                DropdownMenuItem(
                                    value: 'Vegan', child: Text('Vegan')),
                                DropdownMenuItem(
                                    value: 'Other', child: Text('Other')),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedDietary = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: FilledButton(
                                onPressed: _isSaving
                                    ? null
                                    : () => Navigator.pop(context),
                                style: FilledButton.styleFrom(
                                  backgroundColor: cancelBg,
                                  foregroundColor: cancelFg,
                                  side: isDarkMode
                                      ? BorderSide(
                                          color: AppColors.borderOf(context))
                                      : BorderSide.none,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Cancel',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: FilledButton(
                                onPressed: _isSaving ? null : _saveProfile,
                                style: FilledButton.styleFrom(
                                  backgroundColor: saveBg,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: _isSaving
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2.4,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : const Text(
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
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isSaving)
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black26,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<bool> Profile_edit_save() async {
    try {
      var response = await http.post(
        Uri.parse(Constants.NODE_URL + Constants.profile_edit),
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
              "title": "${_selectedTitle}", //
              "firstName": "${_firstNameController.text}",
              "lastName": "${_lastNameController.text}",
              "countryCode": "${_selectedCountryCode}",
              "phone": "${_phoneController.text}",
              "bio": "${_bioController.text}",
              "twitter_handle": "",
              "linkedin_url": "",
              "website_url": "",
              "dietary_preference": "${_selectedDietary}",
              "id": "${_id}", //
              "email": '${_primary_email}', //
            },
          ),
        ),
      );
      print(
          'this is the profile details ${Hive.box('LoginDetails').get("Profile_details")}');
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint("this is the error in assignedUserDetailsApi: $e");
      return false;
    }
  }
}
