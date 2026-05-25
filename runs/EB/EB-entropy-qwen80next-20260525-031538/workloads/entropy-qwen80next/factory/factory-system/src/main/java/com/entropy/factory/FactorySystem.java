package com.entropy.factory;

import com.entropy.factory.model.Component;
import com.entropy.factory.model.Station;
import com.entropy.factory.model.Product;
import com.entropy.factory.model.Routing;
import java.util.ArrayList;
import java.util.List;

public class FactorySystem {
    // Entry point for the factory system
    // This class will orchestrate the core concepts
    
    private List<Station> stations;
    private List<Routing> routings;
    
    public FactorySystem() {
        this.stations = new ArrayList<>();
        this.routings = new ArrayList<>();
        initializeStations();
        initializeRoutings();
    }
    
    private void initializeStations() {
        Station station1 = new Station("station-001", "Assembly", List.of("component-a", "component-b"));
        Station station2 = new Station("station-002", "Inspection", List.of("component-a", "component-b"));
        Station station3 = new Station("station-003", "Packaging", List.of("component-a", "component-b"));
        
        stations.add(station1);
        stations.add(station2);
        stations.add(station3);
    }
    
    private void initializeRoutings() {
        Routing routing1 = new Routing("product-001", List.of("station-001", "station-002", "station-003"));
        Routing routing2 = new Routing("product-002", List.of("station-001", "station-003"));
        
        routings.add(routing1);
        routings.add(routing2);
    }
    
    public List<Station> getStations() {
        return stations;
    }
    
    public List<Routing> getRoutings() {
        return routings;
    }
}
