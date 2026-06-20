import { statSync, writeFileSync } from "node:fs";
import { spawnSync } from "node:child_process";

const blockedPattern = /Crack|Tanner Tools|tanner|mentor|破解器|破解|patched?|keygen|MentorKG|绝密|安装包|驱动|\.exe$|\.cab$|\.msi$|\.dll$|\.iso$|\.rar$|\.rar\.[0-9]+$|\.zip$|\.7z$|\.dmg$/i;
const hiddenPattern = /^(\.|scripts\/|docs\/|css\/|js\/|data\/|assets\/|index\.html$|README\.md$)/i;
const packageLikePattern = /(^|\/)([^/]+\.(app|bundle|framework|xcodeproj|xcworkspace|playground)|node_modules|dist|build|modelsim[^/]*|软件|小模块源码|源码|源代码|实验源文件|工程|项目|大作业贡献者|CMOSOL)(\/|$)/i;

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
function getPackageRoot(path) {
  const parts = path.split("/");
  const matchIndex = parts.findIndex((part) => packageLikePattern.test(part));
  if (matchIndex >= 0) return parts.slice(0, matchIndex + 1).join("/");

  if (parts.length >= 3) {
    const firstTwo = parts.slice(0, 2).join("/");
    if (packageLikePattern.test(firstTwo)) return firstTwo;
  }

  return "";
}

const publicFiles = trackedFiles.filter((path) => {
  if (!path.includes("/")) return false;
  if (hiddenPattern.test(path)) return false;
  if (blockedPattern.test(path)) return false;
  return true;
});

const unsafeCourses = new Set();
const unsafePackageRoots = new Set();
for (const path of trackedFiles) {
  if (!path.includes("/") || hiddenPattern.test(path) || !blockedPattern.test(path)) continue;
  unsafeCourses.add(path.split("/")[0]);
  const packageRoot = getPackageRoot(path);
  if (packageRoot) unsafePackageRoots.add(packageRoot);
}

const packageEntries = new Map();
const tree = [];

for (const path of publicFiles) {
  const packageRoot = getPackageRoot(path);
  if (packageRoot && !blockedPattern.test(packageRoot)) {
    const entry = packageEntries.get(packageRoot) || {
      path: packageRoot,
      type: "package",
      size: 0,
      fileCount: 0,
      unsafe: unsafePackageRoots.has(packageRoot),
    };
    entry.size += statSync(new URL(path, repoRoot)).size;
    entry.fileCount += 1;
    packageEntries.set(packageRoot, entry);
    continue;
  }

  tree.push({
    path,
    type: "blob",
    size: statSync(new URL(path, repoRoot)).size,
  });
}

tree.push(...packageEntries.values());
tree.sort((a, b) => a.path.localeCompare(b.path, "zh-Hans-CN"));

const payload = {
  generatedAt: new Date().toISOString(),
  source: "git ls-files",
  totalTrackedFiles: trackedFiles.length,
  blockedCount: trackedFiles.length - publicFiles.length,
  unsafeCourses: [...unsafeCourses].sort((a, b) => a.localeCompare(b, "zh-Hans-CN")),
  unsafePackageRoots: [...unsafePackageRoots].sort((a, b) => a.localeCompare(b, "zh-Hans-CN")),
  tree,
};

writeFileSync(
  new URL("../data/resource-index.json", import.meta.url),
  `${JSON.stringify(payload, null, 2)}\n`,
);

console.log(`Generated data/resource-index.json with ${tree.length} public entries.`);
