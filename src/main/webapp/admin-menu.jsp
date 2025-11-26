<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.foodtruck.model.Restaurant, com.foodtruck.model.Menu" %>

<%
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    List<Menu> menuItems = (List<Menu>) request.getAttribute("menuItems");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Manage Menu|Admin</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { brand: "#ff4d00", brandDark: "#d84300" }
                }
            }
        }
    </script>
</head>

<body class="bg-gray-100 min-h-screen">

<div class="max-w-7xl mx-auto mt-10 bg-white p-8 rounded-2xl shadow-xl">

    <div class="flex justify-between items-center mb-10">
        <h1 class="text-3xl font-bold text-gray-900">
            Menu – <%= restaurant.getName() %>
        </h1>

        <a href="<%= request.getContextPath() %>/admin/menu?action=add&restaurantId=<%= restaurant.getRestaurantId() %>"
           class="bg-brand text-white px-6 py-3 rounded-xl font-semibold hover:bg-brandDark transition">
            + Add New Item
        </a>
    </div>

    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-8">

        <% if (menuItems == null || menuItems.isEmpty()) { %>
            <p class="col-span-3 text-center text-gray-600 text-lg">No menu items found.</p>
        <% } %>

        <% for (Menu m : menuItems) { %>

        <div class="bg-white p-6 border rounded-xl shadow hover:shadow-lg transition">

            <img src="<%= request.getContextPath() + "/menuImage?id=" + m.getMenuId() %>"
                 class="w-full h-44 object-cover rounded-lg mb-4 shadow">

            <h2 class="text-xl font-bold"><%= m.getItemName() %></h2>
            <p class="text-gray-600 mt-2"><%= m.getDescription() %></p>

            <p class="text-brand font-bold text-xl mt-3">₹ <%= m.getPrice() %></p>
            <p class="text-gray-600 text-sm">Time: <%= m.getEstimatedTime() %> mins</p>

            <p class="mt-2 font-semibold <%= m.isAvailable() ? "text-green-600" : "text-red-600" %>">
                <%= m.isAvailable() ? "Available" : "Unavailable" %>
            </p>

            <div class="mt-6 flex justify-between">

                <a href="<%= request.getContextPath() %>/admin/menu?action=edit&restaurantId=<%= restaurant.getRestaurantId() %>&menuId=<%= m.getMenuId() %>"
                   class="px-4 py-2 bg-yellow-500 text-white rounded-lg hover:bg-yellow-600 transition">
                    Edit
                </a>

                <!-- delete menu item -->
                <form action="<%= request.getContextPath() %>/admin/menu" method="post"
                      onsubmit="return confirm('Delete this item?');">

                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="menuId" value="<%= m.getMenuId() %>">
                    <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>">

                    <button type="submit"
                            class="px-4 py-2 bg-red-500 text-white rounded-lg hover:bg-red-600 transition">
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
