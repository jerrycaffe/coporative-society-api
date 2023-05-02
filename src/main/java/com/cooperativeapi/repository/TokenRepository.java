package com.cooperativeapi.repository;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.cooperativeapi.model.Token;

import java.util.Optional;
@Repository
public interface TokenRepository extends JpaRepository<Token, Integer> {



    Optional<Token> findByToken(String token);
}
