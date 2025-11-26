package com.foodtruck.DAOImplementations;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import com.foodtruck.DAO.UserDAO;
import com.foodtruck.model.User;
import com.foodtruck.util.DBConnection;

public class UserDAOImpl implements UserDAO {

    @Override
    public User getUserByUsernameAndPassword(String username, String password) {
        String sql = "SELECT * FROM `USER` WHERE `username`=? AND `password`=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);
            stmt.setString(2, password);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractUser(rs);
            }
        } 
        catch (Exception e)
        { 
        	e.printStackTrace(); 
        	
        }
        return null;
    }

    @Override
    public boolean isUsernameExists(String username) {
        String sql = "SELECT `userId` FROM `USER` WHERE `username`=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, username);

            ResultSet rs = stmt.executeQuery();
            return rs.next();

        } catch (Exception e) { e.printStackTrace(); }
        return false;
    }

    @Override
    public int updateUserRole(int userId, String newRole) {
        String sql = "UPDATE `USER` SET `role`=? WHERE `userId`=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, newRole);
            stmt.setInt(2, userId);

            return stmt.executeUpdate();

        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public int addUser(User user) {
        String sql = "INSERT INTO `USER`(`username`,`password`,`fullName`,`email`,`phone`,`role`,`address`) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getPassword());
            stmt.setString(3, user.getFullName());
            stmt.setString(4, user.getEmail());
            stmt.setString(5, user.getPhone());
            stmt.setString(6, user.getRole());
            stmt.setString(7, user.getAddress());
            return stmt.executeUpdate();

        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public User getUser(int userId) {
        String sql = "SELECT * FROM `USER` WHERE `userId`=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);

            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                return extractUser(rs);
            }

        } catch (Exception e) { e.printStackTrace(); }
        return null;
    }

    @Override
    public int updateUser(User user) {
        String sql = "UPDATE `USER` SET `username`=?, `fullName`=?, `email`=?, `phone`=?,`address`=? WHERE `userId`=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setString(1, user.getUsername());
            stmt.setString(2, user.getFullName());
            stmt.setString(3, user.getEmail());
            stmt.setString(4, user.getPhone());
            stmt.setString(5, user.getAddress());
            stmt.setInt(6, user.getUserId());

            return stmt.executeUpdate();

        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public int deleteUser(int userId) {
        String sql = "DELETE FROM `USER` WHERE `userId`=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, userId);
            return stmt.executeUpdate();

        } catch (Exception e) { e.printStackTrace(); }
        return 0;
    }

    @Override
    public List<User> getAllUsers() {
        List<User> list = new ArrayList<>();
        String sql = "SELECT * FROM `USER`";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                list.add(extractUser(rs));
            }

        } catch (Exception e) { e.printStackTrace(); }
        return list;
    }

    private User extractUser(ResultSet rs) {
        try {
            User u = new User();
            u.setUserId(rs.getInt("userId"));
            u.setUsername(rs.getString("username"));
            u.setPassword(rs.getString("password"));
            u.setFullName(rs.getString("fullName"));
            u.setEmail(rs.getString("email"));
            u.setPhone(rs.getString("phone"));
            u.setRole(rs.getString("role"));
            u.setAddress(rs.getString("address"));
            return u;
        } catch (Exception e)
        { 
        	e.printStackTrace(); 
        }
        return null;
    }
}
