package com.foodtruck.DAOImplementations;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.foodtruck.DAO.RestaurantDAO;
import com.foodtruck.model.Restaurant;
import com.foodtruck.util.DBConnection;

public class RestaurantDAOImpl implements RestaurantDAO {

    @Override
    public List<Restaurant> getAllActiveRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        String sql = "SELECT * FROM RESTAURANT WHERE restaurantStatus='OPEN' ";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(extractRestaurant(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public Restaurant getRestaurantByAdminId(int adminUserId) {
        String sql = "SELECT * FROM RESTAURANT WHERE adminId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, adminUserId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return extractRestaurant(rs);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int addRestaurant(Restaurant restaurant) {
        String sql = "INSERT INTO RESTAURANT (name,  address,rating, restaurantStatus, adminId, phone, restaurantImage) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, restaurant.getName());
            ps.setString(2, restaurant.getAddress());
            ps.setDouble(3, restaurant.getRating());
            ps.setString(4, restaurant.getRestaurantStatus());
            ps.setInt(5, restaurant.getAdminId());
            ps.setString(6, restaurant.getPhone());
            ps.setBinaryStream(7, restaurant.getRestaurantImage());
            
            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        restaurant.setRestaurantId(keys.getInt(1));
                    }
                }
            }
            return affected;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public Restaurant getRestaurant(int restaurantId) {
        String sql = "SELECT * FROM RESTAURANT WHERE restaurantId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, restaurantId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return extractRestaurant(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int updateRestaurant(Restaurant restaurant) {
        String sql = "UPDATE RESTAURANT SET name=?, rating=?, address=?, restaurantStatus=?, phone=?, restaurantImage=? WHERE restaurantId=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, restaurant.getName());
            ps.setDouble(2, restaurant.getRating());
            ps.setString(3, restaurant.getAddress());
            ps.setString(4, restaurant.getRestaurantStatus());
            ps.setString(5, restaurant.getPhone());
            ps.setBinaryStream(6, restaurant.getRestaurantImage());
            ps.setInt(7, restaurant.getRestaurantId());

            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public int deleteRestaurant(int restaurantId) {
        String sql = "DELETE FROM RESTAURANT WHERE restaurantId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, restaurantId);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Restaurant> getAllRestaurants() {
        List<Restaurant> list = new ArrayList<>();
        String sql = "SELECT * FROM RESTAURANT";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(extractRestaurant(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    @Override
    public List<Restaurant> searchRestaurants(String keyword) {
        List<Restaurant> list = new ArrayList<>();
        String sql = "SELECT * FROM RESTAURANT WHERE name LIKE ? AND restaurantStatus = 'OPEN' ";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, "%" + keyword + "%");
        
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractRestaurant(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private Restaurant extractRestaurant(ResultSet rs) {
        try {
            Restaurant r = new Restaurant();
            r.setRestaurantId(rs.getInt("restaurantId"));
            r.setName(rs.getString("name"));
            r.setRating(rs.getDouble("rating"));
            r.setAddress(rs.getString("address"));
            r.setRestaurantStatus(rs.getString("restaurantStatus"));
            r.setPhone(rs.getString("phone"));
            r.setAdminId(rs.getInt("adminId"));
            r.setRestaurantImage(rs.getBinaryStream("restaurantImage"));
            return r;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}