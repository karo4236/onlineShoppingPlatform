<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<!DOCTYPE html>
<html>
<head>
    <title>Ray's Grocery Main Page</title>
    <style>
        body {
            background-color: #BFEFFF;
            font-family: Arial, sans-serif;
            color: #333;
            margin: 0;
            padding: 0;
        }

        h1 {
            color: #0077b3;
            text-align: center;
            margin-top: 20px;
        }

        h2 {
            text-align: center;
            margin: 10px 0;
        }

        a {
            text-decoration: none;
            color: #0077b3;
            font-weight: bold;
        }

        a:hover {
            color: #004d66;
        }

        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            border-radius: 8px;
            overflow: hidden;
        }

        th, td {
            padding: 10px;
            text-align: center;
            border: 1px solid #ccc;
        }

        th {
            background-color: #0077b3;
            color: white;
        }

        td {
            background-color: #f1f1f1;
        }

        tr:nth-child(even) td {
            background-color: #e6f7ff;
        }

        .container {
            width: 90%;
            margin: 0 auto;
            text-align: center;
        }

        .section-title {
            color: #004d66;
            margin-bottom: 15px;
        }

        .button-link {
            background-color: #0077b3;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
        }

        .button-link:hover {
            background-color: #004d66;
        }

        .login-logout-button {
            background-color: #ff6f61;  
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            text-decoration: none;
            margin: 10px;
        }

        .login-logout-button:hover {
            background-color: #e65c54; 
        }

        .message {
            color: red;
            font-size: 1.1em;
        }

        .bottom-image {
            width: 100%;
            margin-top: 20px;
        }
    </style>
</head>
<body>

<h1>Welcome to doujiao's Grocery</h1>

<div class="container">
    <h2><a href="login.jsp" class="login-logout-button">Login</a></h2>

    <% 
        // 检查用户是否已登录
        String userName = (String) session.getAttribute("authenticatedUser");

        if (userName == null) {
            // 用户未登录，显示“创建账户”按钮
    %>
            <h2><a href="createAcc.jsp" class="button-link">Create Account</a></h2>
    <%
        } else {
            // 用户已登录，显示欢迎信息
            out.println("<h3>Welcome, " + userName + "!</h3>");
        }
    %>

    <h2><a href="listprod.jsp" class="button-link">Begin Shopping</a></h2>
    <h2><a href="listorder.jsp" class="button-link">List All Orders</a></h2>
    <h2><a href="customer.jsp" class="button-link">Customer Info</a></h2>
    <h2><a href="admin.jsp" class="button-link">Administrators</a></h2> <!-- 修改后的代码，直接链接到 adminLogin.jsp -->
    <h2><a href="logout.jsp" class="login-logout-button">Log out</a></h2>
    <h2><a href="displayInventory.jsp" class="button-link">inventory</a></h2>
</div>

<%
    Integer customerId = null;

    // If user is logged in, fetch customerId dynamically
    if (userName != null) {
        try {
            String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True;";
            String uid = "sa";
            String pw = "304#sa#pw";

            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            try (Connection con = DriverManager.getConnection(url, uid, pw)) {
                String sql = "SELECT customerId FROM customer WHERE userid = ?";
                try (PreparedStatement pstmt = con.prepareStatement(sql)) {
                    pstmt.setString(1, userName);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            customerId = rs.getInt("customerId");
                        }
                    }
                }
            }
        } catch (Exception e) {
            out.println("<p>Error retrieving customer ID: " + e.getMessage() + "</p>");
        }
    }

    if (userName != null) {
        out.println("<h3 align='center'>Signed in as: " + userName + "</h3>");
    } else {
        out.println("<p align='center'>Please log in to see personalized recommendations.</p>");
    }

    // Database connection for product recommendations and top-selling products
    try {
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True;";
        String uid = "sa";
        String pw = "304#sa#pw";

        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        try (Connection con = DriverManager.getConnection(url, uid, pw)) {

            // Top 10 best-selling products query
            String topProductsSql = 
                "SELECT TOP 10 p.productId, p.productName, p.productPrice, SUM(op.quantity) AS totalSales " +
                "FROM product p " +
                "JOIN orderproduct op ON p.productId = op.productId " +
                "GROUP BY p.productId, p.productName, p.productPrice " +
                "ORDER BY totalSales DESC";
            try (PreparedStatement pstmt = con.prepareStatement(topProductsSql);
                 ResultSet rs = pstmt.executeQuery()) {

                out.println("<h3 align='center'>Top 10 Best-Selling Products:</h3>");
                out.println("<table align='center' border='1'>");
                out.println("<tr><th>Product Name</th><th>Price</th><th>Total Sales</th><th>View Details</th></tr>");

                while (rs.next()) {
                    int productId = rs.getInt("productId");
                    String productName = rs.getString("productName");
                    double productPrice = rs.getDouble("productPrice");
                    int totalSales = rs.getInt("totalSales");

                    out.println("<tr>");
                    out.println("<td>" + productName + "</td>");
                    out.println("<td>$" + productPrice + "</td>");
                    out.println("<td>" + totalSales + "</td>");
                    out.println("<td><a href='product.jsp?id=" + productId + "'>View</a></td>");
                    out.println("</tr>");
                }
                out.println("</table>");
            }

            // Personalized recommendations if customerId is available
            if (customerId != null) {
                String recommendationsSql = 
                    "SELECT TOP 2 p.productId, p.productName, p.productPrice " +
                    "FROM orderproduct op1 " +
                    "JOIN orderproduct op2 ON op1.orderId = op2.orderId AND op1.productId != op2.productId " +
                    "JOIN product p ON op2.productId = p.productId " +
                    "JOIN ordersummary os ON op1.orderId = os.orderId " +
                    "WHERE os.customerId = ? " +
                    "GROUP BY p.productId, p.productName, p.productPrice " +
                    "ORDER BY COUNT(*) DESC";
                try (PreparedStatement pstmt = con.prepareStatement(recommendationsSql)) {
                    pstmt.setInt(1, customerId);
                    try (ResultSet rs = pstmt.executeQuery()) {
                        if (rs.next()) {
                            out.println("<h3 align='center'>Recommended Products for You:</h3>");
                            out.println("<table align='center' border='1'>");
                            out.println("<tr><th>Product Name</th><th>Price</th><th>View Details</th></tr>");

                            do {
                                int productId = rs.getInt("productId");
                                String productName = rs.getString("productName");
                                double productPrice = rs.getDouble("productPrice");

                                out.println("<tr>");
                                out.println("<td>" + productName + "</td>");
                                out.println("<td>$" + productPrice + "</td>");
                                out.println("<td><a href='product.jsp?id=" + productId + "'>View</a></td>");
                                out.println("</tr>");
                            } while (rs.next());

                            out.println("</table>");
                        } else {
                            out.println("<p align='center'>No personalized recommendations available.</p>");
                        }
                    }
                }
            }
        }
    } catch (Exception e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    }
%>

<img src="https://wx4.sinaimg.cn/orj480/007846BMgy1hucrdjtb16j30zk0k0wj3.jpg" alt="Grocery Image" class="bottom-image">

</body>
</html>
