#!/bin/bash

parts="front base both"

for part in $parts; do
	echo "I'm doing my $part..."
	openscad  indicator_slots.scad -o export/indicator_slots_$part.stl -D show=\"$part\"
done
