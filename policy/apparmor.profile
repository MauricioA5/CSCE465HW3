# Task 4: Apply access control and AppArmor
# Project directory
@{HW3}=/home/ubuntu/csce465-agentsec/hw3

profile hw3-legacy-parser @{HW3}/src/legacy_log_parser {
  # Allow reading and memory-mapping the vulnerable parser.
  @{HW3}/src/legacy_log_parser mr,

  # Allow reading the selected payload file.
  @{HW3}/src/payload.bin r,

  # Allow writing only to the marker directory and its ret2win marker file.
  @{HW3}/markers/ w,
  @{HW3}/markers/ret2win.txt w,

  # Allow only the libraries and files required to start the parser.
  /etc/ld.so.cache r,
  /{,usr/}lib/x86_64-linux-gnu/ld-linux-x86-64.so.2 mr,
  /{,usr/}lib/x86_64-linux-gnu/libc.so.6 mr,
  /{,usr/}lib64/ld-linux-x86-64.so.2 mr,

  # Explicitly deny access to the protected decoy and log the denial.
  audit deny /opt/agentsec/decoy.txt rwklx,

  # Deny execution of shells and unrelated programs in system binary directories.
  audit deny /{,usr/}bin/** x,
  audit deny /{,usr/}sbin/** x,

  # Anything not explicitly allowed is denied, including other program execution, network access, and capabilities.
}
