package ocms.web;

import java.io.IOException;
import jakarta.servlet.ServletException; // Changed from javax.servlet.ServletException
import jakarta.servlet.annotation.WebServlet; // Changed from javax.servlet.annotation.WebServlet
import jakarta.servlet.http.HttpServlet; // Changed from javax.servlet.http.HttpServlet
import jakarta.servlet.http.HttpServletRequest; // Changed from javax.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse; // Changed from javax.servlet.http.HttpServletResponse
import jakarta.servlet.http.HttpSession; // Changed from javax.servlet.http.HttpSession

import ocms.web.UserDAO;
import ocms.web.User;

/**
 * Servlet implementation class LoginServlet
 * Handles user login requests, authenticates credentials, and manages the session.
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        // Initialize the DAO when the servlet starts
        userDAO = new UserDAO();
    }

	/**
	 * Handles HTTP POST requests for login form submission.
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // 1. Get parameters from the login form (Now retrieving email instead of username)
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		
        // 2. Validate input (basic check)
        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            request.setAttribute("error", "Email and Password cannot be empty.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
            return;
        }

        // 3. Authenticate user using the DAO
        // NOTE: The UserDAO.authenticateUser method will need to be updated 
        // in a separate step to look up the user by 'email' instead of 'username'.
        User user = userDAO.authenticateUser(email, password);
        
        if (user != null) {
            // 4. Authentication successful: Set user session and redirect to dashboard
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user); // Store the User object in session
            
            // Redirect based on role (for future multi-role dashboard)
            String roleName = user.getRoleName();
            System.out.println("User logged in successfully: " + user.getUsername() + " (" + roleName + ")");
            
            // For now, all users go to the general dashboard
            response.sendRedirect("dashboard.jsp"); 
            
        } else {
            // 5. Authentication failed: Set error message and forward back to login page
            System.out.println("Login failed for user: " + email);
            request.setAttribute("error", "Invalid Email or Password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
	}
    
    /**
     * Handles HTTP GET requests, typically used to display the login form.
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Check if user is already logged in, redirect them if true
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("currentUser") != null) {
            response.sendRedirect("dashboard.jsp");
            return;
        }
        
        // Otherwise, forward to the login JSP page
        request.getRequestDispatcher("login.jsp").forward(request, response);
    }
}