package com.foodtruck.servlet;



import java.io.IOException;
import java.io.OutputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.foodtruck.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/restaurantImage")
public class RestaurantImageServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                 "SELECT restaurantImage FROM restaurant WHERE restaurantId=?")) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                byte[] imgBytes = rs.getBytes("restaurantImage");

                if (imgBytes != null) {
                    response.setContentType("image/jpeg");
                    OutputStream os = response.getOutputStream();
                    os.write(imgBytes);
                    os.flush();
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
