<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OCMS Student Registration</title>

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap"
          rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f7f9fb;
        }
    </style>
</head>
<body class="min-h-screen">

<header class="bg-yellow-400 shadow-lg">
    <div class="max-w-7xl mx-auto py-4 px-4">
        <h1 class="text-xl font-extrabold text-gray-900">OnCoMaSy</h1>
    </div>
</header>

<div class="max-w-7xl mx-auto pt-4 px-4">
    <a href="register.jsp"
       class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50">

        <svg class="-ml-1 mr-2 h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
            <path fill-rule="evenodd"
                  d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z"
                  clip-rule="evenodd"/>
        </svg>
        Change Role
    </a>
</div>

<div class="flex items-center justify-center py-10">
    <div class="w-full max-w-lg bg-white p-10 rounded-xl shadow-2xl border border-gray-100">

        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-gray-800">Student Account Registration</h1>
            <p class="text-gray-500 mt-2">Create your student account to enroll in courses.</p>
        </div>

        <!-- ERROR MESSAGES -->
        <%
            String error = (String) request.getAttribute("error");
            String errorRegId = (String) request.getAttribute("error_regid");
            if (errorRegId != null) {
        %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                <strong class="font-bold">Registration ID Error:</strong>
                <span class="block sm:inline"><%= errorRegId %></span>
            </div>
        <%
            } else if (error != null) {
        %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                <strong class="font-bold">Error:</strong>
                <span class="block sm:inline"><%= error %></span>
            </div>
        <%
            }
        %>

        <form action="<%= request.getContextPath() %>/register" method="post">
            <div class="space-y-6">

                <input type="hidden" name="role" value="Student"/>

                <!-- Full Name -->
                <div>
                    <label class="block text-sm font-medium mb-1">Full Name</label>
                    <input type="text" name="fullName" required
                           placeholder="e.g., Jane Doe"
                           class="w-full px-4 py-2 border rounded-lg"
                           value="<%= request.getParameter("fullName") != null ? request.getParameter("fullName") : "" %>">
                </div>

                <!-- Registration ID -->
                <div>
                    <label class="block text-sm font-medium mb-1">Registration ID</label>
                    <input type="text" name="reg_id" required
                           placeholder="Enter your official registration number"
                           class="w-full px-4 py-2 border rounded-lg"
                           value="<%= request.getParameter("reg_id") != null ? request.getParameter("reg_id") : "" %>">
                </div>

                <!-- Email -->
                <div>
                    <label class="block text-sm font-medium mb-1">Email</label>
                    <input type="email" name="email" required
                           placeholder="e.g., jane.doe@school.edu"
                           class="w-full px-4 py-2 border rounded-lg"
                           value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>">
                </div>

                <!-- Username -->
                <div>
                    <label class="block text-sm font-medium mb-1">Username</label>
                    <input type="text" name="username" required
                           placeholder="Choose a unique username"
                           class="w-full px-4 py-2 border rounded-lg"
                           value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>">
                </div>

                <!-- Password -->
                <div>
                    <label class="block text-sm font-medium mb-1">Password</label>
                    <input type="password" name="password" required
                           class="w-full px-4 py-2 border rounded-lg">
                </div>

                <button type="submit"
                        class="w-full py-3 bg-blue-600 text-white rounded-lg hover:bg-blue-700">
                    Register Student Account
                </button>
            </div>
        </form>

        <p class="mt-6 text-center text-sm">
            Already have an account? 
            <a href="login" class="text-blue-600 underline">Login Here</a>
        </p>
    </div>
</div>
</body>
</html>
