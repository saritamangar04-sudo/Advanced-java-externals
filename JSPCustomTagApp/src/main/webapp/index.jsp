<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="mylib.tld" prefix="t" %>
<%
    String actionParam = request.getParameter("action");
    if ("forward".equalsIgnoreCase(actionParam)) {
%>
<t:tags action="forward" page="thankyou.jsp"/>
<%
    } else {
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>JSP Page</title>
</head>
<body>

<h2>Custom tag that give forward and include actions</h2>

<!-- 1. Included action of custom tag (Output 1) -->
<t:tags action="include" page="welcome.jsp"/>

<p>This tag make JSP Simple and Reusable.</p>

<br>
<hr>
<!-- Quick link to view Output 2 (Forwarded action) without modifying code -->
<p>
    <b>To see the Forwarded Output:</b> 
    <a href="index.jsp?action=forward">Click here to test Forward Action &rarr;</a>
</p>

</body>
</html>
<%
    }
%>
