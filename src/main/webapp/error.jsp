<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>Error | FoodTruck</title>

    <script src="https://cdn.tailwindcss.com"></script>
</head>

<body class="bg-gray-100 h-screen flex items-center justify-center">

    <div class="bg-white shadow-xl rounded-xl w-full max-w-md p-10 text-center">
        <h1 class="text-3xl font-bold text-red-500 mb-4">Oops!</h1>
        <p class="text-gray-700 mb-6">
            <%= request.getAttribute("error") != null ? request.getAttribute("error") : "Something went wrong." %>
        </p>

        <a href="home" class="px-6 py-3 bg-brand text-white rounded-full hover:bg-brandDark">
            Go Back Home
        </a>
    </div>

</body>
</html>
