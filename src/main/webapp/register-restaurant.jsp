<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Register Restaurant | FoodZone Admin</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { brand: "#ff4d00", brandDark: "#e64500" }
                }
            }
        }
    </script>
    <style>
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        @keyframes slideOut {
            to { opacity: 0; transform: translateX(100%); }
        }
        .slide-up { animation: slideUp 0.5s ease-out; }
        .notification { animation: slideUp 0.3s ease-out; }
        .notification-exit { animation: slideOut 0.3s ease-out; }
    </style>
</head>

<body class="bg-gradient-to-br from-orange-50 via-red-50 to-pink-50 min-h-screen flex items-center justify-center p-4">

<% String err = (String) request.getAttribute("adminError"); %>

<!-- NOTIFICATION CONTAINER -->
<div id="notification-container" class="fixed top-4 right-4 z-50 space-y-2"></div>

<div class="bg-white shadow-2xl rounded-3xl w-full max-w-2xl p-10 slide-up">

    <div class="text-center mb-8">
        <div class="text-5xl mb-3">🏪</div>
        <h1 class="text-3xl font-bold text-gray-900 mb-1">Register Your Restaurant</h1>
        <p class="text-sm text-gray-600">Set up your restaurant profile</p>
    </div>

    <form action="<%= request.getContextPath() %>/admin/registerRestaurant" 
          method="post" enctype="multipart/form-data" class="space-y-4">

        <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
                <label class="block text-gray-700 font-medium mb-1.5 text-sm">Restaurant Name</label>
                <input type="text" name="name" required
                       placeholder="e.g., Tasty Bites"
                       class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
            </div>

            <div>
                <label class="block text-gray-700 font-medium mb-1.5 text-sm">Phone Number</label>
                <input type="text" name="phone" required
                       placeholder="9876543210"
                       class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
            </div>
        </div>

        <div>
            <label class="block text-gray-700 font-medium mb-1.5 text-sm">Address</label>
            <textarea name="address" rows="2" required
                      placeholder="Full restaurant address..."
                      class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm resize-none"></textarea>
        </div>

        <div>
            <label class="block text-gray-700 font-medium mb-1.5 text-sm">Status</label>
            <select name="status" required
                    class="w-full px-4 py-2.5 border border-gray-200 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-brand text-sm">
                <option value="OPEN">OPEN</option>
                <option value="CLOSED">CLOSED</option>
            </select>
        </div>

        <div>
            <label class="block text-gray-700 font-medium mb-1.5 text-sm">Restaurant Image</label>
            <input type="file" name="restaurantImage" accept="image/*" onchange="previewImage(event)"
                   class="w-full px-4 py-2.5 border border-gray-200 rounded-lg bg-white text-sm file:mr-4 file:py-2 file:px-4 file:rounded-lg file:border-0 file:text-sm file:font-semibold file:bg-brand file:text-white hover:file:bg-brandDark">
            <img id="imgPreview" class="hidden mt-3 w-32 h-32 object-cover rounded-lg shadow-sm border border-gray-200">
        </div>

        <button class="w-full bg-brand text-white py-3 rounded-lg text-sm font-semibold hover:bg-brandDark transition shadow-sm mt-6">
            Register Restaurant
        </button>
    </form>

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
    notification.className = 'notification px-5 py-3 rounded-lg shadow-lg text-sm font-medium bg-red-500 text-white';
    notification.textContent = message;
    container.appendChild(notification);
    
    setTimeout(function() {
        notification.classList.add('notification-exit');
        setTimeout(function() { notification.remove(); }, 300);
    }, 3000);
}

<% if (err != null) { %>
    showNotification('<%= err %>', 'error');
<% } %>
</script>

</body>
</html>