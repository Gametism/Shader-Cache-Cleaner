# Shader-Cache-Cleaner

--------------------------------------------------------------------------------------------------------------------------------------------

This script helps clean up the shader caches for your NVIDIA, AMD, and Intel graphics cards. Shader caches store precompiled shaders to improve game performance, but occasionally, they can cause issues and may need to be deleted.


Key Features:


Administrative Privileges:

The script runs with Administrator Rights to ensure it can delete all necessary files.


User Confirmation:

Before proceeding with any deletions, the script prompts you to confirm if you want to delete all shader caches.


Shader Cache Deletion:

The script will attempt to delete shader caches from the following locations:
NVIDIA: DXCache, GLCache, and NV_Cache.
AMD: DxCache and GLCache.
Intel: ShaderCache and Low ShaderCache.


Error Handling:

If the script cannot delete certain files (e.g., if they are in use by the system), it notifies the user of the failure.


Guidance for NVIDIA/AMD Users:

If shader issues persist, the script provides advice on how to reset or disable the shader cache in the NVIDIA or AMD control panels.



This script is useful if you are experiencing performance issues or stuttering in games, as clearing shader caches can sometimes resolve such problems.

License
MIT license
