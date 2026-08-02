package com.fashionstore.model;

public class User {

    private int userId;
    private String fullName;
    private String email;
    private String phone;
    private String password;
    private String address;
    private String createdAt;
    private boolean isAdmin;

    // Default Constructor
    public User() {}

    // Parameterized Constructor
    public User(int userId, String fullName, String email, String phone,
                String password, String address, String createdAt,
                boolean isAdmin) {
        this.userId = userId;
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.password = password;
        this.address = address;
        this.createdAt = createdAt;
        this.isAdmin = isAdmin;
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getCreatedAt() { return createdAt; }
    public void setCreatedAt(String createdAt) { this.createdAt = createdAt; }

    public boolean isAdmin() { return isAdmin; }
    public void setAdmin(boolean isAdmin) { this.isAdmin = isAdmin; }
}
