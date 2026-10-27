# CPython oracle: native graphlib uses variadic predecessors.
from graphlib import TopologicalSorter
plan = TopologicalSorter()
plan.add("download")
plan.add("unpack", "download")
plan.add("compile", "unpack")
plan.add("package", "compile")
for step in plan.static_order():
    print(step)
