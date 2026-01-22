<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Create Account | FoodZone</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { brand: "#ff4d00", brandDark: "#e64500" } } }
        };
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
    <%
        String successMessage = (String) request.getAttribute("successMessage");
        String errorMessage = (String) request.getAttribute("error");
    %>

    <!-- NOTIFICATION CONTAINER -->
    <div id="notification-container" class="fixed top-4 right-4 z-50 space-y-2"></div>

    <div class="bg-white shadow-2xl rounded-3xl w-full max-w-lg p-10 slide-up my-8">
        <!-- LOGO -->
        <div class="text-center mb-8">
            <div class="text-5xl mb-3">🍕</div>
            <h1 class="text-3xl font-bold text-gray-900 mb-1">Create Account</h1>
            <p class="text-sm text-gray-600">Join FoodZone today!</p>
        </div>

        <form action="register" method="post" class="space-y-4">
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-gray-700 font-medium mb-1.5 text-sm">Full Name</label>
                    <input type="text" name="fullName" placeholder="John Doe" required
                           class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
                </div>

                <div>
                    <label class="block text-gray-700 font-medium mb-1.5 text-sm">Phone</label>
                    <input type="text" name="phone" placeholder="9876543210" required
                           class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
                </div>
            </div>

            <div>
                <label class="block text-gray-700 font-medium mb-1.5 text-sm">Email</label>
                <input type="email" name="email" placeholder="john@example.com" required
                       class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
            </div>

            <div>
                <label class="block text-gray-700 font-medium mb-1.5 text-sm">Address</label>
                <input type="text" name="address" placeholder="123 Main St, City" required
                       class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
            </div>

            <div class="grid grid-cols-2 gap-4">
                <div>
                    <label class="block text-gray-700 font-medium mb-1.5 text-sm">Username</label>
                    <input type="text" name="username" placeholder="johndoe" required
                           class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
                </div>

                <div>
                    <label class="block text-gray-700 font-medium mb-1.5 text-sm">Password</label>
                    <input type="password" name="password" placeholder="••••••••" required
                           class="w-full px-4 py-2.5 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand text-sm">
                </div>
            </div>

            <div>
                <label class="block text-gray-700 font-medium mb-1.5 text-sm">Role</label>
                <select name="role" required
                        class="w-full px-4 py-2.5 border border-gray-200 rounded-lg bg-white focus:outline-none focus:ring-2 focus:ring-brand text-sm">
                    <option value="" disabled selected>Select your role</option>
                    <option value="USER">🍽️ Customer</option>
                    <option value="ADMIN">🏪 Restaurant Owner</option>
                </select>
            </div>

            <button type="submit"
                    class="w-full bg-brand hover:bg-brandDark text-white font-semibold rounded-lg py-3 transition shadow-sm text-sm mt-6">
                Create Account
            </button>
        </form>

        <p class="text-center text-gray-600 mt-6 text-sm">
            Already have an account?
            <a href="login.jsp" class="text-brand font-semibold hover:underline">
                Login
            </a>
        </p>
    </div>

    <script>
        function showNotification(message, type) {
            const container = document.getElementById('notification-container');
            const notification = document.createElement('div');
            notification.className = 'notification px-5 py-3 rounded-lg shadow-lg text-sm font-medium ' + 
                (type === 'success' ? 'bg-green-500 text-white' : 'bg-red-500 text-white');
            notification.textContent = message;
            container.appendChild(notification);
            
            setTimeout(function() {
                notification.classList.add('notification-exit');
                setTimeout(function() { notification.remove(); }, 300);
            }, 4000);
        }

        <% if (successMessage != null) { %>
            showNotification('<%= successMessage %>', 'success');
        <% } %>
        <% if (errorMessage != null) { %>
            showNotification('<%= errorMessage %>', 'error');
        <% } %>
    </script>
</body>
</html>