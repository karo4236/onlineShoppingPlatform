<%@ page import="java.sql.*" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<html>
<head>
<title>Processing Order</title>
</head>
<body>

<%
    // Session management: check if the user is authenticated
    //HttpSession session = request.getSession(false);
    if (session == null || session.getAttribute("authenticatedUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String customerId = request.getParameter("customerId");
    String password = request.getParameter("password");
    String creditCard = request.getParameter("creditCard");
    String expiryDate = request.getParameter("expiryDate");
    String shiptoAddress = request.getParameter("shiptoAddress");
    String shiptoCity = request.getParameter("shiptoCity");
    String shiptoState = request.getParameter("shiptoState");
    String shiptoPostalCode = request.getParameter("shiptoPostalCode");
    String shiptoCountry = request.getParameter("shiptoCountry");

    // Basic data validation
    if (customerId == null || password == null || creditCard == null || expiryDate == null ||
        shiptoAddress == null || shiptoCity == null || shiptoState == null || shiptoPostalCode == null || shiptoCountry == null ||
        customerId.isEmpty() || password.isEmpty() || creditCard.isEmpty() || expiryDate.isEmpty() ||
        shiptoAddress.isEmpty() || shiptoCity.isEmpty() || shiptoState.isEmpty() || shiptoPostalCode.isEmpty() || shiptoCountry.isEmpty()) {
        out.println("<h1>Error: All fields are required.</h1>");
        return;
    }

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    try {
        // Establish a connection to the database
        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
        String dbUser = "sa";
        String dbPassword = "304#sa#pw";
        conn = DriverManager.getConnection(url, dbUser, dbPassword);

        // Verify customer credentials
        String sqlVerifyCustomer = "SELECT * FROM customer WHERE customerId = ? AND password = ?";
        ps = conn.prepareStatement(sqlVerifyCustomer);
        ps.setString(1, customerId);
        ps.setString(2, password);
        rs = ps.executeQuery();

        if (!rs.next()) {
            out.println("<h1>Error: Invalid customer ID or password.</h1>");
            return;
        }

        // Insert order summary into database
        String sqlInsertOrder = "INSERT INTO ordersummary (customerId, orderDate, totalAmount, shiptoAddress, shiptoCity, shiptoState, shiptoPostalCode, shiptoCountry) VALUES (?, GETDATE(), 0.00, ?, ?, ?, ?, ?)";
        ps = conn.prepareStatement(sqlInsertOrder, Statement.RETURN_GENERATED_KEYS);
        ps.setInt(1, Integer.parseInt(customerId)); // Make sure customerId is an integer
        ps.setString(2, shiptoAddress);
        ps.setString(3, shiptoCity);
        ps.setString(4, shiptoState);
        ps.setString(5, shiptoPostalCode);
        ps.setString(6, shiptoCountry);
        ps.executeUpdate();

        // Get the generated order ID
        rs = ps.getGeneratedKeys();
        int orderId = 0;
        if (rs.next()) {
            orderId = rs.getInt(1);
        }

        // Calculate taxes and shipping costs
        double taxRate = 0.0;
        if (shiptoState.equalsIgnoreCase("CA")) {
            taxRate = 0.075; // Example tax rate for California
        } else if (shiptoState.equalsIgnoreCase("NY")) {
            taxRate = 0.085; // Example tax rate for New York
        }

        double shippingCost = 5.00; // Flat shipping rate for demonstration
        double orderSubtotal = 100.00; // Example subtotal, replace with actual calculation
        double totalAmount = (orderSubtotal * (1 + taxRate)) + shippingCost;

        // Update the totalAmount in the database
        String sqlUpdateOrder = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";
        ps = conn.prepareStatement(sqlUpdateOrder);
        ps.setDouble(1, totalAmount);
        ps.setInt(2, orderId);
        ps.executeUpdate();

        // Insert shipment details for the order
        String sqlInsertShipment = "INSERT INTO shipment (shipmentDate, shipmentDesc, warehouseId) VALUES (GETDATE(), ?, ?)";
        ps = conn.prepareStatement(sqlInsertShipment);
        ps.setString(1, "Initial Shipment"); // Example shipment description
        ps.setInt(2, 1); // Assuming warehouseId 1 for demonstration, this can be dynamic
        ps.executeUpdate();

        // Insert a second shipment (for demonstration purposes)
        ps.setString(1, "Second Shipment"); // Example shipment description
        ps.setInt(2, 1); // Assuming same warehouse
        ps.executeUpdate();

        out.println("<h1>Order processed successfully with multiple shipments!</h1>");
        out.println("<p>Order ID: " + orderId + "</p>");
        out.println("<p>Total Amount: $" + totalAmount + "</p>");

    } catch (Exception e) {
        out.println("Error: " + e.getMessage());
    } finally {
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.println("Error closing resources: " + e.getMessage());
        }
    }
%>

<!-- Link to return to the main page -->
<a href="index.jsp">Go back to main page</a>

</body>
</html>
