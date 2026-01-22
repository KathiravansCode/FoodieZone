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
        @keyframes scaleUp {
            0% { transform: scale(0); opacity: 0; }
            50% { transform: scale(1.1); }
            100% { transform: scale(1); opacity: 1; }
        }
        @keyframes slideUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
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
            animation: scaleUp 0.5s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        }
        .slide-up {
            animation: slideUp 0.6s 0.3s ease-out backwards;
        }
    </style>
</head>

<body class="bg-gradient-to-br from-green-50 to-emerald-50 min-h-screen flex items-center justify-center p-4">
<%
    Orders order = (Orders) request.getAttribute("order");
%>

<div class="bg-white max-w-md w-full shadow-2xl rounded-3xl p-10 text-center">
    <!-- Success Animation -->
    <div class="success-icon mb-6">
        <svg class="w-28 h-28 mx-auto" viewBox="0 0 52 52">
            <circle class="checkmark-circle" cx="26" cy="26" r="25" fill="none" stroke="#22c55e" stroke-width="2"/>
            <path class="checkmark-check" fill="none" stroke="#22c55e" stroke-width="4" d="M14 27l7 7 16-16"/>
        </svg>
    </div>

    <div class="slide-up">
        <h2 class="text-2xl font-bold text-gray-900 mb-2">Order Placed Successfully!</h2>
        <p class="text-sm text-gray-600 mb-8">Thank you for ordering with <span class="text-brand font-semibold">FoodZone</span></p>

        <!-- ORDER INFO -->
        <div class="bg-gradient-to-br from-orange-50 to-red-50 rounded-2xl p-5 mb-8 text-left">
            <div class="grid grid-cols-2 gap-4">
                <div>
                    <p class="text-xs text-gray-600 mb-1">Order ID</p>
                    <p class="text-base font-bold text-gray-900">#<%= order.getOrderId() %></p>
                </div>
                <div>
                    <p class="text-xs text-gray-600 mb-1">Status</p>
                    <p class="text-base font-bold text-green-600"><%= order.getOrderStatus() %></p>
                </div>
                <div>
                    <p class="text-xs text-gray-600 mb-1">Payment Mode</p>
                    <p class="text-base font-bold text-gray-900"><%= order.getPaymentMode() %></p>
                </div>
                <div>
                    <p class="text-xs text-gray-600 mb-1">Total Amount</p>
                    <p class="text-base font-bold text-brand">₹<%= order.getTotalAmount() %></p>
                </div>
            </div>
        </div>

        <!-- BUTTONS -->
        <div class="space-y-3">
            <a href="order-history"
   class="block w-full bg-brand text-white py-4 rounded-xl text-lg font-bold hover:bg-brandDark transition shadow-lg">
    View My Orders →
</a>
            <a href="home"
               class="block w-full bg-gray-100 text-gray-700 py-3 rounded-lg text-sm font-semibold hover:bg-gray-200 transition">
                Continue Shopping
            </a>
        </div>
    </div>
</div>
</body>
</html>