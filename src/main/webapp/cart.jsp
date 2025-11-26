<%@ page import="java.util.*, com.foodtruck.model.*, com.foodtruck.model.Menu" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>Your Cart|FoodZone</title>

    <!-- Tailwind CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { brand: "#ff4d00", brandDark: "#e64500" } } }
        };
    </script>
</head>

<body class="bg-gray-100 min-h-screen">

<%
    User user = (User) request.getAttribute("user");
    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    Map<Integer, Menu> menuDetails = (Map<Integer, Menu>) request.getAttribute("menuDetails");

    // SAFE subtotal calculation
    Double totalObj = (Double) request.getAttribute("subTotal");
    double subTotal = totalObj != null ? totalObj : 0.0;
%>

<!-- NAVBAR -->
<nav class="bg-white shadow-md py-4 px-6 flex justify-between items-center sticky top-0 z-40">

    <div class="text-2xl font-bold text-brand cursor-pointer" onclick="window.location.href='home'">
        FoodZone
    </div>

    <div class="flex gap-6 items-center">
        <a href="home" class="text-gray-700 font-semibold hover:text-brand">Home</a>
        <a href="orders" class="text-gray-700 font-semibold hover:text-brand">My Orders</a>

        <a href="logout"
           class="px-4 py-2 bg-gray-800 text-white rounded-full hover:bg-black transition">
            Logout
        </a>
    </div>
</nav>

<!-- CART HEADER -->
<div class="bg-white text-center shadow-md py-4 mt-6 mx-10 rounded-lg">
    <h2 class="text-xl font-semibold text-gray-700">Your Cart</h2>
</div>

<!-- SUCCESS ERROR MESSAGES -->
<%
    String success = (String) request.getAttribute("cartSuccess");
    String error = (String) request.getAttribute("cartError");
%>

<% if (success != null) { %>
<div class="mx-10 mt-4 bg-green-100 text-green-700 px-4 py-3 rounded-lg text-center">
    <%= success %>
</div>
<% } %>

<% if (error != null) { %>
<div class="mx-10 mt-4 bg-red-100 text-red-700 px-4 py-3 rounded-lg text-center">
    <%= error %>
</div>
<% } %>

<!-- CART ITEMS -->
<div class="mx-10 mt-8 space-y-6">

<%
    if (cartItems != null && !cartItems.isEmpty()) {
        for (Cart item : cartItems) {
            Menu menu = menuDetails.get(item.getMenuId());
%>

    <div class="bg-white shadow-lg rounded-2xl p-6 flex justify-between items-center">

        <!--  NAME + PRICE -->
        <div>
            <h2 class="text-lg font-bold text-gray-900"><%= menu.getItemName() %></h2>
            <p class="text-gray-600 mt-1">₹ <%= menu.getPrice() %></p>
        </div>

        <!-- RIGHT: IMAGE + QUANTITY -->
        <div class="flex flex-col items-center">

            <!-- ITEM IMAGE -->
            <img src="menuImage?id=<%= menu.getMenuId() %>"
                 onerror="this.src='https://via.placeholder.com/120'"
                 class="w-28 h-28 object-cover rounded-lg shadow">

            <!-- QUANTITY CONTROLS -->
            <form action="cart" method="post" class="flex gap-3 mt-3">

                <input type="hidden" name="cartId" value="<%= item.getCartId() %>">
                <input type="hidden" name="action" value="update">

                <!-- decrease -->
                <button name="quantity" value="<%= item.getQuantity() - 1 %>"
                        class="px-3 py-1 bg-gray-300 rounded-lg hover:bg-gray-400">-</button>

                <!-- quantity display -->
                <div class="px-4 py-1 bg-gray-200 rounded-lg font-semibold">
                    <%= item.getQuantity() %>
                </div>

                <!-- increase -->
                <button name="quantity" value="<%= item.getQuantity() + 1 %>"
                        class="px-3 py-1 bg-gray-300 rounded-lg hover:bg-gray-400">+</button>

            </form>

            <!-- REMOVE -->
            <form action="cart" method="post" class="mt-2">
                <input type="hidden" name="cartId" value="<%= item.getCartId() %>">
                <input type="hidden" name="action" value="remove">

                <button class="text-red-500 hover:text-red-700 text-sm">
                    Remove
                </button>
            </form>

        </div>

    </div>

<%  
        }
    } else { 
%>
    <p class="text-center text-gray-600 text-lg mt-10">Your cart is empty.</p>
<% } %>

</div>

<!-- TOTAL PRICE -->
<div class="mx-10 mt-10 flex justify-end text-xl font-bold text-gray-800">
    Total: ₹ <%= subTotal %>
</div>

<!-- CHECKOUT BUTTON -->
<div class="mx-10 mt-6 mb-20">
    <a href="checkout"
       class="block w-full text-center bg-brand text-white py-3 rounded-full hover:bg-brandDark transition shadow-lg">
        Proceed to Checkout
    </a>
</div>

</body>
</html>

