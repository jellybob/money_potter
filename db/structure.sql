SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: monthly_budgets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.monthly_budgets (
    id bigint NOT NULL,
    pot_id bigint,
    month date NOT NULL,
    amount_pence integer DEFAULT 0 NOT NULL,
    amount_currency character varying DEFAULT 'GBP'::character varying NOT NULL,
    payments_total_pence integer DEFAULT 0 NOT NULL,
    payments_total_currency character varying DEFAULT 'GBP'::character varying NOT NULL
);


--
-- Name: monthly_budgets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.monthly_budgets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: monthly_budgets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.monthly_budgets_id_seq OWNED BY public.monthly_budgets.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id bigint NOT NULL,
    amount_pence integer DEFAULT 0 NOT NULL,
    amount_currency character varying DEFAULT 'GBP'::character varying NOT NULL,
    tags character varying[] DEFAULT '{}'::character varying[],
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    monthly_budget_id bigint
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: pots; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.pots (
    id bigint NOT NULL,
    name character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    budget_pence integer DEFAULT 0 NOT NULL,
    budget_currency character varying DEFAULT 'GBP'::character varying NOT NULL,
    payments_total_pence integer DEFAULT 0 NOT NULL,
    payments_total_currency character varying DEFAULT 'GBP'::character varying NOT NULL,
    CONSTRAINT pots_budget_pence_numericality CHECK ((budget_pence >= 0)),
    CONSTRAINT pots_name_presence CHECK (((name IS NOT NULL) AND ((name)::text !~ '^\s*$'::text)))
);


--
-- Name: pots_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.pots_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: pots_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.pots_id_seq OWNED BY public.pots.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: monthly_budgets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monthly_budgets ALTER COLUMN id SET DEFAULT nextval('public.monthly_budgets_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: pots id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pots ALTER COLUMN id SET DEFAULT nextval('public.pots_id_seq'::regclass);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: monthly_budgets monthly_budgets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monthly_budgets
    ADD CONSTRAINT monthly_budgets_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: pots pots_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.pots
    ADD CONSTRAINT pots_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: index_monthly_budgets_on_pot_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_monthly_budgets_on_pot_id ON public.monthly_budgets USING btree (pot_id);


--
-- Name: monthly_budgets fk_rails_db7ff72b74; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.monthly_budgets
    ADD CONSTRAINT fk_rails_db7ff72b74 FOREIGN KEY (pot_id) REFERENCES public.pots(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20180713165959'),
('20180714091600'),
('20180715120323'),
('20180715211307'),
('20180806062357'),
('20180806170008');


