package com.fashionstore.controller;

import com.fashionstore.daoimpl.CartDAOImpl;
import com.fashionstore.daoimpl.UserDAOImpl;
import com.fashionstore.model.User;
import com.fashionstore.util.PasswordUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


import java.io.IOException;
@WebServlet("/user")


public class UserController extends HttpServlet {

    private UserDAOImpl userDAO;
    private CartDAOImpl cartDAO;

    @Override
    public void init() {
        userDAO = new UserDAOImpl();
        cartDAO = new CartDAOImpl();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "loginPage";

        switch (action) {

            case "loginPage":
                request.getRequestDispatcher("/WEB-INF/views/user/login.jsp")
                       .forward(request, response);
                break;

            case "registerPage":
                request.getRequestDispatcher("/WEB-INF/views/user/register.jsp")
                       .forward(request, response);
                break;

            case "logout":
                handleLogout(request, response);
                break;

            case "profile":
                handleProfile(request, response);
                break;

            default:
                request.getRequestDispatcher("/WEB-INF/views/user/login.jsp")
                       .forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "";

        switch (action) {

            case "login":
                handleLogin(request, response);
                break;

            case "register":
                handleRegister(request, response);
                break;

            case "updateProfile":
                handleUpdateProfile(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/user?action=loginPage");
                break;
        }
    }

    // =============================================
    // LOGIN
    // =============================================
    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        if (email == null || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required.");
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp")
                   .forward(request, response);
            return;
        }

        // BCrypt verification happens inside loginUser method
        User user = userDAO.loginUser(email.trim(), password.trim());

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getFullName());

            // Create cart if not exists
            if (cartDAO.getCartByUserId(user.getUserId()) == null) {
                cartDAO.createCart(user.getUserId());
            }

            // Set cart count in session
            var cart = cartDAO.getCartByUserId(user.getUserId());
            if (cart != null) {
                int count = cartDAO.getCartItemCount(cart.getCartId());
                session.setAttribute("cartCount", count);
                session.setAttribute("cartId", cart.getCartId());
            } else {
                session.setAttribute("cartCount", 0);
            }

            response.sendRedirect(request.getContextPath() + "/home");

        } else {
            request.setAttribute("error", "Invalid email or password. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/user/login.jsp")
                   .forward(request, response);
        }
    }

    // =============================================
    // REGISTER
    // =============================================
    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String fullName        = request.getParameter("fullName");
        String email           = request.getParameter("email");
        String phone           = request.getParameter("phone");
        String password        = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String address         = request.getParameter("address");

        // Validate required fields
        if (fullName == null || fullName.trim().isEmpty() ||
            email == null    || email.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            address == null  || address.trim().isEmpty()) {

            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("/WEB-INF/views/user/register.jsp")
                   .forward(request, response);
            return;
        }

        // Password length check
        if (password.trim().length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters.");
            request.getRequestDispatcher("/WEB-INF/views/user/register.jsp")
                   .forward(request, response);
            return;
        }

        // Password match check
        if (confirmPassword != null && !password.trim().equals(confirmPassword.trim())) {
            request.setAttribute("error", "Passwords do not match.");
            request.getRequestDispatcher("/WEB-INF/views/user/register.jsp")
                   .forward(request, response);
            return;
        }

        // Email already exists check
        if (userDAO.isEmailExists(email.trim())) {
            request.setAttribute("error", "This email is already registered. Please login.");
            request.getRequestDispatcher("/WEB-INF/views/user/register.jsp")
                   .forward(request, response);
            return;
        }

        // Hash password using BCrypt before saving
        String hashedPassword = PasswordUtil.hashPassword(password.trim());

        User user = new User();
        user.setFullName(fullName.trim());
        user.setEmail(email.trim());
        user.setPhone(phone != null ? phone.trim() : "");
        user.setPassword(hashedPassword);
        user.setAddress(address.trim());

        boolean registered = userDAO.registerUser(user);

        if (registered) {
            User newUser = userDAO.getUserByEmail(email.trim());

            HttpSession session = request.getSession();
            session.setAttribute("user", newUser);
            session.setAttribute("userId", newUser.getUserId());
            session.setAttribute("userName", newUser.getFullName());
            session.setAttribute("cartCount", 0);

            // Create cart for new user
            cartDAO.createCart(newUser.getUserId());

            response.sendRedirect(request.getContextPath() + "/home");

        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/WEB-INF/views/user/register.jsp")
                   .forward(request, response);
        }
    }

    // =============================================
    // LOGOUT
    // =============================================
    private void handleLogout(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/home");
    }

    // =============================================
    // PROFILE
    // =============================================
    private void handleProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=loginPage");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");
        User freshUser   = userDAO.getUserById(sessionUser.getUserId());
        request.setAttribute("user", freshUser);

        request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp")
               .forward(request, response);
    }

    // =============================================
    // UPDATE PROFILE
    // =============================================
    private void handleUpdateProfile(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/user?action=loginPage");
            return;
        }

        User sessionUser = (User) session.getAttribute("user");

        String fullName = request.getParameter("fullName");
        String phone    = request.getParameter("phone");
        String address  = request.getParameter("address");

        // Validate
        if (fullName == null || fullName.trim().isEmpty() ||
            address == null  || address.trim().isEmpty()) {
            request.setAttribute("error", "Name and address are required.");
            request.setAttribute("user", sessionUser);
            request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp")
                   .forward(request, response);
            return;
        }

        User user = new User();
        user.setUserId(sessionUser.getUserId());
        user.setFullName(fullName.trim());
        user.setEmail(sessionUser.getEmail());
        user.setPhone(phone != null ? phone.trim() : "");
        user.setAddress(address.trim());

        boolean updated = userDAO.updateUser(user);

        if (updated) {
            User freshUser = userDAO.getUserById(sessionUser.getUserId());
            session.setAttribute("user", freshUser);
            session.setAttribute("userName", freshUser.getFullName());
            request.setAttribute("success", "Profile updated successfully!");
            request.setAttribute("user", freshUser);
        } else {
            request.setAttribute("error", "Update failed. Please try again.");
            request.setAttribute("user", sessionUser);
        }

        request.getRequestDispatcher("/WEB-INF/views/user/profile.jsp")
               .forward(request, response);
    }
}
