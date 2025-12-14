package ocms.web;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Servlet implementation class LogoutServlet
 * Handles user logout by invalidating the current session.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * Handles HTTP GET requests for logging out.
	 * This is typically linked from a "Logout" button on the dashboard.
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    
	    // Retrieve the existing session, but don't create a new one if it doesn't exist (false)
		HttpSession session = request.getSession(false); 
		
		if (session != null) {
		    // Invalidate the session, which removes all session attributes (including "currentUser")
		    session.invalidate();
		    System.out.println("User session invalidated successfully.");
		}
		
		// Redirect the user back to the login page
		response.sendRedirect("login");
	}
	
	/**
	 * Optionally handle POST, but GET is standard for logout links/buttons.
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
		doGet(request, response);
	}
}