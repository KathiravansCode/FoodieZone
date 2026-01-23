package com.foodtruck.servlet;

import java.io.IOException;
import java.io.InputStream;
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
                InputStream imgStream = rs.getBinaryStream("restaurantImage");

                // Check if image exists in database
                if (imgStream != null) {
                    response.setContentType("image/jpeg");
                    OutputStream os = response.getOutputStream();
                    
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = imgStream.read(buffer)) != -1) {
                        os.write(buffer, 0, bytesRead);
                    }
                    os.flush();
                    imgStream.close();
                } else {
                    // No image in database - redirect to default image
                    response.sendRedirect("https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400");
                }
            } else {
                // Restaurant not found - redirect to default image
                response.sendRedirect("https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // On error, redirect to default image
            response.sendRedirect("https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400");
        }
    }
}