package com.foodtruck.model;

import java.io.InputStream;
import java.sql.Timestamp;

public class Restaurant {
	    private int restaurantId;
	    private String name;
	    private String address;
	    private String phone;
	    private double rating; 
	    private int adminId;
	    private String restaurantStatus;
	    private InputStream restaurantImage; 
	    private Timestamp createdAt;
		public int getRestaurantId() {
			return restaurantId;
		}
		public void setRestaurantId(int restaurantId) {
			this.restaurantId = restaurantId;
		}
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		public String getAddress() {
			return address;
		}
		public void setAddress(String address) {
			this.address = address;
		}
		public String getPhone() {
			return phone;
		}
		public void setPhone(String phone) {
			this.phone = phone;
		}
	
		public double getRating() {
			return rating;
		}
		public void setRating(double rating) {
			this.rating = rating;
		}
		public int getAdminId() {
			return adminId;
		}
		public void setAdminId(int adminId) {
			this.adminId = adminId;
		}
		public String getRestaurantStatus() {
			return restaurantStatus;
		}
		public void setRestaurantStatus(String restaurantStatus) {
			this.restaurantStatus = restaurantStatus;
		}
		public InputStream getRestaurantImage() {
			return restaurantImage;
		}
		public void setRestaurantImage(InputStream restaurantImage) {
			this.restaurantImage = restaurantImage;
		}
		public Timestamp getCreatedAt() {
			return createdAt;
		}
		public void setCreatedAt(Timestamp createdAt) {
			this.createdAt = createdAt;
		}
	    
	    public Restaurant() {
			// TODO Auto-generated constructor stub
		}
		public Restaurant(int restaurantId, String name, String address, String phone, double rating,
				int adminId, InputStream restaurantImage, Timestamp createdAt,String restaurantStatus) {
			super();
			this.restaurantId = restaurantId;
			this.name = name;
			this.address = address;
			this.phone = phone;
			
			this.rating = rating;
			this.adminId = adminId;
			this.restaurantImage = restaurantImage;
			this.createdAt = createdAt;
			this.restaurantStatus=restaurantStatus;
		}
		@Override
		public String toString() {
			return "Restaurant [restaurantId=" + restaurantId + ", name=" + name + ", address=" + address + ", phone="
					+ phone + ", rating=" + rating + ", adminId=" + adminId + ", restaurantStatus=" + restaurantStatus
					+ ", restaurantImage=" + restaurantImage + ", createdAt=" + createdAt + "]";
		}
		
		
	    
	    
	    
	    
}
