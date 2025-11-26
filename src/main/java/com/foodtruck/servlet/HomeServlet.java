package com.foodtruck.servlet;

import java.io.IOException;
import java.util.Comparator;
import java.util.List;

import com.foodtruck.DAO.CartDAO;
import com.foodtruck.DAO.RestaurantDAO;
import com.foodtruck.DAOImplementations.CartDAOImpl;
import com.foodtruck.DAOImplementations.RestaurantDAOImpl;
import com.foodtruck.model.Restaurant;
import com.foodtruck.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private RestaurantDAO restaurantDAO;
    private CartDAO cartDAO; 

    public void init() {
        this.restaurantDAO = new RestaurantDAOImpl();
        this.cartDAO = new CartDAOImpl(); 
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
            List<Restaurant> restaurants;
            String searchKeyword = request.getParameter("search");
            
            // Cart count logic will depend on how you implement cart count in CartDAOImpl.
            // Assuming 0 for now as no explicit count method was in the uploaded DAO.
            int cartItemCount = cartDAO.getCartsByUserId(currentUser.getUserId()).size(); 
            request.setAttribute("cartItemCount", cartItemCount);
            request.setAttribute("user", currentUser);

            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                // Use the search method defined in your DAO
                restaurants = restaurantDAO.searchRestaurants(searchKeyword.trim());
                
                request.setAttribute("searchKeyword", searchKeyword);
                if (restaurants.isEmpty()) {
                     request.setAttribute("noRestaurantFound", true);
                }
                
            } else {
                // Use the getAllRestaurants method defined in your DAO
                restaurants = restaurantDAO.getAllRestaurants();
                
                // Sorting based on restaurantStatus ('OPEN' status will typically sort first)
                restaurants.sort(Comparator
                    .comparing(Restaurant::getRestaurantStatus, Comparator.reverseOrder()) 
                    .thenComparing(Restaurant::getName)
                );
            }

            request.setAttribute("restaurants", restaurants);
            request.getRequestDispatcher("/home.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Failed to load restaurant data or cart data: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
