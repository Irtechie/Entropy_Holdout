package com.example.factory;

import java.util.Arrays;
import java.util.List;

public class FactoryService {
    private StationGraph stationGraph;
    private RouteEngine routeEngine;

    public FactoryService() {
        this.stationGraph = new StationGraph();
        this.routeEngine = new RouteEngine(stationGraph);
        initializeStations();
    }

    private void initializeStations() {
        Station receiving = new Station("receiving", "Receiving", Arrays.asList("c1"));
        Station assembly = new Station("assembly", "Assembly", Arrays.asList("c1", "c2"));
        Station testing = new Station("testing", "Testing", Arrays.asList("c1", "c2"));
        Station shipping = new Station("shipping", "Shipping", Arrays.asList("c1", "c2"));

        stationGraph.addStation(receiving);
        stationGraph.addStation(assembly);
        stationGraph.addStation(testing);
        stationGraph.addStation(shipping);

        stationGraph.addTransition("receiving", "assembly");
        stationGraph.addTransition("assembly", "testing");
        stationGraph.addTransition("testing", "shipping");
    }

    public void routeProduct(Product product, Routing routing) {
        routeEngine.executeRoute(product, routing);
    }

    public StationGraph getStationGraph() {
        return stationGraph;
    }
}

