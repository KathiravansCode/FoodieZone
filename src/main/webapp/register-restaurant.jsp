<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Register Restaurant | Admin</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { brand: "#ff4d00", brandDark: "#d84300" }
                }
            }
        }
    </script>
</head>

<body class="bg-gray-100 min-h-screen">

<div class="max-w-3xl mx-auto mt-16 bg-white p-10 shadow-xl rounded-2xl">

    <h1 class="text-3xl font-bold text-gray-900 mb-6">Register Your Restaurant</h1>

    <% String err = (String) request.getAttribute("adminError"); %>
    <% if (err != null) { %>
        <div class="bg-red-100 text-red-700 border border-red-300 px-4 py-3 rounded-lg mb-6">
            <%= err %>
        </div>
    <% } %>

    <form action="<%= request.getContextPath() %>/admin/registerRestaurant" 
          method="post" enctype="multipart/form-data" class="space-y-6">

        <div>
            <label class="font-semibold block mb-2">Restaurant Name</label>
            <input type="text" name="name" required
                   class="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-brand">
        </div>

        <div>
            <label class="font-semibold block mb-2">Phone Number</label>
            <input type="text" name="phone" required
                   class="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-brand">
        </div>

        <div>
            <label class="font-semibold block mb-2">Address</label>
            <textarea name="address" rows="3" required
                      class="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-brand"></textarea>
        </div>

        <div>
            <label class="font-semibold block mb-2">Status</label>
            <select name="status" required
                    class="w-full px-4 py-3 border rounded-lg focus:ring-2 focus:ring-brand">
                <option value="OPEN">OPEN</option>
                <option value="CLOSED">CLOSED</option>
            </select>
        </div>

        <div>
            <label class="font-semibold block mb-2">Restaurant Image</label>
            <input type="file" name="restaurantImage" class="w-full border px-4 py-3 rounded-lg">
        </div>

        <button class="bg-brand text-white w-full py-3 rounded-xl text-lg font-semibold hover:bg-brandDark">
            Register Restaurant
        </button>
    </form>

</div>

</body>
</html>
