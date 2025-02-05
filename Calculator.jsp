<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%
    // Initialize history list in session if not already present
    if (session.getAttribute("history") == null) {
        session.setAttribute("history", new ArrayList<String>());
    }
    ArrayList<String> history = (ArrayList<String>) session.getAttribute("history");

    String result = "";
    String error = "";

    if (request.getMethod().equalsIgnoreCase("post")) {
        String num1 = request.getParameter("num1");
        String num2 = request.getParameter("num2");
        String operation = request.getParameter("operation");

        try {
            double n1 = Double.parseDouble(num1);
            double n2 = Double.parseDouble(num2);
            double res = 0;

            switch (operation) {
                case "+":
                    res = n1 + n2;
                    break;
                case "-":
                    res = n1 - n2;
                    break;
                case "*":
                    res = n1 * n2;
                    break;
                case "/":
                    if (n2 == 0) {
                        error = "Error: Division by zero!";
                    } else {
                        res = n1 / n2;
                    }
                    break;
                default:
                    error = "Invalid operation!";
            }

            if (error.isEmpty()) {
                result = String.format("%.2f", res);
                history.add(n1 + " " + operation + " " + n2 + " = " + result);
            }
        } catch (NumberFormatException e) {
            error = "Invalid input! Please enter valid numbers.";
        }
    }

    if (request.getParameter("clear") != null) {
        result = "";
        error = "";
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Calculator</title>
    <link rel="stylesheet" href="style.css">
</head>
<body>
    <div class="calculator">
        <h1>Calculator</h1>
        <form method="post">
            <input type="text" name="num1" placeholder="Enter first number" required>
            <select name="operation">
                <option value="+">+</option>
                <option value="-">-</option>
                <option value="*">*</option>
                <option value="/">/</option>
            </select>
            <input type="text" name="num2" placeholder="Enter second number" required>
            <div class="buttons">
                <button type="submit">Calculate</button>
                <button type="submit" name="clear" value="true">C</button>
            </div>
        </form>
        <% if (!error.isEmpty()) { %>
            <div class="error"><%= error %></div>
        <% } else if (!result.isEmpty()) { %>
            <div class="result">Result: <%= result %></div>
        <% } %>
        <div class="history">
            <h2>History</h2>
            <ul>
                <% for (String entry : history) { %>
                    <li><%= entry %></li>
                <% } %>
            </ul>
        </div>
    </div>
</body>
</html>