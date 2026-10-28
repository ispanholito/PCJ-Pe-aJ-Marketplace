import 'package:flutter_test/flutter_test.dart';
import 'package:pecaja/src/peca.dart';

void main() {
  group('formatarPreco', () {
    test('formata centavos', () => expect(formatarPreco(12990), 'R\$ 129,90'));
    test('completa com zero', () => expect(formatarPreco(205), 'R\$ 2,05'));
    test(
      'separa milhar',
      () => expect(formatarPreco(1234500), 'R\$ 12.345,00'),
    );
  });

  test('peça sem estoque não está disponível', () {
    const p = Peca(
      codigo: 'X',
      nome: 'Teste',
      marca: 'M',
      loja: 'L',
      precoCentavos: 100,
      estoque: 0,
    );
    expect(p.disponivel, isFalse);
  });
}
