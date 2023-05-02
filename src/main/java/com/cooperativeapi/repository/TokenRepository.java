package com.cooperativeapi.repository;


import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.cooperativeapi.model.Token;

import java.util.Optional;
@Repository
public interface TokenRepository extends JpaRepository<Token, Integer> {

//    @Query(value = """
//      select t from Token t inner join User u\s
//      on t.user.id = u.id\s
//      where u.id = :id and (t.expired = false or t.revoked = false)\s
//      """)
//    List<Token> findAllValidTokenByUser(Integer id);

    Optional<Token> findByToken(String token);
}
