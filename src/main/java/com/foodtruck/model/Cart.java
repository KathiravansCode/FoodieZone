package com.foodtruck.model;

import java.sql.Timestamp;

public class Cart {
	    private int cartId;
	    private int userId;
	    private int menuId;
	    private int quantity;
	    private Timestamp createdAt;
		public int getCartId() {
			return cartId;
		}
		public void setCartId(int cartId) {
			this.cartId = cartId;
		}
		public int getUserId() {
			return userId;
		}
		public void setUserId(int userId) {
			this.userId = userId;
		}
		public int getMenuId() {
			return menuId;
		}
		public void setMenuId(int menuId) {
			this.menuId = menuId;
		}
		public int getQuantity() {
			return quantity;
		}
		public void setQuantity(int quantity) {
			this.quantity = quantity;
		}
		public Timestamp getCreatedAt() {
			return createdAt;
		}
		public void setCreatedAt(Timestamp createdAt) {
			this.createdAt = createdAt;
		}
	     
		public Cart() {
			// TODO Auto-generated constructor stub
		}
		public Cart(int cartId, int userId, int menuId, int quantity, Timestamp createdAt) {
			super();
			this.cartId = cartId;
			this.userId = userId;
			this.menuId = menuId;
			this.quantity = quantity;
			this.createdAt = createdAt;
		}
		@Override
		public String toString() {
			return "Cart [cartId=" + cartId + ", userId=" + userId + ", menuId=" + menuId + ", quantity=" + quantity
					+ ", createdAt=" + createdAt + "]";
		}
		
		
	    
}
