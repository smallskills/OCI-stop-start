#!/bin/bash

# DEV
COMPARTMENT_DEV_OCID=ocid1.compartment.oc1..aaaaaaaam2oxgs3t4rdv3og2q3lr46qu7bsstv73ajvdbwd6bp2nbykqm75a
LIFE_STATUS_EXPECTED="STOPPED"

# 1. For each COMPARTMENT
ALL_COMPARTMENT_OCIDS=$(oci iam compartment list --all --compartment-id $COMPARTMENT_DEV_OCID | grep -v "compartment-id" | grep "ocid1.compartment.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
for COMPARTMENT_OCID in $ALL_COMPARTMENT_OCIDS
do
    echo "**** $COMPARTMENT_OCID"
	# 2. For each COMPUTE
	ALL_COMPUTE_OCIDS=$(oci compute instance list --compartment-id $COMPARTMENT_OCID | grep "ocid1.instance.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
	for COMPUTE_OCID in $ALL_COMPUTE_OCIDS
	do
		export LIFE_STATUS=$(oci compute instance get --instance-id $COMPUTE_OCID --query data.\"lifecycle-state\" --raw-output)
		if [[  " $LIFE_STATUS " == " $LIFE_STATUS_EXPECTED " ]]; then
			echo "#### $COMPUTE_OCID"
			echo "COMPUTE is starting..."
			oci compute instance action --instance-id $COMPUTE_OCID --action START --wait-for-state RUNNING
		else
			echo "#### Computer status is not STOPPED"
		fi # end $LIFE_STATUS
	done # end COMPUTE		
done #end COMPARTMENT

# HOM
COMPARTMENT_HOM_OCID=ocid1.compartment.oc1..aaaaaaaau3fmsgrac75fnke7dvwgskm26h3ng4b6hu2rik5bd5gkazs3wjza

# 1. For each COMPARTMENT
ALL_COMPARTMENT_OCIDS=$(oci iam compartment list --all --compartment-id $COMPARTMENT_HOM_OCID | grep -v "compartment-id" | grep "ocid1.compartment.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
for COMPARTMENT_OCID in $ALL_COMPARTMENT_OCIDS
do
    echo "*******************************  $COMPARTMENT_OCID"
	# 2. For each COMPUTE
	ALL_COMPUTE_OCIDS=$(oci compute instance list --compartment-id $COMPARTMENT_OCID | grep "ocid1.instance.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
	for COMPUTE_OCID in $ALL_COMPUTE_OCIDS
	do
		export LIFE_STATUS=$(oci compute instance get --instance-id $COMPUTE_OCID --query data.\"lifecycle-state\" --raw-output)
		if [[  " $LIFE_STATUS " == " $LIFE_STATUS_EXPECTED " ]]; then
			echo "###########################  $COMPUTE_OCID"
			echo "COMPUTE is starting..."
			oci compute instance action --instance-id $COMPUTE_OCID --action START --wait-for-state RUNNING
		else
			echo "###########################  Computer status is not STOPPED"
		fi # end $LIFE_STATUS
	done # end COMPUTE		
done #end COMPARTMENT
