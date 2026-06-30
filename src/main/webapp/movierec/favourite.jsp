<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>
<head>

<title>MovieRec | Favourite Movies</title>

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

<a href="welcome.jsp">Dashboard</a>
<a href="viewMovies.jsp">Movies</a>
<a href="searchMovie.jsp">Search</a>

</div>

</div>

<div class="container">

<h1>Favourite Movies</h1>

<%

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
        url = "jdbc:mysql://localhost:3306/moviedb?useSSL=false&serverTimezone=UTC";
        user = "root";
        pass = "";
    }

    Connection con = DriverManager.getConnection(url, user, pass);

    /* Remove Favourite */

    if(request.getParameter("remove")!=null){

        int id=Integer.parseInt(request.getParameter("remove"));

        PreparedStatement ps=con.prepareStatement(
        "UPDATE movies SET favourite=0 WHERE id=?"
        );

        ps.setInt(1,id);

        ps.executeUpdate();

        response.sendRedirect("favourite.jsp");
        return;
    }

    Statement st=con.createStatement();

    ResultSet rs=st.executeQuery(
    "SELECT * FROM movies WHERE favourite=1"
    );

%>

<div class="movie-grid">

<%

while(rs.next()){

double rating=rs.getDouble("rating");

int stars=(int)Math.round(rating/2);

%>

<div class="movie-card">

<img src="<%=rs.getString("image_url")%>">

<div class="movie-info">

<h2><%=rs.getString("title")%></h2>

<div class="genre"><%=rs.getString("genre")%></div>

<div class="language"><%=rs.getString("language")%></div>

<p>Release Year : <%=rs.getInt("release_year")%></p>

<div class="stars">

<%

for(int i=1;i<=5;i++){

if(i<=stars)

out.print("★");

else

out.print("☆");

}

%>

<span style="color:white;font-size:15px;">
(<%=rating%>/10)
</span>

</div>

<p><%=rs.getString("synopsis")%></p>

<br>

<form method="post">

<input
type="hidden"
name="remove"
value="<%=rs.getInt("id")%>">

<input
type="submit"
value="Remove Favourite"
class="btn">

</form>

</div>

</div>

<%

}

con.close();

} catch (Exception e) {
    out.println("<p style='color:#ff8080;text-align:center;'>❌ Error: " + e.getMessage() + "</p>");
    System.err.println("❌ Favourite Error: " + e.getMessage());
    e.printStackTrace();
}

%>

</div>

<br><br>

<div class="center">

<a href="welcome.jsp">

<button class="btn">

Back to Dashboard

</button>

</a>

</div>

</div>

<div class="footer">

MovieRec | Favourite Movies

</div>

</body>

</html>