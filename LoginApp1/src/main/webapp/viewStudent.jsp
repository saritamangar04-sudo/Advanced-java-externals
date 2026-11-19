<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="com.loginapp.util.DBUtil" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Directory - LoginApp1</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .page-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 24px;
            flex-wrap: wrap;
            gap: 16px;
        }
        .header-title h2 {
            font-size: 24px;
            margin-bottom: 4px;
        }
        .header-title p {
            color: var(--text-muted);
            font-size: 14px;
        }
    </style>
</head>
<body style="justify-content: flex-start;">

<div class="portal-wrapper">
    <div class="card" style="padding: 28px 32px;">
        <div class="page-header">
            <div class="header-title">
                <h2>Student Records Directory</h2>
                <p>Centralized view of all enrolled students in LoginDB</p>
            </div>
            <div style="display: flex; gap: 10px; align-items: center; flex-wrap: wrap;">
                <a href="info.html" class="btn-primary" style="padding: 9px 16px; font-size: 13.5px;">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round">
                        <line x1="12" y1="5" x2="12" y2="19"></line>
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                    </svg>
                    <span>Register Student</span>
                </a>
                <a href="login.html" class="btn-secondary">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M9 21H5a2 2 0 0 1-2-2V5a2 2 0 0 1 2-2h4"></path>
                        <polyline points="16 17 21 12 16 7"></polyline>
                        <line x1="21" y1="12" x2="9" y2="12"></line>
                    </svg>
                    <span>Portal Sign In</span>
                </a>
            </div>
        </div>

        <div class="top-action-bar">
            <div class="search-box">
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="color: var(--text-muted);">
                    <circle cx="11" cy="11" r="8"></circle>
                    <line x1="21" y1="21" x2="16.65" y2="16.65"></line>
                </svg>
                <input type="text" id="searchInput" placeholder="Filter by name, enrollment, batch..." onkeyup="filterTable()">
            </div>
            <div id="recordCountBadge" style="font-size: 13px; color: var(--text-muted); font-weight: 500;">
                Loading records...
            </div>
        </div>

        <div class="table-wrapper">
            <table class="data-table" id="studentsTable">
                <thead>
                    <tr>
                        <th style="width: 50px;">#</th>
                        <th>Student Name</th>
                        <th>Enrollment No</th>
                        <th>Batch</th>
                        <th>Official Email</th>
                        <th>Mobile</th>
                        <th>Date of Birth</th>
                        <th>Address</th>
                        <th>City & State</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    Connection con = null;
                    Statement stmt = null;
                    ResultSet rs = null;
                    int count = 0;

                    try {
                        try {
                            con = DBUtil.getConnection();
                        } catch (Throwable t) {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/LoginDB?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC", "root", "ricK999_@777");
                        }

                        stmt = con.createStatement();
                        rs = stmt.executeQuery("SELECT id, name, enrollment_no, batch, official_email, mobile_number, dob, address, state, city FROM Student ORDER BY id DESC");

                        while (rs.next()) {
                            count++;
                            String studentName = rs.getString("name") != null ? rs.getString("name") : "-";
                            String enrollNo = rs.getString("enrollment_no") != null ? rs.getString("enrollment_no") : "-";
                            String batch = rs.getString("batch") != null ? rs.getString("batch") : "-";
                            String email = rs.getString("official_email") != null ? rs.getString("official_email") : "-";
                            String mobile = rs.getString("mobile_number") != null ? rs.getString("mobile_number") : "-";
                            Date dob = rs.getDate("dob");
                            String address = rs.getString("address") != null ? rs.getString("address") : "-";
                            String state = rs.getString("state") != null ? rs.getString("state") : "";
                            String city = rs.getString("city") != null ? rs.getString("city") : "";
                            String location = (!city.isEmpty() ? city + ", " : "") + state;
                %>
                    <tr>
                        <td style="color: var(--text-muted); font-weight: 600;"><%= count %></td>
                        <td style="font-weight: 600; color: var(--dark);"><%= studentName %></td>
                        <td><span class="badge-tag"><%= enrollNo %></span></td>
                        <td><%= batch %></td>
                        <td><a href="mailto:<%= email %>" style="color: var(--primary); text-decoration: none;"><%= email %></a></td>
                        <td><%= mobile %></td>
                        <td style="white-space: nowrap;"><%= dob != null ? dob.toString() : "-" %></td>
                        <td><%= address %></td>
                        <td><%= !location.isEmpty() ? location : "-" %></td>
                    </tr>
                <%
                        }

                        if (count == 0) {
                %>
                    <tr>
                        <td colspan="9" class="empty-state">
                            <p style="font-size: 15px; margin-bottom: 12px;">No student records found in LoginDB.</p>
                            <a href="info.html" class="btn-primary" style="display: inline-flex; width: auto; padding: 8px 16px;">Add First Student</a>
                        </td>
                    </tr>
                <%
                        }
                    } catch (Exception e) {
                %>
                    <tr>
                        <td colspan="9" style="text-align: center; color: var(--danger); padding: 24px;">
                            <b>Database Query Error:</b> <%= e.getMessage() %>
                        </td>
                    </tr>
                <%
                    } finally {
                        if (rs != null) try { rs.close(); } catch (Exception ignored) {}
                        if (stmt != null) try { stmt.close(); } catch (Exception ignored) {}
                        if (con != null) try { con.close(); } catch (Exception ignored) {}
                    }
                %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script>
    const totalCount = <%= count %>;
    document.getElementById('recordCountBadge').textContent = 'Total Enrolled: ' + totalCount + (totalCount === 1 ? ' student' : ' students');

    function filterTable() {
        const input = document.getElementById('searchInput');
        const filter = input.value.toLowerCase();
        const table = document.getElementById('studentsTable');
        const trs = table.getElementsByTagName('tr');

        let visibleCount = 0;
        for (let i = 1; i < trs.length; i++) {
            const row = trs[i];
            const text = row.textContent.toLowerCase();
            if (text.indexOf(filter) > -1) {
                row.style.display = '';
                visibleCount++;
            } else {
                row.style.display = 'none';
            }
        }
        document.getElementById('recordCountBadge').textContent = 'Showing ' + visibleCount + ' of ' + totalCount + ' students';
    }
</script>

</body>
</html>