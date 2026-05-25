package com.example.factory;

import java.util.List;

public class RouteEngine {
    private StationGraph stationGraph;

    public RouteEngine(StationGraph stationGraph) {
        this.stationGraph = stationGraph;
    }

    public boolean canRoute(Product product, Routing routing) {
        List<String> stations = routing.getStationSequence();
        for (int i = 0; i < stations.size() - 1; i++) {
            String current = stations.get(i);
            String next = stations.get(i + 1);
            if (!stationGraph.getTransitions(current).contains(next)) {
                return false;
            }
        }
        return true;
    }
}

