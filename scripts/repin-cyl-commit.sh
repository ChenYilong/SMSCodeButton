#!/usr/bin/env bash
# [EN] Repins every platform of this repository to one commit of CYLTabBarController: the newest commit on any branch (by
#      commit time) or the sha given. It writes `CYL_COMMIT` (read by the Android, HarmonyOS and mini program examples through
#      scripts/sync-cyl-components.sh) and the sha in the Podfile and README.md (iOS). Then: `pod install` on iOS and
#      `scripts/sync-cyl-components.sh` for the other platforms. A commit without the Swift CYLAnimatedItemView is refused;
#      scripts/sync-cyl-components.sh refuses one without the countdown style (AGENTS.md, "Depending on CYLAnimatedItem").
# [CN] 把本仓库的所有平台重新固定到 CYLTabBarController 的同一个 commit：任意分支上最新（按提交时间）的 commit，或指定的 sha。
#      写入 `CYL_COMMIT`（Android、HarmonyOS 与小程序示例通过 scripts/sync-cyl-components.sh 读取）以及 Podfile 与 README.md（iOS）中的 sha。
#      之后：iOS 执行 `pod install`，其他平台执行 `scripts/sync-cyl-components.sh`。缺少 CYLAnimatedItemView 倒计时样式的 commit 会被拒绝：
#      请固定包含它的 commit（AGENTS.md「Depending on CYLAnimatedItem」）。
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
sha="${1:-$("$root/scripts/latest-cyl-commit.sh" --sha)}"
[[ "$sha" =~ ^[0-9a-f]{40}$ ]] || { echo "not a full sha: $sha" >&2; exit 2; }

cache="${CYL_COMMIT_CACHE:-${TMPDIR:-/tmp}/cyl-latest-commit.git}"
if [ -d "$cache" ] && ! git -C "$cache" cat-file -e "$sha^{commit}" 2>/dev/null; then
  git -C "$cache" fetch -q --no-tags --filter=blob:none origin "$sha" 2>/dev/null || true
fi
if git -C "$cache" cat-file -e "$sha^{commit}" 2>/dev/null; then
  # [EN] Read into a variable: `grep -q` in a pipe would end `git ls-tree` early and fail under pipefail.
  # [CN] 读入变量：管道中的 `grep -q` 会让 `git ls-tree` 提前结束，在 pipefail 下失败。
  files="$(git -C "$cache" ls-tree -r --name-only "$sha")"
  if ! grep -q 'CYLAnimatedItem/Swift/CYLAnimatedItemView.swift' <<< "$files"; then
    echo "commit $sha has no Swift CYLAnimatedItemView" >&2; exit 1
  fi
fi

echo "$sha" > "$root/CYL_COMMIT"
sed -i.bak -E "s/(:commit => ')[0-9a-f]{40}(')/\1${sha}\2/" "$root/Podfile" "$root/README.md"
rm -f "$root/Podfile.bak" "$root/README.md.bak"
echo "pinned $sha"
