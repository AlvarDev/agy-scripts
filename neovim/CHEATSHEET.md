# Neovim Quick Reference Cheat Sheet

A handy guide of the most important and useful native commands for Neovim.

## 💾 Saving & Exiting

*   **`i`** - Enter **Insert Mode** (start typing text).
*   **`Esc`** (or **`Ctrl + [`**) - Return to **Normal Mode**.
*   **`:w`** - Save (write) changes.
*   **`:wa`** - Save all open files.
*   **`:q`** - Quit (fails if there are unsaved changes).
*   **`:q!`** - Quit without saving changes.
*   **`:wq`** (or **`ZZ`**) - Save and quit.

---

## 📝 Editing (Normal Mode)

*   **`u`** - **Undo** last action.
*   **`Ctrl + r`** - **Redo** (reverse the undo).
*   **`x`** - Delete the character under the cursor.
*   **`dd`** - **Delete (Cut)** the entire current line.
*   **`dw`** - **Delete (Cut)** from cursor to the end of the word.
*   **`yy`** - **Copy (Yank)** the entire current line.
*   **`p`** - **Paste** copied/cut text after the cursor.
*   **`P`** - **Paste** copied/cut text before the cursor.
*   **`r`** - Replace the single character under the cursor (type `r` followed by the new letter).

---

## 🚀 Navigation (Normal Mode)

*   **`h` `j` `k` `l`** - Left, Down, Up, Right (arrow key replacements).
*   **`w`** - Jump forward to the start of the next **word**.
*   **`b`** - Jump backward to the start of the previous **word**.
*   **`0`** (zero) - Jump to the **start** of the line.
*   **`$`** - Jump to the **end** of the line.
*   **`gg`** - Jump to the **first line** of the file.
*   **`G`** - Jump to the **last line** of the file.
*   **`#line_number` followed by `G`** (e.g. `45G`) - Jump to line 45.

---

## 🔍 Search and Replace

*   **`/pattern`** - Search forward for a word (e.g., `/hello`). Press **`n`** for the next match, **`N`** for the previous.
*   **`:%s/old/new/g`** - Search and replace `old` with `new` everywhere in the file.
*   **`:%s/old/new/gc`** - Same as above, but **asks you to confirm** each replacement.

---

## 🗂️ Tabs & Splits

*   **`:vsplit`** (or **`:vsp`**) - Split the screen **vertically** (side-by-side editing).
*   **`:split`** (or **`:sp`**) - Split the screen **horizontally** (top and bottom editing).
*   **`Ctrl + w w`** - Cycle your cursor through open split panels.
*   **`:tabnew`** - Open a completely new file tab.
*   **`gt`** - Switch to the **next** tab.
*   **`gT`** - Switch to the **previous** tab.
