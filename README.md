# pd-tools
These scripts use traditional Linux utilities to construct some high-level tools for analysis. They are mainly for performance and debugging. Many of them are mimic to Brendan Gregg's BPF tools and perf-tools. But I try to wrap all utilities I need to have the results I need.

# Dependent tools:

perf
flamegraph.pl

# Tools

"stackcount.sh"
collect stacktraces and user-defined metrics, generate a flamegraph

"oncpu.sh"
collect stacktraces of sampled functions, generate a flamegraph

"offcpu.sh"
collect stacktraces of blocked tasks, generate a flamegraph

...
