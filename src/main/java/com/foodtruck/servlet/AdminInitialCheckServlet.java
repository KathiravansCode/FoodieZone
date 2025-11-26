package com.foodtruck.servlet;

import java.io.IOException;

import com.foodtruck.DAO.RestaurantDAO;
import com.foodtruck.DAOImplementations.RestaurantDAOImpl;
import com.foodtruck.model.Restaurant;
import com.foodtruck.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/admin/initialCheck")
public class AdminInitialCheckServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantDAO restaurantDAO;

    public void init() {
        this.restaurantDAO = new RestaurantDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        // Ensure user is logged in and is an admin (AdminFilter should also catch this)
        if (adminUser == null || !"ADMIN".equals(adminUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Check if this admin has an associated restaurant using getRestaurantByAdminId
            Restaurant restaurant = restaurantDAO.getRestaurantByAdminId(adminUser.getUserId());

            if (restaurant != null) {
                // Restaurant exists, proceed to the main dashboard
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                // Restaurant does not exist, force registration
                request.getRequestDispatcher("/register-restaurant-prompt.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Database error during initialization.");
            response.sendRedirect(request.getContextPath() + "/login"); 
        }
    }
}