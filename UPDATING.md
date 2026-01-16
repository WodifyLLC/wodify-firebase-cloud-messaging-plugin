# Updating from upstream (official releases only)

This repo keeps **our custom changes** on `main` and keeps **upstream vendor snapshots** on `official`.

- `official`: one commit per upstream release tag (no upstream history on our branch)
- `main`: our changes + merges from `official`

## One-time setup (Windows)

If you hit path-length errors while committing iOS `.xcframework` files, enable Git long paths:

```powershell
git config core.longpaths true
```

(You can also set it globally: `git config --global core.longpaths true`.)

## Import a new upstream release

1) Fetch tags from upstream

```powershell
git fetch upstream --tags --prune
```

2) Pick the release tag

```powershell
git tag -l --sort=v:refname
```

3) Update `official` by importing the tag as a single snapshot commit

```powershell
$newTag = "x.y.z"  # <-- change this
$zip = Join-Path $env:TEMP "upstream-$newTag.zip"

if (Test-Path $zip) { Remove-Item -Force $zip }

git checkout official

git rm -rf . 2>$null

git archive --format=zip -o $zip upstream/$newTag
Expand-Archive -Force $zip .

git add -A
git commit -m "Vendor: OutSystems cordova-outsystems-firebase-cloud-messaging $newTag"
```

4) Merge the vendor update into `main`

```powershell
git checkout main
git merge official
```

Resolve conflicts if needed, then commit the merge.

## Notes

- Only import **official release tags** (e.g. `2.5.1`, `2.5.2`, ...).
- Do not commit custom changes directly to `official`.
