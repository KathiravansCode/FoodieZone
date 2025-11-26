package com.foodtruck.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import com.foodtruck.DAO.RestaurantDAO;
import com.foodtruck.DAOImplementations.RestaurantDAOImpl;
import com.foodtruck.model.Restaurant;
import com.foodtruck.model.User;

@WebServlet("/admin/registerRestaurant")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class RegisterRestaurantServlet extends HttpServlet {

    private RestaurantDAO restaurantDAO = new RestaurantDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (adminUser == null || !"ADMIN".equalsIgnoreCase(adminUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/register-restaurant.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (adminUser == null || !"ADMIN".equalsIgnoreCase(adminUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String status = request.getParameter("status");

        Restaurant restaurant = new Restaurant();
        restaurant.setName(name);
        restaurant.setAddress(address);
        restaurant.setPhone(phone);
        restaurant.setRestaurantStatus(status);
        restaurant.setAdminId(adminUser.getUserId());

        Part imgPart = request.getPart("restaurantImage");
        if (imgPart != null && imgPart.getSize() > 0) {
            restaurant.setRestaurantImage(imgPart.getInputStream());
        }

        try {
            int rows = restaurantDAO.addRestaurant(restaurant);

            if (rows > 0) {
                session.setAttribute("adminSuccess", "Restaurant registered successfully!");
                response.sendRedirect(request.getContextPath() + "/admin/initialCheck");
            } else {
                request.setAttribute("adminError", "Failed to register restaurant");
                request.getRequestDispatcher("/register-restaurant.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("adminError", "Error: " + e.getMessage());
            request.getRequestDispatcher("/register-restaurant.jsp").forward(request, response);
        }
    }
}
