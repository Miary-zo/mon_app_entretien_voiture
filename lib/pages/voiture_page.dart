import 'package:entretien/pages/piece.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/db_helper.dart';

class MyVoiturePage extends StatefulWidget{
  const MyVoiturePage({super.key});

  @override
  State<MyVoiturePage>createState(){
    return PageVoitureeState();
  }
}

class PageVoitureeState extends State<MyVoiturePage>{


  TextEditingController _numVoitureController = TextEditingController();

  void _addVoiture() async {                                        // ajout au base de donné
    if (_numVoitureController.text.isNotEmpty) {
      await DbHelper.insertVoiture(
        numVoiture: _numVoitureController.text,
      );

      setState(() {
        _numVoitureController.clear();
        _listeTodoVoiture(); // cette méthode doit recharger les données
      });
    }
  }

  List<Voiture> _voiture = [];

  void _listeTodoVoiture() async {                                 // lister les donnée au BD
    final data = await DbHelper.getAllVoitures();
    setState(() {
      _voiture = data.map((e) => Voiture.fromMap(e)).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _listeTodoVoiture();
  }

  @override
  Widget build(BuildContext context){
    return  Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(                                  // 1ere ligne
              children: [
                Expanded(
                  child: TextField(
                      controller: _numVoitureController,
                      decoration: InputDecoration(
                        labelText: "Numéro d'immatriculation de la voiture",
                        border: OutlineInputBorder(),
                        filled: true,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16,),
            Row(                                      //2eme ligne
              children: [
                Expanded(
                  child: ElevatedButton(
                      child: Text("VALIDER"),
                      onPressed: _addVoiture,
                      
                  )
                )
              ],
            ),

            SizedBox(height: 16,),

            Expanded(                                                // 3eme ligne
            child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2),   // 👉 Bordure ici
              borderRadius: BorderRadius.circular(8),             // (optionnel) coins arrondis
            ),

              child: _voiture.isEmpty
                ? Center(child: Text("Aucune voiture enregistrée."))
                  : ListView.builder(
                    itemCount: _voiture.length,
                    itemBuilder: (context, index) {
                      final voiture = _voiture[index];
                      return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: ListTile(
                                          title: Text('Voiture numéro :'),
                                          subtitle: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                            Text('${voiture.numVoiture}'),
                                          ],
                                          ),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.delete, color: Colors.red),
                                            onPressed: () async {
                                            final confirm = await showDialog<bool>(                             // boitier de dialogue de confirmation de suppression
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                title: Text("Confirmation"),
                                                content: Text("Voulez-vous vraiment supprimer cette pièce ?"),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, true), // Confirmer
                                                    child: Text("Oui"),
                                                  ),
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(context, false), // Annuler
                                                    child: Text("Non"),
                                                  ),
                                                ],
                                              ),
                                            );

                                            if (confirm == true) {
                                            await DbHelper.deleteVoiture(voiture.id);
                                            _listeTodoVoiture();
                                            }
                                            },
                                          ),


                                ),
                      );
              },
              ),
              ),



            )],
        ),

    );
  }
}
