<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OCMS Login</title>
    <!-- Load Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        /* Custom styles for the login box */
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f7f9fb;
        }
    </style>
</head>
<body class="min-h-screen">

    <!-- Yellow Ribbon Header -->
    <header class="bg-yellow-400 shadow-lg">
        <div class="max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8">
            <h1 class="text-xl font-extrabold text-gray-900 tracking-tight">
                OnCoMaSy
            </h1>
        </div>
    </header>

    <!-- Go Back Button (Under the ribbon, above the main content) -->
    <div class="max-w-7xl mx-auto pt-4 px-4 sm:px-6 lg:px-8">
        <a href="./" class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition duration-150">
            <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
            </svg>
            Go Back to Home
        </a>
    </div>

    <!-- Main Content Container (Centered) -->
    <div class="flex items-center justify-center py-10">
        <div class="w-full max-w-md bg-white p-8 rounded-xl shadow-2xl transition duration-300 ease-in-out hover:shadow-3xl border border-gray-100">
            
            <div class="text-center mb-8">
                <h1 class="text-3xl font-bold text-gray-800">OCMS Login</h1>
                <p class="text-gray-500 mt-2">Sign in to your account</p>
            </div>

            <% 
                // Check for and display error message from the Servlet
                String error = (String) request.getAttribute("error");
                
                // Check for and display success message from the RegisterServlet
                String successMessage = (String) session.getAttribute("successMessage");
                if (successMessage != null) {
                    // Display success message
            %>
                <div class="bg-green-100 border border-green-400 text-green-700 px-4 py-3 rounded relative mb-4" role="alert">
                    <strong class="font-bold">Success:</strong>
                    <span class="block sm:inline"><%= successMessage %></span>
                </div>
            <%
                    // Remove the message after displaying it once
                    session.removeAttribute("successMessage");
                }


                if (error != null) {
            %>
                <div class="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded relative mb-4" role="alert">
                    <strong class="font-bold">Error:</strong>
                    <span class="block sm:inline"><%= error %></span>
                </div>
            <%
                }
            %>

            <form action="<%= request.getContextPath() %>/login" method="post">
                <div class="space-y-6">
                    <!-- Email Field (Changed from Username) -->
                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-700 mb-1">Email Address</label>
                        <input 
                            type="email" 
                            id="email" 
                            name="email" 
                            required
                            placeholder="Enter your email address"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500 transition duration-150"
                        >
                    </div>

                    <!-- Password Field -->
                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-700 mb-1">Password</label>
                        <input 
                            type="password" 
                            id="password" 
                            name="password" 
                            required
                            placeholder="Enter your password"
                            class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500 transition duration-150"
                        >
                    </div>

                    <!-- Submit Button -->
                    <button 
                        type="submit"
                        class="w-full py-3 px-4 bg-blue-600 text-white font-semibold rounded-lg shadow-md hover:bg-blue-700 focus:outline-none focus:ring-4 focus:ring-blue-500 focus:ring-opacity-50 transition duration-300 transform hover:scale-[1.01]"
                    >
                        Login
                    </button>
                </div>
            </form>

            <p class="mt-6 text-center text-sm text-gray-600">
                Don't have an account? 
                <a href="register" class="font-medium text-blue-600 hover:text-blue-500 hover:underline">Register Here</a>
            </p>

        </div>
    </div>
</body>
</html>