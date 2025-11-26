package com.foodtruck.model;

import java.io.InputStream;

public class Menu {
	private int menuId;
	private int restaurantId;
	private String itemName;
	private String description;
	private double price;
	private boolean isAvailable;
	private InputStream itemImage;
	private int estimatedTime;
	
	public int getMenuId() {
		return menuId;
	}
	public void setMenuId(int menuId) {
		this.menuId = menuId;
	}
	public int getRestaurantId() {
		return restaurantId;
	}
	public void setRestaurantId(int restaurantId) {
		this.restaurantId = restaurantId;
	}
	public String getItemName() {
		return itemName;
	}
	public void setItemName(String itemName) {
		this.itemName = itemName;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public double getPrice() {
		return price;
	}
	public void setPrice(double price) {
		this.price = price;
	}
	public boolean isAvailable() {
		return isAvailable;
	}
	public void setAvailable(boolean isAvailable) {
		this.isAvailable = isAvailable;
	}
	public InputStream getItemImage() {
		return itemImage;
	}
	public void setItemImage(InputStream itemImage) {
		this.itemImage = itemImage;
	}
	public int getEstimatedTime() {
		return estimatedTime;
	}
	public void setEstimatedTime(int estimatedTime) {
		this.estimatedTime = estimatedTime;
	}

	public Menu() {
		// TODO Auto-generated constructor stub
	}
	public Menu(int menuId, int restaurantId, String itemName, String description, double price, boolean isAvailable,
			InputStream itemImage, int estimatedTime) {
		super();
		this.menuId = menuId;
		this.restaurantId = restaurantId;
		this.itemName = itemName;
		this.description = description;
		this.price = price;
		this.isAvailable = isAvailable;
		this.itemImage = itemImage;
		this.estimatedTime = estimatedTime;
	}
	@Override
	public String toString() {
		return "Menu [menuId=" + menuId + ", restaurantId=" + restaurantId + ", itemName=" + itemName + ", description="
				+ description + ", price=" + price + ", isAvailable=" + isAvailable 
				+ ", estimatedTime=" + estimatedTime + "]";
	}


}
