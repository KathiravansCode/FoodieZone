package com.foodtruck.DAOImplementations;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.foodtruck.DAO.CartDAO;
import com.foodtruck.model.Cart;
import com.foodtruck.model.Cart;
import com.foodtruck.util.DBConnection;

public class CartDAOImpl implements CartDAO {

    @Override
    public int addItemToCart(Cart cart) {
        String checkSql = "SELECT cartId, quantity FROM CART WHERE userId=? AND menuId=?";
        String insertSql = "INSERT INTO CART(userId, menuId, quantity) VALUES (?,?,?)";
        String updateSql = "UPDATE CART SET quantity=? WHERE cartId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement checkStmt = conn.prepareStatement(checkSql)) {

            // Step 1: Check if item already exists
            checkStmt.setInt(1, cart.getUserId());
            checkStmt.setInt(2, cart.getMenuId());

            ResultSet rs = checkStmt.executeQuery();

            if (rs.next()) {
                // Already exists → update quantity
                int cartId = rs.getInt("cartId");
                int newQty = rs.getInt("quantity") + cart.getQuantity();

                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setInt(1, newQty);
                    updateStmt.setInt(2, cartId);
                    return updateStmt.executeUpdate();
                }

            } else {
                // Insert new cart item
                try (PreparedStatement insertStmt = conn.prepareStatement(insertSql)) {
                    insertStmt.setInt(1, cart.getUserId());
                    insertStmt.setInt(2, cart.getMenuId());
                    insertStmt.setInt(3, cart.getQuantity());
                    return insertStmt.executeUpdate();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Cart> getCartsByUserId(int userId) {
        List<Cart> list = new ArrayList<>();
        String sql = "SELECT * FROM CART WHERE userId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) list.add(extractCart(rs));

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public int updateItemQuantity(int cartId, int newQuantity) {
        String sql = "UPDATE CART SET quantity=? WHERE cartId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newQuantity);
            ps.setInt(2, cartId);

            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int removeItemFromCart(int cartId) {
        String sql = "DELETE FROM CART WHERE cartId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, cartId);
            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int clearUserCart(int userId) {
        String sql = "DELETE FROM CART WHERE userId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            return ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    
    @Override
    public int getRestaurantIdInCart(int userId) {
        String sql = "SELECT m.restaurantId FROM CART c JOIN MENU m ON c.menuId = m.menuId WHERE c.userId = ? LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                return rs.getInt("restaurantId");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0; // 0 indicates an empty cart or error
    }

    private Cart extractCart(ResultSet rs) {
        try {
            Cart ci = new Cart();
            ci.setCartId(rs.getInt("cartId"));
            ci.setUserId(rs.getInt("userId"));
            ci.setMenuId(rs.getInt("menuId"));
            ci.setQuantity(rs.getInt("quantity"));
            return ci;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
