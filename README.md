# Slay the Godot

一个用 Godot 4 引擎开发的卡牌游戏，灵感来自《杀戮尖塔》(Slay the Spire)。

## 项目结构

```
slay-the-godot/
├── scenes/
│   ├── main_menu.tscn
│   └── battle/
│       └── battle_scene.tscn
├── scripts/
│   ├── ui/
│   │   └── main_menu.gd
│   ├── battle/
│   │   └── battle_manager.gd
│   ├── entities/
│   │   ├── player.gd
│   │   └── enemy.gd
│   ├── card_system/
│   │   ├── card.gd
│   │   ├── deck.gd
│   │   └── card_database.gd
│   └── managers/
│       └── game_manager.gd
└── project.godot
```

## 开发进度

### Phase 1: 核心框架 ✅
- ✅ Godot 项目初始化
- ✅ 基础卡牌类和卡组系统
- ✅ 简单战斗场景框架
- ✅ 主菜单

### Phase 2: 战斗系统 ⏳
- [ ] 完整回合制战斗逻辑
- [ ] 卡牌打出和效果执行
- [ ] 敌人AI和攻击模式
- [ ] UI交互

## 快速开始

1. 用 Godot 4.1+ 打开项目
2. 按 F5 运行游戏
3. 点击"开始游戏"进入战斗场景

## 许可证

MIT
