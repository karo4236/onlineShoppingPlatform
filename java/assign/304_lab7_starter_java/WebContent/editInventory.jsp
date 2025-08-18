<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Inventory</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 20px;
        }
        h1 {
            color: #008080;
            text-align: left;
        }
        table {
            width: 80%;
            margin: 20px auto;
            border-collapse: collapse;
            background-color: #ffffff;
        }
        th, td {
            padding: 10px;
            text-align: left;
            border: 1px solid #ddd;
        }
        th {
            background-color: #008080;
            color: white;
        }
        tr:nth-child(even) {
            background-color: #f2f2f2;
        }
        tr:hover {
            background-color: #ddd;
        }
        .quantity-buttons {
            display: flex;
            align-items: center;
        }
        .quantity-buttons button {
            padding: 5px 10px;
            font-size: 18px;
            cursor: pointer;
        }
        .quantity-buttons input {
            margin: 0 10px;
        }
    </style>
</head>
<body>

<%
    HashMap<String, ArrayList<Object>> inventoryList = (HashMap<String, ArrayList<Object>>) session.getAttribute("inventoryList");

    // Debugging: output session inventory data
    if (inventoryList == null || inventoryList.isEmpty()) {
        out.println("<h1>Your inventory is empty!</h1>");
        out.println("<p>Debugging: Inventory is empty or null in session.</p>");
    } else {
        out.println("<h1>Edit Inventory</h1>");
        out.println("<form action='updateInventory.jsp' method='post'>");
        out.println("<table><tr><th>Product ID</th><th>Product Name</th><th>Quantity</th><th>Actions</th></tr>");

        for (Map.Entry<String, ArrayList<Object>> entry : inventoryList.entrySet()) {
            ArrayList<Object> product = entry.getValue();
            String productId = entry.getKey();
            String productName = (String) product.get(1);
            int quantity = Integer.parseInt(product.get(3).toString());

            out.print("<tr>");
            out.print("<td>" + productId + "</td>");
            out.print("<td>" + productName + "</td>");
            out.print("<td><div class='quantity-buttons'>");
            out.print("<button type='submit' name='quantity_" + productId + "_increase'>+</button>");
            out.print("<input type='number' name='quantity_" + productId + "' value='" + quantity + "' min='1' style='width: 50px; text-align: center;'>");
            out.print("<button type='submit' name='quantity_" + productId + "_decrease'>-</button>");
            out.print("</div></td>");
            out.print("<td><button type='submit' name='remove' value='" + productId + "'>Remove</button></td>");
            out.print("</tr>");
        }

        out.println("</table>");
        out.println("<div style='text-align:center;'><input type='submit' name='update' value='Update Inventory'></div>");
        out.println("</form>");
    }
%>

<div class="footer-links">
    <h2><a href="listprod.jsp">Back to Product List</a></h2>
</div>

</body>
</html>
