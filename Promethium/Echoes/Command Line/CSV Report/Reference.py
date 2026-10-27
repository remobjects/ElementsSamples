# CPython oracle for the equivalent row-at-a-time CSV operations.
import csv
import io
rows = ['"North, Bay",open', 'South,closed', 'West,open']
for fields in csv.reader(rows):
    if fields[1] == "open":
        output = io.StringIO(newline="")
        csv.writer(output, lineterminator="").writerow(fields)
        print(output.getvalue())
