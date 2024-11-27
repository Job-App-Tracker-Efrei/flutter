import 'package:flutter/material.dart';
import 'package:mobile/models/job_model.dart';

class EditCandidaturePage extends StatefulWidget {
  final JobApplication candidature;

  const EditCandidaturePage({super.key, required this.candidature});

  @override
  _EditCandidaturePageState createState() => _EditCandidaturePageState();
}

class _EditCandidaturePageState extends State<EditCandidaturePage> {
  late TextEditingController _entrepriseController;
  late TextEditingController _posteController;
  late JobApplicationStatus _statut;

  final List<JobApplicationStatus> _statutOptions = [
    JobApplicationStatus.pending,
    JobApplicationStatus.accepted,
    JobApplicationStatus.rejected,
  ];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _entrepriseController = TextEditingController(text: widget.candidature.company);
    _posteController = TextEditingController(text: widget.candidature.position);
    _statut = widget.candidature.status;
  }

  @override
  void dispose() {
    _entrepriseController.dispose();
    _posteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier la candidature'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _entrepriseController,
                decoration: InputDecoration(
                  labelText: 'Entreprise',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.business),
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
                decoration: InputDecoration(
                  labelText: 'Poste',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.work),
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
                decoration: InputDecoration(
                  labelText: 'Statut',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.check_circle),
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
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Mettre à jour la candidature
                        final updatedCandidature = widget.candidature
                          ..company = _entrepriseController.text
                          ..position = _posteController.text
                          ..status = _statut
                          ..lastUpdate = DateTime.now();

                        Navigator.of(context).pop(updatedCandidature);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: const Text('Enregistrer'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Logique pour supprimer la candidature
                      Navigator.of(context).pop('delete');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      backgroundColor: Colors.red, // Couleur rouge pour indiquer la suppression
                    ),
                    child: const Text('Supprimer',
                      style: TextStyle(color: Colors.white),
                    )
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getStatusText(JobApplicationStatus status) {
    switch (status) {
      case JobApplicationStatus.pending:
        return 'En cours';
      case JobApplicationStatus.accepted:
        return 'Accepté';
      case JobApplicationStatus.rejected:
        return 'Refusé';
      default:
        return '';
    }
  }
}