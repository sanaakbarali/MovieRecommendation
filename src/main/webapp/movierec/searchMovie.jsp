<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<!DOCTYPE html>
<html>

<head>

<title>Search Movie</title>

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
<a href="addMovie.jsp">Add Movie</a>
<a href="favourite.jsp">Favourites</a>

</div>

</div>

<div class="container">

<div class="card">

<h2>🔍 Search Movie</h2>

<form method="post">

<input type="text"
name="title"
placeholder="Enter Movie Title..."
required>

<br><br>

<input type="submit"
value="Search"
class="btn">

</form>

</div>

<%

if(request.getMethod().equalsIgnoreCase("POST")){

    String title = request.getParameter("title");

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

        PreparedStatement ps = con.prepareStatement(
            "SELECT * FROM movies WHERE title LIKE ?"
        );

        ps.setString(1, "%" + title + "%");

        ResultSet rs = ps.executeQuery();

        if(rs.next()){

            String genre = rs.getString("genre");

%>

<h2 style="margin-top:30px;">Movie Found</h2>

<div style="display:flex;justify-content:center;margin-top:30px;">

<div class="movie-card" style="max-width:350px;">

<img src="<%=rs.getString("image_url")%>">

<div class="movie-info">

<h2><%=rs.getString("title")%></h2>

<div class="genre">

<%=genre%>

</div>

<div class="language">

<%=rs.getString("language")%>

</div>

<p>

📅 <%=rs.getInt("release_year")%>

</p>

<div class="stars">

<%

int rating = (int)rs.getDouble("rating");

for(int i=1;i<=5;i++){

if(i<=rating)

out.print("★");

else

out.print("☆");

}

%>

<span style="color:white;font-size:15px;">

(<%=rs.getDouble("rating")%>/10)

</span>

</div>

<p>

<%=rs.getString("synopsis")%>

</p>

<br>

<form action="toggleFavourite.jsp" method="post">

<input
type="hidden"
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

</div>

<h2 style="margin-top:40px;">Recommended Movies</h2>

<div class="movie-grid">

<%

PreparedStatement rec = con.prepareStatement(

"SELECT * FROM movies WHERE genre=? AND title<>?"

);

rec.setString(1, genre);
rec.setString(2, title);

ResultSet recRs = rec.executeQuery();

boolean found = false;

while(recRs.next()){

found = true;

%>

<div class="movie-card">

<img src="<%=recRs.getString("image_url")%>">

<div class="movie-info">

<h2><%=recRs.getString("title")%></h2>

<div class="genre">

<%=recRs.getString("genre")%>

</div>

<div class="language">

<%=recRs.getString("language")%>

</div>

<p>

📅 <%=recRs.getInt("release_year")%>

</p>

<div class="stars">

<%

int r = (int)recRs.getDouble("rating");

for(int i=1;i<=5;i++){

if(i<=r)

out.print("★");

else

out.print("☆");

}

%>

<span style="color:white;font-size:15px;">

(<%=recRs.getDouble("rating")%>/10)

</span>

</div>

<p>

<%=recRs.getString("synopsis")%>

</p>

<br>

<form action="toggleFavourite.jsp" method="post">

<input
type="hidden"
name="id"
value="<%=recRs.getInt("id")%>">

<%

if(recRs.getInt("favourite")==1){

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

if(!found){

%>

<p class="center">No recommendations available.</p>

<%

}

recRs.close();
rec.close();

%>

</div>

<%

} else {

%>

<h3 style="text-align:center;color:#ff8080;">

Movie Not Found

</h3>

<%

}

rs.close();
ps.close();
con.close();

} catch (Exception e) {
    out.println("<p style='color:#ff8080;text-align:center;'>❌ Error: " + e.getMessage() + "</p>");
    System.err.println("❌ Search Error: " + e.getMessage());
    e.printStackTrace();
}

}

%>

<br><br>

<div class="center">

<a href="welcome.jsp">

<button class="btn">

⬅ Dashboard

</button>

</a>

</div>

</div>

<div class="footer">

MovieRec | Search Movies

</div>

</body>

</html>