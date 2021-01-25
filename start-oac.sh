#!/bin/bash

# DEV
COMPARTMENT_DEV_OCID=ocid1.compartment.oc1..xxxxxx
LIFE_STATUS_EXPECTED="INACTIVE"

# 1. For each COMPARTMENT DEV
ALL_COMPARTMENT_OCIDS=$(oci iam compartment list --all --compartment-id $COMPARTMENT_DEV_OCID | grep -v "compartment-id" | grep "ocid1.compartment.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
for COMPARTMENT_OCID in $ALL_COMPARTMENT_OCIDS
do
    echo "**** $COMPARTMENT_OCID"
	# 2. For each OAC
	ALL_OAC_OCIDS=$(oci analytics analytics-instance list --compartment-id $COMPARTMENT_OCID | grep "ocid1.analyticsinstance.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
	for OAC_OCID in $ALL_OAC_OCIDS
	do
		export LIFE_STATUS=$(oci analytics analytics-instance get --analytics-instance-id $OAC_OCID --query data.\"lifecycle-state\" --raw-output)
		if [[  " $LIFE_STATUS " == " $LIFE_STATUS_EXPECTED " ]]; then
			echo "#### $OAC_OCID"
			echo "OAC is starting..."
			oci analytics analytics-instance start --analytics-instance-id $OAC_OCID
		else
			echo "#### OAC status is not INACTIVE"
		fi # end $LIFE_STATUS
	done # end OAC		
done #end COMPARTMENT

# HOM
COMPARTMENT_HOM_OCID=ocid1.compartment.oc1..xxxxxx

# 1. For each COMPARTMENT DEV
ALL_COMPARTMENT_OCIDS=$(oci iam compartment list --all --compartment-id $COMPARTMENT_HOM_OCID | grep -v "compartment-id" | grep "ocid1.compartment.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
for COMPARTMENT_OCID in $ALL_COMPARTMENT_OCIDS
do
    echo "**** $COMPARTMENT_OCID"
	# 2. For each OAC
	ALL_OAC_OCIDS=$(oci analytics analytics-instance list --compartment-id $COMPARTMENT_OCID | grep "ocid1.analyticsinstance.oc1" | cut -d ":" -f2 | cut -d "\"" -f2)
	for OAC_OCID in $ALL_OAC_OCIDS
	do
		export LIFE_STATUS=$(oci analytics analytics-instance get --analytics-instance-id $OAC_OCID --query data.\"lifecycle-state\" --raw-output)
		if [[  " $LIFE_STATUS " == " $LIFE_STATUS_EXPECTED " ]]; then
			echo "#### $OAC_OCID"
			echo "OAC is starting..."
			oci analytics analytics-instance start --analytics-instance-id $OAC_OCID
		else
			echo "#### OAC status is not INACTIVE"
		fi # end $LIFE_STATUS
	done # end OAC		
done #end COMPARTMENT