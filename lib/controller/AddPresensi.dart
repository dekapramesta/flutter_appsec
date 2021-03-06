import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:aplikasi_magang/nav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class AddPresensiController extends GetxController {
  final formKey = GlobalKey<FormState>();
  
  final selected = "".obs;
  File uploadimage;
  File file;
  var data_items = ['Masuk','Pulang'];
  var onShow = true.obs;

    @override
  void onInit() {
    if (selected.isEmpty){
      selected.value = data_items[0];
    }
    super.onInit();
  }

  void setSelected(String value) {
    selected.value = value;
    inspect(selected);
  }

  Future<void> chooseImage() async {
    var choosedimage = await ImagePicker.pickImage(source: ImageSource.camera);
    uploadimage = File(choosedimage != null ? choosedimage.path : "");
    file = File(uploadimage.path);
    inspect(file);
  }
//untuk menampilkan tanggal/kalendernya

 

  
  Future<void> pressSubmit(context) async {
    inspect(file);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
    inspect(localStorage.getString('token'));
    Get.focusScope?.unfocus();
    if(file.path == ""){
       var snackBar = new SnackBar(
        content: Text("Foto Kosong"),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
 if(selected.value == "Masuk"){
         var request = http.MultipartRequest("POST",
        Uri.parse('https://jurnalmagang.aeritechnology.com/Api/Presensi'));
    request.fields['id_magang'] = localStorage.getString('id_magang');
    request.fields['token'] = localStorage.getString('token');
  

    request.files.add(http.MultipartFile.fromBytes(
        'image', File.fromUri(file.uri).readAsBytesSync(),
        filename: file.path));

    // http.StreamedResponse response = await request.send();
    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    inspect(responsed.body);

    inspect(response);
    if (response.statusCode == 200) {
      var snackBar = const SnackBar(
        content: Text('Presensi Masuk Berhasil Dikirm'),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Nav()),
      );
    } else {
      var snackBar = new SnackBar(
        content: Text(jsonDecode(responsed.body)),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    }else if(selected.value == "Pulang"){
         var request = http.MultipartRequest("POST",
        Uri.parse('https://jurnalmagang.aeritechnology.com/Api/Presensi/Pulang'));
    request.fields['id_magang'] = localStorage.getString('id_magang');
    request.fields['token'] = localStorage.getString('token');
  

    request.files.add(http.MultipartFile.fromBytes(
        'image', File.fromUri(file.uri).readAsBytesSync(),
        filename: file.path));

    // http.StreamedResponse response = await request.send();
    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    inspect(responsed.body);

    inspect(response);
    if (response.statusCode == 200) {
      var snackBar = const SnackBar(
        content: Text('Presensi Pulang Berhasil Dikirm'),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Nav()),
      );
    } else {
      
      var snackBar = new SnackBar(
        content: Text(jsonDecode(responsed.body)),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    }
    }
   
  
 
  }
}
