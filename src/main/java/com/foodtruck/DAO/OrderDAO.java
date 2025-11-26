package com.foodtruck.DAO;

import java.util.List;

import com.foodtruck.model.Orders;

public interface OrderDAO {

    // Order placement
    int addOrder(Orders order);

    // Payment update
    int updatePaymentStatus(int orderId, String orderStatus,String paymentMode, String paymentStatus);

    // Customer history
    List<Orders> getOrdersByUserId(int userId);

    // Admin dashboard
    List<Orders> getConfirmedOrdersByRestaurantId(int restaurantId);
    List<Orders> getOrdersByRestaurantId(int restaurantId);
    
    // Admin updates status
    int updateOrderStatus(int orderId, String status);

    // CRUD
    Orders getOrder(int orderId);
    int updateOrder(Orders order);
    int deleteOrder(int orderId);
    List<Orders> getAllOrders();
}