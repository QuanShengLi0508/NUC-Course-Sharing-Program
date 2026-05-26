import { readFileSync } from "node:fs";

const html = readFileSync(new URL("../index.html", import.meta.url), "utf8");
const css = readFileSync(new URL("../css/styles.css", import.meta.url), "utf8");
const js = readFileSync(new URL("../js/app.js", import.meta.url), "utf8");
const indexJson = readFileSync(new URL("../data/resource-index.json", import.meta.url), "utf8");
const resourceIndex = JSON.parse(indexJson);

const checks = [
  ["html", html, "NUC Course Hub"],
  ["html", html, "中北大学课程资料"],
  ["html", html, 'id="searchInput"'],
  ["html", html, 'id="courseFilter"'],
  ["html", html, 'id="typeFilter"'],
  ["html", html, 'id="courseSlider"'],
  ["html", html, 'script type="module" src="./js/app.js?v=20260526"'],
  ["css", css, "--bg: #05070a"],
  ["css", css, "--terminal-green"],
  ["css", css, ".terminal-card"],
  ["css", css, ".course-slider"],
  ["css", css, "scroll-snap-type: x mandatory"],
  ["css", css, "@media (max-width: 760px)"],
  ["js", js, "https://api.github.com/repos/QuanShengLi0508/NUC-Course-Sharing-Program/git/trees/main?recursive=1"],
  ["js", js, "blockedPattern"],
  ["js", js, "Tanner Tools"],
  ["js", js, "modelsim"],
  ["js", js, "download_url"],
  ["js", js, "groupResourcesByCourse"],
  ["js", js, "renderCourseIndex"],
  ["js", js, "course-column"],
  ["js", js, "course-file-row"],
  ["js", js, "escapeHtml"],
  ["js", js, "localIndexUrl"],
  ["js", js, "loadTreePayload"],
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

try {
  new Function(js);
} catch (error) {
  console.error("Homepage verification failed. js/app.js does not parse:");
  console.error(error.message);
  process.exit(1);
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

const exposesBlockedInstaller = resourceIndex.tree.some((item) => /Crack|Tanner Tools|modelsim|tanner|破解器|破解|\.exe$|\.zip$/i.test(item.path));
if (exposesBlockedInstaller) {
  console.error("Homepage verification failed. data/resource-index.json includes blocked installer or crack-like paths.");
  process.exit(1);
}

console.log("Homepage verification passed.");
