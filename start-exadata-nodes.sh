#!/bin/bash

# DEV
COMPARTMENT_DEV_OCID=ocid1.compartment.oc1..xxxxxxxx
LIFE_STATUS_EXPECTED="STOPPED"

# 1. For each COMPARTMENT DEV
ALL_COMPARTMENT_OCIDS=$(oci iam compartment list --all --compartment-id $COMPARTMENT_DEV_OCID | grep -v "compartment-id" | grep "ocid1.compartment.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
for COMPARTMENT_OCID in $ALL_COMPARTMENT_OCIDS
do
    echo "**** $COMPARTMENT_OCID"
	# 2. For each DBSYSTEM
	ALL_EXADATA_OCIDS=$(oci db cloud-vm-cluster list --compartment-id $COMPARTMENT_OCID | grep "ocid1.cloudvmcluster.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
	for EXADATA_OCID in $ALL_EXADATA_OCIDS
	do
        ALL_NODE_OCIDS=$(oci db node list --compartment-id $COMPARTMENT_OCID --vm-cluster-id $EXADATA_OCID | grep ocid1.dbnode.oc1 | cut -d ":" -f2 | cut -d "\"" -f2)
        for NODE_OCID in $ALL_NODE_OCIDS
        do
            export LIFE_STATUS=$(oci db node get --db-node-id $NODE_OCID --query data.\"lifecycle-state\" --raw-output)
			if [[  " $LIFE_STATUS " == " $LIFE_STATUS_EXPECTED " ]]; then
                echo "#### $NODE_OCID"
                echo "DBSYSTEM NODE is starting..."
                oci db node start --db-node-id $NODE_OCID
            else
                echo "#### Node status is not STOPPED"
            fi # end $LIFE_STATUS    
        done # end NODE
	done # end DBSYSTEM		
done #end COMPARTMENT

# HOM
COMPARTMENT_HOM_OCID=ocid1.compartment.oc1..xxxxx
LIFE_STATUS_EXPECTED="STOPPED"

# 1. For each COMPARTMENT HOM
ALL_COMPARTMENT_OCIDS=$(oci iam compartment list --all --compartment-id $COMPARTMENT_HOM_OCID | grep -v "compartment-id" | grep "ocid1.compartment.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
for COMPARTMENT_OCID in $ALL_COMPARTMENT_OCIDS
do
    echo "**** $COMPARTMENT_OCID"
	# 2. For each DBSYSTEM
	ALL_EXADATA_OCIDS=$(oci db cloud-vm-cluster list --compartment-id $COMPARTMENT_OCID | grep "ocid1.cloudvmcluster.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
	for EXADATA_OCID in $ALL_EXADATA_OCIDS
	do
        ALL_NODE_OCIDS=$(oci db node list --compartment-id $COMPARTMENT_OCID --vm-cluster-id $EXADATA_OCID | grep ocid1.dbnode.oc1 | cut -d ":" -f2 | cut -d "\"" -f2)
        for NODE_OCID in $ALL_NODE_OCIDS
        do
            export LIFE_STATUS=$(oci db node get --db-node-id $NODE_OCID --query data.\"lifecycle-state\" --raw-output)
			if [[  " $LIFE_STATUS " == " $LIFE_STATUS_EXPECTED " ]]; then
                echo "#### $NODE_OCID"
                echo "DBSYSTEM NODE is starting..."
                oci db node start --db-node-id $NODE_OCID
            else
                echo "#### Node status is not STOPPED"
            fi # end $LIFE_STATUS    
        done # end NODE
	done # end DBSYSTEM		
done #end COMPARTMENT