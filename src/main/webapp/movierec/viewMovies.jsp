<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>

<head>

<title>View Movies</title>

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
<a href="addMovie.jsp">Add Movie</a>
<a href="searchMovie.jsp">Search</a>
<a href="favourite.jsp">Favourites</a>

</div>

</div>

<div class="container">

<h1>Movie Collection</h1>

<div class="movie-grid">

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

    Statement st = con.createStatement();

    ResultSet rs = st.executeQuery("SELECT * FROM movies ORDER BY id");

    while(rs.next()){

%>

<div class="movie-card">

<img src="<%=rs.getString("image_url")%>">

<div class="movie-info">

<h2><%=rs.getString("title")%></h2>

<div class="genre">

<%=rs.getString("genre")%>

</div>

<div class="language">

<%=rs.getString("language")%>

</div>

<p>

📅 <%=rs.getInt("release_year")%>

</p>

<div class="stars">

<%

double rating = rs.getDouble("rating");

int stars = (int)Math.round(rating / 2);

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

<p>

<%=rs.getString("synopsis")%>

</p>

<br>

<form action="toggleFavourite.jsp" method="post">

<input type="hidden"
name="id"
value="<%=rs.getInt("id")%>">

<%

if(rs.getInt("favourite")==1){

%>

<input
type="submit"
value="❤️ Remove Favourite"
class="btn">

<%

}else{

%>

<input
type="submit"
value="🤍 Add to Favourite"
class="btn">

<%

}

%>

</form>

</div>

</div>

<%

}

rs.close();
st.close();
con.close();

} catch (Exception e) {
    out.println("<p style='color:#ff8080;text-align:center;'>❌ Error loading movies: " + e.getMessage() + "</p>");
    System.err.println("❌ View Movies Error: " + e.getMessage());
    e.printStackTrace();
}

%>

</div>

<br><br>

<div class="center">

<a href="welcome.jsp">

<button class="btn">

⬅ Back to Dashboard

</button>

</a>

</div>

</div>

<div class="footer">

MovieRec | Browse Movies

</div>

</body>

</html>