import 'package:flutter/material.dart';
import '../../services/professor/professor_service.dart';
import '../../services/Auth/user_session_service.dart';
import '../../models/pending_review_model.dart';
import '../../core/app_routes.dart';

class HomeProfessorScreen extends StatefulWidget {
  final ProfessorService professorService;
  final void Function(int)? onNavigate;
  final Future<void> Function({
    required String studentId,
    required String activityId,
  })? onEvaluateActivity;

  const HomeProfessorScreen({
    super.key,
    required this.professorService,
    this.onNavigate,
    this.onEvaluateActivity,
  });

  @override
  State<HomeProfessorScreen> createState() => _HomeProfessorScreenState();
}

class _HomeProfessorScreenState extends State<HomeProfessorScreen> {
  late Future<List<PendingReview>> _pendingReviewsFuture = Future.value([]);

  @override
  void initState() {
    super.initState();
    _loadPendingReviews();
  }

  @override
void didChangeDependencies() {
  super.didChangeDependencies();

  final route = ModalRoute.of(context);
  if (route != null) {
    route.addScopedWillPopCallback(() async {
      _loadPendingReviews();
      return true;
    });

    if (route.isCurrent) {
      _loadPendingReviews();
    }
  }
}

  Future<List<PendingReview>> _loadPendingReviews() async {
    final id = await UserSessionService.getUserId();
    if (id == null) {
      setState(() {
        _pendingReviewsFuture = Future.error('Usuário não autenticado.');
      });
      return Future.error('Usuário não autenticado.');
    }

    final future = widget.professorService.getPendingReviews(id);
    setState(() {
      _pendingReviewsFuture = future;
    });

    return future;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildIconCardButton(
                context,
                text: 'Criar atividade',
                icon: Icons.add,
                routeName: AppRoutes.criarAtividade,
              ),
              _buildIconCardButton(
                context,
                text: 'Atribuir atividade',
                icon: Icons.assignment,
                onTap: () => widget.onNavigate?.call(11),
              ),
              _buildIconCardButton(
                context,
                text: 'Gerenciar alunos',
                icon: Icons.group,
                onTap: () => widget.onNavigate?.call(4),
              ),
              const SizedBox(height: 16),
              _buildCard(
                title: 'Ver relatórios de progresso',
                onPressed: () {
                  widget.onNavigate?.call(4);
                },
                backgroundColor: const Color(0xFFDBE6F6),
                imageAsset: 'assets/images/report.png',
              ),
              const SizedBox(height: 12),
              _buildMetaCard(
                context,
                title: 'Desbloquear metas',
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Avaliações pendentes',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/avaliacoes-pendentes');
                    },
                    child: const Text('Ver mais'),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              FutureBuilder<List<PendingReview>>(
                future: _pendingReviewsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Erro: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Não há avaliações pendentes');
                  } else {
                    final reviews = snapshot.data!;
                    final itemsToShow = reviews.length > 3
                        ? reviews.sublist(0, 3)
                        : reviews;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: itemsToShow.map((pr) {
                        return _buildPendingEvaluation(
                          atividade: pr.activity,
                          aluno: pr.student,
                          onTap: () async {
                            await widget.onEvaluateActivity?.call(
                              studentId: pr.studentId,
                              activityId: pr.activityId,
                            );
                            _loadPendingReviews();
                          },
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconCardButton(
    BuildContext context, {
    required String text,
    required IconData icon,
    String? routeName,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE7EDF8),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(text, style: const TextStyle(color: Colors.black)),
          trailing: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF5A76A9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(icon),
              color: const Color(0xFFDDEF71),
              onPressed: onTap ??
                  () {
                    if (routeName != null) {
                      Navigator.pushNamed(context, routeName);
                    }
                  },
            ),
          ),
          onTap: onTap ??
              () {
                if (routeName != null) {
                  Navigator.pushNamed(context, routeName);
                }
              },
        ),
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required VoidCallback onPressed,
    required Color backgroundColor,
    Color textColor = Colors.black,
    Color buttonColor = const Color(0xFFBFAF00),
    String? imageAsset,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 16, color: textColor)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                onPressed: onPressed,
                child: const Text('Ver mais'),
              ),
              if (imageAsset != null)
                Image.asset(
                  imageAsset,
                  width: 64,
                  height: 64,
                  fit: BoxFit.contain,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaCard(
    BuildContext context, {
    required String title,
  }) {
    return Opacity(
      opacity: 0.4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF000000),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFDDEF71),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              onPressed: null,
              child: const Text('Ver mais'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingEvaluation({
    required String atividade,
    required String aluno,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(atividade, style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Aluno: $aluno'),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.rate_review, color: Color(0xFF5A76A9)),
              tooltip: 'Avaliar atividade',
              onPressed: onTap,
            ),
          ],
        ),
      ),
    );
  }
}
