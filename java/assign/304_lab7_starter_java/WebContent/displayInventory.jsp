<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.DecimalFormat" %>

<%
    // Database connection details
    String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
    String user = "sa";
    String password = "304#sa#pw";
    
    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;
    
    // Declare the inventory list outside the scriptlet
    ArrayList<HashMap<String, Object>> inventoryList = new ArrayList<>();
    
    try {
        // Establish the database connection
        conn = DriverManager.getConnection(url, user, password);
        
        // SQL query to fetch product inventory details
        String query = "SELECT p.productId, p.productName, w.warehouseId, w.warehouseName, pi.quantity, pi.price " +
                       "FROM productinventory pi " +
                       "JOIN product p ON pi.productId = p.productId " +
                       "JOIN warehouse w ON pi.warehouseId = w.warehouseId";
        
        // Prepare and execute the query
        ps = conn.prepareStatement(query);
        rs = ps.executeQuery();
        
        // Populate the inventory list
        while (rs.next()) {
            HashMap<String, Object> inventory = new HashMap<>();
            inventory.put("productId", rs.getInt("productId"));
            inventory.put("productName", rs.getString("productName"));
            inventory.put("warehouseId", rs.getInt("warehouseId"));
            inventory.put("warehouseName", rs.getString("warehouseName"));
            inventory.put("quantity", rs.getInt("quantity"));
            inventory.put("price", rs.getDouble("price"));
            inventoryList.add(inventory);
        }
    } catch (SQLException e) {
        out.println("Error occurred while fetching inventory data: " + e.getMessage());
    } finally {
        // Close the connection and resources in the finally block
        try {
            if (rs != null) rs.close();
            if (ps != null) ps.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            out.println("Error occurred while closing resources: " + e.getMessage());
        }
    }
%>

<!-- HTML Table to display inventory by warehouse -->
<h2>Inventory by Warehouse</h2>
<table border="1">
    <thead>
        <tr>
            <th>Product ID</th>
            <th>Product Name</th>
            <th>Warehouse ID</th>
            <th>Warehouse Name</th>
            <th>Quantity</th>
            <th>Price</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
        <% 
            // Use the inventoryList to display the data
            for (HashMap<String, Object> inventory : inventoryList) { 
        %>
        <tr>
            <td><%= inventory.get("productId") %></td>
            <td><%= inventory.get("productName") %></td>
            <td><%= inventory.get("warehouseId") %></td>
            <td><%= inventory.get("warehouseName") %></td>
            <td><%= inventory.get("quantity") %></td>
            <td><%= new DecimalFormat("0.00").format(inventory.get("price")) %></td>
            <td>
                <a href="editInventory.jsp?productId=<%= inventory.get("productId") %>&warehouseId=<%= inventory.get("warehouseId") %>">Edit</a>
            </td>
        </tr>
        <% 
            } // End of for loop
        %>
    </tbody>
</table>
