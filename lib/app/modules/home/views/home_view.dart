import 'package:dio/dio.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_ongkir/app/data/models/city_model.dart';
import 'package:training_ongkir/app/data/models/province_model.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ongkos Kirim'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          DropdownSearch<Province>(
            showSearchBox: true,
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item.province}"),
            ),
            onChanged: (value) =>
                controller.provAsal.value = value?.provinceId ?? "0",
            onFind: (text) async {
              var response = await Dio().get(
                  "https://api.rajaongkir.com/starter/province",
                  queryParameters: {"key": "c1b9ea5c7e345bd002f441d47762b29f"});

              return Province.fromJsonList(
                  response.data["rajaongkir"]["results"]);
            },
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Select a province',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<City>(
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item.cityName}"),
            ),
            dropdownBuilder: (context, selectedItem) => ListTile(
              title: Text(selectedItem?.cityName ?? ""),
            ),
            onFind: (text) async {
              var response = await Dio().get(
                  'https://api.rajaongkir.com/starter/city?province=${controller.provAsal}',
                  queryParameters: {"key": "c1b9ea5c7e345bd002f441d47762b29f"});
              return City.fromJsonList(response.data["rajaongkir"]["results"]);
            },
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Select a city',
            ),
            onChanged: (value) =>
                controller.cityAsal.value = value?.cityId ?? "0",
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<Province>(
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item.province}"),
            ),
            dropdownBuilder: (context, selectedItem) => ListTile(
              title: Text(selectedItem?.province ?? ""),
            ),
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Pilih Provinsi Tujuan',
            ),
            onFind: (text) async {
              var response = await Dio().get(
                  "https://api.rajaongkir.com/starter/province",
                  queryParameters: {"key": "c1b9ea5c7e345bd002f441d47762b29f"});

              return Province.fromJsonList(
                  response.data["rajaongkir"]["results"]);
            },
            onChanged: (value) =>
                controller.provTujuan.value = value?.provinceId ?? "0",
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<City>(
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item.cityName}"),
            ),
            dropdownBuilder: (context, selectedItem) => ListTile(
              title: Text(selectedItem?.cityName ?? ""),
            ),
            onFind: (text) async {
              var response = await Dio().get(
                  'https://api.rajaongkir.com/starter/city?province=${controller.provTujuan}',
                  queryParameters: {"key": "c1b9ea5c7e345bd002f441d47762b29f"});
              return City.fromJsonList(response.data["rajaongkir"]["results"]);
            },
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Select a city',
            ),
            onChanged: (value) =>
                controller.cityTujuan.value = value?.cityId ?? "0",
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.beratC,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Berat (gram)',
            ),
          ),
          SizedBox(
            height: 20,
          ),
          DropdownSearch<Map<String, dynamic>>(
            items: [
              {
                "code": "jne",
                "Name": "JNE",
              },
              {
                "code": "pos Indonesia",
                "Name": "Pos Indonesia",
              },
              {
                "code": "tiki",
                "Name": "TIKI",
              }
            ],
            popupItemBuilder: (context, item, isSelected) => ListTile(
              title: Text("${item['Name']}"),
            ),
            dropdownBuilder: (context, selectedItem) => ListTile(
              title: Text(selectedItem?['Name'] ?? ""),
            ),
            onChanged: (value) => controller.codeKurir.value = value!['code'],
          ),
          SizedBox(
            height: 20,
          ),
          Obx(() => ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.cekOngkir();
                  }
                },
                child: Text(
                    controller.isLoading.isFalse ? "Cek Ongkir" : "Loading.."),
              )),
        ],
      ),
    );
  }
}
