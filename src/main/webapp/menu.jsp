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
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        .slide-up { animation: slideUp 0.4s ease-out forwards; }
        .fade-in { animation: fadeIn 0.3s ease-out; }
        .menu-card {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            height: 100%;
            display: flex;
            flex-direction: column;
        }
        .menu-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 24px -5px rgba(0, 0, 0, 0.12);
        }
        .menu-card img {
            transition: transform 0.3s ease;
        }
        .menu-card:hover img {
            transform: scale(1.05);
        }
        .cart-float {
            animation: slideUp 0.4s ease-out;
        }
        .line-clamp-2 {
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
    </style>
</head>

<body class="bg-gray-50 min-h-screen pb-24">
<%
    User user = (User) request.getAttribute("user");
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    List<Menu> menuItems = (List<Menu>) request.getAttribute("menuItems");
    int cartCount = (request.getAttribute("cartItemCount") != null) ? (Integer) request.getAttribute("cartItemCount") : 0;
    boolean isLoggedIn = (user != null);
    Boolean requiresConfirmation = (Boolean) request.getAttribute("requiresConfirmation");
%>

<!-- NAVBAR -->
<nav class="bg-white shadow-sm sticky top-0 z-40 border-b border-gray-100">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="text-2xl font-bold text-brand cursor-pointer flex items-center gap-2" onclick="window.location.href='home'">
                🍕 <span>FoodZone</span>
            </div>

            <!-- DESKTOP SEARCH -->
            <form action="menu" method="get" class="hidden md:flex flex-1 max-w-md mx-8">
                <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>">
                <div class="relative w-full">
                    <input type="text" name="search"
                           value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"
                           placeholder="Search menu..."
                           class="w-full pl-10 pr-4 py-2 border border-gray-200 rounded-full focus:outline-none focus:ring-2 focus:ring-brand focus:border-transparent text-sm">
                    <svg class="absolute left-3 top-2.5 w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                    </svg>
                </div>
            </form>

            <div class="flex items-center gap-4">
                <% if (isLoggedIn) { %>
                    <a href="order-history" class="text-gray-700 font-semibold hover:text-brand text-base">My Orders</a>
                    <a href="cart" onclick="return checkLogin()" class="relative p-2 hover:bg-gray-50 rounded-full transition">
                        <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                        </svg>
                        <% if (cartCount > 0) { %>
                            <span class="absolute -top-1 -right-1 bg-brand text-white text-xs w-5 h-5 rounded-full flex items-center justify-center font-semibold">
                                <%= cartCount %>
                            </span>
                        <% } %>
                    </a>
                    <a href="logout" class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-brand transition">Logout</a>
                <% } else { %>
                    <button onclick="openLoginModal()" class="px-5 py-2 bg-brand text-white rounded-full hover:bg-brandDark transition text-sm font-semibold">Sign In</button>
                <% } %>
            </div>
        </div>
    </div>
</nav>

<!-- RESTAURANT HEADER -->
<div class="bg-gradient-to-br from-orange-50 via-red-50 to-pink-50 py-8">
    <div class="max-w-7xl mx-auto px-4">
        <div class="flex items-center gap-4">
            <img src="restaurantImage?id=<%= restaurant.getRestaurantId() %>"
                 onerror="this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=200'"
                 class="w-20 h-20 rounded-2xl object-cover shadow-md">
            <div class="flex-1">
                <h1 class="text-2xl font-bold text-gray-900 mb-1"><%= restaurant.getName() %></h1>
                <p class="text-sm text-gray-600 mb-2">📍 <%= restaurant.getAddress() %></p>
                <div class="flex items-center gap-3">
                    <span class="bg-white px-2.5 py-1 rounded-full text-xs font-semibold shadow-sm">⭐ <%= restaurant.getRating() %></span>
                    <% if ("OPEN".equals(restaurant.getRestaurantStatus())) { %>
                        <span class="bg-green-500 text-white px-2.5 py-1 rounded-full text-xs font-semibold">OPEN</span>
                    <% } else { %>
                        <span class="bg-red-500 text-white px-2.5 py-1 rounded-full text-xs font-semibold">CLOSED</span>
                    <% } %>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- MENU ITEMS -->
<section class="max-w-7xl mx-auto px-4 py-6">
    <h2 class="text-xl font-bold text-gray-900 mb-5">Menu</h2>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">
        <% for (Menu m : menuItems) { %>
        <div class="menu-card bg-white rounded-xl overflow-hidden shadow-sm fade-in">
            <div class="relative h-40 overflow-hidden">
                <img src="menuImage?id=<%= m.getMenuId() %>"
                     onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400'"
                     class="w-full h-full object-cover">
                <% if (m.isAvailable()) { %>
                    <div class="absolute top-2 right-2 bg-green-500 text-white px-2 py-0.5 rounded-full text-xs font-semibold">Available</div>
                <% } else { %>
                    <div class="absolute top-2 right-2 bg-red-500 text-white px-2 py-0.5 rounded-full text-xs font-semibold">Sold Out</div>
                <% } %>
            </div>

            <div class="p-3.5 flex flex-col flex-1">
                <h3 class="text-sm font-bold text-gray-900 mb-1"><%= m.getItemName() %></h3>
                <p class="text-xs text-gray-500 mb-2 line-clamp-2"><%= m.getDescription() %></p>
                
                <div class="flex items-center justify-between mb-3 mt-auto">
                    <span class="text-lg font-bold text-brand">₹<%= m.getPrice() %></span>
                    <span class="text-xs text-gray-500">⏱️ <%= m.getEstimatedTime() %> min</span>
                </div>

                <% if (isLoggedIn) { %>
                    <form action="addToCart" method="post">
                        <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                        <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>">
                        <input type="hidden" name="quantity" value="1">
                        <button type="submit" <%= !m.isAvailable() ? "disabled" : "" %>
                                class="w-full <%= m.isAvailable() ? "bg-brand hover:bg-brandDark" : "bg-gray-300 cursor-not-allowed" %> text-white py-2 rounded-lg transition font-medium text-sm">
                            <%= m.isAvailable() ? "Add to Cart" : "Unavailable" %>
                        </button>
                    </form>
                <% } else { %>
                    <button onclick="openLoginModal()" class="w-full bg-brand hover:bg-brandDark text-white py-2 rounded-lg transition font-medium text-sm">
                        Login to Order
                    </button>
                <% } %>
            </div>
        </div>
        <% } %>
    </div>
</section>

<!-- FLOATING CART BUTTON -->
<% if (isLoggedIn && cartCount > 0) { %>
<div class="fixed bottom-6 left-0 right-0 flex justify-center z-30 px-4">
    <a href="cart" class="cart-float bg-brand hover:bg-brandDark text-white px-8 py-3.5 rounded-full shadow-2xl font-semibold text-sm transition flex items-center gap-2">
        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
        </svg>
        View Cart (<%= cartCount %>)
    </a>
</div>
<% } %>

<!-- LOGIN MODAL -->
<div id="loginModal" class="hidden fixed inset-0 bg-black bg-opacity-50 backdrop-blur-sm flex items-center justify-center z-50 p-4">
    <div class="bg-white rounded-3xl shadow-2xl w-full max-w-md p-8 relative fade-in">
        <button onclick="closeLoginModal()" class="absolute top-4 right-4 text-gray-400 hover:text-gray-600">
            <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
            </svg>
        </button>
        <h2 class="text-2xl font-bold text-gray-900 mb-2">Login Required</h2>
        <p class="text-gray-600 mb-6 text-sm">Please login to add items</p>
        <form action="login" method="post" class="space-y-4">
            <input type="hidden" name="redirect" value="auto">
            <div>
                <label class="block text-gray-700 font-medium mb-1.5 text-sm">Username</label>
                <input type="text" name="username" required class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
            </div>
            <div>
                <label class="block text-gray-700 font-medium mb-1.5 text-sm">Password</label>
                <input type="password" name="password" required class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
            </div>
            <button type="submit" class="w-full bg-brand hover:bg-brandDark text-white font-semibold py-3 rounded-lg transition text-sm">Login</button>
        </form>
        <p class="text-center text-gray-600 mt-6 text-sm">
            Don't have an account? <a href="register" class="text-brand font-semibold hover:underline">Create Account</a>
        </p>
    </div>
</div>

<!-- CART REPLACEMENT MODAL -->
<% if (requiresConfirmation != null && requiresConfirmation) {
    int incomingRestaurantId = (Integer) request.getAttribute("incomingRestaurantId");
    int menuId = (Integer) request.getAttribute("menuId");
    int quantity = (Integer) request.getAttribute("quantity");
%>
<div class="fixed inset-0 bg-black bg-opacity-50 backdrop-blur-sm flex items-center justify-center z-50 p-4">
    <div class="bg-white p-8 rounded-3xl shadow-2xl max-w-sm w-full text-center fade-in">
        <div class="text-4xl mb-3">⚠️</div>
        <h2 class="text-xl font-bold text-gray-800 mb-2">Replace Cart Items?</h2>
        <p class="text-gray-600 mb-6 text-sm">Your cart contains items from another restaurant. Clear it?</p>
        <div class="flex gap-3">
            <form action="addToCart" method="post" class="flex-1">
                <input type="hidden" name="replace" value="true">
                <input type="hidden" name="restaurantId" value="<%= incomingRestaurantId %>">
                <input type="hidden" name="menuId" value="<%= menuId %>">
                <input type="hidden" name="quantity" value="<%= quantity %>">
                <button class="w-full px-5 py-2.5 bg-brand text-white rounded-lg hover:bg-brandDark font-semibold text-sm">Yes, Replace</button>
            </form>
            <button onclick="window.location.reload()" class="flex-1 px-5 py-2.5 bg-gray-200 rounded-lg hover:bg-gray-300 font-semibold text-sm">Cancel</button>
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
    document.getElementById('loginModal')?.addEventListener('click', function(e) {
        if (e.target === this) closeLoginModal();
    });
</script>
</body>
</html>