# ceaserCypher_Irvine32

A menu-driven Caesar Cipher implementation written in x86 Assembly (MASM) using the Irvine32 library. This repository demonstrates low-level procedural design, string handling, and simple cryptographic transformation implemented in assembly language. The project focuses on clarity of procedures, correct ASCII handling for alphabetic characters, and a user-friendly console menu.

---

Table of contents
- Project overview
- Features
- Background: Caesar Cipher explained
- Design and implementation details
- Files and module responsibilities
- Prerequisites
- Build and run instructions
- Usage examples
- Behavior and edge cases
- Testing and verification
- Troubleshooting
- Contributing
- License and author / contact

---

Project overview
This project implements the classical Caesar Cipher (a monoalphabetic substitution where each alphabetic character is shifted by a fixed number of positions). The implementation is written in MASM (Microsoft Macro Assembler) and uses the Irvine32 support library by Kip Irvine for convenient console I/O and some helper macros. The program is menu-driven and supports both encryption and decryption of user-supplied text, with clear separation of responsibilities through well-defined assembly procedures.

Features
- Encrypt plain text with a user-specified shift (positive integer).
- Decrypt cipher text using the inverse of the specified shift.
- Menu-driven console interface with input validation.
- Preserves case: uppercase letters remain uppercase, lowercase remain lowercase.
- Non-alphabetic characters (digits, punctuation, whitespace) are left unchanged.
- Clean, modular assembly code: main program delegates tasks to clear procedures.

Background: Caesar Cipher explained
- The Caesar Cipher replaces each letter by another letter fixed positions away in the alphabet.
- Example with shift = 3: 'A' -> 'D', 'B' -> 'E', ..., 'X' -> 'A', 'Y' -> 'B', 'Z' -> 'C'.
- To decrypt, apply the same shift in the opposite direction (or shift by 26 - key).
- Important details for correct implementation:
  - Wrap-around at the end of the alphabet (modulo 26 arithmetic).
  - Preserve upper/lower case: treat 'A'..'Z' and 'a'..'z' separately.
  - Leave non-letter characters unchanged.

Design and implementation details
- Procedural approach: the code is organized into small, testable procedures (routines) such as:
  - Input routine: reads a line of text from the console.
  - Parse/validate shift routine: accepts and validates the numeric key (0..25 or larger, reduced modulo 26).
  - Cipher routine: performs the shift for a single character or a string.
  - Menu routine: prints options and dispatches the selected action.
- Character handling:
  - For uppercase letters (ASCII 65..90), compute offset = (ch - 'A' + shift) mod 26, result = 'A' + offset.
  - For lowercase letters (ASCII 97..122), compute offset = (ch - 'a' + shift) mod 26, result = 'a' + offset.
  - For all other characters, return unchanged.
- Shift normalization: input shift values should be normalized using shift % 26 so that very large keys behave as expected.
- Error handling: input validation for numeric keys and menu choices; safe buffer sizes for string input to prevent overflow.

Files and module responsibilities
Note: replace example filenames below with the actual filenames in the repository if they differ.

- README.md
  - This file: project description, usage, and development notes.
- caesar.asm (or main.asm)
  - The program entry point, menu loop, and high-level flow.
- cipherproc.asm (or cipher.asm)
  - Contains the Caesar cipher procedures: apply shift to bytes/strings, normalize shift, etc.
- ioproc.asm (or utils.asm)
  - Console I/O wrappers using Irvine32 services (ReadString, WriteString, ReadInt, etc.).
- Irvine32.inc / Irvine32.lib
  - External Irvine library header and library files used for simple console I/O and helper macros. These are not included here and must be provided by the user (see prerequisites).

Prerequisites
- MASM assembler (ml.exe) and linker (link.exe). Usually comes with:
  - Visual Studio (C++ Desktop development workload with MASM support), or
  - The MASM32 SDK (community-provided, includes ml and tools).
- The Irvine32 library (Irvine32.inc, Irvine32.lib, and Irvine32.dll if used). The library is commonly used in academic MASM projects and is available from Kip Irvine's course resources.
- A Windows development environment (the code uses the Irvine32 library and is targeted at 32-bit x86 using the Windows console).

Build and run instructions (typical)
1. Set up the environment
   - Open "Developer Command Prompt for VS" (so ml.exe and link.exe are on PATH), or use the MASM32 shell if using MASM32.
   - Make sure the assembler include path contains `Irvine32.inc` and the linker path contains `Irvine32.lib`. You can copy these files into the project directory or set INCLUDE/LIB environment variables.

2. Assemble and link (example commands)
   - Assemble:
     ```
     ml /c /coff caesar.asm
     ```
     `/c` = compile only, `/coff` = produce COFF object for the linker.
   - Link:
     ```
     link /SUBSYSTEM:CONSOLE caesar.obj Irvine32.lib
     ```
     Adjust the object and library names to match your files. If the project uses multiple assembly modules, assemble all modules and include all object files in the link step.

3. Run:
   - Execute the produced `.exe` from the same command prompt:
     ```
     caesar.exe
     ```
   - Follow the menu prompts to encrypt or decrypt text.

Usage examples
- Encrypt a message:
  - Select the "Encrypt" menu option.
  - Enter the plaintext: "Hello, World!"
  - Enter the shift (key): 3
  - Output: "Khoor, Zruog!"
- Decrypt the previous message:
  - Select "Decrypt".
  - Enter ciphertext: "Khoor, Zruog!"
  - Enter shift: 3
  - Output: "Hello, World!"

Behavior and edge cases
- Shift normalization:
  - Input keys larger than 26 are handled by taking key modulo 26. Example: key 29 behaves like key 3.
- Negative keys:
  - If negative keys are supported by input routine, they should be converted to their positive equivalent (key mod 26) before use.
- Non-letter characters:
  - Digits, punctuation, and whitespace remain unchanged to preserve message structure.
- Buffer sizes:
  - The input routine should enforce a maximum string length to avoid buffer overruns. Irvine32's ReadString lets you specify a buffer size; ensure the buffer in .data is sized accordingly.

Testing and verification
- Unit test ideas:
  - Single-letter wrap-around: 'Z' with key 1 -> 'A'; 'z' with key 2 -> 'b'.
  - Full rotation: key 26 should return the original text.
  - Non-letter preservation: "123!?" should remain unchanged.
  - Case preservation: check mixed-case strings maintain cases after transformation.
- Manual tests:
  - Run a sequence of encrypt -> decrypt with the same key and verify original message recovery.
  - Try boundary keys (0, 25, 26, >26) and negative values if supported.

Troubleshooting
- Linker errors referencing Irvine32 symbols:
  - Ensure Irvine32.lib is present and included in the link command and the library search path.
- Assemble errors about unknown macros or directives:
  - Confirm the assembler is MASM (ml.exe) and Irvine32.inc is included at top of your assembly file with correct path.
- Console I/O not functioning:
  - Make sure you linked with /SUBSYSTEM:CONSOLE and the executable is run from a console.

Contributing
- If you wish to extend or improve the project:
  - Use modular procedures for added features (file I/O, larger alphabets, ROT13 quick option).
  - Add automated test scripts (batch files) that run common scenarios and assert outputs.
  - Document any new dependencies or build steps in this README.

License and author / contact
- MIT License
- Email: ak49392919@gmail.com

---
