# The Future of PowerShell on Windows

**Talk Outline — Living Document**

|                 |                                                     |
| --------------- | --------------------------------------------------- |
| **Presenters**  | Jason Helmick + Sean Wheeler                        |
| **Format**      | 50 minutes (presentation + Q&A)                     |
| **Audience**    | Knowledgeable user group — European community, MVPs |
| **Test-flight** | Jake Hildreth user group — July 10, 2026            |
| **Target**      | TechMentor — August 2026 (formal version)           |

> **Working note:** This outline is a living document. After each delivery, update with what worked,
> what got cut, and what the audience wanted more of. TechMentor version will be built from the
> test-flight learnings.

## 1. Introductions *(3 min)*

**Jason:**

- PM on the PowerShell team at Microsoft for 7 years — owns PowerShell inboxing, DSC v3, and
  migration
- I've been in this community a long time.
- This is a conversation, not a press release.

**Sean:**

- Principal Content Developer for the PowerShell team — documentation, thought partner, and the
  person who catches what Jason gets wrong
  - 28 years at Microsoft - most of that in support as PFE
- What does a PowerShell Documentarian do?
  - Write, edit, and curate documentation
  - Manage doc lifecycle - releases, retirements, etc.
  - UX champion - my experience in support informs my work in docs
  - Edit most of what Jason writes :)

*Tone goal: establish we're community people who happen to work at Microsoft, not corporate
spokespeople.*

## 2. Audience Check-In *(5 min)*

**Jason leads — quick show of hands to calibrate the room:**

- How many are running Windows PowerShell 5.1 in production today?
- How many are already running PowerShell 7 alongside it?
- Who manages primarily on-prem? Cloud? Multi-cloud mix?
- Who's writing *new* automation for Windows right now — are you targeting 5.1, 7, or just hoping it
  works on both?
- *(If time)* How many have looked at DSC v3?

> **Why this matters:** Their answers shape the rest of the session. If most are on 7, lean harder
> into the migration tooling story. If most are on 5.1, spend more time on "what's coming and when."
> If DSC interest is high, don't cut that section.

## 3. The State of PowerShell on Windows *(10 min)*

**Jason starts - Sean jumps in often**

### What just happened

- Microsoft officially announced PowerShell 7 is coming to Windows as a preinstalled app
  - Windows Server blog confirmed it
- This is a significant moment — the first time a modern, open-source PowerShell has shipped *with*
  Windows
- PowerShell team's own announcement with full details and timeline is coming soon

### Where things stand generally *(public-only framing)*

- **Side by side** — PS7 and PS5.1 will coexist. This is not a forced cutover.
  - **PS5.1 is not disappearing tomorrow** — there's a deliberate, multi-year runway
  - Server 2028 (late 2027)
  - Working on client - details to come
  - Windows PS 5.1 to be removed after 3-years
- **PS7 ships as MSIX** — modern app packaging; the MSI installer was deprecated starting with PS
  7.7

### The honest part *(what makes this credible with this audience)*

- We know PS7 in MSIX has gaps in some system-level scenarios — session 0, certain remoting
  patterns, enterprise deployment edge cases
  - Store apps vs PowerShell
- We're being transparent about that. The runway exists *because* we're fixing those gaps before the
  transition, not after.
  - Master issue: https://github.com/PowerShell/PowerShell/issues/27565
- Framing: *"Availability → Capability parity → Ecosystem migration"* — staged, not sudden
- Link to master tracking issue???

### What this means for you

- If you're already on PS7: you're ahead of the curve. Start testing your production automation.
- If you're on PS5.1: you have time — but _time to start_ not _time to ignore this._
- Side-by-side availability is the right moment to begin discovery and testing.
- CAUTION: Don't test using the current MSIX. Use the MSI or Zip install to test while with figure
  out the MSIX issues.

## 4. The Migration Story *(17 min)*

**Jason starts - Sean leads docs, pssa, geenral migraiton issues**

### Step 1: Know what you actually have *(5 min)* - Jason

Before you migrate anything, you need to know where PS5.1 is being invoked — including the
automation that runs *without anyone pressing Enter.*

**The "invisible automation" problem:**

The scripts you know about aren't the scary ones. It's the ones you've forgotten:

- Scheduled Tasks (often running as SYSTEM or a service account, set up years ago)
- Windows Services that shell out to `powershell.exe`
- GPO scripts — logon, logoff, startup, shutdown
- SQL Server Agent jobs calling PowerShell job steps
- Third-party monitoring and RMM tools that invoke PS under the hood

*Rule of thumb: if a human doesn't press Enter for it to run, there's a good chance it's on 5.1
somewhere you haven't thought about.*

### Step 2: Understand what breaks and why *(7 min)* - Jason

The single biggest source of PS7 compatibility breaks is the **.NET Framework → modern .NET** shift.

PS5.1 runs on .NET Framework. PS7 runs on modern .NET. Some things that worked on Framework either
don't exist in modern .NET or behave differently.

**Common scenarios:**
- COM interop — behaviors and error handling differ
- `Add-Type` with Framework-specific assemblies
- Some WMI/CIM module behavior
- Older modules built against .NET Framework that haven't been updated

**Before you assume something is broken:**

Always check for a newer cmdlet or a different approach. The old cmdlet may not exist, but the
*capability* usually does in PS7 — often done better. Check the docs, check if there's a `*-*`
replacement, check if the module has a PS7-compatible version.

### Step 3: Use the runway *(5 min)* - Sean

Side-by-side availability is your best tool. Use it:

- Run your existing automation against PS7 in a test environment
- Document what breaks; use the compatibility reference to understand why
- Fix incrementally — don't wait for a migration deadline to discover your blockers

### What we're building to help - Jason/Sean

Jason

- **Discovery tooling** — find where PS5.1 is being invoked across your environment, including the
  scenarios that don't show up in obvious places. Still in development; we want your input on what
  matters most.
- **A compatibility reference** — a structured mapping of .NET Framework APIs that changed in modern
  .NET, how those differences map to PowerShell cmdlets, and what the replacement or workaround is.
  The goal: give you a clear answer for "does this break, and if so, what do I do?"
- Additional tooling to help migrate script (may be AI-enabled)

Sean

- [PowerShell 7 migration guide — aka.ms/PSMigration] *(verify URL before talk)*
- [PowerShell 7 compatibility overview — docs.microsoft.com]
- PSScriptAnalyzer rules

**Invite from Jason to the room:**

*"We're building these migration tools with input from the community. If you hit a specific pattern
that isn't covered by existing tooling or documentation, we want to hear about it."*

> **Q&A checkpoint** — open the floor briefly before moving to DSC. This audience will have
> questions here and you want them to get out before the final section.

## 5. DSC v3 *(8 min — CONDITIONAL on time and audience interest)*

> **Cut this section if Q&A at the Step 3 checkpoint runs long, or if the audience check-in showed
> low DSC interest. It's better to have a real Q&A than a rushed DSC overview.**

**Jason leads**

### What shipped — DSC v3.2 GA

- DSC v3.2 is generally available
- WinGet now uses it natively (`processor: dscv3` in configuration files) — that's a significant
  signal

### The design shift from v1/v2

|               |             DSC v1/v2             |                    DSC v3                    |
| ------------- | --------------------------------- | -------------------------------------------- |
| Engine        | PowerShell-hosted                 | Rust — language-agnostic                     |
| Orchestration | LCM (Local Configuration Manager) | No LCM — engine + resource contract          |
| Resources     | PowerShell only                   | PowerShell, Python, Rust, anything with JSON |
| Platform      | Windows-first                     | Linux is a first-class target                |
| Pull server   | Yes                               | No — higher-order tools handle that layer    |

**The key framing:** v3 is smaller and more deliberate. It does the orchestration that belongs at
the engine layer — running resources, dependency ordering, applying state. Higher-order
orchestration (rollout strategy, drift remediation policy, scheduling across environments) is
deliberately left for tools above it to build.

### Microsoft adoption signal *(the part most people don't know)*

- **WinGet** uses DSC v3 directly: `processor: dscv3` in configuration documents
- **Bicep** orchestrates DSC v3 via gRPC — Bicep → DSC v3 directly, not through ARM
- **Azure Machine Configuration / Azure Policy Guest Configuration** runs on DSC v3
- **Image factories** use DSC v3 for machine configuration during image build

### For existing DSC v1/v2 users

- Adapters let existing PS-based resources work under v3 — migration is incremental
- Your existing v1/v2 resources don't have to be rewritten immediately

## Additional PowerShell topics

- PSResourceGet - MAR, PSGallery roadmap - Sean
- PlatyPS v1.0.2 release - now ready for everyone - Sean
- OpenSSH - Jason

## 6. Close + Q&A *(7 min)*

**Jason + Sean together**

**Jason:**

- "We came here to have a real conversation, not deliver a press release. Sean and I are here."
- Open floor — Sean catches what Jason misses

**Closing ask (important — this is a test flight):**

*"This talk is going to TechMentor next month. We're using today to figure out what's actually
useful and what we got wrong. Before you go — what did we miss? What do you want more of? What
wasn't clear?"*

**Leave the door open:**

- GitHub Discussions: github.com/PowerShell/PowerShell
- Community call (monthly)
- "If you're hitting a specific migration scenario that isn't covered anywhere, file an issue or
  come find us."

## Post-Talk Notes Template

*(Fill in after each delivery — use for TechMentor iteration)*

**Date / venue:**
**What worked:**
**What got cut:**
**What the audience wanted more of:**
**Questions we didn't have good answers for:**
**Changes for next version:**

## TechMentor Version — Known Improvements Needed

*(Running list — add to this after the test-flight)*

- [ ] Add a visual timeline slide for the inboxing arc (26H2 → 27H2 → beyond)
- [ ] Build out the "invisible automation" discovery section — can we show or demo anything?
- [ ] DSC v3 may need to be a separate session at TechMentor (30-min breakout) rather than squeezed
  into this talk
- [ ] Consider a live demo: run the same script against 5.1 and PS7, show the break, show the fix
- [ ] The compatibility section needs real examples — pull 2-3 concrete "this breaks, here's why,
  here's the fix" cases from migration feedback
- [ ] Decide: does TechMentor get DSC, or does it go deeper on migration tooling? Probably can't do
  both well in 50 min.
- [ ] **Add a "PowerShell ecosystem update" section for TechMentor** — not needed for the user
  group, but TechMentor audience will want a broader status sweep. Quick "where things stand" on:
  PSResourceGet, DSC v3, PSGallery, OpenSSH/EntraID. Format: rapid-fire status + what's next, ~5
  min. Build this section once the user group version is locked.
