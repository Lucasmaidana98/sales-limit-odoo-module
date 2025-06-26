from odoo import models, fields, api
from odoo.exceptions import UserError


class SaleOrder(models.Model):
    _inherit = 'sale.order'

    partner_sales_limit = fields.Monetary(
        string='Customer Sales Limit',
        related='partner_id.sales_limit',
        readonly=True,
        currency_field='currency_id'
    )

    def action_confirm(self):
        for order in self:
            if order.partner_id.sales_limit > 0 and order.amount_total > order.partner_id.sales_limit:
                raise UserError(
                    f"Cannot confirm order. Order total ({order.amount_total:.2f} {order.currency_id.symbol}) "
                    f"exceeds customer's sales limit ({order.partner_id.sales_limit:.2f} {order.currency_id.symbol})."
                )
        return super().action_confirm()


class SaleOrderLine(models.Model):
    _inherit = 'sale.order.line'

    product_barcode = fields.Char(
        string='Barcode',
        related='product_id.barcode',
        readonly=True
    )