# Sample: parse quoted CSV fields and write matching records with libPromethium.
import csv

rows = ['"North, Bay",open', 'South,closed', 'West,open']
for line in rows:
    fields: list[str] = csv.parse_line(line)
    if fields[1] == "open":
        print(csv.write_row(fields))
