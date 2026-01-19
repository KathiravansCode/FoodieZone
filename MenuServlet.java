package com.foodtruck.servlet;

import java.io.IOException;
import java.util.List;

import com.foodtruck.DAO.CartDAO;
import com.foodtruck.DAO.MenuDAO;
import com.foodtruck.DAO.RestaurantDAO;
import com.foodtruck.DAOImplementations.CartDAOImpl;
import com.foodtruck.DAOImplementations.MenuDAOImpl;
import com.foodtruck.DAOImplementations.RestaurantDAOImpl;
import com.foodtruck.model.Menu;
import com.foodtruck.model.Restaurant;
import com.foodtruck.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private MenuDAO menuDAO;
    private RestaurantDAO restaurantDAO;
    private CartDAO cartDAO;

    public void init() {
        this.menuDAO = new MenuDAOImpl();
        this.restaurantDAO = new RestaurantDAOImpl();
        this.cartDAO = new CartDAOImpl();
    }

    protected void service(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String restaurantIdParam = request.getParameter("restaurantId");
        if (restaurantIdParam == null) {
            response.sendRedirect("home");
            return;
        }
        
        try {
            int restaurantId = Integer.parseInt(restaurantIdParam);
            String searchKeyword = request.getParameter("search");
            
            // Cart count logic
            int cartItemCount = cartDAO.getCartsByUserId(currentUser.getUserId()).size();
            request.setAttribute("cartItemCount", cartItemCount);
            request.setAttribute("user", currentUser);

            // Fetch Restaurant Details using updated method name
            Restaurant restaurant = restaurantDAO.getRestaurant(restaurantId);
            if (restaurant == null) {
                response.sendRedirect("home?error=invalidRestaurant");
                return;
            }
            request.setAttribute("restaurant", restaurant);
            
            // Fetch Menu Items (Handling search)
            List<Menu> menuItems;
            
            if (searchKeyword != null && !searchKeyword.trim().isEmpty()) {
                // Use the search method defined in your DAO
                menuItems = menuDAO.searchMenuItems(searchKeyword.trim());
                request.setAttribute("searchKeyword", searchKeyword);
                if (menuItems.isEmpty()) {
                     request.setAttribute("noMenuItemFound", true);
                }
            } else {
                // Use the getMenuItemsByRestaurantId method defined in your DAO
                menuItems = menuDAO.getMenuItemsByRestaurantId(restaurantId);
            }
            
            request.setAttribute("menuItems", menuItems);
            
            if (request.getAttribute("cartSuccess") != null) {
                request.setAttribute("successMessage", request.getAttribute("cartSuccess"));
            }
            if (request.getAttribute("cartError") != null) {
                request.setAttribute("errorMessage", request.getAttribute("cartError"));
            }

            request.getRequestDispatcher("/menu.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("home?error=invalidID");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error: Could not load menu items: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }
}
