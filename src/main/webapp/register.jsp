<!-- ========================================== -->
<!-- register.jsp -->
<!-- ========================================== -->

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
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .fade-in { animation: fadeIn 0.6s ease; }
    </style>
</head>

<body class="bg-gradient-to-br from-orange-50 to-red-50 min-h-screen flex items-center justify-center p-4">

    <div class="bg-white shadow-2xl rounded-3xl w-full max-w-lg p-10 fade-in">

        <!-- LOGO -->
        <div class="text-center mb-8">
            <div class="text-5xl mb-4">🍕</div>
            <h1 class="text-4xl font-bold text-gray-900 mb-2">Create Account</h1>
            <p class="text-gray-600 text-base">Join FoodZone today!</p>
        </div>

        <%
            String successMessage = (String) request.getAttribute("successMessage");
            String errorMessage = (String) request.getAttribute("error");
        %>

        <% if (successMessage != null) { %>
            <div class="bg-green-50 border-2 border-green-200 text-green-700 px-4 py-3 rounded-xl mb-6 text-center text-base">
                ✓ <%= successMessage %>
            </div>
        <% } %>

        <% if (errorMessage != null) { %>
            <div class="bg-red-50 border-2 border-red-200 text-red-700 px-4 py-3 rounded-xl mb-6 text-center text-base">
                ✕ <%= errorMessage %>
            </div>
        <% } %>

        <form action="register" method="post" class="space-y-5">

            <div>
                <label class="block text-gray-700 font-semibold mb-2 text-base">Full Name</label>
                <input type="text" name="fullName" placeholder="John Doe" required
                       class="w-full px-5 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-brand focus:border-brand outline-none text-base">
            </div>

            <div>
                <label class="block text-gray-700 font-semibold mb-2 text-base">Email</label>
                <input type="email" name="email" placeholder="john@example.com" required
                       class="w-full px-5 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-brand focus:border-brand outline-none text-base">
            </div>

            <div>
                <label class="block text-gray-700 font-semibold mb-2 text-base">Phone</label>
                <input type="text" name="phone" placeholder="9876543210" required
                       class="w-full px-5 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-brand focus:border-brand outline-none text-base">
            </div>

            <div>
                <label class="block text-gray-700 font-semibold mb-2 text-base">Address</label>
                <input type="text" name="address" placeholder="123 Main St, City" required
                       class="w-full px-5 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-brand focus:border-brand outline-none text-base">
            </div>

            <div>
                <label class="block text-gray-700 font-semibold mb-2 text-base">Username</label>
                <input type="text" name="username" placeholder="johndoe" required
                       class="w-full px-5 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-brand focus:border-brand outline-none text-base">
            </div>

            <div>
                <label class="block text-gray-700 font-semibold mb-2 text-base">Password</label>
                <input type="password" name="password" placeholder="Create a strong password" required
                       class="w-full px-5 py-3 border-2 border-gray-200 rounded-xl focus:ring-2 focus:ring-brand focus:border-brand outline-none text-base">
            </div>

            <div>
                <label class="block text-gray-700 font-semibold mb-2 text-base">Role</label>
                <select name="role" required
                        class="w-full px-5 py-3 border-2 border-gray-200 rounded-xl bg-white focus:ring-2 focus:ring-brand focus:border-brand outline-none text-base">
                    <option value="" disabled selected>Select your role</option>
                    <option value="USER">🍽️ Customer</option>
                    <option value="ADMIN">🏪 Restaurant Owner</option>
                </select>
            </div>

            <button type="submit"
                    class="w-full text-center bg-brand hover:bg-brandDark text-white font-bold rounded-xl py-4 transition shadow-lg text-base">
                Create Account →
            </button>
        </form>

        <p class="text-center text-gray-600 mt-6 text-base">
            Already have an account?
            <a href="login.jsp" class="text-brand font-bold hover:underline">
                Login
            </a>
        </p>

    </div>

</body>
</html>