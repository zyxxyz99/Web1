package ocms.web;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve form fields
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String roleName = request.getParameter("role");

        // reg_id is optional for teachers, required for students
        String regId = request.getParameter("reg_id");

        // ========== VALIDATION ===========

        // Basic fields
        if (fullName == null || fullName.isBlank() ||
            email == null || email.isBlank() ||
            username == null || username.isBlank() ||
            password == null || password.isBlank() ||
            roleName == null || roleName.isBlank()) {

            request.setAttribute("error", "All fields are required.");
            forwardToCorrectPage(roleName, request, response);
            return;
        }

        // Additional registration ID check ONLY for students
        if ("Student".equalsIgnoreCase(roleName)) {
            if (regId == null || regId.isBlank()) {
                request.setAttribute("error", "Registration ID is required for students.");
                forwardToCorrectPage(roleName, request, response);
                return;
            }
        }

        // For teacher, force reg_id to null (remove it)
        if ("Teacher".equalsIgnoreCase(roleName)) {
            regId = null;
        }

        // ========== DUPLICATE CHECKS ===========
        boolean duplicateUser = userDAO.isUserDuplicate(username, email);

        if (duplicateUser) {
            request.setAttribute("error",
                    "An account already exists with that username or email.");
            forwardToCorrectPage(roleName, request, response);
            return;
        }

        // Only check reg_id duplicates if student
        if ("Student".equalsIgnoreCase(roleName) && userDAO.isRegIdDuplicate(regId)) {
            request.setAttribute("error_regid",
                    "This Registration ID is already registered with another account.");
            forwardToCorrectPage(roleName, request, response);
            return;
        }

        // ========== ROLE ID ===========
        int roleId = userDAO.selectRoleIdByName(roleName);
        if (roleId == 0) {
            request.setAttribute("error", "Invalid role selected. Contact administrator.");
            forwardToCorrectPage(roleName, request, response);
            return;
        }

        // ========== CREATE USER OBJECT ===========
        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setUsername(username);
        newUser.setPassword(password);
        newUser.setRoleId(roleId);
        newUser.setRegId(regId);  // null for teachers

        // Save user in DB
        boolean success = userDAO.registerUser(newUser);

        if (success) {
            request.getSession().setAttribute("successMessage",
                    "Registration successful! You can now log in as a " + roleName + ".");
            response.sendRedirect("login");
        } else {
            request.setAttribute("error", "Registration failed due to a database error. Please try again.");
            forwardToCorrectPage(roleName, request, response);
        }
    }

    /**
     * Forward back to correct JSP while preserving foreground values + errors.
     */
    private void forwardToCorrectPage(String roleName, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if ("Student".equalsIgnoreCase(roleName)) {
            request.getRequestDispatcher("registerAsStudent.jsp").forward(request, response);
        } else if ("Teacher".equalsIgnoreCase(roleName)) {
            request.getRequestDispatcher("registerAsTeacher.jsp").forward(request, response);
        } else {
            request.getRequestDispatcher("register.jsp").forward(request, response);
        }
    }
}
