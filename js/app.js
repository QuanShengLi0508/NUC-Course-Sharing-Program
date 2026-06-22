import { supabaseInsert, supabaseSelect, isConfigured } from "./supabase.js";

      const repoApi = "https://api.github.com/repos/QuanShengLi0508/NUC-Course-Sharing-Program/git/trees/main?recursive=1";
      const localIndexUrl = "./data/resource-index.json";
      const repoBlobBase = "https://github.com/QuanShengLi0508/NUC-Course-Sharing-Program/blob/main/";
      const repoTreeBase = "https://github.com/QuanShengLi0508/NUC-Course-Sharing-Program/tree/main/";
      const githubRawBase = "https://github.com/QuanShengLi0508/NUC-Course-Sharing-Program/raw/main/";
      const downloadDirectoryBase = "https://download-directory.github.io/?url=";
      const openIssueUrl = "https://github.com/QuanShengLi0508/NUC-Course-Sharing-Program/issues/new";
      const blockedPattern = /Crack|Tanner Tools|tanner|mentor|破解器|破解|patched?|keygen|MentorKG|绝密|安装包|驱动|\.exe$|\.cab$|\.msi$|\.dll$|\.iso$|\.rar$|\.rar\.[0-9]+$|\.zip$|\.7z$|\.dmg$/i;
      const hiddenPattern = /^(\.|scripts\/|docs\/|css\/|js\/|data\/|assets\/|index\.html$|README\.md$)/i;
      const packageLikePattern = /(^|\/)([^/]+\.(app|bundle|framework|xcodeproj|xcworkspace|playground)|node_modules|dist|build|modelsim[^/]*|软件|小模块源码|源码|源代码|实验源文件|工程|项目|大作业贡献者|CMOSOL)(\/|$)/i;
      const notificationKey = "nuc-course-notifications";

      const courseCategories = new Map([
        ["高等数学上", "基础课"],
        ["线性代数", "基础课"],
        ["概率论与数理统计", "基础课"],
        ["大学物理", "基础课"],
        ["大物实验", "基础课"],
        ["复变函数", "基础课"],
        ["理论力学", "基础课"],
        ["工程制图B", "基础课"],
        ["英语大一上", "基础课"],
        ["Matlab应用基础", "基础课"],
        ["思想道德与法治", "通识课"],
        ["道德与法治", "通识课"],
        ["形势与政策大一", "通识课"],
        ["环境保护与可持续发展", "通识课"],
        ["文献检索", "通识课"],
        ["质量工程导论", "通识课"],
        ["信号与系统", "专业基础"],
        ["数字电子技术基础", "专业基础"],
        ["高频电子线路", "专业基础"],
        ["微机原理及接口技术", "专业基础"],
        ["理论物理导论", "专业基础"],
        ["固体物理课件", "专业基础"],
        ["电子工艺实习", "专业基础"],
        ["可编程逻辑器件", "专业基础"],
        ["半导体物理与器件", "专业核心"],
        ["半导体集成电路基础", "专业核心"],
        ["集成电路分析与设计", "专业核心"],
        ["集成电路设计自动化", "专业核心"],
        ["集成电路测试技术", "专业核心"],
        ["集成电路封装及可靠性设计", "专业核心"],
        ["微纳器件及集成电路工艺", "专业核心"],
        ["集成电路科学前沿技术", "专业核心"],
        ["集成电路专业英语", "专业核心"],
        ["集成电路综合实践", "专业核心"],
      ]);

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
        ["package", "PACK"],
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
        currentQuery: "",
        notifications: [],
        unsafeCourses: new Set(),
        unsafePackageRoots: new Set(),
      };

      const shell = document.querySelector(".site-shell");
      const searchInput = document.querySelector("#searchInput");
      const courseFilter = document.querySelector("#courseFilter");
      const typeFilter = document.querySelector("#typeFilter");
      const sortOrder = document.querySelector("#sortOrder");
      const courseSlider = document.querySelector("#courseSlider");
      const emptyState = document.querySelector("#emptyState");
      const terminalLog = document.querySelector("#terminalLog");
      const notificationButton = document.querySelector("#notificationButton");
      const notificationPanel = document.querySelector("#notificationPanel");
      const notificationCount = document.querySelector("#notificationCount");
      const notificationList = document.querySelector("#notificationList");
      const commentFeed = document.querySelector("#commentFeed");
      const contributionForm = document.querySelector("#contributionForm");
      const commentForm = document.querySelector("#commentForm");
      const themeToggle = document.querySelector("#themeToggle");
      const backToTop = document.querySelector("#backToTop");
      const mobileSearchFab = document.querySelector("#mobileSearchFab");
      const quickTags = document.querySelector("#quickTags");

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

      function getDisplayType(item) {
        return item.type === "package" ? "PACK" : getType(item.path);
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
        const relativePath = path.includes("/") ? path.split("/").slice(1).join("/") : path;
        const parentPath = relativePath.includes("/") ? relativePath.split("/").slice(0, -1).join("/") : "课程根目录";
        const encoded = encodePath(path);
        const isPackage = item.type === "package";
        return {
          path,
          name,
          relativePath,
          parentPath,
          course,
          size: item.size || 0,
          type: isPackage ? "PACK" : getDisplayType(item),
          ext: getExt(path),
          fileCount: item.fileCount || 1,
          unsafe: Boolean(item.unsafe),
          html_url: isPackage ? `${repoTreeBase}${encoded}` : `${repoBlobBase}${encoded}`,
          download_url: isPackage && item.unsafe ? `${repoTreeBase}${encoded}` : isPackage ? getDirectoryDownloadUrl(path) : `${githubRawBase}${encoded}`,
          isPackage,
        };
      }

      function isPublicCourseFile(item) {
        if (item.type !== "blob" && item.type !== "package") return false;
        if (!item.path.includes("/")) return false;
        if (hiddenPattern.test(item.path)) return false;
        if (blockedPattern.test(item.path)) return false;
        return true;
      }

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

      function collapsePackageEntries(items, unsafePackageRoots = new Set()) {
        const packages = new Map();
        const visible = [];

        for (const item of items) {
          if (item.type === "package") {
            visible.push(item);
            continue;
          }

          const root = getPackageRoot(item.path);
          if (!root || blockedPattern.test(root)) {
            visible.push(item);
            continue;
          }

          const existing = packages.get(root) || {
            path: root,
            type: "package",
            size: 0,
            fileCount: 0,
            unsafe: unsafePackageRoots.has(root),
          };
          existing.size += item.size || 0;
          existing.fileCount += 1;
          packages.set(root, existing);
        }

        return [...visible, ...packages.values()];
      }

      function getUnsafeInfo(tree, payload = {}) {
        const unsafeCourses = new Set(payload.unsafeCourses || []);
        const unsafePackageRoots = new Set(payload.unsafePackageRoots || []);

        for (const item of tree) {
          if (!item.path || !blockedPattern.test(item.path)) continue;
          unsafeCourses.add(item.path.split("/")[0]);
          const root = getPackageRoot(item.path);
          if (root) unsafePackageRoots.add(root);
        }

        return { unsafeCourses, unsafePackageRoots };
      }

      function getDirectoryDownloadUrl(path) {
        return `${downloadDirectoryBase}${encodeURIComponent(`${repoTreeBase}${encodePath(path)}`)}`;
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
          <p class="readme-kicker">README.md</p>
          <h2>中北大学课程攻略共享计划</h2>
          <p>这里整理中北大学课程资料、复习经验、历年试卷、学习建议和补充材料。资料按最初的课程目录层级展示，方便后来的同学顺着文件夹找到真正需要的内容。</p>
          <div class="readme-stats" aria-label="Repository summary">
            <span>${resources.length} files</span>
            <span>${courses} courses</span>
            <span>${types} types</span>
            <span>${blockedCount} unsafe paths hidden</span>
          </div>
          <h3>为什么要做这件事</h3>
          <p>大学课程资料常常散落在群聊、网盘、论坛和个人电脑里。很多真正有用的信息并不是不存在，而是难以系统获取，只能靠运气和口口相传。</p>
          <p>这个项目希望把零散、隐晦、依赖个人保存的资料与经验，逐步转化为公开、可查阅、可积累、可持续完善的共享资源。</p>
          <h3>内容范围</h3>
          <ul>
            <li>选课与学习建议</li>
            <li>电子教材、参考书与补充材料</li>
            <li>平时作业参考、复习资料和历年试卷</li>
            <li>课程实验、项目文件和经验总结</li>
          </ul>
          <h3>贡献方式</h3>
          <p>欢迎通过贡献入口、评论区或 GitHub Issue 补充资料。如果不方便操作 Git，也可以把资料链接或附件说明提交出来，由维护者协助整理到对应课程目录。</p>
          <p class="terminal-muted">欢迎通过贡献入口、评论区或 GitHub Issue 补充资料。${escapeHtml(sourceLabel)} · GitHub LFS raw · folder tree view</p>
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
        const entries = [...groups.entries()]
          .map(([course, files]) => ({
            course,
            files: files.sort((a, b) => a.path.localeCompare(b.path, "zh-Hans-CN")),
          }));

        const order = sortOrder ? sortOrder.value : "files-desc";
        switch (order) {
          case "files-asc":
            entries.sort((a, b) => a.files.length - b.files.length || a.course.localeCompare(b.course, "zh-Hans-CN"));
            break;
          case "name-asc":
            entries.sort((a, b) => a.course.localeCompare(b.course, "zh-Hans-CN"));
            break;
          case "name-desc":
            entries.sort((a, b) => b.course.localeCompare(a.course, "zh-Hans-CN"));
            break;
          default:
            entries.sort((a, b) => b.files.length - a.files.length || a.course.localeCompare(b.course, "zh-Hans-CN"));
        }
        return entries;
      }

      function createDirectoryNode(name, path) {
        return {
          kind: "directory",
          name,
          path,
          children: new Map(),
          fileCount: 0,
          size: 0,
        };
      }

      function buildCourseTree(course, files) {
        const root = createDirectoryNode(course, course);

        for (const item of files) {
          const segments = item.relativePath.split("/").filter(Boolean);
          let current = root;

          for (let index = 0; index < segments.length - 1; index += 1) {
            const segment = segments[index];
            const path = `${course}/${segments.slice(0, index + 1).join("/")}`;
            if (!current.children.has(segment)) {
              current.children.set(segment, createDirectoryNode(segment, path));
            }
            current = current.children.get(segment);
          }

          current.children.set(`${item.name}:${item.path}`, {
            kind: item.isPackage ? "package" : "file",
            name: item.name,
            path: item.path,
            item,
            fileCount: item.fileCount || 1,
            size: item.size || 0,
          });
        }

        aggregateDirectoryStats(root);
        return root;
      }

      function aggregateDirectoryStats(node) {
        if (node.kind !== "directory") {
          return { fileCount: node.fileCount || 1, size: node.size || 0 };
        }

        let fileCount = 0;
        let size = 0;
        for (const child of node.children.values()) {
          const stats = aggregateDirectoryStats(child);
          fileCount += stats.fileCount;
          size += stats.size;
        }
        node.fileCount = fileCount;
        node.size = size;
        return { fileCount, size };
      }

      function compareTreeNodes(a, b) {
        const rank = { directory: 0, package: 1, file: 2 };
        return rank[a.kind] - rank[b.kind] || a.name.localeCompare(b.name, "zh-Hans-CN");
      }

      function getTreeChildren(node) {
        return [...node.children.values()].sort(compareTreeNodes);
      }

      function isUnsafePath(path) {
        const course = path.split("/")[0];
        if (path === course && state.unsafeCourses.has(course)) return true;
        return [...state.unsafePackageRoots].some((root) => path === root || path.startsWith(`${root}/`) || root.startsWith(`${path}/`));
      }

      function renderDirectoryRow(node, depth) {
        const unsafe = isUnsafePath(node.path);
        const treeUrl = `${repoTreeBase}${encodePath(node.path)}`;
        const downloadUrl = unsafe ? treeUrl : getDirectoryDownloadUrl(node.path);
        return `
          <div class="course-file-row directory-row" style="--depth: ${depth}">
            <span class="file-kind">DIR</span>
            <div class="file-main">
              <div class="file-name">${escapeHtml(node.name)}</div>
              <div class="file-meta">${node.fileCount} files · ${formatSize(node.size) || "folder"}</div>
            </div>
            <div class="file-links">
              <a class="action-link" href="${treeUrl}" target="_blank" rel="noopener">查看</a>
              <a class="action-link" href="${downloadUrl}" target="_blank" rel="noopener">${unsafe ? "目录" : "整包"}</a>
            </div>
          </div>
        `;
      }

      function renderFileRow(item, depth) {
        const query = state.currentQuery || "";
        const nameHtml = highlightText(item.name, query);
        const isPdf = item.ext === "pdf";
        const previewLink = isPdf
          ? `<a class="action-link preview-link" href="${item.download_url}" target="_blank" rel="noopener" title="在线预览 PDF">预览</a>`
          : "";
        return `
          <div class="course-file-row" style="--depth: ${depth}">
            <span class="file-kind">${escapeHtml(item.type)}</span>
            <div class="file-main">
              <div class="file-name">${nameHtml}</div>
              <div class="file-meta">${escapeHtml(getFileMeta(item))}</div>
            </div>
            <div class="file-links">
              ${previewLink}
              <a class="action-link" href="${item.html_url}" target="_blank" rel="noopener">查看</a>
              <a class="action-link" href="${item.download_url}" target="_blank" rel="noopener">${item.isPackage ? item.unsafe ? "目录" : "整包" : "下载"}</a>
            </div>
          </div>
        `;
      }

      function renderTreeRows(node, depth = 0) {
        return getTreeChildren(node).map((child) => {
          if (child.kind === "directory") {
            return `${renderDirectoryRow(child, depth)}${renderTreeRows(child, depth + 1)}`;
          }
          return renderFileRow(child.item, depth);
        }).join("");
      }

      function renderCourseIndex(resources) {
        const groups = groupResourcesByCourse(resources);
        document.querySelector("#resourceCount").textContent = `${resources.length} files`;
        document.querySelector("#courseListCount").textContent = `${groups.length} courses`;
        emptyState.style.display = resources.length === 0 ? "block" : "none";

        courseSlider.innerHTML = groups.map((group, index) => {
          const typeCounts = countBy(group.files, "type").slice(0, 4);
          const courseDownloadUrl = getDirectoryDownloadUrl(group.course);
          const canDownloadCourse = !state.unsafeCourses.has(group.course);
          const courseTree = buildCourseTree(group.course, group.files);
          const category = courseCategories.get(group.course) || "其他";
          const isHot = group.files.length >= 10;
          return `
            <article class="course-column" aria-label="${escapeHtml(group.course)}">
              <header class="course-column-header">
                <div class="course-column-kicker">
                  <span>[ ${String(index + 1).padStart(2, "0")} ]</span>
                  <span class="course-category-badge">${escapeHtml(category)}</span>
                  <span>${group.files.length} files${isHot ? " 🔥" : ""}</span>
                </div>
                <h3 class="course-column-title">${escapeHtml(group.course)}</h3>
                <div class="course-actions">
                  <a class="course-action-link" href="${canDownloadCourse ? courseDownloadUrl : `${repoTreeBase}${encodePath(group.course)}`}" target="_blank" rel="noopener">${canDownloadCourse ? "全部下载" : "打开目录"}</a>
                </div>
                <div class="course-type-strip">
                  ${typeCounts.map(([type, count]) => `<span class="course-type-chip">${escapeHtml(type)} · ${count}</span>`).join("")}
                </div>
              </header>
              <div class="course-file-list">
                ${renderTreeRows(courseTree)}
              </div>
            </article>
          `;
        }).join("");

        if (resources.length > 0) {
          courseSlider.scrollTo({ left: 0, behavior: "smooth" });
        }
      }

      function getFileMeta(item) {
        const location = item.parentPath || "课程根目录";
        if (item.isPackage) return `${location} · ${item.fileCount || 0} files · ${formatSize(item.size) || "package"}`;
        return `${location} · ${formatSize(item.size) || item.ext || "file"}`;
      }

      function renderResources(resources) {
        renderCourseIndex(resources);
      }

      function applyFilters() {
        const query = searchInput.value.trim().toLowerCase();
        const course = courseFilter.value;
        const type = typeFilter.value;
        state.selectedCourse = course;
        state.currentQuery = query;
        state.filteredResources = state.allResources.filter((item) => {
          const haystack = `${item.course} ${item.name} ${item.path} ${item.type}`.toLowerCase();
          return (!query || haystack.includes(query)) && (!course || item.course === course) && (!type || item.type === type);
        });
        renderMetrics(state.allResources);
        renderCourseControls(state.allResources);
        renderResources(state.filteredResources);
        updateEmptyState(query);
      }

      function updateEmptyState(query) {
        if (state.filteredResources.length === 0 && query) {
          emptyState.style.display = "block";
          emptyState.innerHTML = `<p>没有匹配「${escapeHtml(query)}」的资料。</p><p style="color:var(--muted);margin-top:8px;">试试搜索「试卷」「期末」「复习」「PPT」</p>`;
        } else if (state.filteredResources.length === 0) {
          emptyState.style.display = "block";
          emptyState.innerHTML = `<p>没有匹配的资料。</p>`;
        } else {
          emptyState.style.display = "none";
        }
      }

      function loadNotifications() {
        try {
          return JSON.parse(localStorage.getItem(notificationKey)) || [];
        } catch {
          return [];
        }
      }

      function saveNotifications(items) {
        localStorage.setItem(notificationKey, JSON.stringify(items.slice(0, 12)));
      }

      function pushNotification(title, detail, url = "") {
        state.notifications = [{
          title,
          detail,
          url,
          time: new Date().toLocaleString("zh-CN"),
        }, ...state.notifications].slice(0, 12);
        saveNotifications(state.notifications);
        renderNotifications();
      }

      function renderNotifications() {
        notificationCount.textContent = state.notifications.length;
        notificationCount.hidden = state.notifications.length === 0;
        notificationList.innerHTML = state.notifications.length
          ? state.notifications.map((item) => `
              <a class="notification-item" href="${escapeHtml(item.url || "#")}" target="_blank" rel="noopener">
                <strong>${escapeHtml(item.title)}</strong>
                <span>${escapeHtml(item.detail)}</span>
                <small>${escapeHtml(item.time)}</small>
              </a>
            `).join("")
          : `<p class="notification-empty">暂无新动态</p>`;
      }

      function buildIssueUrl({ title, labels, body }) {
        const params = new URLSearchParams({ title, labels, body });
        return `${openIssueUrl}?${params.toString()}`;
      }

      function openIssueDraft(issueUrl) {
        window.open(issueUrl, "_blank", "noopener");
        showToast("已打开 GitHub Issue 草稿，请在新页面确认提交。");
      }

      async function handleContribution(event) {
        event.preventDefault();
        const btn = contributionForm.querySelector(".submit-button");
        btn.textContent = "提交中...";
        btn.disabled = true;

        const isAnon = contributionForm.querySelector("#anonymousContribution").checked;
        const name = isAnon ? "匿名" : (contributionForm.contributorName.value.trim() || "匿名");
        const studentId = isAnon ? "" : (contributionForm.studentId.value.trim() || "");
        const course = contributionForm.courseName.value.trim();
        const title = contributionForm.contributionTitle.value.trim();
        const link = contributionForm.contributionLink.value.trim();
        const note = contributionForm.contributionNote.value.trim();

        try {
          if (isConfigured()) {
            await supabaseInsert("contributions", {
              contributor_name: name,
              student_id: studentId,
              course_name: course,
              title,
              link,
              note,
              is_anonymous: isAnon,
            });
            pushNotification("贡献已提交", `${name} · ${course}`);
            showToast("贡献提交成功，感谢你的分享！");
          } else {
            const issueUrl = buildIssueUrl({
              title: `[贡献] ${course} - ${title}`,
              labels: "contribution",
              body: `贡献者：${name}${studentId ? ` / ${studentId}` : ""}\n\n课程：${course}\n\n资料：${title}\n\n文件链接：${link || "待补充"}\n\n备注：${note || "无"}`,
            });
            pushNotification("贡献草稿", `${name} · ${course}`, issueUrl);
            openIssueDraft(issueUrl);
          }
          contributionForm.reset();
        } catch (error) {
          showToast("提交失败，请稍后重试", true);
          console.error(error);
        } finally {
          btn.textContent = "提交贡献";
          btn.disabled = false;
        }
      }

      async function handleComment(event) {
        event.preventDefault();
        const btn = commentForm.querySelector(".submit-button");
        btn.textContent = "提交中...";
        btn.disabled = true;

        const isAnon = commentForm.querySelector("#anonymousComment").checked;
        const name = isAnon ? "匿名" : (commentForm.commentName.value.trim() || "匿名");
        const studentId = isAnon ? "" : (commentForm.commentStudentId.value.trim() || "");
        const body = commentForm.commentBody.value.trim();

        try {
          if (isConfigured()) {
            await supabaseInsert("comments", {
              commenter_name: name,
              student_id: studentId,
              body,
              is_anonymous: isAnon,
            });
            pushNotification("新评论", name);
            showToast("评论发表成功！");
            loadCommentsFeed();
          } else {
            const issueUrl = buildIssueUrl({
              title: `[评论] ${name}`,
              labels: "comment",
              body: `评论者：${name}${studentId ? ` / ${studentId}` : ""}\n\n内容：${body}`,
            });
            pushNotification("评论草稿", name, issueUrl);
            openIssueDraft(issueUrl);
          }
          commentForm.reset();
        } catch (error) {
          showToast("提交失败，请稍后重试", true);
          console.error(error);
        } finally {
          btn.textContent = "发表评论";
          btn.disabled = false;
        }
      }

      function showToast(message, isError = false) {
        const existing = document.querySelector(".toast");
        if (existing) existing.remove();
        const toast = document.createElement("div");
        toast.className = `toast ${isError ? "toast-error" : "toast-success"}`;
        toast.textContent = message;
        document.body.appendChild(toast);
        setTimeout(() => toast.classList.add("toast-visible"), 10);
        setTimeout(() => { toast.classList.remove("toast-visible"); setTimeout(() => toast.remove(), 300); }, 3000);
      }

      async function loadRemoteNotifications() {
        if (!isConfigured()) return;
        try {
          const contributions = await supabaseSelect("contributions", { order: "created_at.desc", limit: 6 });
          const remoteItems = contributions.map((c) => ({
            title: `[贡献] ${c.title}`,
            detail: `${c.contributor_name} · ${c.course_name}`,
            url: "",
            time: new Date(c.created_at).toLocaleString("zh-CN"),
          }));
          state.notifications = [...remoteItems, ...state.notifications].slice(0, 12);
          renderNotifications();
        } catch (error) {
          console.warn("Remote notifications unavailable.", error);
        }
        loadCommentsFeed();
      }

      async function loadCommentsFeed() {
        if (!commentFeed) return;
        if (!isConfigured()) {
          commentFeed.innerHTML = `<div class="comment-card is-empty"><strong>留言走 GitHub Issue</strong><span>后端未配置时会打开草稿页</span></div>`;
          return;
        }
        try {
          const comments = await supabaseSelect("comments", { order: "created_at.desc", limit: 8 });
          if (comments.length === 0) {
            commentFeed.innerHTML = `<div class="comment-card is-empty"><strong>暂无评论</strong><span>提交后会在这里显示</span></div>`;
            return;
          }
          commentFeed.innerHTML = comments.map((c) => `
            <div class="comment-card">
              <strong>${escapeHtml(c.commenter_name || "匿名")}</strong>
              <span>${escapeHtml(c.body.slice(0, 120))}</span>
              <small>${new Date(c.created_at).toLocaleDateString("zh-CN")}</small>
            </div>
          `).join("");
        } catch (error) {
          commentFeed.innerHTML = `<div class="comment-card is-empty"><strong>评论加载失败</strong><span>请稍后再试</span></div>`;
        }
      }

      async function loadContributors() {
        const contributorsList = document.querySelector("#contributorsList");
        if (!contributorsList) return;
        try {
          const contributors = await fetchJson(
            "https://api.github.com/repos/QuanShengLi0508/NUC-Course-Sharing-Program/contributors?per_page=20",
            { headers: { Accept: "application/vnd.github+json" } }
          );
          contributorsList.innerHTML = contributors.map((c) => `
            <a class="contributor-chip" href="${escapeHtml(c.html_url)}" target="_blank" rel="noopener">
              <img src="${escapeHtml(c.avatar_url)}&s=48" alt="" loading="lazy">
              <span>${escapeHtml(c.login)}</span>
            </a>
          `).join("");
        } catch (error) {
          contributorsList.innerHTML = `<span style="color:var(--muted);font-size:13px;">贡献者列表加载失败</span>`;
        }
      }

      // === COURSE RATINGS ===
      const ratingForm = document.querySelector("#ratingForm");
      const ratingFeed = document.querySelector("#ratingFeed");

      async function handleRating(event) {
        event.preventDefault();
        const btn = ratingForm.querySelector(".submit-button");
        btn.textContent = "提交中...";
        btn.disabled = true;

        const course = ratingForm.ratingCourse.value.trim();
        const difficulty = ratingForm.ratingDifficulty.value;
        const tips = ratingForm.ratingTips.value.trim();

        try {
          if (isConfigured()) {
            await supabaseInsert("course_reviews", { course_name: course, difficulty, tips });
            pushNotification("课程评价", `${course} · ${difficulty}`);
            showToast("评价提交成功！");
            loadRatings();
          } else {
            const issueUrl = buildIssueUrl({
              title: `[课程评价] ${course} - ${difficulty}`,
              labels: "course-review",
              body: `课程：${course}\n\n难度：${difficulty}\n\n学习建议：${tips}`,
            });
            pushNotification("评价草稿", `${course} · ${difficulty}`, issueUrl);
            openIssueDraft(issueUrl);
          }
          ratingForm.reset();
        } catch (error) {
          showToast("提交失败，请稍后重试", true);
          console.error(error);
        } finally {
          btn.textContent = "提交评价";
          btn.disabled = false;
        }
      }

      if (ratingForm) {
        ratingForm.addEventListener("submit", handleRating);
      }

      async function loadRatings() {
        if (!ratingFeed) return;
        if (!isConfigured()) {
          ratingFeed.innerHTML = `<div class="comment-card is-empty"><strong>评价走 GitHub Issue</strong><span>后端未配置时会打开草稿页</span></div>`;
          return;
        }
        try {
          const reviews = await supabaseSelect("course_reviews", { order: "created_at.desc", limit: 10 });
          if (reviews.length === 0) {
            ratingFeed.innerHTML = `<div class="comment-card is-empty"><strong>暂无评价</strong><span>成为第一个评价课程的人</span></div>`;
            return;
          }
          ratingFeed.innerHTML = reviews.map((r) => `
            <div class="rating-card">
              <strong>${escapeHtml(r.course_name)} · ${escapeHtml(r.difficulty)}</strong>
              <p class="rating-tips">${escapeHtml(r.tips)}</p>
              <span class="rating-meta">${new Date(r.created_at).toLocaleDateString("zh-CN")}</span>
            </div>
          `).join("");
        } catch (error) {
          ratingFeed.innerHTML = `<div class="comment-card is-empty"><strong>评价加载失败</strong><span>请稍后再试</span></div>`;
        }
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
          const localPayload = await fetchJson(localIndexUrl);
          refreshFromApi();
          return { payload: localPayload, sourceLabel: "local index (fast)" };
        } catch (localError) {
          console.warn("Local index unavailable, trying GitHub API.", localError);
          const apiPayload = await fetchJson(repoApi, { headers: { Accept: "application/vnd.github+json" } });
          return { payload: apiPayload, sourceLabel: "GitHub API" };
        }
      }

      async function refreshFromApi() {
        try {
          const apiPayload = await fetchJson(repoApi, { headers: { Accept: "application/vnd.github+json" } });
          const allBlobs = apiPayload.tree.filter((item) => item.type === "blob" && item.path.includes("/"));
          const unsafeInfo = getUnsafeInfo(apiPayload.tree, apiPayload);
          state.unsafeCourses = unsafeInfo.unsafeCourses;
          state.unsafePackageRoots = unsafeInfo.unsafePackageRoots;
          const resources = collapsePackageEntries(apiPayload.tree.filter(isPublicCourseFile), state.unsafePackageRoots)
            .map(normalizeTreeItem)
            .sort((a, b) => a.course.localeCompare(b.course, "zh-Hans-CN") || a.name.localeCompare(b.name, "zh-Hans-CN"));

          if (resources.length > state.allResources.length) {
            state.allResources = resources;
            state.filteredResources = resources;
            const blockedCount = allBlobs.length - resources.length;
            setTerminal(resources, blockedCount, "GitHub API (synced)");
            renderCourseControls(resources);
            renderTypeControl(resources);
            renderMetrics(resources);
            renderResources(resources);
          }
        } catch (error) {
          console.warn("Background API sync skipped.", error);
        }
      }

      async function boot() {
        const { payload, sourceLabel } = await loadTreePayload();
        const allBlobs = payload.tree.filter((item) => item.type === "blob" && item.path.includes("/"));
        const unsafeInfo = getUnsafeInfo(payload.tree, payload);
        state.unsafeCourses = unsafeInfo.unsafeCourses;
        state.unsafePackageRoots = unsafeInfo.unsafePackageRoots;
        const resources = collapsePackageEntries(payload.tree
          .filter(isPublicCourseFile)
        , state.unsafePackageRoots)
          .map(normalizeTreeItem)
          .sort((a, b) => a.course.localeCompare(b.course, "zh-Hans-CN") || a.name.localeCompare(b.name, "zh-Hans-CN"));
        const blockedCount = Number.isFinite(payload.blockedCount) ? payload.blockedCount : allBlobs.length - resources.length;

        state.notifications = loadNotifications();
        renderNotifications();
        state.allResources = resources;
        state.filteredResources = resources;
        setTerminal(resources, blockedCount, sourceLabel);
        renderCourseControls(resources);
        renderTypeControl(resources);
        renderMetrics(resources);
        renderResources(resources);
        shell.classList.remove("loading");
        loadRemoteNotifications();
        loadContributors();
        loadRatings();
      }

      searchInput.addEventListener("input", applyFilters);
      courseFilter.addEventListener("change", applyFilters);
      typeFilter.addEventListener("change", applyFilters);
      if (sortOrder) sortOrder.addEventListener("change", applyFilters);
      notificationButton.addEventListener("click", () => {
        const isOpen = !notificationPanel.hidden;
        notificationPanel.hidden = isOpen;
        notificationButton.setAttribute("aria-expanded", String(!isOpen));
      });
      contributionForm.addEventListener("submit", handleContribution);
      commentForm.addEventListener("submit", handleComment);

      // === DARK MODE ===
      function initTheme() {
        const saved = localStorage.getItem("nuc-theme");
        if (saved === "dark" || (!saved && window.matchMedia("(prefers-color-scheme: dark)").matches)) {
          document.documentElement.setAttribute("data-theme", "dark");
        }
      }
      initTheme();

      if (themeToggle) {
        themeToggle.addEventListener("click", () => {
          const isDark = document.documentElement.getAttribute("data-theme") === "dark";
          const next = isDark ? "light" : "dark";
          document.documentElement.setAttribute("data-theme", next);
          localStorage.setItem("nuc-theme", next);
        });
      }

      // === BACK TO TOP ===
      if (backToTop) {
        window.addEventListener("scroll", () => {
          backToTop.classList.toggle("is-visible", window.scrollY > 400);
        }, { passive: true });
        backToTop.addEventListener("click", () => {
          window.scrollTo({ top: 0, behavior: "smooth" });
        });
      }

      // === MOBILE SEARCH FAB ===
      if (mobileSearchFab) {
        mobileSearchFab.addEventListener("click", () => {
          searchInput.focus();
          window.scrollTo({ top: 0, behavior: "smooth" });
        });
      }

      // === QUICK TAGS ===
      if (quickTags) {
        quickTags.addEventListener("click", (e) => {
          const tag = e.target.closest(".quick-tag");
          if (!tag) return;
          const query = tag.dataset.query;
          const isActive = tag.classList.contains("is-active");

          quickTags.querySelectorAll(".quick-tag").forEach((t) => t.classList.remove("is-active"));

          if (isActive) {
            searchInput.value = "";
          } else {
            tag.classList.add("is-active");
            searchInput.value = query;
          }
          applyFilters();
        });
      }

      // === SEARCH HIGHLIGHT ===
      function highlightText(text, query) {
        if (!query) return escapeHtml(text);
        const escaped = escapeHtml(text);
        const regex = new RegExp(`(${query.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")})`, "gi");
        return escaped.replace(regex, `<mark class="search-highlight">$1</mark>`);
      }

      boot().catch((error) => {
        console.error(error);
        terminalLog.innerHTML = `
          <p class="readme-kicker">README.md</p>
          <h2>中北大学课程攻略共享计划</h2>
          <p>这里整理中北大学课程资料、复习经验、历年试卷、学习建议和补充材料。当前目录索引暂时加载失败，可以先打开 GitHub 仓库查看原始文件夹。</p>
          <h3>项目初衷</h3>
          <p>让已经被整理出来的课程资料和学习经验，不再只存在于运气之中。</p>
          <p class="terminal-muted">GitHub API temporarily unavailable.</p>
        `;
        shell.classList.remove("loading");
      });
    
