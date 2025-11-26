<%@ page import="com.foodtruck.model.Orders" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <title>Order Success | FoodZone</title>

    
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

    <!-- Success Animation CSS -->
    <style>
        .checkmark {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            display: block;
            stroke-width: 4;
            stroke: #22c55e;
            stroke-miterlimit: 10;
            margin: 20px auto;
            box-shadow: inset 0px 0px 0px #22c55e;
            animation: fill .4s ease-in-out .4s forwards, scale .3s ease-in-out .9s both;
        }

        .checkmark__circle {
            stroke-dasharray: 166;
            stroke-dashoffset: 166;
            stroke-width: 4;
            stroke-miterlimit: 10;
            stroke: #22c55e;
            animation: stroke 0.6s cubic-bezier(0.65, 0, 0.45, 1) forwards;
        }

        .checkmark__check {
            stroke-dasharray: 48;
            stroke-dashoffset: 48;
            stroke-width: 6;     /* BOLDER TICK */
            stroke: white;       /* White tick */
            animation: stroke 0.3s ease-in-out 0.6s forwards;
        }

        @keyframes stroke {
            100% { stroke-dashoffset: 0; }
        }

        @keyframes scale {
            50% { transform: scale3d(1.15, 1.15, 1); }
            100% { transform: scale3d(1, 1, 1); }
        }

        @keyframes fill {
            100% { box-shadow: inset 0px 0px 0px 45px #22c55e; }
        }
    </style>

</head>

<body class="bg-gray-100 min-h-screen">

<%
    Orders order = (Orders) request.getAttribute("order");
%>

<!-- CONTAINER -->
<div class="flex justify-center items-center py-20 px-4">

    <div class="bg-white w-full max-w-lg shadow-xl rounded-2xl p-10 text-center">

        <!-- Success Animation -->
        <svg class="checkmark" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 52 52">
            <circle class="checkmark__circle" cx="26" cy="26" r="25" fill="none"/>
            <path class="checkmark__check" fill="none" d="M16 27l7 7 15-15"/>
        </svg>

        <!-- Text -->
        <h2 class="text-3xl font-bold text-gray-800 mt-4">Order Placed Successfully!</h2>

        <p class="text-gray-600 mt-2">
            Thank you for ordering with <span class="text-brand font-bold">FoodZone</span>
        </p>

        <!-- ORDER INFO CARD -->
        <div class="bg-gray-100 rounded-xl p-6 mt-6 text-left shadow-inner">

            <p class="text-gray-700 text-lg">
                <span class="font-bold">Order ID:</span> #<%= order.getOrderId() %>
            </p>

            <p class="text-gray-700 text-lg mt-2">
                <span class="font-bold">Payment Mode:</span>
                <%= order.getPaymentMode() %>
            </p>

            <p class="text-gray-700 text-lg mt-2">
                <span class="font-bold">Status:</span>
                <%= order.getOrderStatus() %>
            </p>

            <p class="text-gray-700 text-lg mt-2">
                <span class="font-bold">Total Paid:</span>
                ₹ <%= order.getTotalAmount() %>
            </p>
        </div>

        <!-- BUTTONS -->
        <div class="mt-8 flex flex-col gap-4">

            <a href="orders"
               class="w-full bg-brand text-white py-3 rounded-full text-lg font-semibold hover:bg-brandDark transition">
                View My Orders
            </a>

            <a href="home"
               class="w-full bg-gray-200 text-gray-700 py-3 rounded-full text-lg font-semibold hover:bg-gray-300 transition">
                Continue Shopping
            </a>

        </div>
    </div>

</div>

</body>
</html>
