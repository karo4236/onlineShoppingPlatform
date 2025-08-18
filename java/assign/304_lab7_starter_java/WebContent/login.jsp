<%@ page language="java" import="java.io.*,java.sql.*" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login Screen</title>
</head>
<body>

<div style="margin:0 auto;text-align:center;display:inline">

    <h3>Please Login to System</h3>

    <%
        // 检查并显示之前的登录错误消息
        if (session != null) {
            String loginMessage = (String) session.getAttribute("loginMessage");
            if (loginMessage != null) {
                out.println("<p>" + loginMessage + "</p>");
                session.removeAttribute("loginMessage"); // 删除消息以避免重复显示
            }
        }
    %>

    <br>
    <form id="loginForm" name="MyForm" method="post" action="validateLogin.jsp">
        <table style="display:inline">
            <tr>
                <td>
                    <div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Username:</font></div>
                </td>
                <td><input type="text" name="username" size="10" maxlength="50" required></td>
            </tr>
            <tr>
                <td>
                    <div align="right"><font face="Arial, Helvetica, sans-serif" size="2">Password:</font></div>
                </td>
                <td><input type="password" name="password" size="10" maxlength="50" required></td>
            </tr>
        </table>
        <br/>
        <input class="submit" type="submit" name="Submit2" value="Log In">
    </form>

    <a href="index.jsp">Go back to main page</a>
</div>

</body>
</html>