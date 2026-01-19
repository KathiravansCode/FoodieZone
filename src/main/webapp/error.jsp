<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Error | FoodTruck</title>
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-gray-50 h-screen flex items-center justify-center">
    <div class="bg-white shadow-lg rounded-xl w-full max-w-sm p-8 text-center">
        <h1 class="text-2xl font-bold text-red-500 mb-3">Oops!</h1>
        <p class="text-gray-700 text-sm mb-5">
            <%= request.getAttribute("error") != null ? request.getAttribute("error") : "Something went wrong." %>
        </p>
        <a href="home" class="inline-block px-6 py-2.5 bg-brand text-white text-sm rounded-lg hover:bg-brandDark transition">
            Go Back Home
        </a>
    </div>
</body>
</html>