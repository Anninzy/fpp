# untitled-game

## Rojo
`Workspace`, `Lighting`, `ReplicatedStorage.Assets`, `StarterGui`, and `TextChatService` is not managed by Rojo.

> [!NOTE]
> `Lighting` will be managed after https://github.com/rojo-rbx/rojo/issues/363 is closed.
> - `Lighting.FogEnd` = `inf`
> - `Lighting.Bloom.Threshold` = `inf`

## TODO (listed in priority)
- [ ] Reimplement old code
- [ ] Refactor code
- [ ] Complete Weapon: Revolver
- [ ] Rename files to .lua for better GitHub categorisation
- [ ] Go through `default.project.json` and set `$ignoreUnknownInstances` to false on most of everything
- [ ] Merge with Aston
- [ ] Movement system
- [ ] More dynamic camera that follows player movement
- [ ] Animations
- [ ] Figure out a way to add `ChatWindowConfiguration`, `ChatInputBarConfiguration`, and `BubbleChatConfiguration` to `default.project.json` so `TextChatService` can be managed

## Getting Started
To build the place from scratch, use:

```bash
rojo build -o "roblox-fps.rbxlx"
```

Next, open `roblox-fps.rbxlx` in Roblox Studio and start the Rojo server:

```bash
rojo serve
```
