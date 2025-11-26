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
    <title><%= isEdit ? "Edit Menu Item" : "Add Menu Item" %></title>

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: { colors: { brand: "#ff4d00", brandDark: "#d84300" } }
            }
        }
    </script>
</head>

<body class="bg-gray-100 min-h-screen">

<div class="max-w-4xl mx-auto mt-14 bg-white p-10 rounded-2xl shadow-xl">

    <h1 class="text-3xl font-bold text-gray-900 mb-8">
        <%= isEdit ? "Edit Menu Item" : "Add New Menu Item" %>
    </h1>

    <form action="<%= request.getContextPath() %>/admin/menu" method="post" enctype="multipart/form-data">

        <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>">
        <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>">

        <% if (isEdit) { %>
            <input type="hidden" name="menuId" value="<%= menu.getMenuId() %>">
        <% } %>

        <div class="grid grid-cols-2 gap-6">

            <div>
                <label class="font-semibold mb-2 block">Item Name</label>
                <input type="text" name="itemName" required
                       value="<%= isEdit ? menu.getItemName() : "" %>"
                       class="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-brand">
            </div>

            <div>
                <label class="font-semibold mb-2 block">Price (₹)</label>
                <input type="number" name="price" step="0.01" required
                       value="<%= isEdit ? menu.getPrice() : "" %>"
                       class="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-brand">
            </div>

            <div class="col-span-2">
                <label class="font-semibold mb-2 block">Description</label>
                <textarea name="description" class="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-brand" rows="3"><%= isEdit ? menu.getDescription() : "" %></textarea>
            </div>

            <div>
                <label class="font-semibold mb-2 block">Estimated Time (mins)</label>
                <input type="number" name="estimatedTime" required
                       value="<%= isEdit ? menu.getEstimatedTime() : "" %>"
                       class="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-brand">
            </div>

            <div class="flex items-center mt-8 gap-2">
                <input type="checkbox" name="isAvailable"
                       <%= isEdit && menu.isAvailable() ? "checked" : "" %>
                       class="w-5 h-5">
                <label class="font-semibold">Available</label>
            </div>

            <div class="col-span-2">
                <label class="font-semibold mb-2 block">Menu Image</label>

                <input type="file" name="itemImage" accept="image/*" onchange="previewImage(event)"
                       class="w-full px-4 py-3 border rounded-lg bg-gray-50">

                <% if (isEdit) { %>
                    <img id="imgPreview"
                         src="<%= request.getContextPath() + "/menuImage?id=" + menu.getMenuId() %>"
                         class="mt-4 w-40 h-40 object-cover rounded-xl shadow">
                <% } else { %>
                    <img id="imgPreview" class="hidden mt-4 w-40 h-40 object-cover rounded-xl shadow">
                <% } %>
            </div>
        </div>

        <div class="mt-10 flex justify-between">
            <button type="submit" class="bg-brand text-white px-8 py-3 rounded-xl hover:bg-brandDark transition">
                <%= isEdit ? "Update Item" : "Add Item" %>
            </button>

            <a href="<%= request.getContextPath() %>/admin/menu?restaurantId=<%= restaurant.getRestaurantId() %>"
               class="bg-gray-300 px-8 py-3 rounded-xl hover:bg-gray-400">
                Cancel
            </a>
        </div>

    </form>
</div>

<script>
function previewImage(event) {
    const img = document.getElementById("imgPreview");
    img.src = URL.createObjectURL(event.target.files[0]);
    img.classList.remove("hidden");
}
</script>

</body>
</html>
