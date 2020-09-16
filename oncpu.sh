#!/bin/sh

if [ $# != "3" ]; then
	echo "usage: $0 FREQUENCY DURATION OUT_SVG_FILE"
	exit 1
fi

freq=$1
duration=$2
out_svg_file=$3

perf record -F $freq -ag -- sleep $duration
perf script | stackcollapse-perf.pl | flamegraph.pl > $out_svg_file

rm perf.data
