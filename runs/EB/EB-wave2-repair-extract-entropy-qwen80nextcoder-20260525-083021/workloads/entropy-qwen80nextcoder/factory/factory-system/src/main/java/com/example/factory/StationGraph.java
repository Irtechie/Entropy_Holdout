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

    public Station getStation(String id) {
        return stations.get(id);
    }

    public void addTransition(String fromId, String toId) {
        transitions.computeIfAbsent(fromId, k -> new HashSet<>()).add(toId);
    }

    public Set<String> getTransitions(String id) {
        return transitions.getOrDefault(id, new HashSet<>());
    }

    public boolean hasStation(String id) {
        return stations.containsKey(id);
    }
}

