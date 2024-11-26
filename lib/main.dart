import 'package:flutter/material.dart';
import 'screens/edit_application.dart';

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

class AddCandidatureModal extends StatefulWidget {
  const AddCandidatureModal({super.key});

  @override
  _AddCandidatureModalState createState() => _AddCandidatureModalState();
}

class _AddCandidatureModalState extends State<AddCandidatureModal> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _entrepriseController = TextEditingController();
  final TextEditingController _posteController = TextEditingController();
  String _statut = 'En cours';

  final List<String> _statutOptions = ['En cours', 'Accepté', 'Refusé'];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'Nouvelle Candidature',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _entrepriseController,
              decoration: const InputDecoration(
                labelText: 'Entreprise',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le nom de l\'entreprise';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _posteController,
              decoration: const InputDecoration(
                labelText: 'Poste',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Veuillez entrer le nom du poste';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _statut,
              decoration: const InputDecoration(
                labelText: 'Statut',
                border: OutlineInputBorder(),
              ),
              items: _statutOptions.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _statut = newValue!;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Fermer la modale
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              // Logique pour enregistrer la nouvelle candidature
              final nouvelleCandidature = {
                'entreprise': _entrepriseController.text,
                'poste': _posteController.text,
                'statut': _statut,
              };

              Navigator.of(context).pop(nouvelleCandidature);
            }
          },
          child: const Text('Ajouter'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}

class SuiviCandidatures extends StatefulWidget {
  const SuiviCandidatures({super.key});

  @override
  _SuiviCandidaturesState createState() => _SuiviCandidaturesState();
}

class _SuiviCandidaturesState extends State<SuiviCandidatures> {
  // Liste pour stocker les candidatures
  final List<Map<String, String>> _candidatures = [
    {
      'entreprise': 'TechCorp',
      'poste': 'Développeur Full Stack',
      'statut': 'En cours'
    },
    {
      'entreprise': 'InnovSoft',
      'poste': 'Ingénieur DevOps',
      'statut': 'Refusé'
    },
    {'entreprise': 'DataViz', 'poste': 'Data Scientist', 'statut': 'Accepté'},
  ];

  // Fonction pour éditer une candidature
  void _editerCandidature(int index) async {
    // Navigate to the EditCandidaturePage and wait for the result
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditCandidaturePage(candidature: _candidatures[index]),
      ),
    );

    // If a result is returned (candidature was updated)
    if (result != null) {
      setState(() {
        // Update the candidature at the specific index
        _candidatures[index] = result;
      });
    }
  }

  // Fonction pour se déconnecter
  void _signOut(BuildContext context) {
    // Implement sign-out logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suivi des Candidatures'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.menu),
            onSelected: (String value) {
              if (value == 'signOut') {
                _signOut(context);
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem<String>(
                  value: 'signOut',
                  child: ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'Se déconnecter',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ];
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cartes de statistiques
              Wrap(
                spacing: 16,
                runSpacing: 16,
                children: [
                  StatCard(
                      title: 'Candidatures\ntotales',
                      value: _candidatures.length.toString()),
                  StatCard(
                      title: 'En cours',
                      value: _candidatures
                          .where((c) => c['statut'] == 'En cours')
                          .length
                          .toString()),
                  StatCard(
                      title: 'Acceptées',
                      value: _candidatures
                          .where((c) => c['statut'] == 'Accepté')
                          .length
                          .toString()),
                  StatCard(
                      title: 'Refusées',
                      value: _candidatures
                          .where((c) => c['statut'] == 'Refusé')
                          .length
                          .toString()),
                ],
              ),
              const SizedBox(height: 24),
              // Barre de recherche
              Row(
                children: [
                  const Text(
                    'Entreprise',
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
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 16),
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
                    onPressed: () {
                      // Afficher la modale d'ajout de candidature
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const AddCandidatureModal();
                        },
                      ).then((nouvelleCandidature) {
                        if (nouvelleCandidature != null) {
                          setState(() {
                            _candidatures.add(nouvelleCandidature);
                          });
                        }
                      });
                    },
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
                  showCheckboxColumn: false, // Désactive la case à cocher
                  columns: const [
                    DataColumn(label: Text('Entreprise')),
                    DataColumn(label: Text('Poste')),
                    DataColumn(label: Text('Statut')),
                  ],
                  rows: _candidatures.map((candidature) {
                    return DataRow(
                      onSelectChanged: (_) {
                        _editerCandidature(_candidatures.indexOf(candidature));
                      },
                      cells: [
                        DataCell(Text(
                            candidature['entreprise']!)), // Colonne entreprise
                        DataCell(Text(candidature['poste']!)), // Colonne poste
                        DataCell(
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor(candidature['statut']!),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child:
                                Text(candidature['statut']!), // Colonne statut
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Fonction pour obtenir la couleur du statut
  Color _getStatusColor(String statut) {
    switch (statut) {
      case 'En cours':
        return Colors.blue.withOpacity(0.1);
      case 'Accepté':
        return Colors.green.withOpacity(0.1);
      case 'Refusé':
        return Colors.red.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
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
          SizedBox(
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
