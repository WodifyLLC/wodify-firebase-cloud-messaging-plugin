# Repository Workflow

This repository is a fork of [OutSystems cordova-outsystems-firebase-cloud-messaging](https://github.com/OutSystems/cordova-outsystems-firebase-cloud-messaging.git) with custom badge management modifications.

## Branch Strategy

- **`official`**: Tracks the OutSystems upstream source (`upstream/main`). This branch is kept in sync with the original repository.
- **`main`**: Your main publishing branch. Receives merges from `dev` (for your changes) and `official` (for upstream updates).
- **`dev`**: Your development branch for making badge management changes.

## Daily Development Workflow

### Making Changes

1. Switch to the `dev` branch:
   ```bash
   git checkout dev
   ```

2. Make your badge management changes

3. Commit your changes:
   ```bash
   git add .
   git commit -m "Description of your changes"
   ```

4. When ready to publish, merge `dev` into `main`:
   ```bash
   git checkout main
   git merge dev
   ```

## Updating from OutSystems (When They Release)

When OutSystems releases a new version, follow these steps to merge their updates:

1. **Fetch the latest from upstream:**
   ```bash
   git fetch upstream
   ```

2. **Update the `official` branch:**
   ```bash
   git checkout official
   git merge upstream/main
   ```
   This will pull the latest changes from OutSystems into your `official` branch.

3. **Merge `official` into `main`:**
   ```bash
   git checkout main
   git merge official
   ```
   **Note:** This merge will likely have conflicts, especially around badge management areas. You'll need to resolve these conflicts manually, keeping your badge management changes while incorporating OutSystems' updates.

4. **Resolve conflicts:**
   - Git will mark conflicted files
   - Edit the files to resolve conflicts, preserving your badge management logic
   - After resolving all conflicts:
     ```bash
     git add .
     git commit -m "Merge upstream updates from OutSystems"
     ```

5. **Update `dev` branch with the merged changes:**
   ```bash
   git checkout dev
   git merge main
   ```
   This keeps your `dev` branch in sync with `main` so future development includes the upstream updates.

## Remote Configuration

The repository is configured with:
- **`upstream`**: Points to `https://github.com/OutSystems/cordova-outsystems-firebase-cloud-messaging.git`
- The `official` branch tracks `upstream/main`

## Notes

- Badge management changes are isolated to specific files (primarily iOS AppDelegate), making conflict resolution more manageable
- The merge from `official` to `main` will require manual conflict resolution, but this is expected and manageable given the limited scope of custom changes
- Always keep `dev` synced with `main` after merging upstream updates to avoid divergence
- Consider testing thoroughly after merging upstream updates to ensure badge management still works correctly
