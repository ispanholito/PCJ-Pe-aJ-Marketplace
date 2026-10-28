import 'package:flutter/material.dart';

import 'src/carrinho.dart';
import 'src/catalogo.dart';
import 'src/peca.dart';
import 'src/versao.dart';

void main() => runApp(const PecaJaApp());

class PecaJaApp extends StatelessWidget {
  const PecaJaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PeçaJá',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF1B3A5C),
        useMaterial3: true,
      ),
      home: const TelaCatalogo(),
    );
  }
}

class TelaCatalogo extends StatefulWidget {
  const TelaCatalogo({super.key, this.pecas = catalogoDemo});

  final List<Peca> pecas;

  @override
  State<TelaCatalogo> createState() => _TelaCatalogoState();
}

class _TelaCatalogoState extends State<TelaCatalogo> {
  final _carrinho = Carrinho();
  String _termo = '';
  bool _soDisponiveis = false;

  void _reservar(Peca peca) {
    try {
      setState(() => _carrinho.adicionar(peca));
      _aviso('${peca.nome} reservada');
    } on StateError {
      _aviso('Sem estoque suficiente de ${peca.nome}');
    }
  }

  void _aviso(String texto) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(texto)));
  }

  @override
  Widget build(BuildContext context) {
    final resultado = buscarPecas(
      widget.pecas,
      _termo,
      soDisponiveis: _soDisponiveis,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('PeçaJá'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Text(
                '${_carrinho.totalItens} itens · ${formatarPreco(_carrinho.totalCentavos)}',
                key: const Key('resumo-carrinho'),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              key: const Key('campo-busca'),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar por nome, código ou marca',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _termo = v),
            ),
          ),
          SwitchListTile(
            title: const Text('Só peças em estoque'),
            value: _soDisponiveis,
            onChanged: (v) => setState(() => _soDisponiveis = v),
          ),
          Expanded(
            child: resultado.isEmpty
                ? const Center(child: Text('Nenhuma peça encontrada'))
                : ListView.builder(
                    itemCount: resultado.length,
                    itemBuilder: (context, i) {
                      final p = resultado[i];
                      return ListTile(
                        title: Text(p.nome),
                        subtitle: Text('${p.marca} · ${p.codigo} · ${p.loja}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(formatarPreco(p.precoCentavos)),
                            IconButton(
                              key: Key('reservar-${p.codigo}'),
                              tooltip: 'Reservar',
                              icon: const Icon(Icons.add_shopping_cart),
                              onPressed: p.disponivel
                                  ? () => _reservar(p)
                                  : null,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Text(
              rotuloVersao(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
