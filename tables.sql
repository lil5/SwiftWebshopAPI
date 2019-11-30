
CREATE TABLE products
(
    id integer NOT NULL,
    fid integer NOT NULL,
    uid character varying(200) COLLATE pg_catalog."default" NOT NULL,
    accessory_set_id integer,
    name text COLLATE pg_catalog."default" NOT NULL,
    price double precision NOT NULL,
    CONSTRAINT products_pkey PRIMARY KEY (id)
);
CREATE TABLE accessorysets
(
    id integer NOT NULL,
    fid integer NOT NULL,
    uid character varying(200) COLLATE pg_catalog."default" NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    price double precision NOT NULL,
    CONSTRAINT accessorysets_pkey PRIMARY KEY (id)
);
CREATE TABLE attributes
(
    id integer NOT NULL,
    fid integer NOT NULL,
    uid character varying(200) COLLATE pg_catalog."default" NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    price double precision NOT NULL,
    CONSTRAINT attributes_pkey PRIMARY KEY (id)
);
CREATE TABLE carts
(
    id integer NOT NULL,
    uid character varying(200) COLLATE pg_catalog."default" NOT NULL,
    user_id integer NOT NULL,
    store_id integer NOT NULL,
    contents text NOT NULL,
    price double precision NOT NULL,
    created_at character varying(200) COLLATE pg_catalog."default" NOT NULL,
    updated_at character varying(200) COLLATE pg_catalog."default" NOT NULL,
    deleted_at character varying(200) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT carts_pkey PRIMARY KEY (id)
);
CREATE TABLE store_users
(
    id integer NOT NULL,
    fid integer NOT NULL,
    uid character varying(200) COLLATE pg_catalog."default" NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    role integer NOT NULL,
    gender integer NOT NULL,
    store_id integer NOT NULL,
    customer_id integer NOT NULL,
    email character varying(200) COLLATE pg_catalog."default" NOT NULL,
    password character text,
    remember_token character varying(200) COLLATE pg_catalog."default" NOT NULL,
    initials character varying(200) COLLATE pg_catalog."default" NOT NULL,
    prefix character varying(200) COLLATE pg_catalog."default" NOT NULL,
    surname character varying(200) COLLATE pg_catalog."default" NOT NULL,
    phone_number character varying(200) COLLATE pg_catalog."default" NOT NULL,
    verified integer NOT NULL,
    verification_token character varying(200) COLLATE pg_catalog."default" NOT NULL,
    created_at character varying(200) COLLATE pg_catalog."default" NOT NULL,
    updated_at character varying(200) COLLATE pg_catalog."default" NOT NULL,
    deleted_at character varying(200) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT store_users_pkey PRIMARY KEY (id)
);
CREATE TABLE procurement_users
(
    id integer NOT NULL,
    fid integer NOT NULL,
    uid character varying(200) COLLATE pg_catalog."default" NOT NULL,
    name text COLLATE pg_catalog."default" NOT NULL,
    role integer NOT NULL,
    gender integer NOT NULL,
    store_id integer NOT NULL,
    customer_id integer NOT NULL,
    email character varying(200) COLLATE pg_catalog."default" NOT NULL,
    password character text,
    remember_token character varying(200) COLLATE pg_catalog."default" NOT NULL,
    initials character varying(200) COLLATE pg_catalog."default" NOT NULL,
    prefix character varying(200) COLLATE pg_catalog."default" NOT NULL,
    surname character varying(200) COLLATE pg_catalog."default" NOT NULL,
    phone_number character varying(200) COLLATE pg_catalog."default" NOT NULL,
    verified integer NOT NULL,
    verification_token character varying(200) COLLATE pg_catalog."default" NOT NULL,
    created_at character varying(200) COLLATE pg_catalog."default" NOT NULL,
    updated_at character varying(200) COLLATE pg_catalog."default" NOT NULL,
    deleted_at character varying(200) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT procurement_users_pkey PRIMARY KEY (id)
);
