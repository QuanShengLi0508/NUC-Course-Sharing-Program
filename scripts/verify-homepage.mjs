import { readFileSync } from "node:fs";
import { spawnSync } from "node:child_process";
import { fileURLToPath } from "node:url";

const html = readFileSync(new URL("../index.html", import.meta.url), "utf8");
const css = readFileSync(new URL("../css/styles.css", import.meta.url), "utf8");
const js = readFileSync(new URL("../js/app.js", import.meta.url), "utf8");
const supabaseJs = readFileSync(new URL("../js/supabase.js", import.meta.url), "utf8");
const swJs = readFileSync(new URL("../sw.js", import.meta.url), "utf8");
const indexJson = readFileSync(new URL("../data/resource-index.json", import.meta.url), "utf8");
const resourceIndex = JSON.parse(indexJson);

const checks = [
  ["html", html, "NUC Course Hub"],
  ["html", html, "NUC-Course-<br>Sharing-Program"],
  ["html", html, "./assets/nuc-emblem.jpg"],
  ["html", html, 'id="themeToggle"'],
  ["html", html, 'id="searchInput"'],
  ["html", html, 'id="courseFilter"'],
  ["html", html, 'id="typeFilter"'],
  ["html", html, 'id="sortOrder"'],
  ["html", html, 'id="courseSlider"'],
  ["html", html, 'id="ratings"'],
  ["html", html, 'id="ratingForm"'],
  ["html", html, 'id="contribute"'],
  ["html", html, 'id="contributionForm"'],
  ["html", html, 'id="commentForm"'],
  ["html", html, 'id="notificationButton"'],
  ["html", html, 'id="notificationPanel"'],
  ["html", html, "匿名"],
  ["html", html, 'href="./css/styles.css?v=20260527-full-upgrade"'],
  ["html", html, 'script type="module" src="./js/app.js?v=20260527-full-upgrade"'],
  ["html", html, 'navigator.serviceWorker.register("./sw.js")'],
  ["html", html, "README · Project Intro"],
  ["css", css, "--paper: #eee9dc"],
  ["css", css, "--paper-strong: #f8f3e8"],
  ["css", css, "--yellow: #f0b90b"],
  ["css", css, "--shadow: 4px 4px 0 var(--line)"],
  ["css", css, "margin: -12px 0 0"],
  ["css", css, "align-items: start"],
  ["css", css, "color: var(--muted)"],
  ["css", css, ".brand-mark img"],
  ["css", css, "object-position: center"],
  ["css", css, ".hero-title"],
  ["css", css, "transition: transform .14s ease"],
  ["css", css, "transform: translate(-1px, -1px)"],
  ["css", css, ".directory-row"],
  ["css", css, "overflow-wrap: anywhere"],
  ["css", css, ".course-action-link"],
  ["css", css, ".contribute-stage"],
  ["css", css, ".comment-stage"],
  ["css", css, ".rating-stage"],
  ["css", css, ".theme-toggle"],
  ["css", css, ".mobile-search-fab"],
  ["css", css, ".terminal-card"],
  ["css", css, "overflow-y: auto"],
  ["css", css, ".readme-kicker"],
  ["css", css, ".readme-stats"],
  ["css", css, ".metric-grid"],
  ["css", css, ".directory-shell"],
  ["css", css, ".course-slider"],
  ["css", css, "scroll-snap-type: x mandatory"],
  ["css", css, "@media (max-width: 760px)"],
  ["js", js, "https://api.github.com/repos/QuanShengLi0508/NUC-Course-Sharing-Program/git/trees/main?recursive=1"],
  ["js", js, "blockedPattern"],
  ["js", js, "Tanner Tools"],
  ["js", js, "modelsim"],
  ["js", js, "githubRawBase"],
  ["js", js, "downloadDirectoryBase"],
  ["js", js, "packageLikePattern"],
  ["js", js, "collapsePackageEntries"],
  ["js", js, "全部下载"],
  ["js", js, "openIssueUrl"],
  ["js", js, "notificationKey"],
  ["js", js, "themeToggle"],
  ["js", js, "ratingForm"],
  ["js", js, "supabaseInsert"],
  ["js", js, "isConfigured"],
  ["js", js, "contributionForm"],
  ["js", js, "commentForm"],
  ["js", js, "download_url"],
  ["js", js, "groupResourcesByCourse"],
  ["js", js, "buildCourseTree"],
  ["js", js, "renderTreeRows"],
  ["js", js, "directory-row"],
  ["js", js, "parentPath"],
  ["js", js, "README.md"],
  ["js", js, "为什么要做这件事"],
  ["js", js, "renderCourseIndex"],
  ["js", js, "course-column"],
  ["js", js, "course-file-row"],
  ["js", js, "escapeHtml"],
  ["js", js, "localIndexUrl"],
  ["js", js, "loadTreePayload"],
  ["supabase", supabaseJs, "SUPABASE_URL"],
  ["supabase", supabaseJs, "isConfigured"],
  ["service-worker", swJs, "nuc-course-hub-v8"],
  ["service-worker", swJs, "./js/supabase.js"],
  ["json", indexJson, '"tree"'],
  ["json", indexJson, '"generatedAt"'],
];

const missing = checks.filter(([, content, snippet]) => !content.includes(snippet));

if (missing.length > 0) {
  console.error("Homepage verification failed. Missing snippets:");
  for (const [file, , snippet] of missing) {
    console.error(`- ${file}: ${snippet}`);
  }
  process.exit(1);
}

for (const file of ["../js/app.js", "../js/supabase.js", "../sw.js"]) {
  const result = spawnSync(process.execPath, ["--check", fileURLToPath(new URL(file, import.meta.url))], {
    encoding: "utf8",
  });
  if (result.status !== 0) {
    console.error(`Homepage verification failed. ${file} does not parse:`);
    console.error(result.stderr || result.stdout);
    process.exit(result.status || 1);
  }
}

if (!Array.isArray(resourceIndex.tree) || resourceIndex.tree.length === 0) {
  console.error("Homepage verification failed. data/resource-index.json has no tree entries.");
  process.exit(1);
}

const hasCoursePdf = resourceIndex.tree.some((item) => item.type === "blob" && /\.pdf$/i.test(item.path) && item.path.includes("/"));
if (!hasCoursePdf) {
  console.error("Homepage verification failed. data/resource-index.json has no course PDF entry.");
  process.exit(1);
}

if (/raw\.githubusercontent\.com/.test(js)) {
  console.error("Homepage verification failed. js/app.js still links downloads through raw.githubusercontent.com.");
  process.exit(1);
}

if (!/assets\\\//.test(js) || !/assets\\\//.test(readFileSync(new URL("./generate-resource-index.mjs", import.meta.url), "utf8"))) {
  console.error("Homepage verification failed. assets/ must be hidden from the public course index.");
  process.exit(1);
}

const hasPackageEntry = resourceIndex.tree.some((item) => item.type === "package" && item.path.includes("/"));
if (!hasPackageEntry) {
  console.error("Homepage verification failed. data/resource-index.json has no collapsed package entries.");
  process.exit(1);
}

const exposesBlockedInstaller = resourceIndex.tree.some((item) => /Crack|Tanner Tools|tanner|破解器|破解|patched?|keygen|MentorKG|安装包|驱动|\.exe$|\.cab$|\.msi$|\.dll$|\.iso$|\.rar$|\.rar\.[0-9]+$|\.zip$|\.7z$|\.dmg$/i.test(item.path));
if (exposesBlockedInstaller) {
  console.error("Homepage verification failed. data/resource-index.json includes blocked installer or crack-like paths.");
  process.exit(1);
}

console.log("Homepage verification passed.");
