import 'dart:io';

import 'connection.dart';
import 'pages/DAO/ClienteDAO.dart';
import 'pages/DAO/ProdutoDAO.dart';

Future<void> main() async {
  ClienteDAO clienteDAO = ClienteDAO();
  ProdutoDAO produtoDAO = ProdutoDAO();
  int decisao = 0;

  while (decisao != 13) {
    print("      ");
    print("      Portal de Clientes ");
    print("      ");
    print("1  | Cadastro de Clientes");
    print("2  | Alteração de Cliente");
    print("3  | Procurar por Cliente");
    print("4  | Listar todos os Clientes");
    print("5  | Deletar um Cliente");

    print("      ");

    print("      Portal de Produtos ");
    print("      ");
    print("6  | Cadastro de Produto");
    print("7  | Alteração de cadastro");
    print("8  | Procurar por produto");
    print("9  | Listar todos os produtos");
    print("10 | Deletar produto do sistema");
    print("11 | Baixa em produto");
    print("12 | Renovar estoque");

    print("      ");
    print("13 | Sair do sistema");

    print("      ");
    print("Digite uma opção:");

    decisao = int.parse(stdin.readLineSync()!);

    switch (decisao) {
      case 1:
        print("      ");
        print("Opção Escolhida: Cadastrar um cliente.");
        await clienteDAO.cadastrarCliente();
        break;

      case 2:
        print("Opção Escolhida: Alteração de Cliente");
        sleep(Duration(seconds: 2));
        await clienteDAO.listarTodos();
        await clienteDAO.alterarCliente();
        break;

      case 3:
        print("Opção Escolhida: Procurar por cliente");
        await clienteDAO.procurarClientePorNome();
        break;

      case 4:
        print("      ");
        print("Opção Escolhida: Listar todos os clientes");
        await clienteDAO.listarTodos();
        break;

      case 5:
        print("Opção Escolhida: Deletar um cliente");
        await clienteDAO.listarTodos();
        await clienteDAO.deletarCliente();
        break;

      case 6:
        print("Opção Escolhida: Cadastrar produto");
        await produtoDAO.cadastrarProduto();
        break;

      case 7:
        print("Opção Escolhida: Alterar cadastro de produto");
        await produtoDAO.listarTodos();
        await produtoDAO.alterarProduto();
        break;

      case 8:
        print("Opção Escolhida: Procurar por produto");
        await produtoDAO.procurarProdutoPorNome();
        break;

      case 9:
        print("Opção Escolhida: Listar todos os produto");
        await produtoDAO.listarTodos();
        break;

      case 10:
        print("Opção Escolhida: Deletar produto do sistema");
        await produtoDAO.listarTodos();
        await produtoDAO.deletarProduto();
        break;

      case 11:
        print("Opção Escolhida: Saída de produto");
        await produtoDAO.listarTodos();

        await produtoDAO.vendaProduto();
        break;

      case 12:
        print("Opção Escolhida: Reposição de produto");
        await produtoDAO.listarTodos();

        await produtoDAO.reposicaoProduto();
        break;

      case 13:
        print("      ");
        print("Sistema finalizado com sucesso.");
        print("      ");
        break;

      default:
        print("Digite uma opção válida.");
        print("Reconectando ao sistema... por favor aguarde!");
        sleep(Duration(seconds: 3));
    }
  }
}
