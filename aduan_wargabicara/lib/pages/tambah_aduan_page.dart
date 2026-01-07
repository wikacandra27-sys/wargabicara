import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

late List<CameraDescription> cameras;

class TambahAduanPage extends StatefulWidget {
  const TambahAduanPage({super.key});

  @override
  State<TambahAduanPage> createState() => _TambahAduanPageState();
}

class _TambahAduanPageState extends State<TambahAduanPage> {
  final namaController = TextEditingController();
  final deskripsiController = TextEditingController();
  final tanggalController = TextEditingController();
  final lokasiController = TextEditingController();

  String kategori = "Infrastruktur";
  XFile? foto;
  CameraController? cameraController;

  @override
  void initState() {
    super.initState();
    availableCameras().then((value) {
      cameras = value;
      cameraController =
          CameraController(cameras[0], ResolutionPreset.medium);
      cameraController!.initialize().then((_) {
        if (mounted) setState(() {});
      });
    });
  }

  Future ambilFoto() async {
    if (!cameraController!.value.isInitialized) return;
    foto = await cameraController!.takePicture();
    setState(() {});
  }

  Future ambilLokasi() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    Position pos = await Geolocator.getCurrentPosition();
    lokasiController.text = "${pos.latitude}, ${pos.longitude}";
  }

  Future pilihTanggal() async {
    DateTime? pick = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (pick != null) {
      tanggalController.text =
          DateFormat('dd-MM-yyyy').format(pick);
    }
  }

  void submit() {
    if (namaController.text.isEmpty ||
        deskripsiController.text.isEmpty ||
        tanggalController.text.isEmpty ||
        lokasiController.text.isEmpty ||
        foto == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data belum lengkap")),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Berhasil"),
        content: const Text("Aduan berhasil dikirim"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null ||
        !cameraController!.value.isInitialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Aduan"),
        backgroundColor: const Color.fromARGB(255, 13, 71, 161),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(
                  labelText: "Judul Aduan",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField(
              value: kategori,
              items: const [
                DropdownMenuItem(
                    value: "Infrastruktur",
                    child: Text("Infrastruktur")),
                DropdownMenuItem(
                    value: "Pendidikan",
                    child: Text("Pendidikan")),
                DropdownMenuItem(
                    value: "Kesehatan",
                    child: Text("Kesehatan")),
                DropdownMenuItem(
                    value: "Lingkungan Hidup",
                    child: Text("Lingkungan Hidup")),
                DropdownMenuItem(
                    value: "Transportasi",
                    child: Text("Transportasi")),
              ],
              onChanged: (v) => kategori = v!,
              decoration: const InputDecoration(
                  labelText: "Kategori",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: deskripsiController,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: tanggalController,
              readOnly: true,
              onTap: pilihTanggal,
              decoration: const InputDecoration(
                  labelText: "Tanggal",
                  suffixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            Container(
              height: 200,
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.grey)),
              child: foto == null
                  ? CameraPreview(cameraController!)
                  : Image.file(File(foto!.path), fit: BoxFit.cover),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
                onPressed: ambilFoto,
                child: const Text("Ambil Foto")),
            const SizedBox(height: 12),
            TextField(
              controller: lokasiController,
              readOnly: true,
              decoration: const InputDecoration(
                  labelText: "Titik Lokasi",
                  border: OutlineInputBorder()),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
                onPressed: ambilLokasi,
                child: const Text("Ambil Lokasi")),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor:const Color.fromARGB(255, 13, 71, 161)),
                onPressed: submit,
                child: const Text("Kirim Aduan"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
