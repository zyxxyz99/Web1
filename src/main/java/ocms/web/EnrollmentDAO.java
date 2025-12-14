package ocms.web;

import ocms.web.Course;
import ocms.web.User; 
import ocms.web.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * EnrollmentDAO manages student enrollment and unenrollment from courses.
 * Uses the 'enrollments' table with fields: 
 * (enrollment_id, student_id, course_id, enrollment_date)
 */
public class EnrollmentDAO {

    // SQL to insert a new enrollment record. 
    private static final String INSERT_ENROLLMENT_SQL = 
            "INSERT INTO enrollments (student_id, course_id) VALUES (?, ?)";
    
    // SQL to delete an enrollment record (unenrollment) based on the unique pairing.
    private static final String DELETE_ENROLLMENT_SQL = 
            "DELETE FROM enrollments WHERE student_id = ? AND course_id = ?";

    // SQL to check if a student is already enrolled in a course
    private static final String IS_ENROLLED_SQL = 
            "SELECT COUNT(*) FROM enrollments WHERE student_id = ? AND course_id = ?";

    // SQL to retrieve all courses a student is enrolled in
    private static final String SELECT_ENROLLED_COURSES_SQL =
            "SELECT c.course_id, c.course_code, c.course_title, c.course_description, c.teacher_id, u.full_name AS teacher_name " +
            "FROM courses c " +
            "JOIN enrollments e ON c.course_id = e.course_id " +
            "JOIN users u ON c.teacher_id = u.user_id " +
            "WHERE e.student_id = ?";
            
    // SQL to retrieve all courses a student is NOT enrolled in (available for enrollment)
    private static final String SELECT_AVAILABLE_COURSES_SQL =
            "SELECT c.course_id, c.course_code, c.course_title, c.course_description, c.teacher_id, u.full_name AS teacher_name " +
            "FROM courses c " +
            "JOIN users u ON c.teacher_id = u.user_id " +
            "WHERE c.course_id NOT IN (" +
            "    SELECT course_id FROM enrollments WHERE student_id = ?" +
            ")";
            
    // ⭐ FIX: Added u.reg_id to the SELECT clause to fetch registration number. ⭐
    private static final String SELECT_ENROLLED_STUDENTS_SQL =
            "SELECT u.user_id, u.full_name, u.email, u.role_id, u.reg_id, e.enrollment_date " +
            "FROM users u " +
            "JOIN enrollments e ON u.user_id = e.student_id " +
            "WHERE e.course_id = ? AND u.role_id = 3"; 

    /**
     * Helper method to map a ResultSet row to a Course object, including teacher name.
     */
    private Course mapResultSetToCourse(ResultSet rs) throws SQLException {
        Course course = new Course(
            rs.getInt("course_id"),
            rs.getString("course_code"), 
            rs.getString("course_title"), 
            rs.getString("course_description"), 
            rs.getInt("teacher_id")
        );
        
        course.setTeacherName(rs.getString("teacher_name")); 
        
        return course;
    }
    
    /**
     * Helper method to map a ResultSet row to a User object (used for students).
     * Assumes User model has setters for ID, name, email, roleId.
     */
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        // Assuming a User model with default constructor and setters
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setRoleId(rs.getInt("role_id"));
        
        // ⭐ FIX: Extract reg_id now that it is included in the SELECT query. ⭐
        try {
            user.setRegId(rs.getString("reg_id"));
        } catch (SQLException ignored) {
            // This is defensive; should not happen if the correct SQL is used.
        }
        
        return user;
    }

    /**
     * Enroll a student into a course.
     */
    public boolean enrollStudent(int studentId, int courseId) throws SQLException {
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_ENROLLMENT_SQL)) {
            
            preparedStatement.setInt(1, studentId);
            preparedStatement.setInt(2, courseId);
            
            return preparedStatement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error enrolling student: " + e.getMessage());
            throw e;
        }
    }
    
    /**
     * Unenroll a student from a course.
     */
    public boolean unenrollStudent(int studentId, int courseId) throws SQLException {
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(DELETE_ENROLLMENT_SQL)) {
            
            preparedStatement.setInt(1, studentId);
            preparedStatement.setInt(2, courseId);
            
            return preparedStatement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Error unenrolling student: " + e.getMessage());
            throw e;
        }
    }

    /**
     * Checks if a student is enrolled in a specific course.
     */
    public boolean isStudentEnrolled(int studentId, int courseId) {
        boolean enrolled = false;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(IS_ENROLLED_SQL)) {
            
            preparedStatement.setInt(1, studentId);
            preparedStatement.setInt(2, courseId);
            
            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next() && rs.getInt(1) > 0) {
                    enrolled = true;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking enrollment status: " + e.getMessage());
            e.printStackTrace();
        }
        return enrolled;
    }

    /**
     * Retrieves all courses a specific student is enrolled in.
     */
    public List<Course> selectEnrolledCourses(int studentId) {
        List<Course> courses = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ENROLLED_COURSES_SQL)) {
            
            preparedStatement.setInt(1, studentId);
            
            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    courses.add(mapResultSetToCourse(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error selecting enrolled courses: " + e.getMessage());
            e.printStackTrace();
        }
        return courses;
    }
    
    /**
     * Retrieves all courses a specific student is NOT enrolled in (available courses).
     */
    public List<Course> selectAvailableCourses(int studentId) {
        List<Course> courses = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_AVAILABLE_COURSES_SQL)) {
            
            preparedStatement.setInt(1, studentId);
            
            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    courses.add(mapResultSetToCourse(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error selecting available courses: " + e.getMessage());
            e.printStackTrace();
        }
        return courses;
    }
    
    /**
     * Retrieves a list of all students currently enrolled in a specific course.
     * * @param courseId The ID of the course.
     * @return A list of User objects (students) enrolled in the course.
     */
    public List<User> selectEnrolledStudents(int courseId) {
        List<User> students = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ENROLLED_STUDENTS_SQL)) {
            
            preparedStatement.setInt(1, courseId);
            
            try (ResultSet rs = preparedStatement.executeQuery()) {
                while (rs.next()) {
                    // Uses the updated mapResultSetToUser which now extracts reg_id
                    students.add(mapResultSetToUser(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error selecting enrolled students for course ID " + courseId + ": " + e.getMessage());
            e.printStackTrace();
        }
        return students;
    }
}