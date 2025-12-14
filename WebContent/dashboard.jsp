<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="ocms.web.User" %>
<% 
    User currentUser = (User) session.getAttribute("currentUser");
    // Set currentUser in request scope for JSTL access
    if (currentUser != null) {
        request.setAttribute("currentUser", currentUser);
    } else {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OCMS Dashboard</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #f4f7f9; }
        .card { 
            background-color: white; 
            border-radius: 0.75rem; 
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1); 
            padding: 2rem; 
            border-left: 4px solid;
        }
        .card-admin { border-left-color: #dc2626; }
        .card-teacher { border-left-color: #4f46e5; }
        .card-student { border-left-color: #2563eb; }
    </style>
</head>

<body class="min-h-screen flex flex-col items-center py-10 pt-20">

    <!-- Header -->
    <header class="fixed top-0 left-0 right-0 z-10 bg-yellow-400 shadow-lg">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between w-full">
            <div class="flex items-center">
                <h1 class="text-xl font-extrabold text-gray-900 tracking-tight">OnCoMaSy</h1>
            </div>

            <div class="flex items-center space-x-4">
                <c:if test="${not empty currentUser}">
                    <span class="text-black text-sm font-medium hidden sm:inline">
                        <c:out value="${currentUser.roleName}" />: 
                        <c:out value="${currentUser.fullName}" />
                    </span>
                </c:if>

                <a href="logout" 
                   class="bg-red-600 hover:bg-red-700 text-white font-semibold py-1.5 px-3 rounded-md text-sm shadow-md">
                    Logout
                </a>
            </div>
        </div>
    </header>

    <div class="w-full max-w-4xl">

        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">

            <!-- Account Overview -->
            <c:choose>
                <c:when test="${currentUser.roleId == 1}">
                    <c:set var="cardClass" value="card-admin" />
                </c:when>
                <c:when test="${currentUser.roleId == 2}">
                    <c:set var="cardClass" value="card-teacher" />
                </c:when>
                <c:when test="${currentUser.roleId == 3}">
                    <c:set var="cardClass" value="card-student" />
                </c:when>
                <c:otherwise>
                    <c:set var="cardClass" value="" />
                </c:otherwise>
            </c:choose>

            <div class="card ${cardClass} col-span-1 md:col-span-2">
                <h2 class="text-2xl font-semibold mb-3 text-gray-800">Account Overview</h2>

                <p class="text-gray-600">
                    Name: <span class="font-medium"><c:out value="${currentUser.fullName}" /></span>
                </p>

                <p class="text-gray-600">
                    Email: <span class="font-medium"><c:out value="${currentUser.email}" /></span>
                </p>

                <!-- ✅ SHOW REG ID ONLY FOR STUDENT -->
                <c:if test="${currentUser.roleId == 3}">
                    <p class="text-gray-600">
                        Registration ID:
                        <span class="font-medium"><c:out value="${currentUser.regId}" /></span>
                    </p>
                </c:if>

                <c:choose>
                    <c:when test="${currentUser.roleId == 1}">
                        <p class="text-gray-600">Role: <span class="font-bold text-red-600">Administrator</span></p>
                    </c:when>
                    <c:when test="${currentUser.roleId == 2}">
                        <p class="text-gray-600">Role: <span class="font-bold text-indigo-600">Teacher</span></p>
                    </c:when>
                    <c:when test="${currentUser.roleId == 3}">
                        <p class="text-gray-600">Role: <span class="font-bold text-blue-600">Student</span></p>
                    </c:when>
                    <c:otherwise>
                        <p class="text-gray-600">Role: <span class="font-bold text-gray-500">Unknown</span></p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Student Options -->
            <c:if test="${currentUser.roleId == 3}">
                <div class="card card-student">
                    <h3 class="text-xl font-semibold mb-3 text-blue-800">Student Enrollment</h3>
                    <p class="text-gray-600 mb-4">Manage your course registrations and view your current schedule.</p>
                    <a href="StudentServlet?action=viewEnrolled" 
                       class="bg-blue-600 hover:bg-blue-700 text-white font-medium py-2 px-4 rounded-lg text-center shadow-md">
                        Enrolled Courses
                    </a>
                </div>

                <div class="card card-student">
                    <h3 class="text-xl font-semibold mb-3 text-blue-800">Available Courses</h3>
                    <p class="text-gray-600 mb-4">Explore and enroll in new courses for the upcoming semester.</p>
                    <a href="StudentServlet?action=enrollList" 
                       class="bg-green-600 hover:bg-green-700 text-white font-medium py-2 px-4 rounded-lg text-center shadow-md">
                        View Course List
                    </a>
                </div>
            </c:if>

            <!-- Teacher Options -->
            <c:if test="${currentUser.roleId == 2}">
                <div class="card card-teacher col-span-1 md:col-span-2">
                    <h3 class="text-xl font-semibold mb-3 text-indigo-800">Teacher Tools</h3>
                    <p class="text-gray-600 mb-4">Access course rosters and manage student enrollment for your assigned courses.</p>
                    <a href="TeacherServlet?action=manageCourses" 
                       class="bg-indigo-600 hover:bg-indigo-700 text-white font-medium py-3 px-6 rounded-lg shadow-lg">
                        Manage My Courses
                    </a>
                </div>
            </c:if>

            <!-- Admin Options -->
            <c:if test="${currentUser.roleId == 1}">
                <div class="card card-admin col-span-1 md:col-span-2">
                    <h3 class="text-xl font-semibold mb-3 text-red-800">Admin Panel</h3>
                    <p class="text-gray-600 mb-4">Access system settings, manage users, and configure core course data.</p>
                    
                    <div class="flex flex-wrap gap-4 mt-4">
                        <a href="CourseServlet?action=list" 
                           class="p-3 bg-green-600 text-white font-bold rounded-lg shadow-md hover:bg-green-700">
                            Manage Courses
                        </a>

                        <a href="AdminServlet" 
                           class="bg-red-600 hover:bg-red-700 text-white font-medium py-3 px-6 rounded-lg shadow-lg">
                            Go to Admin Console
                        </a>
                    </div>
                </div>
            </c:if>

        </div>
    </div>
</body>
</html>
