package com.foodtruck.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.foodtruck.DAO.CartDAO;
import com.foodtruck.DAO.MenuDAO;
import com.foodtruck.DAOImplementations.CartDAOImpl;
import com.foodtruck.DAOImplementations.MenuDAOImpl;
import com.foodtruck.model.Cart;
import com.foodtruck.model.Menu;
import com.foodtruck.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/cart")
public class CartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CartDAO cartDAO;
    private MenuDAO menuDAO;

    public void init() {
        // Initialize DAOs using the correct package
        this.cartDAO = new CartDAOImpl();
        this.menuDAO = new MenuDAOImpl();
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
            
            // 1. Fetch Cart Items using the confirmed DAO method: getCartsByUserId
            List<Cart> cartItems = cartDAO.getCartsByUserId(userId);
            
            // 2. Fetch Menu details and calculate item cost for display
            Map<Integer, Menu> menuDetails = new HashMap<>();
            double subTotal = 0.0;
            
            for (Cart item : cartItems) {
                Menu menu = menuDAO.getMenu(item.getMenuId());
                if (menu != null) {
                    menuDetails.put(item.getMenuId(), menu);
                    // Use getPrice() from Menu model
                    subTotal += item.getQuantity() * menu.getPrice();
                }
            }
            
            // 3. Set Attributes
            request.setAttribute("cartItems", cartItems);
            request.setAttribute("menuDetails", menuDetails);
            request.setAttribute("subTotal", subTotal);
            request.setAttribute("cartItemCount", cartItems.size()); 
            request.setAttribute("user", currentUser);
            
            // 4. Forward to the Cart JSP
            request.getRequestDispatcher("/cart.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error loading cart details: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        String cartIdParam = request.getParameter("cartId");
        
        if (cartIdParam == null) {
            response.sendRedirect("cart"); 
            return;
        }
        
        try {
            int cartId = Integer.parseInt(cartIdParam);
            boolean success = false;
            String message = "";
            
            if ("update".equals(action)) {
                String quantityParam = request.getParameter("quantity");
                int quantity = Integer.parseInt(quantityParam);
                
                if (quantity > 0) {
                    // Use confirmed DAO method: updateItemQuantity(int cartId, int newQuantity)
                    success = cartDAO.updateItemQuantity(cartId, quantity) > 0;
                    message = success ? "Cart updated successfully!" : "Failed to update cart.";
                } else {
                    // Treat update to 0 or less as a remove action
                    // Use confirmed DAO method: removeItemFromCart(int cartId)
                    success = cartDAO.removeItemFromCart(cartId) > 0;
                    message = success ? "Item removed from cart!" : "Failed to remove item.";
                }
            } else if ("remove".equals(action)) {
                // Use confirmed DAO method: removeItemFromCart(int cartId)
                success = cartDAO.removeItemFromCart(cartId) > 0;
                message = success ? "Item removed from cart!" : "Failed to remove item.";
            } else {
                 message = "Invalid action.";
            }

            if (success) {
                request.setAttribute("cartSuccess", message);
            } else {
                request.setAttribute("cartError", message);
            }

            // Redirect back to GET method to refresh the cart display
            doGet(request, response); 

        } catch (NumberFormatException e) {
            request.setAttribute("cartError", "Invalid quantity or item ID.");
            doGet(request, response); 
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("cartError", "Database error during cart modification.");
            doGet(request, response); 
        }
    }
}