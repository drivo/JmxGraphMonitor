/*
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
 */

package it.bitstorm.lab;

import javax.annotation.Resource;
import javax.management.MBeanServer;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import javax.management.ObjectName;
import javax.ws.rs.QueryParam;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;
import javax.ws.rs.core.Response.Status;
import org.jboss.mx.util.MBeanServerLocator;

/**
 * @author Guido D'Albore
 */

@Resource
@Path(value="/api")
public class JmxMBeanAttributeAPI {
    Logger log  = LoggerFactory.getLogger("JMX-GRAPH-MONITOR-REST-API");
    
    @Context
	HttpServletRequest httpRequest;
    @Context
	HttpServletResponse httpResponse;
    @Context
    ServletContext servletContext;
    @Context
    HttpHeaders httpHeader;
    
    @GET
    @Path("/")
    @Produces("text/html")
    public String usage() {
        return  "<h2>JMX MBean REST API ready.</h2>" +
                "<p>Reads attributes from a JMX service.</p>" +
                "<p>Usage:" +
                "<ul>" +
                "   <li>" + httpRequest.getRequestURL() + "/<jmx-domain>/<jmx-name>/<jmx-type>/<attribute></li>" +
                "   <li>" + httpRequest.getRequestURL() + "/<jmx-domain>/<jmx-name>/<attribute></li>" +
                "   <li>" + httpRequest.getRequestURL() + "/<jmx-domain>/<attribute>?from=<full-jmx-name> (most compatible form)</li>" +
                "</ul>" +
                "</p>";
    }
    
    @GET
    @Path("/{domain:.+}/{name:.+}/{type:.+}/{attribute:.+}")
    @Produces("text/plain")
    public Response get(@PathParam("domain") String domain,
                        @PathParam("name") String name,
                        @PathParam("type") String type,
                        @PathParam("attribute") String attribute) {

        ResponseBuilder responseBuilder = Response.status(Status.BAD_REQUEST);
        ObjectName jmxMBeanON;
        String requestedObjectName;

        if(name.compareTo("-") != 0) {
            requestedObjectName = domain + ":name=" + name + ",type=" + type;
        } else {
            // Anonymous MBean service
            requestedObjectName = domain + ":type=" + type;
        }

        try {
            jmxMBeanON = new ObjectName(requestedObjectName);
        } catch(Exception ex) {
            jmxMBeanON = null;
        }

        MBeanServer server = MBeanServerLocator.locateJBoss();

        try {
            return responseBuilder.entity(server.getAttribute(jmxMBeanON, attribute).toString()).status(Status.OK).build();
        } catch(Exception ex) {
            return responseBuilder.entity("Cannot find attribute '" + attribute + "' for service " + requestedObjectName).status(Status.NOT_FOUND).build();
        }
    }

    @GET
    @Path("/{domain:.+}/{name:.+}/{attribute:.+}")
    @Produces("text/plain")
    public Response get(@PathParam("domain") String domain,
                        @PathParam("name") String name,
                        @PathParam("attribute") String attribute) {

        ResponseBuilder responseBuilder = Response.status(Status.BAD_REQUEST);
        ObjectName jmxMBeanON;
        String requestedObjectName;

        requestedObjectName = domain + ":" + name;

        try {
            jmxMBeanON = new ObjectName(requestedObjectName);
        } catch(Exception ex) {
            jmxMBeanON = null;
        }

        MBeanServer server = MBeanServerLocator.locateJBoss();

        try {
            return responseBuilder.entity(server.getAttribute(jmxMBeanON, attribute).toString()).status(Status.OK).build();
        } catch(Exception ex) {
            return responseBuilder.entity("Cannot find attribute '" + attribute + "' for service " + requestedObjectName).status(Status.NOT_FOUND).build();
        }
    }

    @GET
    @Path("/{domain:.+}/{attribute:.+}")
    @Produces("text/plain")
    public Response getFrom(@PathParam("domain") String domain,
                            @QueryParam("from") String name,
                            @PathParam("attribute") String attribute) {

        ResponseBuilder responseBuilder = Response.status(Status.BAD_REQUEST);
        ObjectName jmxMBeanON;
        String requestedObjectName;

        requestedObjectName = domain + ":" + name;

        try {
            jmxMBeanON = new ObjectName(requestedObjectName);
        } catch(Exception ex) {
            jmxMBeanON = null;
        }

        MBeanServer server = MBeanServerLocator.locateJBoss();

        try {
            return responseBuilder.entity(server.getAttribute(jmxMBeanON, attribute).toString()).status(Status.OK).build();
        } catch(Exception ex) {
            return responseBuilder.entity("Cannot find attribute '" + attribute + "' for service " + requestedObjectName).status(Status.NOT_FOUND).build();
        }
    }
}
