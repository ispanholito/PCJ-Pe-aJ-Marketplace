import 'peca.dart';

/// Reserva de peças para retirada na loja.
class Carrinho {
  final Map<String, int> _quantidades = {};
  final Map<String, Peca> _pecas = {};

  /// Adiciona [quantidade] unidades. Lança [StateError] se passar do estoque.
  void adicionar(Peca peca, {int quantidade = 1}) {
    if (quantidade <= 0) {
      throw ArgumentError.value(quantidade, 'quantidade', 'deve ser positiva');
    }
    final atual = _quantidades[peca.codigo] ?? 0;
    if (atual + quantidade > peca.estoque) {
      throw StateError('Estoque insuficiente para ${peca.codigo}');
    }
    _pecas[peca.codigo] = peca;
    _quantidades[peca.codigo] = atual + quantidade;
  }

  void remover(String codigo) {
    _quantidades.remove(codigo);
    _pecas.remove(codigo);
  }

  int quantidadeDe(String codigo) => _quantidades[codigo] ?? 0;

  int get totalItens => _quantidades.values.fold(0, (a, b) => a + b);

  int get totalCentavos => _quantidades.entries
      .map((e) => _pecas[e.key]!.precoCentavos * e.value)
      .fold(0, (a, b) => a + b);

  /// Lojas envolvidas na reserva (cada uma gera uma retirada).
  Set<String> get lojas => _pecas.values.map((p) => p.loja).toSet();

  bool get vazio => _quantidades.isEmpty;
}
