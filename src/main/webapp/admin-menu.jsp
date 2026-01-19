<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.foodtruck.model.Restaurant, com.foodtruck.model.Menu" %>

<%
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    List<Menu> menuItems = (List<Menu>) request.getAttribute("menuItems");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Manage Menu | Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { brand: "#ff4d00", brandDark: "#d84300" } } }
        }
    </script>
    <style>
        .menu-card { transition: all 0.3s ease; }
        .menu-card:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(0,0,0,0.15); }
    </style>
</head>

<body class="bg-gray-50 min-h-screen">

<div class="max-w-7xl mx-auto mt-10 bg-white p-10 rounded-3xl shadow-2xl">

    <div class="flex justify-between items-center mb-10">
        <h1 class="text-4xl font-bold text-gray-900">
            🍽️ Menu – <%= restaurant.getName() %>
        </h1>

        <a href="<%= request.getContextPath() %>/admin/menu?action=add&restaurantId=<%= restaurant.getRestaurantId() %>"
           class="bg-brand text-white px-8 py-4 rounded-xl font-bold hover:bg-brandDark transition text-base shadow-lg">
            + Add New Item
        </a>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">

        <% if (menuItems == null || menuItems.isEmpty()) { %>
            <p class="col-span-3 text-center text-gray-600 text-xl">No menu items found.</p>
        <% } %>

        <% for (Menu m : menuItems) { %>

        <div class="menu-card bg-white p-6 border-2 border-gray-200 rounded-2xl shadow-lg">

            <img src="<%= request.getContextPath() + "/menuImage?id=" + m.getMenuId() %>"
                 class="w-full h-52 object-cover rounded-xl mb-5 shadow-md">

            <h2 class="text-2xl font-bold text-gray-900 mb-2"><%= m.getItemName() %></h2>
            <p class="text-gray-600 mb-4 text-base"><%= m.getDescription() %></p>

            <p class="text-brand font-bold text-2xl mb-2">₹ <%= m.getPrice() %></p>
            <p class="text-gray-600 text-base mb-3">⏱️ <%= m.getEstimatedTime() %> mins</p>

            <p class="mb-5 font-bold text-base <%= m.isAvailable() ? "text-green-600" : "text-red-600" %>">
                <%= m.isAvailable() ? "✓ Available" : "✕ Unavailable" %>
            </p>

            <div class="flex gap-3">

                <a href="<%= request.getContextPath() %>/admin/menu?action=edit&restaurantId=<%= restaurant.getRestaurantId() %>&menuId=<%= m.getMenuId() %>"
                   class="flex-1 text-center px-4 py-3 bg-yellow-500 text-white rounded-xl hover:bg-yellow-600 transition font-semibold text-base">
                    Edit
                </a>

                <form action="<%= request.getContextPath() %>/admin/menu" method="post"
                      onsubmit="return confirm('Delete this item?');" class="flex-1">

                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                    <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>">

                    <button type="submit"
                            class="w-full px-4 py-3 bg-red-500 text-white rounded-xl hover:bg-red-600 transition font-semibold text-base">
                        Delete
                    </button>
                </form>

            </div>

        </div>

        <% } %>

    </div>

</div>

</body>
</html>