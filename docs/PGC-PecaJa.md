# PCJ — PeçaJá Marketplace

## PLANO DE GERENCIAMENTO DE CONFIGURAÇÃO

### Enfoque DevOps — Integração e Entrega Contínuas (CI/CD)

**Versão 1.1**

| Campo | Descrição |
|---|---|
| Projeto | PCJ — PeçaJá Marketplace: app mobile e web para encontrar e reservar autopeças em lojas da região de Joinville (nome ilustrativo) |
| Gerente de Projeto / Product Owner | Ruan Pablo Amaral (`@ispanholito`) |
| Gerente/Responsável de GCS-DevOps | Ruan Pablo Amaral (`@ispanholito`) |
| Fábrica de Software / Squad | Desenvolvedor individual + 1 par de revisão (colega da disciplina, com acesso de escrita) |
| Repositório principal | https://github.com/ispanholito/PCJ-Pe-aJ-Marketplace (GitHub, plano gratuito, público) |
| Disciplina | Gerenciamento, Configuração e Processos de Software — Engenharia de Software, 4º semestre, Católica SC |

## Histórico de Revisões

| Data | Versão | Descrição | Autor |
|---|---|---|---|
| 23/09/2026 | 1.0 | Criação do repositório e primeira versão do plano. | Ruan Pablo Amaral |
| 28/10/2026 | 1.1 | Plano revisado e completado a partir do template DevOps e da referência ONGConecta; publicado no repositório como item de configuração; aplicação da Aula 1 (estrutura, par de revisão, ambientes e proteção da `main`). | Ruan Pablo Amaral |

## Sumário

1. Introdução
2. Cultura DevOps e Papéis na Gerência de Configuração
3. Ferramentas, Ambientes e Infraestrutura
4. Identificação da Configuração
5. Integração Contínua (CI)
6. Entrega e Implantação Contínua (CD)
7. Infraestrutura como Código (IaC)
8. Controle de Configuração e Mudança
9. Baselines e Releases
10. Estimativa do Status de Configuração
11. Marcos
12. Treinamento e Recursos
13. Controle de Software de Subcontratados, Fornecedores e Dependências de Terceiros
14. Quadro-Resumo do Pipeline CI/CD

---

## 1. Introdução

Este Plano de Gerenciamento de Configuração (PGC) descreve as atividades de Gestão de Configuração de Software (GCS) do PeçaJá ao longo do seu ciclo de vida, com ênfase em práticas DevOps: Integração Contínua (CI), Entrega Contínua (CD) e automação de pipelines, usando apenas ferramentas gratuitas.

O plano parte de três restrições concretas:

1. **Equipe de uma pessoa.** Um único desenvolvedor acumula todos os papéis. A revisão por outra pessoa vem do **par de revisão**, um colega da disciplina adicionado como colaborador.
2. **Dedicação parcial.** O projeto é desenvolvido junto com o trabalho e as demais disciplinas, em blocos curtos de tempo.
3. **Custo zero.** Sem orçamento para infraestrutura; tudo roda no GitHub (Actions, Pages, Environments, Dependabot).

Essas restrições levaram a simplificações deliberadas em relação ao template: papéis consolidados, PaaS gratuito (GitHub Pages) no lugar de Kubernetes/Terraform e CCM reduzido.

### 1.1 Finalidade

Estabelecer um padrão simples e sustentável que garanta rastreabilidade, versionamento e controle de mudanças do app PeçaJá, apoiado por pipelines automatizados de build, teste, integração e implantação. O objetivo também é que nenhuma mudança chegue à `main` sem ser vista por uma segunda pessoa, mesmo num projeto individual.

### 1.2 Escopo

Este PGC se aplica a todo o repositório do PeçaJá e às pessoas que trabalham nele:

- **Ruan Pablo Amaral**: desenvolvedor, Product Owner, responsável de GCS/DevOps e aprovador de produção;
- **Par de revisão**: colega da disciplina com permissão *Write*, que revisa e aprova os Pull Requests.

O produto é um único app **Flutter**, com uma base de código e dois alvos:

- **Web** (Flutter Web), publicada no GitHub Pages em `staging` e `production`;
- **Android** (APK/AAB), gerado como artefato do pipeline e, futuramente, publicado no canal de teste interno da Google Play.

Estão incluídos: código-fonte, testes, configuração de build, pipelines, documentação (este PGC, ADRs, onboarding) e metadados de publicação.

### 1.3 Definições, Acrônimos e Abreviações

| Termo | Significado |
|---|---|
| GCS | Gestão de Configuração de Software |
| PGC | Plano de Gerenciamento de Configuração (este documento) |
| CI | Integração Contínua (Continuous Integration) |
| CD | Entrega/Implantação Contínua (Continuous Delivery / Deployment) |
| IaC | Infraestrutura como Código |
| CCM | Comitê de Controle de Mudanças (aqui: desenvolvedor + par de revisão) |
| IC | Item de Configuração |
| Baseline | Conjunto de ICs que atingiram um estado comprovado de estabilidade |
| Pipeline | Sequência automatizada de build, teste, análise e implantação |
| GitHub Flow | Branching com `main` sempre implantável e branches de feature curtas |
| SemVer | Versionamento Semântico (MAJOR.MINOR.PATCH) |
| Par de revisão | Colega com acesso de escrita que aprova os PRs (o GitHub não permite aprovar o próprio PR) |
| APK/AAB | Formatos de pacote Android |
| DORA Metrics | Lead Time, Deployment Frequency, MTTR e Change Failure Rate |

### 1.4 Referências

- Documento base: Processos de Desenvolvimento de Software e a Integração com GCS.
- Template do Plano de Gerenciamento de Configuração — Enfoque DevOps (Prof. Luiz Camargo, RUP 7.0 adaptado).
- PGC de referência e repositório ONGConecta: https://github.com/lzcamargo/ongconecta (Aula 1 — Preparar o repositório do seu projeto).
- Documentação oficial: GitHub Actions, GitHub Environments, Flutter (`flutter test`, `flutter build web`, `flutter build apk`).
- Decisões do projeto: `docs/adr/`.

### 1.5 Visão Geral

A GCS é parte do fluxo diário de trabalho, e não uma atividade manual concentrada em marcos. Cada Pull Request revisado, testado e implantado gera evidência de rastreabilidade: issue → branch → PR com revisão → logs do pipeline → tag SemVer → Release. Num projeto individual isso tem duas vantagens: o histórico substitui a memória de quem codificou, e o par de revisão consegue entender cada mudança sem reunião.

## 2. Cultura DevOps e Papéis na Gerência de Configuração

Com uma pessoa só, os papéis do template foram consolidados. A única separação mantida de propósito é a de **quem escreve** e **quem aprova** a entrada na `main`.

| Papel (template) | Quem exerce | Responsabilidades |
|---|---|---|
| Gerente de Projeto / Product Owner | Ruan Pablo Amaral | Mantém o backlog (GitHub Issues/Projects), define o que entra em cada release e acompanha as métricas. |
| Engenheiro DevOps / Release Engineer | Ruan Pablo Amaral | Mantém pipelines, branching, versionamento, Environments e publicação. Aprova o deploy em `production`. |
| Desenvolvedor(a) | Ruan Pablo Amaral | Implementa funcionalidades com testes automatizados e abre PRs pequenos. |
| Revisor (par de revisão) | Colega da disciplina (permissão *Write*) | Revisa e aprova os PRs ("quatro olhos"). Pede mudanças quando o PR não segue este plano. |
| SRE / Operações | Ruan Pablo Amaral | Acompanha o site publicado e os alertas; executa rollback quando necessário. |
| QA / Automação de Testes | Ruan Pablo Amaral | Mantém a suíte de testes que roda no pipeline; não há QA manual dedicado. |
| Segurança (DevSecOps) | Ruan Pablo Amaral | Revisa alertas do Dependabot e do *secret scanning*; garante que nenhum segredo vá para o código. |
| CCM | Ruan Pablo Amaral + par de revisão | Atua só em mudanças de alto risco (seção 8.2). |

### 2.1 Comunicação

- Toda discussão técnica fica registrada no próprio GitHub (Issue e PR), para que o par não dependa de reunião.
- O PR segue o template (Contexto / Decisão tomada / Como testar).
- Prazo combinado de resposta a um PR: **até 3 dias úteis**.

## 3. Ferramentas, Ambientes e Infraestrutura

### 3.1 Ferramentas do Pipeline

| Categoria | Ferramenta adotada | Finalidade |
|---|---|---|
| Controle de versão | Git + GitHub (plano gratuito, repositório público) | Versiona código, pipelines e documentação |
| Orquestração de CI/CD | GitHub Actions | Build, lint, testes, empacotamento e deploy |
| Framework / build | Flutter (stable) + Dart; `flutter analyze`, `flutter test`, `flutter build web/apk` | Um código para web e Android |
| Hospedagem web (PaaS) | GitHub Pages (branch `gh-pages`) | Staging em `/staging/` e produção na raiz, sem conta externa (ADR 0001) |
| Distribuição Android | Artefato do GitHub Actions (APK); Google Play *Internal testing* quando houver conta | Pacote de teste a cada versão |
| Gestão de segredos | GitHub Secrets e Environments | Credenciais fora do código |
| Ambientes de deploy | GitHub Environments `staging` e `production` | Controle de promoção e aprovação |
| Dependências / SCA | Dependabot (`pub` e `github-actions`) + `pubspec.lock` versionado | Vulnerabilidades e atualizações por PR |
| Rastreamento de tarefas | GitHub Issues + GitHub Projects | Liga issue → branch → PR → release |
| Monitoramento | UptimeRobot (free) no site de produção; logs do Actions | Disponibilidade e histórico de deploy |

### 3.2 Ambientes e Infraestrutura

| Ambiente | Finalidade | Gatilho de promoção | Configuração no GitHub |
|---|---|---|---|
| Desenvolvimento / Revisão de PR | Build e testes de cada PR; artefato web do PR para conferência | Abertura ou atualização de PR | — |
| Homologação / Staging | Validação funcional da web publicada e do APK de teste | Merge na `main` (automático) | Environment `staging`: *Deployment branches* = **Protected branches only** |
| Produção | Versão usada pelo público | **Aprovação manual** de `@ispanholito` após validar em staging | Environment `production`: *Required reviewers* = `@ispanholito`, *Prevent self-review* desmarcado, **Protected branches only** |

URLs previstas:

- Staging: `https://ispanholito.github.io/PCJ-Pe-aJ-Marketplace/staging/`
- Produção: `https://ispanholito.github.io/PCJ-Pe-aJ-Marketplace/`

*Prevent self-review* fica desmarcado porque o próprio desenvolvedor dispara e aprova o deploy de produção. A separação de funções no código já é garantida pela revisão do par no PR (ADR 0002).

### 3.3 Estratégia de Branching e Versionamento

Adota-se **GitHub Flow**:

- `main`: sempre implantável. Protegida: PR obrigatório, 1 aprovação de outra pessoa, aprovações antigas descartadas a cada novo commit, histórico linear e **nenhuma exceção, nem para o administrador**. Push direto é recusado.
- `feature/<issue>-<descricao-curta>`: uma branch por funcionalidade ou correção, de vida curta (idealmente até 2 dias).
- `hotfix/<descricao>`: correção urgente, com o mesmo fluxo de PR; o CCM é avisado.
- `release/x.y`: opcional, só para estabilizar uma versão antes de enviar à loja.

**Merge somente por squash**, com o **título do PR** como mensagem do commit. Assim cada PR vira um commit na `main` em Conventional Commits, e o pipeline calcula a próxima versão a partir dele.

**Versionamento:** SemVer (`vMAJOR.MINOR.PATCH`) e Conventional Commits (`feat`, `fix`, `docs`, `chore`, `refactor`, `test`, `ci`). `feat` sobe MINOR, `fix` sobe PATCH, `!`/`BREAKING CHANGE` sobe MAJOR. No Android, `versionName` = versão SemVer e `versionCode` = número do build, ambos vindos do `pubspec.yaml` (`version: X.Y.Z+build`).

## 4. Identificação da Configuração

### 4.1 Itens de Configuração

São itens de configuração formais, versionados neste repositório:

| IC | Localização |
|---|---|
| Este PGC | `docs/PGC-PecaJa.md` |
| Código-fonte do app | `lib/` |
| Testes automatizados | `test/` |
| Manifesto e lockfile de dependências | `pubspec.yaml`, `pubspec.lock` |
| Regras de análise estática | `analysis_options.yaml` |
| Configuração do alvo web | `web/` |
| Pipelines como código | `.github/workflows/` (a partir da Aula 2) |
| Modelos de colaboração | `.github/pull_request_template.md`, `.github/ISSUE_TEMPLATE/`, `.github/CODEOWNERS` |
| Política de dependências | `.github/dependabot.yml` |
| Variáveis de ambiente (só nomes) | `.env.example` (os valores reais nunca são versionados) |
| Regras de versionamento | `.gitignore`, `.gitattributes` |
| Documentação | `README.md`, `docs/onboarding.md`, `docs/adr/` |
| Evidências de GCS | `docs/evidencias/` |

**Segredos:** nenhum segredo vai para o repositório. Se algum for commitado por engano, ele é considerado vazado: a credencial é trocada na origem e passa a viver no GitHub Secrets.

### 4.2 Convenção de Nomenclatura

| Item | Convenção | Exemplo |
|---|---|---|
| Issue | Título em Conventional Commits | `feat: busca de peças por código original` |
| Branch de feature | `feature/<issue>-<descricao-curta>` | `feature/12-busca-por-codigo` |
| Branch de correção | `hotfix/<descricao>` | `hotfix/preco-zerado-no-carrinho` |
| Commit / título de PR | `<tipo>(<escopo>): <descrição>` | `feat(carrinho): calcula total com quantidade` |
| Tag de release | `vX.Y.Z` | `v0.2.0` |
| Build Android | `android-<versão>-<build>` | `android-0.2.0-7` |
| Artefato web do PR | `web-pr-<número>` | `web-pr-15` |
| ADR | `docs/adr/NNNN-titulo-curto.md` | `0001-github-pages-para-staging-e-producao.md` |

Escopos válidos: `catalogo`, `carrinho`, `ui`, `web`, `android`, `ci`, `docs`, `deps`.

### 4.3 Estrutura do Repositório

```
PCJ-Pe-aJ-Marketplace/
├── .github/
│   ├── ISSUE_TEMPLATE/      # funcionalidade, defeito, mudança de alto risco
│   ├── workflows/           # ci.yml, cd.yml (Aulas 2 e 3)
│   ├── CODEOWNERS
│   ├── dependabot.yml
│   └── pull_request_template.md
├── docs/
│   ├── adr/                 # decisões de arquitetura
│   ├── evidencias/          # prints e registros de GCS
│   ├── onboarding.md
│   └── PGC-PecaJa.md        # este plano (IC)
├── lib/
│   ├── main.dart            # app e telas
│   └── src/                 # regras de negócio (catálogo, carrinho, versão)
├── test/                    # testes unitários e de widget
├── web/                     # alvo Flutter Web
├── .env.example
├── .gitattributes
├── .gitignore
├── analysis_options.yaml
├── pubspec.yaml
├── pubspec.lock
└── README.md
```

A pasta `android/` é gerada por `flutter create --platforms=android .` quando o pipeline mobile entrar (Aula 3). A decisão vai ser registrada em ADR.

## 5. Integração Contínua (CI)

Todo Pull Request para a `main` dispara o pipeline de CI. Nenhuma mudança é integrada sem pipeline verde.

### 5.1 Etapas do Pipeline de CI

1. Checkout e instalação do Flutter (versão fixada), com cache do `pub`.
2. `flutter pub get --enforce-lockfile`: falha se o `pubspec.lock` não estiver coerente.
3. `dart format --set-exit-if-changed`: padrão de código.
4. `flutter analyze`: análise estática (lint).
5. `flutter test --coverage`: testes unitários e de widget, com cobertura.
6. Verificação do título do PR em Conventional Commits (check `titulo-pr`).
7. `flutter build web`: artefato `web-pr-<n>` publicado no Actions para revisão (`flutter build apk` entra quando a pasta `android/` for adicionada).
8. Check agregador `ci-ok`, usado na proteção da `main`.

### 5.2 Política de Pull Request e Revisão de Código

- Todo PR exige **1 aprovação do par de revisão** antes do merge. O GitHub impede o autor de aprovar o próprio PR.
- Novos commits no PR descartam a aprovação anterior (*dismiss stale approvals*).
- PRs pequenos, de um assunto só, com o template preenchido.
- `CODEOWNERS` chama automaticamente `@ispanholito` para `.github/`, `pubspec.*` e `docs/PGC-PecaJa.md`.
- Merge somente por **squash**, com pipeline verde e conversa resolvida.

### 5.3 Critérios de Qualidade (Quality Gate)

| Critério | Limite |
|---|---|
| Testes | 100% passando |
| Cobertura de linhas | ≥ 60% no total e ≥ 80% em `lib/src/` (regras de negócio) |
| Análise estática | zero *errors* e zero *warnings* no `flutter analyze` |
| Formatação | `dart format` sem diferenças |
| Dependências | zero alertas críticos/altos abertos no Dependabot |
| Título do PR | Conventional Commits válido |

Os limites podem subir conforme a suíte de testes amadurecer. A mudança é feita por PR neste plano.

## 6. Entrega e Implantação Contínua (CD)

Após o merge, o pipeline de CD gera **um único build** da versão e promove esse mesmo artefato para staging e, com aprovação, para produção, sem recompilar.

### 6.1 Etapas do Pipeline de CD — Web

1. Cálculo da próxima versão SemVer a partir do título do commit (squash) desde a última tag.
2. `flutter build web --dart-define=APP_VERSION=vX.Y.Z` e troca da tag `<base href="/">` por `<base href="./">` no `index.html`: artefato único, com caminhos relativos. O ambiente exibido no app é detectado pela URL, não pelo build.
3. Deploy automático no Environment **staging** (`/staging/` no GitHub Pages).
4. Smoke test: requisição HTTP ao site de staging deve retornar 200 e a versão esperada.
5. **Gate de aprovação**: o job do Environment **production** espera a aprovação de `@ispanholito`.
6. Deploy do mesmo artefato na raiz do GitHub Pages, seguido de smoke test.
7. Criação da tag `vX.Y.Z` e da Release com as notas de versão.

### 6.2 Etapas do Pipeline de CD — Android

1. `flutter build apk --release` com a versão calculada.
2. Publicação do APK como artefato `android-<versão>-<build>` (canal de teste).
3. Com conta da Google Play: envio ao *Internal testing* e, após aprovação no Environment `production`, lançamento faseado.

### 6.3 Estratégias de Implantação

| Estratégia | Uso no projeto |
|---|---|
| Promoção de artefato único | O mesmo build validado em staging vai para produção. |
| Substituição atômica (web) | O GitHub Pages troca o conteúdo da pasta de uma vez; não há instâncias para rolling update. |
| Feature flags | Funções maiores (ex.: pagamento online) entram desligadas por configuração e são ligadas depois do deploy. |
| Lançamento faseado (Android) | Na Google Play, quando houver publicação na loja. |

### 6.4 Rollback e Recuperação

- **Web:** workflow manual `rollback.yml` que republica em produção o artefato de uma tag anterior. Alternativa manual: *revert* do PR por um novo PR.
- **Android:** reverter na loja exige nova revisão. Por isso, primeiro se desliga a funcionalidade por feature flag e depois se publica a correção.
- Todo rollback gera uma Issue com o label `defeito`, descrevendo causa e correção.

## 7. Infraestrutura como Código (IaC)

O projeto não tem servidores próprios: usa GitHub Pages e GitHub Actions. Por isso Terraform/Ansible não são adotados neste momento. O princípio "tudo versionado" é mantido:

- Pipelines são código (`.github/workflows/*.yml`), alterados só por PR.
- A configuração do repositório (merge por squash, proteção da `main`, Environments) está documentada neste plano (seções 3.2 e 3.3). Alterações nela passam pelo CCM e são registradas no histórico de revisões.
- Se o projeto passar a ter backend próprio (ex.: Supabase ou Render), a configuração desse serviço vai ser versionada (ex.: `supabase/migrations`, `render.yaml`) e este plano vai ser revisado.

## 8. Controle de Configuração e Mudança

### 8.1 Processo de Solicitação de Mudança

Fluxo padrão, que por si já é o registro formal da mudança:

**Issue** (template *Funcionalidade* ou *Defeito*) → **branch** `feature/<issue>-...` → **PR** (template, `Closes #n`) → **CI verde** → **aprovação do par** → **squash merge** → **CD staging** → **aprovação de produção** → **tag/Release**.

### 8.2 Comitê de Controle de Mudança (CCM)

**Composição:** Ruan Pablo Amaral (decide) e o par de revisão (opina e registra).

**Quando é acionado** (template de Issue *Mudança de alto risco*):

- alteração em dados pessoais de usuários ou lojistas (LGPD);
- mudança de esquema/estrutura de dados persistidos, quando houver backend;
- mudança nas regras de proteção da `main`, nos Environments ou nos pipelines de deploy;
- exceção ao fluxo padrão (ex.: hotfix publicado sem passar por staging);
- inclusão de dependência que exija permissões novas no app (câmera, localização, pagamento).

**Registro:** a decisão (aprovada, aprovada com ressalvas ou rejeitada) e o plano de rollback ficam na própria Issue. Mudanças de rotina seguem só a revisão do PR.

## 9. Baselines e Releases

### 9.1 Geração Automática de Baseline

Cada deploy aprovado em produção gera uma **baseline**: a tag `vX.Y.Z` no commit da `main`, a Release com o artefato web e o APK correspondentes, e o log do pipeline que os gerou.

Baselines de projeto (marcos da disciplina) também viram tags anotadas:

| Baseline | Conteúdo |
|---|---|
| `bl-aula1` | Repositório organizado, PGC publicado, `main` protegida, Environments criados |
| `bl-aula2` | Pipeline de CI ativo e exigido na proteção da `main` |
| `bl-aula3` | CD com staging, aprovação de produção, tag e rollback |
| `bl-aula4` | Governança: Dependabot, CCM e rastreabilidade em uso |

### 9.2 Notas de Versão (Release Notes)

Geradas automaticamente a partir dos Conventional Commits desde a última tag, agrupadas em *Novidades* (`feat`), *Correções* (`fix`) e *Outros*. São publicadas na Release e reaproveitadas como "novidades da versão" na loja.

## 10. Estimativa do Status de Configuração

### 10.1 Monitoramento e Observabilidade

- UptimeRobot (gratuito) verifica a URL de produção a cada 5 minutos e avisa por e-mail.
- A versão e o ambiente aparecem no rodapé do app, para que todo relato de defeito diga em que versão ocorreu.
- O histórico do GitHub Actions mostra o que foi publicado, quando e por quem foi aprovado.

### 10.2 Métricas acompanhadas

| Métrica | Como é medida | Por que |
|---|---|---|
| Deployment Frequency | Número de Releases por mês | Mostra se a entrega está contínua mesmo com dedicação parcial |
| Lead Time for Changes | Tempo entre abrir o PR e a tag em produção | Mostra se a revisão do par está travando o fluxo |
| Change Failure Rate | Releases seguidas de rollback ou hotfix / total de Releases | Principal sinal de qualidade; orienta reforço de testes |

O MTTR passa a ser medido quando houver incidentes suficientes para uma média com sentido.

### 10.3 Relatórios e Auditorias

O histórico de PRs, os logs do GitHub Actions, as tags e as Releases são a base de auditoria. Ao fim de cada aula/marco, é feita uma **auditoria rápida** contra o checklist da aula: proteção da `main`, Environments, colaboradores e ICs presentes. O resultado é registrado em `docs/evidencias/`.

## 11. Marcos

| Marco | Data prevista | Entrega |
|---|---|---|
| Plano de GCS (v1.0) | 23/09/2026 | Primeira versão do PGC e criação do repositório |
| Aula 1: repositório preparado | 28/10/2026 | PGC v1.1 publicado, estrutura, par de revisão, Environments, `main` protegida, evidência da recusa de push |
| 50% da execução do plano | 04/11/2026 | CI ativo (Aula 2) e exigido na `main` |
| Aula 3: CD | nov/2026 | Staging automático, aprovação de produção, tag/Release, rollback |
| Aula 4: governança | nov/2026 | Dependabot, CCM em uso, rastreabilidade issue → release |
| 100% da execução do plano | 09/12/2026 | Primeira release totalmente automatizada do commit à produção |

## 12. Treinamento e Recursos

| Recurso | Uso |
|---|---|
| Computador pessoal com Flutter SDK, VS Code e Git | Desenvolvimento local |
| Conta GitHub com 2FA (`@ispanholito`) | Repositório, Actions, Pages, Environments |
| Par de revisão (colega da disciplina) | Revisão de PRs. O par também precisa de 2FA e de aceitar o convite |
| Repositório de referência ONGConecta | Modelo de workflows, templates e ADRs |

Treinamento e continuidade:

- `docs/onboarding.md` explica como clonar, rodar, testar e abrir o primeiro PR. Serve para o par de revisão e para qualquer pessoa que entrar no projeto.
- Decisões técnicas relevantes são registradas em ADRs curtos (`docs/adr/`).
- Comentários de revisão explicam o porquê, não só aprovam ou rejeitam.

## 13. Controle de Software de Subcontratados, Fornecedores e Dependências de Terceiros

Não há subcontratados. As dependências de terceiros são pacotes do pub.dev e GitHub Actions, tratados como ICs:

- **Versões travadas** no `pubspec.lock`, versionado no repositório; o CI usa `--enforce-lockfile`.
- **Dependabot** semanal para `pub` e mensal para `github-actions`, com prefixo `chore(deps)`. Cada atualização passa pelo mesmo CI e pela mesma revisão.
- **Actions** de terceiros fixadas por versão maior (`@v4`) e atualizadas pelo Dependabot.
- Nova dependência entra só por PR, com justificativa na descrição; se pedir permissões novas no app, passa pelo CCM.
- Serviços externos futuros (ex.: gateway de pagamento) devem ter versão da API e responsável documentados em `docs/`, com credenciais só no GitHub Secrets.

## 14. Quadro-Resumo do Pipeline CI/CD

| Etapa | Descrição | Gatilho |
|---|---|---|
| CI | Lockfile, formatação, análise estática, testes com cobertura, título do PR, build web do PR | Abertura/atualização de PR |
| Revisão | Aprovação do par de revisão | PR com CI verde |
| Merge | Squash na `main`, título do PR como mensagem | 1 aprovação + `ci-ok` verde |
| CD — Staging | Build único, deploy em `/staging/`, smoke test, APK de teste | Push na `main` |
| Gate de release | Aprovação de `@ispanholito` no Environment `production` | Staging validado |
| CD — Produção | Deploy do mesmo artefato, smoke test, tag `vX.Y.Z`, Release | Aprovação do gate |
| Rollback | Republica o artefato de uma tag anterior | Manual (`rollback.yml`) |

---

*Este plano mantém os quatro pilares da GCS (identificação, controle de versão, controle de mudanças e auditoria/status) apoiados por automação. Qualquer alteração nele é feita por Pull Request e registrada no Histórico de Revisões.*
