Linux System Monitoring & Audit Log Commands Guide

1. Check Sudo Command History
--------------------------------
View all commands run with sudo:
    sudo cat /var/log/auth.log | grep "COMMAND="

Example output:
    Nov 2 18:40:01 ubuntu sudo: ganraj : COMMAND=/bin/rm -rf /tmp/testdir

2. Check Bash History (User Commands)
--------------------------------
For current user:
    cat ~/.bash_history | grep rm
For root user:
    sudo cat /root/.bash_history | grep rm

3. Check Login & SSH Access
--------------------------------
    last
    sudo cat /var/log/auth.log | grep "Accepted"

4. Auditd Logs (Advanced Tracking)
--------------------------------
Check if auditd is running:
    sudo systemctl status auditd

Search delete events:
    sudo ausearch -x rm

Install auditd:
    sudo apt install auditd -y
    sudo systemctl enable auditd
    sudo systemctl start auditd

Add monitoring rule for / directory:
    sudo auditctl -w / -p wa -k rootdir_monitor

View audit logs:
    sudo ausearch -k rootdir_monitor

Make rule permanent:
    sudo bash -c 'echo "-w / -p wa -k rootdir_monitor" >> /etc/audit/rules.d/rootdir.rules'
    sudo service auditd restart

5. Journalctl Logs (System Logs)
--------------------------------
    sudo journalctl | grep rm
    sudo journalctl _COMM=sudo

6. Real-time File Deletion Monitoring
--------------------------------
Install inotify tools:
    sudo apt install inotify-tools -y
Run monitoring:
    sudo inotifywait -m -r / --event delete

7. Summary Table
--------------------------------
Purpose                | Command                                         | Works on EC2/Ubuntu
------------------------|--------------------------------------------------|---------------------
Sudo command logs       | grep "COMMAND=" /var/log/auth.log               | Yes
User delete history     | grep rm ~/.bash_history                         | Yes
Audit logs              | ausearch -x rm                                  | Yes
Login tracking          | last / grep Accepted /var/log/auth.log          | Yes
Real-time monitor       | inotifywait -m -r / --event delete              | Yes

Tip for SysAdmins:
Enable auditd and keep /var/log on a separate partition to avoid log loss during system issues.
