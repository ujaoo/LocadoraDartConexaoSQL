import '../model/Cliente.dart';
import 'package:mysql1/mysql1.dart';

import 'dart:io';

class ClienteDAO {
  final settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: 'Teste123@',
    db: 'teste_dart',
  );

  List<Cliente> clientes = [];
  int relatorio = 0;

  cadastrarCliente() async {
    try {
      final conn = await MySqlConnection.connect(settings);
      print('Conexão estabelecida com sucesso.');

      print("Digite o nome do cliente:");
      String nome = stdin.readLineSync()!;

      print("Digite o endereço do cliente:");
      String endereco = stdin.readLineSync()!;

      print("Digite o email do cliente:");
      String email = stdin.readLineSync()!;

      print("Digite a idade do cliente:");
      int idade = int.parse(stdin.readLineSync()!);

      await conn.query(
          'INSERT INTO usuarios (nome, endereco, idade, email) VALUES ("$nome", "$endereco", $idade, "$email")');

      print('Novo usuário inserido com sucesso.');

      await conn.close();
      print('Conexão fechada.');
    } catch (e) {
      print('Erro: $e');
    }
  }

  listarTodos() async {
    final conn = await MySqlConnection.connect(settings);

    try {
      final results = await conn.query('SELECT * FROM usuarios');
      print('Resultado da consulta: $results');
    } catch (e) {
      print('Erro ao executar a consulta: $e');
    }

    print('Conectado ao banco de dados.');
    final results = await conn.query('SELECT * FROM usuarios');

    if (results.isNotEmpty) {
      for (var row in results) {
        print(
            'ID: ${row['id']}   | Nome: ${row['nome']}, Endereço: ${row['endereco']}, Idade: ${row['idade']}, Email: ${row['email']}');
        print(
            "-----------------------------------------------------------------------------------");
      }
    } else {
      print('Nenhum usuário encontrado.');
    }

    print("<  |  Qualquer botão para avançar");
    String continuar = stdin.readLineSync()!;
  }

  Future<void> alterarCliente() async {
    final conn = await MySqlConnection.connect(settings);

    print("Digite o ID do cliente que deseja alterar:");
    int idCliente = int.parse(stdin.readLineSync()!);

    print("Digite o novo nome do cliente:");
    String novoNome = stdin.readLineSync()!;

    print("Digite o novo endereço do cliente:");
    String novoEndereco = stdin.readLineSync()!;

    print("Digite o novo email do cliente:");
    String novoEmail = stdin.readLineSync()!;

    print("Digite a nova idade do cliente:");
    int novaIdade = int.parse(stdin.readLineSync()!);

    await conn.query(
        "UPDATE usuarios SET nome = '$novoNome', endereco = '$novoEndereco', idade = '$novaIdade', email = '$novoEmail' WHERE id = $idCliente");

    print("Cadastro do cliente alterado com sucesso!");
    sleep(Duration(seconds: 2));
  }

  Future<void> procurarClientePorNome() async {
    final conn = await MySqlConnection.connect(settings);

    print("Digite o nome que está procurando:");
    String nome = stdin.readLineSync()!;
  String likePattern = '%$nome%';

  try {
    var queryDirect = 'SELECT * FROM usuarios WHERE nome LIKE "%$nome%"';
    final resultsDirect = await conn.query(queryDirect);
    
    if (resultsDirect.isNotEmpty) {
      print('Resultados da consulta direta encontrados:');
      print("----------------------------------------------------------");
      for (var row in resultsDirect) {
        print('ID: ${row['id']} | Nome: ${row['nome']} | Endereço: ${row['endereco']} | Idade: ${row['idade']} | Email: ${row['email']}');
        print("----------------------------------------------------------");
      }
    } else {
      print('Nenhum usuário encontrado com a consulta direta.');
    }
    
    var queryParam = 'SELECT * FROM usuarios WHERE nome LIKE ?';
    final resultsParam = await conn.query(queryParam, [likePattern]);
    
    if (resultsParam.isNotEmpty) {
      print('Resultados da consulta com parâmetro encontrados:');
      print("----------------------------------------------------------");
      for (var row in resultsParam) {
        print('ID: ${row['id']} | Nome: ${row['nome']} | Endereço: ${row['endereco']} | Idade: ${row['idade']} | Email: ${row['email']}');
        print("----------------------------------------------------------");
      }
    } else {
      print('Nenhum usuário encontrado com a consulta com parâmetro.');
    }
  } catch (e) {
    print('Erro ao executar a consulta: $e');
  } finally {
    await conn.close();
  }
    print("<  |  Qualquer botão para avançar");
    String decisao = stdin.readLineSync()!;
    print("Redirecionando.");
  }

  Future<void> deletarCliente() async {
    final conn = await MySqlConnection.connect(settings);
    listarTodos();

    print("Digite o ID do cliente que deseja deletar:");
    int idCliente = int.parse(stdin.readLineSync()!);

    await conn.query('DELETE FROM usuarios WHERE id =  $idCliente');
    print('Usuário com o ID foi excluído com sucesso.');
  }

  void qtdRelatorio() {
    ++relatorio;
  }

  void imprimirRelatorioCliente() {
    qtdRelatorio();
    var arquivo = new File("RelatorioDeClientes${relatorio}.txt");
    DateTime dataRelatorio = DateTime.now();
    var escrita = arquivo.openWrite(mode: FileMode.append);

    arquivo.writeAsStringSync(
        "********************************************************\n",
        mode: FileMode.append);
    arquivo.writeAsStringSync(
        "                 RELATÓRIO DE CLIENTES                  \n",
        mode: FileMode.append);
    arquivo.writeAsStringSync(
        "********************************************************\n",
        mode: FileMode.append);
    arquivo.writeAsStringSync("Relatório gerado em: ${dataRelatorio}\n",
        mode: FileMode.append);
    arquivo.writeAsStringSync("  \n", mode: FileMode.append);

    for (Cliente cliente in clientes) {
      arquivo.writeAsStringSync("ID         | ${cliente.id}\n",
          mode: FileMode.append);
      arquivo.writeAsStringSync("NOME       | ${cliente.nome}\n",
          mode: FileMode.append);
      arquivo.writeAsStringSync("ENDEREÇO   |  ${cliente.endereco}\n",
          mode: FileMode.append);
      arquivo.writeAsStringSync("E-MAIL     |  ${cliente.email}\n",
          mode: FileMode.append);
      arquivo.writeAsStringSync("IDADE |  ${cliente.idade}\n",
          mode: FileMode.append);
      arquivo.writeAsStringSync("  \n", mode: FileMode.append);
    }
    print("Relatório de produtos foi gerado com sucesso.");
  }
}
