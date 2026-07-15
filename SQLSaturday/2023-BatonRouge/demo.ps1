• ExecutionPolicy on Windows
• Running with pwsh -noprofile
	• Best for testing code you want to share
• $profile | select *
AllUsersAllHosts       : C:\Program Files\PowerShell\7-preview\profile.ps1
AllUsersCurrentHost    : C:\Program Files\PowerShell\7-preview\Microsoft.PowerShell_profile.ps1
CurrentUserAllHosts    : C:\Users\sewhee\Documents\PowerShell\profile.ps1
CurrentUserCurrentHost : C:\Users\sewhee\Documents\PowerShell\Microsoft.PowerShell_profile.ps1
• Environment tweaks
	• Key mapping
	• coloring
	• $PSDefaultParameterValues - https://mikefrobbins.com/2019/08/01/whats-in-your-powershell-psdefaultparametervalues-preference-variable/

	$PSDefaultParameterValues += @{
	    'Out-Default:OutVariable' = 'LastResult'
	    'Out-File:Encoding' = 'utf8'
	    'Export-Csv:NoTypeInformation' = $true
	    'ConvertTo-Csv:NoTypeInformation' = $true
	    'Receive-Job:Keep' = $true
	    'Install-Module:AllowClobber' = $true
	    'Install-Module:Force' = $true
	    'Install-Module:SkipPublisherCheck' = $true
	    'Group-Object:NoElement' = $true
	    'Find-Module:Repository' = 'PSGallery'
	    'Install-Module:Repository' = 'PSGallery'
	}
	• Custom prompts

• Version specific
	• Using "`e" vs $ESC
	• Conditional module loading
		○ PSStyle
	• Differences between Windows PowerShell 5.1 and PowerShell 7.x
		• Missing modules and cmdlets - Release history of modules and cmdlets
		• New cmdlets
		• Changes to cmdlet behaviors - deprecated features, etc.
		• Exe name (powershell vs. pwsh)
		• Experimental features
		• New operators (null, ternary, and chain operators)
		• Encoding defaults - always specify for cross-plat compat (prefer UTF8)
		• & at end for backgrounding to a job
		• Total rewrite of Web cmdlets
		• PSStyle
• Host-specific commands
	• VS Code vs. console/terminal
• Platform specific
	• dir variable:is*

	Name                           Value
	----                           -----
	IsLinux                        False
	IsMacOS                        False
	IsWindows                      True
	IsCoreCLR                      True
	IsAdmin                        False
		• No OS variables in Windows PowerShell so you can set them in your profile
		$IsLinux = $IsMacOS = $IsCoreCLR = $False
		$IsWindows = $True
	• PowerShell differences on non-Windows platforms
		○ Missing modules and cmdlets - Release history of modules and cmdlets
		○ Execution policy
		○ Case-sensitivity
		○ Path and directory separators
		○ Environment variables
		○ No aliases that collide with native commands
		○ No unix job control - & at end for backgrounding to a job
		○ Out of scope for profiles
			§ Remoting
			§ DSC
	• [system.io.path] | gm -s -Type property

	   TypeName: System.IO.Path

	Name                      MemberType Definition
	----                      ---------- ----------
	AltDirectorySeparatorChar Property   static char AltDirectorySeparatorChar {get;}
	DirectorySeparatorChar    Property   static char DirectorySeparatorChar {get;}
	InvalidPathChars          Property   static char[] InvalidPathChars {get;}
	PathSeparator             Property   static char PathSeparator {get;}
	VolumeSeparatorChar       Property   static char VolumeSeparatorChar {get;}



