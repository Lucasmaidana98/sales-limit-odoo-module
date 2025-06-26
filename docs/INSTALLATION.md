# 📦 Guía de Instalación - Sales Limit Odoo Module

Esta guía proporciona instrucciones detalladas para instalar el módulo Sales Limit en Odoo 17.0.

---

## 🔧 Instalación Automática (Recomendada)

### **Opción 1: Script de Instalación**
```bash
# Clonar repositorio
git clone https://github.com/tu-usuario/sales-limit-odoo-module.git
cd sales-limit-odoo-module

# Ejecutar script de instalación
chmod +x scripts/install.sh
./scripts/install.sh

# Iniciar Odoo
./start_odoo.sh
```

---

## ⚙️ Instalación Manual

### **Paso 1: Preparación del Sistema**

#### **Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install -y python3 python3-pip python3-dev python3-venv
sudo apt install -y postgresql postgresql-contrib
sudo apt install -y git wget curl unzip
```

#### **CentOS/RHEL:**
```bash
sudo yum update
sudo yum install -y python3 python3-pip python3-devel
sudo yum install -y postgresql postgresql-server postgresql-contrib
sudo yum install -y git wget curl unzip
```

### **Paso 2: Configurar PostgreSQL**

```bash
# Iniciar servicio PostgreSQL
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Crear usuario de base de datos
sudo -u postgres createuser -d -R -S $USER

# Crear base de datos
sudo -u postgres createdb odoo_sales_limit

# Configurar permisos
sudo -u postgres psql -d odoo_sales_limit -c "GRANT ALL ON SCHEMA public TO $USER;"
```

### **Paso 3: Instalar Dependencias del Sistema**

```bash
sudo apt install -y \
    libxml2-dev libxslt1-dev libevent-dev \
    libsasl2-dev libldap2-dev pkg-config \
    libtiff5-dev libjpeg8-dev libopenjp2-7-dev \
    zlib1g-dev libfreetype6-dev liblcms2-dev \
    libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev
```

### **Paso 4: Obtener Odoo 17.0**

```bash
# Descargar Odoo desde GitHub
git clone https://github.com/odoo/odoo.git --depth 1 --branch 17.0 odoo-17.0
```

### **Paso 5: Configurar Entorno Python**

```bash
# Crear entorno virtual
python3 -m venv odoo_env
source odoo_env/bin/activate

# Actualizar pip
pip install --upgrade pip wheel setuptools

# Instalar dependencias de Odoo
pip install -r odoo-17.0/requirements.txt

# O usar nuestro requirements.txt
pip install -r requirements.txt
```

### **Paso 6: Instalar el Módulo**

```bash
# Copiar módulo a addons de Odoo
cp -r addons/sales_limit_module odoo-17.0/addons/

# Instalar módulo en base de datos
cd odoo-17.0
python odoo-bin -d odoo_sales_limit -i base,sale,sales_limit_module --stop-after-init
```

### **Paso 7: Configurar Odoo**

Crear archivo `odoo.conf`:
```ini
[options]
addons_path = ./odoo-17.0/addons
data_dir = ./data
db_host = localhost
db_port = 5432
db_user = tu_usuario
db_password = False
http_port = 8069
logfile = ./odoo.log
log_level = info
```

### **Paso 8: Iniciar Servidor**

```bash
# Modo desarrollo
python odoo-bin -d odoo_sales_limit --dev=all --http-port=8069

# Modo producción
python odoo-bin -c odoo.conf -d odoo_sales_limit
```

---

## 🐳 Instalación con Docker

### **Paso 1: Crear docker-compose.yml**
```yaml
version: '3.8'
services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: odoo
      POSTGRES_USER: odoo
      POSTGRES_PASSWORD: odoo
    volumes:
      - postgres_data:/var/lib/postgresql/data

  odoo:
    image: odoo:17
    depends_on:
      - db
    ports:
      - "8069:8069"
    environment:
      HOST: db
      USER: odoo
      PASSWORD: odoo
    volumes:
      - ./addons:/mnt/extra-addons
      - odoo_data:/var/lib/odoo

volumes:
  postgres_data:
  odoo_data:
```

### **Paso 2: Ejecutar**
```bash
# Copiar módulo
mkdir -p addons
cp -r addons/sales_limit_module addons/

# Iniciar servicios
docker-compose up -d

# Instalar módulo
docker-compose exec odoo odoo -i sales_limit_module --stop-after-init
```

---

## 🔐 Credenciales por Defecto

### **Base de Datos:**
- **Host:** localhost
- **Puerto:** 5432
- **Base de datos:** odoo_sales_limit
- **Usuario:** tu_usuario_sistema
- **Contraseña:** (sin contraseña por defecto)

### **Aplicación Odoo:**
- **URL:** http://localhost:8069
- **Usuario:** admin
- **Contraseña:** admin

### **Configuración de Permisos:**
Después del primer login, configurar permisos de usuario:
1. Ir a: Configuración → Usuarios → Administrator
2. Pestaña "Permisos de Acceso"
3. **Sales:** Administrator
4. **Invoicing:** Billing
5. **Inventory:** User

---

## ✅ Verificación de Instalación

### **1. Verificar Módulo Instalado**
```bash
# Acceder a Odoo
# Ir a: Aplicaciones → Buscar "Sales Limit"
# Estado: Instalado ✅
```

### **2. Verificar Funcionalidades**
```bash
# 1. Campo en clientes
#    Contactos → [Cliente] → Campo "Sales Limit" visible

# 2. Campo en órdenes
#    Ventas → Órdenes → [Orden] → Campo "Customer Sales Limit"

# 3. Validación
#    Crear orden que exceda límite → Error esperado

# 4. Reporte
#    Imprimir orden → Ver porcentaje de límite
```

### **3. Logs de Verificación**
```bash
# Verificar logs de Odoo
tail -f odoo.log | grep sales_limit

# Verificar en base de datos
psql -d odoo_sales_limit -c "SELECT name FROM ir_module_module WHERE name = 'sales_limit_module';"
```

---

## 🚨 Solución de Problemas Comunes

### **Error: "Module not found"**
```bash
# Verificar que el módulo esté en addons
ls odoo-17.0/addons/sales_limit_module

# Actualizar lista de módulos
python odoo-bin -d odoo_sales_limit -u base --stop-after-init
```

### **Error: "Permission denied for schema public"**
```bash
# Corregir permisos PostgreSQL
sudo -u postgres psql -d odoo_sales_limit -c "GRANT ALL ON SCHEMA public TO $USER;"
```

### **Error: "Port 8069 already in use"**
```bash
# Detener procesos en puerto 8069
sudo fuser -k 8069/tcp

# O usar puerto diferente
python odoo-bin -d odoo_sales_limit --http-port=8070
```

### **Error: "Dependencies not installed"**
```bash
# Reinstalar dependencias
source odoo_env/bin/activate
pip install -r requirements.txt
```

---

## 🔄 Actualización del Módulo

### **Actualizar desde Git**
```bash
# Actualizar repositorio
git pull origin main

# Copiar módulo actualizado
cp -r addons/sales_limit_module odoo-17.0/addons/

# Actualizar en Odoo
python odoo-bin -d odoo_sales_limit -u sales_limit_module --stop-after-init
```

### **Actualizar Manualmente**
```bash
# En Odoo Web UI:
# 1. Ir a: Aplicaciones → Sales Limit Module
# 2. Click "Actualizar"
# 3. Reiniciar servidor si es necesario
```

---

## 📞 Soporte

Si encuentras problemas durante la instalación:

1. **Revisar logs:** `tail -f odoo.log`
2. **Verificar dependencias:** `pip list | grep -E "(odoo|psycopg2|lxml)"`
3. **Consultar documentación:** Ver `docs/TROUBLESHOOTING.md`
4. **Reportar issue:** [GitHub Issues](https://github.com/tu-usuario/sales-limit-odoo-module/issues)

---

## ✨ Próximos Pasos

Después de la instalación exitosa:

1. **Configurar permisos** de usuario
2. **Leer manual de pruebas:** `docs/TESTING.md`
3. **Configurar datos de prueba**
4. **Capacitar usuarios finales**

**¡Instalación completada! 🎉**