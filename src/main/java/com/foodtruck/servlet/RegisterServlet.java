package com.foodtruck.servlet;

import java.io.IOException;

import com.foodtruck.DAO.UserDAO;
import com.foodtruck.DAOImplementations.UserDAOImpl;
import com.foodtruck.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        this.userDAO = new UserDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        request.getRequestDispatcher("/register.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Use updated field names: fullName, email, phone, address
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName"); 
        String phone = request.getParameter("phone");
        String address = request.getParameter("address");
        String email = request.getParameter("email");
        String role=request.getParameter("role");
        User newUser = new User();
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setFullName(fullName);
        newUser.setRole(role); 
        newUser.setPhone(phone);
        newUser.setAddress(address);
        newUser.setEmail(email);

        // Check if username already exists using updated method name
        if (userDAO.isUsernameExists(username)) {
            request.setAttribute("error", "Username is already taken.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Add user using updated method name
        int rows = userDAO.addUser(newUser);

        if (rows > 0) {
            request.setAttribute("successMessage", "Registration successful! Please login.");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}