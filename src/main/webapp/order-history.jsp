<%@ page import="java.util.*, com.foodtruck.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>My Orders | FoodZone</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: { colors: { brand: "#ff4d00", brandDark: "#e64500" } }
            }
        }
    </script>
</head>

<body class="bg-gray-100 min-h-screen">

<%
    User user = (User) request.getAttribute("user");
    List<Orders> orderHistory = (List<Orders>) request.getAttribute("orderHistory");

    String successMsg = (String) request.getAttribute("orderSuccess");
%>

<!-- NAVBAR -->
<nav class="bg-white shadow-md py-4 px-6 flex justify-between items-center sticky top-0">
    <div onclick="window.location.href='home'" class="text-2xl font-bold text-brand cursor-pointer">
        FoodZone
    </div>

    <div class="flex gap-6 items-center">
        <a href="home" class="font-semibold text-gray-700 hover:text-brand">Home</a>
        <a href="orders" class="font-semibold text-gray-700 hover:text-brand">My Orders</a>
        <a href="logout" class="px-4 py-2 bg-gray-800 text-white rounded-full hover:bg-black">
            Logout
        </a>
    </div>
</nav>

<!-- SUCCESS MESSAGE -->
<% if (successMsg != null) { %>
<div class="mx-10 mt-6 bg-green-100 text-green-700 px-4 py-3 rounded-lg text-center font-semibold">
    <%= successMsg %>
</div>
<% } %>

<!-- PAGE TITLE -->
<h2 class="text-center text-2xl font-bold text-gray-800 mt-10">Your Orders</h2>

<!-- ORDERS TABLE -->
<div class="mx-10 mt-8 overflow-x-auto">
    <table class="w-full bg-white rounded-xl shadow-lg overflow-hidden">
        <thead class="bg-gray-200 text-gray-700 font-semibold">
            <tr>
                <th class="py-3 px-4 border">Order Date</th>
                <th class="py-3 px-4 border">Total Amount</th>
                <th class="py-3 px-4 border">Order Status</th>
                <th class="py-3 px-4 border">Payment Status</th>
                <th class="py-3 px-4 border">View</th>
            </tr>
        </thead>

        <tbody>
        <% 
            if (orderHistory != null && !orderHistory.isEmpty()) {
                for (Orders o : orderHistory) {
        %>

            <tr class="border-b hover:bg-gray-50">
                <td class="py-3 px-4 border"><%= o.getCreatedAt() %></td>
                <td class="py-3 px-4 border font-semibold">₹ <%= o.getTotalAmount() %></td>
                <td class="py-3 px-4 border"><%= o.getOrderStatus() %></td>
                <td class="py-3 px-4 border"><%= o.getPaymentStatus() %></td>
                <td class="py-3 px-4 border">
                    <a href="order-details?orderId=<%= o.getOrderId() %>"
                       class="text-brand font-semibold hover:underline">
                        View Items
                    </a>
                </td>
            </tr>

        <% 
                }
            } else {
        %>

            <tr>
                <td colspan="5" class="py-6 text-center text-gray-500 font-semibold">
                    You have no previous orders.
                </td>
            </tr>

        <% } %>
        </tbody>

    </table>
</div>

</body>
</html>
