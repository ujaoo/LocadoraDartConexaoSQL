class Cliente {
  
  String _nome;
  String _endereco;
  String _email;
  int _idade;
  static int _ultimoId = 0;
  int _id;

  Cliente(this._nome, this._endereco, this._email, this._idade) : _id = ++_ultimoId;

  int get id => _id;

  String get nome => _nome;

  set nome(String nome) {
    _nome = nome;
  }

  String get endereco => _endereco;

  set endereco(String endereco) {
    _endereco = endereco;
  }

  String get email => _email;

  set email(String email) {
    _email = email;
  }

  int get idade => _idade;

  set idade(int idade) {
    _idade = idade;
  }
}

void main() {
  Cliente cliente1 = Cliente("João", "Rua A", "joao@unidep.com", 30);
  Cliente cliente2 = Cliente("Maria", "Rua B", "maria@unidep.com", 25);
  Cliente cliente3 = Cliente("Carlos", "Rua C", "carlos@unidep.com", 35);


  print("********************************************************");
  print("                   TESTE DE CLASSE                      ");
  print("********************************************************");
  print("      ");

  print("Cliente 1 | ID: ${cliente1.id} | Nome:  ${cliente1.nome}");
  print("Cliente 2 | ID: ${cliente2.id} | Nome:  ${cliente2.nome}");
  print("Cliente 3 | ID: ${cliente3.id} | Nome:  ${cliente3.nome}");

  print("      ");

}
