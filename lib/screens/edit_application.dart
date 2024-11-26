import 'package:flutter/material.dart';

class EditCandidaturePage extends StatefulWidget {
  final Map<String, String> candidature;

  const EditCandidaturePage({super.key, required this.candidature});

  @override
  _EditCandidaturePageState createState() => _EditCandidaturePageState();
}

class _EditCandidaturePageState extends State<EditCandidaturePage> {
  late TextEditingController _entrepriseController;
  late TextEditingController _posteController;
  late String _statut;

  final List<String> _statutOptions = ['En cours', 'Accepté', 'Refusé'];

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _entrepriseController = TextEditingController(text: widget.candidature['entreprise']);
    _posteController = TextEditingController(text: widget.candidature['poste']);
    _statut = widget.candidature['statut']!;
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
        title: const Text('Ta Candidature'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
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
              DropdownButtonFormField<String>(
                value: _statut,
                decoration: InputDecoration(
                  labelText: 'Statut',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.check_circle),
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
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final candidatureMiseAJour = {
                        'entreprise': _entrepriseController.text,
                        'poste': _posteController.text,
                        'statut': _statut,
                      };
                      Navigator.of(context).pop(candidatureMiseAJour);
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}