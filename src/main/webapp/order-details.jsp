<%@ page import="java.util.*, com.foodtruck.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>Order Details | FoodZone</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { brand: "#ff4d00", brandDark: "#e64500" }
                }
            }
        }
    </script>
</head>

<body class="bg-gray-100 min-h-screen">

<%
    Orders order = (Orders) request.getAttribute("order");
    List<OrderItem> items = (List<OrderItem>) request.getAttribute("items");
    Map<Integer, Menu> menuDetails = (Map<Integer, Menu>) request.getAttribute("menuDetails");

    double finalTotal = (Double) request.getAttribute("finalTotal");
%>

<!-- NAVBAR -->
<nav class="bg-white shadow-md py-4 px-6 flex justify-between items-center sticky top-0">
    <div onclick="window.location.href='home'" class="text-2xl font-bold text-brand cursor-pointer">
        FoodZone
    </div>

    <div class="flex items-center gap-6">
        <a href="home" class="font-semibold text-gray-700 hover:text-brand">Home</a>
        <a href="order-history" class="font-semibold text-gray-700 hover:text-brand">My Orders</a>
        <a href="logout" class="px-4 py-2 bg-gray-800 text-white rounded-full hover:bg-black">
            Logout
        </a>
    </div>
</nav>

<h2 class="text-center text-2xl font-bold text-gray-800 mt-10">ORDER DETAILS</h2>

<!-- ORDER DETAILS BOX -->
<div class="mx-auto max-w-xl bg-white shadow-xl rounded-2xl p-8 mt-10">

    <!-- ITEMS TABLE -->
    <table class="w-full text-center border-collapse">
        <thead>
            <tr class="bg-gray-200 text-gray-700 font-semibold">
                <th class="py-3 border">Item</th>
                <th class="py-3 border">Qty</th>
                <th class="py-3 border">Total</th>
            </tr>
        </thead>

        <tbody>
            <% for (OrderItem it : items) { 
                Menu menu = menuDetails.get(it.getMenuId());
            %>

            <tr class="border-b">
                <td class="py-3 border font-semibold"><%= menu.getItemName() %></td>
                <td class="py-3 border"><%= it.getQuantity() %></td>
                <td class="py-3 border">Rs. <%= it.getQuantity() * it.getPrice() %></td>
            </tr>

            <% } %>
        </tbody>
    </table>

    <!-- FINAL TOTAL -->
    <div class="text-center text-xl font-bold text-gray-800 mt-6">
        Total: Rs. <%= finalTotal %>
    </div>

</div>

</body>
</html>
