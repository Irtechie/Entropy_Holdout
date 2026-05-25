package com.example.factory;

import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class StationGraph {
    private Map<String, Station> stations = new HashMap<>();
    private Map<String, Set<String>> transitions = new HashMap<>();

    public void addStation(Station station) {
        stations.put(station.getId(), station);
    }

    public void addTransition(String fromStationId, String toStationId) {
        transitions.computeIfAbsent(fromStationId, k -> new HashSet<>()).add(toStationId);
    }

    public Station getStation(String id) {
        return stations.get(id);
    }

    public boolean hasStation(String id) {
        return stations.containsKey(id);
    }

    public Set<String> getTransitions(String stationId) {
        return transitions.getOrDefault(stationId, new HashSet<>());
    }
}

