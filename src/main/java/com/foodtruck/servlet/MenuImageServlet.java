package com.foodtruck.servlet;

import java.io.IOException;
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
                byte[] imgBytes = rs.getBytes("itemImage");

                if (imgBytes != null) {
                    response.setContentType("image/jpeg");
                    response.getOutputStream().write(imgBytes);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

