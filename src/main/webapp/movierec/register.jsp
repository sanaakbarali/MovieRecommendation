<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>

<head>

<title>Register</title>

<link rel="stylesheet" href="css/style.css">

</head>

<body>

<div class="navbar">

<h2>
    <a href="welcome.jsp" class="logo">
        <span class="gold">Movie</span><span class="white">Rec</span>
    </a>
</h2>

<div>

<a href="index.jsp">Home</a>
<a href="login.jsp">Login</a>

</div>

</div>

<div class="container">

<div class="card">

<h2>Create Your Account</h2>

<form method="post">

<label>👤 Username</label>

<input type="text" name="username" placeholder="Enter Username" required>

<label>🔒 Password</label>

<input type="password" name="password" placeholder="Enter Password" required>

<br><br>

<div class="center">

<input type="submit" value="Register" class="btn">

</div>

</form>

<br>

<div class="center">

Already have an account?

<a href="login.jsp">Login Here</a>

</div>

<%

if(request.getMethod().equalsIgnoreCase("POST")){

    String username = request.getParameter("username");
    String password = request.getParameter("password");

    try {

        Class.forName("com.mysql.cj.jdbc.Driver");

        // ==========================================
        // 🔥 UPDATED: Use environment variables
        // ==========================================
        
        String dbHost = System.getenv("DB_HOST");
        String dbPort = System.getenv("DB_PORT");
        String dbName = System.getenv("DB_NAME");
        String dbUser = System.getenv("DB_USER");
        String dbPassword = System.getenv("DB_PASSWORD");
        
        String url, user, pass;
        
        if (dbHost != null && !dbHost.isEmpty()) {
            // Production - Aiven (on Render)
            url = "jdbc:mysql://" + dbHost + ":" + dbPort + "/" + dbName + 
                  "?useSSL=true&requireSSL=true&serverTimezone=UTC";
            user = dbUser;
            pass = dbPassword;
        } else {
            // Local Development
            url = "jdbc:mysql://localhost:3306/login_db?useSSL=false&serverTimezone=UTC";
            user = "root";
            pass = "";
        }

        Connection con = DriverManager.getConnection(url, user, pass);

        PreparedStatement ps = con.prepareStatement(
            "INSERT INTO users(username, password, role) VALUES(?, ?, 'USER')"
        );

        ps.setString(1, username);
        ps.setString(2, password);

        ps.executeUpdate();

        con.close();

        response.sendRedirect("login.jsp?msg=registered");

    } catch (Exception e) {

        out.println("<p style='color:#ff8080;text-align:center;'>❌ Error: " + e.getMessage() + "</p>");
        System.err.println("❌ Registration Error: " + e.getMessage());
        e.printStackTrace();

    }

}

%>

</div>

</div>

<div class="footer">

MovieRec | Create your account

</div>

</body>

</html>