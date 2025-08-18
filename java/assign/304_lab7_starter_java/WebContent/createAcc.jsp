<html>
    <head>
        <title>Create Account</title>
        <style>
            body {
                display: flex;
                flex-flow: column;
                align-items: center;
                font-family: Arial, sans-serif;
                background-color: #f9f9f9;
                padding: 20px;
            }

            form {
                border: 1px solid #ccc;
                border-radius: 8px;
                padding: 20px;
                background-color: #ffffff;
                box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            }

            form label {
                font-weight: bold;
                margin-top: 10px;
            }

            form input {
                padding: 8px;
                margin: 5px 0 15px;
                width: calc(100% - 20px);
                border: 1px solid #ccc;
                border-radius: 4px;
            }

            form input[type="submit"] {
                width: auto;
                background-color: #008080;
                color: white;
                border: none;
                cursor: pointer;
                padding: 10px 20px;
                border-radius: 4px;
                transition: background-color 0.3s;
            }

            form input[type="submit"]:hover {
                background-color: #005f5f;
            }
        </style>
    </head>
    <body>
        <h1>Create a new account</h1>
        <form method="post" action="addCustomer.jsp">
            <label for="fn">customerId: </label>
            <input type="text" id="custId" name="customerId" placeholder="num" required><br>

            <label for="fn">First Name: </label>
            <input type="text" id="fn" name="fname" placeholder="John" required><br>

            <label for="ln">Last Name: </label>
            <input type="text" id="ln" name="lname" placeholder="Smith" required><br>

            <label for="em">Email: </label>
            <input type="email" id="em" name="email" placeholder="john123@email.com" required><br>

            <label for="un">Username: </label>
            <input type="text" id="un" name="userId" minlength="5" maxlength="20" placeholder="john123" required><br>

            <label for="pw">Password: </label>
            <input type="password" id="pw" name="password" minlength="8" maxlength="30" required><br>

            <label for="pn">Phone Number: </label>
            <input type="tel" id="pn" name="phonenum" pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}"  placeholder="123-456-7890" required><br>

            <label for="sa">Street Address: </label>
            <input type="text" id="sa" name="streetAddress" placeholder="123 abc street" required><br>

            <label for="cty">City: </label>
            <input type="text" id="cty" name="city" placeholder="City" required><br>

            <label for="sp">State/Province: </label>
            <input type="text" id="sp" name="state" placeholder="State/Province" required><br>

            <label for="pc">Postal Code: </label>
            <input type="text" id="pc" name="postalcode" pattern="[A-Z,a-z]{1}[0-9]{1}[A-Z,a-z]{1}[0-9]{1}[A-Z,a-z]{1}[0-9]{1}" placeholder="A1B2C3" required><br>
            
            <label for="cntry">Country: </label>
            <input type="text" id="cntry" name="country" placeholder="Country" required><br>
            
            <input type="submit" value="Create Account">
        </form>
    </body>
</html>