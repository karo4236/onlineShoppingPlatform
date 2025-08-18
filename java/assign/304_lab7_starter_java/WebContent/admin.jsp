<%@ page import="java.sql.*, java.text.NumberFormat, java.util.Locale" %>
<%@ include file="auth.jsp" %>  
<%@ include file="jdbc.jsp" %>  
<!DOCTYPE html>
<html>
<head>
    <title>Administrator Page</title>
</head>
<body>
    <% 
    // Check if the user is logged in; if not, redirect to login
    String userName = (String) session.getAttribute("authenticatedUser");
    if (userName == null) {
        if (!response.isCommitted()) {
            response.sendRedirect("login.jsp"); // Redirecting if not logged in
        }
        return;
    }
    %>
    <header>
        <nav>
            <ul>
                <!-- Show the currently logged-in user's name -->
                <li><a href='customer.jsp'><%= userName %></a></li>
                <li><a href='logout.jsp'>Sign Out</a></li>
            </ul>
        </nav>
    </header>

    <!-- Display Total Order Table -->
    <div>
        <% 
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String user = "sa", password = "304#sa#pw";
        
        // Display total order amount by day
        try (Connection con = DriverManager.getConnection(url, user, password);
             Statement stmt = con.createStatement();
             ResultSet rst = stmt.executeQuery(
                "SELECT YEAR(orderDate) AS Year, " +
                "MONTH(orderDate) AS Month, " +
                "DAY(orderDate) AS Day, " +
                "SUM(totalAmount) AS Total " +
                "FROM ordersummary " +
                "GROUP BY YEAR(orderDate), MONTH(orderDate), DAY(orderDate) " +
                "ORDER BY Year, Month, Day"
             )) {

            out.println("<h4>Total Order Amount by Day</h4>");
            out.println("<table border='1'>");
            out.println("<tr><th>Order Date</th><th>Total Order Amount</th></tr>");

            while (rst.next()) {
                String date = rst.getInt("Year") + "-" + rst.getInt("Month") + "-" + rst.getInt("Day");
                double totalSales = rst.getDouble("Total");
                out.println("<tr><td>" + date + "</td><td>" + NumberFormat.getCurrencyInstance(Locale.US).format(totalSales) + "</td></tr>");
            }
            out.println("</table>");
        } catch (SQLException ex) {
            out.println("<h4>Error: " + ex.getMessage() + "</h4>");
        }
        %>
    </div>

    <!-- Display Full Names of Customers Table -->
    <div>
        <% 
        // Fetch all customer names
        try (Connection con = DriverManager.getConnection(url, user, password);
             Statement stmt = con.createStatement();
             ResultSet rst = stmt.executeQuery(
                "SELECT firstName, lastName FROM customer ORDER BY lastName, firstName"
             )) {

            out.println("<h4>Full Names of Customers</h4>");
            out.println("<table border='1'>");
            out.println("<tr><th>Customer Name</th></tr>");

            while (rst.next()) {
                String firstName = rst.getString("firstName");
                String lastName = rst.getString("lastName");

                // Only display rows where both firstName and lastName are non-null
                if (firstName != null && lastName != null) {
                    String fullName = firstName + " " + lastName;
                    out.println("<tr><td>" + fullName + "</td></tr>");
                }
            }
            out.println("</table>");
        } catch (SQLException ex) {
            out.println("<h4>Error: " + ex.getMessage() + "</h4>");
        }
        %>
    </div>

    <h3>List of All Products</h3>
    
    <!-- Display Products Table -->
    <div>
        <% 
        // Fetch the products from the database
        try (Connection con = DriverManager.getConnection(url, user, password);
             Statement stmt = con.createStatement();
             ResultSet rst = stmt.executeQuery(
                "SELECT productId, productName, productPrice, productDesc FROM product ORDER BY productName"
             )) {

            out.println("<h4>Product List</h4>");
            out.println("<table border='1'>");
            out.println("<tr><th>Product Name</th><th>Price</th><th>Description</th><th>Action</th></tr>");

            while (rst.next()) {
                int productId = rst.getInt("productId");
                String productName = rst.getString("productName");
                double productPrice = rst.getDouble("productPrice");
                String productDesc = rst.getString("productDesc");

                out.println("<tr>");
                out.println("<td>" + productName + "</td>");
                out.println("<td>" + NumberFormat.getCurrencyInstance(Locale.US).format(productPrice) + "</td>");
                out.println("<td>" + productDesc + "</td>");
                out.println("<td><a href='admin.jsp?deleteProductId=" + productId + "'>Delete</a></td>");
                out.println("</tr>");
            }
            out.println("</table>");
        } catch (SQLException ex) {
            out.println("<h4>Error: " + ex.getMessage() + "</h4>");
        }
        %>
    </div>

    <!-- Add New Product Form -->
    <div>
        <h4>Add a New Product</h4>
        <form action="addProduct.jsp" method="post">
            <label for="productName">Product Name:</label><br>
            <input type="text" id="productName" name="productName" required><br><br>

            <label for="productPrice">Product Price:</label><br>
            <input type="number" id="productPrice" name="productPrice" step="0.01" required><br><br>

            <label for="productDesc">Product Description:</label><br>
            <textarea id="productDesc" name="productDesc" required></textarea><br><br>

            <label for="categoryId">Category ID:</label><br>
            <input type="number" id="categoryId" name="categoryId" required><br><br>

            <input type="submit" value="Add Product">
        </form>
    </div>

    <% 
    // If deleteProductId is passed in the URL, delete the corresponding product
    String deleteProductIdStr = request.getParameter("deleteProductId");
    if (deleteProductIdStr != null) {
        try {
            int deleteProductId = Integer.parseInt(deleteProductIdStr);

            // Delete the product from the database
            try (Connection con = DriverManager.getConnection(url, user, password)) {
                String sql = "DELETE FROM product WHERE productId = ?";
                try (PreparedStatement stmt = con.prepareStatement(sql)) {
                    stmt.setInt(1, deleteProductId);
                    int rowsAffected = stmt.executeUpdate();
                    if (rowsAffected > 0) {
                        out.println("<h3>Product with ID " + deleteProductId + " deleted successfully!</h3>");
                    } else {
                        out.println("<h3>Error: Product could not be deleted.</h3>");
                    }
                }
            }
        } catch (SQLException e) {
            out.println("<h3>Error: " + e.getMessage() + "</h3>");
        }
    }
    %>

</body>
</html>
