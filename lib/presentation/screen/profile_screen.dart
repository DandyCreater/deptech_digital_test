// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:dep_tech/data/model/register_response_model.dart';
import 'package:dep_tech/data/model/user_response_model.dart';
import 'package:dep_tech/presentation/bloc/auth/login-bloc/login_bloc.dart';
import 'package:dep_tech/presentation/bloc/auth/update-user-bloc/update_user_bloc.dart';
import 'package:dep_tech/presentation/screen/homepage.dart';
import 'package:dep_tech/presentation/screen/login_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ProfileScreen extends StatefulWidget {
  final UserResponseModel? arguments;
  const ProfileScreen({required this.arguments, super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bornDateController = TextEditingController();
  String? dateTimeReq = "";
  DateTime bornDate = DateTime.now();
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateFormat formatRequestDate = DateFormat('yyyy-MM-dd');
  DateFormat showDate = DateFormat("dd MMMM yyyy");

  File? image = null;
  bool? changePass = false;

  String gender = "Pria";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newPasswordValidateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _formKeySecond = GlobalKey<FormState>();
  bool obsecure = true;
  bool obsecureValidate = true;
  bool obsecureNewValidate = true;
  var storage = const FlutterSecureStorage();
  LoginParamaterPost? params;

  pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to Pick Image : $e");
    }
  }

  List jenisKelamin = ["Pria", "Wanita"];

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: bornDate,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != bornDate) {
      final formatDate = DateFormat('dd MMMM yyyy');
      final formatRequestDate = DateFormat('yyyy-MM-dd');

      setState(() {
        bornDateController.text = formatDate.format(picked);
        dateTimeReq = formatRequestDate.format(picked);
      });
    }
  }

  readUserInfo() async {
    String? userData = await storage.read(key: 'keyUserData');
    var user = UserResponseModel.fromJson(jsonDecode(userData!));
    String? loginData = await storage.read(key: 'keyLogin');
    var decodeData = jsonDecode(loginData!);
    var data = LoginParamaterPost.fromJson(decodeData);

    var date = dateFormat.parse(user.bornDate!.toString());
    firstNameController.text = user.firstName!;
    lastNameController.text = user.lastName!;
    bornDateController.text = showDate.format(date);
    dateTimeReq = formatRequestDate.format(date);
    gender = user.gender!;
    emailController.text = user.email!;
    passwordController.text = data.password!;
  }

  readUserData() async {
    String? loginData = await storage.read(key: 'keyLogin');
    var decodeData = jsonDecode(loginData!);
    var data = LoginParamaterPost.fromJson(decodeData);

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const HomePage()));
  }

  @override
  void initState() {
    // TODO: implement initState
    readUserInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: BlocListener<UpdateUserBloc, UpdateUserState>(
          listener: (context, state) {
            if (state is UpdateUserLoading) {
              showDialog(
                  context: context,
                  builder: (context) => Center(
                        child: SizedBox(
                            height: 150,
                            width: 150,
                            child: Lottie.network(
                                "https://assets9.lottiefiles.com/packages/lf20_a2chheio.json")),
                      ));
              Future.delayed(const Duration(seconds: 1));
            }
            if (state is UpdateUserSuccess) {
              Navigator.pop(context);
              if (changePass == false) {
                readUserData();
              } else {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false);
              }
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      pickImageFromGallery();
                    },
                    child: Center(
                      child: (image == null)
                          ? CircleAvatar(
                              radius: 57,
                              backgroundColor: Colors.indigo,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage: NetworkImage(
                                    // state.value!.profilePict!
                                    widget.arguments!.profilePict!),
                              ),
                            )
                          : CircleAvatar(
                              radius: 57,
                              backgroundColor: Colors.indigo,
                              child: CircleAvatar(
                                radius: 55,
                                backgroundImage: FileImage(image!),
                              ),
                            ),
                    )),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Biodata ",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Nama Depan : ",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: firstNameController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[a-z]")),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Kolom Nama Tidak Boleh Kosong!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              isDense: false,
                              isCollapsed: false,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(19, 12, 18, 12),
                              hintText: "Nama Depan",
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.3),
                                  fontWeight: FontWeight.w400),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      const BorderSide(color: Colors.red))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Nama Belakang : ",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: lastNameController,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp("[a-z]")),
                          ],
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Kolom Nama Tidak Boleh Kosong!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.person),
                              isDense: false,
                              isCollapsed: false,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(19, 12, 18, 12),
                              hintText: "Nama Belakang",
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.3),
                                  fontWeight: FontWeight.w400),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      const BorderSide(color: Colors.red))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Email : ",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          readOnly: true,
                          textInputAction: TextInputAction.next,
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Kolom Email Tidak Boleh Kosong!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.mail),
                              isDense: false,
                              isCollapsed: false,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(19, 12, 18, 12),
                              hintText: "Email",
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.3),
                                  fontWeight: FontWeight.w400),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      const BorderSide(color: Colors.red))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Jenis Kelamin : ",
                          style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        DropdownButtonFormField2(
                          hint: Row(
                            children: [
                              SizedBox(
                                height: 30,
                                width: 30,
                                child: Center(
                                    child: Icon((gender == "Pria")
                                        ? Icons.male
                                        : Icons.female)),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 30,
                                child: Center(
                                  child: Text(
                                    gender,
                                    style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              )
                            ],
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            contentPadding:
                                const EdgeInsets.fromLTRB(4, 10, 18, 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide:
                                  const BorderSide(color: Colors.blueAccent),
                            ),
                          ),
                          items: jenisKelamin
                              .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Center(
                                            child: Icon((item == "Pria")
                                                ? Icons.male
                                                : Icons.female)),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        height: 30,
                                        child: Center(
                                          child: Text(
                                            item!,
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                color: Colors.black,
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ),
                                      )
                                    ],
                                  )))
                              .toList(),
                          onChanged: (value) {
                            gender = value.toString();
                          },
                          onSaved: (value) {
                            gender = value.toString();
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Tanggal Lahir : ",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          onTap: () {
                            _selectedDate(context);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Tanggal Lahir Tidak Boleh Kosong !";
                            }
                          },
                          controller: bornDateController,
                          readOnly: true,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.calendar_month,
                              ),
                              isDense: false,
                              isCollapsed: false,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 12, 18, 12),
                              hintText: "Tanggal Lahir",
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.3),
                                  fontWeight: FontWeight.w400),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent)),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide: const BorderSide(
                                      color: Colors.blueAccent)),
                              errorBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  borderSide:
                                      const BorderSide(color: Colors.red))),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Change Password ",
                                style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700)),
                            Switch(
                              activeColor: Colors.indigo,
                              value: changePass!,
                              onChanged: (value) {
                                setState(() {
                                  changePass = value;
                                });
                              },
                              activeTrackColor: Colors.lightBlueAccent,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        (changePass == true)
                            ? Form(
                                key: _formKeySecond,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Password : ",
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      textInputAction: TextInputAction.next,
                                      controller: passwordController,
                                      obscureText: true,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Kolom Password Tidak Boleh Kosong!";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(Icons.lock),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  obsecure = !obsecure;
                                                });
                                              },
                                              icon: Icon(obsecure
                                                  ? Icons.visibility
                                                  : Icons.visibility_off)),
                                          isDense: false,
                                          isCollapsed: false,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  19, 12, 18, 12),
                                          hintText: "Password",
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              fontWeight: FontWeight.w400),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.blueAccent)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.blueAccent)),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide:
                                                  const BorderSide(color: Colors.blueAccent)),
                                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Colors.red))),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text("Password Baru : ",
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      textInputAction: TextInputAction.next,
                                      controller: newPasswordController,
                                      obscureText: obsecureValidate,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Kolom Passowrd Tidak Boleh Kosong!";
                                        }
                                        if (value == passwordController.text) {
                                          return "Password didn't change !";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(Icons.lock),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  obsecureValidate =
                                                      !obsecureValidate;
                                                });
                                              },
                                              icon: Icon(obsecureValidate
                                                  ? Icons.visibility
                                                  : Icons.visibility_off)),
                                          isDense: false,
                                          isCollapsed: false,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  19, 12, 18, 12),
                                          hintText: "Password",
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              fontWeight: FontWeight.w400),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.blueAccent)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.blueAccent)),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide:
                                                  const BorderSide(color: Colors.blueAccent)),
                                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Colors.red))),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Text("Konfirmasi Password Baru : ",
                                        style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400)),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      textInputAction: TextInputAction.next,
                                      controller: newPasswordValidateController,
                                      obscureText: obsecureNewValidate,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return "Kolom Passowrd Tidak Boleh Kosong!";
                                        }
                                        if (value !=
                                            newPasswordController.text) {
                                          return "Password didn't match !";
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                          prefixIcon: const Icon(Icons.lock),
                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  obsecureNewValidate =
                                                      !obsecureNewValidate;
                                                });
                                              },
                                              icon: Icon(obsecureNewValidate
                                                  ? Icons.visibility
                                                  : Icons.visibility_off)),
                                          isDense: false,
                                          isCollapsed: false,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  19, 12, 18, 12),
                                          hintText: "Password",
                                          hintStyle: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              fontWeight: FontWeight.w400),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.blueAccent)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide: const BorderSide(
                                                  color: Colors.blueAccent)),
                                          focusedErrorBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              borderSide:
                                                  const BorderSide(color: Colors.blueAccent)),
                                          errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0), borderSide: const BorderSide(color: Colors.red))),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox()
                      ],
                    )),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 40,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.indigo),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)))),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (changePass == true) {
                          if (_formKeySecond.currentState!.validate()) {
                            context.read<UpdateUserBloc>().add(StartUpdateUser(
                                value: RegisterParameterPost(
                                    bornDate: dateTimeReq,
                                    email: emailController.text,
                                    password: passwordController.text,
                                    firstName: firstNameController.text,
                                    lastName: lastNameController.text,
                                    gender: gender,
                                    profilePict: image),
                                changePassword: changePass!,
                                newPassword: newPasswordController.text));
                          }
                        } else {
                          context.read<UpdateUserBloc>().add(StartUpdateUser(
                              value: RegisterParameterPost(
                                  bornDate: dateTimeReq,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  firstName: firstNameController.text,
                                  lastName: lastNameController.text,
                                  gender: gender,
                                  profilePict: image),
                              changePassword: changePass!,
                              newPassword: newPasswordController.text));
                        }
                      }
                    },
                    child: Text(
                      "Update Profile",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
            // }
            //   return const SizedBox(
            //     height: double.infinity,
            //     width: double.infinity,
            //     child: Center(
            //       child: SizedBox(
            //           height: 150,
            //           width: 150,
            //           child: CircularProgressIndicator()),
            //     ),
            //   );
            // },
            // ),
          ),
        ),
      ),
    );
  }
}
