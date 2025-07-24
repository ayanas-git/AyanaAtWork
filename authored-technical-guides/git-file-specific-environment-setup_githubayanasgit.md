# Git Environment Setup and Workflow Guide

Configuring Git for Branch-Specific File Tracking and Exclusions

This guide provides a comprehensive breakdown for configuring a Git environment to:

* **Track development-specific files in `dev`** but exclude them from other branches (`main`, `wip`).
* **Prevent dev folders from appearing in diffs or commit comparisons** in non-dev branches.
* **Flexibly manage branch-specific rules** to keep `main` clean for production-ready files.

---

## Table of Contents

[Git Environment Setup and Workflow Guide](#git-environment-setup-and-workflow-guide)
[Table of Contents](#table-of-contents)
[1. Overview of Branch-Specific Tracking and Exclusions](#1-overview-of-branch-specific-tracking-and-exclusions)
[2. Setting Up the Global `.gitignore`](#2-setting-up-the-global-gitignore)
[Steps for Creating and Editing Global `.gitignore`](#steps-for-creating-and-editing-global-gitignore)
[3. Using `.git/info/exclude` for Local Dev Exclusions](#3-using-gitinfoexclude-for-local-dev-exclusions)
[Steps for Setting Up `.git/info/exclude` in `dev`](#steps-for-setting-up-gitinfoexclude-in-dev)
[4. Combining with `.gitattributes` for `skip-worktree`](#4-combining-with-gitattributes-for-skip-worktree)
[Steps for Setting Up `.gitattributes` in `dev`](#steps-for-setting-up-gitattributes-in-dev)
[5. Branch Workflow: Dev → Wip → Main](#5-branch-workflow-dev--wip--main)
[Step-by-Step Branch Workflow](#step-by-step-branch-workflow)
[6. Testing and Verifying Configuration](#6-testing-and-verifying-configuration)
[Commands to Test Exclusions](#commands-to-test-exclusions)
[7. Common Commands and Expected Outputs](#7-common-commands-and-expected-outputs)
[Branch Comparison Commands](#branch-comparison-commands)
[8. Troubleshooting and Tips](#8-troubleshooting-and-tips)
[Conclusion](#conclusion)
[Additional Resources](#additional-resources)

---

## 1. Overview of Branch-Specific Tracking and Exclusions

To maintain an organized Git workflow, each branch will serve a distinct purpose:

* **main**: The stable, production-ready branch with only essential files for remote pushing.
* **dev**: A development branch where `.vscode` and dev-specific files are **tracked locally** but **excluded from `main`**.
* **wip**: A transitional branch to test and stage changes between `dev` and `main`.

This setup avoids using `.gitignore` for files specific to `dev`, instead using **local ignore files and attributes** to keep them isolated within `dev`.

---

## 2. Setting Up the Global `.gitignore`

The global `.gitignore` is intended for files universally ignored across all projects (e.g., OS or IDE-specific files) but not for dev-specific files.

### Steps for Creating and Editing Global `.gitignore`

1. **Location**: `~/.config/git/ignore`
2. **Purpose**: Ignore universally unwanted files (e.g., OS-generated files) across all repositories on your system.
3. **PowerShell Command**:

   ```powershell
   if (!(Test-Path -Path "~/.config/git/ignore")) {
       New-Item -Path "~/.config/git" -ItemType Directory -Force
       New-Item -Path "~/.config/git/ignore" -ItemType File
   }
   ```

4. **Add Universal Ignore Patterns**:

   * Open the global `.gitignore` file:

     ```powershell
     code ~/.config/git/ignore
     ```

   * Example rules:

     ```powershell
     # OS generated files
     *.DS_Store
     *.swp
     *.log
     ```

---

## 3. Using `.git/info/exclude` for Local Dev Exclusions

The `.git/info/exclude` file acts like a `.gitignore` but is **local to the repository** and does not affect remote branches.

### Steps for Setting Up `.git/info/exclude` in `dev`

1. **Location**: `.git/info/exclude` within each repo’s `.git` directory.
2. **Purpose**: Exclude dev folders and specific files from being pushed to other branches.
3. **Configuration**:

   * In the `dev` branch, navigate to `.git/info/` and open the `exclude` file:

     ```powershell
     # Exclude dev-specific folders from main
     .vscode/
     dev_folder1/
     dev_folder2/
     ```

4. **Effect**: Files and folders listed in `.git/info/exclude` will not appear in commits or diffs outside `dev`.

> **Note**: `.git/info/exclude` rules only apply locally. If you switch to `main` or `wip`, these folders remain isolated to `dev`.

---

## 4. Combining with `.gitattributes` for `skip-worktree`

Adding the `skip-worktree` attribute in `.gitattributes` keeps these dev folders invisible in diffs and commits, providing a seamless experience across branches.

### Steps for Setting Up `.gitattributes` in `dev`

1. **Location**: `.gitattributes` file in the root of your `dev` repo.
2. **Purpose**: Use `skip-worktree` to make dev files local to `dev` and ignored in diffs or commits outside `dev`.
3. **Configuration**:

   * In `.gitattributes`, add:

     ```powershell
     .vscode/* skip-worktree
     dev_folder1/* skip-worktree
     dev_folder2/* skip-worktree
     ```

4. **Effect**: Changes to these dev folders won’t appear in diffs, merges, or when switching branches.

> **Note**: If you need to re-track these folders in another branch, remove the `skip-worktree` flag by running:

```powershell
git update-index --no-skip-worktree path/to/dev-only-file
```

---

## 5. Branch Workflow: Dev → Wip → Main

The following flow enables you to work within `dev` while keeping dev-specific files isolated from `main`.

### Step-by-Step Branch Workflow

1. **Develop in `dev`**:

   * `.vscode` and other dev-only folders remain local.
   * Changes to tracked files (excluding those in `.git/info/exclude` and `.gitattributes`) can be committed as needed.

2. **Testing in `wip`**:

   * Merge changes from `dev` into `wip`.
   * Files with `skip-worktree` or in `.git/info/exclude` remain local to `dev` and do not interfere.

3. **Push Production-Ready Changes in `main`**:

   * Only shared project files and core updates are pushed to `main`.
   * Dev-specific files (`.vscode`, `dev_folder1`, etc.) are automatically excluded from pushes.

---

## 6. Testing and Verifying Configuration

After setting up, confirm that each configuration works as intended.

### Commands to Test Exclusions

1. **Check Ignored Files**:

   ```powershell
   git check-ignore -v path/to/file
   ```

   This command will show if a file is ignored in `.git/info/exclude` or `.gitignore`.

2. **Verify `skip-worktree` Effect**:

   * Edit a file in `.vscode` in `dev`.
   * Run `git status` in `main`. Confirm that `.vscode` doesn’t appear in modified files.

3. **View Changes Between Branches**:

   * **Example**: `git diff dev wip`
   * **Expected Output**:

     * Only files not in `.git/info/exclude` or set to `skip-worktree` appear in diffs.

---

## 7. Common Commands and Expected Outputs

### Branch Comparison Commands

1. **Comparing dev and wip**:

   ```powershell
   git diff dev wip
   ```

   * **Expected Output**: Files ignored by `.git/info/exclude` or `skip-worktree` won’t appear in the diff.

2. **Testing Changes in Other Branches**:

   * **On `main`**:

     * Run `git diff dev`.
     * Files like `.vscode` should not appear if they’re only configured to stay in `dev`.

---

## 8. Troubleshooting and Tips

1. **Verify Ignore Rules**:

   * Run `git status` in each branch to confirm that excluded files are ignored as intended.

2. **List Skipped and Untracked Files**:

   * Confirm `skip-worktree` with:

     ```powershell
     git ls-files -v | Select-String "^S"  # Shows skipped files
     git ls-files -v | Select-String "^H"  # Shows assumed-unchanged files
     ```

3. **Revert `skip-worktree` or `assume-unchanged` for Files**:

   * Run:

     ```powershell
     git update-index --no-assume-unchanged path/to/file
     git update-index --no-skip-worktree path/to/file
     ```

This guide provides a comprehensive reference for setting up and maintaining branch-specific file tracking in Git, allowing dev-specific files to remain local without pushing to remote branches or cluttering diffs in `main`.

## Conclusion

By following this guide, you can effectively manage dev-specific files in your Git workflow. The combination of `.gitignore`, `.gitattributes`, and Git commands allows you to isolate changes in development branches while keeping your main branch clean and focused on production-ready code. Regularly verify your configurations and adjust as needed to maintain an efficient workflow.  

## Additional Resources

* [Git Documentation](https://git-scm.com/doc)
* [Pro Git Book](https://git-scm.com/book/en/v2)
* [Atlassian Git Tutorials](https://www.atlassian.com/git/tutorials)
* [Git Ignore Documentation](https://git-scm.com/docs/gitignore)
* [Git Attributes Documentation](https://git-scm.com/docs/gitattributes)

_May the force of Git be with you!_
