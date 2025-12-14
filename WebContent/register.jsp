<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OCMS Registration Role Selection</title>
    <!-- Load Tailwind CSS -->
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

    <!-- Yellow Ribbon Header -->
    <header class="bg-yellow-400 shadow-lg">
        <div class="max-w-7xl mx-auto py-4 px-4 sm:px-6 lg:px-8">
            <h1 class="text-xl font-extrabold text-gray-900 tracking-tight">
                OnCoMaSy
            </h1>
        </div>
    </header>

    <!-- Go Back Button -->
    <div class="max-w-7xl mx-auto pt-4 px-4 sm:px-6 lg:px-8">
        <a href="./" class="inline-flex items-center px-4 py-2 border border-gray-300 shadow-sm text-sm font-medium rounded-md text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500 transition duration-150">
            <svg class="-ml-1 mr-2 h-5 w-5" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor" aria-hidden="true">
                <path fill-rule="evenodd" d="M12.707 5.293a1 1 0 010 1.414L9.414 10l3.293 3.293a1 1 0 01-1.414 1.414l-4-4a1 1 0 010-1.414l4-4a1 1 0 011.414 0z" clip-rule="evenodd" />
            </svg>
            Go Back to Home
        </a>
    </div>

    <!-- Main Content Container (Role Selector) -->
    <div class="flex items-center justify-center py-10">
        <div class="w-full max-w-2xl bg-white p-10 rounded-xl shadow-2xl transition duration-300 ease-in-out border border-gray-100">
            
            <div class="text-center mb-10">
                <h1 class="text-3xl font-bold text-gray-800">Select Your Registration Type</h1>
                <p class="text-gray-500 mt-2">Are you joining as a Student or a Teacher?</p>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-8">
                
                <!-- Student Card -->
                <a href="registerAsStudent.jsp" class="block p-6 border-4 border-blue-200 rounded-xl shadow-lg hover:shadow-xl transition duration-300 ease-in-out transform hover:scale-[1.02] cursor-pointer bg-blue-50 group">
                    <div class="text-center">
                        <svg class="mx-auto h-12 w-12 text-blue-600 group-hover:text-blue-700 transition" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 21h7a2 2 0 002-2V9.414a1 1 0 00-.293-.707l-5.414-5.414A1 1 0 0012.586 3H7a2 2 0 00-2 2v14a2 2 0 002 2h3zM10 16v-2m4 2v-2m-4-4h4m-4-4h4"></path></svg>
                        <h2 class="mt-4 text-xl font-semibold text-gray-900 group-hover:text-blue-800">Register as Student</h2>
                        <p class="mt-1 text-gray-600">Enroll in courses and submit assignments.</p>
                        <span class="mt-4 inline-block text-blue-600 font-bold">Start &rarr;</span>
                    </div>
                </a>

                <!-- Teacher Card -->
                <a href="registerAsTeacher.jsp" class="block p-6 border-4 border-green-200 rounded-xl shadow-lg hover:shadow-xl transition duration-300 ease-in-out transform hover:scale-[1.02] cursor-pointer bg-green-50 group">
                    <div class="text-center">
                         <svg class="mx-auto h-12 w-12 text-green-600 group-hover:text-green-700 transition" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm-6-6v4m0 0h-3v-4m3 4v-4m0 4h3v-4m-3-4a7 7 0 00-7 7v4h14v-4a7 7 0 00-7-7z"></path></svg>
                        <h2 class="mt-4 text-xl font-semibold text-gray-900 group-hover:text-green-800">Register as Teacher</h2>
                        <p class="mt-1 text-gray-600">Create courses and manage classes.</p>
                        <span class="mt-4 inline-block text-green-600 font-bold">Start &rarr;</span>
                    </div>
                </a>
            </div>

            <p class="mt-10 text-center text-sm text-gray-600">
                Already have an account? 
                <a href="login" class="font-medium text-blue-600 hover:text-blue-500 hover:underline">Login Here</a>
            </p>

        </div>
    </div>
</body>
</html>