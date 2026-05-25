package com.example.factory;

import java.util.ArrayList;
import java.util.List;

public class Factory {
    private List<Station> stations = new ArrayList<>();
    private List<Routing> routings = new ArrayList<>();

    public void addStation(Station station) {
        stations.add(station);
    }

    public void addRouting(Routing routing) {
        routings.add(routing);
    }

    public List<Station> getStations() {
        return stations;
    }

    public List<Routing> getRoutings() {
        return routings;
    }
}

