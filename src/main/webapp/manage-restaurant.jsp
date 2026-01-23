<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.foodtruck.model.Restaurant" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Manage Restaurant | FoodZone Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
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
    <style>
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes slideOut {
            to { opacity: 0; transform: translateX(100%); }
        }
        .slide-up { animation: slideUp 0.4s ease-out; }
        .notification { animation: slideUp 0.3s ease-out; }
        .notification-exit { animation: slideOut 0.3s ease-out; }
    </style>
</head>

<body class="bg-gray-50 min-h-screen">

<%
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    boolean isEdit = (restaurant != null);
    String error = (String) request.getAttribute("error");
%>

<!-- NOTIFICATION CONTAINER -->
<div id="notification-container" class="fixed top-20 right-4 z-50 space-y-2"></div>

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

<!-- Page Container -->
<div class="max-w-3xl mx-auto px-4 py-6">

    <div class="bg-white shadow-sm rounded-xl p-6 slide-up">

        <!-- Title -->
        <h1 class="text-2xl font-bold text-gray-900 mb-6">
            <%= isEdit ? "Edit Restaurant" : "Add New Restaurant" %>
        </h1>

        <!-- Form Start -->
        <form action="<%= request.getContextPath() %>/admin/restaurant/manage" method="post" enctype="multipart/form-data">

            <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>">

            <% if (isEdit) { %>
                <input type="hidden" name="restaurantId" value="<%= restaurant.getRestaurantId() %>">
            <% } %>

            <div class="space-y-4">

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- Name -->
                    <div>
                        <label class="block text-gray-700 font-medium mb-1.5 text-sm">Restaurant Name</label>
                        <input type="text" name="name" required
                               value="<%= isEdit ? restaurant.getName() : "" %>"
                               placeholder="e.g., Tasty Bites"
                               class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
                    </div>

                    <!-- Phone -->
                    <div>
                        <label class="block text-gray-700 font-medium mb-1.5 text-sm">Phone Number</label>
                        <input type="text" name="phone" required
                               value="<%= isEdit ? restaurant.getPhone() : "" %>"
                               placeholder="9876543210"
                               class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
                    </div>
                </div>

                <!-- Address -->
                <div>
                    <label class="block text-gray-700 font-medium mb-1.5 text-sm">Address</label>
                    <textarea name="address" required rows="2"
                              placeholder="Full restaurant address..."
                              class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm resize-none"><%= isEdit ? restaurant.getAddress() : "" %></textarea>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <!-- Rating -->
                    <div>
                        <label class="block text-gray-700 font-medium mb-1.5 text-sm">Rating</label>
                        <input type="number" step="0.1" name="rating" min="0" max="5"
                               value="<%= isEdit ? restaurant.getRating() : "" %>"
                               placeholder="4.5"
                               class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
                    </div>

                    <!-- Status -->
                    <div>
                        <label class="block text-gray-700 font-medium mb-1.5 text-sm">Status</label>
                        <select name="restaurantStatus" required
                                class="w-full px-4 py-2.5 border border-gray-200 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-brand text-sm">
                            <option value="OPEN" <%= isEdit && "OPEN".equals(restaurant.getRestaurantStatus()) ? "selected" : "" %>>OPEN</option>
                            <option value="CLOSED" <%= isEdit && "CLOSED".equals(restaurant.getRestaurantStatus()) ? "selected" : "" %>>CLOSED</option>
                        </select>
                    </div>
                </div>

                <!-- Image -->
                <div>
                    <label class="block text-gray-700 font-medium mb-1.5 text-sm">Restaurant Image</label>
                    <input type="file" name="restaurantImage" accept="image/*" onchange="previewImage(event)"
                           class="w-full px-4 py-2.5 border border-gray-200 rounded-lg bg-white text-sm file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-brand file:text-white hover:file:bg-brandDark">

                    <% if (isEdit && restaurant.getRestaurantId() > 0) { %>
                        <p class="text-xs text-gray-500 mt-1">Leave blank to keep current image</p>
                        <img id="imgPreview"
                             src="<%= request.getContextPath() + "/restaurantImage?id=" + restaurant.getRestaurantId() %>"
                             class="mt-3 w-32 h-32 object-cover rounded-lg shadow-sm border border-gray-200">
                    <% } else { %>
                        <img id="imgPreview" class="hidden mt-3 w-32 h-32 object-cover rounded-lg shadow-sm border border-gray-200">
                    <% } %>
                </div>

            </div>

            <!-- Buttons -->
            <div class="mt-6 flex justify-between">

                <!-- Save Button -->
                <button type="submit"
                        class="bg-brand hover:bg-brandDark text-white font-semibold px-6 py-2.5 rounded-lg transition text-sm shadow-sm">
                    <%= isEdit ? "Update Restaurant" : "Add Restaurant" %>
                </button>

                <div class="flex gap-3">
                    <!-- Delete Button (only in edit mode) -->
                    <% if (isEdit) { %>
                        <a href="<%= request.getContextPath() %>/admin/restaurant/manage?action=delete&restaurantId=<%= restaurant.getRestaurantId() %>"
                           class="bg-red-500 hover:bg-red-600 text-white px-6 py-2.5 rounded-lg transition text-sm font-semibold"
                           onclick="return confirm('Are you sure you want to delete this restaurant?');">
                            Delete
                        </a>
                    <% } %>

                    <a href="<%= request.getContextPath() %>/admin/dashboard"
                       class="bg-gray-200 hover:bg-gray-300 text-gray-900 px-6 py-2.5 rounded-lg text-sm font-semibold">
                        Cancel
                    </a>
                </div>

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

function showNotification(message, type) {
    const container = document.getElementById('notification-container');
    const notification = document.createElement('div');
    notification.className = 'notification px-5 py-3 rounded-lg shadow-lg text-sm font-medium ' + 
        (type === 'error' ? 'bg-red-500 text-white' : 'bg-green-500 text-white');
    notification.textContent = message;
    container.appendChild(notification);
    
    setTimeout(function() {
        notification.classList.add('notification-exit');
        setTimeout(function() { notification.remove(); }, 300);
    }, 3000);
}

<% if (error != null) { %>
    showNotification('<%= error %>', 'error');
<% } %>
</script>

</body>
</html>