#!/bin/bash
# SPDX-License-Identifier: GPL-2.0+
#
# Get an estimate of how CPU-hoggy to be.
#
# Usage: cpus2use.sh
#
# Copyright (C) IBM Corporation, 2013
#
# Authors: Paul E. McKenney <paulmck@linux.ibm.com>

ncpus=`grep '^processor' /proc/cpuinfo | wc -l`
idlecpus=`mpstat | tail -1 | \
	awk -v ncpus=$ncpus '{ print ncpus * ($7 + $NF) / 100 }'`
awk -v ncpus=$ncpus -v idlecpus=$idlecpus < /dev/null '
BEGIN {
	cpus2use = idlecpus;
	if (cpus2use < 1)
		cpus2use = 1;
	if (cpus2use < ncpus / 10)
		cpus2use = ncpus / 10;
	if (cpus2use == int(cpus2use))
		cpus2use = int(cpus2use)
	else
		cpus2use = int(cpus2use) + 1
	print cpus2use;
}'

