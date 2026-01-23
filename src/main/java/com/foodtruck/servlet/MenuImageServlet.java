package com.foodtruck.servlet;

import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import com.foodtruck.util.DBConnection;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/menuImage")
public class MenuImageServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(
                     "SELECT itemImage FROM menu WHERE menuId=?")) {

            ps.setString(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                InputStream imgStream = rs.getBinaryStream("itemImage");

                // Check if image exists in database
                if (imgStream != null) {
                    response.setContentType("image/jpeg");
                    
                    byte[] buffer = new byte[4096];
                    int bytesRead;
                    while ((bytesRead = imgStream.read(buffer)) != -1) {
                        response.getOutputStream().write(buffer, 0, bytesRead);
                    }
                    response.getOutputStream().flush();
                    imgStream.close();
                } else {
                    // No image in database - redirect to default image
                    response.sendRedirect("https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400");
                }
            } else {
                // Menu item not found - redirect to default image
                response.sendRedirect("https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400");
            }

        } catch (Exception e) {
            e.printStackTrace();
            // On error, redirect to default image
            response.sendRedirect("https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=400");
        }
    }
}