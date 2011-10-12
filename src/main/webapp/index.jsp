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
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.net.*" %>
<%@page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE HTML>

<html>
    <head>
        <!-- Developed by Guido D'Albore -->

        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="jquery-1.6.4.min.js"></script>
        <script type="text/javascript" src="jquery.popupwindow.js"></script>
        <script type="text/javascript" src="date.js"></script>
        
        <script type="text/javascript">
            $(function() {
                 $(".example").popupwindow({
                     defaultconfig: {
                        height:300,
                        width:900
                     }
                });
            });
        </script>

        <title>Jmx Graph Monitor</title>
    </head>
    <body>
        <h2>JMX Graph Monitor v1.0.0</h2>
        <p>Simple graph monitor for JMX MBean attributes. JBossAS 4, 5 and 6 compatible. You can use it in a simple way, you only need to
            form a link in the following manner (all parameters values shall be URL encoded):

        <ul>
            <li><%= request.getScheme()+"://"+request.getLocalAddr()+":"+request.getLocalPort()+request.getContextPath() %>/monitor.jsp?<b>domain</b>=<i>&lt;name of mbean domain&gt;</i>&amp;<b>name</b>=<i>&lt;mbean name&gt;</i>&amp;<b>attribute</b>=<i>&lt;attribute name&gt;</i>
            </li>
        </ul>
        </p>

        <%
            String examples[][] = {
                // Insert here other examples if you need
                // {domain,name,attribute,description}
                {"jboss.system","type=ServerInfo","FreeMemory","JVM free memory"},
                {"jboss.web","name=" + request.getScheme() + "-" + request.getLocalAddr() + "-" + request.getLocalPort() + ",type=ThreadPool","currentThreadsBusy", "JBoss Web current threads busy"},
            };

            String domain, name, attribute, description, monitorUrl;

            // Exposes in JSTL the Java variable "examples"
            pageContext.setAttribute("examples",examples);

            String example[];
        %>

        <div id="examples">
            <h3>Examples:</h3>
            
            <c:forEach items="${examples}" var="example">
                <%
                    // Retrieves "example" from JSTL and puts it in Java scope
                    example      = (String[])pageContext.getAttribute("example");

                    domain       = example[0];
                    name         = example[1];
                    attribute    = example[2];
                    description  = example[3];
                    monitorUrl   =   request.getScheme() +
                                     "://" +
                                     request.getLocalAddr() +
                                     ":" +
                                     request.getLocalPort() +
                                     request.getContextPath() +
                                     "/monitor.jsp?attribute=" +
                                     URLEncoder.encode(attribute,"UTF-8") +
                                     "&name=" +
                                     URLEncoder.encode(name,"UTF-8") +
                                     "&domain=" +
                                     URLEncoder.encode(domain,"UTF-8");
                %>
            
                <p><%=description%> (domain => "<%=domain%>", name =>  "<%=name%>", attribute => "<%=attribute%>"):
                    <ul>
                        <li><a  class="example" rel="defaultconfig" href="<%= monitorUrl %>"><%= monitorUrl %> </a>
                        </li>
                    </ul>
                </p>
            </c:forEach>
        </div>

    </body>
</html>
