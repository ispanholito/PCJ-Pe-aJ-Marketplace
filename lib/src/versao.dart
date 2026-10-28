/// Versão e ambiente exibidos no rodapé (PGC 10.1).
///
/// A versão é injetada no build pelo pipeline (--dart-define=APP_VERSION=...).
/// O ambiente é detectado pela URL, para que o MESMO artefato validado em
/// staging seja promovido a produção sem recompilar (PGC 6, ADR 0001).
const versaoApp = String.fromEnvironment('APP_VERSION', defaultValue: 'dev');

String detectarAmbiente(Uri url) {
  if (url.path.contains('/staging/')) return 'staging';
  if (url.host.endsWith('github.io')) return 'production';
  return 'local';
}

String rotuloVersao({String versao = versaoApp, String? ambiente}) =>
    'Ambiente ${ambiente ?? detectarAmbiente(Uri.base)} · versão $versao';
