# projectM EQ & Transition Fork

## Philosophy: ships flat, changes nothing by default

This fork adds per-band (Bass/Middles/Treble) sensitivity and frequency-range
controls, plus a transition effect selector. Every new setting **defaults to
exactly reproducing stock projectM's existing audio-reactive behavior** — if
you install this and never open the new Settings tabs, your presets will look
and react identically to how they always have.

This matters because the underlying band-splitting logic in stock projectM
has a long-standing quirk: it only ever analyzes the **bottom half of the
frequency spectrum** (0–11025 Hz out of the full 0–22050 Hz range), split into
three equal thirds:

| Band    | Stock/default range |
|---------|---------------------|
| Bass    | 0 – 3675 Hz         |
| Middles | 3675 – 7350 Hz      |
| Treble  | 7350 – 11025 Hz     |

This fork's defaults match these numbers exactly, down to the Hz. The upper
half of the spectrum (11025–22050 Hz) goes unused by default, same as it
always has. Global and per-band sensitivity all default to `1.0` (unchanged).

**Nothing about the audio processing pipeline itself changed** — only new,
optional, opt-in controls were added on top of it.

## Recommended alternative tuning (opt-in)

The stock band split above was never actually designed around real drum
frequencies — it's an arbitrary equal-thirds-of-half-spectrum split. If you
want visuals that react more specifically to kick drums, vocals, and cymbals
rather than the stock split, try these values in Settings → Audio:

| Band    | Suggested range | Targets |
|---------|-----------------|---------|
| Bass    | 100 – 280 Hz    | Kick drum punch/body (deliberately excludes true sub-bass below 100 Hz, which tends to move independently of the kick — basslines, sidechain drones, etc.) |
| Middles | 280 – 4000 Hz   | Vocals, snare body, guitar/synth mids |
| Treble  | 4000 – 22050 Hz | Hi-hats, cymbals, and the kick beater's click/attack transient (~2–5 kHz) |

This also extends Treble all the way to Nyquist (22050 Hz) rather than
stopping at 11025 Hz, so the full spectrum gets analyzed instead of just the
bottom half.

There's also a **known low-mid "mud" zone around 300–500 Hz** in most
full mixes — if your visuals still feel muddy/undifferentiated with the
tuning above, try narrowing Middles' low end up slightly (e.g. 400 Hz
instead of 280 Hz) to skip past it.

## New features

- **Per-band sensitivity**: scales how far each band swings from its neutral
  baseline. `0` = flat/no reactivity for that band regardless of playback
  volume. `1.0` (default) = unchanged. `>1.0` = exaggerated swings.
- **Per-band frequency range**: adjustable low/high Hz boundaries per band,
  described above.
- **Global sensitivity**: convenience slider/control that scales all three
  bands' sensitivity multipliers proportionally at once. A band you've set to
  `0` stays at `0` regardless of the global value — the global control is a
  multiplier on top of each band's own setting, not an overwrite.
- **Transition selector**: checkboxes to include/exclude individual
  transition effects (Circle, Plasma, Fade, Sweep, Warp, Zoom Blur, Beat
  Pulse, Datamosh) from the random pool used between presets. If every
  transition is disabled, the engine falls back to using the full set rather
  than breaking transitions entirely.
- **Beat Pulse** (new transition): a transition that dissolves into separate circles.
- **Datamosh** (new transition): uses the outgoing preset's own color values
  to drive its own zoom/rotation warp (the same self-referential trick used
  in classic feedback-loop presets), with an audio-driven moving center and
  several unrolled warp iterations approximating compounding feedback.

## API compatibility note

The C API (`parameters.h` and all `projectm_*` functions) is fully backward
compatible — every change is additive (new enums, new functions), no existing
function signatures changed.

One internal C++ note for anyone linking against libprojectM directly rather
than through the C API: `Audio::Loudness`'s constructor signature changed
from `Loudness(Band)` to `Loudness(Band, lowHz, highHz, sampleRate)`. This
class is `PROJECTM_CXX_EXPORT`, so it's technically part of the public C++
surface. Anyone going through the documented C API is unaffected.