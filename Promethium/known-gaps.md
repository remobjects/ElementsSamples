# Compatibility gaps observed while preparing the samples

These are short probes of ordinary Python syntax. The five checked-in projects use patterns that compile and run. The cases below did not compile with the `develop-promethium` compiler tested on 27 October 2026; they are potential ship-readiness work, not claims about other targets.

1. **Empty dictionary with a typed annotation.** `counts: dict[str, int] = {}` reports a conversion from `Promethium.Dictionary[Object,Object]` to `Promethium.Dictionary[String,Int32]`. An empty literal has no entries from which to infer key and value types, but the annotation supplies both.
2. **Dictionary indexing.** With `counts: dict[str, int]`, `counts[word] = counts.get(word, 0) + 1` reports that `Promethium.Dictionary[String,Int32]` has no default property. The sample uses `collections.Counter` to avoid this gap.
3. **Filtered list comprehension.** `[book for book in books if book.finished]` reports `No member 'Where' on type 'Promethium.List[Book]'`. The sample uses a normal loop.
4. **Ordinary project module imports.** With `budget.py` and `Program.py` in one `.elements` project, `from budget import total` reports an unknown namespace `budget`. The sample uses a shared `@namespace("trip_budget")` directive and directly references `total`.

These probes should become focused compiler regressions when addressed. The executable samples intentionally stay green so the suite can serve as a release gate.
