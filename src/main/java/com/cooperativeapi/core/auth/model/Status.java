package com.cooperativeapi.core.auth.model;

import lombok.*;

import javax.persistence.*;
import java.util.UUID;

@Builder
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@Entity
@Table(name = "status")
public class Status extends AuditModel {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;
    private String name;
    private String description;
}
