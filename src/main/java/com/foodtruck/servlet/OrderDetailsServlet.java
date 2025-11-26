package com.foodtruck.servlet;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.foodtruck.DAO.MenuDAO;
import com.foodtruck.DAO.OrderDAO;
import com.foodtruck.DAO.OrderItemDAO;
import com.foodtruck.DAOImplementations.MenuDAOImpl;
import com.foodtruck.DAOImplementations.OrderDAOImpl;
import com.foodtruck.DAOImplementations.OrderItemDAOImpl;
import com.foodtruck.model.Menu;
import com.foodtruck.model.OrderItem;
import com.foodtruck.model.Orders;
import com.foodtruck.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/order-details")
public class OrderDetailsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private OrderDAO orderDAO;
    private OrderItemDAO orderItemDAO;
    private MenuDAO menuDAO;

    public void init() {
        this.orderDAO = new OrderDAOImpl();
        this.orderItemDAO = new OrderItemDAOImpl();
        this.menuDAO = new MenuDAOImpl();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        try {
            String orderIdParam = request.getParameter("orderId");

            if (orderIdParam == null) {
                response.sendRedirect("order-history");
                return;
            }

            int orderId = Integer.parseInt(orderIdParam);

            // 1️⃣ Load Order Header
            Orders order = orderDAO.getOrder(orderId);

            if (order == null || order.getUserId() != currentUser.getUserId()) {
                response.sendRedirect("order-history?error=notfound");
                return;
            }

            // 2️⃣ Load Order Items
            List<OrderItem> items = orderItemDAO.getOrderItemsByOrderId(orderId);

            // 3️⃣ Load menu details for each order item
            Map<Integer, Menu> menuMap = new HashMap<>();
            double finalTotal = 0.0;

            for (OrderItem item : items) {
                Menu m = menuDAO.getMenu(item.getMenuId());
                if (m != null) {
                    menuMap.put(item.getMenuId(), m);
                    finalTotal += item.getQuantity() * item.getPrice();
                }
            }

            // 4️⃣ Set attributes
            request.setAttribute("order", order);
            request.setAttribute("items", items);
            request.setAttribute("menuDetails", menuMap);
            request.setAttribute("finalTotal", finalTotal);

            request.getRequestDispatcher("/order-details.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("order-history?error=server");
        }
    }
}
