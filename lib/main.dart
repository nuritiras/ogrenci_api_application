import 'package:flutter/material.dart';
import 'api_service.dart';
import 'ogrenci_model.dart';

void main() {
  runApp(const OkulApp());
}

class OkulApp extends StatelessWidget {
  const OkulApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Okul Yönetim Sistemi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo, useMaterial3: true),
      home: const OgrenciListeEkrani(),
    );
  }
}

class OgrenciListeEkrani extends StatefulWidget {
  const OgrenciListeEkrani({super.key});

  @override
  State<OgrenciListeEkrani> createState() => _OgrenciListeEkraniState();
}

class _OgrenciListeEkraniState extends State<OgrenciListeEkrani> {
  final ApiService apiService = ApiService();
  late Future<List<Ogrenci>> ogrenciListesi;

  @override
  void initState() {
    super.initState();
    _listeyiYenile();
  }

  void _listeyiYenile() {
    setState(() {
      ogrenciListesi = apiService.fetchOgrenciler();
    });
  }

  // Yeni Öğrenci Ekleme Dialog Penceresi
  void _ogrenciEkleDialog() {
    final adController = TextEditingController();
    final soyadController = TextEditingController();
    final numaraController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Yeni Öğrenci Ekle"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: adController, decoration: const InputDecoration(labelText: "Ad")),
            TextField(controller: soyadController, decoration: const InputDecoration(labelText: "Soyad")),
            TextField(
              controller: numaraController, 
              decoration: const InputDecoration(labelText: "Okul No"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("İptal")),
          ElevatedButton(
            onPressed: () async {
              if (adController.text.isNotEmpty && numaraController.text.isNotEmpty) {
                final yeni = Ogrenci(
                  ad: adController.text,
                  soyad: soyadController.text,
                  numara: int.parse(numaraController.text),
                );
                
                bool basarili = await apiService.ogrenciEkle(yeni);
                if (mounted) {
                  Navigator.pop(context);
                  if (basarili) {
                    _listeyiYenile();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Öğrenci başarıyla eklendi!")),
                    );
                  }
                }
              }
            },
            child: const Text("Kaydet"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Öğrenci Yönetimi"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _listeyiYenile),
        ],
      ),
      body: FutureBuilder<List<Ogrenci>>(
        future: ogrenciListesi,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("Henüz kayıtlı öğrenci yok."));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final ogrenci = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  leading: CircleAvatar(child: Text(ogrenci.ad[0].toUpperCase())),
                  title: Text("${ogrenci.ad} ${ogrenci.soyad}"),
                  subtitle: Text("Numara: ${ogrenci.numara}"),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ogrenciEkleDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}