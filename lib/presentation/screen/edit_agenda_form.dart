import 'dart:io';

import 'package:dep_tech/data/model/agenda_response_model.dart';
import 'package:dep_tech/presentation/bloc/agenda/edit-agenda/edit_agenda_bloc.dart';
import 'package:dep_tech/presentation/screen/homepage.dart';
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

class EditAgendaFormScreen extends StatefulWidget {
  final EditAgendaArguments arguments;
  const EditAgendaFormScreen({super.key, required this.arguments});

  @override
  State<EditAgendaFormScreen> createState() => _EditAgendaFormScreenState();
}

class _EditAgendaFormScreenState extends State<EditAgendaFormScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  String dateTimeReq = "";
  DateTime now = DateTime.now();
  TimeOfDay timeOfDay = TimeOfDay.now();
  bool reminder = false;
  String? reminderValue = "1 hari sebelumnya";
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
  DateFormat formatRequestDate = DateFormat('yyyy-MM-dd');
  DateFormat showDate = DateFormat("dd MMMM yyyy");

  File? fileData = null;
  final _formKey = GlobalKey<FormState>();

  pickImageFromGallery() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this.fileData = imageTemporary;
      });
    } on PlatformException catch (e) {
      debugPrint("Failed to Pick Image : $e");
    }
  }

  Future<Null> _selectedDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: DateTime(1901, 1),
        lastDate: DateTime(2100));
    if (picked != null && picked != now) {
      final formatDate = DateFormat('dd MMMM yyyy');
      final formatRequestDate = DateFormat('yyyy-MM-dd');

      setState(() {
        dateController.text = formatDate.format(picked);
        dateTimeReq = formatRequestDate.format(picked);
      });
    }
  }

  Future displayTimePicker(BuildContext context) async {
    var time = await showTimePicker(context: context, initialTime: timeOfDay);

    if (time != null) {
      setState(() {
        timeController.text = "${time.hour}:${time.minute}";
      });
    }
  }

  List reminderList = [
    "1 hari sebelumnya",
    "3 jam sebelumnya",
    "1 jam sebelumnya",
  ];

  setFirstData() async {
    var date = dateFormat.parse(widget.arguments.date.toString());
    titleController.text = widget.arguments.title!;
    descriptionController.text = widget.arguments.description!;
    timeController.text = widget.arguments.time!;
    dateController.text = showDate.format(date);
    dateTimeReq = formatRequestDate.format(date);
    reminder = widget.arguments.reminder!;
    reminderValue = widget.arguments.remindVal!;
    setState(() {});
  }

  @override
  void initState() {
    setFirstData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: BlocListener<EditAgendaBloc, EditAgendaState>(
          listener: (context, state) {
            if (state is EditAgendaLoading) {
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
            if (state is EditAgendaSuccess) {
              Navigator.pop(context);
              Fluttertoast.showToast(
                  msg: "Edit Agenda Sukses!",
                  gravity: ToastGravity.CENTER,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  fontSize: 14);

              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const HomePage()));
            }
            // TODO: implement listener
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 24),
            child: Column(
              children: [
                Center(
                  child: SizedBox(
                    height: 150,
                    width: 150,
                    child: Lottie.network(
                        "https://assets7.lottiefiles.com/private_files/lf30_tfozcvfo.json"),
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
                        Text("Edit Agenda ",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(
                          height: 20,
                        ),
                        Text("Judul Agenda : ",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: titleController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Kolom Judul Tidak Boleh Kosong!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.local_activity),
                              isDense: false,
                              isCollapsed: false,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(19, 12, 18, 12),
                              hintText: "Work Out Mantap",
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
                        Text("Deskripsi Agenda : ",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          maxLines: 5,
                          textInputAction: TextInputAction.next,
                          controller: descriptionController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Kolom Deskripsi Tidak Boleh Kosong!";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              isDense: false,
                              isCollapsed: false,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(19, 12, 18, 12),
                              hintText:
                                  "Ceritakan sedetail mungkin apa yang akan di lakukan pada agenda ini",
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
                        Text("Tanggal Agenda : ",
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
                              return "Tanggal Agenda Tidak Boleh Kosong !";
                            }
                          },
                          controller: dateController,
                          readOnly: true,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.calendar_month,
                              ),
                              isDense: false,
                              isCollapsed: false,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 12, 18, 12),
                              hintText: "Tanggal Agenda",
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
                        Text("Waktu Agenda : ",
                            style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400)),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          onTap: () {
                            displayTimePicker(context);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Waktu Agenda Tidak Boleh Kosong !";
                            }
                          },
                          controller: timeController,
                          readOnly: true,
                          decoration: InputDecoration(
                              prefixIcon: const Icon(
                                Icons.lock_clock,
                              ),
                              isDense: false,
                              isCollapsed: false,
                              contentPadding:
                                  const EdgeInsets.fromLTRB(15, 12, 18, 12),
                              hintText: "Tanggal Agenda",
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
                        Text("Lampiran : ",
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
                            child: fileData != null
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
                                          fileData!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )
                                : Padding(
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
                                        child: Image.network(
                                          widget.arguments.picture!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  )),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Aktifkan Reminder ",
                        style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.w700)),
                    Switch(
                      activeColor: Colors.indigo,
                      value: reminder,
                      onChanged: (value) {
                        setState(() {
                          reminder = value;
                        });
                      },
                      activeTrackColor: Colors.lightBlueAccent,
                    ),
                  ],
                ),
                (reminder == true)
                    ? Form(
                        child: DropdownButtonFormField2(
                          hint: Row(
                            children: [
                              const SizedBox(
                                height: 30,
                                width: 30,
                                child: Center(child: Icon(Icons.timelapse)),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              SizedBox(
                                height: 30,
                                child: Center(
                                  child: Text(
                                    reminderValue!,
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
                          items: reminderList
                              .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: Center(
                                            child: Icon(Icons.timelapse)),
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
                            reminderValue = value.toString();
                          },
                          onSaved: (value) {
                            reminderValue = value.toString();
                          },
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 40,
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.indigo),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      onPressed: () {
                        context.read<EditAgendaBloc>().add(StartEditAgenda(
                            agenda: AgendaParameterPost(
                                date: dateTimeReq,
                                description: descriptionController.text,
                                remindVal: reminderValue,
                                reminder: reminder,
                                time: timeController.text,
                                title: titleController.text,
                                imageUrl: widget.arguments.picture,
                                image: fileData),
                            uId: widget.arguments.id));
                      },
                      child: Text(
                        "Update Agenda",
                        style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w500),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
