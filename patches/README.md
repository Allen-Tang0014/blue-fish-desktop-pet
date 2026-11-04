# patches/

Upstream `dsh-pet` has no way to close the pet window in standalone mode: the helper
process is restarted by its host whenever it exits, and its right-click menu has no
quit item. These three files are byte-for-byte copies of the installed package with
small, well-scoped edits. `setup.ps1` / `npm run patch` copy them into
`node_modules/dsh-pet/runtime/electron-helper/`.

| File | Change |
| --- | --- |
| `sprite.js` | Right-click menu gets one extra item **退出桌宠** (`action: 'quit'`). `quitPet()` sends `POST /shutdown` to the standalone host (host is `site`), which disposes the helper and exits the server; when the host is the DSH desktop app it calls `window.close()` instead. |
| `main.js` | `app.on('window-all-closed')` no longer calls `app.quit()`. Without this, closing the pet window kills the helper, the host notices and respawns it (the classic "cannot close the pet" behaviour). |
| `preload.js` | Identical to upstream (kept so all three patched files sit in one place; no functional change). |

## After upgrading upstream

```sh
npm install dsh-pet@latest
npm run patch        # copies these files over the new version
```

If the new upstream version changed `sprite.js` / `main.js` structure, the copies above
would overwrite upstream fixes. In that case diff them first:

```sh
git diff --no-index node_modules/dsh-pet/runtime/electron-helper/sprite.js patches/sprite.js
```
