<%@ page import="java.sql.*" %>

<%

try {
    int id = Integer.parseInt(request.getParameter("id"));

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
        "UPDATE movies SET favourite = CASE WHEN favourite=1 THEN 0 ELSE 1 END WHERE id=?"
    );

    ps.setInt(1, id);

    ps.executeUpdate();

    con.close();

    // Redirect back to the previous page
    String referer = request.getHeader("Referer");
    if (referer != null && !referer.isEmpty()) {
        response.sendRedirect(referer);
    } else {
        response.sendRedirect("viewMovies.jsp");
    }

} catch (Exception e) {
    System.err.println("❌ Toggle Favourite Error: " + e.getMessage());
    e.printStackTrace();
    response.sendRedirect("viewMovies.jsp?error=1");
}
%>