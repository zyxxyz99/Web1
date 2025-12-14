<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession" %>
<%
    // Get the current session by using a non-conflicting variable name.
    // 'session' is an implicit JSP object, so we rename the local variable to 'currentSession'.
    HttpSession currentSession = request.getSession(false); 
    
    // Check if a session exists and invalidate it to log the user out
    if (currentSession != null) {
        // Remove the stored user object
        currentSession.removeAttribute("currentUser");
        
        // Invalidate the session entirely (logs out the user)
        currentSession.invalidate();
    }

    // Redirect the user to the login servlet alias for consistent navigation
    response.sendRedirect("login");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Logging Out...</title>
</head>
<body>
    <!-- This body content won't be seen as the user is immediately redirected -->
    <p>You have been logged out. Redirecting...</p>
</body>
</html>