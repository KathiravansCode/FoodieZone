<%@ page import="java.util.*, com.foodtruck.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>Order Details | FoodZone</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { brand: "#ff4d00", brandDark: "#e64500" } } }
        };
    </script>
</head>

<body class="bg-gray-50 min-h-screen">

<%
    Orders order = (Orders) request.getAttribute("order");
    List<OrderItem> items = (List<OrderItem>) request.getAttribute("items");
    Map<Integer, Menu> menuDetails = (Map<Integer, Menu>) request.getAttribute("menuDetails");
    double finalTotal = (Double) request.getAttribute("finalTotal");
%>

<!-- NAVBAR -->
<nav class="bg-white shadow-md py-4 px-6 sticky top-0 z-40">
    <div class="max-w-7xl mx-auto flex justify-between items-center">
        <div onclick="window.location.href='home'" class="text-2xl font-bold text-brand cursor-pointer">
            🍕 FoodZone
        </div>

        <div class="flex items-center gap-6">
            <a href="home" class="font-semibold text-gray-700 hover:text-brand text-base">Home</a>
            <a href="orders" class="font-semibold text-gray-700 hover:text-brand text-base">My Orders</a>
            <a href="logout" class="px-5 py-2.5 bg-gray-800 text-white rounded-full hover:bg-black transition text-base font-medium">
                Logout
            </a>
        </div>
    </div>
</nav>

<!-- ORDER DETAILS -->
<div class="max-w-4xl mx-auto px-4 py-10">
    
    <!-- HEADER -->
    <div class="mb-8">
        <h1 class="text-4xl font-bold text-gray-900 mb-2">Order #<%= order.getOrderId() %></h1>
        <p class="text-gray-600 text-lg">Placed on <%= order.getCreatedAt() %></p>
    </div>

    <!-- STATUS CARD -->
    <div class="bg-gradient-to-r from-orange-50 to-red-50 rounded-2xl p-6 mb-8">
        <div class="grid md:grid-cols-3 gap-6">
            <div>
                <p class="text-gray-600 text-sm mb-1">Order Status</p>
                <p class="text-2xl font-bold text-gray-900"><%= order.getOrderStatus() %></p>
            </div>
            <div>
                <p class="text-gray-600 text-sm mb-1">Payment Mode</p>
                <p class="text-2xl font-bold text-gray-900"><%= order.getPaymentMode() %></p>
            </div>
            <div>
                <p class="text-gray-600 text-sm mb-1">Payment Status</p>
                <p class="text-2xl font-bold <%= "PAID".equals(order.getPaymentStatus()) ? "text-green-600" : "text-yellow-600" %>">
                    <%= order.getPaymentStatus() %>
                </p>
            </div>
        </div>
    </div>

    <!-- ITEMS LIST -->
    <div class="bg-white rounded-2xl shadow-lg overflow-hidden mb-8">
        <div class="bg-gray-50 px-6 py-4 border-b">
            <h2 class="text-2xl font-bold text-gray-900">Order Items</h2>
        </div>

        <div class="divide-y">
            <% for (OrderItem it : items) { 
                Menu menu = menuDetails.get(it.getMenuId());
            %>
            <div class="p-6 flex items-center gap-6">
                <img src="menuImage?id=<%= menu.getMenuId() %>"
                     onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=150'"
                     class="w-24 h-24 object-cover rounded-xl shadow-md">
                
                <div class="flex-1">
                    <h3 class="text-xl font-bold text-gray-900 mb-2"><%= menu.getItemName() %></h3>
                    <p class="text-gray-600 text-base">₹<%= it.getPrice() %> × <%= it.getQuantity() %></p>
                </div>

                <div class="text-right">
                    <p class="text-2xl font-bold text-brand">₹<%= it.getQuantity() * it.getPrice() %></p>
                </div>
            </div>
            <% } %>
        </div>

        <!-- TOTAL -->
        <div class="bg-gray-50 px-6 py-6 border-t-2">
            <div class="flex justify-between items-center">
                <span class="text-2xl font-bold text-gray-800">Total Amount</span>
                <span class="text-4xl font-bold text-brand">₹<%= finalTotal %></span>
            </div>
        </div>
    </div>

    <!-- BACK BUTTON -->
    <a href="orders" class="inline-block bg-gray-200 text-gray-700 px-8 py-4 rounded-xl hover:bg-gray-300 transition font-semibold text-base">
        ← Back to Orders
    </a>

</div>

</body>
</html>