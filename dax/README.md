### Total Revenue
```DAX
Total Revenue =
SUMX(
    order_items,
    order_items[quantity] *
    order_items[unit_price] *
    (1 - order_items[discount_pct])
)
```

### Completed Revenue
```DAX
Completed Revenue =
CALCULATE(
    [Total Revenue],
    orders[order_status] = "Completed"
)
```
