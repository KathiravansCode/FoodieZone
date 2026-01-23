package com.foodtruck.DAOImplementations;

import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.foodtruck.DAO.MenuDAO;
import com.foodtruck.model.Menu;
import com.foodtruck.util.DBConnection;

public class MenuDAOImpl implements MenuDAO {


    @Override
    public List<Menu> getMenuItemsByRestaurantId(int restaurantId) {             
        List<Menu> list = new ArrayList<>();
        String sql = "SELECT * FROM MENU WHERE restaurantId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, restaurantId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(extractMenu(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    //admin functionality
    @Override
    public int toggleItemAvailability(int menuId, boolean isAvailable) {
        String sql = "UPDATE MENU SET isAvailable = ? WHERE menuId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setBoolean(1, isAvailable);
            ps.setInt(2, menuId);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    //admin functionality
    @Override
    public int addMenu(Menu menu) {
        String sql = "INSERT INTO MENU (restaurantId, itemName, description, price, isAvailable,estimatedTime,itemImage) VALUES (?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, menu.getRestaurantId());
            ps.setString(2, menu.getItemName());
            ps.setString(3, menu.getDescription());
            ps.setDouble(4, menu.getPrice());
            ps.setBoolean(5, menu.isAvailable());
            ps.setInt(6, menu.getEstimatedTime());
            
            // Handle null image
            if (menu.getItemImage() != null) {
                ps.setBinaryStream(7, menu.getItemImage());
            } else {
                ps.setNull(7, java.sql.Types.BLOB);
            }

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) menu.setMenuId(keys.getInt(1));
                }
            }
            return affected;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public Menu getMenu(int menuId) {
        String sql = "SELECT * FROM MENU WHERE menuId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, menuId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return extractMenu(rs);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    public int updateMenu(Menu menu) {
        // Check if image is being updated
        if (menu.getItemImage() != null) {
            // Update with new image
            String sql = "UPDATE MENU SET itemName=?, description=?, price=?, isAvailable=?, estimatedTime=?, itemImage=? WHERE menuId=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, menu.getItemName());
                ps.setString(2, menu.getDescription());
                ps.setDouble(3, menu.getPrice());
                ps.setBoolean(4, menu.isAvailable());
                ps.setInt(5, menu.getEstimatedTime());
                ps.setBinaryStream(6, menu.getItemImage());
                ps.setInt(7, menu.getMenuId());
                return ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            // Update without changing image
            String sql = "UPDATE MENU SET itemName=?, description=?, price=?, isAvailable=?, estimatedTime=? WHERE menuId=?";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, menu.getItemName());
                ps.setString(2, menu.getDescription());
                ps.setDouble(3, menu.getPrice());
                ps.setBoolean(4, menu.isAvailable());
                ps.setInt(5, menu.getEstimatedTime());
                ps.setInt(6, menu.getMenuId());
                return ps.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return 0;
    }

    @Override
    public int deleteMenu(int menuId) {
        String sql = "DELETE FROM MENU WHERE menuId = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, menuId);
            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    @Override
    public List<Menu> getAllMenu() {
        List<Menu> list = new ArrayList<>();
        String sql = "SELECT * FROM MENU";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) list.add(extractMenu(rs));
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
    
    @Override
    public List<Menu> searchMenuItems(String keyword) {
        List<Menu> list = new ArrayList<>();

        String sql = "SELECT * FROM MENU WHERE description LIKE ? OR itemName LIKE ? and isAvailable=1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1,"%" + keyword + "%");
            ps.setString(2, "%" + keyword + "%");

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(extractMenu(rs));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }


    private Menu extractMenu(ResultSet rs) {
        try {
            Menu m = new Menu();
            m.setMenuId(rs.getInt("menuId"));
            m.setRestaurantId(rs.getInt("restaurantId"));
            m.setItemName(rs.getString("itemName"));
            m.setDescription(rs.getString("description"));
            m.setPrice(rs.getDouble("price"));
            m.setAvailable(rs.getBoolean("isAvailable"));
            m.setEstimatedTime(rs.getInt("estimatedTime"));
            m.setItemImage(rs.getBinaryStream("itemImage"));
          
            return m;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}