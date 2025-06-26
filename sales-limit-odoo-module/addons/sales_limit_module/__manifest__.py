{
    'name': 'Sales Limit Module',
    'version': '17.0.1.0.0',
    'depends': ['base', 'sale', 'sale_management'],
    'author': 'Custom Development',
    'category': 'Sales',
    'description': """
        Sales Limit Module
        ==================
        
        This module adds the following features:
        - Customer sales limit field
        - Sales limit display in sale orders
        - Product barcode in sale order lines
        - Sales limit validation on order confirmation
        - Credit limit percentage in sale order reports
    """,
    'data': [
        'views/res_partner_views.xml',
        'views/sale_order_views.xml',
        'reports/sale_order_report.xml',
    ],
    'installable': True,
    'auto_install': False,
    'application': False,
}