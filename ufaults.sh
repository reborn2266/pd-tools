#!/bin/sh

if [ $# != "2" ]; then
	echo "usage: $0 DURATION OUT_SVG_FILE"
	exit 1
fi

duration=$1
out_svg_file=$2

perf record -e exceptions:page_fault_user -ag -- sleep $duration
perf script | stackcollapse-perf.pl | \
flamegraph.pl --countname="times" --title="fault count" > $out_svg_file
