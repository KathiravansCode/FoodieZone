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

@WebServlet("/admin/dashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantDAO restaurantDAO;

    public void init() {
        this.restaurantDAO = new RestaurantDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (adminUser == null || !"ADMIN".equals(adminUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        try {
            // Fetch the admin's restaurant (guaranteed to exist by initialCheck)
            Restaurant restaurant = restaurantDAO.getRestaurantByAdminId(adminUser.getUserId());

            if (restaurant == null) {
                 // Safety net: if somehow they bypass the check, redirect them back
                response.sendRedirect(request.getContextPath() + "/admin/initialCheck");
                return;
            }

            request.setAttribute("restaurant", restaurant);
            
            // Pass any success/error messages stored in the session by management servlets
            request.setAttribute("adminSuccess", session.getAttribute("adminSuccess"));
            request.setAttribute("adminError", session.getAttribute("adminError"));
            session.removeAttribute("adminSuccess");
            session.removeAttribute("adminError");

            request.getRequestDispatcher("/admin-dashboard.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Error loading dashboard data: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/login");
        }
    }
}
