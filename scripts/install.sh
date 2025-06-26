#!/bin/bash

# Sales Limit Odoo Module - Installation Script
# Compatible with Ubuntu/Debian and Odoo 17.0

set -e

echo "🚀 Starting Sales Limit Odoo Module Installation"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Configuration
DB_NAME="odoo_sales_limit"
DB_USER="$USER"
ODOO_USER="$USER"
ODOO_DIR="$(pwd)/odoo-17.0"
VENV_DIR="$(pwd)/odoo_env"

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "This script should not be run as root"
   exit 1
fi

# Step 1: Update system packages
print_status "Step 1: Updating system packages..."
sudo apt update
sudo apt install -y python3 python3-pip python3-dev python3-venv git wget curl unzip

# Step 2: Install PostgreSQL
print_status "Step 2: Installing PostgreSQL..."
sudo apt install -y postgresql postgresql-contrib

# Start PostgreSQL service
print_status "Starting PostgreSQL service..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Step 3: Create PostgreSQL user and database
print_status "Step 3: Configuring PostgreSQL..."

# Create user if not exists
sudo -u postgres psql -c "SELECT 1 FROM pg_user WHERE usename = '$DB_USER'" | grep -q 1 || \
sudo -u postgres createuser -d -R -S "$DB_USER"

# Create database if not exists
sudo -u postgres psql -lqt | cut -d \| -f 1 | grep -qw "$DB_NAME" || \
sudo -u postgres createdb "$DB_NAME"

# Grant permissions
sudo -u postgres psql -d "$DB_NAME" -c "GRANT ALL ON SCHEMA public TO $DB_USER;"

print_status "PostgreSQL configured successfully"

# Step 4: Install system dependencies for Odoo
print_status "Step 4: Installing Odoo system dependencies..."
sudo apt install -y \
    libxml2-dev libxslt1-dev libevent-dev \
    libsasl2-dev libldap2-dev pkg-config \
    libtiff5-dev libjpeg8-dev libopenjp2-7-dev \
    zlib1g-dev libfreetype6-dev liblcms2-dev \
    libwebp-dev libharfbuzz-dev libfribidi-dev libxcb1-dev

# Step 5: Download Odoo 17.0
if [ ! -d "$ODOO_DIR" ]; then
    print_status "Step 5: Downloading Odoo 17.0..."
    git clone https://github.com/odoo/odoo.git --depth 1 --branch 17.0 "$ODOO_DIR"
else
    print_warning "Odoo directory already exists, skipping download"
fi

# Step 6: Create Python virtual environment
print_status "Step 6: Creating Python virtual environment..."
python3 -m venv "$VENV_DIR"
source "$VENV_DIR/bin/activate"

# Step 7: Install Python dependencies
print_status "Step 7: Installing Python dependencies..."
pip install --upgrade pip wheel setuptools
pip install -r requirements.txt

# Step 8: Copy sales_limit_module to Odoo addons
print_status "Step 8: Installing Sales Limit Module..."
cp -r addons/sales_limit_module "$ODOO_DIR/addons/"

# Step 9: Install the module in Odoo
print_status "Step 9: Installing module in Odoo database..."
cd "$ODOO_DIR"
python odoo-bin -d "$DB_NAME" -i base,sale,sales_limit_module --stop-after-init

# Step 10: Create startup script
print_status "Step 10: Creating startup script..."
cat > "../start_odoo.sh" << EOF
#!/bin/bash
cd "$ODOO_DIR"
source "$VENV_DIR/bin/activate"
python odoo-bin -d "$DB_NAME" --dev=all --http-port=8069
EOF

chmod +x "../start_odoo.sh"

# Step 11: Create configuration file
print_status "Step 11: Creating Odoo configuration..."
cat > "../odoo.conf" << EOF
[options]
addons_path = $ODOO_DIR/addons
data_dir = $(pwd)/data
db_host = localhost
db_port = 5432
db_user = $DB_USER
db_password = False
http_port = 8069
logfile = $(pwd)/odoo.log
log_level = info
EOF

echo ""
echo "🎉 Installation completed successfully!"
echo "======================================"
echo ""
echo "📋 Next Steps:"
echo "1. Start Odoo server:"
echo "   ./start_odoo.sh"
echo ""
echo "2. Access Odoo:"
echo "   URL: http://localhost:8069"
echo "   User: admin"
echo "   Password: admin"
echo ""
echo "📊 Database Information:"
echo "   Database: $DB_NAME"
echo "   User: $DB_USER"
echo "   Host: localhost"
echo "   Port: 5432"
echo ""
echo "🔧 Configuration:"
echo "   Odoo Dir: $ODOO_DIR"
echo "   Virtual Env: $VENV_DIR"
echo "   Config File: ../odoo.conf"
echo ""
echo "🧪 Testing:"
echo "   See docs/TESTING.md for manual testing guide"
echo ""
print_status "Ready to use! 🚀"