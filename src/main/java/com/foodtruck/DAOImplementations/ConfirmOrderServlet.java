package com.foodtruck.DAOImplementations;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.foodtruck.DAO.CartDAO;
import com.foodtruck.DAO.MenuDAO;
import com.foodtruck.DAO.OrderDAO;
import com.foodtruck.DAO.OrderItemDAO;
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
@WebServlet("/confirmOrder")
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
            // Use confirmed DAO method: getCartsByUserId
            List<Cart> cartItems = cartDAO.getCartsByUserId(userId);

            if (cartItems.isEmpty()) {
                response.sendRedirect("cart?error=empty");
                return;
            }
            
            // Get restaurantId from the first item.
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
            newOrder.setOrderStatus("PENDING"); 
            newOrder.setPaymentMode(paymentMode);
            newOrder.setPaymentStatus("PENDING"); 
            newOrder.setDeliveryAddress(deliveryAddress);

            // Use confirmed DAO method: addOrder(Orders order)
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
                    // Use 'price' field name from OrderItem model
                    item.setPrice(menu.getPrice()); 
                    orderItems.add(item);
                }
                
                // Use confirmed DAO method: addOrderItems(List<OrderItem> orderItems)
                int itemRows = orderItemDAO.addOrderItems(orderItems);

                if (itemRows > 0) {
                    // 5. Clear Cart (using confirmed DAO method: clearUserCart)
                    cartDAO.clearUserCart(userId);
                    
                    // 6. Success: Redirect to confirmation
                    response.sendRedirect("orderConfirmation?orderId=" + newOrder.getOrderId());
                    return;
                }
            } 
            
            // If anything failed above (e.g., itemRows == 0)
            response.sendRedirect("cart?error=transactionfailed"); 

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("cart?error=servererror"); 
        }
    }
}