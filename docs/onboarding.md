# Guia de onboarding — PeçaJá

Guia para o par de revisão (ou quem entrar no projeto) conseguir rodar o app e
revisar ou abrir um Pull Request sem precisar perguntar nada (PGC 12).

## 1. Ambiente

- Flutter SDK (stable) — `flutter --version`
- Git e uma conta GitHub com 2FA
- Na rede do laboratório use sempre a URL `https://` (a porta 22 do SSH costuma estar bloqueada)

```bash
git clone https://github.com/ispanholito/PCJ-Pe-aJ-Marketplace.git
cd PCJ-Pe-aJ-Marketplace
flutter pub get --enforce-lockfile
flutter test
flutter run -d chrome
```

Sem Flutter instalado? A revisão pode ser feita toda pelo site do GitHub: o
pipeline (Aula 2) roda os testes nos servidores do GitHub.

## 2. Revisando um Pull Request

1. Aceite o convite de colaborador (e-mail ou `github.com/notifications`).
2. No PR, leia **Contexto / Decisão tomada / Como testar**.
3. Aba **Files changed** → comente nas linhas e explique o porquê.
4. **Review changes** → *Approve* ou *Request changes*.
5. Se o autor enviar novos commits, a aprovação anterior cai e é preciso revisar de novo.

## 3. Abrindo um Pull Request

```bash
git switch main && git pull
git switch -c feature/12-busca-por-codigo
# ... código + testes ...
git commit -m "feat(catalogo): busca por código original"
git push -u origin feature/12-busca-por-codigo
```

- Título do PR em Conventional Commits: ele vira o commit na `main` (squash) e
  define a próxima versão (`feat` → 0.**2**.0, `fix` → 0.1.**1**).
- Preencha o template e marque `Closes #<issue>`.

## 4. Não faça

- Push direto na `main`: é recusado pela proteção da branch.
- Commitar `.env`, chaves ou senhas: use GitHub Secrets.
- Atualizar dependências fora de PR: o `pubspec.lock` é item de configuração.
