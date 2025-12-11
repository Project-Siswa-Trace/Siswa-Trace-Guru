import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
// import 'package:nfc_manager/nfc_manager.dart'; // Uncomment jika run di Real Device
// import 'dart:async';
import 'package:intl/intl.dart';
import '../provider/scan_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lastScan = ref.watch(scanProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: NetworkImage("https://via.placeholder.com/50"), // Ganti Logo Sekolah
              radius: 16,
            ),
            const SizedBox(width: 10),
            const Text(
              "SMA Negeri 1 Jakarta",
              style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.wifi, color: Colors.green))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("ABSENSI SISWA", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Icon(Icons.wifi, color: Colors.green, size: 20),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text("SMA Negeri 1 Jakarta\n${DateFormat('EEEE, dd/MM/yyyy', 'id_ID').format(DateTime.now())}", 
                    style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                  const SizedBox(height: 10),
                  Text(
                    DateFormat('HH:mm:ss').format(DateTime.now()),
                    style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Statistik Hari Ini", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const Text("80%", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.deepOrange)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                _buildStatCard("0", "Hadir", const Color(0xFFE8F5E9), Colors.green),
                const SizedBox(width: 10),
                _buildStatCard("0", "Terlambat", const Color(0xFFFFFDE7), Colors.orange),
                const SizedBox(width: 10),
                _buildStatCard("0", "Tidak Hadir", const Color(0xFFFFEBEE), Colors.red),
              ],
            ),
            const SizedBox(height: 5),
            const Text("Progress Kehadiran\n29/31", style: TextStyle(fontSize: 12, color: Colors.grey)),

            const SizedBox(height: 20),

            const Text("Metode Scanning", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildScanButton(
                    context, 
                    title: "Barcode Scan Kartu", 
                    icon: Icons.qr_code_scanner, 
                    color: Colors.blue,
                    onTap: () => _showBarcodeScannerSheet(context, ref),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: _buildScanButton(
                    context, 
                    title: "RFID/NFC Tap Kartu", 
                    icon: Icons.nfc, 
                    color: Colors.green,
                    onTap: () => _showNFCScannerSheet(context, ref),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            const Text("HASIL SCAN TERAKHIR", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: lastScan == null 
                ? Column(
                    children: [
                      Icon(Icons.person, size: 40, color: Colors.grey[300]),
                      const SizedBox(height: 10),
                      const Text("Belum Ada Scan Hari Ini", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                      const Text("Pilih metode scan diatas untuk memulai", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  )
                : Column(
                    children: [
                      const Icon(Icons.check_circle, size: 50, color: Colors.green),
                      const SizedBox(height: 10),
                      Text(lastScan.studentName ?? "-", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                      Text("Status: ${lastScan.status} • ${lastScan.time}", style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String count, String label, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(count, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textColor)),
            Text(label, style: TextStyle(fontSize: 12, color: textColor)),
          ],
        ),
      ),
    );
  }

  // Widget Helper: Scan Button
  Widget _buildScanButton(BuildContext context, {required String title, required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  // --- LOGIC: BARCODE BOTTOM SHEET ---
  void _showBarcodeScannerSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          height: 500, // Tinggi Bottom Sheet
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 20),
              const Text("Scan Barcode Siswa", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: MobileScanner(
                    onDetect: (capture) {
                      final List<Barcode> barcodes = capture.barcodes;
                      if (barcodes.isNotEmpty) {
                        final String code = barcodes.first.rawValue ?? "Unknown";
                        ref.read(scanProvider.notifier).setScanResult("Budi Santoso ($code)", "Hadir");
                        Navigator.pop(ctx);
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Scan Berhasil: $code")));
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text("Arahkan kamera ke kartu siswa", style: TextStyle(color: Colors.grey)),
            ],
          ),
        );
      },
    );
  }

  void _showNFCScannerSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Container(
          height: 360,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.nfc, size: 80, color: Colors.green),
              const SizedBox(height: 20),
              const Text("Siap Memindai NFC", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("Tempelkan Kartu pada bagian belakang HP", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                   ref.read(scanProvider.notifier).setScanResult("Siti Aminah (NFC)", "Hadir");
                   Navigator.pop(ctx);
                }, 
                child: const Text("Simulasi Tap Kartu (Debug)"),
              )
            ],
          ),
        );
      },
    );
    
    // Logic NFC Asli (Uncomment saat build di HP Fisik)
    /*
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var id = tag.data['isodep']['identifier']; 
      ref.read(scanProvider.notifier).setScanResult("Siswa NFC Detected", "Hadir");
      NfcManager.instance.stopSession();
      Navigator.pop(context);
    });
    */
  }
}