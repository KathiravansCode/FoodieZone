<%@ page import="java.util.*, com.foodtruck.model.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">

<head>
    <title>Checkout | FoodZone</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { brand: "#ff4d00", brandDark: "#e64500" } } }
        };
    </script>
    <style>
        .modal-bg { background: rgba(0,0,0,0.7); backdrop-filter: blur(5px); }
    </style>
</head>

<body class="bg-gray-50 min-h-screen">

<%
    User user = (User) request.getAttribute("user");
    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    Map<Integer, Menu> menuDetails = (Map<Integer, Menu>) request.getAttribute("menuDetails");
    Double totalObj = (Double) request.getAttribute("finalTotal");
    double finalTotal = totalObj != null ? totalObj : 0.0;
%>

<!-- NAVBAR -->
<nav class="bg-white shadow-md py-4 px-6 sticky top-0 z-40">
    <div class="max-w-7xl mx-auto flex justify-between items-center">
        <div class="text-2xl font-bold text-brand cursor-pointer" onclick="window.location.href='home'">
            🍕 FoodZone
        </div>

        <div class="flex items-center gap-6">
            <a href="home" class="text-gray-700 font-semibold hover:text-brand text-base">Home</a>
            <a href="cart" class="text-gray-700 font-semibold hover:text-brand text-base">Cart</a>
            <a href="logout" class="px-5 py-2.5 bg-gray-800 text-white rounded-full hover:bg-black transition text-base font-medium">
                Logout
            </a>
        </div>
    </div>
</nav>

<!-- CHECKOUT CONTENT -->
<div class="max-w-5xl mx-auto px-4 py-10">
    <div class="mb-8">
        <h1 class="text-4xl font-bold text-gray-900 mb-2">🛍️ Checkout</h1>
        <p class="text-gray-600 text-lg">Complete your order</p>
    </div>

    <form id="checkoutForm" method="post" action="confirm">
        <div class="grid lg:grid-cols-3 gap-8">
            <!-- LEFT: DELIVERY & PAYMENT -->
            <div class="lg:col-span-2 space-y-6">
                <!-- DELIVERY ADDRESS -->
                <div class="bg-white shadow-lg rounded-2xl p-6">
                    <h3 class="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                        📍 Delivery Address
                    </h3>
                    <textarea name="deliveryAddress" required
                              class="w-full px-5 py-4 border-2 border-gray-200 rounded-xl outline-none focus:ring-2 focus:ring-brand text-base"
                              rows="3" placeholder="Enter delivery address"><%= user.getAddress() %></textarea>
                    <input type="hidden" name="totalAmount" value="<%= finalTotal %>">
                </div>

                <!-- PAYMENT METHOD -->
                <div class="bg-white shadow-lg rounded-2xl p-6">
                    <h3 class="text-xl font-bold text-gray-800 mb-4 flex items-center gap-2">
                        💳 Payment Method
                    </h3>
                    <select name="paymentMode" required
                            class="w-full px-5 py-4 border-2 border-gray-200 rounded-xl outline-none focus:ring-2 focus:ring-brand text-base bg-white">
                        <option value="COD">💵 Cash On Delivery (COD)</option>
                        <option value="UPI">📱 UPI Payment</option>
                        <option value="DEBIT CARD">💳 Debit Card</option>
                    </select>
                </div>
            </div>

            <!-- RIGHT: ORDER SUMMARY -->
            <div class="lg:col-span-1">
                <div class="bg-white shadow-lg rounded-2xl p-6 sticky top-24">
                    <h3 class="text-xl font-bold text-gray-800 mb-4">📦 Order Summary</h3>

                    <div class="space-y-4 mb-6 max-h-64 overflow-y-auto">
                        <% for (Cart item : cartItems) {
                            Menu menu = menuDetails.get(item.getMenuId());
                        %>
                        <div class="flex justify-between items-start pb-4 border-b">
                            <div class="flex-1">
                                <p class="font-bold text-gray-900 text-base"><%= menu.getItemName() %></p>
                                <p class="text-gray-500 text-sm">Qty: <%= item.getQuantity() %></p>
                            </div>
                            <img src="menuImage?id=<%= menu.getMenuId() %>"
                                 onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100'"
                                 class="w-16 h-16 object-cover rounded-lg ml-3">
                        </div>
                        <% } %>
                    </div>

                    <div class="border-t-2 pt-4 mb-6">
                        <div class="flex justify-between items-center">
                            <span class="text-lg font-semibold text-gray-700">Total</span>
                            <span class="text-3xl font-bold text-brand">₹<%= finalTotal %></span>
                        </div>
                    </div>

                    <button type="button" onclick="openModal()"
                            class="w-full bg-brand text-white py-4 rounded-xl text-lg font-bold hover:bg-brandDark transition shadow-lg">
                        Place Order →
                    </button>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- CONFIRMATION MODAL -->
<div id="confirmModal" class="fixed inset-0 hidden modal-bg flex justify-center items-center z-50">
    <div class="bg-white rounded-3xl shadow-2xl p-8 w-96 text-center">
        <div class="text-6xl mb-4">🎉</div>
        <h2 class="text-2xl font-bold text-gray-800 mb-3">Confirm Your Order?</h2>
        <p class="text-gray-600 mb-6 text-base">
            Your order will be processed for delivery
        </p>

        <div class="flex gap-4">
            <button onclick="document.getElementById('checkoutForm').submit()"
                    class="flex-1 px-6 py-3 bg-brand text-white rounded-xl hover:bg-brandDark font-bold text-base">
                Yes, Place Order
            </button>
            <button onclick="closeModal()"
                    class="flex-1 px-6 py-3 bg-gray-300 rounded-xl hover:bg-gray-400 font-semibold text-base">
                Cancel
            </button>
        </div>
    </div>
</div>

<script>
    function openModal() {
        document.getElementById("confirmModal").classList.remove("hidden");
    }
    function closeModal() {
        document.getElementById("confirmModal").classList.add("hidden");
    }
</script>

</body>
</html>