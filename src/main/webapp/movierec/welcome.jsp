<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>

<title>Dashboard</title>

<link rel="stylesheet" href="css/style.css">

</head>

<body>

<%
String username = (String) session.getAttribute("username");
String role = (String) session.getAttribute("role");
if(username == null){
    response.sendRedirect("login.jsp");
    return;
}
%>

<div class="navbar">

<h2>🎬 MovieRec</h2>

<div>

<a href="welcome.jsp?user=<%=username%>">Dashboard</a>
<a href="viewMovies.jsp">Movies</a>
<a href="favourite.jsp">Favourites</a>
<a href="index.jsp">Logout</a>

</div>

</div>

<div class="container">

<h1>Welcome, <%=username%> 👋</h1>
<h3>Your Personal Movie Recommendation System</h3>

<p class="center">
Ready to discover your next favourite movie?
</p>

<div class="dashboard">

<%
if("ADMIN".equals(role)){
%>

<%
if("USER".equals(role)){
%>

<a href="requestMovie.jsp" class="card-link">
<div class="option">
<h2>📩</h2>
<h3>Request Movie</h3>
<p>Request a movie to be added.</p>
</div>
</a>

<%
}
%>

<a href="addMovie.jsp" class="card-link">
<div class="option">
<h2>🎬</h2>
<h3>Add Movie</h3>
<p>Add a new movie to the collection.</p>
</div>
</a>

<%
}
%>

<a href="viewMovies.jsp" class="card-link">
<div class="option">
<h2>📚</h2>
<h3>View Movies</h3>
<p>Browse all available movies.</p>
</div>
</a>

<a href="searchMovie.jsp" class="card-link">
<div class="option">
<h2>🔍</h2>
<h3>Search Movies</h3>
<p>Search and get recommendations.</p>
</div>
</a>

<a href="favourite.jsp" class="card-link">
<div class="option">
<h2>❤️</h2>
<h3>Favourite Movies</h3>
<p>View your saved favourite movies.</p>
</div>
</a>


</div>

</div>

<div class="footer">
MovieRec | Movie Recommendation System

</div>

</body>

</html>