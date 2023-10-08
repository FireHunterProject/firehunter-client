import 'package:dio/dio.dart';
import 'package:csv/csv.dart';
import 'package:fast_csv/csv_converter.dart';
import 'package:fire_hunter/fire_data.dart';
import 'package:flutter/services.dart' show rootBundle;

class FIRMSApi {
  static String HOST = "https://firms.modaps.eosdis.nasa.gov";
  static String API_KEY = "fac815e3a23e1867485fe8ba5f6677e4";
  static String API_PATH = "/api/country/csv/";
  static String API_SOURCE = "MODIS_NRT";//"VIIRS_SNPP_NRT";

  static String getUrl() {
    return "$HOST$API_PATH$API_KEY/$API_SOURCE/BRA/1/2023-10-07";
  }

  static Future<String> getData() async {
    final dio = Dio();
    final response = await dio.get(getUrl());
    // print(response.data);
    return response.data;
  }

   static Future<List<FireData>> parseCsv() async {
    final String csvString = await getData();
    final result = CsvConverter().convert(csvString);
    // print(result.join('\n'));
    final List<FireData> fireDataList = [];
    for (final row in result) {
       final FireData fireData = FireData(
          countryId: row[0].toString(),
          latitude: double.tryParse(row[1].toString()) ?? 0.0,
          longitude: double.tryParse(row[2].toString()) ?? 0.0,
          brightTi4: double.tryParse(row[3].toString()) ?? 0.0,
          scan: double.tryParse(row[4].toString()) ?? 0.0,
          track: double.tryParse(row[5].toString()) ?? 0.0,
          acqDate: row[6].toString(),
          acqTime: int.tryParse(row[7].toString()) ?? 0,
          satellite: row[8].toString(),
          instrument: row[9].toString(),
          confidence: row[10].toString(),
          version: row[11].toString(),
          brightTi5: double.tryParse(row[12].toString()) ?? 0.0,
          frp: double.tryParse(row[13].toString()) ?? 0.0,
          dayNight: row[14].toString(),
        );

        fireDataList.add(fireData);
    }
    return fireDataList;
}

  static Future<List<FireData>> loadFireData() async {
    final String csvString = await getData();
    // print(csvString);

    final List<List<dynamic>> csvTable =
        const CsvToListConverter().convert(csvString);
    final List<FireData> fireDataList = [];

    // for (int i = 1; i < csvTable.length; i++) {
    //   var row = csvTable[i];
    //   print(row[0].toString());
     
        // final FireData fireData = FireData(
        //   countryId: row[0].toString(),
        //   latitude: double.tryParse(row[1].toString()) ?? 0.0,
        //   longitude: double.tryParse(row[2].toString()) ?? 0.0,
        //   brightTi4: double.tryParse(row[3].toString()) ?? 0.0,
        //   scan: double.tryParse(row[4].toString()) ?? 0.0,
        //   track: double.tryParse(row[5].toString()) ?? 0.0,
        //   acqDate: row[6].toString(),
        //   acqTime: int.tryParse(row[7].toString()) ?? 0,
        //   satellite: row[8].toString(),
        //   instrument: row[9].toString(),
        //   confidence: row[10].toString(),
        //   version: row[11].toString(),
        //   brightTi5: double.tryParse(row[12].toString()) ?? 0.0,
        //   frp: double.tryParse(row[13].toString()) ?? 0.0,
        //   dayNight: row[14].toString(),
        // );

        // fireDataList.add(fireData);
      
    // }

    return fireDataList;
  }
}
