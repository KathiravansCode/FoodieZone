
package com.foodtruck.model;

import java.sql.Timestamp;

public class User {
	private int userId;
	private String username;
	private String password;
	private String fullName;
	private String email;
	private String phone;
	private String role;
	private String address;
	
	public String getAddress() {
		return address;
	}
	public void setAddress(String address) {
		this.address = address;
	}

	private Timestamp createdAt;
	
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getFullName() {
		return fullName;
	}
	public void setFullName(String fullName) {
		this.fullName = fullName;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public Timestamp getCreatedAt() {
		return createdAt;
	}
	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}
	
	public User() {
		// TODO Auto-generated constructor stub
	}
	public User(int userId, String username, String password, String fullName, String email, String phone, String role,
			Timestamp createdAt,String address) {
		super();
		this.userId = userId;
		this.username = username;
		this.password = password;
		this.fullName = fullName;
		this.email = email;
		this.phone = phone;
		this.role = role;
		this.createdAt = createdAt;
		this.address=address;
	}
	
	@Override
	public String toString() {
		return "User [userId=" + userId + ", username=" + username + ", password=" + password + ", fullName=" + fullName
				+ ", email=" + email + ", phone=" + phone + ", role=" + role + ", address=" + address + ", createdAt="
				+ createdAt + "]";
	}
	
	
	
	
}
