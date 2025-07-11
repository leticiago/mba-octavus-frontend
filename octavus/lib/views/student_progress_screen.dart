import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:octavus/models/StudentMetrics.dart';
import '../services/StudentService.dart';

class StudentProgressScreen extends StatefulWidget {
  final String studentId;
  final void Function(int)? onNavigate;

  const StudentProgressScreen({
    Key? key,
    required this.studentId,
    this.onNavigate,
  }) : super(key: key);

  @override
  State<StudentProgressScreen> createState() => _StudentProgressScreenState();
}

class _StudentProgressScreenState extends State<StudentProgressScreen> {
  late Future<StudentMetrics> _metricsFuture;
  final StudentService _service = StudentService();

  @override
  void initState() {
    super.initState();
    _metricsFuture = _service.getStudentMetrics(widget.studentId);
  }

  @override
  void didUpdateWidget(covariant StudentProgressScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.studentId != widget.studentId) {
      setState(() {
        _metricsFuture = _service.getStudentMetrics(widget.studentId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatório de Progresso'),
        leading: widget.onNavigate != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => widget.onNavigate!(0),
              )
            : null,
      ),
      body: FutureBuilder<StudentMetrics>(
        future: _metricsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Nenhum dado disponível'));
          }

          final metrics = snapshot.data!;
          final activityTypes = metrics.averageScoreByActivityType.keys.toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Média de acertos', style: TextStyle(fontSize: 20)),
                const SizedBox(height: 8),
                Text('${(metrics.averageScore * 10).round()} %',
                    style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Total de atividades: ${metrics.totalActivitiesDone}'),
                const SizedBox(height: 32),
                const Text('Média por tipo de atividade', style: TextStyle(fontSize: 18)),
                const SizedBox(height: 50),

                SizedBox(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: BarChart(
                      BarChartData(
                        maxY: 20,
                        barGroups: List.generate(activityTypes.length, (i) {
                          final activityType = activityTypes[i];
                          final score = metrics.averageScoreByActivityType[activityType] ?? 0;

                          return BarChartGroupData(
                            x: i,
                            barRods: [
                              BarChartRodData(
                                toY: score,
                                width: 20,
                                color: Colors.purple,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ],
                          );
                        }),
                        borderData: FlBorderData(show: false),
                        gridData: FlGridData(show: false),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                final index = value.toInt();
                                if (index >= 0 && index < activityTypes.length) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Text(
                                      activityTypes[index],
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  );
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                          ),
                          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
