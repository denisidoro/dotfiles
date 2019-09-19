% git

# Clean everything
git clean -dxf

# Sign all commits in a branch based on master
git rebase master -S -f

# Checkout to branch
git checkout <branch>
