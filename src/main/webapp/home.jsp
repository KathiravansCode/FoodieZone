<%@ page import="java.util.*, com.foodtruck.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <title>Home | FoodTruck</title>

    
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

    <!-- Welcome Animation -->
    <style>
        @keyframes slideIn {
            from { opacity: 0; transform: translateX(-40px); }
            to { opacity: 1; transform: translateX(0); }
        }

        .welcome-animation {
            animation: slideIn 1.1s ease forwards;
        }
    </style>
</head>

<body class="bg-gray-100 min-h-screen">

    <% User user = (User) request.getAttribute("user"); %>
    <% int cartCount = (request.getAttribute("cartItemCount") != null) ? (Integer) request.getAttribute("cartItemCount") : 0; %>

    <!-- NAVBAR -->
    <nav class="bg-white shadow-md py-4 px-6 flex justify-between items-center sticky top-0 z-40">
        <div class="text-2xl font-bold text-brand">FoodZone</div>

        <!-- SEARCH BAR -->
        <form action="home" method="get" class="flex w-1/2 mx-4">
            <input type="text" name="search"
                   value="<%= request.getAttribute("searchKeyword") != null ? request.getAttribute("searchKeyword") : "" %>"
                   placeholder="Search restaurants..."
                   class="flex-grow px-4 py-2 border border-gray-300 rounded-l-full focus:ring-2 focus:ring-brand outline-none">
            <button class="px-5 bg-brand text-white rounded-r-full hover:bg-brandDark">Search</button>
        </form>

        <!-- PROFILE  CART  LOGOUT -->
        <div class="flex items-center gap-6">

            <!-- My Orders -->
            <a href="orders"
               class="text-gray-700 font-semibold hover:text-brand">My Orders</a>

            <!-- CART ICON -->
            <a href="cart" class="relative">
                <img src="https://cdn-icons-png.flaticon.com/512/1170/1170678.png"
                     class="w-8">
                <% if (cartCount > 0) { %>
                    <span class="absolute -top-2 -right-2 bg-brand text-white text-xs w-5 h-5 flex items-center justify-center rounded-full">
                        <%= cartCount %>
                    </span>
                <% } %>
            </a>

            <!-- LOGOUT -->
            <a href="logout"
               class="px-4 py-2 bg-gray-800 text-white rounded-full hover:bg-black transition">Logout</a>
        </div>
    </nav>

    <!-- Welcome Banner -->
    <div class="bg-white shadow-md text-center py-4 mt-4 mx-10 rounded-lg welcome-animation">
        <h2 class="text-lg font-semibold text-gray-700">
            Welcome <span class="text-brand font-bold"><%= user != null ? user.getFullName() : "" %></span>
        </h2>
    </div>

    <!-- Section Title -->
    <div class="text-center mt-10 mb-6">
        <h1 class="text-3xl font-bold text-gray-800">Available Restaurants</h1>
    </div>

    <!-- NO RESTAURANTS FOUND -->
    <% Boolean notFound = (Boolean) request.getAttribute("noRestaurantFound"); %>
    <% if (notFound != null && notFound) { %>
        <p class="text-center text-red-500 font-semibold text-lg mb-10">
            No restaurants found for "<%= request.getAttribute("searchKeyword") %>".
        </p>
    <% } %>

    <!-- RESTAURANT GRID -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8 px-10 pb-20">

        <%
            List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
            if (restaurants != null) {
                for (Restaurant r : restaurants) {
        %>

        <!-- Card -->
		<div
			class="bg-white shadow-lg rounded-2xl overflow-hidden hover:shadow-xl transition">
			      <img src="restaurantImage?id=<%=r.getRestaurantId()%>"
			 	   onerror="this.src='https://via.placeholder.com/300'"
				   class="w-full h-60 w-40 object-cover" />


			<div class="p-4">
				<h2 class="text-lg font-bold text-gray-900"><%= r.getName() %></h2>
				<p class="text-sm text-gray-600 mt-1"><%= r.getRestaurantStatus() %></p>

				<a href="menu?restaurantId=<%= r.getRestaurantId() %>"
					class="mt-4 block text-center bg-brand hover:bg-brandDark text-white py-2 rounded-full transition">
					View Menu </a>
			</div>
		</div>

		<%  
                }
            }
        %>

    </div>

</body>
</html>


