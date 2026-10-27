# CPython oracle for the equivalent JSON configuration operations.
import json
settings = json.loads('{"name":"Coast Watch","retries":3,"alerts":true}')
print(settings["name"])
print("Retries: {0}".format(settings["retries"]))
print("Alerts: {0}".format(settings["alerts"]))
