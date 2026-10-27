# Sample: order build steps using libPromethium's generic topological sorter.
from graphlib import TopologicalSorter

plan: TopologicalSorter[str] = TopologicalSorter[str]()
plan.add("download")
plan.add("unpack", ["download"])
plan.add("compile", ["unpack"])
plan.add("package", ["compile"])
for step in plan.static_order():
    print(step)
