<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="ocms.web.User" %>

<% 
    // Basic authorization check
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || currentUser.getRoleId() != 2) {
        // Use implicit 'response' object to handle the error status
        response.sendError(403, "Access Denied. Only Teachers can view this page.");
        return;
    }
    // Set currentUser in request scope for display purposes in the ribbon
    if (currentUser != null) {
        request.setAttribute("currentUser", currentUser);
    } 
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage My Courses</title>
    <!-- Tailwind CSS CDN for styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f0f4f8; /* New background color */
        }
        
        /* New container styling from the template */
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
        }
        
        /* New H1 styling from the template */
        h1 {
            color: #2c3e50;
            border-bottom: 3px solid #e74c3c; /* Red border */
            padding-bottom: 10px;
            margin-bottom: 20px;
        }

        /* Course Card Styling - adapted to fit the new aesthetic */
        .course-card {
            background-color: white;
            padding: 1.5rem;
            border-left: 5px solid #4f46e5; /* Keep Indigo border for teacher courses */
            margin-bottom: 1rem;
            transition: transform 0.2s;
            border-radius: 8px; /* Slightly more prominent rounding */
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05); /* Lighter shadow */
        }
        .course-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        
        /* Dashboard Button Styles (from template) */
        .dashboard-button {
            display: inline-block;
            background-color: #3498db; /* Blue */
            color: white;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            margin-bottom: 20px;
            transition: background-color 0.3s;
        }
        .dashboard-button:hover {
            background-color: #2980b9;
        }

        /* Message Styling (optional, but kept for consistency) */
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
            background-color: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #4caf50;
        }
    </style>
</head>

<!-- MODIFIED: Added pt-20 to offset the fixed header -->
<body class="pt-20">

    <!-- INSERTED: Top Navigation Ribbon/Header (Fixed to the top) -->
    <header class="fixed top-0 left-0 right-0 z-10 bg-yellow-400 shadow-lg">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between w-full">
            <!-- Logo/Title (Left) -->
            <div class="flex items-center">
                <h1 class="text-xl font-extrabold text-gray-900 tracking-tight" style="border-bottom: none; padding-bottom: 0; margin-bottom: 0;">OnCoMaSy</h1>
            </div>
            
            <!-- User Info & Logout Button (Right) -->
            <div class="flex items-center space-x-4">
                <c:if test="${not empty currentUser}">
                    <!-- Display user information for context -->
                    <span class="text-gray text-sm font-medium hidden sm:inline">
                        <c:out value="${currentUser.roleName}"/>: <c:out value="${currentUser.fullName}"/>
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

    <!-- MODIFIED: Wrapper now uses the fixed-width container class -->
    <div class="overflow-x-auto">
        
        <h1>Courses I Teach</h1>
        
        <!-- Teacher info display, adapted from the admin template -->
        <p class="text-gray-600 mb-4">Teacher: <c:out value="${currentUser.fullName}" /></p>

        <div class="flex justify-start">
            <!-- UPDATED: Applied dashboard-button style from template -->
            <a href="dashboard.jsp" class="dashboard-button">
                &larr; Return to Dashboard
            </a>
        </div>

        <c:choose>
            <c:when test="${empty requestScope.listCourses}">
                <div class="text-center py-10 border border-dashed border-gray-300 rounded-lg bg-gray-50 shadow-inner mt-4">
                    <p class="text-lg text-gray-500 font-medium">
                        You have not been assigned any courses yet.
                    </p>
                    <p class="text-sm text-gray-400 mt-1">
                        Please contact the administrator to assign courses.
                    </p>
                </div>
            </c:when>
            <c:otherwise>
                <div class="course-list space-y-4 mt-4">
                    <c:forEach var="course" items="${requestScope.listCourses}">
                        <div class="course-card shadow-md flex justify-between items-center">
                            <div class="course-card-inner max-w-2xl">
                                <p class="text-xs font-semibold text-gray-500">
                                	Code: <span class="font-medium text-indigo-600"><c:out value="${course.courseCode}" /></span>
                                </p>
                                <h2 class="text-xl font-bold text-gray-800 mb-1">
                                	Title: <span class="font-medium text-indigo-600"><c:out value="${course.courseTitle}" /></span>
                                </h2>
                                <p class="text-sm text-gray-700 mb-2">
                                	Description: <span class="font-medium text-indigo-600"><c:out value="${course.courseDescription}" /></span>
                                </p>
                            </div>
                            
                            <!-- Button to View Students -->
                            <a href="TeacherServlet?action=viewStudents&courseId=<c:out value='${course.courseId}' />&courseTitle=<c:out value='${course.courseTitle}' />" 
   class="bg-green-600 hover:bg-green-700 text-white font-bold py-2 px-4 rounded-lg 
          transition duration-150 ease-in-out shadow-md hover:shadow-lg flex items-center whitespace-nowrap">
    View Students
    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 ml-2" viewBox="0 0 20 20" fill="currentColor">
        <path d="M13 6a3 3 0 11-6 0 3 3 0 016 0z" />
        <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-6-3a2 2 0 11-4 0 2 2 0 014 0zm-2 4a5 5 0 00-4.546 2.916A5.98 5.98 0 0010 16a5.979 5.979 0 004.546-2.084A5 5 0 0010 11z" clip-rule="evenodd" />
    </svg>
</a>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</body>
</html>