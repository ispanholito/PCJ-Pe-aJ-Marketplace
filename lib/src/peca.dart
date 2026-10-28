/// Uma autopeça anunciada por uma loja.
class Peca {
  const Peca({
    required this.codigo,
    required this.nome,
    required this.marca,
    required this.loja,
    required this.precoCentavos,
    required this.estoque,
  });

  /// Código original (OEM) ou código da loja.
  final String codigo;
  final String nome;
  final String marca;
  final String loja;

  /// Preço em centavos, para evitar erro de arredondamento com double.
  final int precoCentavos;
  final int estoque;

  bool get disponivel => estoque > 0;
}

/// Formata centavos como moeda brasileira: 12990 -> "R$ 129,90".
String formatarPreco(int centavos) {
  final reais = centavos ~/ 100;
  final resto = (centavos % 100).toString().padLeft(2, '0');
  final milhar = reais.toString().replaceAllMapped(
    RegExp(r'(\d)(?=(\d{3})+$)'),
    (m) => '${m[1]}.',
  );
  return 'R\$ $milhar,$resto';
}
