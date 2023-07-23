import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../model/tarefas_model.dart';

class TarefasController {
  //
  static void adicionarTarefa(
    BuildContext context,
    List<TarefasModel> tarefas,
    Function(List<TarefasModel>) atualizaLista,
  ) {
    List<String> statusOptions = ['pendente', 'concluída'];
    String selectedStatus = 'pendente';
    TextEditingController dateController = TextEditingController();

    final GlobalKey<FormState> formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        String titulo = '';
        String descricao = '';

        return AlertDialog(
          title: const Text('Adicionar Tarefa'),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    onChanged: (value) => titulo = value,
                    decoration: const InputDecoration(labelText: 'Título'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira um título.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    onChanged: (value) => descricao = value,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma descrição.';
                      }
                      return null;
                    },
                  ),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    onChanged: (String? newValue) {
                      selectedStatus = newValue!;
                    },
                    items: statusOptions.map((String option) {
                      return DropdownMenuItem<String>(
                        value: option,
                        child: Text(option),
                      );
                    }).toList(),
                    decoration: const InputDecoration(labelText: 'Status'),
                  ),
                  TextFormField(
                    controller: dateController,
                    decoration:
                        const InputDecoration(labelText: 'Data (dd/mm/yyyy)'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira uma data.';
                      }
                      return null;
                    },
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (selectedDate != null) {
                        dateController.text =
                            DateFormat('dd/MM/yyyy').format(selectedDate);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  DateTime parsedDate =
                      DateFormat('dd/MM/yyyy').parse(dateController.text);
                  tarefas.add(
                    TarefasModel(
                      titulo: titulo,
                      descricao: descricao,
                      status: selectedStatus,
                      data: parsedDate,
                    ),
                  );
                  atualizaLista(tarefas);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  static void atualizarStatusTarefa(
    BuildContext context,
    List<TarefasModel> tarefas,
    int index,
    String novoStatus,
    Function(List<TarefasModel>) atualizaLista,
  ) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Alterar Status'),
            content: const Column(mainAxisSize: MainAxisSize.min, children: [
              Text("Deseja alterar o status da tarefa?"),
            ]),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  tarefas[index].status = novoStatus;
                  atualizaLista(tarefas);
                  Navigator.of(context).pop();
                },
                child: const Text('Completar'),
              ),
            ],
          );
        });
  }

  static void removeTarefa(
    BuildContext context,
    List<TarefasModel> tarefas,
    int index,
    Function(List<TarefasModel>) atualizaLista,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remover Tarefa'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Deseja remover a tarefa?"),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                tarefas.removeAt(index);
                atualizaLista(tarefas);
                Navigator.of(context).pop();
              },
              child: const Text('Remover'),
            ),
          ],
        );
      },
    );
  }
}
