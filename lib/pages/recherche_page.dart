import 'package:flutter/material.dart';
import '../data/db_helper.dart';
import '../pages/piece.dart';

class RecherchePage extends StatefulWidget {
  const RecherchePage({super.key});

  @override
  State<RecherchePage> createState() => _RecherchePageState();
}

class _RecherchePageState extends State<RecherchePage> {
  TextEditingController _searchController = TextEditingController();
  List<Piece> _allPieces = [];
  List<Piece> _filteredPieces = [];

  @override
  void initState() {
    super.initState();

    // Écouter les changements de texte
    _searchController.addListener(() {
      _filterPieces();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Charger toutes les pièces de la BD
  Future<void> _loadAllPieces() async {
    final data = await DbHelper.getAllPieces();
    setState(() {
      _allPieces = data.map((e) => Piece.fromMap(e)).toList();
      _filteredPieces = _allPieces; // Afficher tout par défaut
    });
  }

  // Filtrage selon le texte saisi
  void _filterPieces() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        _filteredPieces = _allPieces;
      } else {
        _filteredPieces = _allPieces.where((piece) {
          return piece.nomPiece.toLowerCase().contains(query) ||
              piece.numVoiture.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recherche"),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Champ de recherche
            TextField(
              controller: _searchController,
              onTap: () {
                _loadAllPieces(); // charger les données dès qu’on clique
              },
              decoration: InputDecoration(
                labelText: "Rechercher une pièce ou une voiture",
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _filteredPieces.isEmpty
                  ? Center(child: Text("Aucun résultat"))
                  : ListView.builder(
                itemCount: _filteredPieces.length,
                itemBuilder: (context, index) {
                  final piece = _filteredPieces[index];
                  return ListTile(
                    title: Text('${piece.nomPiece}'),
                    subtitle: Text('Voiture : ${piece.numVoiture}\nDate : ${piece.dateAchat}'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
