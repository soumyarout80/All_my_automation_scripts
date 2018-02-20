# Installing td-agent from package defination sls file
td-agent:
  module.run:
    - name: pkg.install
    - m_name: td-agent

# changing td-agent config file as per requrment
C:/opt/td-agent/etc/td-agent/td-agent.conf:
  file.managed:
    - contents: |
        <source>
         @type tail
         path S:/Philips/Apps/iSite/logs/**/*.log
         pos_file S:\Philips\Apps\iSite\logs\ispac.log.pos
         read_from_head true
         tag filelogs
         format none
        </source>

        <match filelogs.**>
         @type forward
         send_timeout 60s
         recover_wait 10s
         heartbeat_interval 1s
         phi_threshold 16
         hard_timeout 120s

         # buffer
           <buffer>
            @type file
            path S:\opt\fluentd\buffer\ispac.*.buffer
            chunk_limit_size 8m
            total_limit_size 32g
            flush_interval 60s
            overflow_action drop_oldest_chunk
            retry_timeout 72h
            retry_type periodic
            retry_wait 5s
           </buffer>

          # log to forwarder
           <server>
            name fluentd-1
            host 10.0.0.20
            port 24224
            weight 50
           </server>

           <server>
            name fluentd-2
            host 10.0.0.30
            port 24224
            weight 50
           </server>
         </match>


# Changing td-agent-prompt.bat file to register in windows services

C:\opt\td-agent\td-agent-prompt.bat:
  file.managed:
    - contents: |
        @echo off
        set PATH="%~dp0embedded\bin";%PATH%
        title Td-agent Command Prompt
        fluentd --reg-winsvc i
        fluentd --reg-winsvc-fluentdopt '-c C:/opt/td-agent/etc/td-agent/td-agent.conf -o C:/opt/td-agent/td-agent.log





# Starting fluentd as a windows service

ResgisterFluend_Td-agent-prompt:
  cmd.run:
    - name: |
        C:\opt\td-agent\td-agent-prompt.bat

Fluentd-service-Start:
  cmd.run:
    - name: sc start fluentdwinsvc




#soumya:
#  module.run:
#  - name: user.present
#  - m_name: soumya
#  - password: 'soumya'
#  - home: none
#  - groups:
#    - Administrators


#salt://file/setup.ps1:
#  cmd.script:
#    - source: salt://file/setup.ps1
#    - shell: powershell
#    - env:
#      - ExecutionPolicy: "bypass"
