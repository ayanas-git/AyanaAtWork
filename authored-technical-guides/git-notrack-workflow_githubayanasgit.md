# Git Workflow with `--no-track` and Worktrees

## Overview

This workflow is designed for managing independent branches and worktrees using Git's `--no-track` option. It focuses on keeping branches isolated and minimizing unintended merges or syncs. The instructions support **PowerShell** (primary) and **Bash** (secondary).

---

## Setup

### Create a New Branch with `--no-track`

1. **PowerShell**:

   ```powershell
   git checkout --no-track -b <branch-name>
   ```

2. **Bash**:

   ```bash
   git checkout --no-track -b <branch-name>
   ```

This creates a new branch without setting an upstream link.

---

## Using Worktrees

### Add a Worktree for the New Branch

1. **PowerShell**:

   ```powershell
   git worktree add ../<worktree-folder> <branch-name>
   ```

2. **Bash**:

   ```bash
   git worktree add ../<worktree-folder> <branch-name>
   ```

This creates a new physical directory for your branch.

---

## Managing Project-Specific Files

### Configure `.gitignore` for Project-Only Branch

To exclude files outside your project folder from tracking:

1. Add rules to `.gitignore`:

   ```powershell
   # Ignore all files except those in the project folder
   *
   !project-folder/
   ```

2. Commit the `.gitignore` changes:
   - **PowerShell/Bash**:

     ```bash
     git add .gitignore
     git commit -m "Exclude non-project files from tracking"
     ```

---

### Use Sparse-Checkout for Large Repositories

If your repository is too large to copy everything or you only want to include certain directories in your worktree, sparse-checkout is an alternative to `.gitignore`:

1. Enable sparse-checkout:

   ```bash
   git sparse-checkout init
   ```

2. Set the directories to include:

   ```bash
   git sparse-checkout set project-folder/
   ```

3. Verify the sparse-checkout:

   ```bash
   git sparse-checkout list
   ```

This ensures only files within the specified directory appear in the worktree.

---

## Working on the Branch

### Save Progress with `git stash`

1. Save your work:

   ```powershell
   git stash push -m "Save work on <branch-name>"
   ```

2. Restore stashed changes:

   ```powershell
   git stash pop
   ```

### Manual Pull and Push

Since the branch isn’t tracked, specify the branch explicitly when syncing:

1. Pull changes:

   ```powershell
   git pull origin <branch-name>
   ```

2. Push changes:

   ```powershell
   git push origin <branch-name>
   ```

---

## Merging Changes Back to `main`

### Prepare for Merge

Use the `--no-commit` flag to preview the merge:

1. **PowerShell/Bash**:

   ```bash
   git merge <branch-name> --no-commit --no-ff
   ```

### Restore Missing Files

If files are marked as "deleted," restore them:

1. **PowerShell/Bash**:

   ```bash
   git restore --source=<source-branch> -- .
   ```

### Finalize the Merge

1. Commit the merge:

   ```powershell
   git commit -m "Merge <branch-name> into main"
   ```

---

## When to Use Which?

| Scenario                     | Use `--no-track`                 | Use Default Tracking             |
|------------------------------|----------------------------------|----------------------------------|
| **One-off/isolated work**    | Yes (to keep branches separate) | No (if syncing is still needed) |
| **Experimentation**          | Yes (independent from `main`)   | No                              |
| **Collaborative project**    | No (to enable easier syncs)     | Yes                             |
| **Complex workflows**        | Yes (manual control)            | No (if simplicity is desired)   |
| **Frequent syncing**         | No (to avoid extra commands)    | Yes                             |

---

## Pros and Cons of `.gitignore`, Sparse-Checkout, or Both

### `.gitignore`

**Pros**:

- Simple to configure.
- Great for excluding temporary or local files from tracking.

**Cons**:

- Doesn’t remove files already committed to the repository.
- Not ideal for selectively including files for large worktrees.

### Sparse-Checkout

**Pros**:

- Keeps the repository light by limiting files in the worktree.
- Useful for massive repositories or specific project folders.

**Cons**:

- Requires additional setup (`git sparse-checkout init`).
- Less intuitive than `.gitignore` for basic exclusions.

### Using Both

**Pros**:

- Combines selective file inclusion (sparse-checkout) with exclusion of local/temporary files (`.gitignore`).
- Provides maximum control over what files are visible in the worktree.

**Cons**:

- Potential conflicts if `.gitignore` excludes files sparse-checkout needs.
- More complexity in managing rules.

---

## Why Worktrees Are the Best Option for Isolation

### Scenario

You asked why you can’t directly use `$ git checkout --no-track --path` to isolate files in a branch. While this isn’t supported by Git, worktrees provide the best solution for your needs, combining simplicity and isolation.

### Ranking Options

1. **Default Branching**:
   - **Simplicity**: High
   - **Isolation**: Low
   - **Best for**: Small repositories or minimal setup needs.
2. **Sparse-Checkout**:
   - **Simplicity**: Medium
   - **Isolation**: Medium
   - **Best for**: Keeping repositories light while working with subsets of files.
3. **Worktrees**:
   - **Simplicity**: Medium-Low
   - **Isolation**: High
   - **Best for**: Large repositories, independent workflows, and managing separate physical directories.

### Why Worktrees Work Best for Your Case

- Worktrees provide a **physical separation** of files and branches, which eliminates risks of accidental changes in shared directories.
- They allow you to simultaneously work on multiple branches without conflicts.
- Combined with `--no-track`, they ensure full control and independence over branch operations.

---

## Tips for Bash Users

- If working between PowerShell and Bash, remember to:
  - Update file paths (`\` for PowerShell, `/` for Bash).
  - Test worktree commands in both environments.

---

## Troubleshooting

- **Deleted Files After Merge**:
  - Ensure all files are tracked before merging back.
  - Use `git restore` to recover files before committing.
- **Conflicts During Merge**:
  - Resolve conflicts manually and add changes:

    ```bash
    git add .
    git commit
    ```

---

## Resources

- [Git Worktree Documentation](https://git-scm.com/docs/git-worktree)
- [Git Ignore Patterns](https://git-scm.com/docs/gitignore)
- [Git Sparse-Checkout Documentation](https://git-scm.com/docs/git-sparse-checkout)

---

### Notes

This document is tailored to your Git workflow needs, combining `--no-track` with worktrees and handling project-specific file isolation. Ensure to adapt it to your unique directory structures and branch naming conventions.
