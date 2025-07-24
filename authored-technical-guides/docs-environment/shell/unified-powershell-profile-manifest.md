# 🧭 PowerShell Profile Setup Manifest

**Owner:** Ayana  
**Last updated:** 2025-05-02  
**Purpose:** Unified, centralized profile configuration for all PowerShell shells and users.

---

## 📁 Root Config Directory

```powershell
C:\
└── usersettings\
    ├── appprofiles\
    │   └── psprofile-global.ps1              ← ✅ Master profile (all logic lives here)
    ├── archives\                             ← 🗂️ (Optional) Old or deactivated profile scripts
    │   └── ps-profiles\                       ← 🔐 Backup folder for legacy profile files
```

---

## 📂 User Profile Redirectors

### 🔹 dvusr

```powershell
C:\Users\dvusr\
└── Documents\
    ├── WindowsPowerShell\
    │   └── Microsoft.PowerShell_profile.ps1  ← 🔗 Redirects to psprofile-global.ps1
    └── PowerShell\
        └── Microsoft.PowerShell_profile.ps1  ← 🔗 Redirects to psprofile-global.ps1
```

✅ These two are the *only* active profile files in the system.  
🗑️ The following were removed to avoid duplicate profile execution:

- `C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1`
- `C:\Windows\System32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1`
- `C:\Users\dvusr\Documents\WindowsPowerShell\profile.ps1`

---

## 💻 VS Code Confirmation

VS Code terminal automatically uses PowerShell 7 (`pwsh`) as its default shell.

- ✅ Terminal successfully loads the unified profile file
- ✅ `$PSReadLine` settings, prompt aesthetics, and status messages appear correctly
- 🧠 Confirms that profile logic is being respected even in integrated shell environments

---

## 🔮 Future Expansion Slots

You may later add:

```powershell
C:\usersettings\appprofiles\
├── vscodeprofile.ps1          ← (VS Code-specific shell config)
├── conda-init.ps1             ← (Conda environment injection)
├── oh-my-posh-theme.omp.json  ← (Oh My Posh theme file)
├── gitconfig-global           ← (Shared Git config)
```

---

## 🧠 Design Philosophy

- All logic lives in a single global file: `psprofile-global.ps1`
- Individual user profiles contain only redirects
- Missing profile files are left absent **on purpose** to aid debugging
- Shell output is customized to help identify which environment is active
- Structure is designed to scale to additional user accounts or apps later
