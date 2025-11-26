package com.foodtruck.DAOImplementations;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.foodtruck.DAO.OrderDAO;
import com.foodtruck.model.Orders;
import com.foodtruck.util.DBConnection;

public class OrderDAOImpl implements OrderDAO {

	   
    @Override
    public int addOrder(Orders order) {

        String sql = "INSERT INTO ORDERS (userId, restaurantId, totalAmount, orderStatus,paymentMode, paymentStatus,deliveryAddress) VALUES (?, ?, ?, ?,?, ?,?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, order.getUserId());
            ps.setInt(2, order.getRestaurantId());
            ps.setDouble(3, order.getTotalAmount());
            ps.setString(4, order.getOrderStatus());
            ps.setString(5, order.getPaymentMode());
            ps.setString(6, order.getPaymentStatus());
            ps.setString(7, order.getDeliveryAddress());
            int rows = ps.executeUpdate();

            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int generatedId = rs.getInt(1);
                    order.setOrderId(generatedId);   // ⭐ SET ORDER ID BACK INTO THE MODEL
                }
            }

            return rows;  // 1 = success

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }


    @Override
    public int updatePaymentStatus(int orderId, String orderStatus,String paymentMode ,String paymentStatus) {

        String sql = "UPDATE ORDERS SET orderStatus = ?, paymentStatus = ?, paymentMode=? WHERE orderId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, orderStatus);
            ps.setString(2, paymentStatus);
            ps.setString(3, paymentMode);
            ps.setInt(4, orderId);

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }


    @Override
    public List<Orders> getOrdersByUserId(int userId) {

        List<Orders> list = new ArrayList<>();
        String sql = "SELECT * FROM ORDERS WHERE userId = ? ORDER BY createdAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(buildOrder(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

 
    @Override
    public List<Orders> getConfirmedOrdersByRestaurantId(int restaurantId) {

        List<Orders> list = new ArrayList<>();
     // Inside OrderDAOImpl.java - getConfirmedOrdersByRestaurantId(int restaurantId)
        String sql = "SELECT * FROM ORDERS WHERE restaurantId = ? AND orderStatus IN ('CONFIRMED') ORDER BY createdAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, restaurantId);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(buildOrder(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    @Override
    public int updateOrderStatus(int orderId, String status) {

        String sql = "UPDATE ORDERS SET orderStatus = ? WHERE orderId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, orderId);

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

   
    @Override
    public Orders getOrder(int orderId) {

        String sql = "SELECT * FROM ORDERS WHERE orderId = ?";
        Orders order = null;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                order = buildOrder(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return order;
    }

    // ---------------------------------------------------------
    // UPDATE ORDER DETAILS
    // ---------------------------------------------------------
    @Override
    public int updateOrder(Orders order) {

        String sql = "UPDATE ORDERS SET userId=?, restaurantId=?, paymentMode=?, totalAmount=?, orderStatus=?, paymentStatus=? "
                   + "WHERE orderId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, order.getUserId());
            ps.setInt(2, order.getRestaurantId());
            ps.setString(3, order.getPaymentMode());
            ps.setDouble(4, order.getTotalAmount());
            ps.setString(5, order.getOrderStatus());
            ps.setString(6, order.getPaymentStatus());
            ps.setInt(7, order.getOrderId());

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }


    @Override
    public int deleteOrder(int orderId) {

        String sql = "DELETE FROM ORDERS WHERE orderId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);
            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        return 0;
    }

      @Override
    public List<Orders> getAllOrders() {

        List<Orders> list = new ArrayList<>();
        String sql = "SELECT * FROM ORDERS ORDER BY createdAt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(buildOrder(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
      
      @Override
      public List<Orders> getOrdersByRestaurantId(int restaurantId) {

          List<Orders> list = new ArrayList<>();

          String sql = "SELECT * FROM ORDERS WHERE restaurantId = ? ORDER BY createdAt DESC";

          try (Connection conn = DBConnection.getConnection();
               PreparedStatement ps = conn.prepareStatement(sql)) {

              ps.setInt(1, restaurantId);

              ResultSet rs = ps.executeQuery();

              while (rs.next()) {
                  list.add(buildOrder(rs)); // uses your existing method
              }

          } catch (Exception e) {
              e.printStackTrace();
          }

          return list;
      }



    private Orders buildOrder(ResultSet rs) throws SQLException {

        Orders order = new Orders();

        order.setOrderId(rs.getInt("orderId"));
        order.setUserId(rs.getInt("userId"));
        order.setRestaurantId(rs.getInt("restaurantId"));
        order.setTotalAmount(rs.getDouble("totalAmount"));
        order.setOrderStatus(rs.getString("orderStatus"));
        order.setPaymentStatus(rs.getString("paymentStatus"));
        order.setCreatedAt(rs.getTimestamp("createdAt"));
        order.setPaymentMode(rs.getString("paymentMode"));       
        return order;
    }
}