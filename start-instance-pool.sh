#!/bin/bash

# DEV
COMPARTMENT_DEV_OCID=ocid1.compartment.oc1..xxxxxxxx
EXCLUDE_RESOURCES=("ocid1.instancepool.oc1.xxxxx" "ocid1.instancepool.oc1.xxxxx")
LIFE_STATUS_EXPECTED="STOPPED"

# 1. For each COMPARTMENT DEV
ALL_COMPARTMENT_OCIDS=$(oci iam compartment list --all --compartment-id $COMPARTMENT_DEV_OCID | grep -v "compartment-id" | grep "ocid1.compartment.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
for COMPARTMENT_OCID in $ALL_COMPARTMENT_OCIDS
do
    echo "**** $COMPARTMENT_OCID"
	# 2. For each COMPUTE
	ALL_POOL_OCIDS=$(oci compute-management instance-pool list --compartment-id $COMPARTMENT_OCID | grep "ocid1.instancepool.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
	for POOL_OCID in $ALL_POOL_OCIDS
	do
		if [[ " ${EXCLUDE_RESOURCES[@]} " =~ " $POOL_OCID " ]]; then
			echo "#### This feature is part of the list of features to be excluded from the script"
		else
			export LIFE_STATUS=$(oci compute-management instance-pool get --instance-pool-id $POOL_OCID --query data.\"lifecycle-state\" --raw-output)
			if [[  " $LIFE_STATUS " == " $LIFE_STATUS_EXPECTED " ]]; then
				echo "#### $POOL_OCID"
				echo "POOL is starting..."
				oci compute-management instance-pool start --instance-pool-id $POOL_OCID
			else
				echo "#### POOL status is not STOPPED"
			fi # end $LIFE_STATUS
		fi # end ${EXCLUDE_RESOURCES[@]}
	done # end POOL		
done #end COMPARTMENT

# HOM
COMPARTMENT_HOM_OCID=ocid1.compartment.oc1..xxxxxxxxx

# 1. For each COMPARTMENT HOM
ALL_COMPARTMENT_OCIDS=$(oci iam compartment list --all --compartment-id $COMPARTMENT_HOM_OCID | grep -v "compartment-id" | grep "ocid1.compartment.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
for COMPARTMENT_OCID in $ALL_COMPARTMENT_OCIDS
do
    echo "**** $COMPARTMENT_OCID"
	# 2. For each COMPUTE
	ALL_POOL_OCIDS=$(oci compute-management instance-pool list --compartment-id $COMPARTMENT_OCID | grep "ocid1.instancepool.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
	for POOL_OCID in $ALL_POOL_OCIDS
	do
		if [[ " ${EXCLUDE_RESOURCES[@]} " =~ " $POOL_OCID " ]]; then
			echo "#### This feature is part of the list of features to be excluded from the script"
		else
			export LIFE_STATUS=$(oci compute-management instance-pool get --instance-pool-id $POOL_OCID --query data.\"lifecycle-state\" --raw-output)
			if [[  " $LIFE_STATUS " == " $LIFE_STATUS_EXPECTED " ]]; then
				echo "#### $POOL_OCID"
				echo "POOL is starting..."
				oci compute-management instance-pool start --instance-pool-id $POOL_OCID
			else
				echo "#### POOL status is not STOPPED"
			fi # end $LIFE_STATUS
		fi # end ${EXCLUDE_RESOURCES[@]}
	done # end POOL		
done #end COMPARTMENT