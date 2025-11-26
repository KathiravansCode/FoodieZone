package com.foodtruck.DAO;

import java.util.List;

import com.foodtruck.model.Restaurant;

public interface RestaurantDAO {


	    // Customer view
	    List<Restaurant> getAllActiveRestaurants();

	    // Admin — get only their restaurant
	    Restaurant getRestaurantByAdminId(int adminUserId);

	    // CRUD
	    int addRestaurant(Restaurant restaurant);
	    Restaurant getRestaurant(int restaurantId);
	    int updateRestaurant(Restaurant restaurant);
	    int deleteRestaurant(int restaurantId);
	    List<Restaurant> getAllRestaurants();
	    List<Restaurant> searchRestaurants(String keyword);
}