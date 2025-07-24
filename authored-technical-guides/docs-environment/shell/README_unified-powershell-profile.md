# 💻 Ayana's Unified PowerShell Profile

This setup provides a consistent, scalable PowerShell experience across:

- Windows PowerShell (v5)
- PowerShell 7+
- Integrated environments like VS Code

## 🔗 Central Profile File

All shell profiles point to a single global file:

```powershell
C:\usersettings\appprofiles\psprofile-global.ps1
```

This file contains:

```powershell
# Global PowerShell Profile
# This script is loaded for all PowerShell sessions

# Import the global profile
. "C:\usersettings\appprofiles\psprofile-global.ps1"
```

- Custom `$PSReadLine` options and colors
- Smart prompt behavior per PowerShell version
- Tab completion, inline prediction styling
- Optional loading hooks for future modules (e.g., Conda, Oh My Posh)

## 🛠️ Profile Redirects

These redirector files are created per user and shell type:

``` powershell
C:\Users\dvusr\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
C:\Users\dvusr\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1
```

They simply contain:

```powershell
. "C:\usersettings\appprofiles\psprofile-global.ps1"
```

Other default profile files were removed to prevent duplication or redundant execution:

- `C:\Windows\System32\WindowsPowerShell\v1.0\profile.ps1`
- `C:\Windows\System32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1`
- `C:\Users\dvusr\Documents\WindowsPowerShell\profile.ps1`

## ✅ VS Code Integration

VS Code terminals (PowerShell 7) correctly load the global profile and display expected output:

- “✅ Unified PowerShell Profile Loaded!”
- `$PSReadLine` styles are active
- Behavior matches visual and dev preferences

## 🔮 Future Expansion

This design allows easy integration with:

``` powershell
C:\usersettings\appprofiles\
├── vscodeprofile.ps1              ← VS Code shell logic
├── conda-init.ps1                 ← Conda environment injection
├── oh-my-posh-theme.omp.json      ← Oh My Posh theme
├── gitconfig-global               ← Shared Git config
```

## 📁 Suggested Repo Layout

``` powershell
C:\usersettings\appprofiles\
├── psprofile-global.ps1
├── powershell-profile-manifest.md
├── README.md
```

Built by Ayana to streamline multi-user PowerShell workflows and stay cute doing it. ✨
