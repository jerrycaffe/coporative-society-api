package com.cooperativeapi.service;

import com.cooperativeapi.dto.RegisterDto;
import com.cooperativeapi.model.Role;
import com.cooperativeapi.model.Token;
import com.cooperativeapi.model.User;
import com.cooperativeapi.repository.TokenRepository;
import com.cooperativeapi.repository.UserRepository;
import jakarta.mail.MessagingException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class RegistrationService {

	private static final String CONFIRMATION_URL = "http://localhost:8085/api/v1/authentication/confirm?token=%s";
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
		
		// transform - map the registerdto to user dto
		User user = User.builder()
				.firstname(registerDto.getFirstname())
				.lastname(registerDto.getLastname())
				.email(registerDto.getEmail())
				.password(encodedPassword)
				.role(Role.ROLE_USER)
				.build();
				
			// save the user
		User savedUser = repository.save(user);
		// Generate a token
		String generatedToken =UUID.randomUUID().toString();
		Token token = Token.builder()
				.token(generatedToken)
				.createdAt(LocalDateTime.now())
				.expiresAt(LocalDateTime.now().plusMinutes(10))
				.user(savedUser)
				.build();
		tokenRepository.save(token);
		// send the confirmation email
		try {
			emailService.send(registerDto.getEmail(),registerDto.getFirstname(),registerDto.getLastname(),
					String.format(CONFIRMATION_URL, generatedToken));
		} catch (MessagingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return generatedToken;
		
	}
	public String confirm(String token) {
		// get the token
		Token savedToken = tokenRepository.findByToken(token)
				.orElseThrow(()-> new IllegalStateException("Token not found"));
		if(LocalDateTime.now().isAfter(savedToken.getExpiresAt())) {
			// generate a token
			String generatedToken = UUID.randomUUID().toString();
			Token newToken =Token.builder()
					.token(generatedToken)
					.createdAt(LocalDateTime.now())
					.expiresAt(LocalDateTime.now().plusMinutes(10))
					.user(savedToken.getUser())
					.build();
				tokenRepository.save(newToken);
				try {
					emailService.send(
							savedToken.getUser().getEmail(),
							savedToken.getUser().getFirstname(),
							savedToken.getUser().getLastname(),
					String.format(CONFIRMATION_URL,generatedToken)
					);
				} catch (MessagingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		}
		return "<h1>Your account has been successfully activated</h1>";
	}
}
