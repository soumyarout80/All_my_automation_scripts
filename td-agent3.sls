td-agent3:
  '3.1.1':
    full_name: 'td-agent-3.1.1'
    installer: 'http://packages.treasuredata.com.s3.amazonaws.com/3/windows/td-agent-3.1.1-0-x64.msi'
    install_flags: '/qn ALLUSERS=1 /norestart'
    uninstaller: 'http://packages.treasuredata.com.s3.amazonaws.com/3/windows/td-agent-3.1.1-0-x64.msi'
    uninstall_flags: '/qn /norestart'
    msiexec: True
    locale: en_US
    reboot: False
