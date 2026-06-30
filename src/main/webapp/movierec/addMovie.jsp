<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
String role = (String) session.getAttribute("role");

if(role == null || !"ADMIN".equals(role)) {
    response.sendRedirect("welcome.jsp");
    return;
}
%>
<!DOCTYPE html>
<html>

<head>

<title>Add Movie</title>

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
<a href="favourite.jsp">Favourites</a>

</div>

</div>

<div class="container">

<div class="card">

<h2>Add New Movie</h2>

<form method="post">

<label>🎬 Movie Title</label>

<input type="text" name="title" required>

<label>🎭 Genre</label>

<select name="genre">

<option>Action</option>
<option>Adventure</option>
<option>Comedy</option>
<option>Drama</option>
<option>Fantasy</option>
<option>Horror</option>
<option>Romance</option>
<option>Sci-Fi</option>
<option>Thriller</option>

</select>

<label>🌍 Language</label>

<select name="language">

<option>English</option>
<option>Hindi</option>
<option>Korean</option>
<option>Japanese</option>
<option>Tamil</option>
<option>Telugu</option>
<option>Spanish</option>
<option>French</option>

</select>

<label>📅 Release Year</label>

<input type="number"
name="year"
min="1900"
max="2100"
required>

<label>⭐ Rating</label>

<input
type="number"
name="rating"
min="0"
max="10"
step="0.1"
placeholder="Example: 8.5"
required>

<label>🖼 Movie Poster URL</label>

<input type="text"
name="image"
placeholder="Paste Image URL">

<label>📝 Synopsis</label>

<textarea
name="synopsis"
rows="5"
placeholder="Enter Movie Synopsis"></textarea>

<br>

<input
type="submit"
value="Add Movie"
class="btn">

</form>

<%

if(request.getMethod().equalsIgnoreCase("POST")){

    String title = request.getParameter("title");
    String genre = request.getParameter("genre");
    String language = request.getParameter("language");
    int year = Integer.parseInt(request.getParameter("year"));
    double rating = Double.parseDouble(request.getParameter("rating"));
    String image = request.getParameter("image");
    String synopsis = request.getParameter("synopsis");

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

            "INSERT INTO movies(title,genre,language,release_year,rating,image_url,synopsis,favourite) VALUES(?,?,?,?,?,?,?,0)"

        );

        ps.setString(1, title);
        ps.setString(2, genre);
        ps.setString(3, language);
        ps.setInt(4, year);
        ps.setDouble(5, rating);
        ps.setString(6, image);
        ps.setString(7, synopsis);

        ps.executeUpdate();

        con.close();

        out.println("<p style='color:#10b981;text-align:center;'>✅ Movie Added Successfully!</p>");

    } catch (Exception e) {
        out.println("<p style='color:#ff8080;text-align:center;'>❌ Error: " + e.getMessage() + "</p>");
        System.err.println("❌ Add Movie Error: " + e.getMessage());
        e.printStackTrace();
    }
}

%>

</div>

</div>

<div class="footer">

MovieRec | Add Movie

</div>

</body>

</html>