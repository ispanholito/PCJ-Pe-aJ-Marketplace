# PeçaJá Marketplace (PCJ)

App para **encontrar e reservar autopeças** nas lojas da região de Joinville:
o cliente ou a oficina busca a peça por nome, código original ou marca, vê preço,
loja e estoque, e reserva para retirada.

Projeto da disciplina **Gerenciamento, Configuração e Processos de Software**
(Engenharia de Software, 4º semestre, Católica SC). Ele implementa o
[Plano de Gerenciamento de Configuração — Enfoque DevOps](docs/PGC-PecaJa.md),
que é item de configuração deste repositório.

| Pasta | Conteúdo |
|---|---|
| `lib/` | App Flutter (`main.dart`) e regras de negócio (`src/`: peça, catálogo, carrinho, versão) |
| `test/` | Testes unitários e de widget |
| `web/` | Alvo Flutter Web (publicado no GitHub Pages) |
| `docs/` | [PGC](docs/PGC-PecaJa.md), [onboarding](docs/onboarding.md), [ADRs](docs/adr/), [evidências](docs/evidencias/) |
| `.github/` | Templates de PR e Issue, CODEOWNERS, Dependabot e, a partir da Aula 2, workflows |

**Stack:** Flutter (stable) / Dart 3 · Material 3 · `flutter_test` · GitHub Actions · GitHub Pages.

## Como instalar e rodar

Pré-requisitos: [Flutter SDK](https://docs.flutter.dev/get-started/install) (canal stable) e Git.

```bash
git clone https://github.com/ispanholito/PCJ-Pe-aJ-Marketplace.git
cd PCJ-Pe-aJ-Marketplace
flutter pub get --enforce-lockfile   # usa as versões travadas no pubspec.lock
flutter run -d chrome                # app no navegador
```

Variáveis de ambiente: copie `.env.example` para `.env` (o `.env` nunca é versionado).
Sem elas, o app usa o catálogo de demonstração.

## Como rodar os testes

```bash
flutter analyze                      # análise estática
dart format --set-exit-if-changed .  # padrão de formatação
flutter test --coverage              # testes + cobertura (coverage/lcov.info)
```

## Fluxo de trabalho (PGC 3.3, 5.2 e 8.1)

1. Abra uma Issue (template *Funcionalidade* ou *Defeito*).
2. Crie a branch `feature/<issue>-<descricao-curta>` a partir da `main`.
3. Abra um Pull Request com título em Conventional Commits (`feat(carrinho): ...`).
4. O **par de revisão** aprova; o merge é por **squash**.

A `main` é protegida: push direto é recusado, todo PR precisa de 1 aprovação de
outra pessoa e o histórico é linear.

## Ambientes

| Ambiente | URL | Promoção |
|---|---|---|
| Revisão de PR | artefato `web-pr-<n>` na aba Actions | a cada push no PR (Aula 2) |
| Staging | `https://ispanholito.github.io/PCJ-Pe-aJ-Marketplace/staging/` | merge na main (Aula 3) |
| Produção | `https://ispanholito.github.io/PCJ-Pe-aJ-Marketplace/` | aprovação de `@ispanholito` no Environment `production` |

## Equipe

- **Ruan Pablo Amaral** (`@ispanholito`): desenvolvedor, PO e responsável de GCS/DevOps
- **Par de revisão**: colega da disciplina, colaborador com permissão *Write*
- Prazo de resposta a Pull Requests: até 3 dias úteis
