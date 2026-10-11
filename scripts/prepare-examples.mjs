import { spawnSync } from 'node:child_process';
const result = spawnSync('python3', ['scripts/package_examples.py'], { stdio: 'inherit' });
if (result.status !== 0) process.exit(result.status || 1);
