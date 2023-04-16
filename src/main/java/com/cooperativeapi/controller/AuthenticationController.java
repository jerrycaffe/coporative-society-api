package com.cooperativeapi.controller;

import com.cooperativeapi.dto.RegisterDto;
import com.cooperativeapi.service.RegistrationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/v1/auth")
public class AuthenticationController {
	@Autowired
    private  RegistrationService service;

    @PostMapping("/register")
    public ResponseEntity<String> register(
            @RequestBody RegisterDto registrationDto){
return ResponseEntity.ok(service.register(registrationDto));
    }

    @GetMapping("/confirm")
    public ResponseEntity<String> confirm(@RequestParam String token){
        return ResponseEntity.ok(service.confirm(token));
    }
}
