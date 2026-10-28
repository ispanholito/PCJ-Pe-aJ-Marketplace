import 'package:flutter_test/flutter_test.dart';
import 'package:pecaja/src/catalogo.dart';

void main() {
  test('termo vazio devolve o catálogo inteiro', () {
    expect(buscarPecas(catalogoDemo, '').length, catalogoDemo.length);
  });

  test('busca ignora maiúsculas e acentos', () {
    final r = buscarPecas(catalogoDemo, 'OLEO');
    expect(r.single.codigo, 'FO-0055');
  });

  test('busca por código e por marca', () {
    expect(buscarPecas(catalogoDemo, 'cr-33').single.nome, 'Correia dentada');
    expect(buscarPecas(catalogoDemo, 'ngk').single.codigo, 'VL-7781');
  });

  test('filtro de estoque remove peças zeradas', () {
    final r = buscarPecas(catalogoDemo, '', soDisponiveis: true);
    expect(r.any((p) => !p.disponivel), isFalse);
    expect(r.length, catalogoDemo.length - 1);
  });
}
