# Dataset Documentation

## Overview

This project uses a retail analytics dataset containing customer, order, product, regional, and transaction-level information.

The data was modeled in Power BI using the following tables:

- `customers`
- `orders`
- `order_items`
- `products`
- `regions`
- `Date`

## Table Purpose

### customers
Contains customer-level information used for customer segmentation and customer analysis.

### orders
Contains order-level information including customer, order date, channel, payment method, order status, and region.

### order_items
Contains line-item-level transaction data including products, quantity, unit price, and discounts.

### products
Contains product information used for category-level analysis.

### regions
Contains regional information used for geographic performance analysis.

### Date
Calendar table used for time filtering and year-over-year calculations.

## Data Model

The tables are connected through relational keys to support analysis across:

- Customers
- Orders
- Products
- Revenue
- Customer segments
- Sales channels
- Regions
- Time periods

## Data Usage

The dataset is used for portfolio and analytical demonstration purposes.
