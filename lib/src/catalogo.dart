import 'peca.dart';

/// Catálogo de demonstração. Na v0 os dados são locais; o backend entra por
/// ADR quando for definido (PGC 7).
const catalogoDemo = <Peca>[
  Peca(
    codigo: 'PF-1020',
    nome: 'Pastilha de freio dianteira',
    marca: 'Cobreq',
    loja: 'Auto Peças Boa Vista',
    precoCentavos: 12990,
    estoque: 8,
  ),
  Peca(
    codigo: 'FO-0055',
    nome: 'Filtro de óleo',
    marca: 'Tecfil',
    loja: 'Distribuidora Joinville',
    precoCentavos: 2450,
    estoque: 30,
  ),
  Peca(
    codigo: 'VL-7781',
    nome: 'Vela de ignição (jogo com 4)',
    marca: 'NGK',
    loja: 'Auto Peças Boa Vista',
    precoCentavos: 15600,
    estoque: 0,
  ),
  Peca(
    codigo: 'CR-3300',
    nome: 'Correia dentada',
    marca: 'Gates',
    loja: 'Center Peças Itaum',
    precoCentavos: 18900,
    estoque: 3,
  ),
  Peca(
    codigo: 'AM-2210',
    nome: 'Amortecedor traseiro',
    marca: 'Monroe',
    loja: 'Center Peças Itaum',
    precoCentavos: 34500,
    estoque: 2,
  ),
];

/// Busca por nome, código ou marca, sem diferenciar maiúsculas e acentos.
List<Peca> buscarPecas(
  List<Peca> pecas,
  String termo, {
  bool soDisponiveis = false,
}) {
  final t = _normalizar(termo.trim());
  return pecas.where((p) {
    if (soDisponiveis && !p.disponivel) return false;
    if (t.isEmpty) return true;
    return _normalizar(p.nome).contains(t) ||
        _normalizar(p.codigo).contains(t) ||
        _normalizar(p.marca).contains(t);
  }).toList();
}

String _normalizar(String s) {
  const de = 'áàâãäéèêëíìîïóòôõöúùûüç';
  const para = 'aaaaaeeeeiiiiooooouuuuc';
  final lower = s.toLowerCase();
  final buffer = StringBuffer();
  for (final ch in lower.split('')) {
    final i = de.indexOf(ch);
    buffer.write(i >= 0 ? para[i] : ch);
  }
  return buffer.toString();
}
