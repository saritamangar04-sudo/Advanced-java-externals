<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.loginapp.util.DBUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Registration Status</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="auth-wrapper" style="max-width: 540px;">
    <div class="card">
<%
    String name = request.getParameter("name");
    String enrollmentNo = request.getParameter("enrollment_no");
    String batch = request.getParameter("batch");
    String officialEmail = request.getParameter("official-email");
    String mobileNumber = request.getParameter("mobile_number");
    String dob = request.getParameter("dob");
    String address = request.getParameter("address");
    String state = request.getParameter("state");
    String city = request.getParameter("city");

    if (name == null || enrollmentNo == null || name.trim().isEmpty() || enrollmentNo.trim().isEmpty()) {
%>
        <div class="status-badge error">
            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
        </div>
        <div class="card-header">
            <h2>Form Not Submitted</h2>
            <p>Please fill out the student registration form first before viewing this page.</p>
        </div>
        <div style="margin-top: 20px;">
            <a href="info.html" class="btn-primary">Go to Registration Form</a>
        </div>
<%
    } else {
        Connection con = null;
        PreparedStatement psStudent = null;
        PreparedStatement psLogin = null;

        try {
            try {
                con = DBUtil.getConnection();
            } catch (Throwable t) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/LoginDB?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "ricK999_@777");
            }

            // Insert into Student table
            String studentQuery = "INSERT INTO Student (name, enrollment_no, batch, official_email, mobile_number, dob, address, state, city) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
            psStudent = con.prepareStatement(studentQuery);
            psStudent.setString(1, name.trim());
            psStudent.setString(2, enrollmentNo.trim());
            psStudent.setString(3, batch != null ? batch.trim() : "");
            psStudent.setString(4, officialEmail != null ? officialEmail.trim() : "");
            psStudent.setString(5, mobileNumber != null ? mobileNumber.trim() : "");
            
            if (dob != null && !dob.trim().isEmpty()) {
                try {
                    psStudent.setDate(6, java.sql.Date.valueOf(dob.trim()));
                } catch (Exception ex) {
                    psStudent.setNull(6, java.sql.Types.DATE);
                }
            } else {
                psStudent.setNull(6, java.sql.Types.DATE);
            }
            
            psStudent.setString(7, address != null ? address.trim() : "");
            psStudent.setString(8, state != null ? state.trim() : "");
            psStudent.setString(9, city != null ? city.trim() : "");

            int rows = psStudent.executeUpdate();

            if (rows > 0) {
                // Also create Login credential (user_id = enrollment_no, password = mobile_number)
                try {
                    String loginQuery = "INSERT INTO Login (user_id, password) VALUES (?, ?)";
                    psLogin = con.prepareStatement(loginQuery);
                    psLogin.setString(1, enrollmentNo.trim());
                    psLogin.setString(2, mobileNumber != null ? mobileNumber.trim() : "1234");
                    psLogin.executeUpdate();
                } catch (Exception ignored) {
                    // Ignore duplicate login record
                }
%>
                <div class="status-badge success">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <polyline points="20 6 9 17 4 12"></polyline>
                    </svg>
                </div>

                <div class="card-header">
                    <h2>Registration Successful!</h2>
                    <p>The student profile has been registered into the database.</p>
                </div>

                <table class="info-summary-table">
                    <tr>
                        <td class="label">Full Name</td>
                        <td class="value"><%= name %></td>
                    </tr>
                    <tr>
                        <td class="label">Enrollment No</td>
                        <td class="value"><span class="badge-tag"><%= enrollmentNo %></span></td>
                    </tr>
                    <tr>
                        <td class="label">Batch</td>
                        <td class="value"><%= batch != null ? batch : "N/A" %></td>
                    </tr>
                    <tr>
                        <td class="label">Email</td>
                        <td class="value"><%= officialEmail != null ? officialEmail : "N/A" %></td>
                    </tr>
                    <tr>
                        <td class="label">Mobile</td>
                        <td class="value"><%= mobileNumber != null ? mobileNumber : "N/A" %></td>
                    </tr>
                    <tr>
                        <td class="label">Location</td>
                        <td class="value"><%= (city != null && !city.isEmpty() ? city + ", " : "") + (state != null ? state : "") %></td>
                    </tr>
                </table>

                <p style="font-size: 13px; color: var(--text-muted); margin-bottom: 20px;">
                    Login Credentials: User ID = <b><%= enrollmentNo %></b>, Password = <b><%= mobileNumber %></b>
                </p>

                <div style="display: flex; flex-direction: column; gap: 10px;">
                    <a href="login.html" class="btn-primary">Proceed to Sign In</a>
                    <a href="viewStudent.jsp" class="btn-secondary">View All Students</a>
                    <a href="info.html" class="btn-secondary" style="background: transparent;">Register Another Student</a>
                </div>
<%
            } else {
%>
                <div class="status-badge error">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="18" y1="6" x2="6" y2="18"></line>
                        <line x1="6" y1="6" x2="18" y2="18"></line>
                    </svg>
                </div>
                <div class="card-header">
                    <h2>Registration Incomplete</h2>
                    <p>Unable to store the record in the database. Please verify input values.</p>
                </div>
                <div style="margin-top: 20px;">
                    <a href="info.html" class="btn-primary">Try Again</a>
                </div>
<%
            }
        } catch (Exception e) {
%>
            <div class="status-badge error">
                <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                    <polygon points="7.86 2 16.14 2 22 7.86 22 16.14 16.14 22 7.86 22 2 16.14 2 7.86 7.86 2"></polygon>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
            </div>
            <div class="card-header">
                <h2>Database Error</h2>
                <p style="color: var(--danger); font-weight: 500;"><%= e.getMessage() %></p>
            </div>
            <div style="margin-top: 20px;">
                <a href="info.html" class="btn-primary">Return to Registration Form</a>
            </div>
<%
        } finally {
            if (psStudent != null) try { psStudent.close(); } catch (Exception ignored) {}
            if (psLogin != null) try { psLogin.close(); } catch (Exception ignored) {}
            if (con != null) try { con.close(); } catch (Exception ignored) {}
        }
    }
%>
    </div>
</div>

</body>
</html>