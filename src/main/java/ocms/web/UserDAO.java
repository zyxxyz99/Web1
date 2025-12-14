package ocms.web;

import ocms.web.User;
import ocms.web.DBUtil; 

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * UserDAO (Data Access Object) handles all database operations related to the User entity,
 * including authentication, registration, role-based retrieval, and administrative actions.
 */
public class UserDAO {

    // SQL Statements
    private static final String AUTHENTICATE_USER_SQL = 
            "SELECT u.user_id, u.username, u.email, u.full_name, u.role_id, u.reg_id, r.role_name " +
            "FROM users u JOIN roles r ON u.role_id = r.role_id " +
            "WHERE u.email = ? AND u.password_hash = ?"; 

    private static final String SELECT_USERS_BY_ROLE_ID_SQL =
            "SELECT u.user_id, u.username, u.email, u.full_name, u.role_id, r.role_name, u.reg_id " + // Added space
            "FROM users u JOIN roles r ON u.role_id = r.role_id " +
            "WHERE u.role_id = ?";
            
    // *** FIX: Added u.reg_id to the SELECT clause ***
    private static final String SELECT_ALL_USERS_SQL = 
            "SELECT u.user_id, u.username, u.email, u.full_name, u.role_id, r.role_name, u.reg_id " + 
            "FROM users u JOIN roles r ON u.role_id = r.role_id " +
            "ORDER BY u.role_id, u.user_id";

    private static final String UPDATE_USER_ROLE_SQL = 
            "UPDATE users SET role_id = ? WHERE user_id = ?";

    // UPDATED SQL: INSERT_USER_SQL now includes reg_id
    private static final String INSERT_USER_SQL = 
            "INSERT INTO users (username, email, password_hash, full_name, role_id, reg_id) VALUES (?, ?, ?, ?, ?, ?)"; 
            
    private static final String SELECT_ROLE_ID_BY_NAME_SQL =
            "SELECT role_id FROM roles WHERE role_name = ?";
    
    private static final String CHECK_DUPLICATE_USER_SQL =
            "SELECT COUNT(*) FROM users WHERE username = ? OR email = ?";

    // NEW SQL: Check for duplicate Registration ID
    private static final String CHECK_DUPLICATE_REG_ID_SQL =
            "SELECT COUNT(*) FROM users WHERE reg_id = ?";
            
    // SQL for Deleting a User
    private static final String DELETE_USER_SQL = 
            "DELETE FROM users WHERE user_id = ?";
            
    // SQL for dependencies when deleting a user (cleans up enrollments and orphaned courses)
    private static final String UPDATE_COURSES_TEACHER_SQL =
            "UPDATE courses SET teacher_id = NULL WHERE teacher_id = ?";

    // SQL for dependencies when promoting a user (NEW/UPDATED for promotion logic)
    private static final String SELECT_USER_ROLE_BY_ID_SQL =
            "SELECT role_id FROM users WHERE user_id = ?";
            
    private static final String SELECT_COURSES_BY_TEACHER_SQL =
            "SELECT course_id FROM courses WHERE teacher_id = ?";
    
    // Deletes enrollments for a specific student (used for student promotion or deletion)
    private static final String DELETE_ENROLLMENTS_BY_STUDENT_SQL =
            "DELETE FROM enrollments WHERE student_id = ?";
            
    // Deletes enrollments for courses (used for teacher promotion)
    private static final String DELETE_ENROLLMENTS_BY_COURSE_SQL =
            "DELETE FROM enrollments WHERE course_id = ?";
            
    // Deletes courses taught by a specific teacher (used for teacher promotion)
    private static final String DELETE_COURSES_BY_TEACHER_SQL =
            "DELETE FROM courses WHERE teacher_id = ?";

    // NEW SQL: Count users by role ID
    private static final String COUNT_USERS_BY_ROLE_SQL = "SELECT COUNT(*) FROM users WHERE role_id = ?";


    // Helper method to map a ResultSet row to a User object.
    private User mapResultSetToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setFullName(rs.getString("full_name"));
        user.setRoleId(rs.getInt("role_id"));
        user.setRoleName(rs.getString("role_name"));
        
        // Load reg_id if it exists in the ResultSet. Not all SELECT statements include it.
        try {
            user.setRegId(rs.getString("reg_id"));
        } catch (SQLException ignored) {
            // Ignore if the column doesn't exist in the current query's result set.
        }

        return user;
    }

    /**
     * Retrieves the current role ID for a given user.
     */
    private int getCurrentRoleId(Connection connection, int userId) throws SQLException {
        try (PreparedStatement statement = connection.prepareStatement(SELECT_USER_ROLE_BY_ID_SQL)) {
            statement.setInt(1, userId);
            try (ResultSet rs = statement.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("role_id");
                }
            }
        }
        return -1; // Should not happen if user exists
    }
    
    /**
     * Authenticates a user based on email and password.
     */
    public User authenticateUser(String email, String password) {
        User user = null;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(AUTHENTICATE_USER_SQL)) {
            
            preparedStatement.setString(1, email);
            preparedStatement.setString(2, password);

            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                user = mapResultSetToUser(rs);
            }
        } catch (SQLException e) {
            System.err.println("Database error during authentication: " + e.getMessage());
            e.printStackTrace();
        }
        return user;
    }

    /**
     * Retrieves the Role ID (PK) from the database based on the Role Name.
     */
    public int selectRoleIdByName(String roleName) {
        int roleId = 0; // 0 indicates role not found or error
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ROLE_ID_BY_NAME_SQL)) {
            
            preparedStatement.setString(1, roleName);
            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next()) {
                roleId = rs.getInt("role_id");
            }
        } catch (SQLException e) {
            System.err.println("Error selecting role ID by name: " + e.getMessage());
            e.printStackTrace();
        }
        return roleId;
    }

    /**
     * Counts the total number of users associated with a specific role ID.
     */
    public int countUsersByRole(int roleId) {
        int count = 0;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(COUNT_USERS_BY_ROLE_SQL)) {
            
            preparedStatement.setInt(1, roleId);
            try (ResultSet rs = preparedStatement.executeQuery()) {
                if (rs.next()) {
                    count = rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error counting users by role: " + e.getMessage());
            e.printStackTrace();
        }
        return count;
    }
    
    /**
     * Checks if a user with the given username or email already exists.
     */
    public boolean isUserDuplicate(String username, String email) {
        boolean duplicate = false;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(CHECK_DUPLICATE_USER_SQL)) {
            
            preparedStatement.setString(1, username);
            preparedStatement.setString(2, email);
            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                duplicate = true;
            }
        } catch (SQLException e) {
            System.err.println("Error checking for duplicate user: " + e.getMessage());
            e.printStackTrace();
        }
        return duplicate;
    }

    /**
     * Checks if a user with the given registration ID already exists.
     */
    public boolean isRegIdDuplicate(String regId) {
        boolean duplicate = false;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(CHECK_DUPLICATE_REG_ID_SQL)) {
            
            preparedStatement.setString(1, regId);
            ResultSet rs = preparedStatement.executeQuery();

            if (rs.next() && rs.getInt(1) > 0) {
                duplicate = true;
            }
        } catch (SQLException e) {
            System.err.println("Error checking for duplicate registration ID: " + e.getMessage());
            e.printStackTrace();
        }
        return duplicate;
    }

    /**
     * Retrieves a list of users based on their role ID (e.g., all Teachers).
     */
    public List<User> selectUsersByRoleId(int roleId) {
        List<User> users = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USERS_BY_ROLE_ID_SQL)) {
            
            preparedStatement.setInt(1, roleId);
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error selecting users by role ID: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }
    
    /**
     * Retrieves a list of ALL users.
     */
    public List<User> selectAllUsers() {
        List<User> users = new ArrayList<>();
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_USERS_SQL)) {
            
            ResultSet rs = preparedStatement.executeQuery();

            while (rs.next()) {
                users.add(mapResultSetToUser(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error selecting all users: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    /**
     * Updates the role_id for a specific user.
     */
    public boolean updateUserRole(int userId, int newRoleId) throws SQLException {
        Connection connection = null;
        boolean rowUpdated = false;

        final int ADMIN_ROLE = 1;
        final int TEACHER_ROLE = 2;
        final int STUDENT_ROLE = 3;

        try {
            connection = DBUtil.getConnection();
            connection.setAutoCommit(false);

            int currentRoleId = getCurrentRoleId(connection, userId);
            
            if (newRoleId == ADMIN_ROLE && currentRoleId != ADMIN_ROLE) {
                
                if (currentRoleId == STUDENT_ROLE) {
                    try (PreparedStatement deleteEnrollments = connection.prepareStatement(DELETE_ENROLLMENTS_BY_STUDENT_SQL)) {
                        deleteEnrollments.setInt(1, userId);
                        deleteEnrollments.executeUpdate();
                    }
                    
                } else if (currentRoleId == TEACHER_ROLE) {

                    List<Integer> courseIdsToDelete = new ArrayList<>();
                    try (PreparedStatement selectCourses = connection.prepareStatement(SELECT_COURSES_BY_TEACHER_SQL)) {
                        selectCourses.setInt(1, userId);
                        try (ResultSet rs = selectCourses.executeQuery()) {
                            while (rs.next()) {
                                courseIdsToDelete.add(rs.getInt("course_id"));
                            }
                        }
                    }
                    
                    try (PreparedStatement deleteEnrollments = connection.prepareStatement(DELETE_ENROLLMENTS_BY_COURSE_SQL)) {
                        for (int courseId : courseIdsToDelete) {
                            deleteEnrollments.setInt(1, courseId);
                            deleteEnrollments.addBatch();
                        }
                        deleteEnrollments.executeBatch();
                    }
                    
                    try (PreparedStatement deleteCourses = connection.prepareStatement(DELETE_COURSES_BY_TEACHER_SQL)) {
                        deleteCourses.setInt(1, userId);
                        deleteCourses.executeUpdate();
                    }
                }
            }

            try (PreparedStatement statement = connection.prepareStatement(UPDATE_USER_ROLE_SQL)) {
                statement.setInt(1, newRoleId);
                statement.setInt(2, userId);
                rowUpdated = statement.executeUpdate() > 0;
            }

            connection.commit();
        } catch (SQLException e) {
            if (connection != null) {
                try { connection.rollback(); } catch (SQLException ignored) {}
            }
            throw e; 
        } finally {
            if (connection != null) {
                connection.setAutoCommit(true);
                DBUtil.closeConnection(connection);
            }
        }
        return rowUpdated;
    }

    /**
     * Inserts a new user record into the database (User Registration).
     */
    public boolean registerUser(User user) {
        boolean rowInserted = false;
        try (Connection connection = DBUtil.getConnection();
             PreparedStatement preparedStatement = connection.prepareStatement(INSERT_USER_SQL)) {
            
            preparedStatement.setString(1, user.getUsername());
            preparedStatement.setString(2, user.getEmail());
            preparedStatement.setString(3, user.getPassword());
            preparedStatement.setString(4, user.getFullName());
            preparedStatement.setInt(5, user.getRoleId());
            preparedStatement.setString(6, user.getRegId()); 
            
            rowInserted = preparedStatement.executeUpdate() > 0;
            
        } catch (SQLException e) {
            System.err.println("Database error during user registration: " + e.getMessage());
            e.printStackTrace();
        }
        return rowInserted;
    }
    
    /**
     * Deletes a user from the database.
     */
    public boolean deleteUser(int userId) throws SQLException {
        Connection connection = null;
        boolean userDeleted = false;
        
        try {
            connection = DBUtil.getConnection();
            connection.setAutoCommit(false);

            try (PreparedStatement deleteEnrollments = connection.prepareStatement(DELETE_ENROLLMENTS_BY_STUDENT_SQL)) {
                deleteEnrollments.setInt(1, userId);
                deleteEnrollments.executeUpdate();
            }

            try (PreparedStatement updateCourses = connection.prepareStatement(UPDATE_COURSES_TEACHER_SQL)) {
                updateCourses.setInt(1, userId);
                updateCourses.executeUpdate();
            }

            try (PreparedStatement deleteUser = connection.prepareStatement(DELETE_USER_SQL)) {
                deleteUser.setInt(1, userId);
                userDeleted = deleteUser.executeUpdate() > 0;
            }
            
            connection.commit();
            
        } catch (SQLException e) {
            if (connection != null) {
                try { connection.rollback(); } catch (SQLException ignored) {}
            }
            throw e; 
        } finally {
            if (connection != null) {
                connection.setAutoCommit(true);
                DBUtil.closeConnection(connection);
            }
        }
        return userDeleted;
    }
}