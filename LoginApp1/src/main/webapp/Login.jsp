<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.loginapp.util.DBUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Authentication Status</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="auth-wrapper">
    <div class="card">
<%
    String u = request.getParameter("user_id");
    String p = request.getParameter("password");

    if (u == null || u.trim().isEmpty() || p == null || p.trim().isEmpty()) {
%>
        <div class="status-badge error">
            <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="12" cy="12" r="10"></circle>
                <line x1="12" y1="8" x2="12" y2="12"></line>
                <line x1="12" y1="16" x2="12.01" y2="16"></line>
            </svg>
        </div>
        <div class="card-header">
            <h2>Missing Credentials</h2>
            <p>Please enter your user ID and password from the login page.</p>
        </div>
        <div style="margin-top: 20px;">
            <a href="login.html" class="btn-primary">Return to Sign In</a>
        </div>
<%
    } else {
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            // Obtain database connection
            try {
                con = DBUtil.getConnection();
            } catch (Throwable t) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                con = DriverManager.getConnection("jdbc:mysql://localhost:3306/LoginDB?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "ricK999_@777");
            }

            ps = con.prepareStatement("SELECT user_id FROM Login WHERE user_id=? AND password=?");
            ps.setString(1, u.trim());
            ps.setString(2, p.trim());

            rs = ps.executeQuery();

            if (rs.next()) {
                session.setAttribute("user", u.trim());
%>
                <div class="status-badge success">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M22 11.08V12a10 10 0 1 1-5.93-9.14"></path>
                        <polyline points="22 4 12 14.01 9 11.01"></polyline>
                    </svg>
                </div>
                <div class="card-header">
                    <h2>Login Successful!</h2>
                    <p>Welcome back, <b><%= u.trim() %></b>.</p>
                </div>

                <div style="display: flex; flex-direction: column; gap: 10px; margin-top: 24px;">
                    <a href="viewStudent.jsp" class="btn-primary">View Student Directory</a>
                    <a href="info.html" class="btn-secondary">Register New Student</a>
                    <a href="login.html" class="btn-secondary" style="background: transparent; color: var(--text-muted);">Sign Out</a>
                </div>
<%
            } else {
%>
                <div class="status-badge error">
                    <svg width="32" height="32" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"></circle>
                        <line x1="15" y1="9" x2="9" y2="15"></line>
                        <line x1="9" y1="9" x2="15" y2="15"></line>
                    </svg>
                </div>
                <div class="card-header">
                    <h2>Invalid Credentials</h2>
                    <p>The User ID or Password you entered does not match our records.</p>
                </div>

                <div style="display: flex; flex-direction: column; gap: 10px; margin-top: 24px;">
                    <a href="login.html" class="btn-primary">Try Again</a>
                    <a href="info.html" class="btn-secondary">Register New Student</a>
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
                <h2>Database Connection Error</h2>
                <p style="color: var(--danger); font-weight: 500;"><%= e.getMessage() %></p>
            </div>
            <div style="margin-top: 20px;">
                <a href="login.html" class="btn-primary">Back to Login</a>
            </div>
<%
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception ignored) {}
            if (ps != null) try { ps.close(); } catch (Exception ignored) {}
            if (con != null) try { con.close(); } catch (Exception ignored) {}
        }
    }
%>
    </div>
</div>

</body>
</html>