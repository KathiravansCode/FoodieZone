<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.foodtruck.model.Orders, com.foodtruck.model.OrderItem, com.foodtruck.model.Menu, com.foodtruck.model.Restaurant" %>

<%
    Orders order = (Orders) request.getAttribute("order");
    List<OrderItem> items = (List<OrderItem>) request.getAttribute("items");
    List<Menu> menuDetails = (List<Menu>) request.getAttribute("menuDetails");
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Order Items | FoodZone Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
    tailwind.config = {
        theme: {
            extend: {
                colors: {
                    brand: "#ff4d00",
                    brandDark: "#e64500",
                    brandLight: "#fff3eb"
                }
            }
        }
    }
    </script>
    <style>
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .slide-up { animation: slideUp 0.4s ease-out; }
    </style>
</head>

<body class="bg-gray-50 min-h-screen">

<!-- HEADER -->
<header class="bg-white shadow-sm sticky top-0 z-30 border-b border-gray-100">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <h1 class="text-2xl font-bold text-brand flex items-center gap-2">
                🏪 <span>FoodZone Admin</span>
            </h1>
            <div class="flex items-center gap-4">
                <a href="<%= request.getContextPath() %>/admin/orders"
                   class="text-sm font-medium text-gray-700 hover:text-brand transition">
                    ← Back to Orders
                </a>
                <a href="<%= request.getContextPath() %>/logout"
                   class="bg-red-500 hover:bg-red-600 text-white px-5 py-2 rounded-full font-medium text-sm shadow-sm">
                    Logout
                </a>
            </div>
        </div>
    </div>
</header>

<div class="max-w-4xl mx-auto px-4 py-6">

    <div class="bg-white rounded-xl shadow-sm p-6 mb-6 slide-up">
        <div class="flex justify-between items-start border-b border-gray-100 pb-4 mb-4">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">Order #<%= order.getOrderId() %></h1>
                <p class="text-sm text-gray-500 mt-1"><%= order.getCreatedAt() %></p>
            </div>
            <div class="text-right">
                <span class="inline-block px-3 py-1 rounded-full text-sm font-semibold <%= "CONFIRMED".equals(order.getOrderStatus()) ? "bg-blue-100 text-blue-800" : "DELIVERED".equals(order.getOrderStatus()) ? "bg-green-100 text-green-800" : "bg-yellow-100 text-yellow-800" %>">
                    <%= order.getOrderStatus() %>
                </span>
                <p class="text-xs text-gray-500 mt-2">Payment: <%= order.getPaymentStatus() %></p>
            </div>
        </div>
        
        <div class="grid grid-cols-2 gap-4 text-sm">
            <div>
                <span class="text-gray-600">Payment Method:</span>
                <span class="font-semibold text-gray-900 ml-1"><%= order.getPaymentMode() %></span>
            </div>
            <div class="text-right">
                <span class="text-gray-600">Total Amount:</span>
                <span class="font-bold text-brand ml-1 text-lg">₹<%= order.getTotalAmount() %></span>
            </div>
        </div>
    </div>

    <div class="bg-white rounded-xl shadow-sm overflow-hidden">
        <div class="bg-gray-50 px-6 py-4 border-b border-gray-100">
            <h2 class="text-lg font-bold text-gray-900">Order Items</h2>
        </div>
        
        <div class="divide-y divide-gray-100">
            <% 
            for (int i = 0; i < items.size(); i++) {
                OrderItem oi = items.get(i);
                Menu m = menuDetails.get(i);
            %>

            <div class="p-5 flex items-center gap-4 hover:bg-gray-50 transition">

                <!-- IMAGE -->
                <div class="w-20 h-20 bg-gray-200 rounded-lg overflow-hidden flex-shrink-0">
                    <img src="<%= request.getContextPath() + "/menuImage?id=" + m.getMenuId() %>"
                         onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=200'"
                         class="w-full h-full object-cover">
                </div>

                <!-- DETAILS -->
                <div class="flex-1">
                    <h3 class="text-base font-bold text-gray-900 mb-1"><%= m.getItemName() %></h3>
                    <p class="text-sm text-gray-600">Price: ₹<%= oi.getPrice() %> × <%= oi.getQuantity() %></p>
                </div>

                <!-- TOTAL -->
                <div class="text-right">
                    <p class="text-lg font-bold text-brand">
                        ₹<%= oi.getQuantity() * oi.getPrice() %>
                    </p>
                </div>

            </div>

            <% } %>
        </div>
    </div>

</div>

</body>
</html>