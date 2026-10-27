# Sample: verify context-manager entry, exit, exceptions, and suppression.
events: list[str] = ["start"]


class TrackedSession:
    name: str
    swallow: bool

    def __init__(self, name: str, swallow: bool = False):
        self.name = name
        self.swallow = swallow

    def __enter__(self):
        global events
        events.append("enter " + self.name)
        return self

    def __exit__(self, exc_type, exc_value, traceback) -> bool:
        global events
        if exc_value is None:
            events.append("exit " + self.name + " clean")
        else:
            events.append("exit " + self.name + " error")
        return self.swallow


with TrackedSession("outer"):
    with TrackedSession("inner"):
        events.append("work")

try:
    with TrackedSession("failed"):
        raise ValueError("boom")
except ValueError:
    events.append("caught")

with TrackedSession("handled", True):
    raise ValueError("ignored")

for event in events:
    print(event)
