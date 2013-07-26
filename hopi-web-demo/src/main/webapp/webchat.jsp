<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>测试流程图</title>
<meta http-equiv="Content-Type" content="text/html;charset=UTF-8">
<meta http-equiv="Content-Language" content="zh_CN">
<meta name="keywords" content="ado">
<meta name="robots" content="all" />
<meta name="googlebot" content="all" />
<META HTTP-EQUIV="pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache, must-revalidate">
<META HTTP-EQUIV="expires" CONTENT="Wed, 26 Feb 1997 08:21:57 GMT">
<script type="text/javascript">   
            if (!window.WebSocket) {   
                alert("WebSocket not supported by this browser!");   
            }   
               
            function display() {   
                var valueLabel = document.getElementById("valueLabel");   
                valueLabel.innerHTML = "";   
                var ws = new WebSocket("ws://localhost/test.wc");   
                ws.onmessage = function(evt) {   
                    valueLabel.innerHTML = evt.data;   
                };   
  
                ws.onclose = function() {   
                };   
  
                ws.onopen = function() {   
                    ws.send("Hello, Server!");   
                };   
                  
            }   
        </script>
</head>
<body onload="display();">
<div id="valueLabel"></div>
</body>
</html>