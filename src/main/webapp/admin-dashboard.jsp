<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.foodtruck.model.Restaurant"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Admin Dashboard | FoodTruck</title>
<script src="https://cdn.tailwindcss.com"></script>
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
<style>
    .card-hover { transition: all 0.3s ease; }
    .card-hover:hover { transform: translateY(-5px); box-shadow: 0 20px 40px rgba(0,0,0,0.1); }
</style>
</head>

<body class="bg-gray-50">

	<%
        Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
        String success = (String) request.getAttribute("adminSuccess");
        String error = (String) request.getAttribute("adminError");
    %>

	<!-- Navigation Bar -->
	<header class="bg-white shadow-md sticky top-0 z-30">
		<div class="max-w-7xl mx-auto px-6 py-4 flex justify-between items-center">
			<h1 class="text-3xl font-bold text-brand">🏪 FoodTruck Admin</h1>

			<div class="flex items-center gap-6">
				<span class="font-semibold text-gray-800 text-lg"><%= restaurant.getName() %></span>
				<a href="<%= request.getContextPath() %>/logout"
					class="bg-red-500 hover:bg-red-600 text-white px-6 py-2.5 rounded-full transition font-medium text-base">
					Logout
				</a>
			</div>
		</div>
	</header>

	<div class="flex min-h-screen">
		<!-- Sidebar -->
		<aside class="w-72 bg-white shadow-xl p-6 sticky top-20 h-screen">
			<h2 class="text-2xl font-bold text-gray-800 mb-8">Dashboard Menu</h2>

			<nav class="space-y-3">
				<a href="<%= request.getContextPath() %>/admin/dashboard"
				   class="block px-5 py-4 rounded-xl font-semibold text-base
				   bg-brandLight text-brand border-2 border-brand
				   hover:bg-brand hover:text-white transition">
					📊 Overview
				</a>

				<a href="<%= request.getContextPath() %>/admin/menu?restaurantId=<%= restaurant.getRestaurantId() %>"
				   class="block px-5 py-4 rounded-xl font-semibold text-base
				   bg-white text-brand border-2 border-brand
				   hover:bg-brand hover:text-white transition">
					🍽️ Manage Menu
				</a>

				<a href="<%= request.getContextPath() %>/admin/orders"
				   class="block px-5 py-4 rounded-xl font-semibold text-base
				   bg-white text-brand border-2 border-brand
				   hover:bg-brand hover:text-white transition">
					📦 Orders
				</a>

				<a href="<%=request.getContextPath()%>/admin/restaurant/manage?action=edit&restaurantId=<%=restaurant.getRestaurantId()%>"
				   class="block px-5 py-4 rounded-xl font-semibold text-base
				   bg-white text-brand border-2 border-brand
				   hover:bg-brand hover:text-white transition">
					⚙️ Restaurant Settings
				</a>
			</nav>
		</aside>
		

		<!-- Main Content -->
		<main class="flex-1 p-10">

			<!-- Alerts -->
			<% if (success != null) { %>
			<div class="bg-green-50 border-2 border-green-200 text-green-800 px-5 py-4 rounded-xl mb-6 font-semibold text-base">
				✓ <%= success %>
			</div>
			<% } %>

			<% if (error != null) { %>
			<div class="bg-red-50 border-2 border-red-200 text-red-800 px-5 py-4 rounded-xl mb-6 font-semibold text-base">
				✕ <%= error %>
			</div>
			<% } %>

			<!-- Dashboard Header -->
			<h1 class="text-4xl font-bold text-gray-900 mb-10">
				Welcome, <span class="text-brand"><%= restaurant.getName() %></span>
			</h1>

			<!-- Restaurant Info Cards -->
			<div class="grid grid-cols-3 gap-8 mb-10">

				<div class="card-hover bg-white p-8 rounded-2xl shadow-lg">
					<h3 class="text-gray-600 font-semibold mb-3 text-base">Restaurant Name</h3>
					<p class="text-2xl font-bold text-gray-900"><%= restaurant.getName() %></p>
				</div>

				<div class="card-hover bg-white p-8 rounded-2xl shadow-lg">
					<h3 class="text-gray-600 font-semibold mb-3 text-base">Location</h3>
					<p class="text-2xl font-bold text-gray-900"><%= restaurant.getAddress() %></p>
				</div>

				<div class="card-hover bg-white p-8 rounded-2xl shadow-lg">
					<h3 class="text-gray-600 font-semibold mb-3 text-base">Status</h3>
					<p class="text-2xl font-bold text-brand"><%= restaurant.getRestaurantStatus() %></p>
				</div>
			</div>

			<!-- Action Buttons -->
			<div class="flex gap-6">

				<a href="<%= request.getContextPath() %>/admin/menu?restaurantId=<%= restaurant.getRestaurantId() %>"
					class="px-8 py-4 bg-white border-2 border-brand text-brand font-semibold rounded-xl hover:bg-brand hover:text-white transition text-base">
					Manage Menu
				</a>
				
				<a href="<%= request.getContextPath() %>/admin/orders"
					class="px-8 py-4 bg-blue-600 text-white font-bold rounded-xl hover:bg-blue-700 transition text-base">
					View Orders
				</a>
				
				<a href="<%=request.getContextPath()%>/admin/restaurant/manage?action=edit&restaurantId=<%=restaurant.getRestaurantId()%>"
					class="px-8 py-4 bg-yellow-500 hover:bg-yellow-600 text-white font-bold rounded-xl transition text-base">
					Update Details
				</a>

			</div>

		</main>
	</div>

</body>
</html>