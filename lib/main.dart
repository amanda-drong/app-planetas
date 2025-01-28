import 'package:flutter/material.dart';
import 'package:myapp/telas/tela_planeta.dart';
import 'controles/controle_planeta.dart';
import 'modelos/planeta.dart';

void main() {
  runApp(const MyApp());
}

// Classe principal do aplicativo
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Planetas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 220, 12, 189)), // Cor tema
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'App - Planetas'), // Página inicial
    );
  }
}

// Classe da página inicial
class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ControlePlaneta _controlePlaneta = ControlePlaneta();
  List<Planeta> _planetas = [];

  @override
  void initState() {
    super.initState();
    _atualizarPlanetas(); // Atualiza a lista de planetas ao iniciar
  }

  // Método para atualizar a lista de planetas
  Future<void> _atualizarPlanetas() async {
    final resultado = await _controlePlaneta.lerPlanetas();
    setState(() {
      _planetas = resultado;
    });
  }

  // Método para navegar até a tela de inclusão de planeta
  void _incluirPlaneta(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: true,
          planeta: Planeta.vazio(),
          onFinalizado: () {
            _atualizarPlanetas();
          },
        ),
      ),
    );
  }

  // Método para navegar até a tela de alteração de planeta
  void _alterarPlaneta(BuildContext context, Planeta planeta) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TelaPlaneta(
          isIncluir: false,
          planeta: planeta,
          onFinalizado: () {
            _atualizarPlanetas();
          },
        ),
      ),
    );
  }

  // Método para confirmar a edição de um planeta
  Future<void> _confirmarEditar(BuildContext context, Planeta planeta) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Editar Planeta'),
          content: const Text('Deseja realmente editar este planeta?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop(false); // Fecha o diálogo sem editar
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop(true); // Confirma a edição
                _alterarPlaneta(context, planeta); // Navega para a tela de alteração
              },
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Edição iniciada com sucesso!')), // Mostra mensagem de sucesso
      );
    }
  }

  // Método para confirmar a exclusão de um planeta
  Future<void> _confirmarExcluir(BuildContext context, int id) async {
    final bool? confirmar = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Excluir Planeta'),
          content: const Text('Deseja realmente excluir este planeta?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop(false); // Fecha o diálogo sem excluir
              },
            ),
            TextButton(
              child: const Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop(true); // Confirma a exclusão
              },
            ),
          ],
        );
      },
    );

    if (confirmar == true) {
      await _controlePlaneta.excluirPlaneta(id); // Exclui o planeta
      _atualizarPlanetas(); // Atualiza a lista de planetas
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Planeta excluído com sucesso!')), // Mostra mensagem de sucesso
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: ListView.builder(
        itemCount: _planetas.length, // Número de planetas na lista
        itemBuilder: (context, index) {
          final planeta = _planetas[index];
          return ListTile(
            title: Text(planeta.nome),
            subtitle: Text(planeta.apelido!),
            trailing: Row(mainAxisSize: MainAxisSize.min, children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _confirmarEditar(context, planeta), // Botão de editar planeta
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _confirmarExcluir(context, planeta.id!), // Botão de excluir planeta
              ),
            ]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _incluirPlaneta(context); // Botão para adicionar planeta
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
