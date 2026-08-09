---
name: Bug report
about: Create a report to help us improve
title: 'Bug:'
labels: 'bug'
assignees: yowmamasita

---

**Expected Behavior**
Describe what you expect to happen.

**Actual Behavior**
Describe what is actually happening.

**Detailed Steps**
Detail out everything that you did leading up to the issue.
Include any relevant setup information that we should know about.

**Operating System**
What OS are you running? (e.g., Windows, macOS, Linux)
If on Windows, are you using Windows Subsystem for Linux (WSL)?

**Environment Setup**
Are you using Docker, or are you using Zurg's binary?
If Docker, please include your `docker-compose.yml`.
If Zurg's binary, specify the version by running `./zurg version`

**Logs and configuration**
Go to http://ZURGIP:9999/debug/upload and paste the two links here. That uploads your logs and your config with the token, username, password and download links already redacted, so it is safe to share.

If you are running it in Docker, your container logs will also help.

**Rclone Configuration**
Attach or detail your `rclone.conf` — remove any password/bearer token first.

**Screenshots**
If applicable, add screenshots to help explain your problem.
