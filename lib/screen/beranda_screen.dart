import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:whazlansaja/dosen.dart';
import 'package:whazlansaja/screen/pesan_screen.dart';

class BerandaScreen extends StatelessWidget {
  const BerandaScreen({super.key});

  Future<List<Dosen>> loadDosenFromJson() async {
    try {
      final jsonString = await rootBundle.loadString('assets/json_data_chat_dosen/dosen_chat.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.map((e) => Dosen.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error loading dosen data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: const Text(
          'UAS SITI NOOR SHALIHA 4SIB1',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SearchAnchor.bar(
              barElevation: const WidgetStatePropertyAll(2),
              barHintText: 'Cari dosen dan mulai chat',
              suggestionsBuilder: (context, controller) {
                return <Widget>[
                  const Center(child: Text('Belum ada pencarian')),
                ];
              },
            ),
          ),
        ),
      ),
      body: FutureBuilder<List<Dosen>>(
        future: loadDosenFromJson(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data dosen.'));
          }

          final dosens = snapshot.data!;
          return ListView.builder(
            itemCount: dosens.length,
            itemBuilder: (context, index) {
              final dosen = dosens[index];

              String waktu = index == 0 ? '2 menit lalu' : 'Kemaren';
              int notifCount = index == 0 ? 2 : 0;

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: AssetImage(dosen.img),
                ),
                title: Text(
                  dosen.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  dosen.details.isNotEmpty
                      ? dosen.details.last.message
                      : 'Belum ada pesan',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      waktu,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    if (notifCount > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          notifCount.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                  ],
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PesanScreen(dosen: dosen),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: [
          NavigationDestination(icon: Icon(Icons.chat), label: 'Chat'),
          NavigationDestination(icon: Icon(Icons.sync), label: 'Pembaruan'),
          NavigationDestination(icon: Icon(Icons.groups), label: 'Komunitas'),
          NavigationDestination(icon: Icon(Icons.call), label: 'Panggilan'),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        onPressed: () {},
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}
