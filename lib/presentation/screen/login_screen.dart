import 'package:dep_tech/data/model/user_response_model.dart';
import 'package:dep_tech/presentation/bloc/agenda/add-agenda/add_agenda_bloc.dart';
import 'package:dep_tech/presentation/bloc/agenda/list-agenda/list_agenda_bloc.dart';
import 'package:dep_tech/presentation/bloc/auth/login-bloc/login_bloc.dart';
import 'package:dep_tech/presentation/screen/homepage.dart';
import 'package:dep_tech/presentation/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool obsecure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginLoading) {
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
            if (state is LoginSuccess) {
              Navigator.pop(context);
              showDialog(
                  context: context,
                  builder: (context) => Center(
                        child: SizedBox(
                            height: 150,
                            width: 150,
                            child: Lottie.network(
                                "https://assets6.lottiefiles.com/packages/lf20_rbtawnwz.json")),
                      ));

              Future.delayed(const Duration(seconds: 1)).then((value) =>
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const HomePage()),
                      (route) => false));
            }
            if (state is LoginFailed) {
              Fluttertoast.showToast(
                  msg: state.message!,
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 14);
              Navigator.pop(context);
            }

            // TODO: implement listener
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
                        "https://assets9.lottiefiles.com/packages/lf20_1pxqjqps.json"),
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
                              return "Kolom Passowrd Tidak Boleh Kosong!";
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
                            builder: (context) => const RegisterScreen()));
                  },
                  child: RichText(
                    text: TextSpan(
                        text: "Belum memiliki akun ?",
                        style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                        children: [
                          TextSpan(
                              text: " Daftar sekarang!",
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
                        context.read<LoginBloc>().add(StartLogin(
                            value: LoginParamaterPost(
                                email: emailController.text,
                                password: passwordController.text)));
                      }
                    },
                    child: Text(
                      "Login",
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
