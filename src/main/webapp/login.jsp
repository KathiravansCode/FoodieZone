<!-- login.jsp -->
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
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .fade-in { animation: fadeIn 0.6s ease; }
    </style>
</head>

<body class="bg-gradient-to-br from-orange-50 to-red-50 min-h-screen flex items-center justify-center p-4">

    <div class="bg-white shadow-2xl rounded-3xl w-full max-w-md p-10 fade-in">
        
        <!-- LOGO -->
        <div class="text-center mb-8">
            <div class="text-5xl mb-4">🍕</div>
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Welcome Back!</h1>
            <p class="text-gray-600 text-base">Login to continue to FoodZone</p>
        </div>

        <% String loginError = (String) request.getAttribute("loginError"); %>
        <% if (loginError != null) { %>
            <div class="bg-red-50 border-2 border-red-200 text-red-700 px-4 py-3 rounded-xl mb-6 text-center text-base">
                ✕ <%= loginError %>
            </div>
        <% } %>

        <form action="login" method="post" class="space-y-6">
            <input type="hidden" name="redirect" value="auto">

            <div>
                <label class="block text-gray-700 font-semibold mb-2 text-base">Username</label>
                <input type="text" name="username" placeholder="Enter your username" required
                       class="w-full px-5 py-4 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-brand focus:border-brand outline-none text-base">
            </div>

            <div>
                <label class="block text-gray-700 font-semibold mb-2 text-base">Password</label>
                <input type="password" name="password" placeholder="Enter your password" required
                       class="w-full px-5 py-4 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-brand focus:border-brand outline-none text-base">
            </div>

            <button type="submit"
                    class="w-full bg-brand hover:bg-brandDark text-white font-bold rounded-xl py-4 transition shadow-lg text-base">
                Login →
            </button>
        </form>

        <p class="text-center text-gray-600 mt-6 text-base">
            Don't have an account?
            <a href="register" class="text-brand font-bold hover:underline">
                Create Account
            </a>
        </p>
    </div>

</body>
</html>