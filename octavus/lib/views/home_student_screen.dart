import 'package:flutter/material.dart';

class HomeAlunoScreen extends StatelessWidget {
  const HomeAlunoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _roundedButton("Minhas atividades"),
            const SizedBox(height: 12),
            _progressCard(),
            const SizedBox(height: 12),
            _unlockGoalsButton(),
            const SizedBox(height: 24),
            const Text("Atividades recentes", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _recentActivity("Tríades", "Pontuação: 8.0"),
            _recentActivity("Tétrades", "Pontuação: 5.0"),
          ],
        ),
      ),
    );
  }

  Widget _roundedButton(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFE0EFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: TextStyle(fontSize: 16)),
    );
  }

  Widget _progressCard() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Color(0xFF203C60),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 16,
            left: 16,
            child: Text("Ver relatórios de progresso",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEFE08D)),
              child: const Text("Ver mais", style: TextStyle(color: Colors.black)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _unlockGoalsButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFF203C60),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Desbloquear metas", style: TextStyle(color: Colors.white)),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFEFE08D)),
            child: const Text("Ir", style: TextStyle(color: Colors.black)),
          )
        ],
      ),
    );
  }

  Widget _recentActivity(String title, String score) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Text(score),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
