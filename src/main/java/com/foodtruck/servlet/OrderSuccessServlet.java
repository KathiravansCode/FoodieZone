package com.foodtruck.servlet;

import java.io.IOException;

import com.foodtruck.DAO.OrderDAO;
import com.foodtruck.DAOImplementations.OrderDAOImpl;
import com.foodtruck.model.Orders;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/order-success")
public class OrderSuccessServlet extends HttpServlet {

    private OrderDAO orderDAO;

    public void init() {
        orderDAO = new OrderDAOImpl();
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse resp) 
            throws ServletException, IOException {

        String orderIdParam = req.getParameter("orderId");
        if (orderIdParam == null) {
            resp.sendRedirect("home");
            return;
        }

        try {
            int orderId = Integer.parseInt(orderIdParam);
            Orders order = orderDAO.getOrder(orderId);

            if (order == null) {
                resp.sendRedirect("home");
                return;
            }

            req.setAttribute("order", order);
            req.getRequestDispatcher("order-success.jsp").forward(req, resp);

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect("home");
        }
    }
}

