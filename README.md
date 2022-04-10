# Fish plugin to switch between git branches with help of fzf

## Usage

### fco - switch between branches with stash actions

Switches between branches (including remote), if current branch has uncommitted staged changes they will be saved to stash with name like `==prev_branch_name==`, then after switching to other branch, and if there is a stash named `==current_branch_name==` it will be applied.

Execute command `fco` or press `ctrl+x ctrl+b` in git repository.

### fbr - switch between branches without stash actions

Switches between branches (including remote), stashed changes are not taken into account.

Execute command `fbr` or press `ctrl+x ctrl+g` in git repository.

## Install

```fish
fisher install kulynyak/fish.plugin-fzf-git
```
