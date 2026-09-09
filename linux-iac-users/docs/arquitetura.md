# Arquitetura

O projeto cria uma estrutura básica de usuários, grupos, diretórios e permissões em uma máquina Linux.

## Grupos

- `GRP_ADM`: usuários administrativos
- `GRP_VEN`: usuários de vendas
- `GRP_SEC`: usuários de segurança

## Diretórios

| Diretório | Grupo | Permissão |
|---|---|---|
| `/publico` | — | `777` |
| `/adm` | `GRP_ADM` | `770` |
| `/ven` | `GRP_VEN` | `770` |
| `/sec` | `GRP_SEC` | `770` |

## Princípio aplicado

Os diretórios privados usam o modelo `770`, permitindo acesso completo ao proprietário e ao grupo, enquanto usuários externos ao grupo não possuem acesso.

O diretório `/publico` é deliberadamente aberto para reproduzir o cenário proposto no desafio original.
