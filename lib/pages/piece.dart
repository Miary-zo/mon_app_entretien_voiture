
class Piece {
  final int id;
  final String numVoiture;
  final String dateAchat;
  final String nomPiece;
  final double prixUnitaire;
  final int qt;
  final String lieuAchat;
  final int efaNapetaka; // 0 ou 1
  final String dateMontage;
  final String autreExplication;

  Piece({
    required this.id,
    required this.numVoiture,
    required this.dateAchat,
    required this.nomPiece,
    required this.prixUnitaire,
    required this.qt,
    required this.lieuAchat,
    required this.efaNapetaka,
    required this.dateMontage,
    required this.autreExplication,
  });

  factory Piece.fromMap(Map<String, dynamic> map) {
    return Piece(
      id: map['id'],
      numVoiture: map['numVoiture'],
      dateAchat: map['dateAchat'],
      nomPiece: map['nomPiece'],
      prixUnitaire: map['prixUnitaire'],
      qt: map['qt'],
      lieuAchat: map['lieuAchat'],
      efaNapetaka: map['efaNapetaka'],
      dateMontage: map['dateMontage'],
      autreExplication: map['autreExplication'],
    );
  }
}



class Voiture {
  final int id;
  final String numVoiture;

  Voiture({
    required this.id,
    required this.numVoiture,
  });

  factory Voiture.fromMap(Map<String, dynamic> map) {
    return Voiture(
      id: map['id'],
      numVoiture: map['numVoiture'],
    );
  }
}

