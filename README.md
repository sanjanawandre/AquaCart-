# AquaCart – Aquarium E-Commerce Application

AquaCart is a full-stack e-commerce application designed specifically for aquarium enthusiasts.  
The platform connects customers, sellers, and administrators in a single system where users can browse products, manage inventory, and place orders smoothly.

This project demonstrates backend API development, authentication systems, role-based access control, and database integration.

---

## 🚀 Tech Stack

### Backend
- Python (Flask)
- Flask SQLAlchemy
- Flask Bcrypt
- JWT Authentication
- SQLite Database

### Frontend
- Flutter (Mobile Application)

### Other Tools
- REST APIs
- Role-based Authentication
- Basic Order & Inventory Management

---

## 👥 User Roles

The system supports three main roles:

- **Admin**
  - Approve users
  - Manage products
  - View all orders
  - Update order status

- **Seller**
  - Add products
  - Edit or delete own products
  - View seller-related orders

- **Customer**
  - Register & login
  - Browse products
  - Place orders
  - Track order status

---

## ✨ Key Features

- Secure JWT-based login system
- Role-based access control
- Product management system
- Order placement and tracking
- Inventory stock updates
- Seller approval workflow
- RESTful API structure

---

## 🗄 Database

SQLite database (`aquacart.db`)  
Tables include:
- User
- Product
- Order

The database is auto-created when the backend runs.

---

## ▶️ How to Run Backend Locally

1. Clone the repository:
   git clone https://github.com/your-username/aquacart.git

2. Go inside project folder:
   cd aquacart

3. Install dependencies:
   pip install flask flask_sqlalchemy flask_bcrypt flask_cors pyjwt

4. Run the application:
   python app.py

The backend will run at:
http://127.0.0.1:5000

---

## 🔐 Default Seeded Users (For Testing)

Admin:
admin@aquacart.com  
Password: admin123  

Seller:
seller@aquacart.com  
Password: seller123  

Customer:
customer@aquacart.com  
Password: customer123  

---

## 📌 Project Type

Full-Stack E-Commerce Application  
Backend + Mobile App Integration  

---

## 👩‍💻 Created By

Sanjana Wandre  
Computer Science 
