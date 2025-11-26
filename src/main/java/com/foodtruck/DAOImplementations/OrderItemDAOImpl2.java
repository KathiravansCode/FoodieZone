package com.foodtruck.DAOImplementations;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.foodtruck.DAO.OrderItemDAO;
import com.foodtruck.model.OrderItem;
import com.foodtruck.util.DBConnection;

public class OrderItemDAOImpl2 implements OrderItemDAO {

    @Override
    public int addOrderItems(List<OrderItem> orderItems) {
        String sql = "INSERT INTO ORDER_ITEM (orderId, menuId, quantity, price) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (OrderItem oi : orderItems) {
                ps.setInt(1, oi.getOrderId());
                ps.setInt(2, oi.getMenuId());
                ps.setInt(3, oi.getQuantity());
                ps.setDouble(4, oi.getPrice());
                ps.addBatch();
            }

            int[] results = ps.executeBatch();
            return results.length;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<OrderItem> getOrderItemsByOrderId(int orderId) {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM ORDER_ITEM WHERE orderId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) list.add(extractOrderItem(rs));

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int addOrderItem(OrderItem item) {
        String sql = "INSERT INTO ORDER_ITEM (orderId, menuId, quantity, price) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, item.getOrderId());
            ps.setInt(2, item.getMenuId());
            ps.setInt(3, item.getQuantity());
            ps.setDouble(4, item.getPrice());

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public OrderItem getOrderItem(int orderItemId) {
        String sql = "SELECT * FROM ORDER_ITEM WHERE orderItemId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderItemId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) return extractOrderItem(rs);

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
     
    //may the method go unused
    @Override
    public int updateOrderItem(OrderItem item) {
        String sql = "UPDATE ORDER_ITEM SET quantity=?, price=? WHERE orderItemId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, item.getQuantity());
            ps.setDouble(2, item.getPrice());
            ps.setInt(3, item.getOrderItemId());

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int deleteOrderItem(int orderItemId) {
        String sql = "DELETE FROM ORDER_ITEM WHERE orderItemId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderItemId);
            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<OrderItem> getAllOrderItems() {
        List<OrderItem> list = new ArrayList<>();
        String sql = "SELECT * FROM ORDER_ITEM";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(extractOrderItem(rs));

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private OrderItem extractOrderItem(ResultSet rs) {
        try {
            OrderItem item = new OrderItem();
            item.setOrderItemId(rs.getInt("orderItemId"));
            item.setOrderId(rs.getInt("orderId"));
            item.setMenuId(rs.getInt("menuId"));
            item.setQuantity(rs.getInt("quantity"));
            item.setPrice(rs.getDouble("price"));
            return item;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
