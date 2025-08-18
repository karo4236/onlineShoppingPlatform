<%@ page import="java.sql.*, java.io.*, java.util.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Product Added</title>
</head>
<body>

<%
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String user = "sa", password = "304#sa#pw";

    // Collect form data
    String productName = request.getParameter("productName");
    double productPrice = Double.parseDouble(request.getParameter("productPrice"));
    String productDesc = request.getParameter("productDesc");
    int categoryId = Integer.parseInt(request.getParameter("categoryId"));

    // Insert into database
    try (Connection con = DriverManager.getConnection(url, user, password)) {
        String sql = "INSERT INTO product (productName, productPrice, productDesc, categoryId, productImageURL, productImage) " +
                     "VALUES (?, ?, ?, ?, NULL, NULL)";  // Set productImageURL and productImage to NULL

        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, productName);
            stmt.setDouble(2, productPrice);
            stmt.setString(3, productDesc);
            stmt.setInt(4, categoryId);

            int rowsAffected = stmt.executeUpdate();
            if (rowsAffected > 0) {
                out.println("<h3>Product added successfully!</h3>");
            } else {
                out.println("<h3>Error: Product could not be added.</h3>");
            }
        }
    } catch (SQLException e) {
        out.println("<h3>Error: " + e.getMessage() + "</h3>");
    }
%>

<a href="admin.jsp">Back to Administrator Page</a>

</body>
</html>
