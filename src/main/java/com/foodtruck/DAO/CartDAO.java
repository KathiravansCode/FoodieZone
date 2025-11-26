package com.foodtruck.DAO;

import java.util.List;

import com.foodtruck.model.Cart;

public interface CartDAO {

    int addItemToCart(Cart cart);

 

    int updateItemQuantity(int cartId, int newQuantity);

    int removeItemFromCart(int cartId);

    int clearUserCart(int userId);

	List<Cart> getCartsByUserId(int userId);
	
	int getRestaurantIdInCart(int userId);
}

