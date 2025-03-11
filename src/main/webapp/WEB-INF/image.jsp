<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String imageName = ((String) request.getAttribute("image")).split("/")[1];
    String imagePath = "https://s0ooo0k.github.io/temp_image/" + imageName + ".png";
%>
<html>
<head>
    <title>Title</title>
    <meta charset="UTF-8">
    <title><%= imageName %></title>
    <meta property="og:title" content="<%= imageName %>">
    <meta property="og:description" content="<%= imageName %>을 같이 보아요">
    <meta property="og:type" content="website">
    <meta property="og:image" content="<%= imagePath %>">
</head>
<body>
<img src="<%= imagePath %>">
</body>
</html>