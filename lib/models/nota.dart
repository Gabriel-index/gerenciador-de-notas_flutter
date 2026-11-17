// Este arquivo é responsável por definir o formato de cada anotação.
// Classe não desenha tela, nem salva dados.
class Nota {
  final String id;
  final String titulo;
  final String conteudo;

  const Nota({
    required this.id,
    required this.titulo,
    required this.conteudo,
  });

  // Map relaciona cada chave String ao seu valor.
  // dynamic permite valores de diferentes tipos no mapa
  // Converter para Map facilita tranformar o objeto em JSON

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'conteudo': conteudo,
    };
  }

  factory Nota.fromMap(Map<String, dynamic> map) {
    return Nota(
      id: map['id'] as String,
      titulo: map['titulo'] as String,
      conteudo: map['conteudo'] as String,
    );
  }
}


