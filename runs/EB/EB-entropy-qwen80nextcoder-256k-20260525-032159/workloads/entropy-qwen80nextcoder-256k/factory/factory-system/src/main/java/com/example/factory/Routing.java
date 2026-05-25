package com.example.factory;

import java.util.List;

public class Routing {
    private String id;
    private String productId;
    private List<String> stationSequence;

    public Routing(String id, String productId, List<String> stationSequence) {
        this.id = id;
        this.productId = productId;
        this.stationSequence = stationSequence;
    }

    public String getId() { return id; }
    public String getProductId() { return productId; }
    public List<String> getStationSequence() { return stationSequence; }
}

