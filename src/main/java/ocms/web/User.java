package ocms.web;

import java.io.Serializable;

/**
 * User class represents a user entity in the application (Admin, Teacher, Student).
 * Implements Serializable for potential use in sessions.
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;

    private int userId;
    private String username;
    private String email;
    // Password is only used temporarily during registration/login check, not stored as field.
    private String password; 
    private String fullName;
    private int roleId;
    private String roleName;

    // The primary field storing the Registration ID from the database.
    private String regId; 

    // Constructors
    public User() {
    }

    public User(String username, String email, String password, String fullName, int roleId, String regId) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.fullName = fullName;
        this.roleId = roleId;
        this.regId = regId;
    }

    // --- Getters and Setters ---

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getRoleName() {
        return roleName;
    }

    public void setRoleName(String roleName) {
        this.roleName = roleName;
    }

    // --- Registration ID Getters/Setters ---

    /**
     * Getter for the internal 'regId' field (matches the database column name).
     */
    public String getRegId() {
        return regId;
    }

    /**
     * Setter for the internal 'regId' field (matches the database column name).
     */
    public void setRegId(String regId) {
        this.regId = regId;
    }

    /**
     * Alias Getter for JSP/EL access. 
     * Allows JSP to use the property name 'registrationId' (e.g., ${user.registrationId}).
     */
    public String getRegistrationId() {
        return this.regId;
    }

    /**
     * Alias Setter for symmetry, though usually not strictly necessary if setting happens internally.
     */
    public void setRegistrationId(String registrationId) {
        this.regId = registrationId;
    }
}