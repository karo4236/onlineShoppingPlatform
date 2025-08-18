<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<%
    // Retrieve form inputs
    String firstName = request.getParameter("firstName");
    String lastName = request.getParameter("lastName");
    String email = request.getParameter("email");
    String userId = request.getParameter("userId");
    String password = request.getParameter("password");
    String phoneNum = request.getParameter("phonenum");
    String address = request.getParameter("address");
    String city = request.getParameter("city");
    String state = request.getParameter("state");
    String postalCode = request.getParameter("postalcode");
    String country = request.getParameter("country");

    // Database connection details
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String uid = "sa";
    String pw = "304#sa#pw";

    Connection con = null;
    PreparedStatement pstmt = null;

    try {
        // Load SQL Server JDBC driver and establish connection
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        con = DriverManager.getConnection(url, uid, pw);

        // Prepare SQL statement to insert data into the customer table
        String sql = "INSERT INTO customer (firstName, lastName, email, phonenum, address, city, state, postalCode, country, userid, password) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, firstName);
        pstmt.setString(2, lastName);
        pstmt.setString(3, email);
        pstmt.setString(4, phoneNum);
        pstmt.setString(5, address);
        pstmt.setString(6, city);
        pstmt.setString(7, state);
        pstmt.setString(8, postalCode);
        pstmt.setString(9, country);
        pstmt.setString(10, userId);
        pstmt.setString(11, password);

        // Execute SQL statement
        int rows = pstmt.executeUpdate();
        
        if (rows > 0) {
            out.println("<h2>Account created successfully!</h2>");
            out.println("<p><a href='login.jsp'>Click here to login</a></p>");
        } else {
            out.println("<h2>Failed to create account. Please try again later.</h2>");
        }
    } catch (SQLException | ClassNotFoundException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.println("<p>Error closing resources: " + e.getMessage() + "</p>");
        }
    }
%>
