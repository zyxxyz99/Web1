<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ page import="ocms.web.User" %>

<% 
    // Basic authorization check
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser == null || currentUser.getRoleId() != 2) {
        response.sendError(403, "Access Denied. Only Teachers can view this page.");
        return;
    }
    request.setAttribute("currentUser", currentUser);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Enrolled Students</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f0f4f8; }
        .container {
            max-width: 1000px; margin: 0 auto; background: white; padding: 30px;
            border-radius: 12px; box-shadow: 0 6px 12px rgba(0,0,0,0.1);
        }
        h1 { color: #2c3e50; border-bottom: 3px solid #e74c3c; padding-bottom: 10px; margin-bottom: 20px; }
        .dashboard-button {
            display: inline-block; background-color: #3498db; color: white;
            padding: 10px 15px; border-radius: 5px; font-weight: bold;
            margin-bottom: 20px; transition: 0.3s;
        }
        .dashboard-button:hover { background-color: #2980b9; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; border-radius: 8px; }
        th, td { border: 1px solid #ddd; padding: 15px; text-align: left; }
        th { background-color: #e74c3c; color: white; text-transform: uppercase; font-weight: bold; font-size: 0.75rem; }
        tr:nth-child(even) { background-color: #f9f9f9; }
        .student-row:hover { background-color: #f3f4f6; }
    </style>
</head>

<body class="pt-20">

<header class="fixed top-0 left-0 right-0 z-10 bg-yellow-400 shadow-lg">
    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between w-full">
        <div class="flex items-center">
            <h1 class="text-xl font-extrabold text-gray-900 tracking-tight"
                style="border-bottom: none; padding-bottom: 0; margin-bottom: 0;">
                OnCoMaSy
            </h1>
        </div>
        <div class="flex items-center space-x-4">
            <c:if test="${not empty currentUser}">
                <span class="text-gray text-sm font-medium hidden sm:inline">
                    <c:out value="${currentUser.roleName}"/>: <c:out value="${currentUser.fullName}"/>
                </span>
            </c:if>
            <a href="logout"
               class="bg-red-600 hover:bg-red-700 text-white font-semibold py-1.5 px-3 rounded-md text-sm shadow-md">
                Logout
            </a>
        </div>
    </div>
</header>

<div class="overflow-x-auto">

    <h1>Enrolled Students</h1>
    
    <p class="text-lg font-medium text-indigo-600 mb-4">
        Course Title:
        <span class="font-bold"><c:out value="${requestScope.courseTitle}" /></span>
    </p>

    <a href="TeacherServlet?action=manageCourses" class="dashboard-button">&larr; Back to Course List</a>

    <c:choose>
        <c:when test="${empty requestScope.listStudents}">
            <div class="text-center py-10 border border-dashed border-gray-300 rounded-lg bg-gray-50 shadow-inner mt-4">
                <p class="text-lg text-gray-500 font-medium">
                    No students are currently enrolled in this course.
                </p>
            </div>
        </c:when>

        <c:otherwise>

            <div class="shadow-lg rounded-lg overflow-hidden">
                <table class="min-w-full">
                    <thead>
                        <tr>
                            <th>Student Name</th>
                            <th class="hidden sm:table-cell">Email</th>

                            <!-- Registration ID column -->
                            <th class="hidden md:table-cell">Registration ID</th>

                            <th class="hidden md:table-cell">User ID</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="student" items="${requestScope.listStudents}">
                            <tr class="student-row">
                                <td class="text-sm font-medium text-gray-900">
                                    <c:out value="${student.fullName}" />
                                </td>

                                <td class="text-sm text-gray-500 hidden sm:table-cell">
                                    <c:out value="${student.email}" />
                                </td>

                                <!-- ⭐ FIX: Using the full registrationId property, which is aliased in User.java via getRegistrationId() -->
                                <td class="text-sm text-gray-500 hidden md:table-cell">
                                    <c:out value="${student.registrationId}" />
                                </td>

                                <td class="text-sm text-gray-500 hidden md:table-cell">
                                    <c:out value="${student.userId}" />
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>

                </table>
            </div>

            <p class="text-sm text-gray-600 mt-4">
                Total Enrolled Students:
                <span class="font-bold text-gray-800">
                    <c:out value="${fn:length(requestScope.listStudents)}" />
                </span>
            </p>

        </c:otherwise>
    </c:choose>

</div>
</body>
</html>