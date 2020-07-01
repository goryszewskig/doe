#!/bin/bash
# -----------------------------------------------------------------------
# Trivadis AG, Business Development & Support (BDS)
# Saegereistrasse 29, 8152 Glattbrugg, Switzerland
# -----------------------------------------------------------------------
# Name.......: 05_eus_mapping.sh
# Author.....: Stefan Oehrli (oes) stefan.oehrli@trivadis.com
# Editor.....: Stefan Oehrli
# Date.......: 2018.06.27
# Revision...: --
# Purpose....: Script to create EUS for Database.
# Notes......: --
# Reference..: https://github.com/oehrlis/oudbase
# License....: GPL-3.0+
# -----------------------------------------------------------------------
# Modified...:
# see git revision history with git log for more information on changes
# -----------------------------------------------------------------------

export BASEDN=${BASEDN:-"dc=trivadislabs,dc=com"}
export OUD_HOST=${OUD_HOST:-"eusoud.trivadislabs.com"}
export OUD_PORT=${OUD_PORT:-"1389"}
export ORACLE_SID=${ORACLE_SID:-"TEUS02"}
export PDB="pdb1"
export EUS_ADMIN=${EUS_ADMIN:-"$(cat /u01/common/etc/oud_eus_eusadmin_dn.txt)"}
export EUS_PWD_FILE=${EUS_PWD_FILE:-"/u01/common/etc/oud_eus_eusadmin_pwd.txt"}
export SYSTEM_PWD_FILE=${SYSTEM_PWD_FILE:-"${ORACLE_BASE}/admin/${ORACLE_SID}/etc/${ORACLE_SID}_password.txt"}

# - configure EUS mappings ---------------------------------------------
echo "Create Mappings for Database ${ORACLE_SID} in OUD using:"
echo "  OUD_HOST            :   ${OUD_HOST}"
echo "  OUD_PORT            :   ${OUD_PORT}"
echo "  HOSTNAME            :   ${HOSTNAME}"
echo "  BASEDN              :   ${BASEDN}"
echo "  ORACLE_SID          :   ${ORACLE_SID}"
echo "  EUS_ADMIN           :   ${EUS_ADMIN}"
echo "  EUS_PWD_FILE        :   ${EUS_PWD_FILE}"
echo "  SYSTEM_PWD_FILE     :   ${SYSTEM_PWD_FILE}"

# - create mappings ----------------------------------------------------
echo " Create subtree mapping for ${ORACLE_SID} on ou=People,${BASEDN} to EUS_USERS"
eusm listMappings domain_name="OracleDefaultDomain" \
    realm_dn="${BASEDN}" ldap_host=${OUD_HOST} ldap_port=${OUD_PORT} \
    ldap_user_dn="${EUS_ADMIN}" ldap_user_password=$(cat ${EUS_PWD_FILE})  

echo " Create entry mapping for ${ORACLE_SID} on cn=Ben King,ou=Senior Management,ou=People,${BASEDN} to KING"
eusm createMapping database_name="${PDB}_${ORACLE_SID}" \
    map_type=ENTRY schema=KING \
    map_dn="cn=Ben King,ou=Senior Management,ou=People,dc=trivadislabs,dc=com" \
    realm_dn="${BASEDN}" ldap_host=${OUD_HOST} ldap_port=${OUD_PORT} \
    ldap_user_dn="${EUS_ADMIN}" ldap_user_password=$(cat ${EUS_PWD_FILE})  

eusm listMappings database_name="${PDB}_${ORACLE_SID}" \
    realm_dn="${BASEDN}" ldap_host=${OUD_HOST} ldap_port=${OUD_PORT} \
    ldap_user_dn="${EUS_ADMIN}" ldap_user_password=$(cat ${EUS_PWD_FILE})  

# - create enterprise roles --------------------------------------------
echo " List enterprise roles HR Clerk and Management"

eusm listEnterpriseRoles domain_name="OracleDefaultDomain" \
    realm_dn="${BASEDN}" ldap_host=${OUD_HOST} ldap_port=${OUD_PORT} \
    ldap_user_dn="${EUS_ADMIN}" ldap_user_password=$(cat ${EUS_PWD_FILE}) 

# - add global roles -------------------------------------------------
echo " Add global roles HR Clerk and Management"
eusm addGlobalRole enterprise_role="HR Clerk" \
    domain_name="OracleDefaultDomain" database_name="${PDB}_${ORACLE_SID}" \
    global_role="hr_clerk" dbuser="system" dbuser_password=$(cat ${SYSTEM_PWD_FILE}) \
    dbconnect_string="${HOSTNAME}:1521/$PDB" \
    realm_dn="${BASEDN}" ldap_host=${OUD_HOST} ldap_port=${OUD_PORT} \
    ldap_user_dn="${EUS_ADMIN}" ldap_user_password=$(cat ${EUS_PWD_FILE}) 

eusm addGlobalRole enterprise_role="HR Management" \
    domain_name="OracleDefaultDomain" database_name="${PDB}_${ORACLE_SID}" \
    global_role="hr_clerk" dbuser="system" dbuser_password=$(cat ${SYSTEM_PWD_FILE}) \
    dbconnect_string="${HOSTNAME}:1521/$PDB" \
    realm_dn="${BASEDN}" ldap_host=${OUD_HOST} ldap_port=${OUD_PORT} \
    ldap_user_dn="${EUS_ADMIN}" ldap_user_password=$(cat ${EUS_PWD_FILE}) 

eusm addGlobalRole enterprise_role="HR Management" \
    domain_name="OracleDefaultDomain" database_name="${PDB}_${ORACLE_SID}" \
    global_role="hr_mgr" dbuser="system" dbuser_password=$(cat ${SYSTEM_PWD_FILE}) \
    dbconnect_string="${HOSTNAME}:1521/$PDB" \
    realm_dn="${BASEDN}" ldap_host=${OUD_HOST} ldap_port=${OUD_PORT} \
    ldap_user_dn="${EUS_ADMIN}" ldap_user_password=$(cat ${EUS_PWD_FILE}) 

echo " Add global roles common Clerk and Management"
eusm addGlobalRole enterprise_role="Common Clerk" \
    domain_name="OracleDefaultDomain" database_name="${PDB}_${ORACLE_SID}" \
    global_role="common_clerk" dbuser="system" dbuser_password=$(cat ${SYSTEM_PWD_FILE}) \
    dbconnect_string="${HOSTNAME}:1521/$PDB" \
    realm_dn="${BASEDN}" ldap_host=${OUD_HOST} ldap_port=${OUD_PORT} \
    ldap_user_dn="${EUS_ADMIN}" ldap_user_password=$(cat ${EUS_PWD_FILE}) 

eusm addGlobalRole enterprise_role="Common Management" \
    domain_name="OracleDefaultDomain" database_name="${PDB}_${ORACLE_SID}" \
    global_role="common_clerk" dbuser="system" dbuser_password=$(cat ${SYSTEM_PWD_FILE}) \
    dbconnect_string="${HOSTNAME}:1521/$PDB" \
    realm_dn="${BASEDN}" ldap_host=${OUD_HOST} ldap_port=${OUD_PORT} \
    ldap_user_dn="${EUS_ADMIN}" ldap_user_password=$(cat ${EUS_PWD_FILE}) 

eusm addGlobalRole enterprise_role="Common Management" \
    domain_name="OracleDefaultDomain" database_name="${PDB}_${ORACLE_SID}" \
    global_role="common_mgr" dbuser="system" dbuser_password=$(cat ${SYSTEM_PWD_FILE}) \
    dbconnect_string="${HOSTNAME}:1521/$PDB" \
    realm_dn="${BASEDN}" ldap_host=${OUD_HOST} ldap_port=${OUD_PORT} \
    ldap_user_dn="${EUS_ADMIN}" ldap_user_password=$(cat ${EUS_PWD_FILE}) 

# - grant enterprise roles -------------------------------------------------
echo " Grant enterprise roles HR Clerk and Management"
eusm listEnterpriseRoleInfo enterprise_role="HR Management" \
    domain_name="OracleDefaultDomain" \
    realm_dn="${BASEDN}" ldap_host=${OUD_HOST} ldap_port=${OUD_PORT} \
    ldap_user_dn="${EUS_ADMIN}" ldap_user_password=$(cat ${EUS_PWD_FILE}) 

eusm listEnterpriseRoleInfo enterprise_role="HR Clerk" \
    domain_name="OracleDefaultDomain" \
    realm_dn="${BASEDN}" ldap_host=${OUD_HOST} ldap_port=${OUD_PORT} \
    ldap_user_dn="${EUS_ADMIN}" ldap_user_password=$(cat ${EUS_PWD_FILE}) 

echo " Grant enterprise roles common Clerk and Management"
eusm listEnterpriseRoleInfo enterprise_role="Common Management" \
    domain_name="OracleDefaultDomain" \
    realm_dn="${BASEDN}" ldap_host=${OUD_HOST} ldap_port=${OUD_PORT} \
    ldap_user_dn="${EUS_ADMIN}" ldap_user_password=$(cat ${EUS_PWD_FILE}) 

eusm listEnterpriseRoleInfo enterprise_role="Common Clerk" \
    domain_name="OracleDefaultDomain" \
    realm_dn="${BASEDN}" ldap_host=${OUD_HOST} ldap_port=${OUD_PORT} \
    ldap_user_dn="${EUS_ADMIN}" ldap_user_password=$(cat ${EUS_PWD_FILE}) 
# - EOF -----------------------------------------------------------------