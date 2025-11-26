package com.foodtruck.model;

import java.sql.Timestamp;

public class Orders {
	private int orderId;
	private int userId;
	private int restaurantId;
	private double totalAmount;
	private String orderStatus;
	private String paymentMode;
	private String paymentStatus;
	private Timestamp createdAt;
	private String deliveryAddress;
	
	public int getOrderId() {
		return orderId;
	}
	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public int getRestaurantId() {
		return restaurantId;
	}
	public void setRestaurantId(int restaurantId) {
		this.restaurantId = restaurantId;
	}
	public double getTotalAmount() {
		return totalAmount;
	}
	public void setTotalAmount(double totalAmount) {
		this.totalAmount = totalAmount;
	}
	public String getOrderStatus() {
		return orderStatus;
	}
	public void setOrderStatus(String orderStatus) {
		this.orderStatus = orderStatus;
	}
	public String getPaymentMode() {
		return paymentMode;
	}
	public void setPaymentMode(String paymentMode) {
		this.paymentMode = paymentMode;
	}
	public String getPaymentStatus() {
		return paymentStatus;
	}
	public void setPaymentStatus(String paymentStatus) {
		this.paymentStatus = paymentStatus;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	
	public String getDeliveryAddress() {
		return deliveryAddress;
	}
	public void setDeliveryAddress(String deliveryAddress) {
		this.deliveryAddress = deliveryAddress;
	}
	public Orders() {
		// TODO Auto-generated constructor stub
	}
	
	public Orders(int orderId, int userId, int restaurantId, double totalAmount, String orderStatus, String paymentMode,
			String paymentStatus, Timestamp createdAt,String deliveryAddress) {
		super();
		this.orderId = orderId;
		this.userId = userId;
		this.restaurantId = restaurantId;
		this.totalAmount = totalAmount;
		this.orderStatus = orderStatus;
		this.paymentMode = paymentMode;
		this.paymentStatus = paymentStatus;
		this.createdAt = createdAt;
		this.deliveryAddress=deliveryAddress;
	}
	@Override
	public String toString() {
		return "Orders [orderId=" + orderId + ", userId=" + userId + ", restaurantId=" + restaurantId + ", totalAmount="
				+ totalAmount + ", orderStatus=" + orderStatus + ", paymentMode=" + paymentMode + ", paymentStatus="
				+ paymentStatus + ", createdAt=" + createdAt + ", deliveryAddress=" + deliveryAddress + "]";
	}
	
	

    
	
	

    
	
}
