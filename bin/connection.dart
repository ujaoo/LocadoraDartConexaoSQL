import 'package:mysql1/mysql1.dart';

void main() async {
  final settings = ConnectionSettings(
    host: 'localhost', // Host
    port: 3306, // Porta
    user: 'root', // Usuário
    password: 'Teste123@', // Senha
    db: 'teste_dart', // Nome do banco de dados
  );
  
 final conn = await MySqlConnection.connect(settings);

  try {
      final results = await conn.query('SELECT * FROM produtos');
      print('Resultado da consulta: $results');
    } catch (e) {
      print('Erro ao executar a consulta: $e');
    }

    try {

        int valor1 = 2;
          var result = await conn.query('UPDATE produtos SET quantidade = quantidade + $valor1 WHERE id = 1');

  print('Atualizou ${result.affectedRows} linha(s).');

  // Fechar a conexão
  await conn.close();
    } catch (e) {
        print('Erro ao executar a consulta: $e');
    }
}