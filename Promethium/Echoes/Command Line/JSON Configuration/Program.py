# Sample: inspect configuration through libPromethium's typed JSON tree.
import json
from collections import OrderedDict

config: json.JsonValueNode = json.loads('{"name":"Coast Watch","retries":3,"alerts":true}')
settings: OrderedDict[str, json.JsonValueNode] = config.as_object()
print(settings["name"].as_string())
print("Retries: {0}".format(settings["retries"].as_int()))
print("Alerts: {0}".format(settings["alerts"].as_bool()))
