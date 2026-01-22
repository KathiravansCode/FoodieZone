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
    // 1. Retrieve the correct attributes sent by OrderDetailsServlet
    User user = (User) request.getAttribute("currentUser"); // Note: Servlet uses "currentUser" in session usually, but let's check your servlet logic.
    // In your servlet you used: User currentUser = (User) session.getAttribute("currentUser");
    // But you didn't set "user" as a request attribute. If you need user name in navbar, ensure it's in session.
    
    Orders order = (Orders) request.getAttribute("order");
    List<OrderItem> items = (List<OrderItem>) request.getAttribute("items");
    Map<Integer, Menu> menuDetails = (Map<Integer, Menu>) request.getAttribute("menuDetails");
    Double finalTotal = (Double) request.getAttribute("finalTotal");
%>

<nav class="bg-white shadow-sm sticky top-0 z-40 border-b border-gray-100">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="text-2xl font-bold text-brand cursor-pointer flex items-center gap-2" onclick="window.location.href='home'">
                🍕 <span>FoodZone</span>
            </div>
            <div class="flex items-center gap-4">
                <a href="home" class="text-sm font-medium text-gray-700 hover:text-brand transition">Home</a>
                <a href="order-history" class="font-semibold text-gray-700 hover:text-brand text-base">My Orders</a>
                <a href="logout" class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-brand transition">Logout</a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-4xl mx-auto px-4 py-8">
    
    <a href="order-history" class="inline-flex items-center text-gray-600 hover:text-brand mb-6 transition">
        ← Back to Orders
    </a>

    <% if (order != null) { %>
        <div class="bg-white rounded-xl shadow-sm p-6 mb-6">
            <div class="flex justify-between items-start border-b border-gray-100 pb-4 mb-4">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900">Order #<%= order.getOrderId() %></h1>
                    <p class="text-gray-500 text-sm mt-1">Placed on <%= order.getCreatedAt() %></p>
                </div>
                <div class="text-right">
                    <span class="inline-block px-3 py-1 rounded-full text-sm font-semibold 
                        <%= "CONFIRMED".equals(order.getOrderStatus()) ? "bg-blue-100 text-blue-800" : 
                           "DELIVERED".equals(order.getOrderStatus()) ? "bg-green-100 text-green-800" : 
                           "bg-yellow-100 text-yellow-800" %>">
                        <%= order.getOrderStatus() %>
                    </span>
                    <p class="text-gray-500 text-xs mt-2">Payment: <%= order.getPaymentStatus() %></p>
                </div>
            </div>
            
            <div class="grid grid-cols-2 gap-4">

                <div class="">
                    <h3 class="text-xs font-bold text-gray-500 uppercase tracking-wider mb-1">Payment Method</h3>
                    <p class="text-gray-800"><%= order.getPaymentMode() %></p>
                </div>
            </div>
        </div>

        <div class="bg-white rounded-xl shadow-sm overflow-hidden">
            <div class="p-6 border-b border-gray-100">
                <h2 class="text-lg font-bold text-gray-900">Items Ordered</h2>
            </div>
            
            <div class="divide-y divide-gray-100">
                <% 
                if (items != null) {
                    for (OrderItem item : items) { 
                        Menu menu = menuDetails.get(item.getMenuId());
                        String menuName = (menu != null) ? menu.getItemName(): "Unknown Item";
                      
                %>
                <div class="p-6 flex items-center justify-between hover:bg-gray-50 transition">
                    <div class="flex items-center gap-4">
                        <div class="h-16 w-16 bg-gray-200 rounded-lg overflow-hidden flex-shrink-0">
                             <img src="menuImage?id=<%= menu.getMenuId() %>" alt="<%= menuName %>" class="h-full w-full object-cover">
                        </div>
                        
                        <div>
                            <h3 class="font-bold text-gray-900"><%= menuName %></h3>
                            <p class="text-sm text-gray-500">Qty: <%= item.getQuantity() %> x ₹<%= item.getPrice() %></p>
                        </div>
                    </div>
                    <div class="text-right">
                        <p class="font-bold text-gray-900">₹<%= item.getPrice() * item.getQuantity() %></p>
                    </div>
                </div>
                <% 
                    } 
                }
                %>
            </div>

            <div class="bg-gray-50 p-6 border-t border-gray-100">
                <div class="flex justify-between items-center">
                    <span class="text-lg font-bold text-gray-900">Total Amount</span>
                    <span class="text-2xl font-bold text-brand">₹<%= order.getTotalAmount() %></span>
                </div>
            </div>
        </div>
        
    <% } else { %>
        <div class="text-center py-12">
            <p class="text-gray-500">Order details not found.</p>
            <a href="order-history" class="text-brand font-semibold hover:underline">Go Back</a>
        </div>
    <% } %>

</div>

</body>
</html>