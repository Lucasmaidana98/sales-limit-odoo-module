# 🧪 Manual de Pruebas - Sales Limit Odoo Module

Esta guía proporciona casos de prueba detallados para verificar todas las funcionalidades del módulo.

---

## 🔐 Acceso al Sistema

### **Credenciales de Prueba**
- **URL:** http://localhost:8069
- **Usuario:** admin
- **Contraseña:** admin

### **Configuración Inicial de Permisos**
1. Acceder al sistema con admin/admin
2. Ir a: **Configuración** ⚙️ → **Usuarios y Empresas** → **Usuarios**
3. Click en **"Administrator"**
4. Pestaña **"Permisos de Acceso"**
5. Configurar:
   - **Sales:** Administrator
   - **Invoicing:** Billing  
   - **Inventory:** User
6. **Guardar** y hacer **logout/login**

---

## 📋 Casos de Prueba

### **🎯 Caso 1: Campo de Límite de Ventas en Clientes**

#### **Objetivo:** Verificar que el campo sales_limit aparece correctamente en el formulario de clientes

#### **Pasos:**
1. Ir a: **Contactos** → **Crear**
2. Completar datos básicos:
   - **Nombre:** "Empresa Test S.A."
   - **Email:** test@empresa.com
3. Marcar ✅ **"Es una empresa"**
4. **Verificar:** Campo **"Sales Limit"** aparece
5. Ingresar valor: **15000**
6. **Guardar**

#### **Resultado Esperado:**
- ✅ Campo "Sales Limit" visible solo para empresas
- ✅ Campo acepta valores monetarios
- ✅ Campo se guarda correctamente

#### **Criterios de Aceptación:**
- [ ] Campo visible para empresas
- [ ] Campo oculto para personas individuales
- [ ] Valor se almacena correctamente

---

### **🎯 Caso 2: Visualización en Órdenes de Venta**

#### **Objetivo:** Verificar que el límite del cliente aparece en la cabecera de órdenes de venta

#### **Pasos:**
1. Ir a: **Ventas** → **Órdenes** → **Crear**
2. Seleccionar **Cliente:** "Empresa Test S.A."
3. **Verificar:** Campo **"Customer Sales Limit"** visible con valor 15,000.00
4. Cambiar a cliente sin límite
5. **Verificar:** Campo se oculta

#### **Resultado Esperado:**
- ✅ Límite se muestra automáticamente
- ✅ Campo se oculta para clientes sin límite
- ✅ Valor corresponde al configurado en el cliente

#### **Criterios de Aceptación:**
- [ ] Campo visible con clientes que tienen límite
- [ ] Campo oculto con clientes sin límite
- [ ] Valor correcto del límite

---

### **🎯 Caso 3: Código de Barras en Líneas de Venta**

#### **Prerequisito:** Crear producto con código de barras

#### **Preparación:**
1. Ir a: **Inventario** → **Productos** → **Crear**
2. Datos del producto:
   - **Nombre:** "Laptop Test"
   - **Precio de venta:** 1000
   - **Código de barras:** 1234567890123
3. **Guardar**

#### **Pasos de Prueba:**
1. En orden de venta (Caso 2)
2. Agregar línea de producto
3. Seleccionar **Producto:** "Laptop Test"
4. **Cantidad:** 4
5. **Verificar:** Código de barras visible en línea

#### **Resultado Esperado:**
- ✅ Código de barras "1234567890123" visible
- ✅ Código se actualiza automáticamente al cambiar producto
- ✅ Campo es de solo lectura

#### **Criterios de Aceptación:**
- [ ] Código de barras visible en líneas
- [ ] Código correcto del producto
- [ ] Campo de solo lectura

---

### **🎯 Caso 4: Validación Exitosa (Dentro del Límite)**

#### **Objetivo:** Verificar que órdenes dentro del límite se confirman correctamente

#### **Pasos:**
1. Continuar con orden del Caso 3
2. **Verificar totales:**
   - Cantidad: 4
   - Precio unitario: 1000
   - **Total:** 4,000
   - **Límite cliente:** 15,000
3. Click **"Confirmar"**
4. **Verificar:** Orden se confirma exitosamente

#### **Resultado Esperado:**
- ✅ Orden cambia a estado "Confirmado"
- ✅ No se muestra error
- ✅ Proceso continúa normalmente

#### **Cálculo de Porcentaje:**
- Total: $4,000
- Límite: $15,000
- Porcentaje: 26.7%

#### **Criterios de Aceptación:**
- [ ] Orden se confirma sin errores
- [ ] Estado cambia a "Sale Order"
- [ ] Proceso de venta continúa

---

### **🎯 Caso 5: Validación de Error (Excede el Límite)**

#### **Objetivo:** Verificar que el sistema previene confirmación de órdenes que excedan el límite

#### **Pasos:**
1. Crear **nueva orden** con mismo cliente
2. Agregar producto "Laptop Test"
3. **Cantidad:** 20 (Total: $20,000)
4. **Verificar:** Total excede límite de $15,000
5. Intentar **"Confirmar"**
6. **Verificar:** Sistema muestra error

#### **Resultado Esperado:**
- ❌ **Error esperado:** "Cannot confirm order. Order total (20,000.00 USD) exceeds customer's sales limit (15,000.00 USD)."
- ✅ Orden NO se confirma
- ✅ Usuario recibe mensaje claro

#### **Cálculo de Porcentaje:**
- Total: $20,000
- Límite: $15,000
- Porcentaje: 133.3% (EXCEDE)

#### **Criterios de Aceptación:**
- [ ] Error mostrado correctamente
- [ ] Orden no se confirma
- [ ] Mensaje incluye montos específicos

---

### **🎯 Caso 6: Porcentaje en Reportes**

#### **Objetivo:** Verificar cálculo de porcentaje en reportes PDF

#### **Pasos:**
1. Usar orden confirmada del Caso 4
2. Click **"Imprimir"** → **"Sale Order"**
3. **Verificar** en reporte PDF:
   - Sección **"Credit Limit Information"**
   - Customer Sales Limit: $15,000.00
   - Order Total: $4,000.00
   - Credit Limit Usage: 27% of available limit

#### **Resultado Esperado:**
- ✅ Sección aparece en reporte
- ✅ Cálculo correcto: (4000/15000)*100 = 26.7% ≈ 27%
- ✅ Formato claro y legible

#### **Criterios de Aceptación:**
- [ ] Sección "Credit Limit Information" presente
- [ ] Cálculo matemático correcto
- [ ] Formato profesional

---

### **🎯 Caso 7: Cliente sin Límite**

#### **Objetivo:** Verificar comportamiento con clientes sin límite configurado

#### **Pasos:**
1. Crear cliente **"Cliente Sin Límite"**
2. **NO** configurar sales_limit (dejar en 0)
3. Crear orden de venta con este cliente
4. Agregar producto por $50,000
5. Confirmar orden

#### **Resultado Esperado:**
- ✅ Campo "Customer Sales Limit" no aparece
- ✅ Orden se confirma sin restricciones
- ✅ Reporte no muestra sección de límite

#### **Criterios de Aceptación:**
- [ ] Sin restricciones para clientes sin límite
- [ ] Campos relacionados ocultos
- [ ] Funcionalidad estándar mantiene

---

## 📊 Matriz de Pruebas

| Caso | Funcionalidad | Entrada | Resultado Esperado | Estado |
|------|---------------|---------|-------------------|---------|
| 1 | Campo en cliente | Empresa con límite $15,000 | Campo visible y editable | ⬜ |
| 2 | Límite en orden | Cliente con límite | Campo "Customer Sales Limit" visible | ⬜ |
| 3 | Barcode en líneas | Producto con código | Código visible en línea | ⬜ |
| 4 | Validación OK | Orden $4,000 vs límite $15,000 | Confirmación exitosa | ⬜ |
| 5 | Validación Error | Orden $20,000 vs límite $15,000 | Error de validación | ⬜ |
| 6 | Reporte PDF | Orden confirmada | Porcentaje 27% calculado | ⬜ |
| 7 | Sin límite | Cliente sin restricción | Funcionalidad estándar | ⬜ |

---

## 🔧 Pruebas Técnicas Adicionales

### **Prueba de Base de Datos**
```sql
-- Verificar campo agregado
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'res_partner' AND column_name = 'sales_limit';

-- Verificar datos de prueba
SELECT name, sales_limit 
FROM res_partner 
WHERE sales_limit > 0;
```

### **Prueba de Logs**
```bash
# Verificar logs de instalación
grep -i "sales_limit" odoo.log

# Verificar módulo cargado
grep -i "Loading module sales_limit_module" odoo.log
```

### **Prueba de Permisos**
```bash
# Verificar permisos en base de datos
psql -d odoo_sales_limit -c "\dp res_partner"
```

---

## 🎯 Escenarios de Edge Cases

### **Edge Case 1: Límite = 0**
- Cliente con sales_limit = 0
- Comportamiento: Sin restricciones

### **Edge Case 2: Múltiples Monedas**
- Cliente en EUR, orden en USD
- Comportamiento: Conversión automática

### **Edge Case 3: Orden Modificada**
- Orden confirmada, luego modificada
- Comportamiento: Re-validar al guardar

### **Edge Case 4: Descuentos**
- Orden con descuentos aplicados
- Comportamiento: Validar sobre total final

---

## 📝 Reporte de Pruebas

### **Template de Reporte**
```
Fecha: ___________
Probado por: ___________
Versión: Odoo 17.0 + Sales Limit Module

Casos Ejecutados: ___/7
Casos Exitosos: ___/7
Casos Fallidos: ___/7

Observaciones:
_________________________________
_________________________________

Issues Encontrados:
_________________________________
_________________________________

Estado General: [ ] PASS [ ] FAIL
```

---

## ✅ Checklist Final

Marcar como completado cuando todas las pruebas pasen:

- [ ] **Instalación:** Módulo instalado correctamente
- [ ] **Permisos:** Usuario admin tiene permisos de Sales
- [ ] **Campo Cliente:** sales_limit visible y funcional
- [ ] **Campo Orden:** partner_sales_limit visible cuando aplica
- [ ] **Validación:** Previene órdenes que excedan límite
- [ ] **Reportes:** Porcentaje calculado correctamente
- [ ] **Edge Cases:** Comportamiento correcto en casos límite

**✨ ¡Todas las pruebas completadas exitosamente! El módulo está listo para producción. 🚀**