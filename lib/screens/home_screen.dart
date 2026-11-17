import 'package:flutter/material.dart';
import 'nota_storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller permite ler o conteudo digitado no Textfield
  final TextEditingController _controller = TextEditingController();

  // Instancia do serviço: a tela não acessa o pacote diretamente
  final NotaStorageService _storage = NotaStorageService();
  //  Guarda o texto que a interface mostra abaixo dos botões
  String _notaSalva = '';

  @override
  void initState() {
    super.initState();
    carregarNota(); // recuperar o valor ao abrir a home
  }

  // Busca o texto salvo, espera a leitura e atualiza a interface
  Future<void> carregarNota() async {
    final String texto = await _storage.buscarNota();
    if (!mounted) return; // verifica se a tela ainda esta disponivel

    setState(() {
      _notaSalva = texto; // Atualiza o texto marcado na tela
      _controller.text = texto; // Preenche o campo com o valor salvo.
    });
  }
  // Função chamada pelo onPressed do botão Salvar. Salva o texto digitado no campo de texto.
  Future<void> salvarNota() async {
    // variavvel para armazenar a nota digitada pelo usuário
    final String texto = _controller.text.trim(); // pega o valor digitado
    // verificamos se a nota está vazia
    if(texto.isEmpty) return;

    // grava no dispositivo
    await _storage.salvarNota(texto);
    if (!mounted) return; // verifica se a tela ainda esta disponivel

    setState(() {
      _notaSalva = texto; // Atualiza o texto marcado na tela
    });

    // Informaos ao usuário que a ação finalizou
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Nota Salva no dispositivo')),
    );
  }

  Future<void> apagarNota() async {
    await _storage.apagarNota();
    if(!mounted) return; // verifica se a tela ainda esta disponivel

    setState(() {
      _notaSalva = '';
      _controller.clear();
    });
  }

  @override
  void dispose() {
    //Libera o controller quando o flutter descarta essa tela.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minhas Notas')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Minha primeira anotação.'),
            
            const SizedBox(height: 12),

            TextField(
              controller: _controller, // Conecta o campo ao controller
              maxLines: 3, // Permirir escrever até três linhas
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Escreva uma anotação...',
              ),
            ),

            const SizedBox(height: 12),

            FilledButton(
              onPressed: salvarNota, 
              child: const Text ('Salvar no dispositivo'),
              ),
              OutlinedButton(
              onPressed: apagarNota, 
              child: const Text('Apagar a nota salva')
              ),

              const SizedBox(height: 12),

              const Text ('Nota recuperada do armazenamento:'),
              const SizedBox(height: 8),
              Text(_notaSalva.isEmpty ? 'Nenhuma nota salva' : _notaSalva),
            ],
        ),
      ),
    );
  }
}