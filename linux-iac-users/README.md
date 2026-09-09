# Linux IaC — Usuários, Grupos, Diretórios e Permissões

Projeto de automação de infraestrutura em Linux utilizando Bash.

A proposta é transformar uma configuração manual de usuários, grupos, diretórios e permissões em um processo reproduzível por script.

## Objetivo

Ao executar o script em uma nova máquina Linux, a estrutura básica de acesso é criada automaticamente:

- grupos de usuários;
- usuários;
- associação entre usuários e grupos;
- diretórios;
- proprietários;
- permissões;
- registro da execução em log.

O projeto também possui um script de remoção para desfazer a estrutura criada.

## Estrutura

```text
linux-iac-users/
├── setup.sh
├── remove.sh
├── README.md
├── LICENSE
├── config/
│   ├── groups.conf
│   └── users.conf
├── docs/
│   └── arquitetura.md
└── logs/
    └── .gitkeep
```

## Tecnologias

- Linux
- Bash
- Git
- GitHub
- Linux Users & Groups
- File Permissions

## Como executar

### 1. Dar permissão aos scripts

```bash
chmod +x setup.sh remove.sh
```

### 2. Executar a configuração

```bash
sudo ./setup.sh
```

O script exige privilégios administrativos porque cria usuários, grupos e altera permissões do sistema.

### 3. Validar os grupos

```bash
getent group GRP_ADM
getent group GRP_VEN
getent group GRP_SEC
```

### 4. Validar os usuários

```bash
id carlos
id debora
id josefina
```

### 5. Validar permissões

```bash
ls -ld /publico /adm /ven /sec
```

## Idempotência

O script foi desenvolvido para poder ser executado novamente sem tentar recriar grupos ou usuários que já existem.

Isso é importante em automação de infraestrutura porque uma execução repetida não deve, por si só, provocar falhas desnecessárias.

## Logs

As execuções são registradas em:

```text
/opt/linux-iac-users/logs/setup.log
```

## Remoção

Para remover a estrutura criada pelo projeto:

```bash
sudo ./remove.sh
```

O script solicita uma confirmação explícita antes da remoção.

> Atenção: o script de remoção remove os usuários definidos no projeto e seus diretórios pessoais. Execute apenas em uma máquina de laboratório ou ambiente destinado ao teste.

## Exemplo de resultado

```text
==============================================
 CONFIGURAÇÃO CONCLUÍDA
==============================================

Grupos:
GRP_ADM
GRP_VEN
GRP_SEC

Usuários:
  GRP_ADM: carlos maria joao
  GRP_VEN: debora sebastiana roberto
  GRP_SEC: josefina amanda fernando

Diretórios:
/adm
/publico
/sec
/ven
```

## Aprendizados

Este projeto demonstra conhecimentos básicos de:

- administração de usuários Linux;
- gerenciamento de grupos;
- permissões de arquivos e diretórios;
- `chmod`;
- `chown`;
- `useradd`;
- `usermod`;
- `groupadd`;
- automação com Bash;
- tratamento de erros;
- logs;
- idempotência;
- versionamento com Git.

## Próximas evoluções

Possíveis melhorias:

1. transformar usuários e grupos em arquivos de configuração realmente utilizados pelo script;
2. permitir parâmetros via linha de comando;
3. adicionar testes automatizados;
4. adicionar GitHub Actions para validação do Bash;
5. criar uma versão compatível com diferentes distribuições Linux;
6. adicionar execução em ambiente Docker para demonstração.

## Autoria

Projeto desenvolvido como evolução prática de um desafio de Infraestrutura como Código, com implementação própria e foco em automação reproduzível.
