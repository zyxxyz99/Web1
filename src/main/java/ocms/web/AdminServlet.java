package ocms.web;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ocms.web.UserDAO; // Corrected import
import ocms.web.User; // Corrected import

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet implementation for Admin-specific tasks: User and Role Management.
 * Accessible via /AdminServlet
 */
@WebServlet("/AdminServlet")
public class AdminServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;
    private final int ADMIN_ROLE_ID = 1; 

    public void init() {
        // Initialize the DAO with the corrected package structure
        userDAO = new UserDAO(); 
    }
    
    /**
     * General authentication check for Admin access.
     */
    private boolean isAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Check if user is logged in and if their role is Admin (ID 1)
        if (currentUser == null || currentUser.getRoleId() != ADMIN_ROLE_ID) {
            // Set a message before redirecting
            session.setAttribute("message", "Access Denied: You must be an Administrator.");
            response.sendRedirect("dashboard.jsp"); // Redirect to a safe page
            return false;
        }
        return true;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!isAdmin(request, response)) {
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "listUsers"; 
        }

        try {
            switch (action) {
                case "listUsers":
                default:
                    listAllUsers(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        if (!isAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if ("makeAdmin".equals(action)) {
                updateUserToAdmin(request, response);
            } else if ("deleteUser".equals(action)) { // <--- ADDED DELETE HANDLER
                deleteUser(request, response);
            } else {
                doGet(request, response); 
            }
        } catch (SQLException ex) {
             throw new ServletException(ex);
        }
    }

    /**
     * Fetches all users and forwards to the management JSP.
     */
    private void listAllUsers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        
        List<User> listUsers = userDAO.selectAllUsers();
        request.setAttribute("listUsers", listUsers);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("user-management.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Updates a user's role to Admin (roleId = 1).
     */
    private void updateUserToAdmin(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        int userId = Integer.parseInt(request.getParameter("userId"));
        
        // Ensure the admin isn't trying to change their own role (optional check, good practice)
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser.getUserId() == userId) {
            session.setAttribute("message", "Error: You cannot change your own role!");
        } else if (userDAO.updateUserRole(userId, ADMIN_ROLE_ID)) {
            session.setAttribute("message", "User ID " + userId + " successfully promoted to Administrator!");
        } else {
            session.setAttribute("message", "Error promoting User ID " + userId + " to Administrator.");
        }
        
        response.sendRedirect("AdminServlet?action=listUsers");
    }
    
    /**
     * Deletes a user account. (NEW METHOD)
     */
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        HttpSession session = request.getSession();
        String userIdParam = request.getParameter("userId");
        int userIdToDelete = 0;
        
        if (userIdParam != null) {
            try {
                userIdToDelete = Integer.parseInt(userIdParam);
            } catch (NumberFormatException e) {
                session.setAttribute("message", "Error: Invalid User ID format.");
                response.sendRedirect("AdminServlet?action=listUsers");
                return;
            }
        }

        User currentUser = (User) session.getAttribute("currentUser");
        
        if (currentUser.getUserId() == userIdToDelete) {
             session.setAttribute("message", "Error: You cannot delete your own account!");
        } else {
            try {
                if (userDAO.deleteUser(userIdToDelete)) {
                    session.setAttribute("message", "User ID " + userIdToDelete + " successfully deleted.");
                } else {
                    session.setAttribute("message", "Failed to delete user ID " + userIdToDelete + ". User not found or internal error.");
                }
            } catch (SQLException e) {
                // Catch database constraint violations (e.g., user is a teacher of a course)
                session.setAttribute("message", "Error: Could not delete user ID " + userIdToDelete + ". This user may have associated data (e.g., courses, enrollments) that must be deleted first. Database Error: " + e.getMessage());
            }
        }
        
        // Redirect back to the user list
        response.sendRedirect("AdminServlet?action=listUsers");
    }
}