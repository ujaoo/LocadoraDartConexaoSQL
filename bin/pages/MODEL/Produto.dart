class Produto {

    String _nome;
    String _genero;
    int _quantidade;
    static int _ultimoId = 0;
    int _id;

    Produto(this._nome, this._genero, this._quantidade): _id = ++_ultimoId;

    int get id => _id;

    String get nome => _nome;

    set nome(String nome) {
      _nome = nome;
    }

    String get genero => _genero;

    set genero(String genero) {
      _genero = genero;
    }

    int get quantidade => _quantidade;

    set quantidade(int quantidade) {
      _quantidade = quantidade;
    }
}