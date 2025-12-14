package ocms.web;

import ocms.web.Course; // Added import
import ocms.web.DBUtil; // Added import

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * CourseDAO (Data Access Object) handles all database operations related to the Course entity.
 */
public class CourseDAO {

    // SQL Statements
    private static final String INSERT_COURSE_SQL = 
            "INSERT INTO courses (course_code, course_title, course_description, teacher_id) VALUES (?, ?, ?, ?)";
    private static final String SELECT_COURSE_BY_ID_SQL = 
            "SELECT c.course_id, c.course_code, c.course_title, c.course_description, c.teacher_id, u.full_name as teacher_name " +
            "FROM courses c JOIN users u ON c.teacher_id = u.user_id WHERE c.course_id = ?";
    private static final String SELECT_ALL_COURSES_SQL = 
            "SELECT c.course_id, c.course_code, c.course_title, c.course_description, c.teacher_id, u.full_name as teacher_name " +
            "FROM courses c JOIN users u ON c.teacher_id = u.user_id ORDER BY c.course_id DESC";
    private static final String UPDATE_COURSE_SQL = 
            "UPDATE courses SET course_code = ?, course_title = ?, course_description = ?, teacher_id = ? WHERE course_id = ?";
    
    // SQL to select all courses taught by a specific teacher
    private static final String SELECT_COURSES_BY_TEACHER_SQL =
            "SELECT c.course_id, c.course_code, c.course_title, c.course_description, c.teacher_id, u.full_name as teacher_name " +
            "FROM courses c JOIN users u ON c.teacher_id = u.user_id WHERE c.teacher_id = ?";
            
    // NEW SQL: Delete enrollments related to a course
    private static final String DELETE_ENROLLMENTS_BY_COURSE_SQL =
            "DELETE FROM enrollments WHERE course_id = ?";
            
    // Original SQL for deleting the course
    private static final String DELETE_COURSE_SQL = 
            "DELETE FROM courses WHERE course_id = ?";
            
    // NEW SQL: Check if a course with the same code or title already exists
    private static final String CHECK_EXISTENCE_SQL =
            "SELECT COUNT(*) FROM courses WHERE course_code = ? OR course_title = ?";

    // NEW SQL: Count all courses
    private static final String COUNT_ALL_COURSES_SQL = "SELECT COUNT(*) FROM courses";


    /**
     * Helper method to map a ResultSet row to a Course object.
     */
    private Course mapResultSetToCourse(ResultSet rs) throws SQLException {
        Course course = new Course();
        course.setCourseId(rs.getInt("course_id"));
        course.setCourseCode(rs.getString("course_code"));
        course.setCourseTitle(rs.getString("course_title"));
        course.setCourseDescription(rs.getString("course_description"));
        course.setTeacherId(rs.getInt("teacher_id"));
        // The join ensures we can set the teacher's name as well
        course.setTeacherName(rs.getString("teacher_name")); 
        return course;
    }

    /**
     * Checks if a course with the given code or title already exists in the database.
     * @param code The course code to check.
     * @param title The course title to check.
     * @return true if a matching course exists, false otherwise.
     */
    private boolean isCourseCodeOrTitleExists(String code, String title) {
        boolean exists = false;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(CHECK_EXISTENCE_SQL)) {
            
            preparedStatement.setString(1, code);
            preparedStatement.setString(2, title);
            
            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    exists = rs.getInt(1) > 0;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error checking course existence: " + e.getMessage());
            e.printStackTrace();
            // In case of error, default to true to prevent accidental duplication
            exists = true; 
        }
        return exists;
    }

    /**
     * Inserts a new course into the database.
     */
    public boolean insertCourse(Course course) {
        System.out.println(INSERT_COURSE_SQL);
        boolean rowInserted = false;
        
        // 1. Check for uniqueness before inserting
        if (isCourseCodeOrTitleExists(course.getCourseCode(), course.getCourseTitle())) {
            System.err.println("Course insertion blocked: Course code or title already exists.");
            // Returning false indicates failure due to duplication/validation
            return false; 
        }

        // 2. Proceed with insertion if unique
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_COURSE_SQL)) {
            
            preparedStatement.setString(1, course.getCourseCode());
            preparedStatement.setString(2, course.getCourseTitle());
            preparedStatement.setString(3, course.getCourseDescription());
            preparedStatement.setInt(4, course.getTeacherId());
            
            rowInserted = preparedStatement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error inserting course: " + e.getMessage());
            e.printStackTrace();
        }
        return rowInserted;
    }

    /**
     * Retrieves a course by its ID.
     */
    public Course selectCourse(int courseId) {
        Course course = null;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_COURSE_BY_ID_SQL)) {
            
            preparedStatement.setInt(1, courseId);
            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                course = mapResultSetToCourse(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error selecting course by ID: " + e.getMessage());
            e.printStackTrace();
        }
        return course;
    }

    /**
     * Retrieves all courses from the database.
     */
    public List<Course> selectAllCourses() {
        List<Course> courses = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_COURSES_SQL);
             ResultSet rs = preparedStatement.executeQuery()) {

            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error selecting all courses: " + e.getMessage());
            e.printStackTrace();
        }
        return courses;
    }

    /**
     * Retrieves all courses taught by a specific teacher ID.
     */
    public List<Course> selectCoursesByTeacher(int teacherId) {
        List<Course> courses = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_COURSES_BY_TEACHER_SQL)) {
            
            preparedStatement.setInt(1, teacherId);
            ResultSet rs = preparedStatement.executeQuery();
            
            while (rs.next()) {
                courses.add(mapResultSetToCourse(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error selecting courses by teacher: " + e.getMessage());
            e.printStackTrace();
        }
        return courses;
    }

    /**
     * Updates an existing course record.
     */
    public boolean updateCourse(Course course) {
        boolean rowUpdated = false;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_COURSE_SQL)) {
            
            preparedStatement.setString(1, course.getCourseCode());
            preparedStatement.setString(2, course.getCourseTitle());
            preparedStatement.setString(3, course.getCourseDescription());
            preparedStatement.setInt(4, course.getTeacherId());
            preparedStatement.setInt(5, course.getCourseId());
            
            rowUpdated = preparedStatement.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating course: " + e.getMessage());
            e.printStackTrace();
        }
        return rowUpdated;
    }

    /**
     * Deletes a course by its ID.
     * This method first deletes all associated enrollment records to satisfy foreign key constraints.
     * The entire operation is wrapped in a transaction. (UPDATED LOGIC)
     * * @param courseId The ID of the course to delete.
     * @return true if the course was deleted, false otherwise.
     */
    public boolean deleteCourse(int courseId) throws SQLException {
        Connection connection = null;
        boolean courseDeleted = false;
        
        try {
            connection = DBUtil.getConnection();
            connection.setAutoCommit(false); // Start transaction

            // 1. Delete dependent enrollment records first
            try (PreparedStatement deleteEnrollments = connection.prepareStatement(DELETE_ENROLLMENTS_BY_COURSE_SQL)) {
                deleteEnrollments.setInt(1, courseId);
                int enrollmentCount = deleteEnrollments.executeUpdate();
                System.out.println("Deleted " + enrollmentCount + " enrollments for course ID: " + courseId);
            }

            // 2. Delete the course from the courses table
            try (PreparedStatement deleteCourse = connection.prepareStatement(DELETE_COURSE_SQL)) {
                deleteCourse.setInt(1, courseId);
                courseDeleted = deleteCourse.executeUpdate() > 0;
            }
            
            connection.commit(); // Commit transaction if both steps succeeded
            
        } catch (SQLException e) {
            if (connection != null) {
                try {
                    connection.rollback(); // Rollback on error
                    System.err.println("Transaction rolled back for course deletion.");
                } catch (SQLException rollbackEx) {
                    System.err.println("Error during course deletion rollback: " + rollbackEx.getMessage());
                }
            }
            System.err.println("Error deleting course and cleaning up dependencies: " + e.getMessage());
            throw e; // Re-throw the exception to notify the calling servlet/controller
            
        } finally {
            if (connection != null) {
                connection.setAutoCommit(true); // Reset auto-commit mode
                DBUtil.closeConnection(connection);
            }
        }
        return courseDeleted;
    }

    /**
     * Counts the total number of courses in the database.
     * This is required by the HomeServlet to display system statistics.
     */
    public int countAllCourses() {
        int count = 0;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(COUNT_ALL_COURSES_SQL);
             ResultSet rs = preparedStatement.executeQuery()) {

            if (rs.next()) {
                // Retrieves the count from the first column of the result set
                count = rs.getInt(1); 
            }
        } catch (SQLException e) {
            System.err.println("Error counting all courses: " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }
}