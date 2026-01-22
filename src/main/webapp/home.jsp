<%@ page import="java.util.*, com.foodtruck.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>FoodZone - Order Your Favorite Food</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: "#ff4d00",
                        brandDark: "#e64500"
                    }
                }
            }
        }
    </script>
    <style>
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        @keyframes shimmer {
            0% { background-position: -1000px 0; }
            100% { background-position: 1000px 0; }
        }
        .slide-up { animation: slideUp 0.5s ease-out forwards; }
        .fade-in { animation: fadeIn 0.3s ease-out; }
        .notification-enter { animation: slideUp 0.3s ease-out; }
        .notification-exit { animation: fadeIn 0.3s ease-out reverse; }
        .restaurant-card { 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .restaurant-card:hover { 
            transform: translateY(-4px);
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }
        .restaurant-card img {
            transition: transform 0.3s ease;
        }
        .restaurant-card:hover img {
            transform: scale(1.05);
        }
        .gradient-shimmer {
            background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
            background-size: 1000px 100%;
            animation: shimmer 2s infinite;
        }
    </style>
</head>

<body class="bg-gray-50">
    <% 
        User user = (User) request.getAttribute("user"); 
        int cartCount = (request.getAttribute("cartItemCount") != null) ? (Integer) request.getAttribute("cartItemCount") : 0; 
        boolean isLoggedIn = (user != null);
    %>

    <!-- NAVBAR -->
    <nav class="bg-white shadow-sm sticky top-0 z-50 border-b border-gray-100">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex justify-between items-center h-16">
                <div class="flex items-center gap-8">
                    <div class="text-2xl font-bold text-brand cursor-pointer flex items-center gap-2" onclick="window.location.href='home'">
                        🍕 <span>FoodZone</span>
                    </div>
                </div>

                <!-- DESKTOP SEARCH -->
                <form action="home" method="get" class="hidden md:flex flex-1 max-w-md mx-8">
                    <div class="relative w-full">
                        <input type="text" name="search"
                               value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"
                               placeholder="Search restaurants..."
                               class="w-full pl-10 pr-4 py-2 border border-gray-200 rounded-full focus:outline-none focus:ring-2 focus:ring-brand focus:border-transparent text-sm">
                        <svg class="absolute left-3 top-2.5 w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                        </svg>
                    </div>
                </form>

                <!-- RIGHT MENU -->
                <div class="flex items-center gap-4">
                    <% if (isLoggedIn) { %>
                        <a href="order-history" class="text-gray-700 font-semibold hover:text-brand text-base">My Orders</a>
                        <a href="cart" class="relative p-2 hover:bg-gray-50 rounded-full transition">
                            <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                            </svg>
                            <% if (cartCount > 0) { %>
                                <span class="absolute -top-1 -right-1 bg-brand text-white text-xs w-5 h-5 flex items-center justify-center rounded-full font-semibold">
                                    <%= cartCount %>
                                </span>
                            <% } %>
                        </a>
                        <a href="logout" class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-brand transition">
                            Logout
                        </a>
                    <% } else { %>
                        <button onclick="openLoginModal()" class="px-5 py-2 bg-brand text-white rounded-full hover:bg-brandDark transition text-sm font-semibold shadow-sm">
                            Sign In
                        </button>
                    <% } %>
                </div>
            </div>

            <!-- MOBILE SEARCH -->
            <form action="home" method="get" class="md:hidden pb-3">
                <div class="relative">
                    <input type="text" name="search"
                           value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"
                           placeholder="Search restaurants..."
                           class="w-full pl-10 pr-4 py-2 border border-gray-200 rounded-full focus:outline-none focus:ring-2 focus:ring-brand text-sm">
                    <svg class="absolute left-3 top-2.5 w-5 h-5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                    </svg>
                </div>
            </form>
        </div>
    </nav>

    <!-- HERO SECTION -->
    <section class="bg-gradient-to-br from-orange-50 via-red-50 to-pink-50 py-12 px-4">
        <div class="max-w-7xl mx-auto">
            <div class="text-center slide-up">
                <h1 class="text-4xl md:text-5xl font-bold text-gray-900 mb-3">
                    Order Food <span class="text-brand">Online</span>
                </h1>
                <p class="text-lg text-gray-600 mb-6 max-w-2xl mx-auto">
                    Discover amazing restaurants • Fast delivery • Fresh food
                </p>
                <% if (isLoggedIn) { %>
                    <p class="text-lg font-medium text-brand">
                        Welcome back, <%= user.getFullName() %>! 👋
                    </p>
                <% } %>
            </div>
        </div>
    </section>

    <!-- NO RESTAURANTS FOUND -->
    <% Boolean notFound = (Boolean) request.getAttribute("noRestaurantFound"); %>
    <% if (notFound != null && notFound) { %>
        <div class="max-w-7xl mx-auto px-4 py-8">
            <div class="bg-yellow-50 border border-yellow-200 rounded-2xl p-6 text-center">
                <p class="text-yellow-800 font-medium">
                    No restaurants found for "<%= request.getAttribute("searchKeyword") %>"
                </p>
            </div>
        </div>
    <% } %>

    <!-- RESTAURANTS SECTION -->
    <section class="max-w-7xl mx-auto px-4 py-8">
        <h2 class="text-2xl font-bold text-gray-900 mb-6">
            Restaurants near you
        </h2>

        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-5">
            <%
                List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
                if (restaurants != null) {
                    for (Restaurant r : restaurants) {
            %>
            <div class="restaurant-card bg-white rounded-2xl overflow-hidden shadow-sm cursor-pointer" 
                 onclick="navigateToMenu(<%= r.getRestaurantId() %>, <%= isLoggedIn %>)">
                <div class="relative h-44 overflow-hidden">
                    <img src="restaurantImage?id=<%= r.getRestaurantId() %>"
                         onerror="this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400'"
                         class="w-full h-full object-cover" />
                    <div class="absolute top-3 right-3 bg-white px-2.5 py-1 rounded-full text-xs font-semibold shadow-sm">
                        ⭐ <%= r.getRating() %>
                    </div>
                    <% if ("OPEN".equals(r.getRestaurantStatus())) { %>
                        <div class="absolute top-3 left-3 bg-green-500 text-white px-2.5 py-1 rounded-full text-xs font-semibold">
                            OPEN
                        </div>
                    <% } else { %>
                        <div class="absolute top-3 left-3 bg-red-500 text-white px-2.5 py-1 rounded-full text-xs font-semibold">
                            CLOSED
                        </div>
                    <% } %>
                </div>

                <div class="p-4">
                    <h3 class="text-base font-bold text-gray-900 mb-1 truncate"><%= r.getName() %></h3>
                    <p class="text-sm text-gray-500 truncate mb-3">📍 <%= r.getAddress() %></p>
                    <button class="w-full bg-brand hover:bg-brandDark text-white py-2 rounded-lg transition font-medium text-sm">
                        View Menu
                    </button>
                </div>
            </div>
            <% 
                    }
                }
            %>
        </div>
    </section>

    <!-- LOGIN MODAL -->
    <div id="loginModal" class="hidden fixed inset-0 bg-black bg-opacity-50 backdrop-blur-sm flex items-center justify-center z-50 p-4">
        <div class="bg-white rounded-3xl shadow-2xl w-full max-w-md p-8 relative fade-in">
            <button onclick="closeLoginModal()" class="absolute top-4 right-4 text-gray-400 hover:text-gray-600">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
            </button>
            
            <h2 class="text-2xl font-bold text-gray-900 mb-2">Welcome Back!</h2>
            <p class="text-gray-600 mb-6 text-sm">Login to continue ordering</p>

            <form action="login" method="post" class="space-y-4">
                <input type="hidden" name="redirect" value="auto">

                <div>
                    <label class="block text-gray-700 font-medium mb-1.5 text-sm">Username</label>
                    <input type="text" name="username" required
                           class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand focus:border-transparent text-sm">
                </div>

                <div>
                    <label class="block text-gray-700 font-medium mb-1.5 text-sm">Password</label>
                    <input type="password" name="password" required
                           class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand focus:border-transparent text-sm">
                </div>

                <button type="submit" class="w-full bg-brand hover:bg-brandDark text-white font-semibold py-3 rounded-lg transition text-sm shadow-sm">
                    Login
                </button>
            </form>

            <p class="text-center text-gray-600 mt-6 text-sm">
                Don't have an account?
                <a href="register" class="text-brand font-semibold hover:underline">
                    Create Account
                </a>
            </p>
        </div>
    </div>

    <script>
        function openLoginModal() {
            document.getElementById('loginModal').classList.remove('hidden');
        }

        function closeLoginModal() {
            document.getElementById('loginModal').classList.add('hidden');
        }

        function navigateToMenu(restaurantId, isLoggedIn) {
            window.location.href = 'menu?restaurantId=' + restaurantId;
        }

        document.getElementById('loginModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeLoginModal();
            }
        });
    </script>
</body>
</html>