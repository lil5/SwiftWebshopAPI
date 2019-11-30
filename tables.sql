
CREATE TABLE public.products
(
    id integer NOT NULL,
    fid integer NOT NULL,
    uid character varying(200) COLLATE pg_catalog."default" NOT NULL,
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

