package ocms.web;

/**
 * Model class for a Course object.
 */
public class Course {
    private int courseId;
    private String courseCode;
    private String courseTitle;
    private String courseDescription;
    private int teacherId;      // The ID of the user who teaches this course
    private String teacherName; // Optional: To display the teacher's name in the view

    // Constructor
    public Course() {}

    // Constructor for creating a new course (without ID)
    public Course(String courseCode, String courseTitle, String courseDescription, int teacherId) {
        this.courseCode = courseCode;
        this.courseTitle = courseTitle;
        this.courseDescription = courseDescription;
        this.teacherId = teacherId;
    }

    // Constructor for retrieving a course (with ID)
    public Course(int courseId, String courseCode, String courseTitle, String courseDescription, int teacherId) {
        this.courseId = courseId;
        this.courseCode = courseCode;
        this.courseTitle = courseTitle;
        this.courseDescription = courseDescription;
        this.teacherId = teacherId;
    }

    // Getter and Setter Methods
    
    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getCourseCode() {
        return courseCode;
    }

    public void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }

    public String getCourseTitle() {
        return courseTitle;
    }

    public void setCourseTitle(String courseTitle) {
        this.courseTitle = courseTitle;
    }

    public String getCourseDescription() {
        return courseDescription;
    }

    public void setCourseDescription(String courseDescription) {
        this.courseDescription = courseDescription;
    }

    public int getTeacherId() {
        return teacherId;
    }

    public void setTeacherId(int teacherId) {
        this.teacherId = teacherId;
    }

    public String getTeacherName() {
        return teacherName;
    }

    public void setTeacherName(String teacherName) {
        this.teacherName = teacherName;
    }
}