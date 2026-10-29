--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6
-- Dumped by pg_dump version 16.6

-- Started on 2026-10-29 18:58:02

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
-- TOC entry 229 (class 1255 OID 49553)
-- Name: addProduct_updateCheck(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."addProduct_updateCheck"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF NEW.name IS NULL OR LENGTH(NEW.name) = 0 THEN
        RAISE EXCEPTION 'Il nome del prodotto non può essere vuoto';
    END IF;

    IF NEW.price <= 0 THEN
        RAISE EXCEPTION 'Il prezzo deve essere maggiore di 0';
    END IF;

    IF NEW.discount < 0 OR NEW.discount > 100 THEN
        RAISE EXCEPTION 'Lo sconto deve essere tra 0 e 100';
    END IF;

    IF NEW.stock < 0 THEN
        RAISE EXCEPTION 'Lo stock non può essere negativo';
    END IF;

    IF COALESCE(NEW.image_1, '') = '' AND COALESCE(NEW.image_2, '') = '' AND COALESCE(NEW.image_3, '') = '' THEN
        RAISE EXCEPTION 'Almeno un''immagine deve essere presente';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM brand WHERE id = NEW.brand_id) THEN
        RAISE EXCEPTION 'Il brand_id % non esiste', NEW.brand_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM category WHERE id = NEW.category_id) THEN
        RAISE EXCEPTION 'Il category_id % non esiste', NEW.category_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM register WHERE id = NEW.seller_id) THEN
        RAISE EXCEPTION 'Il seller_id % non esiste', NEW.seller_id;
    END IF;

    RETURN NEW;
END;

$$;


ALTER FUNCTION public."addProduct_updateCheck"() OWNER TO postgres;

--
-- TOC entry 244 (class 1255 OID 49554)
-- Name: addProduct_uploadCheck(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."addProduct_uploadCheck"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF NEW.name IS NULL OR LENGTH(NEW.name) = 0 THEN
        RAISE EXCEPTION 'Il nome del prodotto non può essere vuoto';
    END IF;

    IF NEW.price <= 0 THEN
        RAISE EXCEPTION 'Il prezzo deve essere maggiore di 0';
    END IF;

    IF NEW.discount < 0 OR NEW.discount > 100 THEN
        RAISE EXCEPTION 'Lo sconto deve essere tra 0 e 100';
    END IF;

    IF NEW.stock < 0 THEN
        RAISE EXCEPTION 'Lo stock non può essere negativo';
    END IF;

    IF COALESCE(NEW.image_1, '') = '' AND COALESCE(NEW.image_2, '') = '' AND COALESCE(NEW.image_3, '') = '' THEN
        RAISE EXCEPTION 'Almeno un''immagine deve essere presente';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM brand WHERE id = NEW.brand_id) THEN
        RAISE EXCEPTION 'Il brand_id % non esiste', NEW.brand_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM category WHERE id = NEW.category_id) THEN
        RAISE EXCEPTION 'Il category_id % non esiste', NEW.category_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM register WHERE id = NEW.seller_id) THEN
        RAISE EXCEPTION 'Il seller_id % non esiste', NEW.seller_id;
    END IF;

    RETURN NEW;
END;

$$;


ALTER FUNCTION public."addProduct_uploadCheck"() OWNER TO postgres;

--
-- TOC entry 245 (class 1255 OID 49555)
-- Name: brand_deleteCheck(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."brand_deleteCheck"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
IF EXISTS (SELECT 1 FROM addProduct WHERE brand_id = OLD.id) THEN
        RAISE EXCEPTION 'Impossibile eliminare il brand, ci sono prodotti associati';
    END IF;

    RETURN OLD;
END;$$;


ALTER FUNCTION public."brand_deleteCheck"() OWNER TO postgres;

--
-- TOC entry 246 (class 1255 OID 49556)
-- Name: brand_updateCheck(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."brand_updateCheck"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF NEW.name IS DISTINCT FROM OLD.name THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Non è permesso aggiornare altri campi, solo il nome del brand';
    END IF;
END;$$;


ALTER FUNCTION public."brand_updateCheck"() OWNER TO postgres;

--
-- TOC entry 247 (class 1255 OID 49557)
-- Name: brand_uploadCheck(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."brand_uploadCheck"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF NEW.name IS NULL OR LENGTH(NEW.name) = 0 THEN
        RAISE EXCEPTION 'Il nome del brand non può essere vuoto';
    END IF;

    IF EXISTS (SELECT 1 FROM brand WHERE name = NEW.name) THEN
        RAISE EXCEPTION 'Il brand "%" esiste già', NEW.name;
    END IF;

    RETURN NEW;
END;$$;


ALTER FUNCTION public."brand_uploadCheck"() OWNER TO postgres;

--
-- TOC entry 248 (class 1255 OID 49558)
-- Name: category_deleteCheck(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."category_deleteCheck"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF EXISTS (SELECT 1 FROM addProduct WHERE category_id = OLD.id) THEN
        RAISE EXCEPTION 'Impossibile eliminare la categoria, ci sono prodotti associati';
    END IF;

    RETURN OLD;
END;$$;


ALTER FUNCTION public."category_deleteCheck"() OWNER TO postgres;

--
-- TOC entry 249 (class 1255 OID 49559)
-- Name: category_updateCheck(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."category_updateCheck"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF NEW.name IS DISTINCT FROM OLD.name THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Non è permesso aggiornare altri campi, solo il nome della categoria';
    END IF;
END;$$;


ALTER FUNCTION public."category_updateCheck"() OWNER TO postgres;

--
-- TOC entry 250 (class 1255 OID 49560)
-- Name: category_uploadCheck(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."category_uploadCheck"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF NEW.name IS NULL OR LENGTH(NEW.name) = 0 THEN
        RAISE EXCEPTION 'Il nome della categoria non può essere vuoto';
    END IF;

    IF EXISTS (SELECT 1 FROM category WHERE name = NEW.name) THEN
        RAISE EXCEPTION 'La categoria "%" esiste già', NEW.name;
    END IF;

    RETURN NEW;
END;$$;


ALTER FUNCTION public."category_uploadCheck"() OWNER TO postgres;

--
-- TOC entry 251 (class 1255 OID 49561)
-- Name: notification_uploadCheck(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."notification_uploadCheck"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF NOT EXISTS (SELECT 1 FROM register WHERE id = NEW.customer_id) THEN
        RAISE EXCEPTION 'Il customer_id % non esiste', NEW.customer_id;
    END IF;

    IF NEW.text IS NULL OR LENGTH(NEW.text) < 5 THEN
        RAISE EXCEPTION 'Il testo della notifica deve avere almeno 5 caratteri';
    END IF;

    IF NEW.date_created > CURRENT_DATE THEN
        RAISE EXCEPTION 'La data di creazione non può essere nel futuro';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM customer_order WHERE invoice = NEW.order_invoice) THEN
        RAISE EXCEPTION 'L''ordine con fattura "%" non esiste', NEW.order_invoice;
    END IF;

    RETURN NEW;
END;$$;


ALTER FUNCTION public."notification_uploadCheck"() OWNER TO postgres;

--
-- TOC entry 252 (class 1255 OID 49562)
-- Name: order_deleteCheck(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."order_deleteCheck"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    DELETE FROM notification WHERE order_invoice = OLD.invoice;

    RETURN OLD;
END;$$;


ALTER FUNCTION public."order_deleteCheck"() OWNER TO postgres;

--
-- TOC entry 253 (class 1255 OID 49563)
-- Name: order_updateCheck(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."order_updateCheck"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF NEW.orders IS DISTINCT FROM OLD.orders THEN
        RETURN NEW;
    ELSE
        RAISE EXCEPTION 'Non è permesso aggiornare questo ordine su altri campi, solo il dizionario';
    END IF;
END;$$;


ALTER FUNCTION public."order_updateCheck"() OWNER TO postgres;

--
-- TOC entry 230 (class 1255 OID 49564)
-- Name: order_uploadCheck(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."order_uploadCheck"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF NEW.invoice IS NULL OR LENGTH(NEW.invoice) = 0 THEN
        RAISE EXCEPTION 'Il numero di fattura non può essere vuoto';
    END IF;

    IF EXISTS (SELECT 1 FROM customer_order WHERE invoice = NEW.invoice) THEN
        RAISE EXCEPTION 'Il numero di fattura "%" esiste già', NEW.invoice;
    END IF;


    IF NOT EXISTS (SELECT 1 FROM register WHERE id = NEW.customer_id) THEN
        RAISE EXCEPTION 'Il customer_id % non esiste', NEW.customer_id;
    END IF;

    IF NEW.date_created > CURRENT_DATE THEN
        RAISE EXCEPTION 'La data di creazione non può essere nel futuro';
    END IF;

    IF NEW.orders IS NULL OR LENGTH(NEW.orders) = 0 THEN
        RAISE EXCEPTION 'L''ordine non può essere vuoto';
    END IF;

    RETURN NEW;
END;$$;


ALTER FUNCTION public."order_uploadCheck"() OWNER TO postgres;

--
-- TOC entry 231 (class 1255 OID 49565)
-- Name: register_deleteCheck(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."register_deleteCheck"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
	DELETE FROM customer_order WHERE customer_id = OLD.id;

	DELETE FROM addproduct WHERE seller_id = OLD.id;
	
	DELETE FROM notification WHERE customer_id = OLD.id;
	
    RETURN OLD;
END;$$;


ALTER FUNCTION public."register_deleteCheck"() OWNER TO postgres;

--
-- TOC entry 232 (class 1255 OID 49566)
-- Name: register_updateCheck(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."register_updateCheck"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
    IF NEW.email IS DISTINCT FROM OLD.email THEN
        RAISE EXCEPTION 'Non è permesso aggiornare la email';
    ELSIF NEW.password IS DISTINCT FROM OLD.password THEN
        RAISE EXCEPTION 'Non è permesso aggiornare la password';
    END IF;

    RETURN NEW;
END;$$;


ALTER FUNCTION public."register_updateCheck"() OWNER TO postgres;

--
-- TOC entry 254 (class 1255 OID 49567)
-- Name: register_uploadCheck(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public."register_uploadCheck"() RETURNS trigger
    LANGUAGE plpgsql
    AS $_$BEGIN
    IF NEW.username IS NULL OR LENGTH(NEW.username) = 0 THEN
        RAISE EXCEPTION 'Il username non può essere vuoto';
    END IF;

    IF EXISTS (SELECT 1 FROM register WHERE username = NEW.username) THEN
        RAISE EXCEPTION 'Il username "%" esiste già', NEW.username;
    END IF;

    IF NEW.email IS NULL OR LENGTH(NEW.email) = 0 THEN
        RAISE EXCEPTION 'L''email non può essere vuota';
    END IF;

    IF NEW.email !~* '^[_A-Za-z0-9-]+(\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\.[A-Za-z0-9]+)*(\.[A-Za-z]{2,})$' THEN
        RAISE EXCEPTION 'L''email "%" non è valida', NEW.email;
    END IF;

    IF EXISTS (SELECT 1 FROM register WHERE email = NEW.email) THEN
        RAISE EXCEPTION 'L''email "%" esiste già', NEW.email;
    END IF;

    IF NEW.password IS NULL OR LENGTH(NEW.password) < 8 THEN
        RAISE EXCEPTION 'La password deve avere almeno 8 caratteri';
    END IF;

    IF NEW.date_created > CURRENT_DATE THEN
        RAISE EXCEPTION 'La data di creazione non può essere nel futuro';
    END IF;

    IF NEW.country IS NULL OR LENGTH(NEW.country) = 0 THEN
        RAISE EXCEPTION 'Il campo country non può essere vuoto';
    END IF;

    IF NEW.state IS NULL OR LENGTH(NEW.state) = 0 THEN
        RAISE EXCEPTION 'Il campo state non può essere vuoto';
    END IF;

    IF NEW.city IS NULL OR LENGTH(NEW.city) = 0 THEN
        RAISE EXCEPTION 'Il campo city non può essere vuoto';
    END IF;

    IF NEW.zipcode IS NULL OR LENGTH(NEW.zipcode) = 0 THEN
        RAISE EXCEPTION 'Il campo zipcode non può essere vuoto';
    END IF;

    IF NEW.address IS NULL OR LENGTH(NEW.address) = 0 THEN
        RAISE EXCEPTION 'Il campo address non può essere vuoto';
    END IF;

    IF NEW.seller IS NULL THEN
        RAISE EXCEPTION 'Il campo seller deve essere vero o falso';
    END IF;

    RETURN NEW;
END;
$_$;


ALTER FUNCTION public."register_uploadCheck"() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 215 (class 1259 OID 49568)
-- Name: addproduct; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.addproduct (
    id integer NOT NULL,
    name character varying(80) NOT NULL,
    price numeric(10,2) NOT NULL,
    discount integer DEFAULT 0,
    stock integer NOT NULL,
    colors text NOT NULL,
    description text NOT NULL,
    pub_date date NOT NULL,
    brand_id integer NOT NULL,
    category_id integer NOT NULL,
    image_1 character varying(150) NOT NULL,
    image_2 character varying(150) NOT NULL,
    image_3 character varying(150) NOT NULL,
    seller_id integer NOT NULL
);


ALTER TABLE public.addproduct OWNER TO postgres;

--
-- TOC entry 216 (class 1259 OID 49574)
-- Name: addproduct_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.addproduct ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.addproduct_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 217 (class 1259 OID 49575)
-- Name: brand; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.brand (
    id integer NOT NULL,
    name character varying(30) NOT NULL
);


ALTER TABLE public.brand OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 49578)
-- Name: brand_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.brand ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.brand_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 219 (class 1259 OID 49579)
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    id integer NOT NULL,
    name character varying(30) NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 49582)
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.category ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 221 (class 1259 OID 49583)
-- Name: customer_order; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer_order (
    id integer NOT NULL,
    invoice character varying(20) NOT NULL,
    customer_id integer NOT NULL,
    date_created date NOT NULL,
    orders text
);


ALTER TABLE public.customer_order OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 49588)
-- Name: customer_order_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.customer_order ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.customer_order_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 223 (class 1259 OID 49589)
-- Name: notification; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notification (
    id integer NOT NULL,
    customer_id integer NOT NULL,
    text character varying(200),
    date_created date NOT NULL,
    order_invoice character varying(20)
);


ALTER TABLE public.notification OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 49592)
-- Name: notification_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.notification ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.notification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 225 (class 1259 OID 49593)
-- Name: register; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.register (
    id integer NOT NULL,
    username character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    email character varying(50) NOT NULL,
    password character varying(200) NOT NULL,
    country character varying(50) NOT NULL,
    state character varying(50) NOT NULL,
    city character varying(50) NOT NULL,
    zipcode character varying(50) NOT NULL,
    address character varying(100) NOT NULL,
    contact character varying(50) NOT NULL,
    profile character varying(200),
    date_created date NOT NULL,
    seller boolean DEFAULT false NOT NULL
);


ALTER TABLE public.register OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 49599)
-- Name: register_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public.register ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.register_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 227 (class 1259 OID 49600)
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user" (
    id integer NOT NULL,
    name character varying(30) NOT NULL,
    username character varying(80) NOT NULL,
    email character varying(120) NOT NULL,
    password character varying(180) NOT NULL,
    profile character varying(150) NOT NULL
);


ALTER TABLE public."user" OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 49605)
-- Name: user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

ALTER TABLE public."user" ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- TOC entry 4915 (class 0 OID 49568)
-- Dependencies: 215
-- Data for Name: addproduct; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.addproduct (id, name, price, discount, stock, colors, description, pub_date, brand_id, category_id, image_1, image_2, image_3, seller_id) FROM stdin;
9	Laptop Example 3	99.99	80	4	Gray	Example 	2024-12-25	5	2	41ac5629d653f3e6053e.jpeg	5faff12d16523631e994.png	300dd9161cde4b0773ae.png	6
11	phone Example 2	3.05	0	41	Gray, Black	Example 	2024-12-25	1	1	aa45d249fd50f879b6a3.jpeg	563247fe0455717c200d.png	be4f7fa39b01858ea4ab.png	6
13	phone Example 4	30.00	13	3	Gray, Black	Example 	2024-12-25	2	1	55c2432f632d739bb610.jpeg	710e2feeb5440c404d67.png	44a6132810441614572e.png	6
12	phone Example 3	50.99	0	39	Gray, Black	Example 	2024-12-25	5	1	cf417a4760a53ee9dece.jpeg	f74d313e5569f2747c71.png	33d20a42e599d2282f2d.png	6
4	Tablet try	30.00	10	5	Gray	Example.....	2024-12-25	2	4	6865e484b69334a42f44.jpg	7e8dd21b4870692330ab.png	7e3d70626c2afaf9a16a.png	6
14	tablet Example 4	3.00	0	39	Gray	Example 	2024-12-25	5	4	b063e0d292c45b3c6578.jpeg	2de58d4cb7ff5272a74d.png	c5e1aec9658b570a3c6a.png	6
5	Tablet Example 1	33333.00	56	22	Black	Example 	2024-12-25	1	4	51f22d09e40f8c6c90f3.jpeg	4bca2d1d9bef58b1a4f2.png	357670b0a7b33965779a.png	6
6	Tablet Example 2	3334.00	0	220	Yellow	Example 	2024-12-25	5	4	3dbba0a160964ace984d.jpeg	93d288b93cd3a3328ea5.png	6b215ce418950aab9a34.png	6
15	Laptop Example 4	399.99	0	5	Gray	Example 	2024-12-25	1	2	675d0dc8bb841fd7def1.jpeg	220f6ac8d2cbfd2444cf.png	50cb56afdede1acedb0e.png	6
7	Laptop Example 1	23423.00	0	40	Yellow	Example 	2024-12-25	2	2	ef69bd5952fb0f151dac.jpeg	7f88115144ec77ac79b7.png	138cb3be49913bc2c05b.png	6
10	phone Example 1	99.99	80	40	Gray	Example 	2024-12-25	2	1	2ad582dc954a5a456845.jpeg	e8923a3f9260ff0fd63e.png	fe0d738af186a4432768.png	6
21	Orologio Bello	20.00	2	295	Grey, Gold	Orologio molto bello	2025-02-05	1	3	4f2316b25f3c0fb50251.jpg	d477a47a82f390b06814.jpg	a03bc4e41e7b04f52064.jpeg	6
8	Laptop Example 2.1	234.00	99	488	Red	Example 	2024-12-25	1	2	8b8cd01ce64eceacc11b.jpeg	6c15d6e44e5a72002613.jpeg	b5ead190a0191b98c42b.png	6
2	pc1	899.90	15	0	Mystic Silver, Golden	askdiasjdisdaifoasjdiohjnisah	2024-12-24	5	2	92476e1c61874f6b6597.png	8cb715d75df2f2cfdcfa.png	36c7d366ba3194642ca6.png	6
3	tab1	869.00	0	5	Graphite	\r\nMarchio\tSAMSUNG\r\nNome modello\tGalaxy Tab S9\r\nCapacità della memoria\t256 GB\r\nDimensioni schermo\t11 Pollici\r\nRisoluzione massima del display\t2560 x 1600 pixels\r\nSistema operativo\tAndroid\r\nColore\tBeige\r\nDimensioni memoria RAM\t256 GB\r\nGenerazione\t9\r\nCaratteristica speciale\tCapacità di memoria di storage elevata	2024-12-24	2	4	90ae708b64ed1055a136.jpg	60c7c5357e687b0632b5.jpg	634d271ead8b6e69e13f.jpg	6
18	Charger Laptop Honor	14.99	0	199	White, Black, Gray	Charger for laptop  64w	2024-12-31	5	3	f56131828d0ba76ac6fb.jpeg	a153209821b8549a7408.png	a3bc3583799baf047608.jpeg	14
\.


--
-- TOC entry 4917 (class 0 OID 49575)
-- Dependencies: 217
-- Data for Name: brand; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.brand (id, name) FROM stdin;
1	brand1
2	brand2
3	brand3
4	brand4
5	brand5
\.


--
-- TOC entry 4919 (class 0 OID 49579)
-- Dependencies: 219
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (id, name) FROM stdin;
2	Laptop
1	Phone
4	Tablet
3	Other
\.


--
-- TOC entry 4921 (class 0 OID 49583)
-- Dependencies: 221
-- Data for Name: customer_order; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.customer_order (id, invoice, customer_id, date_created, orders) FROM stdin;
7	9b384abed5	5	2025-02-03	{"6": {"color": "Yellow", "colors": "Yellow", "discount": 0, "image": "3dbba0a160964ace984d.jpeg", "name": "Tablet Example 2", "price": "3334.00", "quantity": 1, "status": "Pending"}}
6	a006f09fc4	5	2025-02-02	{"14": {"color": "Gray", "colors": "Gray", "discount": 0, "image": "b063e0d292c45b3c6578.jpeg", "name": "tablet Example 4", "price": "3.00", "quantity": 1, "status": "Shipped"}}
13	e5e0e9c5b2	29	2025-02-05	{"21": {"color": " Gold", "colors": "Grey, Gold", "discount": 2, "image": "4f2316b25f3c0fb50251.jpg", "name": "Orologio Bello", "price": "20.00", "quantity": "5", "status": "On Hold"}}
5	fffc72d66c	5	2025-02-02	{"3": {"color": "Graphite", "colors": "Graphite", "discount": 0, "image": "90ae708b64ed1055a136.jpg", "name": "tab1", "price": "869.00", "quantity": 2, "status": "Pending"}}
12	1099ade8be	28	2025-02-05	{"2": {"color": "Mystic Silver", "colors": "Mystic Silver, Golden", "discount": 15, "image": "92476e1c61874f6b6597.png", "name": "pc1", "price": "899.90", "quantity": "3", "status": "Completed"}}
\.


--
-- TOC entry 4923 (class 0 OID 49589)
-- Dependencies: 223
-- Data for Name: notification; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notification (id, customer_id, text, date_created, order_invoice) FROM stdin;
2	6	Someone ordered 1 tablet Example 4(id=14)	2025-02-02	a006f09fc4
3	5	The status of tablet Example 4(14)of the order 'a006f09fc4' has been updated by the seller to: On Hold	2025-02-02	a006f09fc4
6	6	Someone ordered 1 Tablet Example 2(id:6)	2025-02-03	9b384abed5
10	5	The status of tablet Example 4(14) of the order 'a006f09fc4' has been updated by the seller to: Shipped	2025-02-04	a006f09fc4
13	6	Someone ordered 5 Orologio Bello(id:21)	2025-02-05	e5e0e9c5b2
14	29	The status of Orologio Bello(21) of the order 'e5e0e9c5b2' has been updated by the seller to: On Hold	2025-02-05	e5e0e9c5b2
1	6	Someone ordered 2 tab1(id=3)	2025-02-02	fffc72d66c
11	6	Someone ordered 3 pc1(id:2)	2025-02-05	1099ade8be
12	28	The status of pc1(2) of the order '1099ade8be' has been updated by the seller to: Shipped	2025-02-05	1099ade8be
15	28	The status of pc1(2) of the order '1099ade8be' has been updated by the seller to: Completed	2025-02-05	1099ade8be
\.


--
-- TOC entry 4925 (class 0 OID 49593)
-- Dependencies: 225
-- Data for Name: register; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.register (id, username, name, email, password, country, state, city, zipcode, address, contact, profile, date_created, seller) FROM stdin;
7	adsdasd	sdasad	gg@email.com	$2b$12$msEfLRF6lF0Sks5dlf3Wpe2mJ6D9egDwljVbRUeOOjinFh.XClRI2	fsdsdf	sdfsdf	sfdsdf	321321	adsadklasdjdfjsiod	2312312323	profile.jpg	2024-12-30	f
8	gg	gg wp	wp@email.com	$2b$12$YnW0xlwhurM1W6BNjAKAde0SvsEY5HK5Vj.358LpCWyREWrco/MxS	sdajiosa	asdhuisa	sadjhsauid	32323	assoijiasuihd	178362173767	profile.jpg	2024-12-30	f
9	asdsad	sdsasad	pp@email.com	$2b$12$b8cqgwjKQCfDwrqbqv2FHuvZBMZ/M64E/5EoPAJQCgu9Qj/Puy7FW	fsdfsd	dfssdf	ssss	234234	dsafsdafsf	45354324343	profile.jpg	2024-12-30	f
10	wp@email.com	fwduihgyusdf	dd@email.com	$2b$12$XtJPh0g8phyxYxLuU6o.kumVstk3pbVf3KM/Od49utmr343wbsbf2	fgdfdwASFBF	DFSGDSF	errtre	34432	fgdbfdgsfgb	231453243543	profile.jpg	2024-12-30	f
11	sadasd	fdsg	ss@email.com	$2b$12$YolpAI3v3KeWS5RdG9M4OuGU1W4je3jbe0EOpRx8XdApEkUY49jlW	sdfghdfsg	sfdasfsd	dfghdfg	23456432	mndfsafghf	24356443266	profile.jpg	2024-12-30	f
12	hh	dfslkmsf	hh@email.com	$2b$12$tMxKftrNTqB8Ms3e7NNHYOOJtmY86ZkND5XhyYgyijBMM1necsFDu	wertewt	wertwq	ertyew	342567	ewrgfhjfweqrfgh	11232132133	profile.jpg	2024-12-30	f
13	bla	blabla	ff@email.com	$2b$12$LtvLDcdzJsmRkqw2oUbxM.w1uwazcVT0QrqnM9wV.ynahzw.WL2r.	gfdsfghdsf	uidfygvfd	fsdgsaDFG	3245321	fgrthyjthrefw	653647123123	b2b2733fe24d78883d01.jpeg	2024-12-30	f
26	username9	user9	user9@email.com	$2b$12$GJjdfWWf.SyRkWDqLiblzuGQcDKTqfH2j2L7BdWugmfvgpfx9A82i	qwertyui	eqwrtyu	qwewrtyu	32456	qwertyuitrew	324567	63bae57d7014586466f1.jpg	2025-02-04	f
5	SuperGiannone	Gianni cognome	gianni@email.com	$2b$12$ZUnbtEC4/HZirT4jluewVeEDZXdiKPRvTwcH64ZVZs704H5g3Qmae	Italia	Sicilia	Messina	06660	Via Grandiosa 100	66623232323	profile.jpg	2024-12-28	f
6	user6	nome nome	esempio@gmail.com	$2b$12$dlvVNXS5gul4w8bdT6D6nu3LSrXwcjB9ZNW.SVQD3AyvD143u6Zfm	Italia	regione	città	31021	Via blabla, 5	45454544533	782d7711ed11651f4d7d.jpeg	2024-12-30	t
14	user14	nome nomes	dario@email.com	$2b$12$JLvMghPKBPpjJw2sfDga4ORwgnRV3FEbZ0gFEwymKa/NKJ4zByP1y	Uganda	Knuckels	Checkers	30000	Via Dario, 56	3333333333	19ef4a3da1751b6c708a.jpeg	2024-12-31	t
28	user28	nome nome	okoki@email.com	$2b$12$d553aqK/50Do8tlK1HzGvOFBSZcmQNoT1RPDVdcJSwimtqEIJS7CK	italia	regione	città	31021	via nulla, 5	333333333	0035d3430999d7825d25.jpg	2025-02-05	f
29	user29	nome nome2	ok1@email.com	$2b$12$C0DXS0jG8FB/jggw.ErS5uDQxGzDn568IwHxTNt9WEi8pmSFoOADi	italiaa	regione	città	310212	via nulla, 5b	3454345654	217938511b182ad3fa09.jpeg	2025-02-05	f
\.


--
-- TOC entry 4927 (class 0 OID 49600)
-- Dependencies: 227
-- Data for Name: user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public."user" (id, name, username, email, password, profile) FROM stdin;
1	roberto	ggggggggg	gg@email.com	\\x243262243132246b78524941747472437a4a6f2f42766648412e785a4f507a717262722f4d6d57324d4f7a6134337638415859794e76744176596653	profile.jpg
2	Robbie Williams	robnick	rob@email.com	$2b$12$7mH1NdyGtRQtUDPmWBvqPeLy8YMi.HY0zx3.QLWHA40sM2.NLbqQi	profile.jpg
3	Nome Cognome	userStandard	mail@esempio.it	$2b$12$1GLYxt/338wj.167xT82FeIECmDg1gHZ26cW8N5ptbKymJf3qD4/.	profile.jpg
\.


--
-- TOC entry 4934 (class 0 OID 0)
-- Dependencies: 216
-- Name: addproduct_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.addproduct_id_seq', 22, true);


--
-- TOC entry 4935 (class 0 OID 0)
-- Dependencies: 218
-- Name: brand_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.brand_id_seq', 8, true);


--
-- TOC entry 4936 (class 0 OID 0)
-- Dependencies: 220
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_id_seq', 5, true);


--
-- TOC entry 4937 (class 0 OID 0)
-- Dependencies: 222
-- Name: customer_order_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.customer_order_id_seq', 13, true);


--
-- TOC entry 4938 (class 0 OID 0)
-- Dependencies: 224
-- Name: notification_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notification_id_seq', 15, true);


--
-- TOC entry 4939 (class 0 OID 0)
-- Dependencies: 226
-- Name: register_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.register_id_seq', 29, true);


--
-- TOC entry 4940 (class 0 OID 0)
-- Dependencies: 228
-- Name: user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_id_seq', 1, false);


--
-- TOC entry 4736 (class 2606 OID 49607)
-- Name: addproduct addproduct_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addproduct
    ADD CONSTRAINT addproduct_pkey PRIMARY KEY (id);


--
-- TOC entry 4738 (class 2606 OID 49609)
-- Name: brand brand_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.brand
    ADD CONSTRAINT brand_pkey PRIMARY KEY (id);


--
-- TOC entry 4740 (class 2606 OID 49611)
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- TOC entry 4742 (class 2606 OID 49613)
-- Name: customer_order customer_order_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_order
    ADD CONSTRAINT customer_order_pkey PRIMARY KEY (id);


--
-- TOC entry 4746 (class 2606 OID 49615)
-- Name: notification notification_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT notification_pkey PRIMARY KEY (id);


--
-- TOC entry 4744 (class 2606 OID 49617)
-- Name: customer_order order_invoice; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_order
    ADD CONSTRAINT order_invoice UNIQUE (invoice);


--
-- TOC entry 4748 (class 2606 OID 49619)
-- Name: register register_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.register
    ADD CONSTRAINT register_pkey PRIMARY KEY (id);


--
-- TOC entry 4750 (class 2606 OID 49621)
-- Name: user user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- TOC entry 4757 (class 2620 OID 49622)
-- Name: addproduct addProduct_updateCheck; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "addProduct_updateCheck" BEFORE UPDATE ON public.addproduct FOR EACH ROW EXECUTE FUNCTION public."addProduct_updateCheck"();


--
-- TOC entry 4758 (class 2620 OID 49623)
-- Name: addproduct addProduct_uploadCheck; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "addProduct_uploadCheck" BEFORE INSERT ON public.addproduct FOR EACH ROW EXECUTE FUNCTION public."addProduct_uploadCheck"();


--
-- TOC entry 4759 (class 2620 OID 49624)
-- Name: brand brand_deleteCheck; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "brand_deleteCheck" BEFORE DELETE ON public.brand FOR EACH ROW EXECUTE FUNCTION public."brand_deleteCheck"();


--
-- TOC entry 4760 (class 2620 OID 49625)
-- Name: brand brand_uploadCheck; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "brand_uploadCheck" BEFORE INSERT ON public.brand FOR EACH ROW EXECUTE FUNCTION public."brand_uploadCheck"();


--
-- TOC entry 4762 (class 2620 OID 49626)
-- Name: category category_deleteCheck; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "category_deleteCheck" BEFORE DELETE ON public.category FOR EACH ROW EXECUTE FUNCTION public."category_deleteCheck"();


--
-- TOC entry 4761 (class 2620 OID 49627)
-- Name: brand category_updateCheck; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "category_updateCheck" BEFORE UPDATE ON public.brand FOR EACH ROW EXECUTE FUNCTION public."category_updateCheck"();


--
-- TOC entry 4763 (class 2620 OID 49628)
-- Name: category category_updateCheck; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "category_updateCheck" BEFORE UPDATE ON public.category FOR EACH ROW EXECUTE FUNCTION public."brand_updateCheck"();


--
-- TOC entry 4764 (class 2620 OID 49629)
-- Name: category category_uploadCheck; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "category_uploadCheck" BEFORE INSERT ON public.category FOR EACH ROW EXECUTE FUNCTION public."category_uploadCheck"();


--
-- TOC entry 4768 (class 2620 OID 49630)
-- Name: notification notification_uploadCheck; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "notification_uploadCheck" BEFORE INSERT ON public.notification FOR EACH ROW EXECUTE FUNCTION public."notification_uploadCheck"();


--
-- TOC entry 4765 (class 2620 OID 49631)
-- Name: customer_order order_deleteCheck; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "order_deleteCheck" BEFORE DELETE ON public.customer_order FOR EACH ROW EXECUTE FUNCTION public."order_deleteCheck"();


--
-- TOC entry 4766 (class 2620 OID 49632)
-- Name: customer_order order_updateCheck; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "order_updateCheck" BEFORE UPDATE ON public.customer_order FOR EACH ROW EXECUTE FUNCTION public."order_updateCheck"();


--
-- TOC entry 4767 (class 2620 OID 49633)
-- Name: customer_order order_uploadCheck; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "order_uploadCheck" BEFORE INSERT ON public.customer_order FOR EACH ROW EXECUTE FUNCTION public."order_uploadCheck"();


--
-- TOC entry 4769 (class 2620 OID 49634)
-- Name: register register_deleteCheck; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "register_deleteCheck" BEFORE DELETE ON public.register FOR EACH ROW EXECUTE FUNCTION public."register_deleteCheck"();


--
-- TOC entry 4770 (class 2620 OID 49635)
-- Name: register register_updateCheck; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "register_updateCheck" BEFORE UPDATE ON public.register FOR EACH ROW EXECUTE FUNCTION public."register_updateCheck"();


--
-- TOC entry 4771 (class 2620 OID 49636)
-- Name: register register_uploadCheck; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "register_uploadCheck" BEFORE INSERT ON public.register FOR EACH ROW EXECUTE FUNCTION public."register_uploadCheck"();


--
-- TOC entry 4754 (class 2606 OID 49637)
-- Name: customer_order customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer_order
    ADD CONSTRAINT customer_id FOREIGN KEY (customer_id) REFERENCES public.register(id);


--
-- TOC entry 4755 (class 2606 OID 49642)
-- Name: notification customer_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT customer_id FOREIGN KEY (customer_id) REFERENCES public.register(id);


--
-- TOC entry 4751 (class 2606 OID 49647)
-- Name: addproduct id brand; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addproduct
    ADD CONSTRAINT "id brand" FOREIGN KEY (brand_id) REFERENCES public.brand(id);


--
-- TOC entry 4752 (class 2606 OID 49652)
-- Name: addproduct id category; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addproduct
    ADD CONSTRAINT "id category" FOREIGN KEY (category_id) REFERENCES public.category(id);


--
-- TOC entry 4753 (class 2606 OID 49657)
-- Name: addproduct id seller; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.addproduct
    ADD CONSTRAINT "id seller" FOREIGN KEY (seller_id) REFERENCES public.register(id) NOT VALID;


--
-- TOC entry 4756 (class 2606 OID 49662)
-- Name: notification order_invoice; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notification
    ADD CONSTRAINT order_invoice FOREIGN KEY (order_invoice) REFERENCES public.customer_order(invoice) NOT VALID;


-- Completed on 2026-10-29 18:58:03

--
-- PostgreSQL database dump complete
--

