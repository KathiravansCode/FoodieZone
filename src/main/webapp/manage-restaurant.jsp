<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.foodtruck.model.Restaurant" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Manage Restaurant | Admin</title>

    <!-- Tailwind CDN -->
    <script src="https://cdn.tailwindcss.com"></script>

    <!-- Brand Theme -->
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: "#ff4d00",
                        brandDark: "#e64500",
                        brandLight: "#fff3eb"
                    }
                }
            }
        }
    </script>
</head>

<body class="bg-gray-100 min-h-screen">

<%
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    boolean isEdit = (restaurant != null);
%>

<!-- Page Container -->
<div class="max-w-4xl mx-auto mt-14 bg-white shadow-xl rounded-2xl p-10">

    <!-- Title -->
    <h1 class="text-3xl font-bold text-gray-900 mb-8">
        <%= isEdit ? "Edit Restaurant" : "Add New Restaurant" %>
    </h1>

    <!-- Error Message -->
    <%
        String error = (String) request.getAttribute("error");
        if (error != null) {
    %>
        <div class="bg-red-100 text-red-700 border border-red-400 px-4 py-3 rounded-lg mb-6 text-center">
            <%= error %>
        </div>
    <% } %>

    <!-- Form Start -->
    <form action="<%= request.getContextPath() %>/admin/restaurant/manage" method="post" enctype="multipart/form-data">

        <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>">

        <% if (isEdit) { %>
            <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>">
        <% } %>

        <div class="grid grid-cols-2 gap-6">

            <!-- Name -->
            <div>
                <label class="block text-gray-700 font-semibold mb-2">Restaurant Name</label>
                <input type="text" name="name" required
                       value="<%= isEdit ? restaurant.getName() : "" %>"
                       class="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-brand">
            </div>

            <!-- Phone -->
            <div>
                <label class="block text-gray-700 font-semibold mb-2">Phone Number</label>
                <input type="text" name="phone" required
                       value="<%= isEdit ? restaurant.getPhone() : "" %>"
                       class="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-brand">
            </div>

            <!-- Address -->
            <div class="col-span-2">
                <label class="block text-gray-700 font-semibold mb-2">Address</label>
                <textarea name="address" required
                          class="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-brand"
                          rows="3"><%= isEdit ? restaurant.getAddress() : "" %></textarea>
            </div>

            <!-- Rating -->
            <div>
                <label class="block text-gray-700 font-semibold mb-2">Rating</label>
                <input type="number" step="0.1" name="rating"
                       value="<%= isEdit ? restaurant.getRating() : "" %>"
                       class="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-brand">
            </div>

            <!-- Status -->
            <div>
                <label class="block text-gray-700 font-semibold mb-2">Status</label>
                <select name="restaurantStatus" required
                        class="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-brand">
                    <option value="OPEN" <%= isEdit && "OPEN".equals(restaurant.getRestaurantStatus()) ? "selected" : "" %>>OPEN</option>
                    <option value="CLOSED" <%= isEdit && "CLOSED".equals(restaurant.getRestaurantStatus()) ? "selected" : "" %>>CLOSED</option>
                </select>
            </div>

            <!-- Image -->
            <div class="col-span-2">
                <label class="block text-gray-700 font-semibold mb-2">Restaurant Image</label>
                <input type="file" name="restaurantImage"
                       class="w-full px-3 py-2 border rounded-lg bg-gray-50">

                <% if (isEdit && restaurant.getRestaurantId() > 0) { %>
                    <p class="text-sm text-gray-500 mt-2">Leave blank to keep current image.</p>
                <% } %>
            </div>

        </div>

        <!-- Buttons -->
        <div class="mt-10 flex justify-between">

            <!-- Save Button -->
            <button type="submit"
                    class="bg-brand hover:bg-brandDark text-white font-semibold px-8 py-3 rounded-xl transition">
                <%= isEdit ? "Update Restaurant" : "Add Restaurant" %>
            </button>

            <!-- Delete Button (only in edit mode) -->
            <% if (isEdit) { %>
                <a href="<%= request.getContextPath() %>/admin/restaurant/manage?action=delete&restaurantId=<%= restaurant.getRestaurantId() %>"
                   class="bg-red-500 hover:bg-red-600 text-white px-8 py-3 rounded-xl transition"
                   onclick="return confirm('Are you sure you want to delete this restaurant?');">
                    Delete
                </a>
            <% } %>

            <a href="<%= request.getContextPath() %>/admin/dashboard"
               class="bg-gray-300 hover:bg-gray-400 text-gray-900 px-6 py-3 rounded-xl">
                Cancel
            </a>

        </div>

    </form>
</div>

</body>
</html>
