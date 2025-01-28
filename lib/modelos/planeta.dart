class Planeta {
  int? id; // ID único (pode ser nulo)
  String nome; // Nome do planeta
  double tamanho; // Tamanho em km
  double distancia; // Distância do Sol em UA
  String? apelido; // Apelido (opcional)

  // Construtor principal
  Planeta({
    this.id,
    required this.nome,
    required this.tamanho,
    required this.distancia,
    this.apelido,
  });

  // Construtor para planeta vazio
  Planeta.vazio() : nome = '', tamanho = 0.0, distancia = 0.0, apelido = '';

  // Cria Planeta a partir de um mapa
  factory Planeta.fromMap(Map<String, dynamic> map) {
    return Planeta(
      id: map['id'],
      nome: map['nome'],
      tamanho: map['tamanho'],
      distancia: map['distancia'],
      apelido: map['apelido'],
    );
  }

  // Converte Planeta para um mapa
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'tamanho': tamanho,
      'distancia': distancia,
      'apelido': apelido,
    };
  }
}
