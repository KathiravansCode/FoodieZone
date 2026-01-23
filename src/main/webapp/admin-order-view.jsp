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
    <title>Orders | FoodZone Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { brand: "#ff4d00", brandDark: "#e64500", brandLight: "#fff3eb" }
                }
            }
        }
    </script>
    <style>
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes slideOut {
            to { opacity: 0; transform: translateX(100%); }
        }
        .notification { animation: slideUp 0.3s ease-out; }
        .notification-exit { animation: slideOut 0.3s ease-out; }
        .order-card {
            transition: all 0.3s ease;
        }
        .order-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px -4px rgba(0,0,0,0.1);
        }
    </style>
</head>

<body class="bg-gray-50">

<!-- NOTIFICATION CONTAINER -->
<div id="notification-container" class="fixed top-20 right-4 z-50 space-y-2"></div>

<!-- HEADER -->
<header class="bg-white shadow-sm sticky top-0 z-30 border-b border-gray-100">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <h1 class="text-2xl font-bold text-brand flex items-center gap-2">
                🏪 <span>FoodZone Admin</span>
            </h1>
            <div class="flex items-center gap-4">
                <span class="font-semibold text-gray-700 text-sm"><%= restaurant.getName() %></span>
                <a href="<%= request.getContextPath() %>/logout"
                   class="bg-red-500 hover:bg-red-600 text-white px-5 py-2 rounded-full font-medium text-sm shadow-sm">
                    Logout
                </a>
            </div>
        </div>
    </div>
</header>

<div class="flex">

    <!-- SIDEBAR -->
    <aside class="w-64 bg-white shadow-sm p-5 sticky top-16 h-screen border-r border-gray-100">
        <h2 class="text-lg font-bold text-gray-800 mb-6">Dashboard Menu</h2>

        <nav class="space-y-2">
            <a href="<%= request.getContextPath() %>/admin/dashboard"
               class="block px-4 py-3 rounded-xl font-semibold text-sm text-gray-700 hover:bg-gray-50 transition">
                📊 Overview
            </a>

            <a href="<%= request.getContextPath() %>/admin/menu?restaurantId=<%= restaurant.getRestaurantId() %>"
               class="block px-4 py-3 rounded-xl font-semibold text-sm text-gray-700 hover:bg-gray-50 transition">
                🍽️ Manage Menu
            </a>

            <a href="<%= request.getContextPath() %>/admin/orders"
               class="block px-4 py-3 rounded-xl font-semibold text-sm bg-brandLight border border-brand text-brand hover:bg-brand hover:text-white transition">
                📦 Orders
            </a>

            <a href="<%= request.getContextPath() %>/admin/restaurant/manage?action=edit&restaurantId=<%= restaurant.getRestaurantId() %>"
               class="block px-4 py-3 rounded-xl font-semibold text-sm text-gray-700 hover:bg-gray-50 transition">
                ⚙️ Settings
            </a>
        </nav>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="flex-1 p-6">

        <div class="mb-6">
            <h1 class="text-2xl font-bold text-gray-900 mb-1">
                📦 Orders Management
            </h1>
            <p class="text-sm text-gray-600"><%= restaurant.getName() %></p>
        </div>

        <!-- PENDING ORDERS -->
        <section class="mb-8">
            <h2 class="text-lg font-bold text-gray-800 mb-4">⏳ Pending & Confirmed Orders</h2>

            <% if (pendingOrders == null || pendingOrders.isEmpty()) { %>
                <div class="bg-white rounded-xl p-8 text-center shadow-sm">
                    <p class="text-gray-600 text-sm">No pending or confirmed orders.</p>
                </div>
            <% } else { %>

            <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
                <% for (Orders o : pendingOrders) { %>
                <div class="order-card bg-white p-5 rounded-xl shadow-sm border border-gray-100">
                    <div class="flex justify-between items-start mb-3">
                        <div>
                            <h3 class="text-lg font-bold text-gray-900">Order #<%= o.getOrderId() %></h3>
                            <p class="text-xs text-gray-500 mt-1"><%= o.getCreatedAt() %></p>
                        </div>
                        <span class="px-2.5 py-1 rounded-full text-xs font-semibold <%= "PENDING".equals(o.getOrderStatus()) ? "bg-yellow-100 text-yellow-800" : "bg-blue-100 text-blue-800" %>">
                            <%= o.getOrderStatus() %>
                        </span>
                    </div>

                    <div class="mb-4 pb-3 border-b border-gray-100">
                        <p class="text-sm text-gray-600 mb-1">
                            <span class="font-medium">Amount:</span> ₹<%= o.getTotalAmount() %>
                        </p>
                        <p class="text-sm text-gray-600">
                            <span class="font-medium">Payment:</span> <%= o.getPaymentMode() %>
                        </p>
                    </div>

                    <div class="flex gap-2">
                        <a href="<%= request.getContextPath() %>/admin/orderItems?orderId=<%= o.getOrderId() %>"
                           class="flex-1 text-center px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600 font-medium text-xs">
                            View Items
                        </a>

                        <form action="<%= request.getContextPath() %>/admin/orders" method="post" class="flex-1">
                            <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">

                            <% if ("PENDING".equals(o.getOrderStatus())) { %>
                                <input type="hidden" name="newStatus" value="CONFIRMED">
                                <button class="w-full px-4 py-2 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600 font-medium text-xs">
                                    Mark Confirmed
                                </button>

                            <% } else if ("CONFIRMED".equals(o.getOrderStatus())) { %>
                                <input type="hidden" name="newStatus" value="DELIVERED">
                                <button class="w-full px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 font-medium text-xs">
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
            <h2 class="text-lg font-bold text-gray-800 mb-4">✓ Delivered Orders</h2>

            <% if (completedOrders == null || completedOrders.isEmpty()) { %>
                <div class="bg-white rounded-xl p-8 text-center shadow-sm">
                    <p class="text-gray-600 text-sm">No delivered orders yet.</p>
                </div>
            <% } else { %>

            <div class="grid grid-cols-1 lg:grid-cols-2 gap-4">
                <% for (Orders o : completedOrders) { %>
                <div class="order-card bg-white p-5 rounded-xl shadow-sm border border-gray-100">
                    <div class="flex justify-between items-start mb-3">
                        <div>
                            <h3 class="text-lg font-bold text-gray-900">Order #<%= o.getOrderId() %></h3>
                            <p class="text-xs text-gray-500 mt-1"><%= o.getCreatedAt() %></p>
                        </div>
                        <span class="px-2.5 py-1 rounded-full text-xs font-semibold bg-green-100 text-green-800">
                            DELIVERED
                        </span>
                    </div>

                    <div class="mb-4 pb-3 border-b border-gray-100">
                        <p class="text-sm text-gray-600 mb-1">
                            <span class="font-medium">Amount:</span> ₹<%= o.getTotalAmount() %>
                        </p>
                        <p class="text-sm text-gray-600">
                            <span class="font-medium">Payment:</span> <%= o.getPaymentMode() %>
                        </p>
                    </div>

                    <a href="<%= request.getContextPath() %>/admin/orderItems?orderId=<%= o.getOrderId() %>"
                       class="block text-center bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600 font-medium text-xs">
                        View Items
                    </a>
                </div>
                <% } %>
            </div>

            <% } %>
        </section>

    </main>

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