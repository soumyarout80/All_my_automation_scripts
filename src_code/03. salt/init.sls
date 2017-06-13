{% from "tomcat/map.jinja" import tomcat with context %}
{% set tomcat_java_home = tomcat.java_home %}
{% set tomcat_java_opts = tomcat.java_opts %}

tomcat:
  pkg.installed:
    - name: {{ tomcat.pkg }}
    {% if tomcat.version is defined %}
    - version: {{ tomcat.version }}
    {% endif %}
  service.running:
    - name: {{ tomcat.service }}
    - enable: {{ tomcat.service_enabled }}
    - watch:
      - pkg: tomcat
    - require_in:
       - file: /etc/init.d/tomcat7 

# To install haveged in centos you need the EPEL repository
{% if tomcat.with_haveged %}
  require:
    - pkg: haveged

/etc/init.d/tomcat7:
  file.managed:
    -  source: salt://tomcat7
    -  user: root
    -  group: root 
    -  mode: 0755 

/var/lib/tomcat7/webapps/addressbook.war:
  file.managed:
    -  source: salt://addressbook.war
    -  user: root
    -  group: root 
    -  mode: 0755 
    -  require:
        -  service: tomcat7 

haveged:
  pkg.installed: []
  service.running:
    - enable: {{ tomcat.haveged_enabled }}
    - watch:
       - pkg: haveged
{% endif %}

