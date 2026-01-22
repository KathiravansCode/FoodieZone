<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login | FoodZone</title>
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
    <% String loginError = (String) request.getAttribute("loginError"); %>
    
    <!-- NOTIFICATION CONTAINER -->
    <div id="notification-container" class="fixed top-4 right-4 z-50 space-y-2"></div>

    <div class="bg-white shadow-2xl rounded-3xl w-full max-w-md p-10 slide-up">
        <!-- LOGO -->
        <div class="text-center mb-8">
            <div class="text-5xl mb-3">🍕</div>
            <h1 class="text-3xl font-bold text-gray-900 mb-1">Welcome Back!</h1>
            <p class="text-sm text-gray-600">Login to continue to FoodZone</p>
        </div>

        <form action="login" method="post" class="space-y-5">
            <input type="hidden" name="redirect" value="auto">

            <div>
                <label class="block text-gray-700 font-medium mb-1.5 text-sm">Username</label>
                <input type="text" name="username" placeholder="Enter your username" required
                       class="w-full px-4 py-3 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand focus:border-transparent text-sm">
            </div>

            <div>
                <label class="block text-gray-700 font-medium mb-1.5 text-sm">Password</label>
                <input type="password" name="password" placeholder="Enter your password" required
                       class="w-full px-4 py-3 border border-gray-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-brand focus:border-transparent text-sm">
            </div>

            <button type="submit"
                    class="w-full bg-brand hover:bg-brandDark text-white font-semibold rounded-lg py-3 transition shadow-sm text-sm">
                Login
            </button>
        </form>

        <p class="text-center text-gray-600 mt-6 text-sm">
            Don't have an account?
            <a href="register" class="text-brand font-semibold hover:underline">
                Create Account
            </a>
        </p>
    </div>

    <script>
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
            }, 4000);
        }

        <% if (loginError != null) { %>
            showNotification('<%= loginError %>', 'error');
        <% } %>
    </script>
</body>
</html>