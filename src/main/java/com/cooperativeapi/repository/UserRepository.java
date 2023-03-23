package com.cooperativeapi.repository;

import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;

import com.cooperativeapi.model.User;

public interface UserRepository extends JpaRepository<User, Integer> {

	  Optional<User> findByEmail(String email);

	}

