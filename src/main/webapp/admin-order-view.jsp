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
                    colors: {
                        brand: "#ff4d00",
                        brandDark: "#d84300",
                        brandLight: "#fff3eb"
                    }
                }
            }
        }
    </script>
</head>

<body class="bg-gray-100">

<!--HEADER-->
<header class="bg-white shadow-md fixed top-0 left-0 right-0 z-30">
    <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
        <h1 class="text-2xl font-bold text-brand">FoodTruck Admin</h1>
        <div class="flex items-center gap-4">
            <span class="font-semibold text-gray-800"><%= restaurant.getName() %></span>
            <a href="<%= request.getContextPath() %>/logout"
               class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg">Logout</a>
        </div>
    </div>
</header>

<!-- SIDEBAR AND CONTENT  -->
<div class="flex mt-20">

    <!-- SIDEBAR -->
    <aside class="w-64 h-screen bg-white shadow-xl fixed top-20 left-0 p-6">
        <h2 class="text-xl font-bold text-gray-800 mb-6">Dashboard Menu</h2>

        <nav class="space-y-4">
            <a href="<%= request.getContextPath() %>/admin/dashboard"
               class="block bg-white border border-brand text-brand font-semibold px-4 py-3 rounded-lg hover:bg-brand hover:text-white transition">Overview</a>

            <a href="<%= request.getContextPath() %>/admin/menu?restaurantId=<%= restaurant.getRestaurantId() %>"
               class="block bg-white border border-brand text-brand font-semibold px-4 py-3 rounded-lg hover:bg-brand hover:text-white transition">Manage Menu</a>

            <a href="<%= request.getContextPath() %>/admin/orders"
               class="block bg-brandLight text-brand font-semibold px-4 py-3 rounded-lg hover:bg-brand hover:text-white transition">Orders</a>

            <a href="<%= request.getContextPath() %>/admin/restaurant/manage?action=edit&restaurantId=<%= restaurant.getRestaurantId() %>"
               class="block bg-white border border-brand text-brand font-semibold px-4 py-3 rounded-lg hover:bg-brand hover:text-white transition">Restaurant Settings</a>
        </nav>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="flex-1 ml-72 p-10">

        <!-- SUCCESS / ERROR MESSAGES -->
        <% if (success != null) { %>
            <div class="bg-green-100 border border-green-400 text-green-800 px-4 py-3 rounded-lg mb-6">
                <%= success %>
            </div>
        <% } %>

        <% if (error != null) { %>
            <div class="bg-red-100 border border-red-400 text-red-800 px-4 py-3 rounded-lg mb-6">
                <%= error %>
            </div>
        <% } %>


        <h1 class="text-3xl font-bold mb-8 text-gray-900">
            Orders for <span class="text-brand"><%= restaurant.getName() %></span>
        </h1>

        <!-- ===================== PENDING / CONFIRMED ORDERS ===================== -->
        <section class="mb-12">
            <h2 class="text-2xl font-bold text-gray-800 mb-6">Pending & Confirmed Orders</h2>

            <% if (pendingOrders == null || pendingOrders.isEmpty()) { %>
                <p class="text-gray-600">No pending or confirmed orders.</p>
            <% } else { %>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <% for (Orders o : pendingOrders) { %>
                <div class="bg-white p-6 rounded-xl shadow hover:shadow-lg transition">
                    <h3 class="text-xl font-bold text-gray-900">Order #<%= o.getOrderId() %></h3>

                    <p class="text-gray-700 mt-2">
                        <strong>Status:</strong> 
                        <span class="text-brand"><%= o.getOrderStatus() %></span>
                    </p>

                    <p class="mt-1 text-gray-600"><strong>Amount:</strong> ₹<%= o.getTotalAmount() %></p>
                    <p class="mt-1 text-gray-600"><strong>Payment:</strong> <%= o.getPaymentMode() %></p>

                    <div class="mt-5 flex gap-3">
                        <!-- VIEW ITEMS -->
                        <a href="<%= request.getContextPath() %>/admin/orderItems?orderId=<%= o.getOrderId() %>"
                           class="px-4 py-2 bg-blue-500 text-white rounded-lg hover:bg-blue-600">View Items</a>

                        <!-- NEXT STATUS BUTTON -->
                        <form action="<%= request.getContextPath() %>/admin/orders" method="post">
                            <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">

                            <% if ("PENDING".equals(o.getOrderStatus())) { %>
                                <input type="hidden" name="newStatus" value="CONFIRMED">
                                <button class="px-4 py-2 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600">
                                    Mark as Confirmed
                                </button>

                            <% } else if ("CONFIRMED".equals(o.getOrderStatus())) { %>
                                <input type="hidden" name="newStatus" value="DELIVERED">
                                <button class="px-4 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700">
                                    Mark as Delivered
                                </button>
                            <% } %>

                        </form>
                    </div>
                </div>
                <% } %>
            </div>

            <% } %>
        </section>


        <!-- DELIVERED ORDERS  -->
        <section>
            <h2 class="text-2xl font-bold text-gray-800 mb-6">Delivered Orders</h2>

            <% if (completedOrders == null || completedOrders.isEmpty()) { %>
                <p class="text-gray-600">No delivered orders yet.</p>
            <% } else { %>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <% for (Orders o : completedOrders) { %>
                <div class="bg-white p-6 rounded-xl shadow hover:shadow-lg transition">
                    <h3 class="text-xl font-bold text-gray-900">Order #<%= o.getOrderId() %></h3>

                    <p class="mt-2 text-green-700 font-semibold">Delivered</p>

                    <p class="mt-1 text-gray-600"><strong>Amount:</strong> ₹<%= o.getTotalAmount() %></p>
                    <p class="mt-1 text-gray-600"><strong>Payment:</strong> <%= o.getPaymentMode() %></p>

                    <a href="<%= request.getContextPath() %>/admin/orderItems?orderId=<%= o.getOrderId() %>"
                       class="mt-4 inline-block bg-blue-500 text-white px-4 py-2 rounded-lg hover:bg-blue-600">
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
