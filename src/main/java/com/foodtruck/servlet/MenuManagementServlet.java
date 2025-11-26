package com.foodtruck.servlet;

import java.io.IOException;
import java.util.List;

import com.foodtruck.DAO.MenuDAO;
import com.foodtruck.DAO.RestaurantDAO;
import com.foodtruck.DAOImplementations.MenuDAOImpl;
import com.foodtruck.DAOImplementations.RestaurantDAOImpl;
import com.foodtruck.model.Menu;
import com.foodtruck.model.Restaurant;
import com.foodtruck.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet("/admin/menu")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize = 1024 * 1024 * 10,
        maxRequestSize = 1024 * 1024 * 50
)
public class MenuManagementServlet extends HttpServlet {

    private MenuDAO menuDAO = new MenuDAOImpl();
    private RestaurantDAO restaurantDAO = new RestaurantDAOImpl();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (adminUser == null || !"ADMIN".equalsIgnoreCase(adminUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        String restaurantIdParam = request.getParameter("restaurantId");
        String menuIdParam = request.getParameter("menuId");

        try {
            int restaurantId = Integer.parseInt(restaurantIdParam);

            Restaurant restaurant = restaurantDAO.getRestaurant(restaurantId);

            if (restaurant == null || restaurant.getAdminId() != adminUser.getUserId()) {
                session.setAttribute("adminError", "Unauthorized access.");
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                return;
            }

            // OPEN ADD PAGE
            if ("add".equalsIgnoreCase(action)) {
                request.setAttribute("restaurant", restaurant);
                request.getRequestDispatcher("/manage-menu.jsp").forward(request, response);
                return;
            }

            // OPEN EDIT PAGE
            if ("edit".equalsIgnoreCase(action) && menuIdParam != null) {
                int menuId = Integer.parseInt(menuIdParam);
                Menu menu = menuDAO.getMenu(menuId);

                request.setAttribute("menu", menu);
                request.setAttribute("restaurant", restaurant);
                request.getRequestDispatcher("/manage-menu.jsp").forward(request, response);
                return;
            }

            // LIST PAGE
            List<Menu> menuItems = menuDAO.getMenuItemsByRestaurantId(restaurantId);
            request.setAttribute("restaurant", restaurant);
            request.setAttribute("menuItems", menuItems);

            request.getRequestDispatcher("/admin-menu.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("adminError", "Invalid restaurant or menu ID.");
            response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        User adminUser = (session != null) ? (User) session.getAttribute("currentUser") : null;

        if (adminUser == null || !"ADMIN".equalsIgnoreCase(adminUser.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        int restaurantId = Integer.parseInt(request.getParameter("restaurantId"));
        String menuIdParam = request.getParameter("menuId");

        try {
            int rows = 0;

            if ("delete".equals(action) && menuIdParam != null) {
                rows = menuDAO.deleteMenu(Integer.parseInt(menuIdParam));
                session.setAttribute("adminSuccess", "Item deleted successfully.");
            }
            else if ("toggle".equals(action) && menuIdParam != null) {
                int menuId = Integer.parseInt(menuIdParam);
                boolean available = Boolean.parseBoolean(request.getParameter("isAvailable"));
                rows = menuDAO.toggleItemAvailability(menuId, available);
                session.setAttribute("adminSuccess", "Item availability updated.");
            }
            else {
                String itemName = request.getParameter("itemName");
                String description = request.getParameter("description");
                double price = Double.parseDouble(request.getParameter("price"));
                int estimatedTime = Integer.parseInt(request.getParameter("estimatedTime"));
                boolean isAvailable = request.getParameter("isAvailable") != null;

                Menu menu = new Menu();
                menu.setRestaurantId(restaurantId);
                menu.setItemName(itemName);
                menu.setDescription(description);
                menu.setPrice(price);
                menu.setEstimatedTime(estimatedTime);
                menu.setAvailable(isAvailable);

                Part filePart = request.getPart("itemImage");
                if (filePart != null && filePart.getSize() > 0) {
                    menu.setItemImage(filePart.getInputStream());
                }

                if ("add".equals(action)) {
                    rows = menuDAO.addMenu(menu);
                    session.setAttribute("adminSuccess", "Item added successfully.");
                }
                else if ("edit".equals(action)) {
                    int menuId = Integer.parseInt(menuIdParam);
                    menu.setMenuId(menuId);
                    rows = menuDAO.updateMenu(menu);
                    session.setAttribute("adminSuccess", "Item updated successfully.");
                }
            }

            if (rows <= 0) {
                session.setAttribute("adminError", "Operation failed.");
            }

        } catch (Exception e) {
            session.setAttribute("adminError", "Error: " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/admin/menu?restaurantId=" + restaurantId);
    }
}
