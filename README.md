# CSCE 465 — Homework 3

Team: Mauricio Aguilar and Juel Sandy

## Working environment

Run all commands inside the Ubuntu course VM from `~/csce465-agentsec/hw3`.

## HW Environment Setup
```bash
sudo apt update
sudo apt install -y build-essential gdb binutils checksec apparmor-utils acl python3
cd ~/csce465-agentsec/hw3
mkdir -p markers inbox evidence
```

Create the fake protected file once:

```bash
sudo mkdir -p /opt/agentsec
printf 'FAKE-COURSE-SECRET\n' | sudo tee /opt/agentsec/decoy.txt
sudo chmod 600 /opt/agentsec/decoy.txt
```

## Layout

- `src/`: vulnerable parser, fixed parser, and payload generator.
- `skills/legacy-parser/`: OpenClaw skill and wrapper.
- `web/`: local adversarial webpage.
- `policy/`: AppArmor profile.
- `tests/`: test scripts and inputs.
- `evidence/`: selected command output, screenshots, and agent traces.
- `ai_usage/`: individual team member's AI-use disclosure and relevant conversation logs.

## Collaboration
- Juel Sandy: Task 1, Task 2; 50%
- Mauricio Aguilar: Task 3, Task 4; 50%

## Build and run

Build the original vulnerable parser:

```bash
gcc -O0 -g -fno-stack-protector -no-pie -Wl,-z,noexecstack \
  -Wall -Wextra -o src/legacy_log_parser src/legacy_log_parser.c
checksec --file=./src/legacy_log_parser
```

Generate the payload inside `src/`:

```bash
(cd src && python3 make_payload.py)
```

Task 2 files are in `skills/legacy-parser/` and `web/`. The saved agent trace is `evidence/openclaw_task2.txt`.

Build the fixed parser. and perform task 3 objectives:

```bash
bash tests/run_task3.sh
```

### Task 4 setup

Create the dedicated account once, then grant access to the required files:

```bash
sudo useradd --system --create-home --shell /usr/sbin/nologin agentlab
sudo setfacl -m u:agentlab:--x /home/ubuntu /home/ubuntu/csce465-agentsec \
  /home/ubuntu/csce465-agentsec/hw3
sudo setfacl -m u:agentlab:--x src
sudo setfacl -m u:agentlab:r-x src/legacy_log_parser
sudo setfacl -m u:agentlab:r-- src/payload.bin
sudo setfacl -m u:agentlab:rwx markers
```

The profile uses `/home/ubuntu/csce465-agentsec/hw3`. Update `@{HW3}` in `policy/apparmor.profile` if your VM path differs.

```bash
sudo install -m 644 policy/apparmor.profile /etc/apparmor.d/hw3-legacy-parser
sudo apparmor_parser -r /etc/apparmor.d/hw3-legacy-parser
sudo aa-enforce /etc/apparmor.d/hw3-legacy-parser
sudo aa-status
```

Task 3 screenshots are in `evidence/Task3/`. Task 4 setup output and the denial screenshot are in `evidence/Task4/`.

## Known Issues

To gather Task 4 evidence, the following commands were needed. The temporary ACL grants ordinary read access to the decoy so the denial demonstrates AppArmor enforcement:

```bash
sudo setfacl -m u:agentlab:r-- /opt/agentsec/decoy.txt

sudo rm -f markers/ret2win.txt
date -Is
sudo -u agentlab -- ./src/legacy_log_parser ./src/payload.bin

sudo journalctl -k --since "2 minutes ago" --no-pager \
  | grep 'apparmor="DENIED"' \
  | grep 'hw3-legacy-parser'
```

```bash
sudo setfacl -x u:agentlab /opt/agentsec/decoy.txt
```
