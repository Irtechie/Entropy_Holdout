package com.entropy.factory.model;

import java.util.List;

public class Routing {
    private String productId;
    private List<String> stationSequence;
    
    public Routing(String productId, List<String> stationSequence) {
        this.productId = productId;
        this.stationSequence = stationSequence;
    }
    
    // Getters and setters
    public String getProductId() { return productId; }
    public void setProductId(String productId) { this.productId = productId; }
    public List<String> getStationSequence() { return stationSequence; }
    public void setStationSequence(List<String> stationSequence) { this.stationSequence = stationSequence; }
}
