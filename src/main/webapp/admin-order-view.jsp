<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*, com.foodtruck.model.Orders, com.foodtruck.model.Restaurant" %>

<%
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    List<Orders> pendingOrders = (List<Orders>) request.getAttribute("pendingOrders");
    List<Orders> completedOrders = (List<Orders>) request.getAttribute("completedOrders");

    String success = (String) request.getAttribute("adminSuccess");
    String error = (String) request.getAttribute("adminError");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Orders | Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { brand: "#ff4d00", brandDark: "#d84300", brandLight: "#fff3eb" }
                }
            }
        }
    </script>
</head>

<body class="bg-gray-50">

<!-- HEADER -->
<header class="bg-white shadow-md sticky top-0 z-30">
    <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
        <h1 class="text-3xl font-bold text-brand">🏪 FoodTruck Admin</h1>
        <div class="flex items-center gap-6">
            <span class="font-semibold text-gray-800 text-lg"><%= restaurant.getName() %></span>
            <a href="<%= request.getContextPath() %>/logout"
               class="bg-red-500 hover:bg-red-600 text-white px-6 py-2.5 rounded-full font-medium text-base">
                Logout
            </a>
        </div>
    </div>
</header>

<div class="flex">

    <!-- SIDEBAR -->
    <aside class="w-72 bg-white shadow-xl p-6 sticky top-20 h-screen">
        <h2 class="text-2xl font-bold text-gray-800 mb-8">Dashboard Menu</h2>

        <nav class="space-y-3">
            <a href="<%= request.getContextPath() %>/admin/dashboard"
               class="block px-5 py-4 rounded-xl font-semibold text-base bg-white border-2 border-brand text-brand hover:bg-brand hover:text-white transition">
                📊 Overview
            </a>

            <a href="<%= request.getContextPath() %>/admin/menu?restaurantId=<%= restaurant.getRestaurantId() %>"
               class="block px-5 py-4 rounded-xl font-semibold text-base bg-white border-2 border-brand text-brand hover:bg-brand hover:text-white transition">
                🍽️ Manage Menu
            </a>

            <a href="<%= request.getContextPath() %>/admin/orders"
               class="block px-5 py-4 rounded-xl font-semibold text-base bg-brandLight border-2 border-brand text-brand hover:bg-brand hover:text-white transition">
                📦 Orders
            </a>

            <a href="<%= request.getContextPath() %>/admin/restaurant/manage?action=edit&restaurantId=<%= restaurant.getRestaurantId() %>"
               class="block px-5 py-4 rounded-xl font-semibold text-base bg-white border-2 border-brand text-brand hover:bg-brand hover:text-white transition">
                ⚙️ Settings
            </a>
        </nav>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="flex-1 p-10">

        <!-- SUCCESS / ERROR -->
        <% if (success != null) { %>
            <div class="bg-green-50 border-2 border-green-200 text-green-800 px-5 py-4 rounded-xl mb-6 font-semibold text-base">
                ✓ <%= success %>
            </div>
        <% } %>

        <% if (error != null) { %>
            <div class="bg-red-50 border-2 border-red-200 text-red-800 px-5 py-4 rounded-xl mb-6 font-semibold text-base">
                ✕ <%= error %>
            </div>
        <% } %>


        <h1 class="text-4xl font-bold mb-10 text-gray-900">
            Orders for <span class="text-brand"><%= restaurant.getName() %></span>
        </h1>

        <!-- PENDING ORDERS -->
        <section class="mb-12">
            <h2 class="text-3xl font-bold text-gray-800 mb-6">⏳ Pending & Confirmed Orders</h2>

            <% if (pendingOrders == null || pendingOrders.isEmpty()) { %>
                <p class="text-gray-600 text-lg">No pending or confirmed orders.</p>
            <% } else { %>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <% for (Orders o : pendingOrders) { %>
                <div class="bg-white p-6 rounded-2xl shadow-lg hover:shadow-xl transition">
                    <h3 class="text-2xl font-bold text-gray-900 mb-3">Order #<%= o.getOrderId() %></h3>

                    <p class="text-gray-700 mb-2 text-base">
                        <strong>Status:</strong> 
                        <span class="text-brand font-bold"><%= o.getOrderStatus() %></span>
                    </p>

                    <p class="text-gray-600 text-base mb-1"><strong>Amount:</strong> ₹<%= o.getTotalAmount() %></p>
                    <p class="text-gray-600 text-base mb-5"><strong>Payment:</strong> <%= o.getPaymentMode() %></p>

                    <div class="flex gap-3">
                        <a href="<%= request.getContextPath() %>/admin/orderItems?orderId=<%= o.getOrderId() %>"
                           class="px-5 py-3 bg-blue-500 text-white rounded-xl hover:bg-blue-600 font-semibold text-base">
                            View Items
                        </a>

                        <form action="<%= request.getContextPath() %>/admin/orders" method="post" class="flex-1">
                            <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">

                            <% if ("PENDING".equals(o.getOrderStatus())) { %>
                                <input type="hidden" name="newStatus" value="CONFIRMED">
                                <button class="w-full px-5 py-3 bg-yellow-500 text-white rounded-xl hover:bg-yellow-600 font-semibold text-base">
                                    Mark Confirmed
                                </button>

                            <% } else if ("CONFIRMED".equals(o.getOrderStatus())) { %>
                                <input type="hidden" name="newStatus" value="DELIVERED">
                                <button class="w-full px-5 py-3 bg-green-600 text-white rounded-xl hover:bg-green-700 font-semibold text-base">
                                    Mark Delivered
                                </button>
                            <% } %>

                        </form>
                    </div>
                </div>
                <% } %>
            </div>

            <% } %>
        </section>


        <!-- DELIVERED ORDERS -->
        <section>
            <h2 class="text-3xl font-bold text-gray-800 mb-6">✓ Delivered Orders</h2>

            <% if (completedOrders == null || completedOrders.isEmpty()) { %>
                <p class="text-gray-600 text-lg">No delivered orders yet.</p>
            <% } else { %>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <% for (Orders o : completedOrders) { %>
                <div class="bg-white p-6 rounded-2xl shadow-lg hover:shadow-xl transition">
                    <h3 class="text-2xl font-bold text-gray-900 mb-3">Order #<%= o.getOrderId() %></h3>

                    <p class="text-green-700 font-bold mb-2 text-lg">✓ Delivered</p>

                    <p class="text-gray-600 text-base mb-1"><strong>Amount:</strong> ₹<%= o.getTotalAmount() %></p>
                    <p class="text-gray-600 text-base mb-5"><strong>Payment:</strong> <%= o.getPaymentMode() %></p>

                    <a href="<%= request.getContextPath() %>/admin/orderItems?orderId=<%= o.getOrderId() %>"
                       class="inline-block bg-blue-500 text-white px-5 py-3 rounded-xl hover:bg-blue-600 font-semibold text-base">
                        View Items
                    </a>
                </div>
                <% } %>
            </div>

            <% } %>
        </section>

    </main>

</div>

</body>
</html>