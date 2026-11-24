#!/usr/bin/env python3
"""Build and run Myth samples and behavioral guards with Elements, comparing exact output."""
import argparse
import json
from pathlib import Path
import subprocess
import tempfile


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--ebuild', required=True, type=Path, help='EBuild executable, .dll or .exe')
    parser.add_argument('--compiler', type=Path, help='Optional RemObjects.Elements.dll override')
    parser.add_argument('--target', nargs='+', choices=['Echoes', 'Cooper', 'Toffee', 'Island'],
                        default=['Echoes'])
    parser.add_argument('--configuration', nargs='+', choices=['Debug', 'Release'],
                        default=['Debug', 'Release'])
    parser.add_argument('--sample', help='Optional project name, e.g. WordFrequency or BehaviorTests')
    parser.add_argument('--java', default='java', help='Java executable for Cooper')
    parser.add_argument('--output', type=Path, help='New directory for binaries, logs and results')
    args = parser.parse_args()
    root = Path(__file__).resolve().parent
    output = args.output.resolve() if args.output else Path(tempfile.mkdtemp(prefix='myth-samples-'))
    if args.output:
        output.mkdir(parents=True, exist_ok=False)
    engine = args.ebuild.resolve()
    command = (['dotnet'] if engine.suffix == '.dll' else
               ['mono'] if engine.suffix == '.exe' else []) + [str(engine)]
    results = []
    for target in args.target:
        projects = sorted((root / target / 'Command Line').glob('*/*.elements'))
        projects += sorted((root / 'Tests' / target).glob('*.elements'))
        if args.sample:
            projects = [p for p in projects if p.stem == args.sample]
        if not projects:
            parser.error('No projects matched for ' + target)
        for configuration in args.configuration:
            for project in projects:
                name = project.stem
                work = output / target / configuration / name
                work.mkdir(parents=True)
                row = dict(target=target, configuration=configuration, sample=name, passed=False)
                build = command + [str(project), '--rebuild', '--configuration:' + configuration,
                                   '--output-folder:' + str(work / 'bin'),
                                   '--intermediatebasefolder:' + str(work / 'obj')]
                if args.compiler:
                    build.append('--setting:EBuild:ElementsCompilerDll=' + str(args.compiler.resolve()))
                try:
                    with (work / 'build.log').open('w') as log:
                        result = subprocess.run(build, stdout=log, stderr=subprocess.STDOUT, timeout=180)
                    row['build_exit'] = result.returncode
                    if result.returncode == 0:
                        suffix = '.dll' if target == 'Echoes' else '.jar' if target == 'Cooper' else ''
                        matches = list((work / 'bin').rglob(name + suffix))
                        if len(matches) != 1:
                            raise RuntimeError('Expected one executable; found ' + str(matches))
                        run = (['dotnet'] if target == 'Echoes' else
                               [args.java, '-jar'] if target == 'Cooper' else []) + [str(matches[0])]
                        result = subprocess.run(run, capture_output=True, text=True, timeout=30)
                        (work / 'stdout.txt').write_text(result.stdout)
                        (work / 'stderr.txt').write_text(result.stderr)
                        expected = '' if name == 'BehaviorTests' else (
                            root / 'All' / 'Command Line' / project.parent.name / 'expected-output.txt').read_text()
                        row.update(run_exit=result.returncode,
                                   output_matches=result.stdout.replace('\r\n', '\n') == expected,
                                   stderr_empty=not result.stderr)
                        row['passed'] = result.returncode == 0 and row['output_matches'] and row['stderr_empty']
                except (OSError, RuntimeError, subprocess.TimeoutExpired) as error:
                    row['error'] = str(error)
                results.append(row)
                print(('PASS' if row['passed'] else 'FAIL'), target, configuration, name, flush=True)
                (output / 'results.json').write_text(json.dumps(results, indent=2) + '\n')
    print('Results:', output)
    return 0 if all(row['passed'] for row in results) else 1


if __name__ == '__main__':
    raise SystemExit(main())
