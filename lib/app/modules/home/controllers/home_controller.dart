import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:training_ongkir/app/data/models/ongkir_model.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxString provAsal = "0".obs;
  RxString cityAsal = "0".obs;
  RxString provTujuan = "0".obs;
  RxString cityTujuan = "0".obs;
  RxBool isLoading = false.obs;

  RxString codeKurir = "".obs;
  TextEditingController beratC = TextEditingController();
  List<Ongkir> listOngkir = [];
  void cekOngkir() async {
    if (provAsal != "0" &&
        cityAsal != "0" &&
        provTujuan != "0" &&
        cityTujuan != "0" &&
        codeKurir != "" &&
        beratC.text != "") {
      try {
        isLoading.value = true;
        var response = await http.post(
            Uri.parse("https://api.rajaongkir.com/starter/cost"),
            headers: {
              "key": "c1b9ea5c7e345bd002f441d47762b29f",
              "content-type": "application/x-www-form-urlencoded"
            },
            body: {
              "origin": cityAsal.value,
              "destination": cityTujuan.value,
              "weight": beratC.text,
              "courier": codeKurir.value
            });
        isLoading.value = false;
        var ongkir =
            json.decode(response.body)["rajaongkir"]["results"][0]["costs"];
        listOngkir = Ongkir.fromJsonList(ongkir);

        Get.defaultDialog(
            title: "Daftar Ongkir",
            content: Column(
              children: listOngkir
                  .map((e) => ListTile(
                        title: Text("${e.service}"),
                        subtitle: Text("${e.cost![0].value}"),
                      ))
                  .toList(),
            ));
      } catch (e) {
        print(e);
        Get.defaultDialog(
          title: "Ongkir Tidak Tersedia",
          middleText: "Mohon periksa kembali data anda",
        );
      }
    }
  }
}
