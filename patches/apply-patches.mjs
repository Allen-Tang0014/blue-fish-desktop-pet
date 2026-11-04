// Re-apply the local patches to a freshly installed dsh-pet package.
// Usage: npm run patch   (or: node patches/apply-patches.mjs)
import fs from 'node:fs';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
const root = path.resolve(here, '..');
const helper = path.join(root, 'node_modules', 'dsh-pet', 'runtime', 'electron-helper');

if (!fs.existsSync(helper)) {
  console.error('[x] node_modules/dsh-pet is missing. Run "npm install" first.');
  process.exit(1);
}

const files = fs.readdirSync(here).filter((n) => n.endsWith('.js'));
if (!files.length) {
  console.error('[x] no patch files (*.js) found next to this script.');
  process.exit(1);
}

for (const f of files) {
  fs.copyFileSync(path.join(here, f), path.join(helper, f));
  console.log('[i] patched runtime/electron-helper/' + f);
}
console.log('[i] done. Restart the pet (or right-click -> 重载配置) to load the patched helper.');
