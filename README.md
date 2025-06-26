# 🚀 Sales Limit Odoo Module

Un módulo personalizado de Odoo 17.0 que implementa límites de ventas por cliente con validaciones automáticas y reportes mejorados.

## 📋 Funcionalidades

### ✅ **Campo de Límite de Ventas en Clientes**
- Nuevo campo `sales_limit` en el modelo `res.partner`
- Visible solo para empresas
- Tipo Monetary con soporte para múltiples monedas

### ✅ **Visualización en Órdenes de Venta**
- Muestra el límite del cliente en la cabecera de la orden
- Campo relacionado `partner_sales_limit` 
- Se oculta automáticamente si el cliente no tiene límite

### ✅ **Código de Barras en Líneas**
- Campo `product_barcode` en líneas de orden de venta
- Muestra el código de barras del producto seleccionado
- Columna opcional en las vistas de líneas

### ✅ **Validación Automática**
- Previene confirmación de órdenes que excedan el límite
- Método `action_confirm()` sobrescrito con validación
- Mensaje de error claro indicando el problema

### ✅ **Reportes Mejorados**
- Cálculo automático del porcentaje de límite utilizado
- Sección "Credit Limit Information" en reportes PDF
- Ejemplo: "Credit Limit Usage: 29% of available limit"

---

## 🛠️ Instalación

### **Prerrequisitos**
- Odoo 17.0
- PostgreSQL 12+
- Python 3.8+

### **Paso 1: Clonar el Repositorio**
```bash
git clone https://github.com/tu-usuario/sales-limit-odoo-module.git
cd sales-limit-odoo-module
```

### **Paso 2: Configurar Base de Datos**
```bash
# Crear usuario PostgreSQL
sudo -u postgres createuser -d -R -S tu_usuario

# Crear base de datos
sudo -u postgres createdb odoo_sales_limit

# Configurar permisos
sudo -u postgres psql -d odoo_sales_limit -c "GRANT ALL ON SCHEMA public TO tu_usuario;"
```

### **Paso 3: Instalar Dependencias**
```bash
# Crear entorno virtual
python3 -m venv odoo_env
source odoo_env/bin/activate

# Instalar dependencias
pip install -r requirements.txt
```

### **Paso 4: Configurar Odoo**
```bash
# Copiar módulo a addons de Odoo
cp -r addons/sales_limit_module /path/to/odoo/addons/

# Instalar módulo
python odoo-bin -d odoo_sales_limit -i sales_limit_module --stop-after-init

# Iniciar servidor
python odoo-bin -d odoo_sales_limit --dev=all
```

---

## 🔐 Credenciales de Acceso

### **Base de Datos**
- **Host:** localhost
- **Puerto:** 5432
- **Base de datos:** odoo_sales_limit
- **Usuario:** tu_usuario (configurado en instalación)

### **Aplicación Web**
- **URL:** http://localhost:8069
- **Usuario:** admin
- **Contraseña:** admin

### **Permisos Requeridos**
El usuario admin necesita los siguientes permisos:
- **Sales:** Administrator
- **Invoicing:** Billing
- **Inventory:** User

---

## 🧪 Pruebas Manuales

### **1. Crear Cliente con Límite**
1. Ir a: `Contactos → Crear`
2. Nombre: "Empresa Test S.A."
3. Marcar ✅ "Es una empresa"
4. Campo "Sales Limit": 15000
5. Guardar

### **2. Crear Producto con Código de Barras**
1. Ir a: `Inventario → Productos → Crear`
2. Nombre: "Laptop Test"
3. Precio de venta: 1000
4. Código de barras: 1234567890123
5. Guardar

### **3. Prueba Exitosa (Orden Dentro del Límite)**
1. Ir a: `Ventas → Órdenes → Crear`
2. Cliente: "Empresa Test S.A."
3. **Verificar:** Campo "Customer Sales Limit: 15,000.00"
4. Agregar producto: Laptop Test, Cantidad: 4
5. Total: $4,000 (26.7% del límite)
6. Confirmar → ✅ **Debe funcionar**

### **4. Prueba de Validación (Error Esperado)**
1. Crear nueva orden con mismo cliente
2. Agregar producto: Laptop Test, Cantidad: 20
3. Total: $20,000 (133% del límite)
4. Confirmar → ❌ **Error:** "Order total exceeds customer's sales limit"

### **5. Verificar Reporte**
1. Imprimir orden de venta
2. **Verificar:** Sección "Credit Limit Information"
3. **Ver:** Cálculo automático del porcentaje

---

## 📁 Estructura del Proyecto

```
sales-limit-odoo-module/
├── addons/
│   └── sales_limit_module/
│       ├── __manifest__.py          # Configuración del módulo
│       ├── __init__.py             # Inicialización
│       ├── models/
│       │   ├── __init__.py
│       │   ├── res_partner.py      # Campo sales_limit
│       │   └── sale_order.py       # Validación y campos relacionados
│       ├── views/
│       │   ├── res_partner_views.xml   # Vista del cliente
│       │   └── sale_order_views.xml    # Vista de órdenes
│       └── reports/
│           └── sale_order_report.xml   # Template del reporte
├── scripts/
│   └── install.sh                  # Script de instalación automática
├── docs/
│   ├── INSTALLATION.md            # Guía detallada de instalación
│   ├── TESTING.md                 # Manual de pruebas
│   └── TROUBLESHOOTING.md         # Solución de problemas
├── requirements.txt               # Dependencias Python
└── README.md                     # Este archivo
```

---

## 🔧 Campos Técnicos

### **Nuevos Campos Agregados:**
- `res.partner.sales_limit` (Monetary): Límite de ventas del cliente
- `sale.order.partner_sales_limit` (related): Límite visible en orden
- `sale.order.line.product_barcode` (related): Código de barras del producto

### **Métodos Sobrescritos:**
- `sale.order.action_confirm()`: Validación de límites antes de confirmar

### **Validaciones Implementadas:**
```python
if order.partner_id.sales_limit > 0 and order.amount_total > order.partner_id.sales_limit:
    raise UserError("Order total exceeds customer's sales limit")
```

---

## 🆘 Solución de Problemas

### **Error: "You are not allowed to access 'Sales Order'"**
**Solución:** Configurar permisos de usuario
1. Ir a: Configuración → Usuarios → Administrator
2. Pestaña "Permisos de Acceso"
3. Sales: Administrator
4. Invoicing: Billing

### **Error: "Cannot locate xpath in view"**
**Solución:** El módulo está diseñado para Odoo 17.0. Verificar versión.

### **Servidor no inicia**
**Solución:** Verificar dependencias
```bash
source odoo_env/bin/activate
pip install -r requirements.txt
```

---

## 🤝 Contribuciones

1. Fork el proyecto
2. Crear rama feature (`git checkout -b feature/nueva-funcionalidad`)
3. Commit cambios (`git commit -am 'Agregar nueva funcionalidad'`)
4. Push a la rama (`git push origin feature/nueva-funcionalidad`)
5. Abrir Pull Request

---

## 📄 Licencia

Este proyecto está bajo la Licencia LGPL-3 - ver el archivo [LICENSE](LICENSE) para detalles.

---

## 📞 Soporte

- **Issues:** [GitHub Issues](https://github.com/tu-usuario/sales-limit-odoo-module/issues)
- **Documentación:** Ver carpeta `docs/`
- **Email:** soporte@tuempresa.com

---

## 🎯 Resultados de Pruebas

| Funcionalidad | Estado | Probado |
|---------------|--------|---------|
| Campo límite en cliente | ✅ | ✅ |
| Límite visible en orden | ✅ | ✅ |
| Barcode en líneas | ✅ | ✅ |
| Validación al confirmar | ✅ | ✅ |
| Porcentaje en reporte | ✅ | ✅ |

**¡Todas las funcionalidades implementadas y probadas exitosamente! 🎉**