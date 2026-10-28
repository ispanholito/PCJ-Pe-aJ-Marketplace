# 0002 — Revisão por par em projeto individual

- Status: aceito
- Data: 28/10/2026

## Contexto

O PGC (3.3 e 5.2) exige que todo Pull Request seja aprovado por outra pessoa
antes do merge. O PeçaJá tem um único desenvolvedor, e o GitHub não permite
aprovar o próprio PR.

## Decisão

1. Um colega da disciplina é o **par de revisão**, colaborador com permissão
   *Write*. Ele aprova os PRs do PeçaJá e eu aprovo os dele.
2. A `main` exige 1 aprovação, descarta aprovações antigas a cada novo commit,
   exige histórico linear e **não permite exceções, nem para o administrador**.
3. O deploy em produção exige aprovação de `@ispanholito` no Environment
   `production`, com *Prevent self-review* desmarcado: quem dispara o deploy é
   o próprio desenvolvedor. A separação de funções está na revisão do código,
   não no deploy.

## Alternativas consideradas

- **0 aprovações (como no repositório de referência do professor):** descartada.
  Deixaria o projeto sem nenhuma revisão humana.
- **Segunda conta própria como revisora:** descartada. Viola os Termos de Serviço
  do GitHub e cumpre a regra só no papel.

## Consequências

- Nada entra na `main` sem ser visto por uma segunda pessoa.
- Se o par demorar, o fluxo trava. Por isso o prazo de resposta é de até 3 dias
  úteis (PGC 2.1).
