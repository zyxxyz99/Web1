<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="ocms.web.User" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Course Management</title>
    <!-- ADDED: Tailwind CSS CDN for styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            /* Removed margin: 20px; to allow pt-20 body class to manage top padding */
            background-color: #f4f7f6;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c3e50;
            /* REMOVED: border-bottom: 3px solid #3498db; to remove the blue line */
            padding-bottom: 10px;
            margin-bottom: 20px;
            margin-top: 0;
        }
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 4px;
            background-color: #e8f5e9;
            color: #2e7d32;
            border: 1px solid #4caf50;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #ddd;
            padding: 12px;
            text-align: left;
        }
        th {
            background-color: #3498db;
            color: white;
            text-transform: uppercase;
            font-weight: bold;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        
        /* New Styles for buttons */
        .dashboard-button {
            display: inline-block;
            background-color: #f39c12; /* Orange for return */
            color: white;
            padding: 8px 15px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            margin-bottom: 20px;
            transition: background-color 0.3s;
        }
        .dashboard-button:hover {
            background-color: #e67e22;
        }

        .add-button {
            display: inline-block;
            background-color: #2ecc71;
            color: white;
            padding: 10px 15px;
            text-decoration: none;
            border-radius: 5px;
            font-weight: bold;
            margin-bottom: 20px;
            transition: background-color 0.3s;
        }
        .add-button:hover {
            background-color: #27ae60;
        }

        .action-button {
            display: inline-block;
            padding: 6px 10px;
            margin: 2px 0;
            border-radius: 4px;
            font-size: 14px;
            font-weight: bold;
            text-align: center;
            text-decoration: none;
            transition: background-color 0.3s, opacity 0.3s;
            border: none;
            cursor: pointer;
        }
        .edit-button {
            background-color: #3498db; /* Blue */
            color: white;
            margin-right: 5px;
        }
        .edit-button:hover {
            background-color: #2980b9;
        }
        .delete-button {
            background-color: #e74c3c; /* Red */
            color: white;
        }
        .delete-button:hover {
            background-color: #c0392b;
        }

        /* Remove old link styles */
        .action-link, .delete-link {
            /* Styles replaced by action-button styles */
            text-decoration: none;
        }
    </style>
</head>

<!-- MODIFIED: Added pt-20 to offset the fixed header -->
<body class="pt-20"> 

    <!-- NEW: Top Navigation Ribbon/Header -->
    <header class="fixed top-0 left-0 right-0 z-10 bg-yellow-400 shadow-lg">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between w-full">
            <!-- Logo/Title (Left) -->
            <div class="flex items-center">
                <h1 class="text-xl font-extrabold text-gray-900 tracking-tight">OnCoMaSy</h1>
            </div>
            
            <!-- User Info & Logout Button (Right) -->
            <div class="flex items-center space-x-4">
                <c:if test="${not empty currentUser}">
                    <!-- Display user information for context -->
                    <span class="text-black text-sm font-medium hidden sm:inline">
                        <c:out value="${currentUser.roleName}" />: <c:out value="${currentUser.fullName}" />
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
        
        

        <h1>Course Management Dashboard</h1>
        
        <p>Welcome, <c:out value="${sessionScope.currentUser.fullName}" /> (<c:out value="${sessionScope.currentUser.roleName}" />)</p>
        
        <!-- NEW: Return to Dashboard button added at the top -->
        <a href="dashboard.jsp" class="dashboard-button">
            &larr; Return to Dashboard
        </a>
        
        <c:if test="${not empty sessionScope.message}">
            <div class="message">
                <c:out value="${sessionScope.message}" />
            </div>
            <% session.removeAttribute("message"); %>
        </c:if>

        <!-- Only show ADD button if user is Admin (roleId = 1) -->
        <c:if test="${sessionScope.currentUser.roleId == 1}">
            <a href="CourseServlet?action=new" class="add-button">Add New Course</a>
        </c:if>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Code</th>
                    <th>Title</th>
                    <th>Description</th>
                    <th>Teacher</th>
                    <c:if test="${sessionScope.currentUser.roleId == 1}">
                        <th>Actions</th>
                    </c:if>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="course" items="${requestScope.listCourse}">
                    <tr>
                        <td><c:out value="${course.courseId}" /></td>
                        <td><c:out value="${course.courseCode}" /></td>
                        <td><c:out value="${course.courseTitle}" /></td>
                        <td><c:out value="${course.courseDescription}" /></td>
                        <td><c:out value="${course.teacherName}" /></td>
                        
                        <!-- Only show EDIT/DELETE links if user is Admin (roleId = 1) -->
                        <c:if test="${sessionScope.currentUser.roleId == 1}">
                            <td>
                                <!-- Actions now styled as buttons -->
                                <a href="CourseServlet?action=edit&id=<c:out value='${course.courseId}' />" class="action-button edit-button">Edit</a>
                                <a href="CourseServlet?action=delete&id=<c:out value='${course.courseId}' />" class="action-button delete-button" onclick="return confirm('Are you sure you want to delete this course?');">Delete</a>
                            </td>
                        </c:if>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <!-- Logout removed as requested -->
    </div>
</body>
</html>