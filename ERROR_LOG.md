# [Troubleshooting & Error Log]

## 1. Git Push Rejected (Non-Fast-Forward)

### The Error

```text
! [rejected]        main -> main (fetch first)
error: failed to push some refs to '[https://github.com/Indra1806/nodejs-demo-app.git](https://github.com/Indra1806/nodejs-demo-app.git)'
hint: Updates were rejected because the remote contains work that you do not have locally.

```

### Cause

I initialized the repository on GitHub with a README/License, creating a commit history on the remote that did not exist on my local machine. When I tried to push my local `git init` code, Git blocked it to prevent overwriting the remote history.

### The Solution

I used the `--allow-unrelated-histories` flag to merge the two independent histories.

```bash
git pull origin main --allow-unrelated-histories
# Resolved merge conflicts (if any)
git push -u origin main

```

## 2. Bloated Repository (Node Modules)

### The Error

After running `git add .`, I noticed the upload was taking a long time and the repository size was massive. The `node_modules` folder was accidentally tracked.

### Cause

I ran `git add .` before creating a `.gitignore` file. This caused all dependency files (library binaries) to be staged for commit, which is a bad practice.

### The Solution

I removed the folder from the Git index (cached) while keeping it locally, and then added a `.gitignore`.

**Step 1: Create .gitignore**

```text
node_modules/
.env
.DS_Store

```

**Step 2: Clean Git Index**

```bash
git rm -r --cached node_modules
git add .gitignore
git commit -m "Fix: Stop tracking node_modules"

```

## 3. Docker Login Failed in CI/CD

### The Error

```text
Error: Username and password required
Error: Password required

```

*And later:*

```text
denied: requested access to the resource is denied

```

### Cause

1. **Syntax Error:** I initially missed defining the `password` input in the YAML `with:` block.
2. **Missing Secrets:** I had not added `DOCKER_USERNAME` and `DOCKER_PASSWORD` to the Repository Secrets.
3. **Permissions:** I initially used a "Read-Only" access token, which prevented the workflow from pushing the built image to Docker Hub.

### The Solution

1. **Secrets Configuration:** Added credentials in **Settings > Secrets and variables > Actions**.
2. **Token Update:** Generated a new Docker Hub Access Token with **Read & Write** permissions.
3. **YAML Correction:** Updated `.github/workflows/main.yml` to strictly pass the secrets:

```yaml
- name: Login to Docker Hub
  uses: docker/login-action@v3
  with:
    username: ${{ secrets.DOCKER_USERNAME }}
    password: ${{ secrets.DOCKER_PASSWORD }}

```

---

## 4. CI Pipeline Failure (Test Script)

### The Error

The workflow failed at the `Run Tests` step.

```text
npm ERR! Test failed.  See above for more details.
Exit code 1

```

### Cause

The default `package.json` created by `npm init` contains a placeholder test script that explicitly fails:
`"test": "echo \"Error: no test specified\" && exit 1"`

### The Solution

Modified `package.json` to return exit code 0 (success) for the purpose of this demo.

```json
"scripts": {
  "test": "echo \"No tests yet, passing for demo\" && exit 0"
}

```

## 5. Renaming Files in Git

### The Challenge

Needed to rename files without losing Git history or creating "deleted/untracked" file confusion.

### The Solution

Used the specific Git command to handle the move and staging in one step:

```bash
git mv old_filename new_filename

```
