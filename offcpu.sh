#!/bin/sh

if [ $# != "2" ]; then
	echo "usage: $0 DURATION OUT_SVG_FILE"
	exit 1
fi

duration=$1
out_svg_file=$2

echo 1 > /proc/sys/kernel/sched_schedstats

# borrowed from Brendan's blog post
# http://www.brendangregg.com/blog/2015-02-26/linux-perf-off-cpu-flame-graph.html
perf record -e sched:sched_stat_sleep -e sched:sched_switch \
	    -e sched:sched_process_exit -a -g -o perf.data.raw sleep $duration

perf inject -v -s -i perf.data.raw -o perf.data

perf script -F comm,pid,tid,cpu,time,period,event,ip,sym,dso,trace | awk '
	NF > 4 { exec = $1; period_ms = int($5 / 1000000) }
	NF > 1 && NF <= 4 && period_ms > 0 { print $2 }
	NF < 2 && period_ms > 0 { printf "%s\n%d\n\n", exec, period_ms }' | \
	stackcollapse.pl | c++filt | \
	flamegraph.pl --countname=ms --title="Off-CPU Time Flame Graph" --colors=io > $out_svg_file

rm perf.data perf.data.raw
