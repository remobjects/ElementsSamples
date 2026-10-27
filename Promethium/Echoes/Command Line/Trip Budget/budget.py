# Sample support: typed functions, a default parameter, and a loop.
@namespace("trip_budget")

def total(costs: list[int]) -> int:
    result: int = 0
    for cost in costs:
        result += cost
    return result


def with_tax(amount: int, percent: int = 0) -> int:
    return amount + amount * percent // 100
