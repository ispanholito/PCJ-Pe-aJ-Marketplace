# 0001 — GitHub Pages para staging e produção da web

- Status: aceito
- Data: 28/10/2026

## Contexto

O PeçaJá é um projeto individual, sem orçamento. Criar e conectar contas em
serviços externos (Vercel, Netlify, Firebase Hosting) adiciona tokens para
gerenciar e depende de domínios que a rede do laboratório pode bloquear.

## Decisão

Publicar a versão web (Flutter Web) no **GitHub Pages**, branch `gh-pages`:

- staging em `/PCJ-Pe-aJ-Marketplace/staging/`
- produção em `/PCJ-Pe-aJ-Marketplace/`

O build troca a tag `<base href="/">` por `<base href="./">` (o Flutter não aceita
`--base-href ./`), então **o mesmo artefato** validado em staging é promovido
para produção sem recompilar (PGC 6). O ambiente exibido no app é detectado
pela URL (`lib/src/versao.dart`).

## Alternativas consideradas

- **Firebase Hosting:** tem canais de preview, mas exige conta e token de serviço.
- **actions/deploy-pages:** publica um site inteiro por vez, o que impede staging
  e produção de conviverem no mesmo repositório.

## Consequências

- Só GitHub, nenhuma conta extra.
- O repositório precisa ser **público** (Pages e aprovação em Environments são
  gratuitos só para repositórios públicos no plano Free).
