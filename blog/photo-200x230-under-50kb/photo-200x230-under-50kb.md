# Photo 200x230 Under 50KB for Online Forms

![FormSathi Home overview](../assets/screenshots/home-overview.png)

Some forms ask for both exact dimensions and a file-size cap. That is why `photo 200x230 under 50kb` is a separate topic from a general passport photo article. The user needs both conditions to pass at the same time.

## What this requirement means

The portal wants:

- width `200px`
- height `230px`
- file size below `50KB`

This is more specific than a simple `passport photo under 50kb` requirement.

## Correct order of operations

1. Start with a clear original photo.
2. Crop to the right framing.
3. Resize to `200x230`.
4. Compress until the file is below `50KB`.
5. Check that the final photo still looks natural.

## Why users fail this upload

- they compress before resizing
- they use the wrong aspect ratio
- they shrink the file too aggressively
- they upload a different `200x230` file prepared for another form

## FormSathi use case

This is a strong search-intent page because it maps exactly to a repeat task in the app. A user should be able to move from this article to the photo resize tool with no friction.

## Recommended content block for the live site

Add a short requirement table:

| Rule | Example |
|---|---|
| Width | `200px` |
| Height | `230px` |
| File size | `Under 50KB` |
| Format | Usually JPG/JPEG |

That makes the article easier to scan and more useful in search.

## FAQ

### Is 200x230 the same as passport size everywhere?

No. Different portals ask for different dimensions.

### Can I keep the file under 50KB without losing quality?

Often yes, if the original photo is clean and properly cropped first.

### What if the portal still rejects the file?

Check the official notice again. The issue may be format, dimensions, or face framing rather than only file size.
