# Windows Remote Access Incident Response & Remediation

## Executive Summary
This project documents the real-world identification, triage, containment, and remediation of an unauthorized remote access attempt via an illicit ConnectWise ScreenConnect instance detected on a hospitality workstation network. 

As the IT Support Specialist overseeing property systems (front desk, workstations, and Point of Sale terminals), suspicious background activity was identified on an endpoint. Using PowerShell scripting and native Windows diagnostic utilities, the unauthorized remote access software was isolated, the running process terminated, persistence mechanisms eradicated, and system integrity restored without business disruption.

---

## Technical Environment & Tools
* **Operating System:** Windows 10/11 Enterprise / Pro
* **Target Software:** ConnectWise ScreenConnect (Unauthorized Remote Access Client)
* **Remediation & Analysis Tools:** PowerShell, Windows Command Line, Task Manager, Services Management (`services.msc`), Windows Event Viewer
* **Documentation & Frameworks:** NIST SP 800-61 Rev. 2 (Computer Security Incident Handling Guide), Standard Operating Procedures (SOPs)

---

## Incident Response Lifecycle

### 1. Phase 1: Detection & Identification
* **Trigger:** An anomalous background service and outbound network connection attempt were observed during routine endpoint monitoring and user ticket resolution.
* **Initial Findings:** An unauthorized ConnectWise ScreenConnect client service (`ScreenConnect ClientService` / `ScreenConnect.ClientService.exe`) was discovered running in the background without administrative approval or change tickets.

### 2. Phase 2: Containment & Isolation
* **Host Isolation:** Prevented lateral movement by isolating the host from the internal hotel VLAN while preserving system state for analysis.
* **Session Termination:** Identified the active process ID (PID) and executed immediate termination using PowerShell to sever any established remote control channels:
  ```powershell
  # Locate running ScreenConnect processes
  Get-Process | Where-Object { $_.ProcessName -like "*ScreenConnect*" }

  # Terminate unauthorized execution immediately
  Stop-Process -Name "*ScreenConnect*" -Force
  3. Phase 3: Eradication & Remediation
Service Disablement & Removal: Disabled and uninstalled the persistent background service using native administrative utilities:

PowerShell
# Query service status
Get-Service | Where-Object { $_.DisplayName -like "*ScreenConnect*" }

# Stop and disable the service to prevent restart
Get-Service -Name "*ScreenConnect*" | Stop-Service -PassThru | Set-Service -StartupType Disabled

# Remove the service registration via sc.exe
sc.exe delete "ScreenConnect ClientService"
Artifact Cleanup: Cleared staging directories in C:\Program Files (x86)\ScreenConnect* and user AppData\Local\Temp directories to ensure complete removal of residual binaries.

Persistence Inspection: Inspected Task Scheduler and Registry Run keys (HKLM\Software\Microsoft\Windows\CurrentVersion\Run) to ensure no automated reboot triggers remained.

4. Phase 4: Forensic Verification & Log Review
Inspected Windows Security Event Logs (Security.evtx) for anomalous logon events and administrative privilege escalation:

Event ID 4624: Successful Logon analysis (checking logon types and network source IPs).

Event ID 4672: Special privileges assigned to new logon sessions.

Event ID 4688: Process creation logs to confirm execution command-line arguments.

Governance, Risk & Compliance (GRC) Takeaways
Access Governance & Least Privilege (AC-6): Restricted standard workstation permissions so non-administrative users cannot execute unapproved installers or background services.

Software Whitelisting & Asset Integrity (CM-7): Updated software restriction policies to block unauthorized remote administration tools on front-desk and POS networks.

Audit & Accountability (AU-2 / AU-6): Established baseline event log monitoring criteria to flag unexpected remote desktop and management utility launches.

SOP Documentation: Authored a standard incident response runbook in Confluence for staff to report and isolate unapproved remote access prompts immediately.

Author
Deepika Dasari Love

IT Support Specialist | Systems Administration & Access Governance

LinkedIn Profile: https://www.linkedin.com/in/deepikadasarilove/
