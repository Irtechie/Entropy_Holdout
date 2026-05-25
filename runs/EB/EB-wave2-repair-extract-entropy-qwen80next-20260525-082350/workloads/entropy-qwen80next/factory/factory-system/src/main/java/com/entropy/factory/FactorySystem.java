package com.entropy.factory;

import com.entropy.factory.model.Component;
import com.entropy.factory.model.Station;
import com.entropy.factory.model.Product;
import com.entropy.factory.model.Routing;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Yaml;
import java.io.IOException;

public class FactorySystem {
    // Entry point for the factory system
    // This class will orchestrate the core concepts
    
    private Map<String, Station> stations;
    private Map<String, Routing> routings;
    
    public FactorySystem() {
        this.stations = new HashMap<>();
        this.routings = new HashMap<>();
        loadConfiguration();
    }
    
    private void loadConfiguration() {
        try {
            Path configPath = Paths.get("factory-system/config");
            if (!Files.exists(configPath)) {
                throw new IOException("Configuration file not found: " + configPath);
            }
            
            String configContent = Files.readString(configPath);
            Yaml yaml = new Yaml();
            Map<String, Object> config = yaml.load(configContent);
            
            // Load stations
            Map<String, String> stationMap = (Map<String, String>) config.get("assembly-station");
            if (stationMap == null) {
                stationMap = new HashMap<>();
                stationMap.put("assembly-station", (String) config.get("assembly-station"));
                stationMap.put("inspection-station", (String) config.get("inspection-station"));
                stationMap.put("packaging-station", (String) config.get("packaging-station"));
            }
            
            Station assemblyStation = new Station(stationMap.get("assembly-station"), "Assembly Station", List.of("motor", "wheels", "frame"));
            Station inspectionStation = new Station(stationMap.get("inspection-station"), "Inspection Station", List.of("motor", "wheels", "frame", "battery"));
            Station packagingStation = new Station(stationMap.get("packaging-station"), "Packaging Station", List.of("finished_product"));
            
            stations.put(assemblyStation.getId(), assemblyStation);
            stations.put(inspectionStation.getId(), inspectionStation);
            stations.put(packagingStation.getId(), packagingStation);
            
            // Load routing
            Map<String, List<String>> routingMap = (Map<String, List<String>>) config.get("routing");
            if (routingMap != null) {
                for (Map.Entry<String, List<String>> entry : routingMap.entrySet()) {
                    routings.put(entry.getKey(), new Routing(entry.getKey(), entry.getValue()));
                }
            }
        } catch (IOException e) {
            throw new RuntimeException("Failed to load factory configuration", e);
        }
    }
    
    public Station getStation(String stationId) {
        return stations.get(stationId);
    }
    
    public Routing getRouting(String productId) {
        return routings.get(productId);
    }
    
    public List<String> getStationSequence(String productId) {
        Routing routing = routings.get(productId);
        return routing != null ? routing.getStationSequence() : null;
    }
}
