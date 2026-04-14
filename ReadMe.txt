## How to Use

1. Download and extract the files.
2. Run the BAT file.
3. The tool will automatically scan your system for shader caches.
4. Review the found cache folders/files shown on screen.
5. Confirm deletion if you want to proceed.

---

## Shader Cache Cleaner v0.2

Shader Cache Cleaner is a Windows batch utility designed to locate and remove shader cache files created by graphics drivers, DirectX, and supported games.

Shader caches store precompiled shaders to reduce loading times and improve performance. However, corrupted or outdated cache files can sometimes cause:

* stuttering
* hitching
* long shader compilation times
* graphical issues
* poor game performance after updates

Clearing shader caches can often resolve these problems.

---

## Key Features

### Administrative Privileges

The script checks if it is running with administrator rights.
If not, it automatically requests elevation before continuing.

---

### Automatic Cache Detection

Instead of deleting predefined paths blindly, Version 0.2 first scans your system and only lists shader caches that are actually found.

---

### Supported Cache Locations

The tool checks common Windows shader cache locations, including:

#### NVIDIA

* DXCache
* GLCache
* NV_Cache

#### AMD

* DxCache
* GLCache

#### Intel

* ShaderCache
* Low ShaderCache

#### Microsoft / DirectX

* D3DSCache

---

### Unreal Engine Game Cache Detection

Version 0.2 also scans `%LOCALAPPDATA%` for Unreal Engine style shader cache files commonly used by games.

Examples:

* `*_ShaderCacheCheck.bin`
* `*.upipelinecache`

Such as:

* `MGSDeltaFix_ShaderCacheCheck.bin`
* `Bloodlines2_PCD3D_SM6.upipelinecache`

---

### Found Cache Preview Before Deletion

Before deleting anything, the script shows every detected cache item.

Example:

[Folder] NVIDIA DXCache
[Folder] DirectX D3DSCache
[File] Bloodlines2_PCD3D_SM6.upipelinecache

---

### Safe Confirmation Prompt

No deletion happens automatically.

The script asks for confirmation before removing any detected cache folders or files.

---

### Logging

All actions are logged to:

%LOCALAPPDATA%\ShaderCacheCleaner.log

The log includes:

* scan results
* deleted items
* failed deletions
* timestamps
* cancellation events

---

### User Feedback

The tool provides clear live feedback in the console during:

* scanning
* found results
* deletion progress
* final summary

---

### Error Handling

The script checks whether files/folders exist before deleting them.

If something cannot be removed (for example currently in use), it reports the failure instead of silently skipping it.

---

### Helpful Guidance After Cleanup

If shader problems continue, the tool recommends restarting Windows and resetting shader cache manually in your GPU control panel.

#### NVIDIA

Manage 3D Settings → Shader Cache Size

#### AMD

Graphics → Advanced → Reset Shader Cache

---

## Why Use It?

Shader Cache Cleaner v0.2 is useful if you experience:

* stutter after driver updates
* Unreal Engine games recompiling endlessly
* corrupted shader caches
* poor frametimes
* random hitching
* post-update performance drops

---

## License

MIT License
