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
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-40px); }
            to { opacity: 1; transform: translateX(0); }
        }
        @keyframes float {
            0%, 100% { transform: translateY(0px); }
            50% { transform: translateY(-20px); }
        }
        .fade-in-up { animation: fadeInUp 0.8s ease forwards; }
        .slide-in { animation: slideIn 1s ease forwards; }
        .float { animation: float 3s ease-in-out infinite; }
        .restaurant-card { transition: all 0.3s ease; }
        .restaurant-card:hover { transform: translateY(-8px); box-shadow: 0 20px 40px rgba(0,0,0,0.15); }
        .modal-bg { background: rgba(0,0,0,0.7); backdrop-filter: blur(5px); }
    </style>
</head>

<body class="bg-gray-50">

    <% 
        User user = (User) request.getAttribute("user"); 
        int cartCount = (request.getAttribute("cartItemCount") != null) ? (Integer) request.getAttribute("cartItemCount") : 0; 
        boolean isLoggedIn = (user != null);
    %>

    <!-- NAVBAR -->
    <nav class="bg-white shadow-md sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
            <div class="text-3xl font-bold text-brand cursor-pointer" onclick="window.location.href='home'">
                🍕 FoodZone
            </div>

            <!-- SEARCH BAR -->
            <form action="home" method="get" class="hidden md:flex w-1/2 mx-4">
                <input type="text" name="search"
                       value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"
                       placeholder="Search for restaurants..."
                       class="flex-grow px-5 py-3 border-2 border-gray-200 rounded-l-full focus:ring-2 focus:ring-brand focus:border-brand outline-none text-base">
                <button class="px-6 bg-brand text-white rounded-r-full hover:bg-brandDark transition text-base font-medium">
                    Search
                </button>
            </form>

            <!-- RIGHT MENU -->
            <div class="flex items-center gap-6">
                <% if (isLoggedIn) { %>
                    <a href="orders" class="text-gray-700 font-semibold hover:text-brand transition text-base">
                        My Orders
                    </a>
                    <a href="cart" class="relative">
                        <svg class="w-8 h-8 text-gray-700 hover:text-brand transition" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
                        </svg>
                        <% if (cartCount > 0) { %>
                            <span class="absolute -top-2 -right-2 bg-brand text-white text-xs w-6 h-6 flex items-center justify-center rounded-full font-bold">
                                <%= cartCount %>
                            </span>
                        <% } %>
                    </a>
                    <a href="logout" class="px-5 py-2.5 bg-gray-800 text-white rounded-full hover:bg-black transition text-base font-medium">
                        Logout
                    </a>
                <% } else { %>
                    <button onclick="openLoginModal()" class="px-6 py-2.5 bg-brand text-white rounded-full hover:bg-brandDark transition text-base font-semibold shadow-lg">
                        Login / Sign Up
                    </button>
                <% } %>
            </div>
        </div>

        <!-- MOBILE SEARCH -->
        <form action="home" method="get" class="md:hidden px-6 pb-4">
            <div class="flex">
                <input type="text" name="search"
                       value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"
                       placeholder="Search restaurants..."
                       class="flex-grow px-4 py-2.5 border-2 border-gray-200 rounded-l-full focus:ring-2 focus:ring-brand outline-none">
                <button class="px-5 bg-brand text-white rounded-r-full hover:bg-brandDark transition">
                    Search
                </button>
            </div>
        </form>
    </nav>

    <!-- HERO SECTION -->
    <section class="bg-gradient-to-r from-orange-50 to-red-50 py-16 px-6">
        <div class="max-w-7xl mx-auto grid md:grid-cols-2 gap-10 items-center">
            <div class="slide-in">
                <h1 class="text-5xl md:text-6xl font-bold text-gray-900 mb-4">
                    Order Food <span class="text-brand">Online</span>
                </h1>
                <p class="text-xl text-gray-600 mb-8">
                    Discover the best restaurants near you. Fast delivery, fresh food, amazing taste!
                </p>
                <% if (isLoggedIn) { %>
                    <p class="text-2xl font-semibold text-brand">
                        Welcome back, <%= user.getFullName() %>! 👋
                    </p>
                <% } else { %>
                    <button onclick="openLoginModal()" class="px-8 py-4 bg-brand text-white rounded-full text-lg font-semibold hover:bg-brandDark transition shadow-xl">
                        Get Started →
                    </button>
                <% } %>
            </div>
            <div class="hidden md:block float">
                <svg viewBox="0 0 200 200" class="w-full max-w-md mx-auto">
                    <circle cx="100" cy="100" r="80" fill="#ff4d00" opacity="0.1"/>
                    <text x="100" y="120" font-size="80" text-anchor="middle" fill="#ff4d00">🍔</text>
                </svg>
            </div>
        </div>
    </section>

    <!-- NO RESTAURANTS FOUND -->
    <% Boolean notFound = (Boolean) request.getAttribute("noRestaurantFound"); %>
    <% if (notFound != null && notFound) { %>
        <div class="max-w-7xl mx-auto px-6 py-10">
            <div class="bg-red-50 border-2 border-red-200 rounded-2xl p-8 text-center">
                <p class="text-red-600 font-semibold text-xl">
                    No restaurants found for "<%= request.getAttribute("searchKeyword") %>".
                </p>
            </div>
        </div>
    <% } %>

    <!-- RESTAURANTS SECTION -->
    <section class="max-w-7xl mx-auto px-6 py-16">
        <h2 class="text-4xl font-bold text-gray-900 mb-10 text-center fade-in-up">
            🍽️ Available Restaurants
        </h2>

        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">
            <%
                List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
                if (restaurants != null) {
                    for (Restaurant r : restaurants) {
            %>
            <div class="restaurant-card bg-white rounded-3xl overflow-hidden shadow-lg cursor-pointer" 
                 onclick="navigateToMenu(<%= r.getRestaurantId() %>, <%= isLoggedIn %>)">
                <div class="relative h-56 overflow-hidden">
                    <img src="restaurantImage?id=<%= r.getRestaurantId() %>"
                         onerror="this.src='https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400'"
                         class="w-full h-full object-cover transition-transform hover:scale-110" />
                    <div class="absolute top-4 right-4 bg-white px-3 py-1.5 rounded-full text-sm font-semibold">
                        ⭐ <%= r.getRating() %>
                    </div>
                    <div class="absolute top-4 left-4">
                        <% if ("OPEN".equals(r.getRestaurantStatus())) { %>
                            <span class="bg-green-500 text-white px-3 py-1.5 rounded-full text-sm font-semibold">
                                OPEN
                            </span>
                        <% } else { %>
                            <span class="bg-red-500 text-white px-3 py-1.5 rounded-full text-sm font-semibold">
                                CLOSED
                            </span>
                        <% } %>
                    </div>
                </div>

                <div class="p-5">
                    <h3 class="text-xl font-bold text-gray-900 mb-2"><%= r.getName() %></h3>
                    <p class="text-gray-600 text-base mb-4">📍 <%= r.getAddress() %></p>
                    <button class="w-full bg-brand hover:bg-brandDark text-white py-3 rounded-full transition font-semibold text-base">
                        View Menu →
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
    <div id="loginModal" class="hidden fixed inset-0 modal-bg flex items-center justify-center z-50 p-4">
        <div class="bg-white rounded-3xl shadow-2xl w-full max-w-md p-8 relative fade-in-up">
            <button onclick="closeLoginModal()" class="absolute top-6 right-6 text-gray-400 hover:text-gray-600 text-2xl">
                ✕
            </button>
            
            <h2 class="text-3xl font-bold text-gray-900 mb-2">Welcome Back!</h2>
            <p class="text-gray-600 mb-8 text-base">Login to continue ordering delicious food</p>

            <form action="login" method="post" class="space-y-5">
                <input type="hidden" name="redirect" value="auto">

                <div>
                    <label class="block text-gray-700 font-semibold mb-2 text-base">Username</label>
                    <input type="text" name="username" required
                           class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-brand focus:border-brand outline-none text-base">
                </div>

                <div>
                    <label class="block text-gray-700 font-semibold mb-2 text-base">Password</label>
                    <input type="password" name="password" required
                           class="w-full px-4 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-brand focus:border-brand outline-none text-base">
                </div>

                <button type="submit" class="w-full bg-brand hover:bg-brandDark text-white font-bold py-3.5 rounded-xl transition text-base shadow-lg">
                    Login
                </button>
            </form>

            <p class="text-center text-gray-600 mt-6 text-base">
                Don't have an account?
                <a href="register" class="text-brand font-bold hover:underline">
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

        // Close modal on outside click
        document.getElementById('loginModal').addEventListener('click', function(e) {
            if (e.target === this) {
                closeLoginModal();
            }
        });
    </script>

</body>
</html>