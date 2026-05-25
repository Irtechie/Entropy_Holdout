package com.example.factory;

import java.util.List;

public class Station {
    private String id;
    private String name;
    private List<String> supportedComponents;

    public Station(String id, String name, List<String> supportedComponents) {
        this.id = id;
        this.name = name;
        this.supportedComponents = supportedComponents;
    }

    public String getId() { return id; }
    public String getName() { return name; }
    public List<String> getSupportedComponents() { return supportedComponents; }
}

