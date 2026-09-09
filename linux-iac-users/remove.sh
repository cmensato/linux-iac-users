#!/usr/bin/env bash

set -Eeuo pipefail

if [[ "${EUID}" -ne 0 ]]; then
    echo "Execute este script como root ou usando sudo."
    exit 1
fi

GROUPS=("GRP_ADM" "GRP_VEN" "GRP_SEC")

declare -A USERS
USERS[GRP_ADM]="carlos maria joao"
USERS[GRP_VEN]="debora sebastiana roberto"
USERS[GRP_SEC]="josefina amanda fernando"

echo "ATENÇÃO: esta operação removerá os usuários, grupos e diretórios criados por este projeto."
read -r -p "Digite REMOVE para confirmar: " confirmation

if [[ "${confirmation}" != "REMOVE" ]]; then
    echo "Operação cancelada."
    exit 0
fi

for group in "${GROUPS[@]}"; do
    for user in ${USERS[$group]}; do
        if id "${user}" >/dev/null 2>&1; then
            userdel --remove "${user}" || userdel "${user}"
            echo "Usuário ${user} removido."
        fi
    done
done

rm -rf /publico /adm /ven /sec

for group in "${GROUPS[@]}"; do
    if getent group "${group}" >/dev/null 2>&1; then
        groupdel "${group}"
        echo "Grupo ${group} removido."
    fi
done

echo "Estrutura removida."
