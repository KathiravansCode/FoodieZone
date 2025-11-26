package com.foodtruck.servlet;

import java.io.IOException;
import java.util.List;
import java.util.stream.Collectors;

import com.foodtruck.DAO.OrderDAO;
import com.foodtruck.DAO.RestaurantDAO;
import com.foodtruck.DAOImplementations.OrderDAOImpl;
import com.foodtruck.DAOImplementations.RestaurantDAOImpl;
import com.foodtruck.model.Orders;
import com.foodtruck.model.Restaurant;
import com.foodtruck.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/orders")
public class AdminOrderServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private RestaurantDAO restaurantDAO;

    @Override
    public void init() {
        this.orderDAO = new OrderDAOImpl();
        this.restaurantDAO = new RestaurantDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Security
        if (adminUser == null || !"admin".equalsIgnoreCase(adminUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Fetch restaurant for this admin
            Restaurant restaurant = restaurantDAO.getRestaurantByAdminId(adminUser.getUserId());
            if (restaurant == null) {
                // Safety fallback
                response.sendRedirect(request.getContextPath() + "/admin/initialCheck");
                return;
            }

            // Fetch all orders for this restaurant
            List<Orders> orders = orderDAO.getOrdersByRestaurantId(restaurant.getRestaurantId());

            // Separate PENDING/CONFIRMED vs DELIVERED
            List<Orders> pendingOrders = orders.stream()
                    .filter(o -> o.getOrderStatus().equalsIgnoreCase("PENDING")
                              || o.getOrderStatus().equalsIgnoreCase("CONFIRMED"))
                    .collect(Collectors.toList());

            List<Orders> completedOrders = orders.stream()
                    .filter(o -> o.getOrderStatus().equalsIgnoreCase("DELIVERED"))
                    .collect(Collectors.toList());

            request.setAttribute("restaurant", restaurant);
            request.setAttribute("pendingOrders", pendingOrders);
            request.setAttribute("completedOrders", completedOrders);

            // Pass session messages
            request.setAttribute("adminSuccess", session.getAttribute("adminSuccess"));
            request.setAttribute("adminError", session.getAttribute("adminError"));
            session.removeAttribute("adminSuccess");
            session.removeAttribute("adminError");

            request.getRequestDispatcher("/admin-order-view.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Failed to load orders.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (adminUser == null || !"admin".equalsIgnoreCase(adminUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdParam = request.getParameter("orderId");
        String newStatus = request.getParameter("newStatus");

        if (orderIdParam == null || newStatus == null) {
            session.setAttribute("adminError", "Invalid request.");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);

            Orders order = orderDAO.getOrder(orderId);
            Restaurant restaurant = restaurantDAO.getRestaurantByAdminId(adminUser.getUserId());

            if (order == null || restaurant == null || order.getRestaurantId() != restaurant.getRestaurantId()) {
                session.setAttribute("adminError", "Unauthorized or order not found.");
            } else {
                // Only change orderStatus - do NOT touch paymentMode/paymentStatus
                int rows = orderDAO.updateOrderStatus(orderId, newStatus);

                if (rows > 0) {
                    session.setAttribute("adminSuccess", "Order #" + orderId + " updated to " + newStatus + ".");
                } else {
                    session.setAttribute("adminError", "Failed to update order.");
                }
            }

        } catch (NumberFormatException e) {
            session.setAttribute("adminError", "Invalid order ID.");
        }

        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }
}
