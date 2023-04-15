package com.cooperativeapi.service;

import org.springframework.security.core.userdetails.User;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.cooperativeapi.dto.RegisterDto;
import com.cooperativeapi.model.Role;
import com.cooperativeapi.repository.TokenRepository;
import com.cooperativeapi.repository.UserRepository;

import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class RegistrationService {

	private static final String CONFIRMATION_URL = "http://localhost:8082/api/v1/auth/confirm?token=%s";
	private final TokenRepository tokenRepository;
	private final UserRepository repository;
	private final PasswordEncoder passwordEncoder;
	private final EmailService emailService;
	
	@Transactional
	public String register(RegisterDto registerDto) {
		// check if user exist
		boolean userExists = repository.findByEmail(registerDto.getEmail()).isPresent();
		if(userExists) {
			throw new IllegalStateException("A user already exists with the same email");
		}
		// encode the password
		String encodedPassword = passwordEncoder.encode(registerDto.getPassword());
		
		// transform - ap teh registerdto to user dto
		User user = User.builder()
				.firstname(registerDto.getFirstname())
				.lastname(registerDto.getLastname())
				.email(registerDto.getEmail())
				.password(encodedPassword)
				.role(Role.USER)
				.build();
				
			// save the user
		User savedUser = repository.save(user);
		return null;
		
	}
}
