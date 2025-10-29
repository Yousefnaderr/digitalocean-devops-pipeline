Invoice CronJob (DigitalOcean → Slack)

This Kubernetes CronJob automates the process of fetching **DigitalOcean invoices** and sending them to a **Slack channel** for financial visibility and cost monitoring.

---

#Overview

The `invoice-job.yml` defines a scheduled Kubernetes CronJob that runs a small script or container responsible for:

- Fetching the **latest invoice data** from the DigitalOcean API.
- Formatting the invoice summary (usage, credits, and total).
- Sending a structured message to a predefined **Slack channel** using a Slack webhook.

This process ensures the DevOps team receives monthly billing insights directly in Slack without any manual steps.

---

#Schedule

#3 times per month** | The job runs on the **8th**, **22th**, and **29th** of every month at **09:00 UTC** (adjust as needed)

