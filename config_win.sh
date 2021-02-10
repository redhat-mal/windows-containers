#!/usr/bin/env bash

REGION=eastus
ZONE=1

oc project openshift-machine-api
INFRA_ID=$(oc get machineset -n openshift-machine-api $(oc get machineset -n openshift-machine-api | grep eastus1 | awk '{print $1}')  -o json |  jq '.metadata.labels."machine.openshift.io/cluster-api-cluster"' |tr -d '"')
echo "Cluster ID: $INFRA_ID"
rm -rf $INFRA_ID
mkdir $INFRA_ID

cp install-config/win-machineset.yaml $INFRA_ID

MACHINE_SET_NAME=$INFRA_ID-win-$REGION$ZONE
MACHINE_SET_NAME=win-est1

echo $MACHINE_SET_NAME

sed -i "s/<infrastructure_id>/$INFRA_ID/g" $INFRA_ID/win-machineset.yaml

sed -i "s/<windows_machine_set_name>/$MACHINE_SET_NAME/g" $INFRA_ID/win-machineset.yaml

