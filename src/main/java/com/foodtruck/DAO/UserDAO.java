package com.foodtruck.DAO;

import java.util.List;

import com.foodtruck.model.User;


public interface UserDAO {
    // Authentication
    User getUserByUsernameAndPassword(String username, String password);
    boolean isUsernameExists(String username);

    // Role management
    int updateUserRole(int userId, String newRole);

    // CRUD
    int addUser(User user);
    User getUser(int userId);
    int updateUser(User user);
    int deleteUser(int userId);
    List<User> getAllUsers();
}
