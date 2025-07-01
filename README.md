# GeometrizeJSON2PNG
Geometrize JSON to PNG converter made with LÖVE2D framework

# Features
- High resolution output (Scroll to increase/decrease resolution)
- Batch processing (Drop multiple .json files at once)
- Multiframe export for animations ***(experimental)*** (Press "F" to toggle) (seriously this will take a lot of memory on larger files)
***You have been warned!***
- Supports both Web Demo exports and Desktop app exports

## Supported Shapes
- Rectangle
- Rotated Rectangle
- Triangle
- Ellipse
- Rotated Ellipse
- Circle
- Line
- Quadratic Bezier (is rendered as a polyline with 32 points)
- Polylines

# How to use
## Windows
- Download the latest release for Windows
- Extract the compressed folder
- Open json2png_geometrize.exe
- Drag and drop your exported JSON file from Geometrize
- If the render is successful an image will be created at `%appdata%\Geometrize JSON Renderer` with the filename `[original_filename.json]_[scale]_render.png`

### For example
- The file `geometrized_json.json` at 20x scale
- will be exported at `%appdata%\Geometrize JSON Renderer\geometrized_json.json_20x_render.png`

## Other Operating Systems
- Download [Love2D 11.5](https://love2d.org)
- Download the latest release .love file
- Run `love Geometrize.JSON2PNG.love `
