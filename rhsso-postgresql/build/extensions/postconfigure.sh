#!/bin/bash

echo "------------- START UPDATING CONFIGURATION ---------------"

cp -p /opt/eap/standalone/configuration/standalone-openshift.xml /opt/eap/extensions/standalone-ocp.bak
echo "creating datasources:"
$JBOSS_HOME/bin/jboss-cli.sh --file=/opt/eap/extensions/datasources.cli
echo "configuring TX object store:"

local prefix="os${HOSTNAME//-/}"

echo "
embed-server --std-out=echo  --server-config=standalone-openshift.xml
batch
/subsystem=transactions:write-attribute(name=use-jdbc-store, value=true)
/subsystem=transactions:write-attribute(name=jdbc-store-datasource, value=\"java:jboss/datasources/KeycloakDSObjectStore\")
/subsystem=transactions:write-attribute(name=jdbc-action-store-table-prefix, value=${prefix})
/subsystem=transactions:write-attribute(name=jdbc-communication-store-table-prefix, value=${prefix})
/subsystem=transactions:write-attribute(name=jdbc-state-store-table-prefix, value=${prefix})
run-batch

quit
" > /opt/eap/extensions/objectstore.cli

$JBOSS_HOME/bin/jboss-cli.sh --file=/opt/eap/extensions/objectstore.cli

echo "configuring x-site-replica"

$JBOSS_HOME/bin/jboss-cli.sh --file=/opt/eap/extensions/x-site-replica.cli

echo "------------- ENDED UPDATING CONFIGURATION ---------------"
cp -p /opt/eap/standalone/configuration/standalone-openshift.xml /opt/eap/extensions/standalone-ocp.new
