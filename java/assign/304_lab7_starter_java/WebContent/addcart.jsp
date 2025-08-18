<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.DecimalFormat" %>
<%
// Get the current list of products from the session
@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

// If no product list exists, create a new one
if (productList == null) {
    productList = new HashMap<String, ArrayList<Object>>();
}

// Get product details from the request
String id = request.getParameter("id");
String name = request.getParameter("name");
String priceStr = request.getParameter("price");
Integer quantity = 1; // Default quantity is 1

// Parse the price to a Double (better handling of numeric values)
Double price = null;
try {
    price = Double.parseDouble(priceStr);
} catch (NumberFormatException e) {
    // Handle invalid price format gracefully
    price = 0.0;
}

// Store product information in an ArrayList
ArrayList<Object> product = new ArrayList<Object>();
product.add(id);        // Product ID
product.add(name);      // Product Name
product.add(price);     // Product Price
product.add(quantity);  // Product Quantity

// Update quantity if the same product is added again
if (productList.containsKey(id)) {
    // Retrieve the existing product
    ArrayList<Object> existingProduct = productList.get(id);
    
    // Update the quantity (if the product already exists)
    int currentQuantity = (Integer) existingProduct.get(3);
    existingProduct.set(3, currentQuantity + quantity);  // Increment quantity
    
    // Optionally, update price if the product has different prices (if required)
    // existingProduct.set(2, price); // Uncomment if price can vary for the same product
} else {
    // Add new product if it doesn't exist already
    productList.put(id, product);
}

// Save updated product list back to the session
session.setAttribute("productList", productList);
%>

<!-- Redirect to showcart.jsp -->
<jsp:forward page="showcart.jsp" />
