package com.example.factory;

import java.util.List;

public class RouteEngine {
    private StationGraph stationGraph;

    public RouteEngine(StationGraph stationGraph) {
        this.stationGraph = stationGraph;
    }

    public boolean canRoute(Product product, Routing routing) {
        List<String> stations = routing.getStationSequence();
        for (String stationId : stations) {
            if (!stationGraph.hasStation(stationId)) {
                return false;
            }
        }
        return true;
    }

    public void executeRoute(Product product, Routing routing) {
        if (!canRoute(product, routing)) {
            throw new IllegalArgumentException("Cannot route product: missing stations");
        }
        // Simulate product moving through stations
        for (String stationId : routing.getStationSequence()) {
            Station station = stationGraph.getStation(stationId);
            processAtStation(product, station);
        }
    }

    private void processAtStation(Product product, Station station) {
        // Placeholder for processing logic
    }
}

