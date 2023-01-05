function Install-File {
    $source = $args[0]
    $target = $args[1]

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

function Install-Directory {
    $source = $args[0]
    $target = $args[1]

    if (-not(Test-Path -Path $target)) {
        New-Item -ItemType SymbolicLink -Path $target -Target $source
    } elseif ((Get-Item -Path $target).Attributes.ToString() -match "ReparsePoint") {
        New-Item -ItemType SymbolicLink -Path $target -Target $source -Force
    } elseif (Test-Path -Path $target -PathType Container) {
        Write-Host "Target is a directory; trying to install contained files separately..."
        $srcFileList = Get-ChildItem -Path $source -Name
        foreach ($srcFile in $srcFileList) {
            Install-File (Join-Path -Path $source -ChildPath $srcFile) (Join-Path -Path $target -ChildPath (Split-Path -Path $srcFile -Leaf))
        }
    } else {
        Write-Error "${target} exists but is neither a symlink nor a directory. Skipping..."
    }
}

$curdir = $PSScriptRoot

$fileList = ".bash_aliases",".bashrc",".exports",".functions",".gitconfig"
foreach ($dotfile in $fileList) {
    Install-File (Join-Path -Path $curdir -ChildPath $dotfile) (Join-Path -Path ~ -ChildPath $dotfile)
}

$dirList = "bin",".bash-util.d",".ps1-util.d"
foreach ($srcdir in $dirList) {
    Install-Directory (Join-Path -Path $curdir -ChildPath $srcdir) (Join-Path -Path ~ -ChildPath $srcdir)
}

$addonDirectory = Join-Path -Path ~ -ChildPath ".bash-too.d"
if (-not(Test-Path -Path $addonDirectory)) {
    New-Item -Path $addonDirectory -ItemType Directory
}
