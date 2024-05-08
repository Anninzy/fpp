# untitled-game

## Rojo
> [!NOTE]
> `Lighting` will be managed after https://github.com/rojo-rbx/rojo/issues/363 is closed.
> - `Lighting.FogEnd` = `inf`
> - `Lighting.Bloom.Threshold` = `inf`

## TODO (listed in priority)
- [ ] Reimplement old code
- [ ] Refactor code
- [ ] Complete Weapon: Revolver
- [ ] Merge with Aston
- [ ] Movement system
- [ ] More dynamic camera that follows player movement
- [ ] Animations
- [ ] Use Rojo to manage all Roblox services
- [ ] Figure out a way to add `ChatWindowConfiguration`, `ChatInputBarConfiguration`, and `BubbleChatConfiguration` to `default.project.json` so `TextChatService` can be managed

## Getting Started
To build the place from scratch, use:

```bash
rojo build -o "untitled-game.rbxlx"
```

Next, open `untitled-game.rbxlx` in Roblox Studio and start the Rojo server:

```bash
rojo serve
```
