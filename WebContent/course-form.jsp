<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>
        <c:choose>
            <c:when test="${not empty requestScope.course}">
                Edit Course
            </c:when>
            <c:otherwise>
                Add New Course
            </c:otherwise>
        </c:choose>
    </title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f4f7f6;
        }
        .container {
            max-width: 600px;
            margin: 0 auto;
            background: white;
            padding: 30px;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1);
        }
        h1 {
            color: #2c3e50;
            border-bottom: 3px solid #3498db;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
            color: #34495e;
        }
        input[type="text"], textarea, select { /* Added select */
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
            box-sizing: border-box; 
        }
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        .submit-button {
            background-color: #2ecc71;
            color: white;
            padding: 10px 15px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-weight: bold;
            transition: background-color 0.3s;
        }
        .submit-button:hover {
            background-color: #27ae60;
        }
        .cancel-link {
            margin-left: 15px;
            color: #3498db;
            text-decoration: none;
        }
    </style>
</head>
<body>
    <div class="container">
        <c:choose>
            <c:when test="${not empty requestScope.course}">
                <h1>Edit Course</h1>
                <form action="CourseServlet" method="post">
                    <input type="hidden" name="action" value="update" />
                    <input type="hidden" name="id" value="<c:out value='${requestScope.course.courseId}' />" />
            </c:when>
            <c:otherwise>
                <h1>Add New Course</h1>
                <form action="CourseServlet" method="post">
                    <input type="hidden" name="action" value="insert" />
            </c:otherwise>
        </c:choose>

            <div class="form-group">
                <label for="code">Course Code:</label>
                <input type="text" id="code" name="code" value="<c:out value='${requestScope.course.courseCode}' />" required maxlength="10">
            </div>

            <div class="form-group">
                <label for="title">Title:</label>
                <input type="text" id="title" name="title" value="<c:out value='${requestScope.course.courseTitle}' />" required>
            </div>

            <div class="form-group">
                <label for="description">Description:</label>
                <textarea id="description" name="description" required><c:out value='${requestScope.course.courseDescription}' /></textarea>
            </div>
            
            <!-- TEACHER ASSIGNMENT DROPDOWN -->
            <div class="form-group">
                <label for="teacherId">Assigned Teacher:</label>
                <select id="teacherId" name="teacherId" required>
                    <c:forEach var="teacher" items="${requestScope.listTeachers}">
                        <option value="<c:out value='${teacher.userId}' />"
                            <c:if test="${teacher.userId == requestScope.course.teacherId}">
                                selected
                            </c:if>
                        >
                            <c:out value="${teacher.fullName}" />
                        </option>
                    </c:forEach>
                </select>
            </div>
            
            <button type="submit" class="submit-button">
                <c:choose>
                    <c:when test="${not empty requestScope.course}">Save Changes</c:when>
                    <c:otherwise>Add Course</c:otherwise>
                </c:choose>
            </button>
            <a href="CourseServlet?action=list" class="cancel-link">Cancel</a>
        </form>
    </div>
</body>
</html>