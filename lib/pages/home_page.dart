import 'package:entretien/pages/piece.dart';
import 'package:entretien/pages/recherche_page.dart';
import 'package:entretien/pages/voiture_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/db_helper.dart';

class MyHomePage extends StatefulWidget{
  const MyHomePage({super.key});

  @override
  State<MyHomePage>createState(){
    return PageAcceuilleState();
  }
}

class PageAcceuilleState extends State<MyHomePage>{

  int _selectedIndex = 0;

  // Pages à afficher

  @override
  void initState() {
    super.initState();
    _listeTodo();
    _loadNumVoiture();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        // ➕ On recharge les voitures quand on revient à l'accueil
        _loadNumVoiture();
      }
    });
  }


  TextEditingController _dateAchatController = TextEditingController();
  TextEditingController _nomPieceController = TextEditingController();
  TextEditingController _checkboxController = TextEditingController();
  TextEditingController _dateMontageController = TextEditingController();
  TextEditingController _autreExplicationController = TextEditingController();
  TextEditingController _prixController = TextEditingController();
  TextEditingController _lieuController = TextEditingController();
  TextEditingController _quantiteController = TextEditingController();


  void _addAchat() async {
    if (valueChoose != null &&
        valueChoose!.isNotEmpty &&
        _dateAchatController.text.isNotEmpty &&
        _nomPieceController.text.isNotEmpty) {

      await DbHelper.insertPiece(
        numVoiture: valueChoose!,
        dateAchat: _dateAchatController.text,
        nomPiece: _nomPieceController.text,
        prixUnitaire: double.tryParse(_prixController.text) ?? 0.0,
        qt: int.tryParse(_quantiteController.text) ?? 0,
        lieuAchat: _lieuController.text,
        efaNapetaka: isChecked ? 1 : 0,
        dateMontage: _dateMontageController.text,
        autreExplication: _autreExplicationController.text,
      );

      setState(() {
        valueChoose = null; // ❗ on remet la sélection à null
        _dateAchatController.clear();
        _nomPieceController.clear();
        _dateMontageController.clear();
        _autreExplicationController.clear();
        _prixController.clear();
        _lieuController.clear();
        _quantiteController.clear();
        isChecked = false;
        _listeTodo(); // recharge la liste
      });
    }
  }


  List<Piece> _pieces = [];

  void _listeTodo() async {                                 // lister les donnée au BD
    final data = await DbHelper.getAllPieces();
    setState(() {
      _pieces = data.map((e) => Piece.fromMap(e)).toList();
    });
  }

  bool isChecked = false;
  String date_montage= "";
  String date_montage_liste="";

  Future<void> selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
      locale: const Locale('fr'), // Spécifie ici aussi le français
    );

    if (_picked != null) {
      setState(() {
        _dateAchatController.text = DateFormat('dd-MM-yyyy', 'fr').format(_picked);
      });
    }
  }

  Future<void> selectDateMontage() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
      locale: const Locale('fr'), // Spécifie ici aussi le français
    );

    if (_picked != null) {
      setState(() {
        date_montage = DateFormat('dd-MM-yyyy', 'fr').format(_picked);
        _dateMontageController.text = date_montage;
      });
    }
  }

  Future<void> selectDateMontageListe() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2100),
      locale: const Locale('fr'), // Spécifie ici aussi le français
    );

    if (_picked != null) {
      setState(() {
        date_montage_liste = DateFormat('dd-MM-yyyy', 'fr').format(_picked);
      });
    }
  }

  Future<List<String>> fetchNumVoitures() async {               // fonction ampanitomana ilay numVoiture any @ BD
    final db = await DbHelper.database; // ✅ CORRECTION ICI

    final List<Map<String, dynamic>> maps = await db.query('voiture');

    return maps.map((row) => row['numVoiture'].toString()).toList();
  }

  void _loadNumVoiture() async {
    List<String> result = await fetchNumVoitures();
    setState(() {
      listNumVoiture = result;
    });
  }


  List<String> listNumVoiture = [];
  String? valueChoose;    // c'est mon controller de combobox

  @override
  Widget build(BuildContext context){
    return  Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("ENTRETIENS SUR MES VOITURES",
          style: TextStyle(fontWeight: FontWeight.bold),),
        elevation: 12, centerTitle: true,
        backgroundColor: Colors.amber,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RecherchePage()),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          buildHomeContent(),   // reconstruit à chaque fois
          MyVoiturePage(),
        ],
      ),

      // ilay resaka Navigation bar no antony tsy nanaovana ny contenu tato fa natao ary @widget aary ambany
      bottomNavigationBar: BottomNavigationBar(
        elevation: 50,
        backgroundColor: Colors.amber,
        selectedItemColor: Colors.black,                // Couleur de l’item sélectionné
        unselectedItemColor: Colors.white,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.build),
            label: "Accueil",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: "Voitures",
          ),
        ],
      ),
    );
  }

  Widget buildHomeContent() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(                                        // 1ere ligne
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(

                    child: DropdownButton<String>(
                      value: valueChoose,
                      hint: Text("Sélectionner une voiture"),
                      isExpanded: true,
                      onChanged: (newValue) {
                        setState(() {
                          valueChoose = newValue;
                        });
                      },
                      items: listNumVoiture.map((num) {
                        return DropdownMenuItem<String>(
                          value: num,
                          child: Text(num),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),


              /*TextField(
                    controller: _numVoitureController,
                    decoration: InputDecoration(
                      labelText: "Num de la voiture",
                      border: OutlineInputBorder(),
                      filled: true,
                    ),
                  ),*/

              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _nomPieceController,
                  decoration: InputDecoration(
                    labelText: "Nom du pièce",
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                ),
              ),


            ],
          ),
          SizedBox(height: 16),
          Row(                                         // 2eme ligne
            children: [

              Expanded(
                child: TextField(
                  controller: _prixController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Prix unitaire",
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                width: 60,
                child: TextField(
                  controller: _quantiteController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: "Qt",
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _lieuController,
                  decoration: InputDecoration(
                    labelText: "Lieu d'achat",
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                ),
              ),

            ],
          ),
          SizedBox(height: 16),
          Row(                                          // 3eme ligne
            children: [
              Expanded(
                child: TextField(
                  onTap: (){
                    selectDate();
                  },
                  controller: _dateAchatController,
                  decoration: InputDecoration(
                    labelText: "Date d'achat",
                    prefixIcon: Icon(Icons.calendar_month),
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                  readOnly: true,
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                child: TextField(
                  controller: _autreExplicationController,
                  decoration: InputDecoration(
                    labelText: "Note",
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                ),
              ),
            ],
          ),


SizedBox(height: 16,),
          Row(                                        // 4eme ligne
            children: [
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value ?? false;
                          isChecked? selectDateMontage():null;
                        });
                      },
                    ),
                    Expanded(
                      child: TextField(
                        controller: _dateMontageController,
                        readOnly: true,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: isChecked? "Date de montage:" : "Pas encore monté",

                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Row(                                           // 5eme ligne
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 15
                  ),
                  onPressed: _addAchat,
                  child: Text("VALIDER"),
                ),
              ),
            ],
          ),

          SizedBox(height: 16),
          Expanded(                                  // 6eme ligne
            child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 2),   // 👉 Bordure ici
                  borderRadius: BorderRadius.circular(8),             // (optionnel) coins arrondis
                ),

                child: _pieces.isEmpty
                    ? Center(child: Text("Aucune pièce enregistrée."))
                    : ListView.builder(
                  itemCount: _pieces.length,
                  itemBuilder: (context, index) {
                    final piece = _pieces[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: ListTile(
                        title: Text('${piece.nomPiece} (${piece.numVoiture})'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date Achat : ${piece.dateAchat}'),
                            Text('Prix unitaire : ${piece.prixUnitaire} Ar avec ${piece.qt} pièce.'),
                            Text('Prix total : ${piece.prixUnitaire * piece.qt} Ar'),
                            Row(
                              children: [
                                Checkbox(
                                  value: piece.efaNapetaka == 1,
                                  onChanged: (bool? newValue) async {
                                    if (newValue == true) {
                                      // Affiche le sélecteur de date
                                      DateTime? selectedDate = await showDatePicker(
                                        context: context,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime(2015),
                                        lastDate: DateTime(2100),
                                        locale: const Locale('fr'), // français
                                      );

                                      if (selectedDate != null) {
                                        String formattedDate = DateFormat('dd-MM-yyyy', 'fr').format(selectedDate);

                                        await DbHelper.updatePiece(
                                          id: piece.id,
                                          values: {
                                            'efaNapetaka': 1,
                                            'dateMontage': formattedDate,
                                          },
                                        );
                                        _listeTodo(); // recharge la liste
                                      }
                                    } else {
                                      // Si décoché, on remet efaNapetaka = 0 et dateMontage vide
                                      await DbHelper.updatePiece(
                                        id: piece.id,
                                        values: {
                                          'efaNapetaka': 0,
                                          'dateMontage': '',
                                        },
                                      );
                                      _listeTodo();
                                    }
                                  },
                                ),
                                Text(piece.efaNapetaka == 1
                                    ? "Monté le ${piece.dateMontage}"
                                    : "Pas encore monté"),
                              ],
                            ),

                            //Text('Montage : ${piece.efaNapetaka == 1 ? 'Date de montage' : 'Non, pas encore monté'}'),
                            if (piece.autreExplication.isNotEmpty)
                              Text('Note : ${piece.autreExplication}'),
                          ],
                        ),
                        trailing:
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
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
                              await DbHelper.deletePiece(piece.id);
                              _listeTodo();
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
                ),
            ),
        ],
      ),
    );
  }
}
