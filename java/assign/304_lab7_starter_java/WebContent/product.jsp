<%@ page import="java.sql.*" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.io.IOException" %>
<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp" %>

<%
    String prodId = request.getParameter("id");
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rst = null;

    try {
        int productId = Integer.parseInt(prodId);

        String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True;";
        String uid = "sa";
        String pw = "304#sa#pw";

        Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
        con = DriverManager.getConnection(url, uid, pw);

        // Fetch product details
        String sql = "SELECT productName, productImageURL, productImage, productPrice, productDesc FROM product WHERE productId = ?";
        pstmt = con.prepareStatement(sql);
        pstmt.setInt(1, productId);
        rst = pstmt.executeQuery();

        if (rst.next()) {
            String productName = rst.getString("productName");
            out.println("<h2>" + (productName != null ? productName : "Product name not available") + "</h2>");

            String imageUrl = rst.getString("productImageURL");
            if (imageUrl != null) {
                out.println("<p><img src=\"" + imageUrl + "\"></p>");
            }

            String imageBinary = rst.getString("productImage");
            if (imageBinary != null) {
                out.println("<img src=\"displayImage.jsp?id=" + productId + "\">");
            }

            out.println("<h4><b>ID:</b> " + productId + "</h4>");
            out.println("<h4><b>Price:</b> $" + rst.getDouble("productPrice") + "</h4>");
            out.println("<h4><b>Description:</b> " + rst.getString("productDesc") + "</h4>");
            out.println("<h3><a href='addcart.jsp?id=" + productId + "&name=" + URLEncoder.encode(productName, "UTF-8") + "&price=" + rst.getDouble("productPrice") + "&newqty=1'>Add to cart</a></h3>");
            out.println("<h3><a href='listprod.jsp'>Continue Shopping</a></h3>");
        } else {
            out.println("<p>Product not found.</p>");
        }

        // Handle review submission
        String rate = request.getParameter("rating");
        String comment = request.getParameter("comment");
        String userid = request.getParameter("userid");

        if (rate != null && comment != null && userid != null) {
            // Check if the user purchased the product
            String purchaseCheckSQL = "SELECT COUNT(*) AS purchaseCount " +
                                      "FROM orderproduct op " +
                                      "JOIN ordersummary os ON op.orderId = os.orderId " +
                                      "WHERE os.customerId = ? AND op.productId = ?";
            try (PreparedStatement pstmtPurchaseCheck = con.prepareStatement(purchaseCheckSQL)) {
                pstmtPurchaseCheck.setInt(1, Integer.parseInt(userid));
                pstmtPurchaseCheck.setInt(2, productId);
                try (ResultSet rstPurchaseCheck = pstmtPurchaseCheck.executeQuery()) {
                    if (rstPurchaseCheck.next() && rstPurchaseCheck.getInt("purchaseCount") > 0) {
                        // Check if the user already reviewed the product
                        String checkSQL = "SELECT COUNT(*) AS reviewCount FROM review WHERE customerId = ? AND productId = ?";
                        try (PreparedStatement pstmtCheck = con.prepareStatement(checkSQL)) {
                            pstmtCheck.setInt(1, Integer.parseInt(userid));
                            pstmtCheck.setInt(2, productId);
                            try (ResultSet rstCheck = pstmtCheck.executeQuery()) {
                                if (rstCheck.next() && rstCheck.getInt("reviewCount") > 0) {
                                    // User has already reviewed the product
                                    out.println("<p style='color:red;'>You have already submitted a review for this product.</p>");
                                } else {
                                    // Proceed with inserting the review
                                    String insertSQL = "INSERT INTO review(reviewRating, reviewDate, customerId, productId, reviewComment) VALUES (?, ?, ?, ?, ?)";
                                    try (PreparedStatement pstmtInsert = con.prepareStatement(insertSQL)) {
                                        pstmtInsert.setInt(1, Integer.parseInt(rate));
                                        pstmtInsert.setTimestamp(2, new java.sql.Timestamp(new java.util.Date().getTime()));
                                        pstmtInsert.setInt(3, Integer.parseInt(userid));
                                        pstmtInsert.setInt(4, productId);
                                        pstmtInsert.setString(5, comment);
                                        pstmtInsert.executeUpdate();
                                        out.println("<p style='color:green;'>Your review has been successfully submitted.</p>");
                                    }
                                }
                            }
                        }
                    } else {
                        // User did not purchase the product
                        out.println("<p style='color:red;'>You can only review products you have purchased.</p>");
                    }
                }
            }
        }

        // Fetch and display reviews
String reviewSQL = "SELECT reviewRating, reviewDate, firstName, reviewComment FROM review JOIN customer ON review.customerId = customer.customerId WHERE productId = ?";
try (PreparedStatement pstmt3 = con.prepareStatement(reviewSQL)) {
    pstmt3.setInt(1, productId);
    try (ResultSet rst2 = pstmt3.executeQuery()) {
        // Container for table
        out.println("<div style='width: 80%; margin: 20px auto; border: 2px solid #007BFF; border-radius: 10px; background-color: #f9f9f9; padding: 15px; box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);'>");
        out.println("<h3 style='text-align: center; font-family: Arial, sans-serif; color: #007BFF;'>All Reviews</h3>");

        // Start table
        out.println("<table style='width: 100%; border-collapse: collapse; font-family: Arial, sans-serif; color: #333;'>");

        // Table header
        out.println("<thead>");
        out.println("<tr style='background-color: #007BFF; color: white;'>");
        out.println("<th style='padding: 10px; text-align: left;'>Date</th>");
        out.println("<th style='padding: 10px; text-align: left;'>Customer</th>");
        out.println("<th style='padding: 10px; text-align: center;'>score</th>");
        out.println("<th style='padding: 10px; text-align: left;'>feedback</th>");
        out.println("</tr>");
        out.println("</thead>");

        // Table body
        out.println("<tbody>");
        while (rst2.next()) {
            out.println("<tr style='border-bottom: 1px solid #ddd;'>");
            out.println("<td style='padding: 10px;'>" + rst2.getString("reviewDate") + "</td>");
            out.println("<td style='padding: 10px;'>" + rst2.getString("firstName") + "</td>");
            out.println("<td style='padding: 10px; text-align: center; font-weight: bold; color: #007BFF;'>" + rst2.getInt("reviewRating") + "</td>");
            out.println("<td style='padding: 10px;'>" + rst2.getString("reviewComment") + "</td>");
            out.println("</tr>");
        }
        out.println("</tbody>");

        // End table
        out.println("</table>");

        // Closing div
        out.println("</div>");
    }
}

    } catch (NumberFormatException e) {
        out.println("<p>Invalid product ID format.</p>");
    } catch (SQLException | ClassNotFoundException e) {
        out.println("<p>Error: " + e.getMessage() + "</p>");
    } finally {
        try {
            if (rst != null) rst.close();
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            out.println("<p>Database close error: " + e.getMessage() + "</p>");
        }
    }
%>

<h3 style="text-align:center; font-family: Arial, sans-serif; color: #333; margin-top: 30px;">Share Your Review:</h3>
<form name="NewReview" method="post" 
      style="max-width: 600px; margin: 20px auto; padding: 20px; border: 2px solid #00509E; border-radius: 15px; background: #f0f8ff; box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);">
    <div style="margin-bottom: 15px;">
        <label for="rating" style="display: block; font-family: Arial, sans-serif; font-size: 1.1em; font-weight: bold; color: #333; margin-bottom: 5px;">score:</label>
        <input type="number" name="rating" min="1" max="10" placeholder="1-10" 
               style="width: 100%; padding: 10px; font-size: 1em; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box;">
    </div>

    <div style="margin-bottom: 15px;">
        <label for="comment" style="display: block; font-family: Arial, sans-serif; font-size: 1.1em; font-weight: bold; color: #333; margin-bottom: 5px;">Feedback:</label>
        <textarea name="comment" placeholder="Share your feedback here..." maxlength="1000" rows="5"
                  style="width: 100%; padding: 10px; font-size: 1em; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; resize: none;"></textarea>
    </div>

    <div style="margin-bottom: 15px;">
        <label for="userid" style="display: block; font-family: Arial, sans-serif; font-size: 1.1em; font-weight: bold; color: #333; margin-bottom: 5px;">User ID:</label>
        <input type="text" name="userid" placeholder="Enter your User ID" 
               style="width: 100%; padding: 10px; font-size: 1em; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box;">
    </div>

    <div style="text-align: center;">
        <input type="submit" name="Submit2" value="Submit Review" 
               style="background-color: #00509E; color: white; padding: 12px 20px; font-size: 1.1em; font-weight: bold; border: none; border-radius: 5px; cursor: pointer; transition: 0.3s;">
    </div>

    <script>
        // Add hover effect to the button
        const submitButton = document.querySelector('input[name="Submit2"]');
        submitButton.addEventListener('mouseover', function () {
            this.style.backgroundColor = '#003f7d';
        });
        submitButton.addEventListener('mouseout', function () {
            this.style.backgroundColor = '#00509E';
        });
    </script>
</form>