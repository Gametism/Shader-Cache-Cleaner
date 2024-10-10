# Shader-Cache-Cleaner

The Shader Cache Cleaner script is a Windows batch file designed to help users delete shader cache files associated with various graphics drivers, including NVIDIA, AMD, and Intel. The script checks for administrative privileges before proceeding and allows users to add custom shader cache paths for cleanup. It logs its operations to a log file for reference. Shader caches store precompiled shaders to improve game performance, but occasionally, they can cause issues and may need to be deleted.


Key Features:


Administrative Privileges:

The script checks if it is running with administrative rights and prompts for elevation if not.


Cache Location Definitions:

It defines specific directories for NVIDIA, AMD, and Intel shader caches that are commonly found in the user's AppData directory.


User Interaction:

Users are welcomed with a message and given the option to proceed with cleaning the caches or to cancel the operation.
The script confirms with the user before proceeding with the deletion of cache files.


Custom Path Option:

Users can specify a custom path for shader cache directories they wish to clean. This is useful for game-specific cache files not covered by the predefined paths.



Cache Deletion:

The script attempts to delete the contents of the defined shader cache directories. If successful, it informs the user; if not, it provides feedback about any issues encountered (e.g., files in use).

Logging:

All actions taken by the script, including deletions and errors, are logged into a log file located in the user's AppData directory. This allows users to review what actions were performed and to troubleshoot any issues.

User Feedback:

Throughout the process, the script provides feedback in the console and records important messages in the log file, making it user-friendly.


Error Handling:

The script checks for the existence of directories before attempting to delete them and informs the user if any specified paths are not found.


Guidance for NVIDIA/AMD Users:

If shader issues persist, the script provides advice on how to reset or disable the shader cache in the NVIDIA or AMD control panels.



This script is useful if you are experiencing performance issues or stuttering in games, as clearing shader caches can sometimes resolve such problems.


MIT license
