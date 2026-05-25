package com.example.factory;

import java.util.List;

public class RouteEngine {
    private StationGraph stationGraph;

    public RouteEngine(StationGraph stationGraph) {
        this.stationGraph = stationGraph;
    }

    public boolean canExecute(Product product, Routing routing) {
        for (String stationId : routing.getStationSequence()) {
            if (!stationGraph.hasStation(stationId)) {
                return false;
            }
        }
        return true;
    }

    public void execute(Product product, Routing routing) {
        if (!canExecute(product, routing)) {
            throw new IllegalStateException("Routing cannot be executed with current station graph");
        }
        // Simulate product moving through stations
        for (String stationId : routing.getStationSequence()) {
            // In a real implementation, this would trigger processing at each station
        }
    }
}

