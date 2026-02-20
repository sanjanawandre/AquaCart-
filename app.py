from flask import Flask, request, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_cors import CORS
from flask_bcrypt import Bcrypt
import jwt
import datetime
import os

# --- App Config ---
app = Flask(__name__)
CORS(app)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///aquacart.db'
app.config['SECRET_KEY'] = 'your_secret_key_here'

db = SQLAlchemy(app)
bcrypt = Bcrypt(app)

# --- Database Models ---
class User(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(150), unique=True, nullable=False)
    password = db.Column(db.String(150), nullable=False)
    role = db.Column(db.String(50), nullable=False)  # admin, seller, customer
    status = db.Column(db.String(50), nullable=False, default='pending')  # new column for approval

class Product(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(150), nullable=False)
    price = db.Column(db.Float, nullable=False)
    stock = db.Column(db.Integer, nullable=False)
    seller_id = db.Column(db.Integer, db.ForeignKey('user.id'), nullable=True)

class Order(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    product_id = db.Column(db.Integer, db.ForeignKey('product.id'))
    customer_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    quantity = db.Column(db.Integer, nullable=False)
    status = db.Column(db.String(50), default='Pending')  # Pending, Shipped, Delivered

# --- Helper: decode token ---
def decode_token(token):
    if not token:
        return None
    if token.startswith("Bearer "):
        token = token.split(" ")[1]
    return jwt.decode(token, app.config['SECRET_KEY'], algorithms=["HS256"])

# --- Routes ---
@app.route('/')
def index():
    return "AquaCart Backend Running"

# --- Register ---
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')
    role = data.get('role')

    if User.query.filter_by(email=email).first():
        return jsonify({"success": False, "message": "Email already exists"}), 400

    hashed_password = bcrypt.generate_password_hash(password).decode('utf-8')
    new_user = User(email=email, password=hashed_password, role=role, status="pending")
    db.session.add(new_user)
    db.session.commit()
    return jsonify({"success": True, "message": "User registered successfully"})

# --- Login ---
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    email = data.get('email')
    password = data.get('password')

    user = User.query.filter_by(email=email).first()
    if user and bcrypt.check_password_hash(user.password, password):
        token = jwt.encode({
            'user_id': user.id,
            'role': user.role,
            'exp': datetime.datetime.utcnow() + datetime.timedelta(hours=24)
        }, app.config['SECRET_KEY'], algorithm="HS256")
        return jsonify({"success": True, "role": user.role, "token": token, "user_id": user.id})

    return jsonify({"success": False, "message": "Invalid credentials"}), 401

# --- Approve User (Admin Only) ---
@app.route('/user/approve/<int:id>', methods=['POST'])
def approve_user(id):
    token = request.headers.get('Authorization')
    if not token:
        return jsonify({"success": False, "message": "Missing token"}), 401

    decoded = decode_token(token)
    if decoded['role'] != 'admin':
        return jsonify({"success": False, "message": "Unauthorized"}), 403

    user = User.query.get(id)
    if not user:
        return jsonify({"success": False, "message": "User not found"}), 404

    user.status = "approved"
    db.session.commit()
    return jsonify({"success": True, "message": "User approved"})

# --- Add Product (Seller Only) ---
@app.route('/product', methods=['POST'])
def add_product():
    token = request.headers.get('Authorization')
    if not token:
        return jsonify({"success": False, "message": "Missing token"}), 401

    try:
        decoded = decode_token(token)
        if decoded['role'] != 'seller':
            return jsonify({"success": False, "message": "Unauthorized"}), 403

        data = request.get_json()
        product = Product(
            name=data['name'],
            price=data['price'],
            stock=data['stock'],
            seller_id=decoded['user_id']
        )
        db.session.add(product)
        db.session.commit()
        return jsonify({"success": True, "message": "Product added successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 400

# --- Edit Product ---
@app.route('/product/<int:id>', methods=['PUT'])
def edit_product(id):
    token = request.headers.get('Authorization')
    if not token:
        return jsonify({"success": False, "message": "Missing token"}), 401

    try:
        decoded = decode_token(token)
        product = Product.query.get(id)
        if not product:
            return jsonify({"success": False, "message": "Product not found"}), 404

        if decoded['role'] == 'admin' or (decoded['role'] == 'seller' and product.seller_id == decoded['user_id']):
            data = request.get_json()
            product.name = data['name']
            product.price = data['price']
            product.stock = data['stock']
            db.session.commit()
            return jsonify({"success": True, "message": "Product updated"})
        else:
            return jsonify({"success": False, "message": "Unauthorized"}), 403
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 400

# --- Delete Product ---
@app.route('/product/<int:id>', methods=['DELETE'])
def delete_product(id):
    token = request.headers.get('Authorization')
    if not token:
        return jsonify({"success": False, "message": "Missing token"}), 401

    try:
        decoded = decode_token(token)
        product = Product.query.get(id)
        if not product:
            return jsonify({"success": False, "message": "Product not found"}), 404

        if decoded['role'] == 'admin' or (decoded['role'] == 'seller' and product.seller_id == decoded['user_id']):
            db.session.delete(product)
            db.session.commit()
            return jsonify({"success": True, "message": "Product deleted"})
        else:
            return jsonify({"success": False, "message": "Unauthorized"}), 403
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 400

# --- Get Products ---
@app.route('/products', methods=['GET'])
def get_products():
    products = Product.query.all()
    result = [{"id": p.id, "name": p.name, "price": p.price, "stock": p.stock, "seller_id": p.seller_id} for p in products]
    return jsonify(result)

# --- Place Order (Customer Only) ---
@app.route('/order', methods=['POST'])
def place_order():
    token = request.headers.get('Authorization')
    if not token:
        return jsonify({"success": False, "message": "Missing token"}), 401
    try:
        decoded = decode_token(token)
        if decoded['role'] != 'customer':
            return jsonify({"success": False, "message": "Unauthorized"}), 403

        data = request.get_json()
        product = Product.query.get(data['product_id'])
        if not product:
            return jsonify({"success": False, "message": "Product not found"}), 404

        if product.stock < data['quantity']:
            return jsonify({"success": False, "message": "Insufficient stock"}), 400

        product.stock -= data['quantity']
        order = Order(product_id=data['product_id'], customer_id=decoded['user_id'], quantity=data['quantity'])
        db.session.add(order)
        db.session.commit()
        return jsonify({"success": True, "message": "Order placed successfully"})
    except Exception as e:
        return jsonify({"success": False, "message": str(e)}), 400

# --- Get Orders (All Roles) ---
@app.route('/orders', methods=['GET'])
def get_orders():
    token = request.headers.get('Authorization')
    if not token:
        return jsonify({"success": False, "message": "Missing token"}), 401

    decoded = decode_token(token)
    role = decoded['role']
    user_id = decoded['user_id']

    if role == 'seller':
        orders = Order.query.join(Product).filter(Product.seller_id == user_id).all()
    elif role == 'customer':
        orders = Order.query.filter_by(customer_id=user_id).all()
    else:  # admin
        orders = Order.query.all()

    result = []
    for o in orders:
        product = Product.query.get(o.product_id)
        result.append({
            "order_id": o.id,
            "product_id": o.product_id,
            "product_name": product.name if product else None,
            "customer_id": o.customer_id,
            "quantity": o.quantity,
            "status": o.status
        })
    return jsonify(result)

# --- Update Order Status (Seller/Admin) ---
@app.route('/order/status', methods=['POST'])
def update_order_status():
    token = request.headers.get('Authorization')
    if not token:
        return jsonify({"success": False, "message": "Missing token"}), 401

    decoded = decode_token(token)
    data = request.get_json()
    order = Order.query.get(data['order_id'])
    if not order:
        return jsonify({"success": False, "message": "Order not found"}), 404

    product = Product.query.get(order.product_id)
    if decoded['role'] == 'admin' or (decoded['role'] == 'seller' and product.seller_id == decoded['user_id']):
        order.status = data['status']
        db.session.commit()
        return jsonify({"success": True, "message": "Order status updated"})
    return jsonify({"success": False, "message": "Unauthorized"}), 403

# --- Initialize DB and Seed Users ---
if __name__ == "__main__":
    # Delete old DB to avoid migration issues (only for dev)
    if os.path.exists('aquacart.db'):
        os.remove('aquacart.db')

    with app.app_context():
        db.create_all()

        # Seed users
        if not User.query.filter_by(email="admin@aquacart.com").first():
            db.session.add(User(email="admin@aquacart.com",
                                password=bcrypt.generate_password_hash("admin123").decode('utf-8'),
                                role="admin",
                                status="approved"))
        if not User.query.filter_by(email="seller@aquacart.com").first():
            db.session.add(User(email="seller@aquacart.com",
                                password=bcrypt.generate_password_hash("seller123").decode('utf-8'),
                                role="seller",
                                status="pending"))
        if not User.query.filter_by(email="customer@aquacart.com").first():
            db.session.add(User(email="customer@aquacart.com",
                                password=bcrypt.generate_password_hash("customer123").decode('utf-8'),
                                role="customer",
                                status="pending"))
        db.session.commit()
        print("Database initialized with default users.")

    app.run(host='0.0.0.0', port=5000, debug=True)

