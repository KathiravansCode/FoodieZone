# 🍽️ FoodieZone – Online Food Ordering Web App  
_A full-stack web application built using JSP, Servlets, JDBC, and MySQL._

FoodieZone is a complete food ordering system where users can browse restaurants, explore menus, add items to cart, place orders, and track them.  
Restaurant admins can manage their restaurant, menus, orders, and update delivery status.

This project follows a clean MVC architecture and is ideal for learning **JSP, Servlets, JDBC, and full-stack Java development**.

---

## 🚀 Features

### 👨‍🍳 User Features
- Register & Login  
- Browse restaurants  
- View restaurant menus  
- Add items to cart  
- Place orders (COD / Online)  
- Check order history  
- Order tracking per status  

### 🛠 Admin Features
Each admin manages **only their own restaurant**.

- Login with ADMIN role  
- Restaurant creation wizard (if no restaurant registered)  
- Update restaurant details  
- Menu CRUD (Add / Edit / Delete / Toggle availability)  
- View orders  
- Change order status (Confirmed → Delivered for COD orders)  
- View order item details  

---

## 🧱 Tech Stack


 **Frontend** - JSP, HTML, CSS, Tailwind CSS, JavaScript
 **Backend** Java Servlets, MVC architecture
 **Database**  MySQL + JDBC 
 **Server** Apache Tomcat 9/10 
**Utilities** Multipart file upload, Session management 

---

## 📁 Project Structure
FoodieZone/
│
├── src/
│ ├── com.foodtruck.servlet/ # All Servlets (User/Admin)
│ ├── com.foodtruck.DAO/ # DAO Interfaces
│ ├── com.foodtruck.DAOImplementations/ # JDBC Implementation
│ ├── com.foodtruck.model/ # POJOs (User, Menu, Orders…)
│ └── com.foodtruck.util/ # DBConnection utility
│
├── WebContent/
│ ├── admin-dashboard.jsp
│ ├── admin-menu.jsp
│ ├── manage-menu.jsp
│ ├── adminOrderView.jsp
│ ├── adminOrderItems.jsp
│ ├── registerRestaurantPrompt.jsp
│ ├── manage-restaurant.jsp
│ ├── login.jsp
│ ├── home.jsp
│ ├── cart.jsp
│ └── assets/ # CSS, images, icons
## 🗄 Database Schema (MySQL)

### **Users Table**
userId (PK)
username
password
email
role (USER/ADMIN)
address

markdown
Copy code

### **Restaurant Table**
restaurantId (PK)
adminId (FK → Users)
name
address
phone
status (OPEN/CLOSED)
rating
restaurantImage (BLOB)

css
Copy code

### **Menu Table**
menuId (PK)
restaurantId (FK)
itemName
description
price
isAvailable (BOOLEAN)
estimatedTime
itemImage (BLOB)

markdown
Copy code

### **Orders Table**
orderId (PK)
userId (FK)
restaurantId (FK)
totalAmount
orderStatus (PENDING/CONFIRMED/DELIVERED)
paymentMode (COD/ONLINE)
paymentStatus (PENDING/PAID)
deliveryAddress
createdAt (timestamp)

shell
Copy code

### **Order_Item Table**
orderItemId (PK)
orderId (FK)
menuId (FK)
quantity
price

yaml
Copy code

---

## ⚙️ How to Run the Project

### **1️⃣ Install Required Software**
- JDK 8+  
- Apache Tomcat 9/10  
- MySQL Server  
- Eclipse / IntelliJ / NetBeans  

### **2️⃣ Clone the Repository**
git clone https://github.com/KathiravansCode/FoodieZone.git

markdown
Copy code

### **3️⃣ Import into IDE**
- File → Import → Dynamic Web Project (Eclipse)
- Configure Tomcat in IDE

### **4️⃣ Configure Database**
- Create MySQL database:
CREATE DATABASE foodiezone;

arduino
Copy code

- Run provided SQL script for tables
- Update DB credentials in `DBConnection.java`:
- 

```java
private static final String URL = "jdbc:mysql://localhost:3306/FOOD_APP_DB";
private static final String USER = "root";
private static final String PASSWORD= "root";

username: admin
password: admin123
role: ADMIN
🛡 Security Highlights
Session-based authentication

Role-based access (USER vs ADMIN)

Admin cannot access another admin’s restaurant

Input validation + SQL Injection safe PreparedStatements

📸 Screenshots
Add important screenshots of:

Admin dashboard

Manage menu

Orders page

User home

Cart

Order summary

🏆 Future Enhancements
JWT authentication

Spring Boot migration

Razorpay / Stripe payment integration

Delivery partner module

Real-time order tracking

Email/SMS notifications
