package ocms.web;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import ocms.web.CourseDAO;
import ocms.web.UserDAO;
import ocms.web.Course;
import ocms.web.User; 

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * Servlet implementation for Course Management (CRUD).
 * Accessible via /CourseServlet
 */
@WebServlet("/CourseServlet")
public class CourseServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CourseDAO courseDAO;
    private UserDAO userDAO;

    public void init() {
        courseDAO = new CourseDAO();
        userDAO = new UserDAO(); 
    }

    /**
     * Handles all GET requests (list, show form, delete).
     */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // 1. Authorization Check: Only Admin (Role ID 1) and Teacher (Role ID 2) can access the page.
        if (currentUser == null || (currentUser.getRoleId() != 1 && currentUser.getRoleId() != 2)) {
            response.sendRedirect("login.jsp"); 
            return;
        }

        String action = request.getParameter("action");
        if (action == null) {
            action = "list"; // Default action
        }

        try {
            switch (action) {
                case "new":
                    // Authorization Check: Only Admin can access the new form
                    if (currentUser.getRoleId() != 1) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied. Only Admin can create courses.");
                        return;
                    }
                    showNewForm(request, response);
                    break;
                case "delete":
                    // Authorization Check: Only Admin can delete
                    if (currentUser.getRoleId() != 1) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied. Only Admin can delete courses.");
                        return;
                    }
                    deleteCourse(request, response);
                    break;
                case "edit":
                    // Authorization Check: Only Admin can access the edit form
                    if (currentUser.getRoleId() != 1) {
                        response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied. Only Admin can edit courses.");
                        return;
                    }
                    showEditForm(request, response);
                    break;
                case "list":
                default:
                    listCourse(request, response);
                    break;
            }
        } catch (SQLException ex) {
            throw new ServletException(ex);
        }
    }

    /**
     * Handles all POST requests (insert, update).
     */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        User currentUser = (User) session.getAttribute("currentUser");

        // Authorization Check: Only Admin can perform INSERT or UPDATE
        if (currentUser == null || currentUser.getRoleId() != 1) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied. Only Admin can modify courses.");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "insert":
                    insertCourse(request, response);
                    break;
                case "update":
                    updateCourse(request, response);
                    break;
                default:
                    doGet(request, response); 
                    break;
            }
        } catch (SQLException ex) {
             throw new ServletException(ex);
        }
    }
    
    // --- Helper Methods (CRUD Logic) ---
    
    private void listCourse(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException, ServletException {
        
        List<Course> listCourse = courseDAO.selectAllCourses();
        request.setAttribute("listCourse", listCourse);
        RequestDispatcher dispatcher = request.getRequestDispatcher("course-list.jsp");
        dispatcher.forward(request, response);
    }

    private void showNewForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException, SQLException {
        // Fetch all teachers to populate the dropdown for assignment
        List<User> listTeachers = userDAO.selectUsersByRoleId(2); // Assuming 2 is the RoleId for Teacher
        request.setAttribute("listTeachers", listTeachers);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("course-form.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        
        // Fetch all teachers to populate the dropdown for assignment
        List<User> listTeachers = userDAO.selectUsersByRoleId(2); // Assuming 2 is the RoleId for Teacher
        request.setAttribute("listTeachers", listTeachers);

        Course existingCourse = courseDAO.selectCourse(id);
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("course-form.jsp");
        request.setAttribute("course", existingCourse);
        dispatcher.forward(request, response);
    }

    private void insertCourse(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        String code = request.getParameter("code");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        
        // Admin assigns the teacher via a form field now
        int teacherId = Integer.parseInt(request.getParameter("teacherId")); 
        
        Course newCourse = new Course(code, title, description, teacherId);
        
        if (courseDAO.insertCourse(newCourse)) {
            request.getSession().setAttribute("message", "Course added successfully!");
        } else {
             request.getSession().setAttribute("message", "Error adding course (Check if course code is unique).");
        }
        
        response.sendRedirect("CourseServlet?action=list");
    }

    private void updateCourse(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        int id = Integer.parseInt(request.getParameter("id"));
        String code = request.getParameter("code");
        String title = request.getParameter("title");
        String description = request.getParameter("description");
        
        // Admin updates the assigned teacher via a form field
        int teacherId = Integer.parseInt(request.getParameter("teacherId")); 

        Course course = new Course(id, code, title, description, teacherId);
        
        if (courseDAO.updateCourse(course)) {
            request.getSession().setAttribute("message", "Course updated successfully!");
        } else {
             request.getSession().setAttribute("message", "Error updating course (Check if course code is unique).");
        }
        
        response.sendRedirect("CourseServlet?action=list");
    }

    /**
     * Deletes a course based on the course ID provided in the request parameters.
     */
    private void deleteCourse(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, IOException {
        
        int id = Integer.parseInt(request.getParameter("id"));
        
        if (courseDAO.deleteCourse(id)) {
            request.getSession().setAttribute("message", "Course ID " + id + " deleted successfully!");
        } else {
             request.getSession().setAttribute("message", "Error deleting course ID " + id + ".");
        }
        
        response.sendRedirect("CourseServlet?action=list");
    }
}