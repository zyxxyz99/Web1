<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome to OCMS</title>
    <!-- Tailwind CSS CDN for styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body { 
            font-family: 'Inter', sans-serif; 
            background-color: #f0f4f8; 
        }
        
        /* Dashboard Card Styling */
        .stat-card {
            background-color: white;
            padding: 1.5rem;
            border-radius: 8px;
            border: 2px solid #9b59b6; /* purple*/
            box-shadow: 0 4px 8px rgba(0,0,0,0.05);
            transition: transform 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.1);
        }

        /* Login/Register Button Styles */
        .auth-button {
            padding: 8px 16px;
            border-radius: 6px;
            font-weight: 600;
            transition: background-color 0.3s, opacity 0.3s;
        }
        
        /* Primary (Sign In) - Blue */
        .auth-primary {
            background-color: #3498db;
            color: white;
        }
        .auth-primary:hover {
            background-color: #2980b9;
        }

        /* Secondary (Register) - Light Gray/Outline */
        .auth-secondary {
            background-color: #ecf0f1;
            color: #34495e;
            border: 1px solid #bdc3c7;
        }
        .auth-secondary:hover {
            background-color: #bdc3c7;
        }
    </style>
</head>

<body class="min-h-screen flex flex-col pt-16">

    <!-- Top Navigation Ribbon/Header (Fixed to the top) -->
    <header class="fixed top-0 left-0 right-0 z-10 bg-yellow-400 shadow-lg">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 h-16 flex items-center justify-between w-full">
            
            <!-- Logo/Title (Left) -->
            <div class="flex items-center">
                <p class="text-xl font-extrabold text-gray-900 tracking-tight">OnCoMaSy</p>
            </div>
            
            <!-- Sign In & Register Buttons (Right) -->
            <div class="flex items-center space-x-3">
                <a href="login.jsp" 
                   class="auth-button auth-primary text-sm">
                    Sign In
                </a>
                <a href="register.jsp" 
                   class="auth-button auth-secondary text-sm">
                    Register
                </a>
            </div>
        </div>
    </header>
    <!-- END: Top Navigation Ribbon/Header -->

    <div class="flex-grow flex items-center justify-center p-6">
        <div class="w-full max-w-4xl text-center">
            
            <h1 class="text-4xl font-extrabold text-gray-800 mb-4">
                Online Course Management System
            </h1>
            <p class="text-xl text-gray-500 mb-12">
                Discover, learn, and teach with OCMS.
            </p>


            <!-- Dashboard Statistics Layout -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                
                <!-- Teachers Count -->
                <div class="stat-card">
                    <p class="text-lg font-semibold text-gray-700 mb-1">Teachers</p>
                    <p class="text-4xl font-bold text-gray-600">
                        <c:out value="${requestScope.totalTeachers}" default="0" />
                    </p>
                    <p class="text-sm text-gray-500 mt-1">active instructors</p>
                </div>

                <!-- Students Count -->
                <div class="stat-card">
                    <p class="text-lg font-semibold text-gray-700 mb-1">Students</p>
                    <p class="text-4xl font-bold text-gray-600">
                        <c:out value="${requestScope.totalStudents}" default="0" />
                    </p>
                    <p class="text-sm text-gray-500 mt-1">registered learners</p>
                </div>

                <!-- Courses Count -->
                <div class="stat-card">
                    <p class="text-lg font-semibold text-gray-700 mb-1">Courses</p>
                    <p class="text-4xl font-bold text-gray-600">
                        <c:out value="${requestScope.totalCourses}" default="0" />
                    </p>
                    <p class="text-sm text-gray-500 mt-1">available to enroll</p>
                </div>

            </div>

            <div class="mt-12">
                 <p class="text-sm text-gray-500">
                    <a href="login.jsp" class="text-blue-600 hover:underline font-medium">Sign in</a> 
                    or 
                    <a href="register.jsp" class="text-blue-600 hover:underline font-medium">Register</a> to begin your learning journey.
                 </p>
            </div>
        </div>
    </div>
</body>
</html>