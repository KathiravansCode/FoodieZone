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
    <title>Order Items|Admin</title>

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

<!-- HEADER -->
<header class="bg-white shadow-md fixed top-0 left-0 right-0 z-30">
    <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
        <h1 class="text-2xl font-bold text-brand">FoodTruck Admin</h1>
        <a href="<%= request.getContextPath() %>/admin/orders"
           class="bg-gray-700 hover:bg-gray-800 text-white px-4 py-2 rounded-lg">Back</a>
    </div>
</header>

<div class="max-w-5xl mx-auto mt-24 bg-white p-8 rounded-2xl shadow-xl">

    <h1 class="text-3xl font-bold mb-6">
        Order #<%= order.getOrderId() %> - Items
    </h1>

    <p class="text-gray-600 mb-6">
        <strong>Status:</strong> <%= order.getOrderStatus() %> <br>
        <strong>Total Amount:</strong> ₹ <%= order.getTotalAmount() %>
    </p>

    <div class="space-y-6">

        <% 
        for (int i = 0; i < items.size(); i++) {
            OrderItem oi = items.get(i);
            Menu m = menuDetails.get(i);
        %>

        <div class="flex gap-6 items-center bg-gray-50 p-5 rounded-xl shadow">

            <!-- IMAGE -->
            <img src="<%= request.getContextPath() + "/menuImage?id=" + m.getMenuId() %>"
                 class="w-28 h-28 object-cover rounded-xl shadow">

            <!-- DETAILS -->
            <div class="flex-1">
                <h2 class="text-xl font-bold text-gray-900"><%= m.getItemName() %></h2>

                <p class="text-gray-600 mt-1">Price: ₹<%= oi.getPrice() %></p>
                <p class="text-gray-600">Quantity: <%= oi.getQuantity() %></p>

                <p class="mt-2 font-bold text-brand text-lg">
                    Total: ₹<%= oi.getQuantity() * oi.getPrice() %>
                </p>
            </div>

        </div>

        <% } %>

    </div>

</div>

</body>
</html>
