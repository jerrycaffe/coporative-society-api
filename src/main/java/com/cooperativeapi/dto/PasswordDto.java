package com.cooperativeapi.dto;

import lombok.Data;

@Data
public class PasswordDto {
    private String email;
    private String oldPassword;
    private String newPassword;
}
