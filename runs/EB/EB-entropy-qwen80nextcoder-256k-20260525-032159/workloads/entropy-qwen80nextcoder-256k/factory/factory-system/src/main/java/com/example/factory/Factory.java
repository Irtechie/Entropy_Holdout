package com.example.factory;

import java.util.ArrayList;
import java.util.List;

public class Factory {
    private StationGraph stationGraph = new StationGraph();
    private List<Routing> routings = new ArrayList<>();

    public void addStation(Station station) {
        stationGraph.addStation(station);
    }

    public void addRouting(Routing routing) {
        routings.add(routing);
    }

    public void processProduct(Product product, String routingId) {
        Routing routing = routings.stream()
                .filter(r -> r.getId().equals(routingId))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("Routing not found: " + routingId));

        RouteEngine engine = new RouteEngine(stationGraph);
        engine.executeRoute(product, routing);
    }

    public StationGraph getStationGraph() {
        return stationGraph;
    }
}

