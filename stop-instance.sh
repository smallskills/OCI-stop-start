#!/bin/bash

# DEV
COMPARTMENT_DEV_OCID=ocid1.compartment.oc1..xxxxxxxxx
EXCLUDE_RESOURCES=("exclude1" "exclude2")
LIFE_STATUS_EXPECTED="RUNNING"

# 1. For each COMPARTMENT DEV
ALL_COMPARTMENT_OCIDS=$(oci iam compartment list --all --compartment-id $COMPARTMENT_DEV_OCID | grep -v "compartment-id" | grep "ocid1.compartment.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
for COMPARTMENT_OCID in $ALL_COMPARTMENT_OCIDS
do
    echo "****  $COMPARTMENT_OCID"
	# 2. For each COMPUTE
	ALL_COMPUTE_OCIDS=$(oci compute instance list --compartment-id $COMPARTMENT_OCID | grep "ocid1.instance.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
	for COMPUTE_OCID in $ALL_COMPUTE_OCIDS
	do
		if [[ " ${EXCLUDE_RESOURCES[@]} " =~ " $COMPUTE_OCID " ]]; then
			echo "####  This feature is part of the list of features to be excluded from the script"
		else
			export LIFE_STATUS=$(oci compute instance get --instance-id $COMPUTE_OCID --query data.\"lifecycle-state\" --raw-output)
			if [[  " $LIFE_STATUS " == " $LIFE_STATUS_EXPECTED " ]]; then
				echo "##### $COMPUTE_OCID"
				echo "COMPUTE is stopping..."
				oci compute instance action --instance-id $COMPUTE_OCID --action STOP --wait-for-state STOPPED
			else
				echo "####  Computer status is not RUNNING"
			fi # end $LIFE_STATUS
		fi # end ${EXCLUDE_RESOURCES[@]}
	done # end COMPUTE		
done #end COMPARTMENT

# HOM
COMPARTMENT_HOM_OCID=ocid1.compartment.oc1..xxxxxxx

# 1. For each COMPARTMENT HOM
ALL_COMPARTMENT_OCIDS=$(oci iam compartment list --all --compartment-id $COMPARTMENT_HOM_OCID | grep -v "compartment-id" | grep "ocid1.compartment.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
for COMPARTMENT_OCID in $ALL_COMPARTMENT_OCIDS
do
    echo "****  $COMPARTMENT_OCID"
	# 2. For each COMPUTE
	ALL_COMPUTE_OCIDS=$(oci compute instance list --compartment-id $COMPARTMENT_OCID | grep "ocid1.instance.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
	for COMPUTE_OCID in $ALL_COMPUTE_OCIDS
	do
		if [[ " ${EXCLUDE_RESOURCES[@]} " =~ " $COMPUTE_OCID " ]]; then
			echo "####  This feature is part of the list of features to be excluded from the script"
		else
			export LIFE_STATUS=$(oci compute instance get --instance-id $COMPUTE_OCID --query data.\"lifecycle-state\" --raw-output)
			if [[  " $LIFE_STATUS " == " $LIFE_STATUS_EXPECTED " ]]; then
				echo "####  $COMPUTE_OCID"
				echo "COMPUTE is stopping..."
				oci compute instance action --instance-id $COMPUTE_OCID --action STOP --wait-for-state STOPPED
			else
				echo "####  Computer status is not RUNNING"
			fi # end $LIFE_STATUS
		fi # end ${EXCLUDE_RESOURCES[@]}
	done # end COMPUTE		
done #end COMPARTMENT