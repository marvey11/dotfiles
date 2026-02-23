# -----------------------------------------------------------------------------
#
# git helper functions.
#
# Source in ~/.bashrc
#
# File any issue here: https://github.com/marvey11/dotfiles/issues
#
# -----------------------------------------------------------------------------
#
# MIT License
#
# Copyright (c) 2020 Marco Wegner
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# -----------------------------------------------------------------------------

#
# Clean the branches that have vanished on remote.
#
# Dry-run feature provided by Gemini.
#
# (Using -d instead of -D to only delete branches that have been merged, 
# for safety reasons.)
#
git-clean-branches() {
    # 1. Sync with remote and prune stale tracking references
    git fetch --prune || return 1

    local dry_run=false
    # Check for -n or --dry-run flag
    if [[ "$1" == "-n" || "$1" == "--dry-run" ]]; then
        dry_run=true
        echo "--- DRY RUN MODE: No branches will be deleted ---"
    fi

    local current_branch
    current_branch=$(git symbolic-ref --short HEAD 2>/dev/null)
    
    # 2. Identify 'gone' branches using Git's internal formatting
    local branches_to_delete
    branches_to_delete=$(git for-each-ref --format='%(if:equals=[gone])%(upstream:track)%(then)%(refname:short)%(end)' refs/heads)

    for branch in $branches_to_delete; do
        if [ "$branch" != "$current_branch" ]; then
            if [ "$dry_run" = true ]; then
                echo "[DRY RUN] Would remove: $branch"
            else
                echo "Removing: $branch"
                git branch -d "$branch"
            fi
        fi
    done
}
