from odoo import models, fields


class ResPartner(models.Model):
    _inherit = 'res.partner'

    sales_limit = fields.Monetary(
        string='Sales Limit',
        currency_field='currency_id',
        help='Maximum sales amount allowed for this customer'
    )