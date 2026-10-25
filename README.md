# Windows Endpoint Triage & Unauthorized Remote Access Remediation Toolkit

## Overview
This repository provides an operational, automated incident response framework for auditing, isolating, and remediating unauthorized remote access tooling (including ScreenConnect, AnyDesk, TeamViewer, and associated persistence mechanisms) on Windows endpoints. 

Designed for security analysts and IT administrators, this workflow maps directly to the **NIST SP 800-61 Rev. 2** Incident Handling lifecycle (Identification, Containment, Eradication, and Recovery).

---

## Threat Context & Objective
* **Risk**: Shadow IT or unauthorized remote administration tools (RATs) introduce unmonitored ingress/egress points, bypassing access controls and policy baselines.
* **Objective**: Automate the identification of live processes, inbound/outbound connections, scheduled persistence, file artifacts, and service registrations to perform safe, auditable containment and eradication.

---

## Incident Handling Workflow
