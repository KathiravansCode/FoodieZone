<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Create Account | FoodTruck</title>

  
    <script src="https://cdn.tailwindcss.com"></script>

       <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: "#ff4d00",
                        brandDark: "#e64500"
                    }
                }
            }
        }
    </script>
  
</head>

<body class="bg-gray-100 min-h-screen flex items-center justify-center">

    <!-- Outer Container -->
    <div class="bg-white shadow-xl rounded-2xl w-full max-w-lg p-10 relative">

        <!-- Brand Logo -->
        <div class="w-full flex justify-center mb-6">
            <div class="border border-gray-300 rounded-lg px-5 py-2 text-gray-700 text-sm">
                FoodTruck Logo
            </div>
        </div>

        <!-- Title -->
        <h1 class="text-center text-3xl font-bold text-gray-900 mb-8 tracking-wide">
            CREATE ACCOUNT
        </h1>

        <!-- SUCCESS MESSAGE -->
        <%
            String successMessage = (String) request.getAttribute("successMessage");
            String errorMessage = (String) request.getAttribute("error");
        %>

        <% if (successMessage != null) { %>
            <div class="bg-green-100 text-green-700 px-4 py-3 rounded-lg mb-4 text-center">
                <%= successMessage %>
            </div>
        <% } %>

        <% if (errorMessage != null) { %>
            <div class="bg-red-100 text-red-700 px-4 py-3 rounded-lg mb-4 text-center">
                <%= errorMessage %>
            </div>
        <% } %>

        <!-- REGISTRATION FORM -->
        <form action="register" method="post" class="space-y-5">

            <!-- FULL NAME -->
            <input type="text" name="fullName" placeholder="Full Name"
                   required
                   class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-brand focus:outline-none">

            <!-- EMAIL -->
            <input type="email" name="email" placeholder="Email"
                   required
                   class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-brand focus:outline-none">

            <!-- PHONE -->
            <input type="text" name="phone" placeholder="Phone"
                   required
                   class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-brand focus:outline-none">

            <!-- ADDRESS -->
            <input type="text" name="address" placeholder="Address"
                   required
                   class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-brand focus:outline-none">

            <!-- USERNAME -->
            <input type="text" name="username" placeholder="Username"
                   required
                   class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-brand focus:outline-none">

            <!-- PASSWORD -->
            <input type="password" name="password" placeholder="Password"
                   required
                   class="w-full px-4 py-3 border border-gray-300 rounded-xl focus:ring-2 focus:ring-brand focus:outline-none">

            <!-- ROLE DROPDOWN -->
            <select name="role" required
                    class="w-full px-4 py-3 border border-gray-300 rounded-xl bg-white focus:ring-2 focus:ring-brand focus:outline-none">
                <option value="" disabled selected>Select Role</option>
                <option value="USER">User</option>
                <option value="ADMIN">Admin</option>
            </select>

            <!-- REGISTER BUTTON -->
            <button type="submit"
                    class="w-full text-center bg-brand hover:bg-brandDark text-white font-semibold rounded-full py-3 transition duration-200">
                Register
            </button>
        </form>

        <!-- LOGIN LINK -->
        <p class="text-center text-sm text-gray-600 mt-6">
            Already have an account?
            <a href="login.jsp" class="text-brand font-semibold hover:underline">
                Login
            </a>
        </p>

    </div>
    
   

</body>
</html>
