#!/usr/bin/env bash

set -Eeuo pipefail

PROJECT_NAME="linux-iac-users"
BASE_DIR="/opt/${PROJECT_NAME}"
LOG_DIR="${BASE_DIR}/logs"
LOG_FILE="${LOG_DIR}/setup.log"

GROUPS=("GRP_ADM" "GRP_VEN" "GRP_SEC")

declare -A USERS
USERS[GRP_ADM]="carlos maria joao"
USERS[GRP_VEN]="debora sebastiana roberto"
USERS[GRP_SEC]="josefina amanda fernando"

DIRECTORIES=("/publico" "/adm" "/ven" "/sec")

log() {
    local message="$1"
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ${message}" | tee -a "${LOG_FILE}"
}

error_handler() {
    log "ERRO na linha ${BASH_LINENO[0]}. A execução foi interrompida."
}
trap error_handler ERR

require_root() {
    if [[ "${EUID}" -ne 0 ]]; then
        echo "Execute este script como root ou usando sudo."
        exit 1
    fi
}

create_group() {
    local group="$1"

    if getent group "${group}" >/dev/null 2>&1; then
        log "Grupo ${group} já existe."
    else
        groupadd "${group}"
        log "Grupo ${group} criado."
    fi
}

create_user() {
    local user="$1"

    if id "${user}" >/dev/null 2>&1; then
        log "Usuário ${user} já existe."
    else
        useradd --create-home --shell /bin/bash "${user}"
        log "Usuário ${user} criado."
    fi
}

add_user_to_group() {
    local user="$1"
    local group="$2"

    usermod --append --groups "${group}" "${user}"
    log "Usuário ${user} associado ao grupo ${group}."
}

create_directories() {
    for directory in "${DIRECTORIES[@]}"; do
        mkdir -p "${directory}"
    done

    log "Diretórios estruturais criados."
}

configure_permissions() {
    chmod 777 /publico

    chown root:GRP_ADM /adm
    chown root:GRP_VEN /ven
    chown root:GRP_SEC /sec

    chmod 770 /adm
    chmod 770 /ven
    chmod 770 /sec

    log "Proprietários e permissões configurados."
}

show_summary() {
    echo
    echo "=============================================="
    echo " CONFIGURAÇÃO CONCLUÍDA"
    echo "=============================================="
    echo
    echo "Grupos:"
    getent group GRP_ADM GRP_VEN GRP_SEC | cut -d: -f1
    echo
    echo "Usuários:"
    for group in "${GROUPS[@]}"; do
        echo "  ${group}: ${USERS[$group]}"
    done
    echo
    echo "Diretórios:"
    ls -ld /publico /adm /ven /sec
    echo
    echo "Log: ${LOG_FILE}"
    echo
}

main() {
    require_root

    mkdir -p "${BASE_DIR}" "${LOG_DIR}"
    touch "${LOG_FILE}"

    log "Iniciando ${PROJECT_NAME}."

    for group in "${GROUPS[@]}"; do
        create_group "${group}"
    done

    for group in "${GROUPS[@]}"; do
        for user in ${USERS[$group]}; do
            create_user "${user}"
            add_user_to_group "${user}" "${group}"
        done
    done

    create_directories
    configure_permissions
    show_summary

    log "Execução finalizada com sucesso."
}

main "$@"
