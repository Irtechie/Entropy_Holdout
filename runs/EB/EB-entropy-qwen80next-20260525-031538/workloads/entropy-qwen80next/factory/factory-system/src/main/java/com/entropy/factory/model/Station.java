package com.entropy.factory.model;

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
    
    // Getters and setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public List<String> getSupportedComponents() { return supportedComponents; }
    public void setSupportedComponents(List<String> supportedComponents) { this.supportedComponents = supportedComponents; }
}
