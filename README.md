# ZoomPointMapper

This is a Shiny application built in R for creating interactive map visualizations using OpenStreetMap data. ZoomPointMapper allows users to explore geographical areas, zoom into specific regions, and overlay points of interest such as cafes, markets, parks, and restaurants. It includes features like adjustable latitude/longitude ranges, zoom levels, and downloadable map outputs.

## Features
- **Interactive Map**: Visualize a main map with customizable latitude and longitude ranges.
- **Zoom Boxes**: Explore two detailed sub-regions ("First box" and "Second box") with adjustable zoom settings and points of interest.
- **Points of Interest**: Display categorized locations (e.g., Cafe, Market, Park, Restaurant) with distinct colors and shapes.
- **Buffers and Isometrics**: Generate buffers and isometric lines around selected points using the `osrm` package.
- **Downloadable Output**: Export the generated map as a high-resolution JPEG file.
- **Dynamic Updates**: Sliders and inputs dynamically adjust based on user selections.

## Prerequisites
To run this app locally, you need the following:
- **R** (version 4.0.0 or higher recommended)
- **RStudio** (optional, but recommended for easier development)
- Required R packages (see [Installation](#installation) section)

## Installation
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/elnazkaramelikli/ZoomPointMapper.git
   cd ZoomPointMapper
   ```

2. **Install R Packages**:
   Open R or RStudio and run the following commands to install the required dependencies:
   ```R
   install.packages(c("dplyr", "OpenStreetMap", "ggforce", "sf", "osrm", "shinyjs", "shiny"))
   ```
   Note: Some packages (e.g., `OpenStreetMap`) may require additional system dependencies like Java. Ensure your system is properly configured.

3. **Data File**:
   The app requires a file named `tum_mesafe.csv` containing location data (latitude, longitude, and name columns). Place this file in the same directory as the app script. Example structure:
   ```
   longitude,latitude,name
   32.675,41.25,1
   32.6085,41.2,3
   ```

## Usage
1. **Run the App**:
   Open the R script (e.g., `app.R`) in RStudio or R and run:
   ```R
   shiny::runApp()
   ```
   Alternatively, from the command line:
   ```bash
   R -e "shiny::runApp('path/to/ZoomPointMapper')"
   ```

2. **Interact with the App**:
   - Use the **Main** tab to set the overall latitude and longitude range.
   - Adjust the **First box** and **Second box** tabs to zoom into specific areas and set points of interest.
   - Select a **Zoom Level** (0-20) to control map detail.
   - Click **Make map** to generate the visualization.
   - Use **Download Plot** to save the map as a JPEG file.

3. **Example Output**:
   The app generates a main map with two zoomed-in sub-regions, overlaid with points of interest and buffers/isometric lines.

## Screenshots
Here are some examples of ZoomPointMapper in action:

<!-- Assuming images are in the root directory; adjust paths if in a subfolder like 'images/' -->
<img src="https://github.com/user-attachments/assets/06852591-bc4d-4753-b53d-3ee53644ade0" alt="Main Map Demo" width="600"/>
<img src="https://github.com/user-attachments/assets/aac3eb9c-6de0-43b1-8db0-da8d9d9891aa" alt="Zoomed Region" width="600"/>
<img src="https://github.com/user-attachments/assets/4e596fd1-2f4b-4740-82fc-ccd3edb9df55" alt="User Interface" width="600"/>

<img src="https://github.com/user-attachments/assets/3c334816-fec2-463e-b436-23cfb730a0f1" alt="User Interface" width="600"/>

## Directory Structure
```
ZoomPointMapper/
├── app.R              # Main Shiny app script
├── tum_mesafe.csv     # Sample data file (required)
├── files/             # Directory for cached map data (auto-generated)
└── README.md          # This file
```

## Dependencies
- `dplyr`: Data manipulation
- `OpenStreetMap`: Map rendering
- `ggforce`: Geometric enhancements for ggplot2
- `sf`: Spatial data handling
- `osrm`: Routing and isometric calculations
- `shinyjs`: Enhanced Shiny interactivity
- `shiny`: Core Shiny framework

## Notes
- The app uses the OSRM server (`https://router.project-osrm.org/`) for routing and isometric calculations. Ensure internet access or configure a local OSRM server if needed.
- Cached map tiles are stored in the `files/` directory to improve performance on subsequent runs.
- Uncommented lines for `emojifont` and `ggimage` suggest optional features not currently implemented.

## Contributing
Feel free to fork this repository, submit issues, or create pull requests at [https://github.com/elnazkaramelikli/ZoomPointMapper](https://github.com/elnazkaramelikli/ZoomPointMapper). Contributions to enhance functionality, improve performance, or fix bugs are welcome!

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Contact
For questions or feedback, reach out via GitHub Issues at [https://github.com/elnazkaramelikli/ZoomPointMapper/issues](https://github.com/elnazkaramelikli/ZoomPointMapper/issues) .
