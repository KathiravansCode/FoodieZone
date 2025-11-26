<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Register Your Restaurant | Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100 flex items-center justify-center h-screen">
    <div class="bg-white p-10 rounded-xl shadow-md w-96 text-center">
        
        <h1 class="text-2xl font-semibold text-gray-800 mb-4">
            Set Up Your Restaurant
        </h1>

        <p class="text-gray-600 mb-6">
            You haven't registered a restaurant yet.  
            Please add your restaurant details to continue.
        </p>

        <a href="<%= request.getContextPath() %>/admin/registerRestaurant"
           class="bg-blue-600 hover:bg-blue-700 text-white px-6 py-2 rounded-lg">
            Register Now
        </a>

    </div>
</body>
</html>
