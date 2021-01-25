#!/bin/bash

# DEV
COMPARTMENT_DEV_OCID=ocid1.compartment.oc1..xxxxxxx
EXCLUDE_RESOURCES=("ocid1.autonomousdatabase.oc1.xxxx" "ocid1.autonomousdatabase.oc1.xxxxx")
LIFE_STATUS_EXPECTED="AVAILABLE"

# 1. For each COMPARTMENT DEV
ALL_COMPARTMENT_OCIDS=$(oci iam compartment list --all --compartment-id $COMPARTMENT_DEV_OCID | grep -v "compartment-id" | grep "ocid1.compartment.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
for COMPARTMENT_OCID in $ALL_COMPARTMENT_OCIDS
do
    echo "**** $COMPARTMENT_OCID"
	# 2. For each ADB
	ALL_ADB_OCIDS=$(oci db autonomous-database list --compartment-id $COMPARTMENT_OCID | grep "ocid1.autonomousdatabase.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
	for ADB_OCID in $ALL_ADB_OCIDS
	do
		if [[ " ${EXCLUDE_RESOURCES[@]} " =~ " $ADB_OCID " ]]; then
			echo "####  This feature is part of the list of features to be excluded from the script"
		else
			export LIFE_STATUS=$(oci db autonomous-database get --autonomous-database-id $ADB_OCID --query data.\"lifecycle-state\" --raw-output)
			if [[  " $LIFE_STATUS " == " $LIFE_STATUS_EXPECTED " ]]; then
				echo "#### $ADB_OCID"
				echo "ADB is stopping..."
				oci db autonomous-database stop --autonomous-database-id $ADB_OCID
			else
				echo "#### ADB status is not AVAILABLE"
			fi # end $LIFE_STATUS
		fi # end ${EXCLUDE_RESOURCES[@]}
	done # end ADB		
done #end COMPARTMENT

# HOM
COMPARTMENT_HOM_OCID=ocid1.compartment.oc1..xxxxxxx

# 1. For each COMPARTMENT HOM
ALL_COMPARTMENT_OCIDS=$(oci iam compartment list --all --compartment-id $COMPARTMENT_HOM_OCID | grep -v "compartment-id" | grep "ocid1.compartment.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
for COMPARTMENT_OCID in $ALL_COMPARTMENT_OCIDS
do
    echo "**** $COMPARTMENT_OCID"
	# 2. For each ADB
	ALL_ADB_OCIDS=$(oci db autonomous-database list --compartment-id $COMPARTMENT_OCID | grep "ocid1.autonomousdatabase.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
	for ADB_OCID in $ALL_ADB_OCIDS
	do
		if [[ " ${EXCLUDE_RESOURCES[@]} " =~ " $ADB_OCID " ]]; then
			echo "####  This feature is part of the list of features to be excluded from the script"
		else		
			export LIFE_STATUS=$(oci db autonomous-database get --autonomous-database-id $ADB_OCID --query data.\"lifecycle-state\" --raw-output)
			if [[  " $LIFE_STATUS " == " $LIFE_STATUS_EXPECTED " ]]; then
				echo "#### $ADB_OCID"
				echo "ADB is stopping..."
				oci db autonomous-database stop --autonomous-database-id $ADB_OCID
			else
				echo "#### ADB status is not AVAILABLE"
			fi # end $LIFE_STATUS
		fi # end ${EXCLUDE_RESOURCES[@]}
	done # end ADB		
done #end COMPARTMENT