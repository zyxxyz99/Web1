<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="ocms.web.User" %>

<% 
    // Basic authorization check (assuming this page is primarily for students/roleId=3)
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null) {
        response.sendRedirect("login.jsp"); // Redirect to login if no session user
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enroll in New Courses | OCMS</title>
    <!-- Tailwind CSS CDN for styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f0f4f8; /* Consistent background */
        }
        
        /* Container styling matching the Admin template */
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
        }
        
        /* H1 styling matching the Admin template (Red border) */
        h1 {
            color: #2c3e50;
            border-bottom: 3px solid #e74c3c; /* Red border */
            padding-bottom: 10px;
            /* FIX: Increased bottom margin for greater separation from buttons */
            margin-bottom: 48px; 
        }

        /* Dashboard Button Styles (Prominent Blue background) */
        .dashboard-button {
            display: inline-block;
            background-color: #3498db; 
            color: white;
            padding: 10px 15px; /* Larger padding for prominence */
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            transition: background-color 0.3s;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .dashboard-button:hover {
            background-color: #2980b9;
        }
        
        /* Secondary Action Link (View Enrolled) */
        .secondary-link {
            background-color: #ecf0f1; /* Light gray */
            color: #34495e; /* Darker text */
            padding: 8px 12px;
            border-radius: 5px;
            font-weight: bold;
            transition: background-color 0.3s;
            text-decoration: none;
        }
        .secondary-link:hover {
            background-color: #bdc3c7;
        }

        /* Message Box Style */
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            background-color: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #4caf50;
        }
        
        /* Course Card Styles - Adjusted for visual separation */
        .course-card {
            background-color: white;
            padding: 1.5rem;
            border-left: 5px solid #3498db; /* Blue border to signify 'Available' */
            margin-bottom: 1rem;
            transition: transform 0.2s, box-shadow 0.3s;
            border-radius: 8px; 
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05); 
        }
        .course-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        }
    </style>
</head>

<body class="pt-20">

    <!-- Top Navigation Ribbon/Header (Fixed to the top) -->
    <header class="fixed top-0 left-0 right-0 z-10 bg-yellow-400 shadow-lg">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between w-full">
            <!-- Logo/Title (Left) -->
            <div class="flex items-center">
                <p class="text-xl font-extrabold text-gray-900 tracking-tight">OnCoMaSy</p>
            </div>
            
            <!-- User Info & Logout Button (Right) -->
            <div class="flex items-center space-x-4">
                <c:if test="${not empty sessionScope.currentUser}">
                    <!-- Display user information for context -->
                    <span class="text-gray text-sm font-medium hidden sm:inline">
                        <c:out value="${sessionScope.currentUser.roleName}"/>: <c:out value="${sessionScope.currentUser.fullName}"/>
                    </span>
                </c:if>
                <!-- Logout Button at the far right -->
                <a href="logout" 
                   class="bg-red-600 hover:bg-red-700 text-white font-semibold py-1.5 px-3 rounded-md text-sm 
                          transition duration-150 ease-in-out shadow-md">
                    Logout
                </a>
            </div>
        </div>
    </header>
    <!-- END: Top Navigation Ribbon/Header -->

    <div class="container">
        
        <h1>Available Courses for Enrollment</h1>

        <!-- Session Message Display - Using the standard .message class -->
        <c:if test="${not empty sessionScope.message}">
            <div class="message" role="alert">
                <p class="font-bold">Message:</p>
                <p><c:out value="${sessionScope.message}" /></p>
            </div>
            <% session.removeAttribute("message"); %>
        </c:if>

        <!-- Container for buttons. items-center ensures vertical alignment. -->
        <div class="flex justify-between mb-6 items-center">
            
            <!-- PRIMARY BUTTON: Standardized Dashboard button style -->
            <a href="dashboard.jsp" 
               class="dashboard-button text-sm flex items-center">
                &larr; Return to Dashboard
            </a>
            
            <!-- SECONDARY LINK: Standardized secondary link style -->
            <a href="StudentServlet?action=viewEnrolled" 
               class="secondary-link text-sm font-semibold">
                View My Enrolled Courses
            </a>
        </div>

        <c:choose>
            <c:when test="${empty requestScope.listCourses}">
                <div class="text-center py-10 border border-dashed border-gray-300 rounded-lg bg-gray-50 shadow-inner">
                    <p class="text-lg text-gray-500 font-medium">
                        No courses are currently available for enrollment.
                    </p>
                    <p class="text-sm text-gray-400 mt-1">
                        Please check back later or contact your administrator.
                    </p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="course-list space-y-4">
                    <c:forEach var="course" items="${requestScope.listCourses}">
                        <div class="course-card rounded-lg shadow-md flex justify-between items-center">
                            <div class="course-card-inner">
                                <p class="text-xs font-semibold text-gray-500">
                                	Code: <span class="font-medium text-indigo-600"><c:out value="${course.courseCode}" /></span>
                                </p>
                                <h2 class="text-xl font-bold text-gray-800 mb-1">
                                	Title: <span class="font-medium text-indigo-600"><c:out value="${course.courseTitle}" /></span>
                                </h2>
                                <p class="text-sm text-gray-700 mb-2">
                                	Description: <span class="font-medium text-indigo-600"><c:out value="${course.courseDescription}" /></span>
                                </p>
                                
                                <c:if test="${not empty course.teacherName}">
                                    <p class="text-xs text-gray-600">
                                        Taught by: <span class="font-medium text-indigo-600"><c:out value="${course.teacherName}" /></span>
                                    </p>
                                </c:if>
                            </div>
                            
                            <!-- Enrollment Form -->
                            <form action="StudentServlet" method="post" class="ml-4 flex-shrink-0">
                                <input type="hidden" name="action" value="enroll" />
                                <input type="hidden" name="courseId" value="<c:out value='${course.courseId}' />" />
                                <button type="submit" 
                                    class="dashboard-button text-sm py-2 px-4 shadow-md hover:shadow-lg">
                                    Enroll Now
                                </button>
                            </form>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</body>
</html>