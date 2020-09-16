#!/bin/sh

if [ $# != "4" ]; then
	echo "usage: $0 PROBE_LIB PROBE_FUNCTION DURATION OUT_SVG_FILE"
	exit 1
fi

probe_lib=$1
probe_func=$2
duration=$3
out_svg_file=$4

perf probe -x $probe_lib $probe_func

basename_probe_lib=`basename $probe_lib`
probe_lib_plain_name=`echo $basename_probe_lib | cut -d"." -f1`
perf_new_probe="probe_$probe_lib_plain_name:$probe_func"
perf_parameters="-e $perf_new_probe -ag -- sleep $duration"
perf record $perf_parameters

perf script | stackcollapse-perf.pl | c++filt | \
flamegraph.pl --title "$probe_func count" > $out_svg_file

perf probe -d $perf_new_probe"_"*

rm perf.data
