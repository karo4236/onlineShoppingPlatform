<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Inventory</title>
</head>
<body>

<%
    HashMap<String, ArrayList<Object>> inventoryList = (HashMap<String, ArrayList<Object>>) session.getAttribute("inventoryList");

    if (inventoryList == null) {
        out.println("<h1>Your inventory is empty!</h1>");
    } else {
        // Handle quantity increase or decrease
        for (String key : request.getParameterMap().keySet()) {
            if (key.startsWith("quantity_")) {
                String productId = key.substring(9); // Extract the productId
                String quantityStr = request.getParameter(key);
                try {
                    int quantity = Integer.parseInt(quantityStr);
                    if (quantity < 1) quantity = 1;

                    ArrayList<Object> product = inventoryList.get(productId);
                    if (product != null) {
                        product.set(3, quantity); // Update quantity in the list
                    }
                } catch (NumberFormatException e) {
                    out.println("<h1>Error: Invalid quantity for product " + productId + "</h1>");
                }
            }

            // Handle increase or decrease buttons
            if (key.startsWith("quantity_") && key.endsWith("_increase")) {
                String productId = key.substring(9, key.length() - 9); // Extract productId
                ArrayList<Object> product = inventoryList.get(productId);
                if (product != null) {
                    int currentQuantity = Integer.parseInt(product.get(3).toString());
                    product.set(3, currentQuantity + 1); // Increase quantity
                }
            }

            if (key.startsWith("quantity_") && key.endsWith("_decrease")) {
                String productId = key.substring(9, key.length() - 9); // Extract productId
                ArrayList<Object> product = inventoryList.get(productId);
                if (product != null) {
                    int currentQuantity = Integer.parseInt(product.get(3).toString());
                    if (currentQuantity > 1) {
                        product.set(3, currentQuantity - 1); // Decrease quantity
                    }
                }
            }
        }

        session.setAttribute("inventoryList", inventoryList);
    }

    // Redirect to the inventory page after update
    response.sendRedirect("editInventory.jsp");
%>

</body>
</html>
