# this basically installs apache and tomcat 7
# Apace is installed from https://github.com/saltstack-formulas/apache-formula.git
# tomcat is installed from https://github.com/saltstack-formulas/tomcat-formula.git
# the formula for tomcat also installs addressbook.war. 
# This assumes that your build process has somehow copied over
# the file to a location being served as a file server from Salt
# See attached master file as also the init.sls file 
# init.sls file is a sample modification on showing how to copy
# relevant files for application and is meant only for demo purposes. 
base:
  'test02.edurekademo.com':
    - apache
	- tomcat