# agy-config (Antigravity CLI Configuration)

Google Antigravity CLI (`agy`) を **Claude Code に近い操作感・自律モード・High 推論設定** で利用するための設定リポジトリです。Windows / macOS / Linux 間で設定を共有できます。

---

## 含まれる設定 (`settings.json`)

`~/.gemini/antigravity-cli/settings.json` に適用される主な項目です。

```json
{
  "$schema": "https://antigravity.google/schemas/v1/settings.json",
  "agentMode": "auto",
  "enableTerminalSandbox": true,
  "model": "Gemini 4 Argon (High)",
  "queuedMessages": "send-immediately"
}
```

| キー | 設定値 | 説明 |
| :--- | :--- | :--- |
| **`agentMode`** | `"auto"` | デフォルトの実行モードを `auto` に設定します。ワークスペース内のファイル編集や安全なコマンド実行を自動承認し、不可逆な操作のみ確認を求めます（セッション中は `Shift+Tab` で切り替え可能）。 |
| **`enableTerminalSandbox`** | `true` | `auto` モードで必要となるターミナルサンドボックスを有効化します。 |
| **`model`** | `"Gemini 4 Argon (High)"` | デフォルトモデルと推論レベル（Reasoning Effort）を `Medium` ではなく **`High`** に固定します（TUI 内の `/effort high` や `/model` で設定したものと同じ状態になります）。 |
| **`queuedMessages`** | `"send-immediately"` | **Claude Code 風の実行中割り込み指示**を有効化します。エージェントが作業中に追加メッセージを送信すると、現在のターン終了を待たずに即座に割り込んで新しい指示を考慮します（従来のキュー待ちに戻す場合は `"queue"`）。 |

---

## セットアップ（他の PC への適用方法）

各 OS の既存の `trustedWorkspaces` などの設定を保持したまま、`settings.json` の設定項目をマージ（上書き追加）します。

### Windows (PowerShell)

```powershell
git clone https://github.com/nakamura88/agy-config.git "$HOME\git\agy-config"
& "$HOME\git\agy-config\install.ps1"
```

### macOS / Linux (Bash / Zsh)

```bash
git clone https://github.com/nakamura88/agy-config.git ~/git/agy-config
bash ~/git/agy-config/install.sh
```

> **補足（セキュリティ境界について）**:
> `~/.gemini/antigravity-cli/settings.json` は Antigravity のシステム保護ルールにより、エージェント自身のファイル書き込みツールからは直接変更できないよう保護されています。そのため、上記スクリプトをご自身のターミナルから実行するか、`agy` 内の `/config`・`/effort high` コマンドで反映してください。

---

## Claude Code と Antigravity CLI (`agy`) の対応早見表

| 機能・概念 | Claude Code | Antigravity CLI (`agy`) |
| :--- | :--- | :--- |
| **基本設定・権限ファイル** | `~/.claude/settings.json` | `~/.gemini/antigravity-cli/settings.json` |
| **実行中の追加指示** | 実行中にそのまま入力して軌道修正 | `"queuedMessages": "send-immediately"`（または `"queue"`） |
| **実行モード切替** | `Shift+Tab` (`accept-edits` / `auto` / `plan`) | `Shift+Tab` (`default` > `accept-edits` > `auto` > `plan`) |
| **推論レベル (Effort)** | `/effort` または `--effort high` | `/effort high` または `--effort high`（モデル名 `(High)` として保存） |
| **プロジェクト指示書** | `CLAUDE.md` | `AGENTS.md` または `GEMINI.md`（`.agents/rules/*.md` も可） |
| **指示書の共通化** | `CLAUDE.md` | `AGENTS.md` 内に `@[CLAUDE.md](./CLAUDE.md)` と記述することで共通利用可能 |
| **ライフサイクルフック** | `settings.json` 内の `hooks` | `~/.gemini/config/hooks.json` または `.agents/hooks.json` |
| **カスタムスキル / コマンド** | `.claude/commands/*.md` | `.agents/skills/<name>/SKILL.md` または `~/.gemini/config/skills/<name>/SKILL.md` |
| **MCP サーバー設定** | `.mcp.json` / `~/.claude.json` | `~/.gemini/config/mcp_config.json` または `agy mcp` サブコマンド |
| **キーバインド変更** | `/terminal-setup` など | `/keybindings`（`~/.gemini/antigravity-cli/keybindings.json`） |

---

## よく使う CLI オプション・スラッシュコマンド

### 起動時オプション
* `agy --mode=auto` : 一時的に `auto` モードで起動
* `agy --effort high` : 一時的に推論 Effort を `high` にして起動
* `agy -c` (`--continue`) : 直前の会話を再開

### TUI 内スラッシュコマンド
* `/config` (または `/settings`) : 設定エディタを開く
* `/model` : デフォルトモデルの変更
* `/effort [low|medium|high]` : 推論 Effort レベルの確認・変更
* `/permissions` : コマンドやファイル操作の許可（`allow` / `ask` / `deny`）ルール管理
* `/keybindings` : ショートカットキーのカスタマイズ
* `/compact` : 会話コンテキストの圧縮
* `/plan` : 実装前の計画策定
* `/goal` : ゴール達成まで自律実行するモード
* `/learn` : 会話内での修正指示をルールやスキルとして永続化
