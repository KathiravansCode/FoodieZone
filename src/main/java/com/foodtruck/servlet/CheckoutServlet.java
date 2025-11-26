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

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
	 private static final long serialVersionUID = 1L;
	    private CartDAO cartDAO;
	    private MenuDAO menuDAO;

	    public void init() {
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
	            List<Cart> cartItems = cartDAO.getCartsByUserId(userId);

	            if (cartItems.isEmpty()) {
	                request.setAttribute("error", "Your cart is empty. Please add items to proceed.");
	                request.getRequestDispatcher("/cart.jsp").forward(request, response);
	                return;
	            }
	            
	            // 1. Calculate final total and get item details
	            Map<Integer, Menu> menuDetails = new HashMap<>();
	            double finalTotal = 0.0;
	            
	            for (Cart item : cartItems) {
	                Menu menu = menuDAO.getMenu(item.getMenuId());
	                if (menu != null) {
	                    menuDetails.put(item.getMenuId(), menu);
	                    finalTotal += item.getQuantity() * menu.getPrice();
	                }
	            }
	            
	            // 2. Set Attributes for the JSP
	            request.setAttribute("finalTotal", finalTotal);
	            request.setAttribute("user", currentUser); // Contains address
	            request.setAttribute("cartItems", cartItems); // Optional, for display sanity check
	            request.setAttribute("menuDetails", menuDetails);
	            // 3. Forward to the Checkout Details View
	            request.getRequestDispatcher("/checkout_details.jsp").forward(request, response);

	        } catch (Exception e) {
	            e.printStackTrace();
	            request.setAttribute("error", "Error during checkout preparation: " + e.getMessage());
	            request.getRequestDispatcher("/cart.jsp").forward(request, response);
	        }
	    }
   
}
