JMX Graph Monitor 
=================

* JMX Graph Monitor for JBossAS 4, 5, 6
* Monitors in real-time JMX attributes
* REST interface for reading JMX attributes
* Unique WAR package file

Building
--------
If you already have Maven installed (from project directory)

> mvn clean install

Deployment
----------
Copy JmxGraphMonitor-x.y.z.war file found in target directory in your JBossAS deploy directory

Demo
-----
Once deployed, go to in your browser and open the URL (you should change host and port accordingly to your
JBossAS configuration):

[http://127.0.0.1:8080/jmx-monitor/](http://127.0.0.1:8080/jmx-monitor/)

License
-------
* [Licensed under the Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0.txt)


