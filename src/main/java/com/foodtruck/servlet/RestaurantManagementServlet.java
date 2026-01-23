package com.foodtruck.servlet;

import java.io.IOException;

import com.foodtruck.DAO.RestaurantDAO;
import com.foodtruck.DAOImplementations.RestaurantDAOImpl;
import com.foodtruck.model.Restaurant;
import com.foodtruck.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;


@WebServlet("/admin/restaurant/manage")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 1, 
                 maxFileSize = 1024 * 1024 * 10,      
                 maxRequestSize = 1024 * 1024 * 50)   
public class RestaurantManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantDAO restaurantDAO;

    public void init() {
        this.restaurantDAO = new RestaurantDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        String restaurantIdParam = request.getParameter("restaurantId");

        if ("edit".equals(action) && restaurantIdParam != null) {
            try {
                int restaurantId = Integer.parseInt(restaurantIdParam);
                Restaurant restaurant = restaurantDAO.getRestaurant(restaurantId);
                if (restaurant != null) {
                    request.setAttribute("restaurant", restaurant);
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid restaurant ID.");
            } catch (Exception e) {
                request.setAttribute("error", "Database error fetching restaurant.");
            }
        }
        
        request.getRequestDispatcher("/manage-restaurant.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (adminUser == null || !"ADMIN".equals(adminUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String restaurantIdParam = request.getParameter("restaurantId");
        String action = request.getParameter("action");
        
        // Form Data
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String phone = request.getParameter("phone");
        String ratingParam = request.getParameter("rating");
        String restaurantStatus = request.getParameter("restaurantStatus"); 
        
        Restaurant restaurant = new Restaurant();
        restaurant.setName(name);
        restaurant.setAddress(address);
        restaurant.setPhone(phone);
        restaurant.setRestaurantStatus(restaurantStatus);
        
        try {
            if (ratingParam != null && !ratingParam.isEmpty()) {
                restaurant.setRating(Double.parseDouble(ratingParam));
            }
            restaurant.setAdminId(adminUser.getUserId());
            
            // Handle Image Upload - ONLY set if file is uploaded
            Part filePart = request.getPart("restaurantImage");
            if (filePart != null && filePart.getSize() > 0) {
                restaurant.setRestaurantImage(filePart.getInputStream());
            }
            // If no file uploaded, restaurantImage remains null (database will keep existing image on update)

            int rows = 0;
            if ("add".equals(action)) {
                rows = restaurantDAO.addRestaurant(restaurant);
            } else if ("edit".equals(action) && restaurantIdParam != null) {
                int restaurantId = Integer.parseInt(restaurantIdParam);
                restaurant.setRestaurantId(restaurantId);
                rows = restaurantDAO.updateRestaurant(restaurant);
            } else if ("delete".equals(action) && restaurantIdParam != null) {
                int restaurantId = Integer.parseInt(restaurantIdParam);
                rows = restaurantDAO.deleteRestaurant(restaurantId);
            }

            if (rows > 0) {
                session.setAttribute("adminSuccess", "Restaurant operation successful.");
                
                // If this was the initial 'add', redirect through the checker to get to the dashboard
                if ("add".equals(action) && restaurantIdParam == null) {
                     response.sendRedirect(request.getContextPath() + "/admin/initialCheck");
                     return;
                }
            } else {
                session.setAttribute("adminError", "Operation failed or no changes made.");
            }
            
        } catch (NumberFormatException e) {
            session.setAttribute("adminError", "Invalid number format provided for ID or Rating.");
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Database error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
    }
}