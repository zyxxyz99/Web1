package ocms.web;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ocms.web.EnrollmentDAO;
import ocms.web.Course;
import ocms.web.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet implementation for Student-specific tasks: Enrollment management.
 * * FIX: Ensure the annotation path matches the requested URL path.
 * The path is now set to "/StudentServlet" which corresponds to the URL
 * /OCMS/StudentServlet (where OCMS is the context root).
 */
@WebServlet("/StudentServlet")
public class StudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private EnrollmentDAO enrollmentDAO;
    private final int STUDENT_ROLE_ID = 3;

    public void init() {
        enrollmentDAO = new EnrollmentDAO();
    }
    
    /**
     * General authentication check for Student access.
     */
    private User authenticateStudent(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Check if user is logged in and is a Student (ID 3)
        if (currentUser == null || currentUser.getRoleId() != STUDENT_ROLE_ID) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied. Only Students can access enrollment features.");
            return null;
        }
        return currentUser;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User student = authenticateStudent(request, response);
        if (student == null) {
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "viewEnrolled"; 
        }

        try {
            switch (action) {
                case "enrollList":
                    listAvailableCourses(request, response, student.getUserId());
                    break;
                case "viewEnrolled":
                default:
                    listEnrolledCourses(request, response, student.getUserId());
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User student = authenticateStudent(request, response);
        if (student == null) {
            return;
        }

        String action = request.getParameter("action");
        
        try {
            if ("enroll".equals(action)) {
                enrollCourse(request, response, student.getUserId());
            } else if ("unenroll".equals(action)) {
                unenrollCourse(request, response, student.getUserId());
            } else {
                doGet(request, response); 
            }
        } catch (SQLException ex) {
             throw new ServletException(ex);
        }
    }

    /**
     * Fetches courses available for enrollment (not currently enrolled).
     */
    private void listAvailableCourses(HttpServletRequest request, HttpServletResponse response, int studentId)
            throws SQLException, IOException, ServletException {
        
        List<Course> listCourses = enrollmentDAO.selectAvailableCourses(studentId);
        request.setAttribute("listCourses", listCourses);
        request.setAttribute("listType", "Available Courses");
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("enroll-course.jsp");
        dispatcher.forward(request, response);
    }

    /**
     * Fetches courses the student is currently enrolled in.
     */
    private void listEnrolledCourses(HttpServletRequest request, HttpServletResponse response, int studentId)
            throws SQLException, IOException, ServletException {
        
        List<Course> listCourses = enrollmentDAO.selectEnrolledCourses(studentId);
        request.setAttribute("listCourses", listCourses);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("enrolled-courses.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Processes the enrollment request.
     */
    private void enrollCourse(HttpServletRequest request, HttpServletResponse response, int studentId)
            throws SQLException, IOException {
        
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        HttpSession session = request.getSession();
        
        if (enrollmentDAO.enrollStudent(studentId, courseId)) {
            session.setAttribute("message", "Successfully enrolled in course ID " + courseId + "!");
        } else {
            session.setAttribute("message", "Error enrolling in course ID " + courseId + ".");
        }
        
        response.sendRedirect("StudentServlet?action=enrollList");
    }

    /**
     * Processes the unenrollment request.
     */
    private void unenrollCourse(HttpServletRequest request, HttpServletResponse response, int studentId)
            throws SQLException, IOException {
        
        int courseId = Integer.parseInt(request.getParameter("courseId"));
        HttpSession session = request.getSession();
        
        if (enrollmentDAO.unenrollStudent(studentId, courseId)) {
            session.setAttribute("message", "Successfully unenrolled from course ID " + courseId + ".");
        } else {
            session.setAttribute("message", "Error unenrolling from course ID " + courseId + ".");
        }
        
        response.sendRedirect("StudentServlet?action=viewEnrolled");
    }
}