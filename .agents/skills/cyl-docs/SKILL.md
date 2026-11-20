---
name: cyl-docs
description: "Documentation rules of SMSCodeButton: bilingual two-column tables, the task log with the user's prompt, screenshots, issue tables, stale notes before a commit. Use when adding a feature, changing behavior, or editing README.md or docs/."
---

# Documentation

- **Bilingual**: every document and README section is a table `| 中文 | English |` (left Chinese, right English); a heading is
  `## [CN]…` followed by `## [EN]…`. Agents read the English column. Write both when you write either.
- **Task log first**: before a task, add a `TODO` row to the most relevant document (`docs/Countdown-Button.md`), with the context, the
  requirements and the user's prompt quoted verbatim; when done, make it `DONE` with the result and evidence (commits, tests,
  screenshots). A prompt in Chinese is quoted as written and translated in the same row.
- **Upstream issues**: a table per repository the work fixes issues of: issue link, description, fix status (`TODO` by default,
  then `DONE` with the commit and test). This project: SMSCodeButton issue #1.
- **Pinned commit**: a document that names a CYLTabBarController feature names the commit the Podfile pins (sha, date, branch).
- **Screenshots**: originals, never scaled or recompressed, in `docs/assets/`, labeled with platform, OS version, simulator or device,
  Xcode / iOS SDK, the pinned commit and the time; the README shows cropped key details, stacked vertically (a column reads best on a
  phone). Before the first screenshot of a feature the document says "no screenshots yet".
- **Stale notes before every commit**: `grep -rn -i -E "TODO|Linux|without Xcode|no (iOS )?simulator|no screenshots?" docs README.md`;
  for each hit about a feature, test it and update the document, or keep it with what was checked and when (only the maintainer can
  do some, e.g. a real-device test).
- **Keep skills current**: a change in API use updates `cyl-api-map`; a change in structure updates `cyl-new-project`.
- This repository has no generated navigation blocks: write the contents table of a long document by hand.
