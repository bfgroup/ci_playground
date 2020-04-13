if ($env:VSWHERE_LEGACY) {
	$installationPath = vswhere -legacy -latest -property installationPath -version "$env:VSWHERE_LEGACY"
	if ($installationPath) { $env:VCVARSALL = "$installationPath\VC\vcvarsall.bat" }
}
if ($env:VSWHERE_VERSION) {
	$installationPath = vswhere -latest -products * -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 -property installationPath -version "$env:VSWHERE_VERSION"
	if ($installationPath) { $env:VCVARSALL = "$installationPath\VC\Auxiliary\Build\vcvarsall.bat" }
}
if ($env:VCVARSALL) { $setup = @("$env:VCVARSALL", "$env:PLATFORM") }
if (!($setup)) { $setup = @($env:SETUP) }
if (!($setup)) { $setup = @("Write-Output", "No setup available") }
& "$setup[0]" $setup[1..-1]
