--
-- PostgreSQL database dump
--

\restrict ViG3mQe6y7QghmmmrcQhZDur19vmpPbnF7ZAgdBZiwjOo9Q5GtS7OaEYz537KTr

-- Dumped from database version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: loanstatus; Type: TYPE; Schema: public; Owner: -
--

CREATE TYPE public.loanstatus AS ENUM (
    'ACTIVE',
    'RETURNED',
    'OVERDUE'
);


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


--
-- Name: book_categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.book_categories (
    id bigint NOT NULL,
    book_id bigint NOT NULL,
    category_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: books; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.books (
    id bigint NOT NULL,
    title character varying NOT NULL,
    author character varying NOT NULL,
    isbn character varying NOT NULL,
    pages integer NOT NULL,
    published_year integer NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    stock integer NOT NULL,
    description character varying,
    language character varying(2) NOT NULL,
    publisher character varying
);


--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.books_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- Name: categories; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.categories (
    id bigint NOT NULL,
    name character varying NOT NULL,
    description character varying,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.categories_id_seq OWNED BY public.categories.id;


--
-- Name: loans; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.loans (
    id bigint NOT NULL,
    loan_dt date NOT NULL,
    return_dt date,
    user_id bigint NOT NULL,
    book_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    due_dt date NOT NULL,
    fine_amount numeric(10,2),
    status public.loanstatus DEFAULT 'ACTIVE'::public.loanstatus NOT NULL
);


--
-- Name: loans_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.loans_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: loans_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.loans_id_seq OWNED BY public.loans.id;


--
-- Name: reviews; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.reviews (
    id bigint NOT NULL,
    rating integer NOT NULL,
    comment character varying NOT NULL,
    review_dt date NOT NULL,
    user_id bigint NOT NULL,
    book_id bigint NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL
);


--
-- Name: reviews_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.reviews_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reviews_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.reviews_id_seq OWNED BY public.reviews.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    username character varying NOT NULL,
    fullname character varying NOT NULL,
    password character varying NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    email character varying NOT NULL,
    phone character varying,
    address character varying,
    is_active boolean NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: books id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- Name: categories id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories ALTER COLUMN id SET DEFAULT nextval('public.categories_id_seq'::regclass);


--
-- Name: loans id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loans ALTER COLUMN id SET DEFAULT nextval('public.loans_id_seq'::regclass);


--
-- Name: reviews id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews ALTER COLUMN id SET DEFAULT nextval('public.reviews_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.alembic_version (version_num) FROM stdin;
3f73e53da4a3
\.


--
-- Data for Name: book_categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.book_categories (id, book_id, category_id, created_at, updated_at) FROM stdin;
1	1	5	2025-12-03 21:18:07.966012-03	2025-12-03 21:18:07.966012-03
2	2	1	2025-12-03 21:18:07.966012-03	2025-12-03 21:18:07.966012-03
3	5	1	2025-12-03 21:18:07.966012-03	2025-12-03 21:18:07.966012-03
4	8	1	2025-12-03 21:18:07.966012-03	2025-12-03 21:18:07.966012-03
5	9	1	2025-12-03 21:18:07.966012-03	2025-12-03 21:18:07.966012-03
6	3	3	2025-12-03 21:18:07.966012-03	2025-12-03 21:18:07.966012-03
7	10	3	2025-12-03 21:18:07.966012-03	2025-12-03 21:18:07.966012-03
8	6	3	2025-12-03 21:18:07.966012-03	2025-12-03 21:18:07.966012-03
9	4	4	2025-12-03 21:18:07.966012-03	2025-12-03 21:18:07.966012-03
10	7	1	2025-12-03 21:18:07.966012-03	2025-12-03 21:18:07.966012-03
\.


--
-- Data for Name: books; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.books (id, title, author, isbn, pages, published_year, created_at, updated_at, stock, description, language, publisher) FROM stdin;
1	El Señor de los Anillos	J.R.R. Tolkien	ISBN-BD2-2025-0001	1200	1954	2025-12-03 21:18:07.964757-03	2025-12-03 21:18:07.964757-03	5	Un viaje épico	ES	Minotauro
2	Cien Años de Soledad	Gabriel García Márquez	ISBN-BD2-2025-0002	450	1967	2025-12-03 21:18:07.964757-03	2025-12-03 21:18:07.964757-03	3	Realismo mágico en Macondo	ES	Sudamericana
3	Breve Historia del Tiempo	Stephen Hawking	ISBN-BD2-2025-0003	250	1988	2025-12-03 21:18:07.964757-03	2025-12-03 21:18:07.964757-03	4	Cosmología para todos	ES	Crítica
4	Sapiens	Yuval Noah Harari	ISBN-BD2-2025-0004	500	2011	2025-12-03 21:18:07.964757-03	2025-12-03 21:18:07.964757-03	10	Historia de la humanidad	ES	Debate
5	El Código Da Vinci	Dan Brown	ISBN-BD2-2025-0005	600	2003	2025-12-03 21:18:07.964757-03	2025-12-03 21:18:07.964757-03	2	Misterio religioso	ES	Umbriel
6	Clean Code	Robert C. Martin	ISBN-BD2-2025-0006	464	2008	2025-12-03 21:18:07.964757-03	2025-12-03 21:18:07.964757-03	6	Manual de estilo de código	EN	Prentice Hall
7	Dune	Frank Herbert	ISBN-BD2-2025-0007	700	1965	2025-12-03 21:18:07.964757-03	2025-12-03 21:18:07.964757-03	3	Ciencia ficción política	ES	Nova
8	1984	George Orwell	ISBN-BD2-2025-0008	300	1949	2025-12-03 21:18:07.964757-03	2025-12-03 21:18:07.964757-03	8	Distopía totalitaria	ES	Austral
9	Don Quijote	Miguel de Cervantes	ISBN-BD2-2025-0009	1000	1605	2025-12-03 21:18:07.964757-03	2025-12-03 21:18:07.964757-03	1	Caballero andante	ES	RAE
10	Cosmos	Carl Sagan	ISBN-BD2-2025-0010	380	1980	2025-12-03 21:18:07.964757-03	2025-12-03 21:18:07.964757-03	5	El universo y nosotros	ES	Planeta
\.


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.categories (id, name, description, created_at, updated_at) FROM stdin;
1	Ficción	Obras literarias basadas en hechos imaginarios	2025-12-03 21:18:07.962392-03	2025-12-03 21:18:07.962392-03
2	No Ficción	Obras basadas en hechos reales y datos	2025-12-03 21:18:07.962392-03	2025-12-03 21:18:07.962392-03
3	Ciencia	Libros científicos y divulgativos	2025-12-03 21:18:07.962392-03	2025-12-03 21:18:07.962392-03
4	Historia	Relatos y análisis de eventos pasados	2025-12-03 21:18:07.962392-03	2025-12-03 21:18:07.962392-03
5	Fantasía	Elementos sobrenaturales y mundos mágicos	2025-12-03 21:18:07.962392-03	2025-12-03 21:18:07.962392-03
\.


--
-- Data for Name: loans; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.loans (id, loan_dt, return_dt, user_id, book_id, created_at, updated_at, due_dt, fine_amount, status) FROM stdin;
1	2024-01-01	2024-01-10	2	1	2025-12-03 21:18:07.967832-03	2025-12-03 21:18:07.967832-03	2024-01-15	0.00	RETURNED
2	2024-02-01	2024-02-14	3	2	2025-12-03 21:18:07.967832-03	2025-12-03 21:18:07.967832-03	2024-02-15	0.00	RETURNED
3	2025-12-03	\N	4	3	2025-12-03 21:18:07.967832-03	2025-12-03 21:18:07.967832-03	2025-12-17	0.00	ACTIVE
4	2025-12-03	\N	5	4	2025-12-03 21:18:07.967832-03	2025-12-03 21:18:07.967832-03	2025-12-17	0.00	ACTIVE
5	2023-12-01	\N	2	5	2025-12-03 21:18:07.967832-03	2025-12-03 21:18:07.967832-03	2023-12-15	5.50	OVERDUE
6	2023-11-01	\N	3	6	2025-12-03 21:18:07.967832-03	2025-12-03 21:18:07.967832-03	2023-11-15	10.00	OVERDUE
7	2023-10-01	2023-10-20	4	7	2025-12-03 21:18:07.967832-03	2025-12-03 21:18:07.967832-03	2023-10-15	2.50	RETURNED
8	2025-12-03	\N	5	8	2025-12-03 21:18:07.967832-03	2025-12-03 21:18:07.967832-03	2025-12-17	0.00	ACTIVE
\.


--
-- Data for Name: reviews; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.reviews (id, rating, comment, review_dt, user_id, book_id, created_at, updated_at) FROM stdin;
1	5	Obra maestra absoluta.	2025-12-03	2	1	2025-12-03 21:18:07.970719-03	2025-12-03 21:18:07.970719-03
2	4	Un poco largo pero excelente.	2025-12-03	3	1	2025-12-03 21:18:07.970719-03	2025-12-03 21:18:07.970719-03
3	5	Me encantó Macondo.	2025-12-03	4	2	2025-12-03 21:18:07.970719-03	2025-12-03 21:18:07.970719-03
4	3	Muy complejo para mí.	2025-12-03	5	3	2025-12-03 21:18:07.970719-03	2025-12-03 21:18:07.970719-03
5	5	Cambió mi forma de ver el mundo.	2025-12-03	2	4	2025-12-03 21:18:07.970719-03	2025-12-03 21:18:07.970719-03
6	2	Pura ficción barata.	2025-12-03	3	5	2025-12-03 21:18:07.970719-03	2025-12-03 21:18:07.970719-03
7	5	Todo programador debe leerlo.	2025-12-03	4	6	2025-12-03 21:18:07.970719-03	2025-12-03 21:18:07.970719-03
8	4	La especia debe fluir.	2025-12-03	5	7	2025-12-03 21:18:07.970719-03	2025-12-03 21:18:07.970719-03
9	5	Aterradoramente real.	2025-12-03	2	8	2025-12-03 21:18:07.970719-03	2025-12-03 21:18:07.970719-03
10	1	No entendí el castellano antiguo.	2025-12-03	3	9	2025-12-03 21:18:07.970719-03	2025-12-03 21:18:07.970719-03
11	5	Carl Sagan es un poeta.	2025-12-03	4	10	2025-12-03 21:18:07.970719-03	2025-12-03 21:18:07.970719-03
12	5	Lo volvería a leer.	2025-12-03	5	1	2025-12-03 21:18:07.970719-03	2025-12-03 21:18:07.970719-03
13	4	Un clásico.	2025-12-03	2	2	2025-12-03 21:18:07.970719-03	2025-12-03 21:18:07.970719-03
14	4	Interesante.	2025-12-03	3	3	2025-12-03 21:18:07.970719-03	2025-12-03 21:18:07.970719-03
15	5	Imprescindible.	2025-12-03	4	4	2025-12-03 21:18:07.970719-03	2025-12-03 21:18:07.970719-03
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.users (id, username, fullname, password, created_at, updated_at, email, phone, address, is_active) FROM stdin;
1	admin	Administrador General	$argon2id$v=19$m=65536,t=3,p=4$nVdB9dzfPHH3J4K1NAJfqA$kf7wb7fxca/koCRAbON5xMI6O9e9rtVhPp8KJzt95NA	2025-12-03 21:18:07.963607-03	2025-12-03 21:18:07.963607-03	admin@biblio.com	111-111-111	Calle Admin 1	t
2	juan	Juan Pérez	$argon2id$v=19$m=65536,t=3,p=4$nVdB9dzfPHH3J4K1NAJfqA$kf7wb7fxca/koCRAbON5xMI6O9e9rtVhPp8KJzt95NA	2025-12-03 21:18:07.963607-03	2025-12-03 21:18:07.963607-03	juan@email.com	222-222-222	Av. Siempre Viva 123	t
3	maria	María González	$argon2id$v=19$m=65536,t=3,p=4$nVdB9dzfPHH3J4K1NAJfqA$kf7wb7fxca/koCRAbON5xMI6O9e9rtVhPp8KJzt95NA	2025-12-03 21:18:07.963607-03	2025-12-03 21:18:07.963607-03	maria@email.com	333-333-333	Calle Luna 45	t
4	pedro	Pedro Pascal	$argon2id$v=19$m=65536,t=3,p=4$nVdB9dzfPHH3J4K1NAJfqA$kf7wb7fxca/koCRAbON5xMI6O9e9rtVhPp8KJzt95NA	2025-12-03 21:18:07.963607-03	2025-12-03 21:18:07.963607-03	pedro@email.com	444-444-444	Ruta 66	t
5	ana	Ana Frank	$argon2id$v=19$m=65536,t=3,p=4$nVdB9dzfPHH3J4K1NAJfqA$kf7wb7fxca/koCRAbON5xMI6O9e9rtVhPp8KJzt95NA	2025-12-03 21:18:07.963607-03	2025-12-03 21:18:07.963607-03	ana@email.com	555-555-555	Amsterdam 202	t
\.


--
-- Name: books_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.books_id_seq', 10, true);


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.categories_id_seq', 5, true);


--
-- Name: loans_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.loans_id_seq', 8, true);


--
-- Name: reviews_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.reviews_id_seq', 15, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: book_categories pk_book_categories; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_categories
    ADD CONSTRAINT pk_book_categories PRIMARY KEY (id, book_id, category_id);


--
-- Name: books pk_books; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT pk_books PRIMARY KEY (id);


--
-- Name: categories pk_categories; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT pk_categories PRIMARY KEY (id);


--
-- Name: loans pk_loans; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT pk_loans PRIMARY KEY (id);


--
-- Name: reviews pk_reviews; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT pk_reviews PRIMARY KEY (id);


--
-- Name: users pk_users; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT pk_users PRIMARY KEY (id);


--
-- Name: books uq_books_isbn; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT uq_books_isbn UNIQUE (isbn);


--
-- Name: books uq_books_title; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT uq_books_title UNIQUE (title);


--
-- Name: categories uq_categories_name; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.categories
    ADD CONSTRAINT uq_categories_name UNIQUE (name);


--
-- Name: users uq_users_email; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uq_users_email UNIQUE (email);


--
-- Name: users uq_users_username; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT uq_users_username UNIQUE (username);


--
-- Name: book_categories fk_book_categories_book_id_books; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_categories
    ADD CONSTRAINT fk_book_categories_book_id_books FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- Name: book_categories fk_book_categories_category_id_categories; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.book_categories
    ADD CONSTRAINT fk_book_categories_category_id_categories FOREIGN KEY (category_id) REFERENCES public.categories(id);


--
-- Name: loans fk_loans_book_id_books; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT fk_loans_book_id_books FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- Name: loans fk_loans_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT fk_loans_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- Name: reviews fk_reviews_book_id_books; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_reviews_book_id_books FOREIGN KEY (book_id) REFERENCES public.books(id);


--
-- Name: reviews fk_reviews_user_id_users; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.reviews
    ADD CONSTRAINT fk_reviews_user_id_users FOREIGN KEY (user_id) REFERENCES public.users(id);


--
-- PostgreSQL database dump complete
--

\unrestrict ViG3mQe6y7QghmmmrcQhZDur19vmpPbnF7ZAgdBZiwjOo9Q5GtS7OaEYz537KTr

