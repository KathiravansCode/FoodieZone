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
import jakarta.servlet.http.HttpSession;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private UserDAO userDAO;

	public void init() {
		this.userDAO = new UserDAOImpl();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {
		request.getRequestDispatcher("/login.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
			throws ServletException, IOException {

		String username = request.getParameter("username");
		String password = request.getParameter("password");

		// 1. Authenticate using the new DAO method
		User user = userDAO.getUserByUsernameAndPassword(username, password);

		if (user != null) {
			HttpSession session = request.getSession();
			session.setAttribute("currentUser", user);

			// ADMIN REDIRECT
			if ("ADMIN".equalsIgnoreCase(user.getRole())) {
				response.sendRedirect(request.getContextPath() + "/admin/initialCheck");
				return;
			}

			// USER REDIRECT
			response.sendRedirect(request.getContextPath() + "/home");
			return;
		}
		else {
			request.setAttribute("loginError", "Invalid username or password.");
			request.getRequestDispatcher("/login.jsp").forward(request, response);
		}
	}
}