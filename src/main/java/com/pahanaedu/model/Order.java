package com.pahanaedu.model;

import java.time.LocalDateTime;
import java.util.List;

public class Order {
    private Long orderId;
    private Long customerId;
    private User customer;
    private LocalDateTime orderDate;
    private Double totalAmount;
    private String status;
    private String billNumber;
    private Long createdBy;
    private User createdByUser;
    private int newUnitsConsumed;
    private List<OrderItem> items;
    
    // Getters and Setters
    public Long getOrderId() { return orderId; }
    public void setOrderId(Long orderId) { this.orderId = orderId; }
    public Long getCustomerId() { return customerId; }
    public void setCustomerId(Long customerId) { this.customerId = customerId; }
    public User getCustomer() { return customer; }
    public void setCustomer(User customer) { this.customer = customer; }
    public LocalDateTime getOrderDate() { return orderDate; }
    public void setOrderDate(LocalDateTime orderDate) { this.orderDate = orderDate; }
    public Double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(Double totalAmount) { this.totalAmount = totalAmount; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getBillNumber() { return billNumber; }
    public void setBillNumber(String billNumber) { this.billNumber = billNumber; }
    public Long getCreatedBy() { return createdBy; }
    public void setCreatedBy(Long createdBy) { this.createdBy = createdBy; }
    public User getCreatedByUser() { return createdByUser; }
    public void setCreatedByUser(User createdByUser) { this.createdByUser = createdByUser; }
    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
	public int getNewUnitsConsumed() {
		return newUnitsConsumed;
	}
	public void setNewUnitsConsumed(int newUnitsConsumed) {
		this.newUnitsConsumed = newUnitsConsumed;
	}
}