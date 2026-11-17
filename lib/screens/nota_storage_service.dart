import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/nota.dart';


// Serviço: separa as regras de armazenamento dos widgets da tela.
class NotaStorageService {
  // a chave funciona como o nome do estapaço onde guardamos o texto
  static const String chaveAntiga = 'nota_inicial';
  static const String chaveNota = 'lista_notas';

  // SharedPreferencesAsync lê e grava valores simples no dispositivo.
  // final impede _perfs receba outra instancia depois de criada
  final SharedPreferencesAsync _perfs = SharedPreferencesAsync();

  Future<List<Nota>> listarNotas() async {
    final String? texto = await _perfs.getString(chaveNota);
    if (texto == null) {
      final String? antiga = await _perfs.getString(chaveAntiga);

      if (antiga == null || antiga.trim().isEmpty) {
        return [];
      }

      final Nota primeira = Nota(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        titulo: 'Minha primeira nota',
        conteudo: antiga,
      );

      await salvarLista([primeira]);
      await _perfs.remove(chaveAntiga);
      return [primeira];
    }

    final List<dynamic> dados = jsonDecode(texto) as List<dynamic>;

    return dados.map((item){
      return Nota.fromMap(item as Map<String, dynamic>);
    }).toList();
  }

  // Recebe o texto  e o armazena, não devolve resultado
  Future<void> salvarLista(List<Nota> notas) async {
    final List<Map<String, dynamic>> dados = notas.map((nota){
      return nota.toMap();
    }).toList();

    final String texto = jsonEncode(dados);
    await _perfs.setString(chaveNota, texto);
  }

  Future<void> adicionarNota(Nota novaNota) async {
    final List<Nota> notas = await listarNotas();
    notas.add(novaNota);
    await salvarLista(notas);

  }

  //  Recuperar a nota. Retorna String, mesmo se não existir valor.
  Future<String> buscarNota() async {
    //String? significa que podemos ter retorno com String null
    final String? nota = await _perfs.getString(chaveNota);
    // ?? usamos o texto vazio caso a nota seja null.
    return nota ?? '';
  }

  // exclui somente o valor salvo na chave nota.
  Future<void> apagarNota() async {
    await _perfs.remove(chaveNota);
  }
}
