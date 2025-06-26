# Sales Limit Module

## Description
This Odoo module adds sales limit functionality to control customer purchases and provides enhanced visibility in sales orders.

## Features

### 1. Customer Sales Limit
- Adds a "Sales Limit" field to customer records (res.partner)
- Allows setting a maximum sales amount per customer

### 2. Sales Order Enhancements
- Displays customer's sales limit in the sale order header
- Shows product barcodes in sale order lines
- Provides better visibility of customer credit information

### 3. Sales Validation
- Validates orders against customer sales limits during confirmation
- Prevents order confirmation if total exceeds customer's sales limit
- Shows clear error message when limit is exceeded

### 4. Enhanced Reporting
- Includes credit limit usage percentage in sale order reports
- Shows customer sales limit, order total, and percentage used
- Example: "Credit Limit Usage: 29% of available limit"

## Installation

1. Copy the `sales_limit_module` folder to your Odoo addons directory
2. Restart your Odoo server
3. Go to Apps menu in Odoo
4. Update the apps list
5. Search for "Sales Limit Module"
6. Install the module

## Usage

### Setting Customer Sales Limits
1. Go to Contacts
2. Open a customer record
3. Set the "Sales Limit" field to the desired amount
4. Save the record

### Creating Sales Orders
1. Create a new sales order
2. Select a customer with a sales limit
3. The customer's sales limit will be displayed in the header
4. Product barcodes will be visible in order lines
5. When confirming the order, the system will validate against the sales limit

### Viewing Reports
1. Print or preview a sales order report
2. If the customer has a sales limit, you'll see:
   - Customer Sales Limit amount
   - Order Total amount
   - Credit Limit Usage percentage

## Technical Details

### Models Extended
- `res.partner`: Added `sales_limit` field
- `sale.order`: Added `partner_sales_limit` field and validation
- `sale.order.line`: Added `product_barcode` field

### Views Modified
- Customer form view: Added sales limit field
- Sale order form view: Added sales limit display and barcode column
- Sale order report: Added credit limit information section

## Dependencies
- base
- sale
- sale_management

## Version
17.0.1.0.0 (Compatible with Odoo 17.0)