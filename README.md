# 元器件比价工具 v2.0 - Tauri版本

基于 React 18 + Zustand + TailwindCSS + Framer Motion + TypeScript + Tauri 2.0 开发的跨平台桌面应用。

## 技术栈

- ⚛️ **React 18** - 前端框架
- 🐻 **Zustand** - 轻量级状态管理
- 🎨 **TailwindCSS** - 原子化CSS框架
- 🎬 **Framer Motion** - 流畅动画库
- 📘 **TypeScript** - 类型安全
- 🦀 **Tauri 2.0** - Rust后端 + 轻量级桌面应用框架

## 特点

✅ **超小体积** - 打包后仅 3-5MB（Electron需要100MB+）
✅ **原生性能** - Rust后端，性能卓越
✅ **跨平台** - 支持 Windows、macOS、Linux
✅ **现代化UI** - 流畅动画，美观界面
✅ **本地存储** - SQLite数据库，数据安全
✅ **离线可用** - 无需联网也能查看历史数据

## 开发环境要求

### 必需
- Node.js 18+
- Rust 1.70+
- pnpm/npm/yarn

### Windows额外要求
- Microsoft Visual Studio C++ Build Tools
- WebView2 (Windows 10/11已内置)

## 快速开始

### 1. 安装依赖

\`\`\`bash
# 安装前端依赖
npm install

# 或使用 pnpm（推荐）
pnpm install
\`\`\`

### 2. 开发模式

\`\`\`bash
# 启动开发服务器
npm run tauri:dev
\`\`\`

### 3. 构建生产版本

\`\`\`bash
# 构建Windows安装包
npm run tauri:build
\`\`\`

构建完成后，在 \`src-tauri/target/release/bundle/\` 目录下找到安装包。

## 项目结构

\`\`\`
元器件比价工具_Tauri/
├── src/                    # React前端代码
│   ├── components/         # UI组件
│   ├── stores/             # Zustand状态管理
│   ├── hooks/              # 自定义Hooks
│   ├── utils/              # 工具函数
│   ├── types/              # TypeScript类型定义
│   ├── App.tsx             # 根组件
│   └── main.tsx            # 入口文件
├── src-tauri/              # Rust后端代码
│   ├── src/
│   │   ├── main.rs         # 主入口
│   │   ├── commands.rs     # Tauri命令
│   │   ├── database.rs     # 数据库模块
│   │   └── scraper.rs      # 爬虫模块
│   ├── Cargo.toml          # Rust依赖
│   └── tauri.conf.json     # Tauri配置
├── package.json
├── vite.config.ts
├── tailwind.config.js
└── tsconfig.json
\`\`\`

## 核心功能

### 1. 元器件搜索
- 支持立创商城、云汉芯城、华秋商城等5个平台
- 实时价格对比
- 智能匹配算法

### 2. BOM批量导入
- 支持CSV/Excel格式
- 批量搜索和比价
- 一键导出报告

### 3. 价格监控
- 设置价格阈值
- 自动监控价格变化
- 到价提醒

### 4. 数据管理
- 本地SQLite数据库
- 搜索历史记录
- 收藏功能
- 数据导出（Excel/CSV/JSON）

## API接口

### 前端调用后端

\`\`\`typescript
import { invoke } from '@tauri-apps/api/tauri';

// 搜索元器件
const results = await invoke('search_component', { 
  keyword: 'STM32F103C8T6' 
});

// 获取搜索历史
const history = await invoke('get_search_history', { 
  limit: 10 
});

// 添加收藏
await invoke('add_to_favorites', { 
  component: componentData 
});
\`\`\`

## 打包说明

### Windows
- 输出格式：.msi 和 .exe 安装包
- 安装包大小：约 3-5MB
- 需要WebView2运行时（Win10/11已内置）

### macOS
- 输出格式：.dmg 和 .app
- 安装包大小：约 5-8MB
- 支持Intel和Apple Silicon

### Linux
- 输出格式：.deb、.AppImage
- 安装包大小：约 5-7MB

## 常见问题

### Q: 为什么选择Tauri而不是Electron？
A: 
- **体积小**：Tauri打包后3-5MB，Electron需要100MB+
- **性能好**：Rust后端，原生性能
- **安全**：默认安全配置，不易被攻击
- **资源占用少**：使用系统WebView，内存占用低

### Q: 需要学习Rust吗？
A: 
- 简单应用可以只用前端代码
- 复杂功能（爬虫、数据库）需要Rust
- 我们已经提供了完整的Rust后端

### Q: 如何调试？
A: 
- 开发模式下按F12打开DevTools
- 使用 \`console.log\` 和 \`println!\` 分别调试前后端

## 开发计划

- [x] 基础搜索功能
- [x] 多平台支持
- [x] 本地数据库
- [x] BOM导入
- [ ] 价格趋势图表
- [ ] 供应商管理
- [ ] 自动更新
- [ ] 云端同步

## 许可证

MIT License

## 联系方式

开发者：大Y
版本：v2.0
更新日期：2026-03-20