import 'package:flutter/material.dart';

class RiwayatPage extends StatelessWidget {
  const RiwayatPage({super.key});

  Widget riwayatCard({
    required String judul,
    required String kategori,
    required String status,
  }) {
    Color statusColor;
    IconData statusIcon;

    switch (status) {
      case "Selesai":
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case "Diproses":
        statusColor = Colors.orange;
        statusIcon = Icons.timelapse;
        break;
      default:
        statusColor = Colors.blueGrey;
        statusIcon = Icons.info;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: statusColor.withOpacity(0.15),
              child: Icon(statusIcon, color: statusColor),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    judul,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    kategori,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Chip(
              label: Text(
                status,
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: statusColor,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      appBar: AppBar(
        title: const Text("Riwayat Aduan"),
        backgroundColor: const Color.fromARGB(255, 13, 71, 161),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Daftar Aduan Anda",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                children: [
                  riwayatCard(
                    judul: "Jalan Rusak",
                    kategori: "Infrastruktur",
                    status: "Diproses",
                  ),
                  riwayatCard(
                    judul: "Lampu Mati",
                    kategori: "Lingkungan",
                    status: "Selesai",
                  ),
                  riwayatCard(
                    judul: "Halte Rusak",
                    kategori: "Transportasi",
                    status: "Masuk",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
