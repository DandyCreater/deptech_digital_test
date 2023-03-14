// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:dep_tech/data/model/agenda_response_model.dart';
import 'package:dep_tech/data/model/register_response_model.dart';
import 'package:dep_tech/data/model/user_response_model.dart';
import 'package:dep_tech/domain/entity/agenda_entity.dart';
import 'package:dep_tech/presentation/bloc/agenda/list-agenda/list_agenda_bloc.dart';
import 'package:dep_tech/presentation/bloc/auth/login-bloc/login_bloc.dart';
import 'package:dep_tech/presentation/screen/agenda_form.dart';
import 'package:dep_tech/presentation/screen/edit_agenda_form.dart';
import 'package:dep_tech/presentation/screen/login_screen.dart';
import 'package:dep_tech/presentation/screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var storage = const FlutterSecureStorage();
  String? username = "";
  String? profilePic = "";
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateFormat showDate = DateFormat("dd MMMM yyyy");
  List<AgendaEntity> sortList = [];

  readData() async {
    context.read<ListAgendaBloc>().add(FetchAgendaList());
    String? storageData = await storage.read(key: "keyUserData");
    var data = UserResponseModel.fromJson(jsonDecode(storageData!));
    setState(() {
      username = "${data.firstName} ${data.lastName}";
      profilePic = data.profilePict!;
    });
  }

  @override
  void initState() {
    readData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: width * 0.5,
                    child: Text(
                      "Hi!\n$username",
                      style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w500),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      var storage = const FlutterSecureStorage();
                      String? storageData =
                          await storage.read(key: "keyUserData");
                      var data =
                          UserResponseModel.fromJson(jsonDecode(storageData!));

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                  arguments: UserResponseModel(
                                      bornDate: data.bornDate,
                                      email: data.email,
                                      firstName: data.firstName,
                                      lastName: data.lastName,
                                      gender: data.gender,
                                      profilePict: data.profilePict,
                                      id: data.id))));
                      ;
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.indigo,
                      child: CircleAvatar(
                        radius: 23,
                        backgroundImage: NetworkImage(profilePic!),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      storage.deleteAll();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                          (route) => false);
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.exit_to_app),
                        Text(
                          "Log Out",
                          style: GoogleFonts.poppins(
                              fontSize: 15, color: Colors.black),
                        )
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              BlocBuilder<ListAgendaBloc, ListAgendaState>(
                builder: (context, state) {
                  if (state is ListAgendaSuccess) {
                    var items = state.value;
                    if (items!.isEmpty) {
                      return SizedBox(
                        height: height * 0.7,
                        width: double.infinity,
                        child: Center(
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: 150,
                                  child: Lottie.network(
                                      "https://assets8.lottiefiles.com/packages/lf20_dhtOaoOnRb.json"),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Data Empty",
                                  style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    } else {
                      items.sort(((a, b) => a.date!.compareTo(b.date!)));
                      return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: items.length,
                          itemBuilder: ((context, index) {
                            var formatDate =
                                dateFormat.parse(items[index].date!);
                            var finalDate = showDate.format(formatDate);
                            return Column(
                              children: [
                                Container(
                                  height: 150,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.blueAccent,
                                            Colors.indigo,
                                          ]),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 2,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: width * 0.5,
                                          height: 120,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                items[index].title!,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white),
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              SizedBox(
                                                width: width * 0.5,
                                                child: Text(
                                                  items[index].description!,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Colors.white),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  softWrap: false,
                                                  maxLines: 4,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              finalDate,
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            SizedBox(
                                              width: width * 0.29,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    items[index].time!,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: Colors.white),
                                                  ),
                                                  InkWell(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) => EditAgendaFormScreen(
                                                                    arguments: EditAgendaArguments(
                                                                        id: items[index]
                                                                            .id,
                                                                        date: items[index]
                                                                            .date,
                                                                        description:
                                                                            items[index]
                                                                                .description,
                                                                        picture:
                                                                            items[index]
                                                                                .picture,
                                                                        remindVal:
                                                                            items[index]
                                                                                .remindVal,
                                                                        reminder:
                                                                            items[index]
                                                                                .reminder,
                                                                        time: items[index]
                                                                            .time,
                                                                        title: items[index]
                                                                            .title))));
                                                      },
                                                      child: const Icon(
                                                        Icons.edit,
                                                        color: Colors.green,
                                                      )),
                                                  InkWell(
                                                      onTap: () {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                ((context) =>
                                                                    AlertDialog(
                                                                      title:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "Hapus Agenda ini ?",
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w500),
                                                                        ),
                                                                      ),
                                                                      actions: [
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(horizontal: 20),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.spaceBetween,
                                                                            children: [
                                                                              SizedBox(
                                                                                height: 30,
                                                                                width: width * 0.3,
                                                                                child: ElevatedButton(
                                                                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                                                                                    onPressed: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text(
                                                                                      "Kembali",
                                                                                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                    )),
                                                                              ),
                                                                              SizedBox(
                                                                                height: 30,
                                                                                width: width * 0.3,
                                                                                child: ElevatedButton(
                                                                                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.indigo), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))),
                                                                                    onPressed: () {
                                                                                      context.read<ListAgendaBloc>().add(DeleteAgendaList(uId: items[index].id!));
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Text(
                                                                                      "Hapus",
                                                                                      style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white),
                                                                                    )),
                                                                              )
                                                                            ],
                                                                          ),
                                                                        )
                                                                      ],
                                                                    )));
                                                      },
                                                      child: const Icon(
                                                        Icons.delete,
                                                        color: Colors.red,
                                                      )),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 10),
                                              child: Container(
                                                height: 50,
                                                width: width * 0.24,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            items[index]
                                                                .picture!))),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            );
                          }));
                    }
                  }

                  if (state is ListAgendaLoading) {
                    return SizedBox(
                      height: height * 0.7,
                      width: double.infinity,
                      child: Center(
                        child: SizedBox(
                          height: 100,
                          width: 100,
                          child: Lottie.network(
                              "https://assets9.lottiefiles.com/packages/lf20_a2chheio.json"),
                        ),
                      ),
                    );
                  }
                  return SizedBox(
                    height: height * 0.7,
                    width: double.infinity,
                    child: Center(
                      child: SizedBox(
                        height: 200,
                        width: 200,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 150,
                              child: Lottie.network(
                                  "https://assets8.lottiefiles.com/packages/lf20_dhtOaoOnRb.json"),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Data Empty",
                              style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: Colors.transparent,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AgendaFormScreen()));
        },
        child: Lottie.network(
            "https://assets9.lottiefiles.com/packages/lf20_orCYAZ1Wva.json"),
      ),
    );
  }
}
