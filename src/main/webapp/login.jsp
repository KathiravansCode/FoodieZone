<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Login|FoodTruck</title>

    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100 min-h-screen flex items-center justify-center">

    <div class="bg-white shadow-xl rounded-2xl w-full max-w-lg p-10">

        <h1 class="text-center text-3xl font-bold text-gray-900 mb-8">
            LOGIN
        </h1>

        <% String loginError = (String) request.getAttribute("loginError"); %>
        <% if (loginError != null) { %>
            <div class="bg-red-100 text-red-700 px-4 py-3 rounded-lg mb-4 text-center">
                <%= loginError %>
            </div>
        <% } %>

        <!-- IMPORTANT: redirect parameter -->
        <form action="login" method="post" class="space-y-6">

            <input type="hidden" name="redirect" value="auto">

            <input type="text" name="username" placeholder="Username" required
                   class="w-full px-4 py-3 border border-gray-300 rounded-xl">

            <input type="password" name="password" placeholder="Password" required
                   class="w-full px-4 py-3 border border-gray-300 rounded-xl">

            <button type="submit"
                    class="w-full bg-orange-500 hover:bg-orange-600 text-white font-semibold rounded-full py-3">
                Login
            </button>
        </form>

        <p class="text-center text-sm text-gray-600 mt-6">
            Don’t have an account?
            <a href="register" class="text-orange-600 font-semibold hover:underline">
                Create Account
            </a>
        </p>

    </div>

</body>
</html>


