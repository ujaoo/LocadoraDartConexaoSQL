import 'package:mysql1/mysql1.dart';

import '../model/Produto.dart';
import '../model/Cliente.dart';
import 'dart:io';

class ProdutoDAO {
  final settings = ConnectionSettings(
    host: 'localhost',
    port: 3306,
    user: 'root',
    password: 'Teste123@',
    db: 'teste_dart',
  );

  List<Produto> produtos = [];
  int venda = 0;
  int relatorio = 0;

  cadastrarProduto() async {
    try {
      final conn = await MySqlConnection.connect(settings);
      print('Conexão estabelecida com sucesso.');

      print("Digite o nome do produto:");
      String nome = stdin.readLineSync()!;

      print("Digite a descrição do produto:");
      String descricao = stdin.readLineSync()!;

      print("Digite o preço do produto:");
      double preco = double.parse(stdin.readLineSync()!);

      print("Digite a quantidade do produto:");
      int quantidade = int.parse(stdin.readLineSync()!);

      await conn.query(
          'INSERT INTO produtos (nome, descricao, preco, quantidade) VALUES ("$nome", "$descricao", $preco, $quantidade)');

      print('Novo produto inserido com sucesso.');

      await conn.close();
      print('Conexão fechada.');
    } catch (e) {
      print('Erro: $e');
    }
  }

  listarTodos() async {
    final conn = await MySqlConnection.connect(settings);

    try {
      final results = await conn.query('SELECT * FROM produtos');
      print('Resultado da consulta: $results');
    } catch (e) {
      print('Erro ao executar a consulta: $e');
    }

    try {
      final results = await conn.query('SELECT * FROM produtos');
      if (results.isNotEmpty) {
        for (var row in results) {
          print(
              'ID: ${row['id']}   | Nome: ${row['nome']}, Descrição: ${row['descricao']}, Quantidade: ${row['quantidade']}, Preço: ${row['preco']}');
          print(
              "-----------------------------------------------------------------------------------");
        }
      } else {
        print('Nenhum produto encontrado.');
      }
    } catch (e) {
      print('Erro ao executar a consulta: $e');
    }

    print("<  |  Qualquer botão para avançar");
    String continuar = stdin.readLineSync()!;
  }

  Future<void> alterarProduto() async {
    final conn = await MySqlConnection.connect(settings);

    print("Digite o ID do produto que deseja alterar:");
    int idProduto = int.parse(stdin.readLineSync()!);

    print("Digite o novo nome do produto:");
    String novoNome = stdin.readLineSync()!;

    print("Digite a nova descrição do produto:");
    String novaDescricao = stdin.readLineSync()!;

    print("Digite a nova quantidade do produto:");
    int novaQuantidade = int.parse(stdin.readLineSync()!);

    print("Digite o novo preço do produto:");
    double novoPreco = double.parse(stdin.readLineSync()!);

    await conn.query(
        "UPDATE produtos SET nome = '$novoNome', descricao = '$novaDescricao', quantidade = $novaQuantidade, preco = $novoPreco WHERE id = $idProduto");

    print("Cadastro do produto alterado com sucesso!");
    sleep(Duration(seconds: 2));
  }

  Future<void> procurarProdutoPorNome() async {
    final conn = await MySqlConnection.connect(settings);

    print("Digite o nome do produto que está procurando:");
    String nome = stdin.readLineSync()!;
    String likePattern = '%$nome%';

    try {
      var queryDirect = 'SELECT * FROM produtos WHERE nome LIKE "%$nome%"';
      final resultsDirect = await conn.query(queryDirect);

      if (resultsDirect.isNotEmpty) {
        print('Resultados da consulta direta encontrados:');
        print("----------------------------------------------------------");
        for (var row in resultsDirect) {
          print(
              'ID: ${row['id']} | Nome: ${row['nome']} | Descrição: ${row['descricao']} | Quantidade: ${row['quantidade']} | Preço: ${row['preco']}');
          print("----------------------------------------------------------");
        }
      } else {
        print('Nenhum produto encontrado com a consulta direta.');
      }

      var queryParam = 'SELECT * FROM produtos WHERE nome LIKE ?';
      final resultsParam = await conn.query(queryParam, [likePattern]);

      if (resultsParam.isNotEmpty) {
        print('Resultados da consulta com parâmetro encontrados:');
        print("----------------------------------------------------------");
        for (var row in resultsParam) {
          print(
              'ID: ${row['id']} | Nome: ${row['nome']} | Descrição: ${row['descricao']} | Quantidade: ${row['quantidade']} | Preço: ${row['preco']}');
          print("----------------------------------------------------------");
        }
      } else {
        print('Nenhum produto encontrado com a consulta com parâmetro.');
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

  Future<void> deletarProduto() async {
    final conn = await MySqlConnection.connect(settings);

    print("Digite o ID do produto que deseja deletar:");
    int idProduto = int.parse(stdin.readLineSync()!);

    await conn.query('DELETE FROM produtos WHERE id = $idProduto');
    print('Produto com o ID $idProduto foi excluído com sucesso.');

    await conn.close();
    sleep(Duration(seconds: 2));
  }

  vendaProduto() async {
    final conn = await MySqlConnection.connect(settings);
    print("Digite o ID do produto que está saindo:");
    int idProduto = int.parse(stdin.readLineSync()!);

    print("Digite a quantidade que está saindo");
    int quantidade = int.parse(stdin.readLineSync()!);

    var result = await conn.query(
        'UPDATE produtos SET quantidade = quantidade - $quantidade WHERE id = $idProduto');
    await conn.close();
    print("Estoque atualizado com sucesso.");
    sleep(Duration(seconds: 1));
  }

  void estatisticasvenda() {
    ++venda;
  }

  void qtdRelatorio() {
    ++relatorio;
  }

  Future<void> reposicaoProduto() async {
    final conn = await MySqlConnection.connect(settings);
    print("Digite o ID do produto que está repondo:");
    int idProduto = int.parse(stdin.readLineSync()!);

    print("Digite a quantidade de reposição:");
    int quantidade = int.parse(stdin.readLineSync()!);

    var result = await conn.query(
        'UPDATE produtos SET quantidade = quantidade + $quantidade WHERE id = $idProduto');
    await conn.close();
    print("Estoque atualizado com sucesso.");
    sleep(Duration(seconds: 1));
  }

  void imprimirRelatorioProduto() {
    qtdRelatorio();
    var arquivo = new File("RelatorioDeProdutos${relatorio}.txt");
    DateTime dataRelatorio = DateTime.now();
    var escrita = arquivo.openWrite(mode: FileMode.append);

    arquivo.writeAsStringSync(
        "********************************************************\n",
        mode: FileMode.append);
    arquivo.writeAsStringSync(
        "                 RELATÓRIO DE PRODUTOS                  \n",
        mode: FileMode.append);
    arquivo.writeAsStringSync(
        "********************************************************\n",
        mode: FileMode.append);
    arquivo.writeAsStringSync("Relatório gerado em: ${dataRelatorio}\n",
        mode: FileMode.append);
    arquivo.writeAsStringSync("  \n", mode: FileMode.append);

    for (Produto produto in produtos) {
      arquivo.writeAsStringSync("ID         | ${produto.id}\n",
          mode: FileMode.append);
      arquivo.writeAsStringSync("NOME       | ${produto.nome}\n",
          mode: FileMode.append);
      arquivo.writeAsStringSync("QUANTIDADE |  ${produto.quantidade}\n",
          mode: FileMode.append);
      arquivo.writeAsStringSync("  \n", mode: FileMode.append);
    }
    print("Relatório de produtos foi gerado com sucesso.");
  }
}
