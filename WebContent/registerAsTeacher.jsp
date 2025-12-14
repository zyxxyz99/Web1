<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OCMS Teacher Registration</title>

    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">

    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f7f9fb;
        }
    </style>
</head>
<body class="min-h-screen">

    <!-- Header -->
    <header class="bg-yellow-400 shadow-lg">
        <div class="max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8">
            <h1 class="text-xl font-extrabold text-gray-900 tracking-tight">OnCoMaSy</h1>
        </div>
    </header>

    <!-- Back Button -->
    <div class="max-w-7xl mx-auto pt-4 px-4 sm:px-6 lg:px-8">
        <a href="register.jsp"
           class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium 
                  rounded-md text-gray-700 bg-white hover:bg-gray-50 transition duration-150">

            <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg"
                 fill="currentColor" viewBox="0 0 20 20">
                <path fill-rule="evenodd"
                      d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 
                      01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z"
                      clip-rule="evenodd" />
            </svg>
            &larr; Change Role
        </a>
    </div>

    <!-- Main Container -->
    <div class="flex items-center justify-center py-10">
        <div class="w-full max-w-lg bg-white p-10 rounded-xl shadow-2xl border border-gray-100">

            <div class="text-center mb-8">
                <h1 class="text-3xl font-bold text-gray-800">Teacher Account Registration</h1>
                <p class="text-gray-500 mt-2">Create your teacher account to create and manage courses.</p>
            </div>

            <% 
                String error = (String) request.getAttribute("error");
                if (error != null) {
            %>
            <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
                <strong>Error:</strong> <%= error %>
            </div>
            <% } %>

            <form action="<%= request.getContextPath() %>/register" method="post">
                <div class="space-y-6">

                    <!-- Hidden Role -->
                    <input type="hidden" name="role" value="Teacher">

                    <!-- Full Name -->
                    <div>
                        <label class="block text-sm font-medium mb-1">Full Name</label>
                        <input type="text" name="fullName" required
                               placeholder="e.g., Jane Doe"
                               value="<%= request.getParameter("fullName") != null ? request.getParameter("fullName") : "" %>"
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500">
                    </div>

                    <!-- Email -->
                    <div>
                        <label class="block text-sm font-medium mb-1">Email Address</label>
                        <input type="email" name="email" required
                               placeholder="e.g., jane.doe@school.edu"
                               value="<%= request.getParameter("email") != null ? request.getParameter("email") : "" %>"
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500">
                    </div>

                    <!-- Username -->
                    <div>
                        <label class="block text-sm font-medium mb-1">Username</label>
                        <input type="text" name="username" required
                               placeholder="Choose a unique username"
                               value="<%= request.getParameter("username") != null ? request.getParameter("username") : "" %>"
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500">
                    </div>

                    <!-- Password -->
                    <div>
                        <label class="block text-sm font-medium mb-1">Password</label>
                        <input type="password" name="password" required
                               placeholder="Must be at least 6 characters"
                               class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500">
                    </div>

                    <!-- Submit -->
                    <button type="submit"
                            class="w-full py-3 bg-green-600 text-white font-semibold rounded-lg 
                                   shadow-md hover:bg-green-700 focus:ring-4 focus:ring-green-500">
                        Register Teacher Account
                    </button>
                </div>
            </form>

            <p class="mt-6 text-center text-sm text-gray-600">
                Already have an account?
                <a href="login" class="font-medium text-blue-600 hover:underline">Login Here</a>
            </p>

        </div>
    </div>

</body>
</html>
