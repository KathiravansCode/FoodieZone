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
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(15px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .slide-up { animation: slideUp 0.4s ease-out; }
        .fade-in { animation: slideUp 0.3s ease-out; }
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
<nav class="bg-white shadow-sm sticky top-0 z-40 border-b border-gray-100">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div class="flex justify-between items-center h-16">
            <div class="text-2xl font-bold text-brand cursor-pointer flex items-center gap-2" onclick="window.location.href='home'">
                🍕 <span>FoodZone</span>
            </div>
            <div class="flex items-center gap-4">
                <a href="home" class="text-sm font-medium text-gray-700 hover:text-brand transition">Home</a>
                <a href="cart" class="text-sm font-medium text-gray-700 hover:text-brand transition">Cart</a>
                <a href="logout" class="px-4 py-2 text-sm font-medium text-gray-700 hover:text-brand transition">Logout</a>
            </div>
        </div>
    </div>
</nav>

<div class="max-w-5xl mx-auto px-4 py-8">
    <div class="mb-6">
        <h1 class="text-2xl font-bold text-gray-900 mb-1">Checkout</h1>
        <p class="text-sm text-gray-600">Complete your order</p>
    </div>

    <form id="checkoutForm" method="post" action="confirm">
        <div class="grid lg:grid-cols-3 gap-6">
            <div class="lg:col-span-2 space-y-5">
                <!-- DELIVERY ADDRESS -->
                <div class="bg-white shadow-sm rounded-xl p-5 slide-up">
                    <h3 class="text-base font-bold text-gray-800 mb-3 flex items-center gap-2">
                        <svg class="w-5 h-5 text-brand" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"/>
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"/>
                        </svg>
                        Delivery Address
                    </h3>
                    <textarea name="deliveryAddress" required
                              class="w-full px-4 py-3 border border-gray-200 rounded-lg outline-none focus:ring-2 focus:ring-brand text-sm resize-none"
                              rows="2" placeholder="Enter delivery address"><%= user.getAddress() %></textarea>
                    <input type="hidden" name="totalAmount" value="<%= finalTotal %>">
                </div>

                <!-- PAYMENT METHOD -->
                <div class="bg-white shadow-sm rounded-xl p-5 slide-up">
                    <h3 class="text-base font-bold text-gray-800 mb-3 flex items-center gap-2">
                        <svg class="w-5 h-5 text-brand" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/>
                        </svg>
                        Payment Method
                    </h3>
                    <select name="paymentMode" required
                            class="w-full px-4 py-3 border border-gray-200 rounded-lg outline-none focus:ring-2 focus:ring-brand text-sm bg-white">
                        <option value="COD">💵 Cash On Delivery</option>
                        <option value="UPI">📱 UPI Payment</option>
                        <option value="DEBIT CARD">💳 Debit Card</option>
                    </select>
                </div>
            </div>

            <!-- ORDER SUMMARY -->
            <div class="lg:col-span-1">
                <div class="bg-white shadow-sm rounded-xl p-5 sticky top-24 slide-up">
                    <h3 class="text-base font-bold text-gray-800 mb-4">Order Summary</h3>

                    <div class="space-y-3 mb-5 max-h-60 overflow-y-auto">
                        <% for (Cart item : cartItems) {
                            Menu menu = menuDetails.get(item.getMenuId());
                        %>
                        <div class="flex justify-between items-start pb-3 border-b border-gray-100">
                            <div class="flex-1 pr-2">
                                <p class="font-semibold text-gray-900 text-xs"><%= menu.getItemName() %></p>
                                <p class="text-gray-500 text-xs">Qty: <%= item.getQuantity() %></p>
                            </div>
                            <img src="menuImage?id=<%= menu.getMenuId() %>"
                                 onerror="this.src='https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=100'"
                                 class="w-12 h-12 object-cover rounded-lg">
                        </div>
                        <% } %>
                    </div>

                    <div class="border-t border-gray-200 pt-4 mb-5">
                        <div class="flex justify-between items-center">
                            <span class="text-base font-semibold text-gray-700">Total</span>
                            <span class="text-2xl font-bold text-brand">₹<%= finalTotal %></span>
                        </div>
                    </div>

                    <button type="button" onclick="openModal()"
                            class="w-full bg-brand text-white py-3 rounded-lg text-sm font-semibold hover:bg-brandDark transition shadow-sm">
                        Place Order
                    </button>
                </div>
            </div>
        </div>
    </form>
</div>

<!-- CONFIRMATION MODAL -->
<div id="confirmModal" class="hidden fixed inset-0 bg-black bg-opacity-50 backdrop-blur-sm flex justify-center items-center z-50 p-4">
    <div class="bg-white rounded-3xl shadow-2xl p-8 max-w-sm w-full text-center fade-in">
        <div class="text-5xl mb-3">🎉</div>
        <h2 class="text-xl font-bold text-gray-800 mb-2">Confirm Your Order?</h2>
        <p class="text-gray-600 mb-6 text-sm">Your order will be processed for delivery</p>
        <div class="flex gap-3">
            <button onclick="document.getElementById('checkoutForm').submit()"
                    class="flex-1 px-5 py-2.5 bg-brand text-white rounded-lg hover:bg-brandDark font-semibold text-sm">
                Yes, Place Order
            </button>
            <button onclick="closeModal()"
                    class="flex-1 px-5 py-2.5 bg-gray-200 rounded-lg hover:bg-gray-300 font-semibold text-sm">
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