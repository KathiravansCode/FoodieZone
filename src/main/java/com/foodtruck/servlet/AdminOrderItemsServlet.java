package com.foodtruck.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.foodtruck.DAO.OrderDAO;
import com.foodtruck.DAO.OrderItemDAO;
import com.foodtruck.DAO.MenuDAO;
import com.foodtruck.DAO.RestaurantDAO;

import com.foodtruck.DAOImplementations.OrderDAOImpl;
import com.foodtruck.DAOImplementations.OrderItemDAOImpl;
import com.foodtruck.DAOImplementations.MenuDAOImpl;
import com.foodtruck.DAOImplementations.RestaurantDAOImpl;

import com.foodtruck.model.OrderItem;
import com.foodtruck.model.Orders;
import com.foodtruck.model.Menu;
import com.foodtruck.model.Restaurant;
import com.foodtruck.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/admin/orderItems")
public class AdminOrderItemsServlet extends HttpServlet {

    private OrderDAO orderDAO = new OrderDAOImpl();
    private OrderItemDAO orderItemDAO = new OrderItemDAOImpl();
    private RestaurantDAO restaurantDAO = new RestaurantDAOImpl();
    private MenuDAO menuDAO = new MenuDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (adminUser == null || !"ADMIN".equalsIgnoreCase(adminUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String orderIdParam = request.getParameter("orderId");

        try {
            int orderId = Integer.parseInt(orderIdParam);

            Orders order = orderDAO.getOrder(orderId);
            Restaurant restaurant = restaurantDAO.getRestaurantByAdminId(adminUser.getUserId());

            if (order == null || restaurant == null || order.getRestaurantId() != restaurant.getRestaurantId()) {
                session.setAttribute("adminError", "Unauthorized access.");
                response.sendRedirect(request.getContextPath() + "/admin/orders");
                return;
            }

            // Fetch order items
            List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(orderId);

            // Combine each item with menu details
            List<Menu> menuDetails = new ArrayList<>();
            for (OrderItem oi : items) {
                Menu m = menuDAO.getMenu(oi.getMenuId());
                menuDetails.add(m);
            }

            request.setAttribute("order", order);
            request.setAttribute("items", items);
            request.setAttribute("menuDetails", menuDetails);
            request.setAttribute("restaurant", restaurant);

            request.getRequestDispatcher("/admin-order-items.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Error loading order items.");
            response.sendRedirect(request.getContextPath() + "/admin/orders");
        }
    }
}
