# the following is a sample site.pp. 
# it assumes that you have installed the followin modules: 
# puppetlabs-java, puppetlabs-tomcat using the puppet module install command on the puppet server. 

# the below is an example of using apt to install java using apt and will work on Ubuntu only 
# Use these is you do not want to use the puppetlabs-java module. 
#class {'apt':} 
#apt::ppa { 'ppa:openjdk-r/ppa':
   notify => Exec['apt_update'], 
} 

# install OpenJDK 8 
class {'java':
        distribution => 'jdk',
        package => 'openjdk-8-jdk',
      }

# reference the tomcat instance.. 
class {'tomcat':}

# install tomcat 8 from URL. This will download the file from the specified URL and install the same. 

tomcat::install { '/opt/tomcat':
                   source_url => 'http://archive.apache.org/dist/tomcat/tomcat-8/v8.0.23/bin/apache-tomcat-8.0.23.tar.gz',
                }
# set the instance directory and CATALINE_HOME/CATALINA_BASE directories. 
tomcat::instance { 'default':
                   catalina_home => '/opt/tomcat',
                   catalina_base => '/opt/tomcat',
                 }

# install a war addressbook.war. The file addressbook.war is located in 
# /etc/puppet/modules/tomcat/files. (Assuming default module path in Puppet 3.7.x)
# If this file does not exist, create it manually or use a file resource to create the same. 
tomcat::war { 'addressbook.war':
               catalina_base => '/opt/tomcat',
               war_source => 'puppet:///modules/tomcat/addressbook.war',
            }
