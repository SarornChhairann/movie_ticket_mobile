# Brand images

Generated — do not edit by hand. Regenerate after changing `TicketEmblem` or the
brand colours:

```
flutter test tool/app_icon/generate_brand_images_test.dart   # these images + assets/store/
flutter test tool/app_icon/generate_app_icons_test.dart      # launcher icons
```

Use the constants in `lib/core/assets/app_images.dart` (`AppImages.logo`, …), not
string paths. Every image has `2.0x/` and `3.0x/` variants that `Image.asset`
selects automatically.

| Image | Size (1x) | Use |
| --- | --- | --- |
| `brand/logo.png` | 160×128 | Tilted ticket with shadow (as on the app icon) |
| `brand/logo_flat.png` | 128×80 | Upright ticket, no shadow |
| `brand/logo_mono.png` | 128×80 | White, details cut out; tint with `color:` |
| `brand/wordmark.png` | 360×64 | Ticket + "Movie Tickets", white text, for dark backgrounds |
| `brand/app_icon.png` | 192×192 | Rounded app icon (About, sharing) |
| `placeholders/poster.png` | 200×300 | Missing poster (2:3) |
| `placeholders/banner.png` | 400×225 | Missing banner (16:9) |

Placeholders are flat on purpose: Flutter dithers gradients, and that noise makes
bundled PNGs many times larger. Animated or full-screen brand art (the splash
spotlight) is drawn in code instead of shipped as a bitmap.

`assets/store/` holds store listing artwork and is **not** bundled into the app:
`play_feature_graphic.png` (1024×500, no alpha), `play_icon_512.png`,
`app_store_icon_1024.png` (no alpha).
