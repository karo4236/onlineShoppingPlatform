<%
    // 同时检查用户和管理员的会话属性
    boolean authenticatedUser = session.getAttribute("authenticatedUser") != null;
    boolean authenticatedAdmin = session.getAttribute("authenticatedAdmin") != null;

    if (!authenticatedUser && !authenticatedAdmin) {
        String loginMessage = "You have not been authorized to access the URL " + request.getRequestURL().toString();
        session.setAttribute("loginMessage", loginMessage);        
        response.sendRedirect("login.jsp");
    }
%>