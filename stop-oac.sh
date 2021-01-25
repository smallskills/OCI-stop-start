#!/bin/bash

# DEV
COMPARTMENT_DEV_OCID=ocid1.compartment.oc1..xxxxxxx
EXCLUDE_RESOURCES=("ocid1.analyticsinstance.oc1.xxxxx" "ocid1.analyticsinstance.oc1.xxxxx")
LIFE_STATUS_EXPECTED="ACTIVE"

# 1. For each COMPARTMENT DEV
ALL_COMPARTMENT_OCIDS=$(oci iam compartment list --all --compartment-id $COMPARTMENT_DEV_OCID | grep -v "compartment-id" | grep "ocid1.compartment.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
for COMPARTMENT_OCID in $ALL_COMPARTMENT_OCIDS
do
    echo "**** $COMPARTMENT_OCID"
	# 2. For each OAC
	ALL_OAC_OCIDS=$(oci analytics analytics-instance list --compartment-id $COMPARTMENT_OCID | grep "ocid1.analyticsinstance.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
	for OAC_OCID in $ALL_OAC_OCIDS
	do
		if [[ " ${EXCLUDE_RESOURCES[@]} " =~ " $OAC_OCID " ]]; then
			echo "####  This feature is part of the list of features to be excluded from the script"
		else
			export LIFE_STATUS=$(oci analytics analytics-instance get --analytics-instance-id $OAC_OCID --query data.\"lifecycle-state\" --raw-output)
			if [[  " $LIFE_STATUS " == " $LIFE_STATUS_EXPECTED " ]]; then
				echo "#### $OAC_OCID"
				echo "OAC is stopping..."
				oci analytics analytics-instance stop --analytics-instance-id $OAC_OCID
			else
				echo "####OAC status is not ACTIVE"
			fi # end $LIFE_STATUS
		fi  # end ${EXCLUDE_RESOURCES[@]}
	done # end OAC		
done #end COMPARTMENT

# HOM
COMPARTMENT_HOM_OCID=ocid1.compartment.oc1..xxxxxxx

# 1. For each COMPARTMENT HOM
ALL_COMPARTMENT_OCIDS=$(oci iam compartment list --all --compartment-id $COMPARTMENT_HOM_OCID | grep -v "compartment-id" | grep "ocid1.compartment.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
for COMPARTMENT_OCID in $ALL_COMPARTMENT_OCIDS
do
    echo "**** $COMPARTMENT_OCID"
	# 2. For each OAC
	ALL_OAC_OCIDS=$(oci analytics analytics-instance list --compartment-id $COMPARTMENT_OCID | grep "ocid1.analyticsinstance.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
	for OAC_OCID in $ALL_OAC_OCIDS
	do
		if [[ " ${EXCLUDE_RESOURCES[@]} " =~ " $OAC_OCID " ]]; then
			echo "####  This feature is part of the list of features to be excluded from the script"
		else
			export LIFE_STATUS=$(oci analytics analytics-instance get --analytics-instance-id $OAC_OCID --query data.\"lifecycle-state\" --raw-output)
			if [[  " $LIFE_STATUS " == " $LIFE_STATUS_EXPECTED " ]]; then
				echo "#### $OAC_OCID"
				echo "OAC is stopping..."
				oci analytics analytics-instance stop --analytics-instance-id $OAC_OCID
			else
				echo "#### OAC status is not ACTIVE"
			fi # end $LIFE_STATUS
		fi # end ${EXCLUDE_RESOURCES[@]}
	done # end OAC		
done #end COMPARTMENT