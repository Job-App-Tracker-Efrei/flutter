import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile/screens/auth.dart';
import 'package:mobile/screens/edit_application.dart';
import 'package:mobile/services/job_service.dart';
import 'package:mobile/models/job_model.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final JobApplicationService _jobService = JobApplicationService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Set context for SnackBar in job service
    _jobService.setContext(context);
  }

  void _editerCandidature(JobApplication candidature) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCandidaturePage(candidature: candidature),
      ),
    );

    if (result != null) {
      // Update the job application in Firestore
      await _jobService.updateJobApplication(result);
    }
  }

  void _ajouterCandidature() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AddCandidatureModal();
      },
    ).then((nouvelleCandidature) {
      if (nouvelleCandidature != null) {
        _jobService.addJobApplication(nouvelleCandidature);
      }
    });
  }

  void _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AuthPage()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la déconnexion : ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
                  child: Row(
                    children: [
                      Icon(Icons.logout, color: Colors.red, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Se déconnecter',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ];
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            offset: const Offset(0, 50),
            elevation: 4,
          ),
        ],
      ),
      body: StreamBuilder<List<JobApplication>>(
        stream: _jobService.getJobApplications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Aucune candidature trouvée'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _ajouterCandidature,
                    child: const Text('Ajouter une candidature'),
                  ),
                ],
              ),
            );
          }

          final candidatures = snapshot.data!;

          return SingleChildScrollView(
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
                          value: candidatures.length.toString()),
                      StatCard(
                          title: 'En cours',
                          value: candidatures
                              .where((c) => c.status == JobApplicationStatus.pending)
                              .length
                              .toString()),
                      StatCard(
                          title: 'Acceptées',
                          value: candidatures
                              .where((c) => c.status == JobApplicationStatus.accepted)
                              .length
                              .toString()),
                      StatCard(
                          title: 'Refusées',
                          value: candidatures
                              .where((c) => c.status == JobApplicationStatus.rejected)
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
                            controller: _searchController,
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
                        onPressed: () {
                          // TODO: Implement search functionality
                        },
                        child: const Text('Filtrer'),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: _ajouterCandidature,
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
                      showCheckboxColumn: false,
                      columns: const [
                        DataColumn(label: Text('Entreprise')),
                        DataColumn(label: Text('Poste')),
                        DataColumn(label: Text('Statut')),
                        DataColumn(label: Text('Date')),
                      ],
                      rows: candidatures.map((candidature) {
                        return DataRow(
                          onSelectChanged: (_) {
                            _editerCandidature(candidature);
                          },
                          cells: [
                            DataCell(Text(candidature.company)),
                            DataCell(Text(candidature.position)),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(candidature.status),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(_getStatusText(candidature.status)),
                              ),
                            ),
                            DataCell(Text(
                              '${candidature.date.day}/${candidature.date.month}/${candidature.date.year}'
                            )),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Fonction pour obtenir la couleur du statut
  Color _getStatusColor(JobApplicationStatus statut) {
    switch (statut) {
      case JobApplicationStatus.pending:
        return Colors.blue.withOpacity(0.1);
      case JobApplicationStatus.accepted:
        return Colors.green.withOpacity(0.1);
      case JobApplicationStatus.rejected:
        return Colors.red.withOpacity(0.1);
    }
  }

  // Fonction pour obtenir le texte du statut
  String _getStatusText(JobApplicationStatus statut) {
    switch (statut) {
      case JobApplicationStatus.pending:
        return 'En cours';
      case JobApplicationStatus.accepted:
        return 'Accepté';
      case JobApplicationStatus.rejected:
        return 'Refusé';
    }
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
  JobApplicationStatus _statut = JobApplicationStatus.pending;
  DateTime? _datePostulation;

  final List<JobApplicationStatus> _statutOptions = [
    JobApplicationStatus.pending, 
    JobApplicationStatus.accepted, 
    JobApplicationStatus.rejected
  ];

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _datePostulation = picked;
      });
    }
  }

  // Helper method to get status text
  String _getStatusText(JobApplicationStatus status) {
    switch (status) {
      case JobApplicationStatus.pending:
        return 'En cours';
      case JobApplicationStatus.accepted:
        return 'Accepté';
      case JobApplicationStatus.rejected:
        return 'Refusé';
    }
  }

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
            DropdownButtonFormField<JobApplicationStatus>(
              value: _statut,
              decoration: const InputDecoration(
                labelText: 'Statut',
                border: OutlineInputBorder(),
              ),
              items: _statutOptions.map((JobApplicationStatus status) {
                return DropdownMenuItem<JobApplicationStatus>(
                  value: status,
                  child: Text(_getStatusText(status)),
                );
              }).toList(),
              onChanged: (JobApplicationStatus? newValue) {
                setState(() {
                  _statut = newValue!;
                });
              },
            ),
            const SizedBox(height: 16),
            // Date picker
            Row(
              children: [
                Expanded(
                  child: Text(
                    _datePostulation != null 
                      ? 'Date de postulation: ${_datePostulation!.day}/${_datePostulation!.month}/${_datePostulation!.year}'
                      : 'Aucune date sélectionnée',
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: _selectDate,
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final nouvelleCandidature = JobApplication(
                company: _entrepriseController.text,
                position: _posteController.text,
                status: _statut,
                date: _datePostulation ?? DateTime.now(),
              );

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
      height: 120,
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
            height: 40,
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