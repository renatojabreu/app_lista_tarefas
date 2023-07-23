import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controller/tarefas_controller.dart';
import '../model/tarefas_model.dart';

class TarefasView extends StatefulWidget {
  const TarefasView({super.key});

  @override
  State<TarefasView> createState() => _TarefasViewState();
}

class _TarefasViewState extends State<TarefasView> {
  List<TarefasModel> listaTarefas = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: listaTarefas.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(listaTarefas[index].titulo),
            subtitle: Text(
                "${listaTarefas[index].descricao}\n${DateFormat('dd/MM/yyyy').format(listaTarefas[index].data)}"),
            trailing: Column(
              children: [
                GestureDetector(
                  child: const Icon(Icons.delete),
                  onTap: () {
                    TarefasController.removeTarefa(
                        context, listaTarefas, index, _atualizaLista);
                  },
                ),
                Text(listaTarefas[index].status),
              ],
            ),
            onTap: listaTarefas[index].status != "concluída"
                ? () {
                    TarefasController.atualizarStatusTarefa(context,
                        listaTarefas, index, "concluída", _atualizaLista);
                  }
                : null,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          TarefasController.adicionarTarefa(
            context,
            listaTarefas,
            _atualizaLista,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _atualizaLista(List<TarefasModel> listaAtualizada) {
    setState(() {
      listaTarefas = listaAtualizada;
    });
  }
}
