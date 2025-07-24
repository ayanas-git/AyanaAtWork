# <span style="color:#FF5733;">A</span><span style="color:#33FF57;"> n</span><span style="color:#3357FF;">E</span><span style="color:#FF33A8;">r</span><span style="color:#FFD733;">d</span><span style="color:#33FFF5;">y</span> <span style="color:#FF5733;">G</span><span style="color:#57FF33;">u</span><span style="color:#33D7FF;">i</span><span style="color:#FF33D7;">d</span><span style="color:#D733FF;">e</span> <span style="color:#FF5733;">t</span><span style="color:#33FF57;">o</span> <span style="color:#FF33A8;">[</span><span style="color:#33FFF5;">m</span><span style="color:#FFD733;">y</span><span style="color:#FF33A8;">]</span> <span style="color:#FF5733;">G</span><span style="color:#57FF33;">i</span><span style="color:#33D7FF;">t</span> <span style="color:#FF5733;">E</span><span style="color:#3357FF;">n</span><span style="color:#FFD733;">v</span><span style="color:#33FFF5;">i</span><span style="color:#FF33D7;">r</span><span style="color:#D733FF;">o</span><span style="color:#33FF57;">n</span><span style="color:#33D7FF;">m</span><span style="color:#FF33A8;">e</span><span style="color:#FF5733;">n</span><span style="color:#33FF57;">t</span> <span style="color:#FF5733;">a</span><span style="color:#57FF33;">n</span><span style="color:#33D7FF;">d</span> <span style="color:#FF5733;">W</span><span style="color:#33FF57;">o</span><span style="color:#FF33A8;">r</span><span style="color:#D733FF;">k</span><span style="color:#FF33D7;">f</span><span style="color:#33FFF5;">l</span><span style="color:#3357FF;">o</span><span style="color:#FFD733;">w</span>


> This is a colorful journey, not just a technical one. The guide you're about to explore combines my real-world learning, automation lessons, and Git best practices to build a complete workflow system for managing branches, merging specific files, handling SSH keys, and refreshing environments with elegance and clarity.

---

## Table of Contents

1. [Introduction](#introduction)
2. [SSH Configuration (GitHub + Azure DevOps)](#ssh-configuration)
3. [Local Git Workflow: Managing Specific File Merges](#local-git-workflow)
4. [Selective Branching & File Control](#selective-branching)
5. [Environment Refresh Process](#environment-refresh)
6. [Beginner-Friendly Command Glossary](#command-glossary)
7. [Troubleshooting and Pro Tips](#troubleshooting-and-pro-tips)
8. [Conclusion](#conclusion)
9. [Resources](#resources)

---

## Introduction

This guide helps users:

- Merge specific folders/files from a dev or project branch into a final branch.
- Push changes to a remote repository (e.g., GitHub, Azure DevOps) **without affecting other files**.
- Apply selective syncing, cleanup workflows, and environment refresh techniques using PowerShell, Git CLI, and VS Code.

---

## SSH Configuration

SSH keys are your secure passcards to cloud repositories like GitHub or Azure DevOps.

### Why Use Separate Keys?

Think of SSH keys like door keys. You wouldn't use your house key to open your office door. One key per platform helps you stay secure and avoids conflicts.

### Step-by-Step SSH Key Setup

#### 1. Generate SSH Keys (GitHub)

```powershell
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f $HOME\.ssh\github_rsa
```

#### 2. Generate SSH Keys (Azure DevOps)

```powershell
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -f $HOME\.ssh\azure_rsa
```

#### 3. SSH Config File (PowerShell)

```powershell
@"
Host github.com
    HostName github.com
    User git
    IdentityFile $HOME\.ssh\github_rsa
    IdentitiesOnly yes

Host ssh.dev.azure.com
    HostName ssh.dev.azure.com
    User git
    IdentityFile $HOME\.ssh\azure_rsa
    IdentitiesOnly yes
"@ | Out-File -Append -FilePath $HOME\.ssh\config
```

#### 4. Set Permissions

```powershell
icacls "$HOME\.ssh\github_rsa" /inheritance:r /grant:r "$($env:USERNAME):(R)"
icacls "$HOME\.ssh\azure_rsa" /inheritance:r /grant:r "$($env:USERNAME):(R)"
```

#### 5. Add Keys to GitHub/Azure DevOps

Use `Get-Content` + copy to clipboard, paste on the site.

#### 6. Test Connections

```bash
ssh -T git@github.com
ssh -T git@ssh.dev.azure.com
```

---

## Local Git Workflow

### Goal

Update `main` branch with **only selected folders/files** from another branch (like `project` or `dev`).

### 1. Create a New Branch

```bash
git checkout -b project
```

### 2. Stage Only the Folder You Want

```bash
git add ./ad-hoc/project/project1
```

### 3. Commit Changes

```bash
git commit -m "Add: project1 folder only"
```

### 4. Merge Into Final Branch (e.g., `transmit`)

```bash
git checkout transmit
git merge project --no-commit
```

### 5. Push to Remote

```bash
git push origin transmit
```

---

## Selective Branching

To keep your `dev` branch messy and `main` branch clean:

- Use `.git/info/exclude` (local-only ignores)
- Use `.gitattributes` with `skip-worktree`
- Maintain `.vscode/`, logs, or temp folders locally without pushing

### Git Attributes Example

```bash
.vscode/* skip-worktree
notebooks/tmp/* skip-worktree
```

Use this to prevent diffs and conflicts when switching branches.

---

## Environment Refresh

This refreshes local Git with remote updates.

### 1. Go to the Local Branch

```powershell
cd C:\Users\me\repos\project-folder
```

### 2. Check Differences

```powershell
git diff origin/main
```

✅ **Green** = Changes in current branch, not in `origin/main`  
❌ **Red** = Changes in `origin/main`, not in current branch

### 3. Fetch Remote Updates

```powershell
git fetch origin
```

> Pro tip: Add `--prune` if you're managing lots of stale remote branches.

### 4. Review Status

```powershell
git status
```

This shows if you're ahead/behind the remote, and lists staged or unstaged files.

### 5. Optional Diffs

```powershell
git diff origin/main
```

Use this to preview what pushing would do. Expect green = additions, red = deletions.

### 6. Merge and Continue

If you’ve confirmed what you want to keep:

```powershell
git cherry-pick <commit-hash>
```

Repeat per commit, or skip commits as needed.

---

## Command Glossary

| Command | Purpose |
|--------|---------|
| `git fetch origin` | Sync remote state, don’t apply yet |
| `git diff` | Compare differences |
| `git cherry-pick <hash>` | Apply a single commit |
| `git add path/` | Stage a file or folder |
| `git reset --soft HEAD~1` | Undo the last commit (keep changes) |

---

## Troubleshooting and Pro Tips

- **Deleted too much?** Use `git reflog` to find the lost commit.
- **Keep your config**: Save SSH config snippets per environment.
- **VS Code doesn’t show new files?** Use `Refresh` or reopen the folder.

---

## Conclusion

This has been a true journey in building my Git automation style — from SSH keys, selective commits, `skip-worktree`, and interactive diffs to keeping remote history clean and professional. I've broken and rebuilt many repos to land on this setup.

Whether you're merging one folder, or streamlining 50 repos, these patterns will save time and reduce risk. This guide isn’t exhaustive — it’s evolving, just like the work we do.

Thank you for reading — may your commits be clean and your diffs be small. 💻

---

## Resources

- [Git - Official Documentation](https://git-scm.com/doc)
- [GitHub Docs: SSH](https://docs.github.com/en/authentication/connecting-to-github-with-ssh)
- [Pro Git Book](https://git-scm.com/book/en/v2)
- [Stack Overflow Git Questions](https://stackoverflow.com/questions/tagged/git)
- [Visual Git Guide](https://marklodato.github.io/visual-git-guide/index-en.html)
- [Zscaler Certificate Setup (Corporate)](https://help.zscaler.com/zia/about-ssl-inspection)
