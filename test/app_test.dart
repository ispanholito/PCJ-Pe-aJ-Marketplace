import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pecaja/main.dart';
import 'package:pecaja/src/versao.dart';

void main() {
  testWidgets('busca filtra a lista e reserva atualiza o resumo', (
    tester,
  ) async {
    await tester.pumpWidget(const PecaJaApp());

    expect(find.text('Filtro de óleo'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('campo-busca')), 'pastilha');
    await tester.pump();
    expect(find.text('Filtro de óleo'), findsNothing);
    expect(find.text('Pastilha de freio dianteira'), findsOneWidget);

    await tester.tap(find.byKey(const Key('reservar-PF-1020')));
    await tester.pump();
    expect(find.text('1 itens · R\$ 129,90'), findsOneWidget);
  });

  testWidgets('mostra versão e ambiente no rodapé', (tester) async {
    await tester.pumpWidget(const PecaJaApp());
    expect(find.text(rotuloVersao()), findsOneWidget);
  });

  test('detecta o ambiente pela URL', () {
    expect(
      detectarAmbiente(
        Uri.parse(
          'https://ispanholito.github.io/PCJ-Pe-aJ-Marketplace/staging/',
        ),
      ),
      'staging',
    );
    expect(
      detectarAmbiente(
        Uri.parse('https://ispanholito.github.io/PCJ-Pe-aJ-Marketplace/'),
      ),
      'production',
    );
    expect(detectarAmbiente(Uri.parse('http://localhost:8080/')), 'local');
  });

  test('rótulo de versão', () {
    expect(
      rotuloVersao(versao: 'v1.2.0', ambiente: 'staging'),
      'Ambiente staging · versão v1.2.0',
    );
  });
}
