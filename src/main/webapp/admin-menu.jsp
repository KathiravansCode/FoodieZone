<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.foodtruck.model.Restaurant, com.foodtruck.model.Menu" %>

<%
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    List<Menu> menuItems = (List<Menu>) request.getAttribute("menuItems");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Manage Menu | FoodZone Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { brand: "#ff4d00", brandDark: "#e64500" } } }
        }
    </script>
    <style>
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .menu-card { 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }
        .menu-card:hover { 
            transform: translateY(-3px); 
            box-shadow: 0 12px 24px -5px rgba(0,0,0,0.12);
        }
        .menu-card img {
            transition: transform 0.3s ease;
        }
        .menu-card:hover img {
            transform: scale(1.05);
        }
        .slide-up { animation: slideUp 0.4s ease-out; }
    </style>
</head>

<body class="bg-gray-50 min-h-screen">

<!-- NAVBAR -->
<nav class="bg-white shadow-sm sticky top-0 z-40 border-b border-gray-100">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <h1 class="text-2xl font-bold text-brand flex items-center gap-2">
                🏪 <span>FoodZone Admin</span>
            </h1>
            <div class="flex items-center gap-4">
                <a href="<%= request.getContextPath() %>/admin/dashboard"
                   class="text-sm font-medium text-gray-700 hover:text-brand transition">
                    ← Back to Dashboard
                </a>
                <a href="<%= request.getContextPath() %>/logout"
                   class="bg-red-500 hover:bg-red-600 text-white px-5 py-2 rounded-full transition font-medium text-sm shadow-sm">
                    Logout
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-7xl mx-auto px-4 py-6">

    <div class="flex justify-between items-center mb-6 slide-up">
        <div>
            <h1 class="text-2xl font-bold text-gray-900 mb-1">
                🍽️ Menu Management
            </h1>
            <p class="text-sm text-gray-600"><%= restaurant.getName() %></p>
        </div>

        <a href="<%= request.getContextPath() %>/admin/menu?action=add&restaurantId=<%= restaurant.getRestaurantId() %>"
           class="bg-brand text-white px-6 py-2.5 rounded-lg font-semibold hover:bg-brandDark transition text-sm shadow-sm flex items-center gap-2">
            <span>+</span> Add New Item
        </a>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-4">

        <% if (menuItems == null || menuItems.isEmpty()) { %>
            <div class="col-span-full bg-white rounded-xl p-12 text-center shadow-sm">
                <div class="text-5xl mb-3">🍽️</div>
                <p class="text-gray-600 text-base">No menu items found.</p>
            </div>
        <% } %>

        <% for (Menu m : menuItems) { %>

        <div class="menu-card bg-white rounded-xl overflow-hidden shadow-sm border border-gray-100">

            <div class="relative h-44 overflow-hidden">
                <img src="<%= request.getContextPath() + "/menuImage?id=" + m.getMenuId() %>"
                     onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400'"
                     class="w-full h-full object-cover">
                <div class="absolute top-2 right-2">
                    <span class="<%= m.isAvailable() ? "bg-green-500" : "bg-red-500" %> text-white px-2 py-1 rounded-full text-xs font-semibold">
                        <%= m.isAvailable() ? "Available" : "Unavailable" %>
                    </span>
                </div>
            </div>

            <div class="p-4">
                <h2 class="text-base font-bold text-gray-900 mb-1 truncate"><%= m.getItemName() %></h2>
                <p class="text-gray-600 mb-3 text-xs line-clamp-2"><%= m.getDescription() %></p>

                <div class="flex items-center justify-between mb-3">
                    <span class="text-brand font-bold text-lg">₹<%= m.getPrice() %></span>
                    <span class="text-gray-500 text-xs">⏱️ <%= m.getEstimatedTime() %> min</span>
                </div>

                <div class="flex gap-2">

                    <a href="<%= request.getContextPath() %>/admin/menu?action=edit&restaurantId=<%= restaurant.getRestaurantId() %>&menuId=<%= m.getMenuId() %>"
                       class="flex-1 text-center px-3 py-2 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600 transition font-semibold text-xs">
                        Edit
                    </a>

                    <form action="<%= request.getContextPath() %>/admin/menu" method="post"
                          onsubmit="return confirm('Delete this item?');" class="flex-1">

                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                        <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>">

                        <button type="submit"
                                class="w-full px-3 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition font-semibold text-xs">
                            Delete
                        </button>
                    </form>

                </div>

            </div>

        </div>

        <% } %>

    </div>

</div>

</body>
</html>