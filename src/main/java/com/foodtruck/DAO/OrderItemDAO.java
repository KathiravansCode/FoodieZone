package com.foodtruck.DAO;

import java.util.List;

import com.foodtruck.model.OrderItem;

public interface OrderItemDAO {

    // Bulk insert during checkout
    int addOrderItems(List<OrderItem> orderItems);

    // Order details
    List<OrderItem> getOrderItemsByOrderId(int orderId);

    // CRUD
    int addOrderItem(OrderItem orderItem);
    OrderItem getOrderItem(int orderItemId);
    int updateOrderItem(OrderItem orderItem);
    int deleteOrderItem(int orderItemId);
    List<OrderItem> getAllOrderItems();
}
