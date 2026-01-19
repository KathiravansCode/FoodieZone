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
        @keyframes slideInRight {
            from { opacity: 0; transform: translateX(50px); }
            to { opacity: 1; transform: translateX(0); }
        }
        .slide-in-right { animation: slideInRight 0.5s ease; }
    </style>
</head>

<body class="bg-gray-50 min-h-screen">

<%
    User user = (User) request.getAttribute("user");
    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    Map<Integer, Menu> menuDetails = (Map<Integer, Menu>) request.getAttribute("menuDetails");
    Double totalObj = (Double) request.getAttribute("subTotal");
    double subTotal = totalObj != null ? totalObj : 0.0;
%>

<!-- NAVBAR -->
<nav class="bg-white shadow-md py-4 px-6 sticky top-0 z-40">
    <div class="max-w-7xl mx-auto flex justify-between items-center">
        <div class="text-2xl font-bold text-brand cursor-pointer" onclick="window.location.href='home'">
            🍕 FoodZone
        </div>

        <div class="flex gap-6 items-center">
            <a href="home" class="text-gray-700 font-semibold hover:text-brand text-base">Home</a>
            <a href="orders" class="text-gray-700 font-semibold hover:text-brand text-base">My Orders</a>
            <a href="logout" class="px-5 py-2.5 bg-gray-800 text-white rounded-full hover:bg-black transition text-base font-medium">
                Logout
            </a>
        </div>
    </div>
</nav>

<!-- SUCCESS/ERROR MESSAGES -->
<%
    String success = (String) request.getAttribute("cartSuccess");
    String error = (String) request.getAttribute("cartError");
%>

<% if (success != null) { %>
<div class="max-w-4xl mx-auto mt-6 px-4">
    <div class="bg-green-50 border-2 border-green-200 text-green-800 px-5 py-4 rounded-xl text-center font-semibold text-base">
        ✓ <%= success %>
    </div>
</div>
<% } %>

<% if (error != null) { %>
<div class="max-w-4xl mx-auto mt-6 px-4">
    <div class="bg-red-50 border-2 border-red-200 text-red-800 px-5 py-4 rounded-xl text-center font-semibold text-base">
        ✕ <%= error %>
    </div>
</div>
<% } %>

<div class="max-w-4xl mx-auto px-4 py-10">
    <!-- HEADER -->
    <div class="mb-8">
        <h1 class="text-4xl font-bold text-gray-900 mb-2">🛒 Your Cart</h1>
        <p class="text-gray-600 text-lg">Review your items before checkout</p>
    </div>

    <% if (cartItems != null && !cartItems.isEmpty()) { %>
        <!-- CART ITEMS -->
        <div class="space-y-4 mb-8">
            <% for (Cart item : cartItems) {
                Menu menu = menuDetails.get(item.getMenuId());
            %>
            <div class="bg-white rounded-2xl p-6 shadow-lg slide-in-right flex items-center gap-6">
                <!-- IMAGE -->
                <img src="menuImage?id=<%= menu.getMenuId() %>"
                     onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200'"
                     class="w-28 h-28 object-cover rounded-xl shadow-md">

                <!-- DETAILS -->
                <div class="flex-1">
                    <h2 class="text-xl font-bold text-gray-900 mb-1"><%= menu.getItemName() %></h2>
                    <p class="text-gray-600 text-base mb-3">₹<%= menu.getPrice() %> per item</p>
                    
                    <!-- QUANTITY CONTROLS -->
                    <form action="cart" method="post" class="flex items-center gap-3">
                        <input type="hidden" name="cartId" value="<%= item.getCartId() %>">
                        <input type="hidden" name="action" value="update">

                        <button name="quantity" value="<%= item.getQuantity() - 1 %>"
                                class="w-10 h-10 bg-gray-200 hover:bg-gray-300 rounded-lg font-bold text-lg transition">
                            −
                        </button>

                        <div class="w-12 h-10 bg-gray-100 rounded-lg flex items-center justify-center font-bold text-lg">
                            <%= item.getQuantity() %>
                        </div>

                        <button name="quantity" value="<%= item.getQuantity() + 1 %>"
                                class="w-10 h-10 bg-gray-200 hover:bg-gray-300 rounded-lg font-bold text-lg transition">
                            +
                        </button>
                    </form>
                </div>

                <!-- PRICE & REMOVE -->
                <div class="text-right">
                    <p class="text-2xl font-bold text-brand mb-4">
                        ₹<%= item.getQuantity() * menu.getPrice() %>
                    </p>
                    <form action="cart" method="post">
                        <input type="hidden" name="cartId" value="<%= item.getCartId() %>">
                        <input type="hidden" name="action" value="remove">
                        <button class="text-red-500 hover:text-red-700 font-semibold text-base">
                            🗑️ Remove
                        </button>
                    </form>
                </div>
            </div>
            <% } %>
        </div>

        <!-- TOTAL & CHECKOUT -->
        <div class="bg-gradient-to-r from-orange-50 to-red-50 rounded-2xl p-8">
            <div class="flex justify-between items-center mb-6">
                <span class="text-2xl font-bold text-gray-800">Total Amount:</span>
                <span class="text-4xl font-bold text-brand">₹<%= subTotal %></span>
            </div>

            <a href="checkout" class="block w-full text-center bg-brand text-white py-4 rounded-xl hover:bg-brandDark transition shadow-lg font-bold text-lg">
                Proceed to Checkout →
            </a>
        </div>

    <% } else { %>
        <!-- EMPTY CART -->
        <div class="bg-white rounded-2xl p-12 text-center shadow-lg">
            <div class="text-7xl mb-6">🛒</div>
            <h2 class="text-3xl font-bold text-gray-800 mb-4">Your cart is empty</h2>
            <p class="text-gray-600 text-lg mb-8">Add some delicious items to get started!</p>
            <a href="home" class="inline-block bg-brand text-white px-8 py-4 rounded-xl hover:bg-brandDark transition font-bold text-base">
                Browse Restaurants
            </a>
        </div>
    <% } %>
</div>

</body>
</html>