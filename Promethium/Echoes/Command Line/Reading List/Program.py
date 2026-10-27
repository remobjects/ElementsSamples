# Sample: use classes, a property, defaults, lists, loops, and totals.
class Book:
    title: str
    pages: int
    finished: bool

    def __init__(self, title: str, pages: int, finished: bool = False):
        self.title = title
        self.pages = pages
        self.finished = finished

    @property
    def label(self) -> str:
        return "{0} ({1} pages)".format(self.title, self.pages)


books = [
    Book("Coastal Maps", 220, True),
    Book("Tide Pools", 180),
    Book("Night Sky", 310),
]
finished_pages: int = 0
for book in books:
    if book.finished:
        finished_pages += book.pages
    else:
        print(book.label)
print("Finished pages: {0}".format(finished_pages))
