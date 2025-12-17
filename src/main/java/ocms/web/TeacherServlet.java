package ocms.web;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import ocms.web.CourseDAO;
import ocms.web.EnrollmentDAO;
import ocms.web.Course;
import ocms.web.User;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet implementation for Teacher-specific tasks: Course and Student management.
 */
@WebServlet("/TeacherServlet")
public class TeacherServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CourseDAO courseDAO;
    private EnrollmentDAO enrollmentDAO;
    
    // Teacher role ID is assumed to be 2
    private final int TEACHER_ROLE_ID = 2; 

    public void init() {
        courseDAO = new CourseDAO();
        enrollmentDAO = new EnrollmentDAO();
    }
    
    /**
     * General authentication check for Teacher access.
     */
    private User authenticateTeacher(HttpServletRequest request, HttpServletResponse response) throws IOException {
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Check 1: User is logged in (currentUser is not null)
        // Check 2: User's role ID matches the Teacher role ID (2)
        if (currentUser == null || currentUser.getRoleId() != TEACHER_ROLE_ID) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied. Only Teachers can access course management features.");
            return null;
        }
        return currentUser;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        User teacher = authenticateTeacher(request, response);
        if (teacher == null) {
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "manageCourses"; 
        }

        try {
            switch (action) {
                case "manageCourses":
                    listTaughtCourses(request, response, teacher.getUserId());
                    break;
                case "viewStudents":
                    viewEnrolledStudents(request, response);
                    break;
                default:
                    listTaughtCourses(request, response, teacher.getUserId());
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    /**
     * Lists all courses assigned to the logged-in teacher.
     */
    private void listTaughtCourses(HttpServletRequest request, HttpServletResponse response, int teacherId)
            throws SQLException, IOException, ServletException {
        
        List<Course> listCourses = courseDAO.selectCoursesByTeacher(teacherId);
        request.setAttribute("listCourses", listCourses);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("teacher-manage-courses.jsp");
        dispatcher.forward(request, response);
    }
    
    /**
     * Shows the list of students enrolled in a specific course taught by the teacher.
     */
    private void viewEnrolledStudents(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        
        int courseId;
        String courseTitle = request.getParameter("courseTitle"); // 🌟 NEW: Get title from request

        try {
            courseId = Integer.parseInt(request.getParameter("courseId"));
        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing or invalid course ID.");
            return;
        }
        
        List<User> listStudents = enrollmentDAO.selectEnrolledStudents(courseId);
        
        // Pass data to the JSP
        request.setAttribute("listStudents", listStudents);
        request.setAttribute("courseId", courseId);
        request.setAttribute("courseTitle", courseTitle); // 🌟 NEW: Pass title to JSP
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("teacher-view-students.jsp");
        dispatcher.forward(request, response);
    }
}