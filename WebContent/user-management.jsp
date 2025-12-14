<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page import="ocms.web.User" %>
<% 
    // Ensuring currentUser is available in request scope if necessary for complex roles or access control
    User currentUser = (User) session.getAttribute("currentUser");
    if (currentUser != null) {
        request.setAttribute("currentUser", currentUser);
    } 
    // Note: Assuming necessary role check (Admin/roleId=1) happens in the servlet before displaying this page.
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>User & Role Management</title>
    <!-- ADDED: Tailwind CSS CDN for styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            /* Changed margin to allow fixed header padding to work */
            background-color: #f0f4f8;
        }
        .container {
            max-width: 1000px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 12px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c3e50;
            /* This is the red line in the main content. Keeping it as requested ("keep everything else same"). */
            border-bottom: 3px solid #e74c3c; 
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .message {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 8px;
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
            padding: 15px;
            text-align: left;
        }
        th {
            background-color: #e74c3c;
            color: white;
            text-transform: uppercase;
            font-weight: bold;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        
        /* Dashboard Button Styles (for "Return to Dashboard") */
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
        
        /* Action Button Base Styles */
        .action-button {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: bold;
            text-align: center;
            text-decoration: none;
            transition: background-color 0.3s;
            border: none;
            cursor: pointer;
            white-space: nowrap;
        }
        
        /* Make Admin button style */
        .admin-button {
            background-color: #2ecc71; /* Green */
            color: white;
            padding: 6px 10px;
            font-size: 14px;
        }
        .admin-button:hover {
            background-color: #27ae60;
        }
        
        /* Delete Button Styles */
        .delete-button {
            background-color: #e74c3c; /* Red */
            color: white;
        }
        .delete-button:hover {
            background-color: #c0392b;
        }
        
        /* Special style for deleting other Admins */
        .delete-admin-button {
             background-color: #c0392b; /* Darker Red */
             color: white;
        }
        .delete-admin-button:hover {
            background-color: #9c2b20;
        }
        
        .current-admin {
            font-weight: bold;
            color: #e74c3c;
        }
        
        /* Ensure forms in cells align horizontally with the promotion button */
        .action-form {
            display: inline-block;
            margin: 0;
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
                <!-- MODIFIED: Added 'm-0 p-0 border-none' classes to ensure the h1 inside the header has no border or padding -->
                <h1 class="text-xl font-extrabold text-gray-900 tracking-tight m-0 p-0 border-none">OnCoMaSy</h1>
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
        
        

        <h1>User and Role Management</h1>
        
        <p>Admin: <c:out value="${sessionScope.currentUser.fullName}" /></p>
        
        <!-- Updated: Return to Dashboard now styled as a prominent button -->
        <a href="dashboard.jsp" class="dashboard-button">
            &larr; Return to Dashboard
        </a>
        
        <c:if test="${not empty sessionScope.message}">
            <div class="message">
                <c:out value="${sessionScope.message}" />
            </div>
            <% session.removeAttribute("message"); %>
        </c:if>
        
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Full Name</th>
                    <th>Email</th>
                    <th>Current Role</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="user" items="${requestScope.listUsers}">
                    <tr>
                        <td><c:out value="${user.userId}" /></td>
                        <td><c:out value="${user.username}" /></td>
                        <td><c:out value="${user.fullName}" /></td>
                        <td><c:out value="${user.email}" /></td>
                        
                        <td>
                            <c:choose>
                                <c:when test="${user.roleId == 1}">
                                    <span class="current-admin"><c:out value="${user.roleName}" /></span>
                                </c:when>
                                <c:otherwise>
                                    <c:out value="${user.roleName}" />
                                </c:otherwise>
                            </c:choose>
                        </td>
                        
                        <td>
                            <c:choose>
                                <%-- Rule 1: Prevent Admin from modifying or deleting their own account --%>
                                <c:when test="${user.userId == sessionScope.currentUser.userId}">
                                    <span style="color: gray; font-style: italic;">(Current User)</span>
                                </c:when>
                                
                                <%-- Case 1: Target is another Admin --%>
                                <c:when test="${user.roleId == 1}">
                                    <div style="display: flex; flex-direction: column; gap: 5px;">
                                        <span style="color: #2ecc71; font-weight: bold;">Administrator</span>
                                        
                                        <%-- Rule 3: Only User ID 1 (Super Admin) can delete other Admins --%>
                                        <c:if test="${sessionScope.currentUser.userId == 1}">
                                            
                                            <%-- Delete Admin Form (POST request) --%>
                                            <form action="AdminServlet" method="post" class="action-form"
                                                  onsubmit="return confirm('WARNING! You are about to delete another Administrator account (${user.fullName}). Are you absolutely sure?');">
                                                <input type="hidden" name="action" value="deleteUser" />
                                                <input type="hidden" name="userId" value="<c:out value='${user.userId}' />" />
                                                <button type="submit" class="action-button delete-admin-button" style="margin-top: 5px;">
                                                    Delete Admin
                                                </button>
                                            </form>
                                        </c:if>
                                    </div>
                                </c:when>

                                <%-- Case 2: Target is a non-Admin (Teacher or Student) --%>
                                <c:otherwise>
                                    <div style="display: flex; gap: 10px; align-items: center;">
                                        <%-- Promotion to Admin --%>
                                        <form action="AdminServlet" method="post" onsubmit="return confirm('Are you sure you want to promote ${user.fullName} to Administrator?');" class="action-form">
                                            <input type="hidden" name="action" value="makeAdmin" />
                                            <input type="hidden" name="userId" value="<c:out value='${user.userId}' />" />
                                            <button type="submit" class="admin-button action-button">Make Admin</button>
                                        </form>
                                        
                                        <%-- Rule 2: Delete non-Admin account (POST request) --%>
                                        <form action="AdminServlet" method="post" class="action-form"
                                              onsubmit="return confirm('Are you sure you want to delete the account for ${user.fullName}? This cannot be undone.');">
                                            <input type="hidden" name="action" value="deleteUser" />
                                            <input type="hidden" name="userId" value="<c:out value='${user.userId}' />" />
                                            <button type="submit" class="action-button delete-button">
                                                Delete
                                            </button>
                                        </form>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</body>
</html>