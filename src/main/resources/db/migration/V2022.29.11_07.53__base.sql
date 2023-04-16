CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE TABLE IF NOT EXISTS status
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    name CHARACTER VARYING UNIQUE NOT NULL,
    description CHARACTER VARYING NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);
CREATE TABLE IF NOT EXISTS _users
(
    id         UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    first_name CHARACTER varying,
    last_name  character varying,
    email      character varying not null unique,
    phone      character varying,
    dob TIMESTAMP WITH TIME ZONE,
    password   character varying not null,
    email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    status UUID NOT NULL,
    deleted boolean DEFAULT false,
    img_url character varying,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_users_status FOREIGN KEY (status) REFERENCES status(id) ON UPDATE CASCADE ON DELETE CASCADE

);
CREATE INDEX IF NOT EXISTS users_email_idx ON _users (email);



CREATE TABLE IF NOT EXISTS roles
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    name CHARACTER VARYING UNIQUE NOT NULL,
    description CHARACTER VARYING NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS permissions
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    name CHARACTER VARYING UNIQUE NOT NULL,
    description CHARACTER VARYING NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS users_roles
(
    user_id UUID NOT NULL,
    role_id UUID NOT NULL,
    CONSTRAINT pk_users_roles_user_id_role_id PRIMARY KEY (user_id, role_id),
    CONSTRAINT fk_users_roles_user_id FOREIGN KEY (user_id) REFERENCES _users(id) ON DELETE CASCADE,
    CONSTRAINT fk_users_roles_role_id FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS roles_permissions
(
    role_id UUID NOT NULL,
    permission_id UUID NOT NULL,
    CONSTRAINT pk_roles_permissions_role_id_permission_id PRIMARY KEY (role_id, permission_id),
    CONSTRAINT fk_roles_permissions_permission_id FOREIGN KEY (permission_id) REFERENCES permissions(id) ON DELETE CASCADE,
    CONSTRAINT fk_roles_permissions_role_id FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS users_tokens (
    id SERIAL PRIMARY KEY NOT NULL,
    user_id UUID NOT NULL ,
    token UUID UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    expire_on TIMESTAMP WITH TIME ZONE,

    CONSTRAINT fk_users_token_user_id FOREIGN KEY (user_id) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS banks
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    code CHARACTER(3) UNIQUE NOT NULL,
    name CHARACTER VARYING NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS bank_accounts
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    alias CHARACTER VARYING,
    account_number CHARACTER(10) NOT NULL,
    user_id UUID NOT NULL,
    bank_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_bank_accounts_banks_id FOREIGN KEY (bank_id) REFERENCES banks(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_bank_accounts_users_id FOREIGN KEY (user_id) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS countries
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    code CHARACTER(2) UNIQUE NOT NULL,
    name CHARACTER varying,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);
CREATE TABLE IF NOT EXISTS user_locations
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    street_address CHARACTER VARYING,
    city CHARACTER VARYING,
    state CHARACTER VARYING,
    country_id UUID NOT NULL,
    postal_code CHARACTER VARYING,
    CONSTRAINT fk_locations_users_id FOREIGN KEY (user_id) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_locations_countries_id FOREIGN KEY (country_id) REFERENCES countries(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS states
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    code CHARACTER(5) NOT NULL,
    name CHARACTER varying,
    country_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_states_country_id FOREIGN KEY (country_id) REFERENCES countries(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS branches
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    street_address CHARACTER VARYING,
    state_id UUID NOT NULL,
    country_id UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_branches_state_id FOREIGN KEY (state_id) REFERENCES states(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_branches_countries_id FOREIGN KEY (country_id) REFERENCES countries(id) ON UPDATE CASCADE ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS file_uploads
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    path CHARACTER VARYING NOT NULL,
    name CHARACTER VARYING NOT NULL,
    type CHARACTER VARYING NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);

CREATE TABLE IF NOT EXISTS complaints
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    processed_by UUID NOT NULL,
    description character varying,
    status UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_complaints_processed_by FOREIGN KEY (processed_by) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_complaints_user_id FOREIGN KEY (user_id) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_complaints_status FOREIGN KEY (status) REFERENCES status(id) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS categories
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    name CHARACTER VARYING UNIQUE NOT NULL,
    description CHARACTER VARYING NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);
CREATE TABLE IF NOT EXISTS interests_rates
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    name CHARACTER VARYING UNIQUE NOT NULL,
    rate CHARACTER VARYING NOT NULL,
    description CHARACTER VARYING NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE
);
CREATE TABLE IF NOT EXISTS items
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    name character varying,
    created_by UUID NOT NULL,
    unit character varying,
    unit_amount character varying,
    interest_id UUID NOT NULL,
    selling_price CHARACTER VARYING,
    quantity_available character varying,
    description character varying,
    status UUID NOT NULL,
    category UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_items_created_by FOREIGN KEY (created_by) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_items_category FOREIGN KEY (category) REFERENCES categories(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_items_status FOREIGN KEY (status) REFERENCES status(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_items_interest_id FOREIGN KEY (interest_id) REFERENCES interests_rates(id) ON UPDATE CASCADE ON DELETE CASCADE
);




CREATE TABLE IF NOT EXISTS items_file_uploads
(
    item_id UUID NOT NULL,
    file_id UUID NOT NULL,
    CONSTRAINT pk_items_file_uploads_item_id_item_file_id PRIMARY KEY (file_id, item_id),
    CONSTRAINT fk_items_file_uploads_item_id FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE,
    CONSTRAINT fk_items_file_uploads_file_id FOREIGN KEY (file_id) REFERENCES file_uploads(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS savings
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    updated_by UUID NOT NULL,
    amount CHARACTER VARYING NOT NULL,
    description character varying,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_savings_updated_by FOREIGN KEY (updated_by) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_savings_user_id FOREIGN KEY (user_id) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS purchases
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    total_amount character varying,
    status UUID NOT NULL,
    discount CHARACTER VARYING,
    processed_by UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_purchases_user_id FOREIGN KEY (user_id) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_purchases_processed_by FOREIGN KEY (processed_by) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_purchases_status FOREIGN KEY (status) REFERENCES status(id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS items_purchases
(
    item_id UUID NOT NULL,
    purchase_id UUID NOT NULL,
    quantity character varying,
    amount CHARACTER VARYING,
    CONSTRAINT pk_item_id_purchase_id PRIMARY KEY (item_id, purchase_id),
    CONSTRAINT fk_items_purchases_purchase_id FOREIGN KEY (purchase_id) REFERENCES purchases(id) ON DELETE CASCADE,
    CONSTRAINT fk_items_purchases_item_id FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS purchases_deductions
(
    id UUID NOT NULL,
    user_id UUID NOT NULL,
    purchase_id UUID NOT NULL,
    amount CHARACTER VARYING NOT NULL,
    updated_by UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
     CONSTRAINT fk_purchases_deductions_updated_by FOREIGN KEY (updated_by) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_purchases_deductions_user_id FOREIGN KEY (user_id) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_purchases_deductions_purchase_id FOREIGN KEY (purchase_id) REFERENCES purchases(id) ON DELETE CASCADE
);



CREATE TABLE IF NOT EXISTS loans
(
    id UUID PRIMARY KEY NOT NULL DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL,
    processed_by UUID NOT NULL,
    amount CHARACTER VARYING NOT NULL,
    requested_amount CHARACTER VARYING NOT NULL,
    interest_id UUID NOT NULL,
    description character varying,
    comment character varying,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_loans_processed_by FOREIGN KEY (processed_by) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE,
     CONSTRAINT fk_loans_interest_id FOREIGN KEY (interest_id) REFERENCES interests_rates(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_loans_user_id FOREIGN KEY (user_id) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE TABLE IF NOT EXISTS loans_deductions
(
    id UUID NOT NULL,
    user_id UUID NOT NULL,
    loan_id UUID NOT NULL,
    updated_by UUID NOT NULL,
    amount CHARACTER VARYING NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    CONSTRAINT fk_purchases_deductions_updated_by FOREIGN KEY (updated_by) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_loans_deductions_user_id FOREIGN KEY (user_id) REFERENCES _users(id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_loans_deductions_loan_id FOREIGN KEY (loan_id) REFERENCES loans(id) ON DELETE CASCADE
);