<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>

<head>

<title>Login</title>

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
<a href="register.jsp">Register</a>

</div>

</div>

<div class="container">

<div class="card">

<h2>Welcome Back</h2>

<%
String msg = request.getParameter("msg");

if("registered".equals(msg)){
%>

<p style="color:#10b981;text-align:center;">
Registration Successful! Please Login.
</p>

<%
}
%>

<!-- LOGIN FORM -->
<form method="post">

<label>🎭 Select Role</label>

<select name="role" required>
    <option value="">-- Select Role --</option>
    <option value="USER">USER</option>
    <option value="ADMIN">ADMIN</option>
</select>

<br><br>

<label>👤 Username</label>
<input type="text" name="username" placeholder="Enter Username" required>

<br><br>

<label>🔒 Password</label>
<input type="password" id="password" name="password" placeholder="Enter Password" required>

<br>

<input type="checkbox" onclick="showPassword()">
Show Password

<br><br>

<input type="submit" value="Login" class="btn">

</form>

<br>

<div class="center">

Don't have an account?
<a href="register.jsp">Register Here</a>

</div>

<%
if(request.getMethod().equalsIgnoreCase("POST")){

    String username = request.getParameter("username");
    String password = request.getParameter("password");
    String role = request.getParameter("role");

    try{

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
            
            System.out.println("✅ Connecting to Aiven Production Database");
            System.out.println("   Host: " + dbHost);
            System.out.println("   Database: " + dbName);
        } else {
            // Local Development (your computer)
            url = "jdbc:mysql://localhost:3306/login_db?useSSL=false&serverTimezone=UTC";
            user = "root";
            pass = "";
            
            System.out.println("✅ Connecting to Local Database");
        }

        Connection con = DriverManager.getConnection(url, user, pass);

        PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM users WHERE username=? AND password=? AND role=?"
        );

        ps.setString(1, username);
        ps.setString(2, password);
        ps.setString(3, role);

        ResultSet rs = ps.executeQuery();

        if(rs.next()){

            session.setAttribute("username", username);
            session.setAttribute("role", role);

            response.sendRedirect("welcome.jsp?user=" + username);

        } else {

            out.println("<p style='color:#ff8080;text-align:center;'>Invalid Username, Password or Role</p>");

        }

        con.close();

    } catch(Exception e){

        out.println("<p style='color:#ff8080;text-align:center;'>Error: " + e.getMessage() + "</p>");
        System.err.println("❌ Login Error: " + e.getMessage());
        e.printStackTrace();

    }
}
%>

</div>

</div>

<div class="footer">

MovieRec | Login

</div>

<script>

function showPassword(){

var x=document.getElementById("password");

if(x.type==="password"){
    x.type="text";
}else{
    x.type="password";
}

}

</script>

</body>

</html>