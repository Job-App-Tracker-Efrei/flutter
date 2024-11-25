import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Suivi des Candidatures',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SuiviCandidatures(),
    );
  }
}

class SuiviCandidatures extends StatelessWidget {
  const SuiviCandidatures({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi des Candidatures'),
        actions: [
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cartes de statistiques
              const Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  StatCard(title: 'Candidatures\ntotales', value: '10'),
                  StatCard(title: 'En cours', value: '5'),
                  StatCard(title: 'Acceptées', value: '2'),
                  StatCard(title: 'Refusées', value: '3'),
                ],
              ),
              const SizedBox(height: 24),
              // Barre de recherche
              Row(
                children: [
                  const Text('Entreprise', 
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Nom de l\'entreprise',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  TextButton(
                    onPressed: () {},
                    child: const Text('Filtrer'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Tableau
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  horizontalMargin: 0,
                  columnSpacing: 40,
                  columns: const [
                    DataColumn(label: Text('Entreprise')),
                    DataColumn(label: Text('Poste')),
                    DataColumn(label: Text('Statut')),
                  ],
                  rows: [
                    DataRow(cells: [
                      const DataCell(Text('TechCorp')),
                      const DataCell(Text('Développeur Full Stack')),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text('En cours'),
                        ),
                      ),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('InnovSoft')),
                      const DataCell(Text('Ingénieur DevOps')),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text('Refusé'),
                        ),
                      ),
                    ]),
                    DataRow(cells: [
                      const DataCell(Text('DataViz')),
                      const DataCell(Text('Data Scientist')),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Text('Accepté'),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 2 - 24,
      height: 120, // Hauteur fixe pour toutes les cards
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 40, // Hauteur fixe pour la zone de titre
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}