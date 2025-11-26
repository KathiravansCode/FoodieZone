<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.foodtruck.model.Restaurant"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Admin Dashboard|FoodTruck</title>
<script src="https://cdn.tailwindcss.com"></script>

<!-- Custom Brand Theme -->
<script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: "#ff4d00",
                        brandDark: "#e64500",
                        brandLight: "#fff3eb"
                    }
                }
            }
        }
    </script>
</head>

<body class="bg-gray-100">

	<%
        Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
        String success = (String) request.getAttribute("adminSuccess");
        String error = (String) request.getAttribute("adminError");
    %>

	<!-- Navigation Bar -->
	<header class="bg-white shadow-md fixed top-0 left-0 right-0 z-30">
		<div
			class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
			<h1 class="text-2xl font-bold text-brand">FoodTruck Admin</h1>

			<div class="flex items-center gap-4">
				<span class="font-semibold text-gray-800"> <%= restaurant.getName() %>
				</span> <a href="<%= request.getContextPath() %>/logout"
					class="bg-red-500 hover:bg-red-600 text-white px-4 py-2 rounded-lg transition">
					Logout </a>
			</div>
		</div>
	</header>

	<!--  Sidebar -->
<aside class="w-64 min-h-screen bg-white shadow-xl fixed top-20 left-0 p-6 flex flex-col">

    <h2 class="text-xl font-bold text-gray-800 mb-6">Dashboard Menu</h2>

    <nav class="flex flex-col gap-4">

        <a href="<%= request.getContextPath() %>/admin/dashboard"
           class="w-full block text-left px-4 py-3 rounded-lg font-semibold 
           bg-brandLight text-brand border border-brand
           hover:bg-brand hover:text-white transition">
            Overview
        </a>

        <a href="<%= request.getContextPath() %>/admin/menu?restaurantId=<%= restaurant.getRestaurantId() %>"
           class="w-full block text-left px-4 py-3 rounded-lg font-semibold 
           bg-white text-brand border border-brand
           hover:bg-brand hover:text-white transition">
            Manage Menu
        </a>

        <a href="<%= request.getContextPath() %>/admin/orders"
           class="w-full block text-left px-4 py-3 rounded-lg font-semibold 
           bg-white text-brand border border-brand
           hover:bg-brand hover:text-white transition">
            Orders
        </a>

        <a href="<%=request.getContextPath()%>/admin/restaurant/manage?action=edit&restaurantId=<%=restaurant.getRestaurantId()%>"
           class="w-full block text-left px-4 py-3 rounded-lg font-semibold 
           bg-white text-brand border border-brand
           hover:bg-brand hover:text-white transition">
            Restaurant Settings
        </a>

    </nav>

</aside>
	

		<!-- ⭐ Main Content -->
		<main class="flex-1 ml-72 p-10">

			<!-- Alerts -->
			<% if (success != null) { %>
			<div
				class="bg-green-100 border border-green-400 text-green-800 px-4 py-3 rounded-lg mb-6">
				<%= success %>
			</div>
			<% } %>

			<% if (error != null) { %>
			<div
				class="bg-red-100 border border-red-400 text-red-800 px-4 py-3 rounded-lg mb-6">
				<%= error %>
			</div>
			<% } %>

			<!-- Dashboard Header -->
			<h1 class="text-3xl font-bold text-gray-900 mb-8">
				Welcome, <span class="text-brand"><%= restaurant.getName() %></span>
			</h1>

			<!-- Restaurant Info Cards -->
			<div class="grid grid-cols-3 gap-6">

				<!-- Card -->
				<div
					class="bg-white p-6 rounded-xl shadow hover:shadow-lg transition">
					<h3 class="text-gray-600 font-semibold mb-2">Restaurant Name</h3>
					<p class="text-xl font-bold text-gray-900"><%= restaurant.getName() %></p>
				</div>

				<!-- Card -->
				<div
					class="bg-white p-6 rounded-xl shadow hover:shadow-lg transition">
					<h3 class="text-gray-600 font-semibold mb-2">Location</h3>
					<p class="text-xl font-bold text-gray-900"><%= restaurant.getAddress() %></p>
				</div>

				<!-- Card -->
				<div
					class="bg-white p-6 rounded-xl shadow hover:shadow-lg transition">
					<h3 class="text-gray-600 font-semibold mb-2">Status</h3>
					<p class="text-xl font-bold text-brand"><%= restaurant.getRestaurantStatus() %></p>
				</div>
			</div>

			<!-- Action Buttons -->
			<div class="mt-10 flex gap-6">

				<a
					href="<%= request.getContextPath() %>/admin/menu?restaurantId=<%= restaurant.getRestaurantId() %>"
					class="block bg-white border border-brand text-brand font-semibold px-4 py-3 rounded-lg hover:bg-brand hover:text-white transition">
					Manage Menu </a> <a href="<%= request.getContextPath() %>/admin/orders"
					class="bg-blue-600 text-white font-bold px-6 py-3 rounded-xl hover:bg-blue-700 transition">
					View Orders </a> <a
					href="<%=request.getContextPath()%>/admin/restaurant/manage?action=edit&restaurantId=<%=restaurant.getRestaurantId()%>"
					class="bg-yellow-500 hover:bg-yellow-600 text-white font-bold px-6 py-3 rounded-xl transition">
					Update Details </a>


			</div>

		</main>

	</div>

</body>
</html>

