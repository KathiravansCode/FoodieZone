package com.foodtruck.servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.foodtruck.DAO.CartDAO;
import com.foodtruck.DAO.MenuDAO;
import com.foodtruck.DAO.OrderDAO;
import com.foodtruck.DAO.OrderItemDAO;
import com.foodtruck.DAOImplementations.CartDAOImpl;
import com.foodtruck.DAOImplementations.MenuDAOImpl;
import com.foodtruck.DAOImplementations.OrderDAOImpl;
import com.foodtruck.DAOImplementations.OrderItemDAOImpl;
import com.foodtruck.model.Cart;
import com.foodtruck.model.Menu;
import com.foodtruck.model.OrderItem;
import com.foodtruck.model.Orders;
import com.foodtruck.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/confirm")
public class ConfirmOrderServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private OrderDAO orderDAO;
    private CartDAO cartDAO;
    private OrderItemDAO orderItemDAO;
    private MenuDAO menuDAO;

    public void init() {
        this.orderDAO = new OrderDAOImpl();
        this.cartDAO = new CartDAOImpl();
        this.orderItemDAO = new OrderItemDAOImpl();
        this.menuDAO = new MenuDAOImpl();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        // 1. Get checkout details from the form
        String paymentMode = request.getParameter("paymentMode");
        String deliveryAddress = request.getParameter("deliveryAddress");
        String totalAmountParam = request.getParameter("totalAmount"); 
        
        double totalAmount = 0.0;

        try {
            if (totalAmountParam != null && !totalAmountParam.isEmpty()) {
                totalAmount = Double.parseDouble(totalAmountParam);
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("cart?error=invalidtotal");
            return;
        }
        
        // 2. Basic Validation
        if (totalAmount <= 0 || deliveryAddress == null || deliveryAddress.trim().isEmpty()) {
            response.sendRedirect("cart?error=invalidorder"); 
            return;
        }

        try {
            int userId = currentUser.getUserId();
            List<Cart> cartItems = cartDAO.getCartsByUserId(userId);

            if (cartItems.isEmpty()) {
                response.sendRedirect("cart?error=empty");
                return;
            }
            
            // Determine the restaurant ID (assuming single restaurant cart policy)
            Menu firstItem = menuDAO.getMenu(cartItems.get(0).getMenuId());
            if (firstItem == null) {
                 response.sendRedirect("cart?error=itemnotfound");
                 return;
            }
            int restaurantId = firstItem.getRestaurantId();

            // 3. Start Order Transaction: Add Order Header
            Orders newOrder = new Orders();
            newOrder.setUserId(userId);
            newOrder.setRestaurantId(restaurantId);
            newOrder.setTotalAmount(totalAmount);
            newOrder.setOrderStatus("CONFIRMED"); // Initial status based on new schema
            newOrder.setPaymentMode(paymentMode.toUpperCase()); // Ensure it matches ENUM values (COD, UPI, DEBIT CARD)
            newOrder.setPaymentStatus(paymentMode.equals("COD") ? "PENDING" : "PAID");
            newOrder.setDeliveryAddress(deliveryAddress);

            int orderRows = orderDAO.addOrder(newOrder); 

            if (orderRows > 0 && newOrder.getOrderId() > 0) {
                
                // 4. Prepare and Add Order Items 
                List<OrderItem> orderItems = new ArrayList<>();
                for (Cart cart : cartItems) {
                    Menu menu = menuDAO.getMenu(cart.getMenuId());
                    if (menu == null) continue;
                                                        
                    OrderItem item = new OrderItem();
                    item.setOrderId(newOrder.getOrderId());
                    item.setMenuId(cart.getMenuId());
                    item.setQuantity(cart.getQuantity());
                    // Use price field from OrderItem model
                    item.setPrice(menu.getPrice()); 
                    orderItems.add(item);
                }
                
                int itemRows = orderItemDAO.addOrderItems(orderItems);

                if (itemRows > 0) {
                    // 5. Clear Cart (Success)
                    cartDAO.clearUserCart(userId);
                    
                    // 6. Redirect to confirmation page with order ID
                    response.sendRedirect("order-success?orderId=" + newOrder.getOrderId());
                    return;
                }
            } 
            
            // Failure during Order/Item insertion
            response.sendRedirect("cart?error=transactionfailed"); 

        } catch (Exception e) {
            e.printStackTrace();
            // In a production app, the DAOs would throw exceptions, and we would rollback the transaction here.
            response.sendRedirect("cart?error=servererror"); 
        }
    }
}