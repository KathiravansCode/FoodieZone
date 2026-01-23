<%@ page contentType="text/html;charset=UTF-8"%>
<%@ page import="com.foodtruck.model.Restaurant"%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Admin Dashboard | FoodZone</title>
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
    @keyframes slideUp {
        from { opacity: 0; transform: translateY(15px); }
        to { opacity: 1; transform: translateY(0); }
    }
    @keyframes slideOut {
        to { opacity: 0; transform: translateX(100%); }
    }
    .card-hover { transition: all 0.3s ease; }
    .card-hover:hover { 
        transform: translateY(-3px); 
        box-shadow: 0 12px 24px -5px rgba(0,0,0,0.12);
    }
    .notification { animation: slideUp 0.3s ease-out; }
    .notification-exit { animation: slideOut 0.3s ease-out; }
    .slide-up { animation: slideUp 0.4s ease-out; }
</style>
</head>

<body class="bg-gray-50">

	<%
        Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
        String success = (String) request.getAttribute("adminSuccess");
        String error = (String) request.getAttribute("adminError");
    %>

    <!-- NOTIFICATION CONTAINER -->
    <div id="notification-container" class="fixed top-20 right-4 z-50 space-y-2"></div>

	<!-- Navigation Bar -->
	<header class="bg-white shadow-sm sticky top-0 z-30 border-b border-gray-100">
		<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
			<div class="flex justify-between items-center h-16">
				<h1 class="text-2xl font-bold text-brand flex items-center gap-2">
                    🏪 <span>FoodZone Admin</span>
                </h1>

				<div class="flex items-center gap-4">
					<span class="font-semibold text-gray-700 text-sm"><%= restaurant.getName() %></span>
					<a href="<%= request.getContextPath() %>/logout"
						class="bg-red-500 hover:bg-red-600 text-white px-5 py-2 rounded-full transition font-medium text-sm shadow-sm">
						Logout
					</a>
				</div>
			</div>
		</div>
	</header>

	<div class="flex min-h-screen">
		<!-- Sidebar -->
		<aside class="w-64 bg-white shadow-sm p-5 sticky top-16 h-screen border-r border-gray-100">
			<h2 class="text-lg font-bold text-gray-800 mb-6">Dashboard Menu</h2>

			<nav class="space-y-2">
				<a href="<%= request.getContextPath() %>/admin/dashboard"
				   class="block px-4 py-3 rounded-xl font-semibold text-sm
				   bg-brandLight text-brand border border-brand
				   hover:bg-brand hover:text-white transition">
					📊 Overview
				</a>

				<a href="<%= request.getContextPath() %>/admin/menu?restaurantId=<%= restaurant.getRestaurantId() %>"
				   class="block px-4 py-3 rounded-xl font-semibold text-sm
				   text-gray-700 hover:bg-gray-50 transition">
					🍽️ Manage Menu
				</a>

				<a href="<%= request.getContextPath() %>/admin/orders"
				   class="block px-4 py-3 rounded-xl font-semibold text-sm
				   text-gray-700 hover:bg-gray-50 transition">
					📦 Orders
				</a>

				<a href="<%=request.getContextPath()%>/admin/restaurant/manage?action=edit&restaurantId=<%=restaurant.getRestaurantId()%>"
				   class="block px-4 py-3 rounded-xl font-semibold text-sm
				   text-gray-700 hover:bg-gray-50 transition">
					⚙️ Restaurant Settings
				</a>
			</nav>
		</aside>
		

		<!-- Main Content -->
		<main class="flex-1 p-6">

			<!-- Dashboard Header -->
			<div class="mb-8 slide-up">
				<h1 class="text-2xl font-bold text-gray-900 mb-1">
					Welcome back! 👋
				</h1>
				<p class="text-sm text-gray-600">
					Manage your restaurant - <span class="text-brand font-semibold"><%= restaurant.getName() %></span>
				</p>
			</div>

			<!-- Restaurant Info Cards -->
			<div class="grid grid-cols-1 md:grid-cols-3 gap-5 mb-8">

				<div class="card-hover bg-white p-5 rounded-xl shadow-sm border border-gray-100">
					<h3 class="text-gray-600 font-medium mb-2 text-xs uppercase tracking-wide">Restaurant Name</h3>
					<p class="text-xl font-bold text-gray-900"><%= restaurant.getName() %></p>
				</div>

				<div class="card-hover bg-white p-5 rounded-xl shadow-sm border border-gray-100">
					<h3 class="text-gray-600 font-medium mb-2 text-xs uppercase tracking-wide">Location</h3>
					<p class="text-xl font-bold text-gray-900"><%= restaurant.getAddress() %></p>
				</div>

				<div class="card-hover bg-white p-5 rounded-xl shadow-sm border border-gray-100">
					<h3 class="text-gray-600 font-medium mb-2 text-xs uppercase tracking-wide">Status</h3>
					<p class="text-xl font-bold <%= "OPEN".equals(restaurant.getRestaurantStatus()) ? "text-green-600" : "text-red-600" %>">
						<%= restaurant.getRestaurantStatus() %>
					</p>
				</div>
			</div>

			<!-- Action Buttons -->
			<div class="bg-white rounded-xl shadow-sm p-6 border border-gray-100">
				<h3 class="text-lg font-bold text-gray-900 mb-4">Quick Actions</h3>
				<div class="flex flex-wrap gap-3">

					<a href="<%= request.getContextPath() %>/admin/menu?restaurantId=<%= restaurant.getRestaurantId() %>"
						class="px-6 py-2.5 bg-white border-2 border-brand text-brand font-semibold rounded-lg hover:bg-brand hover:text-white transition text-sm shadow-sm">
						Manage Menu
					</a>
					
					<a href="<%= request.getContextPath() %>/admin/orders"
						class="px-6 py-2.5 bg-blue-600 text-white font-semibold rounded-lg hover:bg-blue-700 transition text-sm shadow-sm">
						View Orders
					</a>
					
					<a href="<%=request.getContextPath()%>/admin/restaurant/manage?action=edit&restaurantId=<%=restaurant.getRestaurantId()%>"
						class="px-6 py-2.5 bg-yellow-500 hover:bg-yellow-600 text-white font-semibold rounded-lg transition text-sm shadow-sm">
						Update Details
					</a>

				</div>
			</div>

		</main>
	</div>

    <script>
        function showNotification(message, type) {
            const container = document.getElementById('notification-container');
            const notification = document.createElement('div');
            notification.className = 'notification px-5 py-3 rounded-lg shadow-lg text-sm font-medium ' + 
                (type === 'success' ? 'bg-green-500 text-white' : 'bg-red-500 text-white');
            notification.textContent = message;
            container.appendChild(notification);
            
            setTimeout(function() {
                notification.classList.add('notification-exit');
                setTimeout(function() { notification.remove(); }, 300);
            }, 3000);
        }

        <% if (success != null) { %>
            showNotification('<%= success %>', 'success');
        <% } %>
        <% if (error != null) { %>
            showNotification('<%= error %>', 'error');
        <% } %>
    </script>

</body>
</html>