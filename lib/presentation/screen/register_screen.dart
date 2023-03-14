import 'dart:io';

import 'package:dep_tech/data/model/register_response_model.dart';
import 'package:dep_tech/presentation/bloc/auth/register-bloc/register_bloc.dart';
import 'package:dep_tech/presentation/screen/login_screen.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final bornDateController = TextEditingController();
  String? dateTimeReq = "";
  DateTime bornDate = DateTime.now();
  File? image = null;

  String gender = "Pria";
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordValidateController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool obsecure = true;
  bool obsecureValidate = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: BlocListener<RegisterBloc, RegisterState>(
          listener: (context, state) {
            if (state is RegisterLoading) {
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
            if (state is RegisterSuccess) {
              Fluttertoast.showToast(
                  msg: "Success Create User",
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 14);
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false);
            }
            if (state is RegisterFailed) {
              Fluttertoast.showToast(
                  msg: state.message!,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 14);
              Navigator.pop(context);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Lottie.network(
                        "https://assets8.lottiefiles.com/packages/lf20_tpa51dr0.json"),
                  ),
                ),
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
                              const SizedBox(
                                height: 30,
                                width: 30,
                                child: Center(child: Icon(Icons.male)),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 30,
                                child: Center(
                                  child: Text(
                                    jenisKelamin.first,
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
                        Text("Foto Profil : ",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(
                          height: 5,
                        ),
                        InkWell(
                          onTap: () {
                            pickImageFromGallery();
                          },
                          child: image != null
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    height: 200,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.blueAccent),
                                        borderRadius:
                                            BorderRadius.circular(17)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Image.file(
                                        image!,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      border:
                                          Border.all(color: Colors.blueAccent)),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 4, horizontal: 18),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          color: Colors.black.withOpacity(0.2),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "Image",
                                          style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              fontWeight: FontWeight.w400),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Registration ",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700)),
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
                        Text("Password : ",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: passwordController,
                          obscureText: obsecure,
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
                                  const EdgeInsets.fromLTRB(19, 12, 18, 12),
                              hintText: "Password",
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
                        Text("Ulangi Password : ",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: passwordValidateController,
                          obscureText: obsecureValidate,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Kolom Passowrd Tidak Boleh Kosong!";
                            }
                            if (value != passwordController.text) {
                              return "Passowrd didn't match";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      obsecureValidate = !obsecureValidate;
                                    });
                                  },
                                  icon: Icon(obsecureValidate
                                      ? Icons.visibility
                                      : Icons.visibility_off)),
                              isDense: false,
                              isCollapsed: false,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(19, 12, 18, 12),
                              hintText: "Password",
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
                      ],
                    )),
                const SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  },
                  child: RichText(
                    text: TextSpan(
                        text: "Sudah memiliki akun ?",
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                              text: " Yuk Mulai!",
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w400))
                        ]),
                  ),
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
                        context.read<RegisterBloc>().add(StartRegistration(
                            value: RegisterParameterPost(
                                bornDate: dateTimeReq,
                                email: emailController.text,
                                password: passwordController.text,
                                firstName: firstNameController.text,
                                lastName: lastNameController.text,
                                gender: gender,
                                profilePict: image)));
                      }
                    },
                    child: Text(
                      "Register",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
