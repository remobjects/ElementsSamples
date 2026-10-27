# Compatibility boundaries

The sample runner reports every target failure and returns a nonzero exit code; it does not filter unsupported targets or treat successful compilation as runtime proof.

- Project filenames do not automatically define Python module namespaces. Trip Budget demonstrates Elements' explicit `@namespace` contract.
- libPromethium JSON, CSV, graph, and binary APIs have typed or explicit helper surfaces. The separate CPython reference scripts validate equivalent results, not API identity.
- Context-manager exception information follows the target's exception model. Native traceback objects are not CPython traceback objects; Island exceptions and arbitrary Cocoa thrown objects have no common traceback API, so their third `__exit__` argument is `None`.
- Native sample projects currently exercise macOS only. Other operating systems and mobile targets need separate execution coverage.

The original empty typed dictionary, dictionary indexing metadata, and filtered-comprehension build failures have regression coverage in the compiler collection tests. Target-specific runtime failures remain release blockers until the complete matrix passes. Do not work around a failing language pattern in a sample merely to make the matrix green.

## Cases that must stay visible in the gate

- JSON Configuration formats a boolean using `"Alerts: {0}".format(...)`. The expected Python spelling is `True`; native formatting currently produces `true` on Cooper and `1` on Toffee. Do not change the expected output to accept these differences.
- Generator Pipeline uses an unannotated generator parameter. Toffee currently rejects the yielded value's `%` operation as `id mod Int32`. Keep the shared source unchanged so this remains a compatibility check.

The full libPromethium test suite is a separate gate. Passing these ten examples does not establish that all library modules or unsupported Python constructs work.
