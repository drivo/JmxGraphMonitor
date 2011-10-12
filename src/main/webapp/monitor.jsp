<%--
    Copyright 2011 (C) by Guido D'Albore (guido@bitstorm.it)

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

    Created on : 07-oct-2011
    Author     : Guido D'Albore (guido@bitstorm.it)
    Example    : http://<host>:8080/jmx-monitor/monitor.jsp?attribute=FreeMemory&name=type%3DServerInfo&domain=jboss.system
--%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.net.*" %>

<html>
<head>
    <script type="text/javascript" src="dygraph-combined.js"></script>
    <script type="text/javascript" src="jquery-1.6.4.min.js"></script>
    <script type="text/javascript" src="date.js"></script>
    <title>Jmx MBean Monitor</title>
</head>
<body>
<div id="graphdiv" style="width:100%; height:100%;"></div>

<script type="text/javascript">

var baseUrl = "<%= request.getScheme()+"://"+request.getLocalAddr()+":"+request.getLocalPort()+request.getContextPath() %>";
var monitorDataUrl = baseUrl + "/api/" + "<%= request.getParameter("domain") %>" + "/" + "<%= request.getParameter("attribute") %>" + "?from=" + "<%= URLEncoder.encode(request.getParameter("name"),"UTF-8") %>";
var data = [];
data.push([new Date(), 0]);
    
function updateGraph() {
	//d = new Date().toString('yyyy/MM/dd HH:mm:ss');
	jsonData = $.ajax({
          // Some examples:
          //url: "http://127.0.0.1:8080/jmx-monitor/api/jboss.web/http-127.0.0.1-8080/ThreadPool/currentThreadsBusy",
          //url: "http://127.0.0.1:8080/jmx-monitor/api/jboss.system/FreeMemory?from=type%3DServerInfo",
          //url: "http://127.0.0.1:8080/jmx-monitor/api/data?domain=jboss.system&name=type%3DServerInfo&attribute=FreeMemory",
          url: monitorDataUrl,
          dataType:"text",
          async: false
          }).responseText;

    jsonData = parseInt(jsonData);
    
	//console.log(jsonData + " (" + typeof(jsonData) + ")");
	data.push([new Date(), jsonData]);
	
	g1.updateOptions({'file':data});
}

var options = {
    //Texts displayed below the chart's x-axis and to the left of the y-axis 
    titleFont: "bold 18px serif",
    titleFontColor: "black",

    //Texts displayed below the chart's x-axis and to the left of the y-axis 
    axisLabelFont: "bold 12px serif",
    axisLabelFontColor: "black",

    // Texts for the axis ticks
    labelFont: "normal 12px serif",
    labelFontColor: "black",

    // Text for the chart legend
    legendFont: "bold 12px serif",
    legendFontColor: "black",

    legendHeight: 20,
    
    axisLabelWidth: 150,
    
    labelsKMB: true,
    rollPeriod: 1,
    showRoller: true,
    digitsAfterDecimal: 0,
    //errorBars: true,
    sigFigs: 11,
    labelsDivWidth: 350,
    
    drawPoints: true,
    showRoller: true,
    labels: ['Time', 'Request']
}; 

var g1 = new Dygraph(document.getElementById("graphdiv"), data, options);

setInterval(updateGraph, 1000);

</script>
</body>
</html>