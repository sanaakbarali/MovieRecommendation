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

String username=request.getParameter("username");
String password=request.getParameter("password");

try{

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con=DriverManager.getConnection(
"jdbc:mysql://localhost:3306/login_db",
"root",
""
);

PreparedStatement ps=con.prepareStatement(
"INSERT INTO users(username,password) VALUES(?,?)"
);

ps.setString(1,username);
ps.setString(2,password);

ps.executeUpdate();

con.close();

response.sendRedirect("login.jsp?msg=registered");

}catch(Exception e){

out.println("<p style='color:#ff8080;text-align:center;'>"+e+"</p>");

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