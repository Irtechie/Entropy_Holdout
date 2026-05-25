package com.example.factory;

import java.util.List;

public class Product {
    private String id;
    private String name;
    private List<Component> components;

    public Product(String id, String name, List<Component> components) {
        this.id = id;
        this.name = name;
        this.components = components;
    }

    public String getId() { return id; }
    public String getName() { return name; }
    public List<Component> getComponents() { return components; }
}

