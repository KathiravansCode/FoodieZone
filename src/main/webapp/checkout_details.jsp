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
        .modal-bg { background: rgba(0,0,0,0.55); }
    </style>
</head>

<body class="bg-gray-100 min-h-screen">

<%
    User user = (User) request.getAttribute("user");
    List<Cart> cartItems = (List<Cart>) request.getAttribute("cartItems");
    Map<Integer, Menu> menuDetails = (Map<Integer, Menu>) request.getAttribute("menuDetails");

    Double totalObj = (Double) request.getAttribute("finalTotal");
    double finalTotal = totalObj != null ? totalObj : 0.0;
%>

<!-- NAVBAR -->
<nav class="bg-white shadow-md py-4 px-6 flex justify-between items-center sticky top-0 z-40">
    <div class="text-2xl font-bold text-brand cursor-pointer" onclick="window.location.href='home'">
        FoodZone
    </div>

    <div class="flex items-center gap-6">
        <a href="home" class="text-gray-700 font-semibold hover:text-brand">Home</a>
        <a href="cart" class="text-gray-700 font-semibold hover:text-brand">Cart</a>
        <a href="logout"
           class="px-4 py-2 bg-gray-800 text-white rounded-full hover:bg-black transition">Logout</a>
    </div>
</nav>


<!-- MAIN CHECKOUT CONTAINER -->
<div class="mx-auto max-w-5xl mt-10">

    <!-- DELIVERY ADDRESS -->
    <form id="checkoutForm" method="post" action="confirm">
        <div class="bg-white shadow-lg rounded-2xl p-6 mb-8">
            <h3 class="text-xl font-bold text-gray-800 mb-4">Delivery Address</h3>

            <textarea name="deliveryAddress"
                      required
                      class="w-full px-4 py-3 border border-gray-300 rounded-xl outline-none focus:ring-2 focus:ring-brand"
                      rows="3"><%= user.getAddress() %></textarea>

            <!-- Hidden final amount -->
            <input type="hidden" name="totalAmount" value="<%= finalTotal %>">
        </div>


        <!-- ORDER SUMMARY -->
        <div class="bg-white shadow-lg rounded-2xl p-6 mb-8">
            <h3 class="text-xl font-bold text-gray-800 mb-4">Order Summary</h3>

            <div class="space-y-6">

            <% for (Cart item : cartItems) {
                Menu menu = menuDetails.get(item.getMenuId());
            %>

                <div class="flex justify-between items-center border-b pb-4">
                    <div>
                        <p class="font-bold text-gray-900"><%= menu.getItemName() %></p>
                        <p class="text-gray-500 text-sm">Qty: <%= item.getQuantity() %></p>
                    </div>

                    <img src="menuImage?id=<%= menu.getMenuId() %>"
                         onerror="this.src='https://via.placeholder.com/100'"
                         class="h-20 w-20 object-cover rounded-xl shadow">
                </div>

            <% } %>

            </div>

            <div class="text-right text-2xl font-bold text-gray-800 mt-6">
                Total: ₹ <%= finalTotal %>
            </div>
        </div>


        <!-- PAYMENT METHOD (MOVED TO BOTTOM) -->
        <div class="bg-white shadow-lg rounded-2xl p-6 mb-10">
            <h3 class="text-xl font-bold text-gray-800 mb-4">Select Payment Method</h3>

            <select name="paymentMode"
                    class="w-full px-4 py-3 border border-gray-300 rounded-xl outline-none focus:ring-2 focus:ring-brand">
                <option value="COD">Cash On Delivery (COD)</option>
                <option value="UPI">UPI Payment</option>
                <option value="DEBIT CARD">Debit Card</option>
            </select>
        </div>

    </form>


    <!-- CONFIRM ORDER BUTTON -->
    <button onclick="openModal()"
            class="w-full bg-brand text-white py-4 rounded-full text-lg hover:bg-brandDark transition shadow-lg mb-20">
        Confirm Order
    </button>

</div>


<!-- CONFIRMATION MODAL -->
<div id="confirmModal" class="fixed inset-0 hidden modal-bg flex justify-center items-center">

    <div class="bg-white rounded-2xl shadow-xl p-8 w-96">

        <h2 class="text-xl font-semibold text-gray-800 text-center">Place this order?</h2>

        <p class="text-gray-600 text-center mt-3">
            Your order will be placed and processed for delivery.
        </p>

        <div class="flex justify-center gap-4 mt-6">

            <!-- YES BUTTON SUBMITS ORDER -->
            <button onclick="document.getElementById('checkoutForm').submit()"
                    class="px-6 py-2 bg-brand text-white rounded-full hover:bg-brandDark">
                Yes, Confirm
            </button>

            <!-- CANCEL BUTTON -->
            <button onclick="closeModal()"
                    class="px-6 py-2 bg-gray-300 rounded-full hover:bg-gray-400">
                Cancel
            </button>
        </div>

    </div>

</div>


<!-- MODAL SCRIPT -->
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
