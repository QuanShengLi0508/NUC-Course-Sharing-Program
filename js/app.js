const repoApi = "https://api.github.com/repos/QuanShengLi0508/NUC-Course-Sharing-Program/git/trees/main?recursive=1";
      const localIndexUrl = "./data/resource-index.json";
      const repoBlobBase = "https://github.com/QuanShengLi0508/NUC-Course-Sharing-Program/blob/main/";
      const rawBase = "https://raw.githubusercontent.com/QuanShengLi0508/NUC-Course-Sharing-Program/main/";
      const blockedPattern = /Crack|Tanner Tools|modelsim|tanner|mentor|破解器|破解|patched|keygen|MentorKG|绝密|软件|安装包|驱动|\.exe$|\.cab$|\.msi$|\.dll$|\.iso$|\.rar$|\.rar\.[0-9]+$|\.zip$|\.7z$|\.dmg$/i;
      const hiddenPattern = /^(\.|scripts\/|docs\/|css\/|js\/|data\/|index\.html$|README\.md$)/i;

      const typeLabels = new Map([
        ["pdf", "PDF"],
        ["doc", "DOC"],
        ["docx", "DOC"],
        ["ppt", "PPT"],
        ["pptx", "PPT"],
        ["jpg", "IMG"],
        ["jpeg", "IMG"],
        ["png", "IMG"],
        ["gif", "IMG"],
        ["webp", "IMG"],
        ["mp4", "MP4"],
        ["asm", "CODE"],
        ["ms14", "DATA"],
        ["obj", "DATA"],
        ["mph", "DATA"],
        ["txt", "TXT"],
      ]);

      const state = {
        allResources: [],
        filteredResources: [],
        selectedCourse: "",
      };

      const shell = document.querySelector(".site-shell");
      const searchInput = document.querySelector("#searchInput");
      const courseFilter = document.querySelector("#courseFilter");
      const typeFilter = document.querySelector("#typeFilter");
      const courseSlider = document.querySelector("#courseSlider");
      const emptyState = document.querySelector("#emptyState");
      const terminalLog = document.querySelector("#terminalLog");

      function encodePath(path) {
        return path.split("/").map(encodeURIComponent).join("/");
      }

      function getExt(path) {
        const clean = path.split("?")[0];
        const file = clean.slice(clean.lastIndexOf("/") + 1);
        const dot = file.lastIndexOf(".");
        return dot === -1 ? "" : file.slice(dot + 1).toLowerCase();
      }

      function getType(path) {
        return typeLabels.get(getExt(path)) || "FILE";
      }

      function formatSize(size) {
        if (!Number.isFinite(size) || size <= 0) return "";
        if (size < 1024) return `${size} B`;
        if (size < 1024 * 1024) return `${(size / 1024).toFixed(1)} KB`;
        if (size < 1024 * 1024 * 1024) return `${(size / 1024 / 1024).toFixed(1)} MB`;
        return `${(size / 1024 / 1024 / 1024).toFixed(1)} GB`;
      }

      function normalizeTreeItem(item) {
        const path = item.path;
        const course = path.includes("/") ? path.split("/")[0] : "根目录";
        const name = path.slice(path.lastIndexOf("/") + 1);
        const encoded = encodePath(path);
        return {
          path,
          name,
          course,
          size: item.size || 0,
          type: getType(path),
          ext: getExt(path),
          html_url: `${repoBlobBase}${encoded}`,
          download_url: `${rawBase}${encoded}`,
        };
      }

      function isPublicCourseFile(item) {
        if (item.type !== "blob") return false;
        if (!item.path.includes("/")) return false;
        if (hiddenPattern.test(item.path)) return false;
        if (blockedPattern.test(item.path)) return false;
        return true;
      }

      function countBy(items, key) {
        const counts = new Map();
        for (const item of items) {
          const value = item[key];
          counts.set(value, (counts.get(value) || 0) + 1);
        }
        return [...counts.entries()].sort((a, b) => b[1] - a[1] || a[0].localeCompare(b[0], "zh-Hans-CN"));
      }

      function setTerminal(resources, blockedCount, sourceLabel) {
        const courses = new Set(resources.map((item) => item.course)).size;
        const types = new Set(resources.map((item) => item.type)).size;
        terminalLog.innerHTML = `
          <p><span class="prompt">$</span> curl repo-tree --recursive</p>
          <p><span class="terminal-good">${resources.length}</span> public files indexed · <span class="terminal-good">${courses}</span> courses · <span class="terminal-good">${types}</span> types</p>
          <p><span class="prompt">$</span> apply safe-index-filter</p>
          <p class="terminal-muted">${blockedCount} package / installer / crack-like paths hidden from this page</p>
          <p><span class="terminal-good">ready</span> · ${escapeHtml(sourceLabel)} · static · download_url linked</p>
        `;
      }

      function renderMetrics(resources) {
        document.querySelector("#fileMetric").textContent = resources.length;
        document.querySelector("#courseMetric").textContent = new Set(resources.map((item) => item.course)).size;
        document.querySelector("#typeMetric").textContent = new Set(resources.map((item) => item.type)).size;
        document.querySelector("#shownMetric").textContent = state.filteredResources.length;
      }

      function renderCourseControls(resources) {
        const courses = countBy(resources, "course");
        const selectedCourse = courseFilter.value;

        courseFilter.innerHTML = `<option value="">全部课程</option>` + courses
          .map(([course, count]) => `<option value="${escapeHtml(course)}">${escapeHtml(course)} (${count})</option>`)
          .join("");
        courseFilter.value = selectedCourse;
      }

      function renderTypeControl(resources) {
        const types = countBy(resources, "type");
        const selectedType = typeFilter.value;

        typeFilter.innerHTML = `<option value="">全部类型</option>` + types
          .map(([type, count]) => `<option value="${escapeHtml(type)}">${escapeHtml(type)} (${count})</option>`)
          .join("");
        typeFilter.value = selectedType;
      }

      function groupResourcesByCourse(resources) {
        const groups = new Map();
        for (const item of resources) {
          if (!groups.has(item.course)) {
            groups.set(item.course, []);
          }
          groups.get(item.course).push(item);
        }
        return [...groups.entries()]
          .map(([course, files]) => ({
            course,
            files: files.sort((a, b) => a.name.localeCompare(b.name, "zh-Hans-CN")),
          }))
          .sort((a, b) => b.files.length - a.files.length || a.course.localeCompare(b.course, "zh-Hans-CN"));
      }

      function renderCourseIndex(resources) {
        const groups = groupResourcesByCourse(resources);
        document.querySelector("#resourceCount").textContent = `${resources.length} files`;
        document.querySelector("#courseListCount").textContent = `${groups.length} courses`;
        emptyState.style.display = resources.length === 0 ? "block" : "none";

        courseSlider.innerHTML = groups.map((group, index) => {
          const typeCounts = countBy(group.files, "type").slice(0, 4);
          return `
            <article class="course-column" aria-label="${escapeHtml(group.course)}">
              <header class="course-column-header">
                <div class="course-column-kicker">
                  <span>[ ${String(index + 1).padStart(2, "0")} ]</span>
                  <span>${group.files.length} files</span>
                </div>
                <h3 class="course-column-title">${escapeHtml(group.course)}</h3>
                <div class="course-type-strip">
                  ${typeCounts.map(([type, count]) => `<span class="course-type-chip">${escapeHtml(type)} · ${count}</span>`).join("")}
                </div>
              </header>
              <div class="course-file-list">
                ${group.files.map((item) => `
                  <div class="course-file-row">
                    <span class="file-kind">${escapeHtml(item.type)}</span>
                    <div class="file-main">
                      <div class="file-name">${escapeHtml(item.name)}</div>
                      <div class="file-meta">${escapeHtml(formatSize(item.size) || item.ext || "file")}</div>
                    </div>
                    <div class="file-links">
                      <a class="action-link" href="${item.html_url}">查看</a>
                      <a class="action-link" href="${item.download_url}">下载</a>
                    </div>
                  </div>
                `).join("")}
              </div>
            </article>
          `;
        }).join("");

        if (resources.length > 0) {
          courseSlider.scrollTo({ left: 0, behavior: "smooth" });
        }
      }

      function renderResources(resources) {
        renderCourseIndex(resources);
      }

      function applyFilters() {
        const query = searchInput.value.trim().toLowerCase();
        const course = courseFilter.value;
        const type = typeFilter.value;
        state.selectedCourse = course;
        state.filteredResources = state.allResources.filter((item) => {
          const haystack = `${item.course} ${item.name} ${item.path} ${item.type}`.toLowerCase();
          return (!query || haystack.includes(query)) && (!course || item.course === course) && (!type || item.type === type);
        });
        renderMetrics(state.allResources);
        renderCourseControls(state.allResources);
        renderResources(state.filteredResources);
      }

      function escapeHtml(value) {
        return String(value)
          .replaceAll("&", "&amp;")
          .replaceAll("<", "&lt;")
          .replaceAll(">", "&gt;")
          .replaceAll('"', "&quot;")
          .replaceAll("'", "&#39;");
      }

      async function fetchJson(url, options) {
        const response = await fetch(url, options);
        if (!response.ok) {
          throw new Error(`${url} ${response.status}`);
        }
        return response.json();
      }

      async function loadTreePayload() {
        try {
          return {
            payload: await fetchJson(repoApi, { headers: { Accept: "application/vnd.github+json" } }),
            sourceLabel: "GitHub API",
          };
        } catch (apiError) {
          console.warn("GitHub API unavailable, falling back to local index.", apiError);
          return {
            payload: await fetchJson(localIndexUrl),
            sourceLabel: "local resource-index.json",
          };
        }
      }

      async function boot() {
        const { payload, sourceLabel } = await loadTreePayload();
        const allBlobs = payload.tree.filter((item) => item.type === "blob" && item.path.includes("/"));
        const resources = payload.tree
          .filter(isPublicCourseFile)
          .map(normalizeTreeItem)
          .sort((a, b) => a.course.localeCompare(b.course, "zh-Hans-CN") || a.name.localeCompare(b.name, "zh-Hans-CN"));
        const blockedCount = Number.isFinite(payload.blockedCount) ? payload.blockedCount : allBlobs.length - resources.length;

        state.allResources = resources;
        state.filteredResources = resources;
        setTerminal(resources, blockedCount, sourceLabel);
        renderCourseControls(resources);
        renderTypeControl(resources);
        renderMetrics(resources);
        renderResources(resources);
        shell.classList.remove("loading");
      }

      searchInput.addEventListener("input", applyFilters);
      courseFilter.addEventListener("change", applyFilters);
      typeFilter.addEventListener("change", applyFilters);

      boot().catch((error) => {
        console.error(error);
        terminalLog.innerHTML = `
          <p><span class="prompt">$</span> curl repo-tree --recursive</p>
          <p class="terminal-muted">GitHub API temporarily unavailable.</p>
          <p class="terminal-muted">Open the repository link above.</p>
        `;
        shell.classList.remove("loading");
      });
    
