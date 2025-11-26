package com.foodtruck.servlet;

import java.io.IOException;

import com.foodtruck.DAO.CartDAO;
import com.foodtruck.DAOImplementations.CartDAOImpl;
import com.foodtruck.model.Cart;
import com.foodtruck.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/addToCart")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CartDAO cartDAO;

    public void init() {
        this.cartDAO = new CartDAOImpl();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String restaurantIdParam = request.getParameter("restaurantId");
        // Parameter sent from JS modal if the user confirms replacement
        String replaceCart = request.getParameter("replace"); 
        
        if (restaurantIdParam == null || restaurantIdParam.trim().isEmpty()) {
            request.setAttribute("cartError", "Missing restaurant information.");
            request.getRequestDispatcher("home").forward(request, response);
            return;
        }

        try {
            int userId = currentUser.getUserId();
            int menuId = Integer.parseInt(request.getParameter("menuId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));
            int incomingRestaurantId = Integer.parseInt(restaurantIdParam);

            if (quantity <= 0) {
                request.setAttribute("cartError", "Quantity must be at least 1.");
            } else {
                
                // Use the confirmed DAO method to check the current cart's restaurant ID
                int currentCartRestaurantId = cartDAO.getRestaurantIdInCart(userId);

                // --- RESTAURANT CHECK LOGIC ---
                // If cart is not empty (ID > 0) AND the current restaurant doesn't match the incoming one
                if (currentCartRestaurantId != 0 && currentCartRestaurantId != incomingRestaurantId) {
                    
                    if (!"true".equals(replaceCart)) {
                        // 1. First attempt: Ask for confirmation (Forward to JSP to display modal)
                        
                        // Set flag and data needed for the modal to submit the replacement
                        request.setAttribute("requiresConfirmation", true);
                        request.setAttribute("incomingRestaurantId", incomingRestaurantId);
                        request.setAttribute("menuId", menuId);
                        request.setAttribute("quantity", quantity);
                        
                        // Forward back to MenuServlet to display the menu page and the modal
                        request.getRequestDispatcher("menu?restaurantId=" + incomingRestaurantId).forward(request, response);
                        return; // Halt processing
                        
                    } else {
                        // 2. Second attempt: User confirmed replacement, clear the old cart
                        cartDAO.clearUserCart(userId);
                        request.setAttribute("cartSuccess", "Old cart cleared. Adding new item!");
                    }
                }
                
                // --- ADD ITEM LOGIC (runs if cart was empty, matched, or just cleared) ---
                Cart cartItem = new Cart();
                cartItem.setUserId(userId);
                cartItem.setMenuId(menuId);
                cartItem.setQuantity(quantity);
                
                int rows = cartDAO.addItemToCart(cartItem);

                if (rows > 0) {
                    request.setAttribute("cartSuccess", "Item added to cart successfully!");
                } else {
                    request.setAttribute("cartError", "Failed to add item to cart (Check logs for DB issue).");
                }
            }
            
            // Re-route back to the menu page (MenuServlet)
            request.getRequestDispatcher("menu?restaurantId=" + incomingRestaurantId).forward(request, response);

        } catch (NumberFormatException e) {
            request.setAttribute("cartError", "Invalid menu item ID or quantity.");
            request.getRequestDispatcher("menu?restaurantId=" + restaurantIdParam).forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("cartError", "Database error: " + e.getMessage());
            request.getRequestDispatcher("menu?restaurantId=" + restaurantIdParam).forward(request, response);
        }
    }
}
