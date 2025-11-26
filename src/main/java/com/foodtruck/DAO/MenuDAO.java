package com.foodtruck.DAO;

import java.util.List;

import com.foodtruck.model.Menu;

public interface MenuDAO{
// Customer view
List<Menu> getMenuItemsByRestaurantId(int restaurantId);

// Admin — toggle availability
int toggleItemAvailability(int menuId, boolean isAvailable);

// CRUD
int addMenu(Menu menu);
Menu getMenu(int menuId);
int updateMenu(Menu menu);
int deleteMenu(int menuId);
List<Menu> getAllMenu();
List<Menu> searchMenuItems(String keyword);



}