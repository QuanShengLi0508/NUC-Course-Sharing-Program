import { statSync, writeFileSync } from "node:fs";
import { spawnSync } from "node:child_process";

const blockedPattern = /Crack|Tanner Tools|modelsim|tanner|mentor|破解器|破解|patched|keygen|MentorKG|绝密|软件|安装包|驱动|\.exe$|\.cab$|\.msi$|\.dll$|\.iso$|\.rar$|\.rar\.[0-9]+$|\.zip$|\.7z$|\.dmg$/i;
const hiddenPattern = /^(\.|scripts\/|docs\/|css\/|js\/|data\/|index\.html$|README\.md$)/i;

const repoRoot = new URL("../", import.meta.url);
const result = spawnSync("git", ["ls-files", "-z"], {
  cwd: repoRoot,
  encoding: "utf8",
});

if (result.status !== 0) {
  console.error(result.stderr || "Unable to read tracked files.");
  process.exit(result.status || 1);
}

const trackedFiles = result.stdout.split("\0").filter(Boolean);
const publicFiles = trackedFiles.filter((path) => {
  if (!path.includes("/")) return false;
  if (hiddenPattern.test(path)) return false;
  if (blockedPattern.test(path)) return false;
  return true;
});

const tree = publicFiles.map((path) => ({
  path,
  type: "blob",
  size: statSync(new URL(path, repoRoot)).size,
}));

const payload = {
  generatedAt: new Date().toISOString(),
  source: "git ls-files",
  totalTrackedFiles: trackedFiles.length,
  blockedCount: trackedFiles.length - publicFiles.length,
  tree,
};

writeFileSync(
  new URL("../data/resource-index.json", import.meta.url),
  `${JSON.stringify(payload, null, 2)}\n`,
);

console.log(`Generated data/resource-index.json with ${tree.length} public files.`);
