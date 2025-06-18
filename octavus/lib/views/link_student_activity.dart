class VincularAtividadeScreen extends StatelessWidget {
  const VincularAtividadeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Vincular atividade", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Vincule um exercício para que seu aluno pratique durante a semana"),
            const SizedBox(height: 16),
            _buildInput(icon: Icons.music_note, text: "Guitarra"),
            const SizedBox(height: 12),
            _buildInput(icon: Icons.assignment, text: "Atividade 1 – Ciclo das quintas"),
            const SizedBox(height: 12),
            _buildInput(icon: Icons.notes, text: "Praticar todos os tons com o auxílio do metrônomo a 120 bpm"),
            const SizedBox(height: 12),
            _buildInput(icon: Icons.calendar_today, text: "17/04/2023"),
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFE49C),
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                
              },
              child: const Text("Vincular >", style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput({required IconData icon, required String text}) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFEFF4F8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(children: [
          Icon(icon, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(child: Text(text)),
        ]),
      );

  Widget _buildBottomNavBar() => BottomNavigationBar(
        currentIndex: 1,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: ''),
        ],
      );
}
