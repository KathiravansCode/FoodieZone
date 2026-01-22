<%@ page import="java.util.*, com.foodtruck.model.*, com.foodtruck.model.Menu" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Your Cart | FoodZone</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { brand: "#ff4d00", brandDark: "#e64500" } } }
        };
    </script>
    <style>
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes slideOut {
            to { opacity: 0; transform: translateX(100%); }
        }
        .slide-up { animation: slideUp 0.4s ease-out; }
        .notification { animation: slideUp 0.3s ease-out; }
        .notification-exit { animation: slideOut 0.3s ease-out; }
    </style>
</head>

<body class="bg-gray-50 min-h-screen">
<%
    User user = (User) request.getAttribute("user");
    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    Map<Integer, Menu> menuDetails = (Map<Integer, Menu>) request.getAttribute("menuDetails");
    Double totalObj = (Double) request.getAttribute("subTotal");
    double subTotal = totalObj != null ? totalObj : 0.0;
    String success = (String) request.getAttribute("cartSuccess");
    String error = (String) request.getAttribute("cartError");
%>

<!-- NAVBAR -->
<nav class="bg-white shadow-sm sticky top-0 z-40 border-b border-gray-100">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="text-2xl font-bold text-brand cursor-pointer flex items-center gap-2" onclick="window.location.href='home'">
                🍕 <span>FoodZone</span>
            </div>
            <div class="flex items-center gap-4">
                <a href="home" class="text-sm font-medium text-gray-700 hover:text-brand transition">Home</a>
                <a href="order-history" class="text-gray-700 font-semibold hover:text-brand text-base">My Orders</a>
                <a href="logout" class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-brand transition">Logout</a>
            </div>
        </div>
    </div>
</nav>

<!-- NOTIFICATIONS -->
<div id="notification-container" class="fixed top-20 right-4 z-50 space-y-2"></div>

<div class="max-w-4xl mx-auto px-4 py-8">
    <div class="mb-6">
        <h1 class="text-2xl font-bold text-gray-900 mb-1">Your Cart</h1>
        <p class="text-sm text-gray-600">Review your items</p>
    </div>

    <% if (cartItems != null && !cartItems.isEmpty()) { %>
        <div class="space-y-3 mb-6">
            <% for (Cart item : cartItems) {
                Menu menu = menuDetails.get(item.getMenuId());
            %>
            <div class="bg-white rounded-xl p-4 shadow-sm slide-up flex items-center gap-4">
                <img src="menuImage?id=<%= menu.getMenuId() %>"
                     onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200'"
                     class="w-20 h-20 object-cover rounded-lg">

                <div class="flex-1 min-w-0">
                    <h3 class="text-sm font-bold text-gray-900 mb-0.5 truncate"><%= menu.getItemName() %></h3>
                    <p class="text-xs text-gray-500 mb-2">₹<%= menu.getPrice() %> each</p>
                    
                    <form action="cart" method="post" class="flex items-center gap-2">
                        <input type="hidden" name="cartId" value="<%= item.getCartId() %>">
                        <input type="hidden" name="action" value="update">
                        <button name="quantity" value="<%= item.getQuantity() - 1 %>"
                                class="w-7 h-7 bg-gray-100 hover:bg-gray-200 rounded-md font-bold text-sm transition flex items-center justify-center">−</button>
                        <div class="w-8 h-7 bg-gray-50 rounded-md flex items-center justify-center font-semibold text-sm"><%= item.getQuantity() %></div>
                        <button name="quantity" value="<%= item.getQuantity() + 1 %>"
                                class="w-7 h-7 bg-gray-100 hover:bg-gray-200 rounded-md font-bold text-sm transition flex items-center justify-center">+</button>
                    </form>
                </div>

                <div class="text-right">
                    <p class="text-lg font-bold text-brand mb-2">₹<%= item.getQuantity() * menu.getPrice() %></p>
                    <form action="cart" method="post">
                        <input type="hidden" name="cartId" value="<%= item.getCartId() %>">
                        <input type="hidden" name="action" value="remove">
                        <button class="text-red-500 hover:text-red-700 font-medium text-xs">Remove</button>
                    </form>
                </div>
            </div>
            <% } %>
        </div>

        <div class="bg-white rounded-xl p-6 shadow-sm">
            <div class="flex justify-between items-center mb-4">
                <span class="text-lg font-bold text-gray-800">Total</span>
                <span class="text-2xl font-bold text-brand">₹<%= subTotal %></span>
            </div>
            <a href="checkout" class="block w-full text-center bg-brand text-white py-3 rounded-lg hover:bg-brandDark transition font-semibold text-sm shadow-sm">
                Proceed to Checkout
            </a>
        </div>
    <% } else { %>
        <div class="bg-white rounded-xl p-12 text-center shadow-sm">
            <div class="text-6xl mb-4">🛒</div>
            <h2 class="text-xl font-bold text-gray-800 mb-2">Your cart is empty</h2>
            <p class="text-sm text-gray-600 mb-6">Add items to get started</p>
            <a href="home" class="inline-block bg-brand text-white px-6 py-2.5 rounded-lg hover:bg-brandDark transition font-semibold text-sm">
                Browse Restaurants
            </a>
        </div>
    <% } %>
</div>

<script>
    function showNotification(message, type) {
        const container = document.getElementById('notification-container');
        const notification = document.createElement('div');
        notification.className = 'notification px-5 py-3 rounded-lg shadow-lg text-sm font-medium ' + 
            (type === 'success' ? 'bg-green-500 text-white' : 'bg-red-500 text-white');
        notification.textContent = message;
        container.appendChild(notification);
        
        setTimeout(function() {
            notification.classList.add('notification-exit');
            setTimeout(function() { notification.remove(); }, 300);
        }, 3000);
    }

    <% if (success != null) { %>
        showNotification('<%= success %>', 'success');
    <% } %>
    <% if (error != null) { %>
        showNotification('<%= error %>', 'error');
    <% } %>
</script>
</body>
</html>