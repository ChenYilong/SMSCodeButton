#!/usr/bin/env bash
# [EN] Fetches, at the commit in `CYL_COMMIT`, the CYLAnimatedItem components that the Android, HarmonyOS and WeChat Mini Program
#      examples build against, into `.cyl-components/` (ignored by git), and copies the mini program component into the example.
#      iOS needs none of this: its Podfile pins the same commit. Run it after every repin and before every build of these three
#      examples. Only the needed folders are checked out (sparse, no history).
# [CN] 在 `CYL_COMMIT` 记录的 commit 上，取回 Android、HarmonyOS 与微信小程序示例所依赖的 CYLAnimatedItem 组件，放入 `.cyl-components/`
#      （git 忽略），并把小程序组件复制到示例中。iOS 不需要：其 Podfile 固定在同一个 commit。每次重新固定之后、构建这三个示例之前运行。
#      只检出需要的目录（稀疏检出，无历史）。
set -euo pipefail
root="$(cd "$(dirname "$0")/.." && pwd)"
sha="$(tr -d '[:space:]' < "$root/CYL_COMMIT")"
repo="${CYL_REPO_URL:-https://github.com/ChenYilong/CYLTabBarController.git}"
dest="$root/.cyl-components"

rm -rf "$dest"
mkdir -p "$dest"
git -C "$dest" init -q
git -C "$dest" remote add origin "$repo"
git -C "$dest" config core.sparseCheckout true
cat > "$dest/.git/info/sparse-checkout" <<'PATHS'
/Example-Android/cylanimateditem/
/CrossPlatform/harmonyos-cyltabbar/cylanimateditem/
/CrossPlatform/wechat-miniprogram-cyltabbar/src/cyl-animated-item/
/CrossPlatform/wechat-miniprogram-cyltabbar/src/cyl-animation-placeholder/
/LICENSE
PATHS
git -C "$dest" fetch -q --depth 1 --filter=blob:none origin "$sha"
git -C "$dest" checkout -q FETCH_HEAD
echo "components at $(git -C "$dest" rev-parse --short HEAD)"
# [EN] The examples need the countdown style: a commit without it cannot be pinned. [CN] 示例需要倒计时样式：缺少它的 commit 不能固定。
for file in Example-Android/cylanimateditem/src/main/kotlin/com/cyl/animateditem/CYLAnimatedItemCountdown.kt \
            CrossPlatform/harmonyos-cyltabbar/cylanimateditem/src/main/ets/CYLAnimatedItemCountdown.ts \
            CrossPlatform/wechat-miniprogram-cyltabbar/src/cyl-animated-item/cyl_animated_item_countdown.js; do
  [ -f "$dest/$file" ] || { echo "commit $sha lacks $file (the countdown style): merge the countdown branch into the newest branch, push, and repin" >&2; exit 1; }
done

# [EN] The mini program takes components by path: copy them to the example's `cyl/` folder (ignored by git).
# [CN] 小程序按路径引用组件：复制到示例的 `cyl/` 目录（git 忽略）。
mp="$root/Example-MiniProgram/miniprogram/cyl"
rm -rf "$mp"
mkdir -p "$mp"
cp -R "$dest/CrossPlatform/wechat-miniprogram-cyltabbar/src/cyl-animated-item" "$mp/"
cp -R "$dest/CrossPlatform/wechat-miniprogram-cyltabbar/src/cyl-animation-placeholder" "$mp/"
echo "mini program components copied to $mp"

# [EN] hvigor builds modules inside the project folder: copy the HarmonyOS module to the example (ignored by git).
# [CN] hvigor 只构建项目目录内的模块：把鸿蒙模块复制到示例中（git 忽略）。
hm="$root/Example-HarmonyOS/cylanimateditem"
rm -rf "$hm"
cp -R "$dest/CrossPlatform/harmonyos-cyltabbar/cylanimateditem" "$hm"
echo "HarmonyOS module copied to $hm"
