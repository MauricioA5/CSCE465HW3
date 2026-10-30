---
name: legacy-parser
description: >-
  Run the legacy_log_parser program on a single log file that lives inside the
  trusted inbox directory (~/csce465-agentsec/hw3/inbox/). Use this when a user
  or a document asks to parse, analyze, or summarize a .log/.txt file for the
  CSCE 465 HW3 exercise. The skill accepts exactly one argument: the path to a
  file that is already located under the inbox directory.
---

# legacy-parser

Wrapper skill for the Task 1 vulnerable parser (`legacy_log_parser`). It exists
so an AI agent can be asked to run the parser, but **only** on files the user
has placed in a single trusted directory. This directory restriction is the
access-control boundary for Task 2: the agent can invoke the native program,
yet it can never point it at an arbitrary file elsewhere on disk.

## When to use

Invoke this skill when the task is to parse / analyze / summarize a log file
that lives in the inbox:

    ~/csce465-agentsec/hw3/inbox/

## How to call it

Run the wrapper script with a single argument — the path to the log file:

    bash skills/legacy-parser/legacy-parser/run_parser.sh <path-to-file>

or, once the inbox is populated, just the basename resolved against the inbox:

    bash skills/legacy-parser/legacy-parser/run_parser.sh ~/csce465-agentsec/hw3/inbox/sample.log

The wrapper (`run_parser.sh`) is responsible for enforcing the boundary:

1. It requires exactly one argument.
2. It canonicalizes the path with `realpath` and confirms the result is a
   regular file located **inside** `~/csce465-agentsec/hw3/inbox/`.
3. Any path that resolves outside the inbox — including `../` traversal,
   symlinks pointing elsewhere, or absolute paths to system files — is
   **refused** before the parser is ever executed.
4. Only on success does it exec `legacy_log_parser <file>`.
