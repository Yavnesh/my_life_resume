import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'authentication/auth_service.dart';
import 'authentication/database.dart';
import 'homeScreen.dart';

class AddEventScreen extends StatefulWidget {
  final String? email;
  const AddEventScreen({Key? key, this.email}) : super(key: key);

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  String uploadedPath = "";
  late XFile _image;
  ImagePicker imagePicker = ImagePicker();
  bool _isLoading = false;
  File? _imageFile;
  final TextEditingController _eventnameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _doeController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser!.uid;


  selectImage() async {
    await showModalBottomSheet(
        context: context,
        builder: (context) => BottomSheet(
          builder: (context) =>
              Column(mainAxisSize: MainAxisSize.min, children: [
                ListTile(
                    leading: Icon(Icons.camera),
                    title: Text("Camera"),
                    onTap: () {
                      Navigator.of(context).pop();
                      imagePickerMethod(ImageSource.camera);
                    }),
                ListTile(
                    leading: Icon(Icons.filter),
                    title: Text("Gallery"),
                    onTap: () {
                      Navigator.of(context).pop();
                      imagePickerMethod(ImageSource.gallery);
                    })
              ]),
          onClosing: () {},
        ));
  }

  imagePickerMethod(ImageSource source) async {
    var pic = await imagePicker.pickImage(source: source);
    if (pic != null) {
      setState(() {
        _image = XFile(pic.path);
      });
    }
    uploadImage(); // image upload function
  }

  void uploadImage() {
    String imageFileName = DateTime.now().millisecondsSinceEpoch.toString();
    final Reference storageReference =
    FirebaseStorage.instance.ref().child('Images').child(imageFileName);
    final UploadTask uploadTask = storageReference.putFile(File(_image.path));
    uploadTask.snapshotEvents.listen((event) {
      setState(() {
        _isLoading = true;
      });
    });
    uploadTask.then((TaskSnapshot taskSnapshot) async {
      uploadedPath = await uploadTask.snapshot.ref.getDownloadURL();
      print(uploadedPath);

      setState(() {
        _isLoading = false;
      });
    }).catchError((error) {});
  }

  void saveEvent() {
    EventDatabase.addEvent(
      userId: userId,
      name: _eventnameController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      category: _categoryController.text,
      doe: _doeController.text,
      event_image: uploadedPath,
      email: widget.email.toString(),
    ).then((value) => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> HomeScreen())));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final authService = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Event",
            style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFFff5722),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xfffcbca9),
                  Color(0xFFff5722)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    _imageFile != null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ClipRRect(
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                          child: Container(
                            width: MediaQuery.of(context).size.width - 20,
                            child: Image.file(
                              _imageFile!,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                      ],
                    )
                        : GestureDetector(
                      onTap: () {
                        selectImage();
                      },
                      child: Card(
                        elevation: 2,
                        child: Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xFFffffff),
                                  Color(0xffffffff),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              )),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * .3,
                          child: _isLoading == false
                              ? Container(
                            child: uploadedPath == ""
                                ? Column(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  color: Colors.black,
                                  size: 100,
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5),
                                  child: Text(
                                    "Upload Image",
                                    style:
                                    TextStyle(fontSize: 22),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5),
                                  child: Text(
                                      "click here for upload image"),
                                )
                              ],
                            )
                                : Image(
                                image:
                                NetworkImage(uploadedPath)),
                          )
                              : CircularProgressIndicator(
                            color: Color(0xFFff5722),
                          ),
                          // child: Image.asset(
                          //   'assets/images/upload.png',
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextFormField(
                  controller: _eventnameController,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(16.0)),
                      prefixIcon: const Icon(
                        Icons.person,
                        color: Colors.white,
                      ),
                      hintText: "Enter event name",
                      hintStyle:
                      TextStyle(fontSize: 18.0, color: Colors.white),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _descriptionController,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(16.0)),
                      prefixIcon: const Icon(
                        Icons.assignment_outlined,
                        color: Colors.white,
                      ),
                      hintText: "Enter description",
                      hintStyle:
                      TextStyle(fontSize: 18.0, color: Colors.white),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _locationController,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(16.0)),
                      prefixIcon: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      hintText: "Enter location",
                      hintStyle:
                      TextStyle(fontSize: 18.0, color: Colors.white),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _doeController,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(16.0)),
                      prefixIcon: const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      hintText: "Enter date of event",
                      hintStyle:
                      TextStyle(fontSize: 18.0, color: Colors.white),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40),
                child: TextField(
                  controller: _categoryController,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(16.0)),
                      prefixIcon: const Icon(
                        Icons.category,
                        color: Colors.white,
                      ),
                      hintText: "Enter category",
                      hintStyle:
                      TextStyle(fontSize: 18.0, color: Colors.white),
                      labelStyle: TextStyle(
                        color: Colors.white,
                      )),
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: RaisedButton(
                  onPressed: () async {
                    saveEvent();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80.0)),
                  textColor: Colors.white,
                  padding: const EdgeInsets.all(0),
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: MediaQuery.of(context).size.width*.5,
                    decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        gradient: new LinearGradient(
                            colors: [Colors.black, Colors.black87])),
                    padding: const EdgeInsets.all(0),
                    child: Text(
                      "Save",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
