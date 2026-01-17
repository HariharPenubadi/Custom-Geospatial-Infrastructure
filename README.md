# Custom-Geospatial-Infrastructure (Self-Hosted Maps)

![Docker](https://img.shields.io/badge/Docker-Containerized-blue?logo=docker)
![Caddy](https://img.shields.io/badge/Caddy-Reverse%20Proxy-green?logo=caddy)
![Mapbox GL](https://img.shields.io/badge/Mapbox%20GL-Vector%20Tiles-orange)
![OSRM](https://img.shields.io/badge/OSRM-Routing%20Engine-yellow)

> A high-performance, offline-capable geospatial microservice stack. Delivers vector tiles, custom styling, and turn-by-turn routing entirely independent of third-party APIs like Google Maps.

![Image Alt](https://github.com/HariharPenubadi/Custom-Geospatial-Infrastructure/blob/7331f5ad8fba32eced0be13379982d3f89cde164/Screenshot_2.png)

![Image Alt](https://github.com/HariharPenubadi/Custom-Geospatial-Infrastructure/blob/7331f5ad8fba32eced0be13379982d3f89cde164/Screenshot_1.png)

---

## Project Overview

This project containerizes a complete mapping infrastructure. It decouples map data from application logic, creating a portable "Map Microservice" that can be deployed anywhere (AWS, DigitalOcean, or on-premise) without usage fees.

It solves the problem of expensive, rate-limited map APIs by self-hosting:
*  **Vector Tiles (MBTiles):** Efficient, zoomable map data.
*  **Routing (OSRM):** Fast pathfinding (shortest path/driving).
*  **Reverse Proxying (Caddy):** Unifies multiple backend services under a single endpoint.

## Architecture

I designed this using a **microservices pattern** orchestrated by Docker Compose. A Caddy reverse proxy sits in front, routing traffic to the appropriate service based on the request path.

## Tech stack

* **Infrastructure:** &ensp; Docker, Docker Compose
* **Gateway:** &ensp; Caddy v2 (Reverse Proxy, Static File Serving)
* **Map Engine:** &ensp; TileServer GL (Serving Vector Tiles & GL Styles)
* **Routing Engine:** &ensp;  OSRM (Open Source Routing Machine)
* **Data Format:** &ensp; OpenStreetMap (PBF), MBTiles, GeoJSON
* **Frontend:** &ensp; Mapbox GL JS (Client-side rendering)

## Engineering Challenges & Solutions

During development, I optimized the stack for performance and reliability. Key challenges I solved included:
* **Service Unification:** TileServer runs on port 8080 and OSRM on 5001. I configured Caddy to stitch these into a unified API (/data/ for tiles, /route/ for navigation), eliminating CORS issues and simplifying the frontend client.
* **Font & Glyph Rendering:** Vector maps require specific PBF font stacks for labels. I engineered a custom pipeline to serve raw font data via Caddy, resolving rendering errors for local language labels.
* **Large Dataset Handling:** The stack manages 2GB+ datasets (india.mbtiles, telangana.osrm). I utilized Docker volumes to mount these efficiently without blowing up container build sizes.
* **Custom Styling:** Implemented a custom Mapbox Style specification (my_india_style.json) to overlay proprietary GeoJSON data (Restaurant locations) directly onto the base map vector layer.

## Getting Started

Prerequisites:
* Docker & Docker Compose installed.
* Data Files: (Not included in repo due to GitHub size limits)
    * Download india.mbtiles and place in root.
    * Generate/Download telangana-latest.osrm files and place in data/.

Installation:
* Clone the repository
    ```
    git clone [https://github.com/HariharPenubadi/Custom-Geospatial-Infrastructure.git](https://github.com/HariharPenubadi/Custom-Geospatial-Infrastructure.git)
    cd docker-map-server
    ```
* Start the Microservices
    ```
    docker-compose up -d
    ```
* Access the endpoints
    * Interactive Map: ``` http://localhost:8088 ```
    * Tile JSON: ``` http://localhost:8088/data/india.json ```
    * Routing API: ``` http://localhost:8088/route/v1/driving/{lon},{lat};{lon},{lat}```

Future Improvements:
* CI/CD Pipeline: Automate the daily fetching and rebuilding of OSRM graph data from OpenStreetMap.
* Auto-Scaling: Deploy to Kubernetes (K8s) to scale TileServer instances based on load.
* Geocoding: Integrate 'Photon' or 'Pelias' container for address search functionality.
