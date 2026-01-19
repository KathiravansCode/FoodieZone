<%@ page import="com.foodtruck.model.Orders" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Order Success | FoodZone</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: { extend: { colors: { brand: "#ff4d00", brandDark: "#e64500" } } }
        };
    </script>
    <style>
        @keyframes checkmark {
            0% { stroke-dashoffset: 166; }
            100% { stroke-dashoffset: 0; }
        }
        @keyframes circle {
            0% { stroke-dashoffset: 166; }
            100% { stroke-dashoffset: 0; }
        }
        @keyframes scale {
            0%, 100% { transform: scale(1); }
            50% { transform: scale(1.1); }
        }
        .checkmark-circle {
            stroke-dasharray: 166;
            animation: circle 0.6s ease-in-out;
        }
        .checkmark-check {
            stroke-dasharray: 48;
            stroke-dashoffset: 48;
            animation: checkmark 0.3s 0.6s ease-in-out forwards;
        }
        .success-icon {
            animation: scale 0.6s ease-in-out;
        }
    </style>
</head>

<body class="bg-gradient-to-br from-green-50 to-emerald-50 min-h-screen flex items-center justify-center p-4">

<%
    Orders order = (Orders) request.getAttribute("order");
%>

<div class="bg-white w-full max-w-lg shadow-2xl rounded-3xl p-10 text-center">

    <!-- Success Animation -->
    <div class="success-icon mb-6">
        <svg class="w-32 h-32 mx-auto" viewBox="0 0 52 52">
            <circle class="checkmark-circle" cx="26" cy="26" r="25" fill="none" stroke="#22c55e" stroke-width="2"/>
            <path class="checkmark-check" fill="none" stroke="#22c55e" stroke-width="4" d="M14 27l7 7 16-16"/>
        </svg>
    </div>

    <h2 class="text-4xl font-bold text-gray-900 mb-4">Order Placed Successfully! 🎉</h2>

    <p class="text-gray-600 text-lg mb-8">
        Thank you for ordering with <span class="text-brand font-bold">FoodZone</span>
    </p>

    <!-- ORDER INFO -->
    <div class="bg-gradient-to-r from-orange-50 to-red-50 rounded-2xl p-6 mb-8 text-left">
        <div class="grid grid-cols-2 gap-4">
            <div>
                <p class="text-gray-600 text-sm mb-1">Order ID</p>
                <p class="text-xl font-bold text-gray-900">#<%= order.getOrderId() %></p>
            </div>
            <div>
                <p class="text-gray-600 text-sm mb-1">Status</p>
                <p class="text-xl font-bold text-green-600"><%= order.getOrderStatus() %></p>
            </div>
            <div>
                <p class="text-gray-600 text-sm mb-1">Payment Mode</p>
                <p class="text-xl font-bold text-gray-900"><%= order.getPaymentMode() %></p>
            </div>
            <div>
                <p class="text-gray-600 text-sm mb-1">Total Amount</p>
                <p class="text-xl font-bold text-brand">₹<%= order.getTotalAmount() %></p>
            </div>
        </div>
    </div>

    <!-- BUTTONS -->
    <div class="space-y-4">
        <a href="orders"
           class="block w-full bg-brand text-white py-4 rounded-xl text-lg font-bold hover:bg-brandDark transition shadow-lg">
            View My Orders →
        </a>

        <a href="home"
           class="block w-full bg-gray-200 text-gray-700 py-4 rounded-xl text-lg font-semibold hover:bg-gray-300 transition">
            Continue Shopping
        </a>
    </div>

</div>

</body>
</html>