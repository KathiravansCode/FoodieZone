<%@ page import="java.util.*, com.foodtruck.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>Menu | FoodTruck</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { brand: "#ff4d00", brandDark: "#e64500" } } }
        };
    </script>

    <style>
        .modal-bg { background: rgba(0,0,0,0.5); }
    </style>
</head>

<body class="bg-gray-100 min-h-screen">

<%
    User user = (User) request.getAttribute("user");
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    List<Menu> menuItems = (List<Menu>) request.getAttribute("menuItems");

    int cartCount = (request.getAttribute("cartItemCount") != null)
                    ? (Integer) request.getAttribute("cartItemCount")
                    : 0;

    // Modal flag from AddToCartServlet
    Boolean requiresConfirmation = (Boolean) request.getAttribute("requiresConfirmation");
%>

<!-- NAVBAR -->
<nav class="bg-white shadow-md py-4 px-6 flex justify-between items-center sticky top-0 z-40">
    <div class="text-2xl font-bold text-brand cursor-pointer" onclick="window.location.href='home'">
        FoodZone
    </div>

    <!-- SEARCH BAR -->
    <form action="menu" method="get" class="flex w-1/2 mx-4">
        <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>">
        <input type="text" name="search"
               value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"
               placeholder="Search for menu items..."
               class="flex-grow px-4 py-2 border border-gray-300 rounded-l-full focus:ring-2 focus:ring-brand outline-none">
        <button class="px-5 bg-brand text-white rounded-r-full hover:bg-brandDark">Search</button>
    </form>

    <div class="flex items-center gap-6">
        <a href="orders" class="text-gray-700 font-semibold hover:text-brand">My Orders</a>

        <!-- CART ICON -->
        <a href="cart" class="relative">
            <img src="https://cdn-icons-png.flaticon.com/512/1170/1170678.png" class="w-8">
            <% if (cartCount > 0) { %>
            <span class="absolute -top-2 -right-2 bg-brand text-white text-xs w-5 h-5 rounded-full flex items-center justify-center">
                <%= cartCount %>
            </span>
            <% } %>
        </a>

        <a href="logout" class="px-4 py-2 bg-gray-800 text-white rounded-full hover:bg-black transition">Logout</a>
    </div>
</nav>

<!-- RESTAURANT TITLE -->
<div class="bg-white shadow-md text-center py-4 mt-4 mx-10 rounded-lg">
    <h2 class="text-lg font-semibold text-gray-700">
        Menu Items From <span class="text-brand font-bold"><%= restaurant.getName() %></span>
    </h2>
</div>

<!-- MENU GRID -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 px-10 pb-20 mt-10">

<% for (Menu m : menuItems) { %>

    <div class="bg-white shadow-lg rounded-2xl overflow-hidden hover:shadow-xl transition">

        <img src="menuImage?id=<%= m.getMenuId() %>"
             onerror="this.src='https://via.placeholder.com/300'"
             class="w-full h-60 object-cover">

        <div class="p-4">

            <h2 class="text-lg font-bold text-gray-900"><%= m.getItemName() %></h2>
            <p class="text-sm text-gray-600 mt-1">₹ <%= m.getPrice() %></p>
            <p class="text-xs text-gray-500 mt-1"><%= m.getDescription() %></p>

            <form action="addToCart" method="post" class="mt-4">
                <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>">
                <input type="hidden" name="quantity" value="1">

                <button class="w-full bg-brand hover:bg-brandDark text-white py-2 rounded-full transition">
                    Add to Cart
                </button>
            </form>

        </div>
    </div>

<% } %>

</div>

<div class="w-full flex justify-center mt-10 mb-20">
    <a href="cart" class="px-10 py-3 bg-brand text-white rounded-full hover:bg-brandDark shadow-md">
        Proceed to Cart
    </a>
</div>


<!-- MODAL FOR CART REPLACEMENT -->
<%
if (requiresConfirmation != null && requiresConfirmation) {

    int incomingRestaurantId = (Integer) request.getAttribute("incomingRestaurantId");
    int menuId = (Integer) request.getAttribute("menuId");
    int quantity = (Integer) request.getAttribute("quantity");
%>

<div class="fixed inset-0 modal-bg flex justify-center items-center">

    <div class="bg-white p-7 rounded-2xl shadow-lg w-96 text-center">

        <h2 class="text-xl font-bold text-gray-800">Replace Your Cart?</h2>

        <p class="text-gray-600 mt-3">
            You already have items from another restaurant.<br>
            Do you want to clear your cart and add this item?
        </p>

        <div class="flex justify-center gap-4 mt-6">

            <!-- YES: Replace cart -->
            <form action="addToCart" method="post">
                <input type="hidden" name="replace" value="true">
                <input type="hidden" name="restaurantId" value="<%= incomingRestaurantId %>">
                <input type="hidden" name="menuId" value="<%= menuId %>">
                <input type="hidden" name="quantity" value="<%= quantity %>">

                <button class="px-6 py-2 bg-brand text-white rounded-full hover:bg-brandDark">
                    Yes, Replace
                </button>
            </form>

            <!-- NO: Stay here -->
            <button onclick="window.location.reload()"
                    class="px-6 py-2 bg-gray-300 rounded-full hover:bg-gray-400">
                No
            </button>

        </div>

    </div>

</div>

<% } %>

</body>
</html>

