package com.foodtruck.servlet;

import java.io.IOException;
import java.util.List;

import com.foodtruck.DAO.OrderDAO;
import com.foodtruck.DAOImplementations.OrderDAOImpl;
import com.foodtruck.model.Orders;
import com.foodtruck.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// FIXED: Changed URL mapping from "/orders" to "/order-history"
@WebServlet("/order-history")
public class OrderHistoryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;

    public void init() {
        this.orderDAO = new OrderDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            int userId = currentUser.getUserId();
            
            // Fetch all previous orders for the current user
            List<Orders> orderHistory = orderDAO.getOrdersByUserId(userId);
            
            // Debug logging
//            System.out.println("User ID: " + userId);
//            System.out.println("Orders found: " + (orderHistory != null ? orderHistory.size() : 0));
            
            String placed = request.getParameter("placed");
            if ("success".equals(placed)) {
                String orderId = request.getParameter("orderId");
                request.setAttribute("orderSuccess", "Order #" + orderId + " placed successfully!");
            }
            
            request.setAttribute("orderHistory", orderHistory);
            request.setAttribute("user", currentUser);
            
            request.getRequestDispatcher("/order-history.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading order history: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}