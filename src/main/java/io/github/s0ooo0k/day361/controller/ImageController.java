package org.example.ex11.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

@WebServlet("/image/*")
public class ImageController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        System.out.println(req.getPathInfo());
        req.setAttribute("image", req.getPathInfo());
        req.getRequestDispatcher("/WEB-INF/image.jsp").forward(req, resp);
    }
}