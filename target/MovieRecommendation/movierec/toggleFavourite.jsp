<%@ page import="java.sql.*" %>

<%

int id = Integer.parseInt(request.getParameter("id"));

Class.forName("com.mysql.cj.jdbc.Driver");

Connection con = DriverManager.getConnection(
"jdbc:mysql://localhost:3306/moviedb",
"root",
""
);

PreparedStatement ps = con.prepareStatement(
"UPDATE movies SET favourite = CASE WHEN favourite=1 THEN 0 ELSE 1 END WHERE id=?"
);

ps.setInt(1,id);

ps.executeUpdate();

con.close();

response.sendRedirect(request.getHeader("Referer"));

%>