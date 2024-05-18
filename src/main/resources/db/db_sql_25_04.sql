-- This script was generated by the ERD tool in pgAdmin 4.
-- Please log an issue at https://github.com/pgadmin-org/pgadmin4/issues/new/choose if you find any bugs, including reproduction steps.
BEGIN;

CREATE TYPE user_role as ENUM ('MANAGER','USER');

CREATE CAST (varchar AS user_role) WITH INOUT AS IMPLICIT;


CREATE TABLE IF NOT EXISTS public.users
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
    login character varying NOT NULL,
    password character varying NOT NULL,
    name character varying NOT NULL,
    email character varying NOT NULL,
    enabled boolean NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT user_login_constraint UNIQUE (login)
);

CREATE TABLE IF NOT EXISTS public.users_roles
(
    role user_role NOT NULL,
    user_id bigint NOT NULL,
    CONSTRAINT unique_multipl_columns_constrainr UNIQUE (role, user_id)
);

CREATE TABLE IF NOT EXISTS public.services
(
    id bigint NOT NULL GENERATED BY DEFAULT AS IDENTITY,
    name character varying NOT NULL,
    description character varying NOT NULL,
    contact_email character varying NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.faqs
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
    service_id bigint NOT NULL,
    question character varying NOT NULL,
    answer character varying NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.tickets
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
    service_id bigint NOT NULL,
    name character varying NOT NULL,
    problem character varying NOT NULL,
    created timestamp without time zone NOT NULL,
    modified timestamp without time zone NOT NULL,
    owner_id bigint NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.messages
(
    id bigint NOT NULL GENERATED ALWAYS AS IDENTITY,
    ticket_id bigint NOT NULL,
    user_id bigint NOT NULL,
    message character varying NOT NULL,
    created timestamp without time zone NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS public.tickets_users
(
    user_id bigint NOT NULL,
    ticket_id bigint NOT NULL
);

CREATE TABLE IF NOT EXISTS public.services_users
(
    user_id bigint NOT NULL,
    service_id bigint NOT NULL,
    CONSTRAINT user_id_service_id_unique_constraint UNIQUE (user_id, service_id)
);

ALTER TABLE IF EXISTS public.users_roles
    ADD CONSTRAINT user_id_foreign_key_constraint FOREIGN KEY (user_id)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID;


ALTER TABLE IF EXISTS public.faqs
    ADD CONSTRAINT service_foreign_key_constraint FOREIGN KEY (service_id)
        REFERENCES public.services (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID;


ALTER TABLE IF EXISTS public.tickets
    ADD CONSTRAINT service_id_foreign_key_constraint FOREIGN KEY (service_id)
        REFERENCES public.services (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID;


ALTER TABLE IF EXISTS public.tickets
    ADD CONSTRAINT owner_id_foreign_key_constraint FOREIGN KEY (owner_id)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID;


ALTER TABLE IF EXISTS public.messages
    ADD CONSTRAINT ticket_id_foreign_key_constraint FOREIGN KEY (ticket_id)
        REFERENCES public.tickets (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID;


ALTER TABLE IF EXISTS public.messages
    ADD CONSTRAINT user_id_foreign_key_constraint FOREIGN KEY (user_id)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID;


ALTER TABLE IF EXISTS public.tickets_users
    ADD CONSTRAINT user_id_foreign_key_constraint FOREIGN KEY (user_id)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID;


ALTER TABLE IF EXISTS public.tickets_users
    ADD CONSTRAINT ticket_id_foreign_key_constraint FOREIGN KEY (ticket_id)
        REFERENCES public.tickets (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID;


ALTER TABLE IF EXISTS public.services_users
    ADD CONSTRAINT user_id_foreign_key_constraint FOREIGN KEY (user_id)
        REFERENCES public.users (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID;


ALTER TABLE IF EXISTS public.services_users
    ADD CONSTRAINT service_id_foreign_key_constraint FOREIGN KEY (service_id)
        REFERENCES public.services (id) MATCH SIMPLE
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
        NOT VALID;



CREATE OR REPLACE FUNCTION add_created_and_modified()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.created = NOW();
    NEW.modified = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION add_created()
    RETURNS TRIGGER AS
$$
BEGIN
    NEW.created = NOW();
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE TRIGGER message_triger
    BEFORE INSERT
    ON messages
    FOR EACH ROW
EXECUTE FUNCTION add_created();

CREATE OR REPLACE TRIGGER before_insert_trigger
    BEFORE INSERT
    ON tickets
    FOR EACH ROW
EXECUTE FUNCTION add_created_and_modified();

END;

