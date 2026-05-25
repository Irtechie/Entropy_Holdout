package com.example.factory;

public class Component {
    private String id;
    private String name;

    public Component(String id, String name) {
        this.id = id;
        this.name = name;
    }

    public String getId() { return id; }
    public String getName() { return name; }
}

