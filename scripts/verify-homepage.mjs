import { readFileSync } from "node:fs";

const html = readFileSync(new URL("../index.html", import.meta.url), "utf8");
const inlineScript = html.match(/<script>([\s\S]*)<\/script>/)?.[1] ?? "";

const requiredSnippets = [
  "NUC Course Hub",
  "GitHub Pages",
  "https://api.github.com/repos/QuanShengLi0508/NUC-Course-Sharing-Program/git/trees/main?recursive=1",
  "id=\"searchInput\"",
  "id=\"courseFilter\"",
  "id=\"typeFilter\"",
  "id=\"courseSlider\"",
  "course-column",
  "course-file-row",
  "renderCourseIndex",
  "groupResourcesByCourse",
  "scroll-snap-type: x mandatory",
  "blockedPattern",
  "Crack",
  "Tanner Tools",
  "modelsim",
  "tanner",
  "download_url",
];

const missing = requiredSnippets.filter((snippet) => !html.includes(snippet));

if (missing.length > 0) {
  console.error("Homepage verification failed. Missing snippets:");
  for (const snippet of missing) {
    console.error(`- ${snippet}`);
  }
  process.exit(1);
}

try {
  new Function(inlineScript);
} catch (error) {
  console.error("Homepage verification failed. Inline script does not parse:");
  console.error(error.message);
  process.exit(1);
}

console.log("Homepage verification passed.");
