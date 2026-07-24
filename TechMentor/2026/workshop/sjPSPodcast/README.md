# sjPSPodcast

A small PowerShell module: list, search, and download episodes of [The PowerShell Podcast](https://powershellpodcast.podbean.com/).

## Commands

- `Get-sjPSPodcast` — lists every episode, newest first.
- `Find-sjPSPodcast` — filters episodes by `-Number`, `-Title`, `-Description`, `-After`, and/or `-Before`. Filters combine with AND.
- `Save-sjPSPodcast` — downloads an episode's audio file. Accepts pipeline input from `Get-sjPSPodcast`/`Find-sjPSPodcast`, or a bare `-Number`.

## Build

`sjPSPodcast.build.ps1` is a hand-rolled Invoke-Build script (no Sampler/ModuleBuilder). Requires the `InvokeBuild` and `Pester` (5.x+) modules.

```powershell
Invoke-Build -File .\sjPSPodcast.build.ps1              # Build, Test, Publish
Invoke-Build Test -File .\sjPSPodcast.build.ps1          # Build, Test only
Invoke-Build Clean -File .\sjPSPodcast.build.ps1         # wipe Output\ entirely
Invoke-Build -File .\sjPSPodcast.build.ps1 -ModuleVersion 0.2.0   # new release
Invoke-Build -File .\sjPSPodcast.build.ps1 -Force        # overwrite the current version
```

`Build` refuses to overwrite an already-built version under `Output\`, and `Publish` refuses to overwrite an already-published version in the repository — bump `-ModuleVersion` or pass `-Force`.

## Output object

Episodes are returned as `[PSCustomObject]` with `PSTypeName` `sjPSPodcast.Episode` (not a custom class), so `Formats\sjPSPodcast.Format.ps1xml` and `Types\sjPSPodcast.Types.ps1xml` can key off the type name for display without the `using module` export headaches classes bring.
