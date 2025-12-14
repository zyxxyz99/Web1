package ocms.web;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

// Import your DAO classes to fetch counts
import ocms.web.CourseDAO;
import ocms.web.UserDAO;

/**
 * Servlet responsible for handling the application's root URL request.
 * It fetches the total counts for courses, students, and teachers to display
 * on the public landing page (index.jsp).
 */
public class HomeServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    // Assuming these constants exist or are standard in your application:
    private static final int ROLE_STUDENT = 3; 
    private static final int ROLE_TEACHER = 2; 

    private CourseDAO courseDAO;
    private UserDAO userDAO;

    public void init() {
        // Initialize DAOs here
        this.courseDAO = new CourseDAO();
        this.userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        try {
            // 1. Fetch system statistics (counts)
            
            // Get total courses count
            int totalCourses = courseDAO.countAllCourses();

            // Get total students count (assuming roleId 3)
            int totalStudents = userDAO.countUsersByRole(ROLE_STUDENT); 

            // Get total teachers count (assuming roleId 2)
            int totalTeachers = userDAO.countUsersByRole(ROLE_TEACHER); 

            // 2. Set the data as request attributes for index.jsp
            request.setAttribute("totalCourses", totalCourses);
            request.setAttribute("totalStudents", totalStudents);
            request.setAttribute("totalTeachers", totalTeachers);

            // 3. Forward to the public landing page
            request.getRequestDispatcher("index.jsp").forward(request, response);

        } catch (Exception e) {
            // Log the error and display a fallback page or message
            System.err.println("Error fetching system statistics: " + e.getMessage());
            e.printStackTrace();
            
            // Forward to the index page even on error, to avoid a blank screen, 
            // the JSP will display default '0' counts if attributes are missing.
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}