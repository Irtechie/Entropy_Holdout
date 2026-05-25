package com.entropy.factory.model;

import java.util.List;

public class Product {
    private String id;
    private String name;
    private List<String> requiredComponents;
    
    public Product(String id, String name, List<String> requiredComponents) {
        this.id = id;
        this.name = name;
        this.requiredComponents = requiredComponents;
    }
    
    // Getters and setters
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public List<String> getRequiredComponents() { return requiredComponents; }
    public void setRequiredComponents(List<String> requiredComponents) { this.requiredComponents = requiredComponents; }
}
