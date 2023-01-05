#
# Installs an addon script into the .bash-too.d directory in ${HOME}.
#
# Ties in directly with the infrastructure established in dotfiles' install script.
#
function Install-Addon {
    $target_dir = Join-Path -Path ~ -ChildPath ".bash-too.d"

    $source = $args[0]
    $target = Join-Path -Path $target_dir -ChildPath (Split-Path -Path $source -Leaf)

    if (-not(Test-Path -Path $target)) {
        New-Item -ItemType SymbolicLink -Path $target -Target $source
    } elseif ((Get-Item -Path $target).Attributes.ToString() -match "ReparsePoint") {
        Remove-Item -Path $target
        if ($?) {
            New-Item -ItemType SymbolicLink -Path $target -Target $source
        }
    } else {
        Write-Error "${target} exists but is not a symlink. Skipping..."
    }
}
