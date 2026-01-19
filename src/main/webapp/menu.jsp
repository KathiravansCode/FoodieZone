<%@ page import="java.util.*, com.foodtruck.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>Menu | FoodZone</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { brand: "#ff4d00", brandDark: "#e64500" } } }
        };
    </script>
    <style>
        .modal-bg { background: rgba(0,0,0,0.7); backdrop-filter: blur(5px); }
        .menu-card { transition: all 0.3s ease; }
        .menu-card:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(0,0,0,0.15); }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        .fade-in { animation: fadeIn 0.5s ease; }
    </style>
</head>

<body class="bg-gray-50 min-h-screen">

<%
    User user = (User) request.getAttribute("user");
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    List<Menu> menuItems = (List<Menu>) request.getAttribute("menuItems");
    int cartCount = (request.getAttribute("cartItemCount") != null) ? (Integer) request.getAttribute("cartItemCount") : 0;
    boolean isLoggedIn = (user != null);
    Boolean requiresConfirmation = (Boolean) request.getAttribute("requiresConfirmation");
%>

<!-- NAVBAR -->
<nav class="bg-white shadow-md sticky top-0 z-40">
    <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
        <div class="text-2xl font-bold text-brand cursor-pointer" onclick="window.location.href='home'">
            🍕 FoodZone
        </div>

        <!-- SEARCH BAR -->
        <form action="menu" method="get" class="hidden md:flex w-1/2 mx-4">
            <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>">
            <input type="text" name="search"
                   value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"
                   placeholder="Search menu items..."
                   class="flex-grow px-5 py-3 border-2 border-gray-200 rounded-l-full focus:ring-2 focus:ring-brand outline-none text-base">
            <button class="px-6 bg-brand text-white rounded-r-full hover:bg-brandDark text-base font-medium">
                Search
            </button>
        </form>

        <div class="flex items-center gap-6">
            <% if (isLoggedIn) { %>
                <a href="orders" class="text-gray-700 font-semibold hover:text-brand text-base">My Orders</a>
                <a href="cart" class="relative" onclick="return checkLogin()">
                    <svg class="w-8 h-8 text-gray-700 hover:text-brand transition" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                    </svg>
                    <% if (cartCount > 0) { %>
                        <span class="absolute -top-2 -right-2 bg-brand text-white text-xs w-6 h-6 rounded-full flex items-center justify-center font-bold">
                            <%= cartCount %>
                        </span>
                    <% } %>
                </a>
                <a href="logout" class="px-5 py-2.5 bg-gray-800 text-white rounded-full hover:bg-black transition text-base font-medium">
                    Logout
                </a>
            <% } else { %>
                <button onclick="openLoginModal()" class="px-6 py-2.5 bg-brand text-white rounded-full hover:bg-brandDark transition text-base font-semibold">
                    Login
                </button>
            <% } %>
        </div>
    </div>
</nav>

<!-- RESTAURANT HEADER -->
<div class="bg-gradient-to-r from-orange-50 to-red-50 py-12">
    <div class="max-w-7xl mx-auto px-6">
        <div class="flex items-center gap-6">
            <img src="restaurantImage?id=<%= restaurant.getRestaurantId() %>"
                 onerror="this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=200'"
                 class="w-24 h-24 rounded-2xl object-cover shadow-lg">
            <div>
                <h1 class="text-4xl font-bold text-gray-900 mb-2"><%= restaurant.getName() %></h1>
                <p class="text-gray-600 text-lg">📍 <%= restaurant.getAddress() %></p>
                <div class="flex items-center gap-4 mt-2">
                    <span class="bg-white px-4 py-2 rounded-full text-base font-semibold">⭐ <%= restaurant.getRating() %></span>
                    <% if ("OPEN".equals(restaurant.getRestaurantStatus())) { %>
                        <span class="bg-green-500 text-white px-4 py-2 rounded-full text-base font-semibold">OPEN</span>
                    <% } else { %>
                        <span class="bg-red-500 text-white px-4 py-2 rounded-full text-base font-semibold">CLOSED</span>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MENU ITEMS -->
<section class="max-w-7xl mx-auto px-6 py-12">
    <h2 class="text-3xl font-bold text-gray-900 mb-8">🍽️ Menu</h2>

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
        <% for (Menu m : menuItems) { %>
        <div class="menu-card bg-white rounded-2xl overflow-hidden shadow-lg fade-in">
            <div class="relative h-48 overflow-hidden">
                <img src="menuImage?id=<%= m.getMenuId() %>"
                     onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400'"
                     class="w-full h-full object-cover">
                <% if (m.isAvailable()) { %>
                    <div class="absolute top-3 right-3 bg-green-500 text-white px-3 py-1 rounded-full text-xs font-bold">
                        Available
                    </div>
                <% } else { %>
                    <div class="absolute top-3 right-3 bg-red-500 text-white px-3 py-1 rounded-full text-xs font-bold">
                        Sold Out
                    </div>
                <% } %>
            </div>

            <div class="p-5">
                <h3 class="text-lg font-bold text-gray-900 mb-2"><%= m.getItemName() %></h3>
                <p class="text-gray-600 text-sm mb-3 line-clamp-2"><%= m.getDescription() %></p>
                
                <div class="flex items-center justify-between mb-4">
                    <span class="text-2xl font-bold text-brand">₹<%= m.getPrice() %></span>
                    <span class="text-gray-500 text-sm">⏱️ <%= m.getEstimatedTime() %> min</span>
                </div>

                <% if (isLoggedIn) { %>
                    <form action="addToCart" method="post">
                        <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                        <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>">
                        <input type="hidden" name="quantity" value="1">
                        <button type="submit" <%= !m.isAvailable() ? "disabled" : "" %>
                                class="w-full <%= m.isAvailable() ? "bg-brand hover:bg-brandDark" : "bg-gray-300 cursor-not-allowed" %> text-white py-3 rounded-xl transition font-semibold text-base">
                            <%= m.isAvailable() ? "Add to Cart" : "Unavailable" %>
                        </button>
                    </form>
                <% } else { %>
                    <button onclick="openLoginModal()" class="w-full bg-brand hover:bg-brandDark text-white py-3 rounded-xl transition font-semibold text-base">
                        Login to Order
                    </button>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>
</section>

<!-- PROCEED TO CART BUTTON -->
<% if (isLoggedIn && cartCount > 0) { %>
<div class="fixed bottom-6 left-0 right-0 flex justify-center z-30">
    <a href="cart" class="bg-brand hover:bg-brandDark text-white px-12 py-4 rounded-full shadow-2xl font-bold text-lg transition">
        View Cart (<%= cartCount %> items) →
    </a>
</div>
<% } %>

<!-- LOGIN MODAL -->
<div id="loginModal" class="hidden fixed inset-0 modal-bg flex items-center justify-center z-50 p-4">
    <div class="bg-white rounded-3xl shadow-2xl w-full max-w-md p-8 relative">
        <button onclick="closeLoginModal()" class="absolute top-6 right-6 text-gray-400 hover:text-gray-600 text-2xl">
            ✕
        </button>
        
        <h2 class="text-3xl font-bold text-gray-900 mb-2">Login Required</h2>
        <p class="text-gray-600 mb-8 text-base">Please login to add items to cart</p>

        <form action="login" method="post" class="space-y-5">
            <input type="hidden" name="redirect" value="auto">

            <div>
                <label class="block text-gray-700 font-semibold mb-2 text-base">Username</label>
                <input type="text" name="username" required
                       class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-brand outline-none text-base">
            </div>

            <div>
                <label class="block text-gray-700 font-semibold mb-2 text-base">Password</label>
                <input type="password" name="password" required
                       class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-brand outline-none text-base">
            </div>

            <button type="submit" class="w-full bg-brand hover:bg-brandDark text-white font-bold py-3.5 rounded-xl transition text-base">
                Login
            </button>
        </form>

        <p class="text-center text-gray-600 mt-6 text-base">
            Don't have an account?
            <a href="register" class="text-brand font-bold hover:underline">Create Account</a>
        </p>
    </div>
</div>

<!-- CART REPLACEMENT MODAL -->
<% if (requiresConfirmation != null && requiresConfirmation) {
    int incomingRestaurantId = (Integer) request.getAttribute("incomingRestaurantId");
    int menuId = (Integer) request.getAttribute("menuId");
    int quantity = (Integer) request.getAttribute("quantity");
%>
<div class="fixed inset-0 modal-bg flex items-center justify-center z-50">
    <div class="bg-white p-8 rounded-3xl shadow-2xl w-96 text-center">
        <div class="text-5xl mb-4">⚠️</div>
        <h2 class="text-2xl font-bold text-gray-800 mb-3">Replace Cart Items?</h2>
        <p class="text-gray-600 mb-6 text-base">
            Your cart contains items from another restaurant. Do you want to clear it and add this item?
        </p>

        <div class="flex gap-4">
            <form action="addToCart" method="post" class="flex-1">
                <input type="hidden" name="replace" value="true">
                <input type="hidden" name="restaurantId" value="<%= incomingRestaurantId %>">
                <input type="hidden" name="menuId" value="<%= menuId %>">
                <input type="hidden" name="quantity" value="<%= quantity %>">
                <button class="w-full px-6 py-3 bg-brand text-white rounded-xl hover:bg-brandDark font-semibold text-base">
                    Yes, Replace
                </button>
            </form>

            <button onclick="window.location.reload()" class="flex-1 px-6 py-3 bg-gray-300 rounded-xl hover:bg-gray-400 font-semibold text-base">
                Cancel
            </button>
        </div>
    </div>
</div>
<% } %>

<script>
    function openLoginModal() {
        document.getElementById('loginModal').classList.remove('hidden');
    }

    function closeLoginModal() {
        document.getElementById('loginModal').classList.add('hidden');
    }

    function checkLogin() {
        <% if (!isLoggedIn) { %>
            openLoginModal();
            return false;
        <% } %>
        return true;
    }

    document.getElementById('loginModal').addEventListener('click', function(e) {
        if (e.target === this) closeLoginModal();
    });
</script>

</body>
</html>