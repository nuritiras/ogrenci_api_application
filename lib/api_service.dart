import 'dart:convert';
import 'package:http/http.dart' as http;
import 'ogrenci_model.dart';

class ApiService {
  // ÖNEMLİ: Android Emülatör kullanıyorsanız 127.0.0.1 yerine 10.0.2.2 kullanın.
  // Gerçek cihaz için bilgisayarınızın yerel IP'sini yazın (örn: 192.168.1.x)
  static const String baseUrl = "http://127.0.0.1:8000/api/ogrenciler/";

  // Listeleme (GET)
  Future<List<Ogrenci>> fetchOgrenciler() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        // Türkçe karakterler için utf8.decode kullanımı kritiktir
        List jsonResponse = json.decode(utf8.decode(response.bodyBytes));
        return jsonResponse.map((data) => Ogrenci.fromJson(data)).toList();
      } else {
        throw Exception('Veriler alınamadı: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Bağlantı hatası: $e');
    }
  }

  // Ekleme (POST)
  Future<bool> ogrenciEkle(Ogrenci ogrenci) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(ogrenci.toJson()),
      );
      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }
}