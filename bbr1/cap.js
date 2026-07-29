// 用 Chrome DevTools Protocol + AppleScript 截滚动版的真实长图
// 因为本地无 Node 用 puppeteer，我们用 --window-size + 多次截图覆盖全 18 节
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const URL = 'file://' + path.resolve(__dirname, '../scroll.html');
const OUT_DIR = path.resolve(__dirname, '../_scroll_thumbs');
const CHROME = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';

// 18 节，每节 100vh
// 浏览器窗口 1920x1080，截 18 张
for (let i = 1; i <= 18; i++) {
  const num = String(i).padStart(2, '0');
  // 用 hash 跳转 + 立即截图
  const cmd = `"${CHROME}" --headless --disable-gpu --no-sandbox --hide-scrollbars --window-size=1920,1080 --virtual-time-budget=5000 --screenshot="${OUT_DIR}/real-${num}.png" "${URL}#p${i}" 2>/dev/null`;
  execSync(cmd);
  console.log(`shot p${num}`);
}
