<%@ page import="java.util.*, com.foodtruck.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>My Orders | FoodZone</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { brand: "#ff4d00", brandDark: "#e64500" } } }
        };
    </script>
</head>

<body class="bg-gray-50 min-h-screen">

<%
    User user = (User) request.getAttribute("user");
    List<Orders> orderHistory = (List<Orders>) request.getAttribute("orderHistory");
    String successMsg = (String) request.getAttribute("orderSuccess");
    
    // Debug output
 
%>

<!-- NAVBAR -->
<nav class="bg-white shadow-md py-4 px-6 sticky top-0 z-40">
    <div class="max-w-7xl mx-auto flex justify-between items-center">
        <div onclick="window.location.href='home'" class="text-2xl font-bold text-brand cursor-pointer">
            🍕 FoodZone
        </div>

        <div class="flex gap-6 items-center">
            <a href="home" class="font-semibold text-gray-700 hover:text-brand text-base">Home</a>
            <a href="orders" class="font-semibold text-gray-700 hover:text-brand text-base">My Orders</a>
            <a href="logout" class="px-5 py-2.5 bg-gray-800 text-white rounded-full hover:bg-black transition text-base font-medium">
                Logout
            </a>
        </div>
    </div>
</nav>

<!-- SUCCESS MESSAGE -->
<% if (successMsg != null) { %>
<div class="max-w-6xl mx-auto mt-6 px-4">
    <div class="bg-green-50 border-2 border-green-200 text-green-700 px-5 py-4 rounded-xl text-center font-semibold text-base">
        ✓ <%= successMsg %>
    </div>
</div>
<% } %>

<!-- ORDERS SECTION -->
<div class="max-w-6xl mx-auto px-4 py-10">
    <div class="mb-8">
        <h1 class="text-4xl font-bold text-gray-900 mb-2">📦 Your Orders</h1>
        <p class="text-gray-600 text-lg">Track and view your order history</p>
    </div>

    <% if (orderHistory != null && !orderHistory.isEmpty()) { %>
        <div class="space-y-4">
            <% 
            for (Orders o : orderHistory) { 
                // NULL CHECK - Skip null orders
                if (o == null) {
                    System.err.println("Warning: Null order found in orderHistory list");
                    continue;
                }
                
                String statusColor = "gray";
                String statusIcon = "📦";
                String orderStatus = o.getOrderStatus();
                
                if (orderStatus != null) {
                    if ("CONFIRMED".equals(orderStatus)) {
                        statusColor = "blue";
                        statusIcon = "";
                    } else if ("DELIVERED".equals(orderStatus)) {
                        statusColor = "green";
                        statusIcon = "";
                    } else if ("PENDING".equals(orderStatus)) {
                        statusColor = "yellow";
                        statusIcon = "⏳";
                    }
                }
            %>
            <div class="bg-white rounded-2xl shadow-lg p-6 hover:shadow-xl transition">
                <div class="flex items-center justify-between mb-4">
                    <div>
                        <h3 class="text-2xl font-semibold text-gray-900 mb-1">
                            Order #<%= o.getOrderId() %>
                        </h3>
                        <p class="text-gray-600 text-base">
                            📅 <%= o.getCreatedAt() != null ? o.getCreatedAt() : "N/A" %>
                        </p>
                    </div>
                    <div class="text-right">
                        <div class="inline-block bg-<%= statusColor %>-100 text-<%= statusColor %>-800 px-4 py-2 rounded-full font-bold text-base mb-2">
                            <%= statusIcon %> <%= orderStatus != null ? orderStatus : "UNKNOWN" %>
                        </div>
                        <p class="text-sm text-gray-600">
                            Payment: <%= o.getPaymentStatus() != null ? o.getPaymentStatus() : "N/A" %>
                        </p>
                    </div>
                </div>

                <div class="flex items-center justify-between pt-4 border-t">
                    <div>
                        <p class="text-gray-600 text-base mb-1">Total Amount</p>
                        <p class="text-xl font-semibold text-brand">₹<%= o.getTotalAmount() %></p>
                    </div>
                    <div class="flex items-center gap-4">
                        <div class="text-right">
                            <p class="text-gray-600 text-sm">Payment Method</p>
                            <p class="font-semibold text-base">
                                <%= o.getPaymentMode() != null ? o.getPaymentMode() : "N/A" %>
                            </p>
                        </div>
                        <a href="order-details?orderId=<%= o.getOrderId() %>"
                           class="px-6 py-3 bg-brand text-white rounded-xl hover:bg-brandDark transition font-semibold text-base">
                            View Details →
                        </a>
                    </div>
                </div>
            </div>
            <% } %>
        </div>

    <% } else { %>
        <!-- EMPTY STATE -->
        <div class="bg-white rounded-2xl p-12 text-center shadow-lg">
            <div class="text-7xl mb-6">📦</div>
            <h2 class="text-3xl font-bold text-gray-800 mb-4">No Orders Yet</h2>
            <p class="text-gray-600 text-lg mb-8">Start ordering your favorite food!</p>
            <a href="home" class="inline-block bg-brand text-white px-8 py-4 rounded-xl hover:bg-brandDark transition font-bold text-base">
                Browse Restaurants
            </a>
        </div>
    <% } %>
</div>

</body>
</html>