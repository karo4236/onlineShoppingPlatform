<!DOCTYPE html>
<html>
<head>
<title>Customer Page</title>
</head>
<body>

<%@ include file="auth.jsp" %>
<%@ page import="java.text.NumberFormat, java.sql.*" %>
<%@ include file="jdbc.jsp" %>

<% 
// 修改1: 检查用户是否已登录
String userName = (String) session.getAttribute("authenticatedUser");
if (userName == null) {
    if (!response.isCommitted()) {
        response.sendRedirect("login.jsp"); // 未登录用户将被重定向到 login.jsp
    }
    return;
}
%>

<h3>Welcome, <%= userName %>!</h3>

<%
// 修改2: 从数据库中查询并显示客户信息
String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
String user = "sa", password = "304#sa#pw";

try (Connection con = DriverManager.getConnection(url, user, password);
     PreparedStatement stmt = con.prepareStatement("SELECT * FROM customer WHERE userid = ?")) {

    // Use prepared statement parameterized query to avoid SQL injection
    stmt.setString(1, userName);
    
    try (ResultSet rst = stmt.executeQuery()) {
        if (rst.next()) {
            int customId = rst.getInt(1);
            String first = rst.getString(2);
            String last = rst.getString(3);
            String email = rst.getString(4);
            String phone = rst.getString(5);
            String address = rst.getString(6);
            String city = rst.getString(7);
            String state = rst.getString(8);
            String postal = rst.getString(9);
            String country = rst.getString(10);
            String userid = rst.getString(11);
    
            out.println("<table align='center' class='table' border='2px'>");
            out.println("<tr><th><b>Id</b></th><td align='center'>" + rst.getInt(1) + "</td></tr>");
            out.println("<tr><th><b>First Name</b></th><td align='center'>" + first + "</td></tr>");
            out.println("<tr><th><b>Last Name</b></th><td align='center'>" + last + "</td></tr>");
            out.println("<tr><th><b>Email</b></th><td align='center'>" + email + "</td></tr>");
            out.println("<tr><th><b>Phone Number</b></th><td align='center'>" + phone + "</td></tr>");
            out.println("<tr><th><b>Address</b></th><td align='center'>" + address + "</td></tr>");
            out.println("<tr><th><b>City</b></th><td align='center'>" + city + "</td></tr>");
            out.println("<tr><th><b>State</b></th><td align='center'>" + state + "</td></tr>");
            out.println("<tr><th><b>Postal Code</b></th><td align='center'>" + postal + "</td></tr>");
            out.println("<tr><th><b>Country</b></th><td align='center'>" + country + "</td></tr>");
            out.println("<tr><th><b>User id</b></th><td align='center'>" + userid + "</td></tr>");
            out.println("</table>");
    
        } else {
            out.println("<h4>No customer information found.</h4>");
        }
    }
} catch (SQLException ex) {
    out.println("<h4>Error: " + ex.getMessage() + "</h4>");
}

%>

</body>
</html>
