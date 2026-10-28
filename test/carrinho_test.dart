import 'package:flutter_test/flutter_test.dart';
import 'package:pecaja/src/carrinho.dart';
import 'package:pecaja/src/catalogo.dart';

void main() {
  final pastilha = catalogoDemo[0]; // R$ 129,90, estoque 8
  final filtro = catalogoDemo[1]; // R$ 24,50, estoque 30
  final amortecedor = catalogoDemo[4]; // estoque 2

  test('soma itens e total', () {
    final c = Carrinho()
      ..adicionar(pastilha, quantidade: 2)
      ..adicionar(filtro);
    expect(c.totalItens, 3);
    expect(c.totalCentavos, 2 * 12990 + 2450);
    expect(c.lojas.length, 2);
  });

  test('não passa do estoque', () {
    final c = Carrinho()..adicionar(amortecedor, quantidade: 2);
    expect(() => c.adicionar(amortecedor), throwsStateError);
    expect(c.quantidadeDe(amortecedor.codigo), 2);
  });

  test('quantidade inválida', () {
    expect(
      () => Carrinho().adicionar(filtro, quantidade: 0),
      throwsArgumentError,
    );
  });

  test('remover esvazia o carrinho', () {
    final c = Carrinho()..adicionar(filtro);
    c.remover(filtro.codigo);
    expect(c.vazio, isTrue);
    expect(c.totalCentavos, 0);
  });
}
