<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.foodtruck.model.Menu, com.foodtruck.model.Restaurant" %>

<%
    Menu menu = (Menu) request.getAttribute("menu");
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    boolean isEdit = (menu != null);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <title><%= isEdit ? "Edit Menu Item" : "Add Menu Item" %> | FoodZone Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: { colors: { brand: "#ff4d00", brandDark: "#e64500" } }
            }
        }
    </script>
    <style>
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
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
                <a href="<%= request.getContextPath() %>/admin/menu?restaurantId=<%= restaurant.getRestaurantId() %>"
                   class="text-sm font-medium text-gray-700 hover:text-brand transition">
                    ← Back to Menu
                </a>
                <a href="<%= request.getContextPath() %>/logout"
                   class="bg-red-500 hover:bg-red-600 text-white px-5 py-2 rounded-full transition font-medium text-sm shadow-sm">
                    Logout
                </a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-3xl mx-auto px-4 py-6">

    <div class="bg-white rounded-xl shadow-sm p-6 slide-up">
        
        <h1 class="text-2xl font-bold text-gray-900 mb-6">
            <%= isEdit ? "Edit Menu Item" : "Add New Menu Item" %>
        </h1>

        <form action="<%= request.getContextPath() %>/admin/menu" method="post" enctype="multipart/form-data">

            <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>">
            <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>">

            <% if (isEdit) { %>
                <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
            <% } %>

            <div class="space-y-4">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-gray-700 font-medium mb-1.5 text-sm">Item Name</label>
                        <input type="text" name="itemName" required
                               value="<%= isEdit ? menu.getItemName() : "" %>"
                               placeholder="e.g., Margherita Pizza"
                               class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
                    </div>

                    <div>
                        <label class="block text-gray-700 font-medium mb-1.5 text-sm">Price (₹)</label>
                        <input type="number" name="price" step="0.01" required
                               value="<%= isEdit ? menu.getPrice() : "" %>"
                               placeholder="299.00"
                               class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
                    </div>
                </div>

                <div>
                    <label class="block text-gray-700 font-medium mb-1.5 text-sm">Description</label>
                    <textarea name="description" rows="3"
                              placeholder="Brief description of the item..."
                              class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm resize-none"><%= isEdit ? menu.getDescription() : "" %></textarea>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-gray-700 font-medium mb-1.5 text-sm">Estimated Time (minutes)</label>
                        <input type="number" name="estimatedTime" required
                               value="<%= isEdit ? menu.getEstimatedTime() : "" %>"
                               placeholder="20"
                               class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
                    </div>

                    <div class="flex items-end">
                        <label class="flex items-center gap-2 cursor-pointer">
                            <input type="checkbox" name="isAvailable"
                                   <%= isEdit && menu.isAvailable() ? "checked" : "" %>
                                   class="w-4 h-4 text-brand border-gray-300 rounded focus:ring-brand">
                            <span class="text-gray-700 font-medium text-sm">Item Available</span>
                        </label>
                    </div>
                </div>

                <div>
                    <label class="block text-gray-700 font-medium mb-1.5 text-sm">Menu Image</label>

                    <input type="file" name="itemImage" accept="image/*" onchange="previewImage(event)"
                           class="w-full px-4 py-2.5 border border-gray-200 rounded-lg bg-white text-sm file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-brand file:text-white hover:file:bg-brandDark">

                    <% if (isEdit) { %>
                        <p class="text-xs text-gray-500 mt-1">Leave blank to keep current image</p>
                        <img id="imgPreview"
                             src="<%= request.getContextPath() + "/menuImage?id=" + menu.getMenuId() %>"
                             class="mt-3 w-32 h-32 object-cover rounded-lg shadow-sm border border-gray-200">
                    <% } else { %>
                        <img id="imgPreview" class="hidden mt-3 w-32 h-32 object-cover rounded-lg shadow-sm border border-gray-200">
                    <% } %>
                </div>

            </div>

            <div class="mt-6 flex gap-3">
                <button type="submit" class="flex-1 bg-brand text-white px-6 py-2.5 rounded-lg hover:bg-brandDark transition font-semibold text-sm shadow-sm">
                    <%= isEdit ? "Update Item" : "Add Item" %>
                </button>

                <a href="<%= request.getContextPath() %>/admin/menu?restaurantId=<%= restaurant.getRestaurantId() %>"
                   class="px-6 py-2.5 bg-gray-200 hover:bg-gray-300 rounded-lg transition font-semibold text-sm text-center">
                    Cancel
                </a>
            </div>

        </form>
    </div>
</div>

<script>
function previewImage(event) {
    const img = document.getElementById("imgPreview");
    if (event.target.files && event.target.files[0]) {
        img.src = URL.createObjectURL(event.target.files[0]);
        img.classList.remove("hidden");
    }
}
</script>

</body>
</html>