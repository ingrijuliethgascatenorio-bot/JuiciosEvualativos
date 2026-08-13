--
-- PostgreSQL database dump
--

\restrict ThXiZGa5qw1BiUcn3A4qWc0j14Yo5GY9chv9ryowVYobOypkX6Yc9GbELaRkw7N

-- Dumped from database version 16.10
-- Dumped by pg_dump version 16.10

-- Started on 2026-08-13 14:42:52

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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 235 (class 1259 OID 42206)
-- Name: actividad_competencias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actividad_competencias (
    id integer NOT NULL,
    id_actividad integer NOT NULL,
    codigo_comp integer NOT NULL
);


ALTER TABLE public.actividad_competencias OWNER TO postgres;

--
-- TOC entry 234 (class 1259 OID 42205)
-- Name: actividad_competencias_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.actividad_competencias_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.actividad_competencias_id_seq OWNER TO postgres;

--
-- TOC entry 5065 (class 0 OID 0)
-- Dependencies: 234
-- Name: actividad_competencias_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.actividad_competencias_id_seq OWNED BY public.actividad_competencias.id;


--
-- TOC entry 233 (class 1259 OID 42187)
-- Name: actividad_resultados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actividad_resultados (
    id integer NOT NULL,
    id_actividad integer NOT NULL,
    codigo_resul integer NOT NULL
);


ALTER TABLE public.actividad_resultados OWNER TO postgres;

--
-- TOC entry 232 (class 1259 OID 42186)
-- Name: actividad_resultados_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.actividad_resultados_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.actividad_resultados_id_seq OWNER TO postgres;

--
-- TOC entry 5066 (class 0 OID 0)
-- Dependencies: 232
-- Name: actividad_resultados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.actividad_resultados_id_seq OWNED BY public.actividad_resultados.id;


--
-- TOC entry 231 (class 1259 OID 42172)
-- Name: actividades_fase; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.actividades_fase (
    id_actividad integer NOT NULL,
    id_fase integer NOT NULL,
    nombre_actividad character varying(200) NOT NULL,
    descripcion text,
    orden integer DEFAULT 1 NOT NULL
);


ALTER TABLE public.actividades_fase OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 42171)
-- Name: actividades_fase_id_actividad_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.actividades_fase_id_actividad_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.actividades_fase_id_actividad_seq OWNER TO postgres;

--
-- TOC entry 5067 (class 0 OID 0)
-- Dependencies: 230
-- Name: actividades_fase_id_actividad_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.actividades_fase_id_actividad_seq OWNED BY public.actividades_fase.id_actividad;


--
-- TOC entry 239 (class 1259 OID 50402)
-- Name: alertas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alertas (
    id_alerta integer NOT NULL,
    tipo character varying(50) NOT NULL,
    nivel character varying(20) NOT NULL,
    descripcion text NOT NULL,
    numero_documento character varying(20),
    codigo_competencia integer,
    fecha_generada timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    estado character varying(20) DEFAULT 'ACTIVA'::character varying
);


ALTER TABLE public.alertas OWNER TO postgres;

--
-- TOC entry 238 (class 1259 OID 50401)
-- Name: alertas_id_alerta_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alertas_id_alerta_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alertas_id_alerta_seq OWNER TO postgres;

--
-- TOC entry 5068 (class 0 OID 0)
-- Dependencies: 238
-- Name: alertas_id_alerta_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alertas_id_alerta_seq OWNED BY public.alertas.id_alerta;


--
-- TOC entry 219 (class 1259 OID 34060)
-- Name: aprendices; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.aprendices (
    numero_documento character varying(20) NOT NULL,
    tipo_documento character varying(20),
    nombres character varying(80),
    apellidos character varying(80),
    id_estado integer NOT NULL,
    numero_ficha integer NOT NULL,
    nivel_riesgo character varying(20)
);


ALTER TABLE public.aprendices OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 34075)
-- Name: competencias; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.competencias (
    codigo_comp integer NOT NULL,
    nombre_comp character varying(250) NOT NULL,
    codigo_programa integer NOT NULL,
    color_semaforo character varying(10)
);


ALTER TABLE public.competencias OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 34164)
-- Name: competencias_fases; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.competencias_fases (
    codigo_comp integer NOT NULL,
    id_fase integer
);


ALTER TABLE public.competencias_fases OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 50413)
-- Name: dashboard_config; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.dashboard_config (
    id integer NOT NULL,
    riesgo_bajo_max integer DEFAULT 0,
    riesgo_medio_max integer DEFAULT 5,
    riesgo_alto_min integer DEFAULT 6,
    verde_min numeric(5,2) DEFAULT 80,
    amarillo_min numeric(5,2) DEFAULT 50
);


ALTER TABLE public.dashboard_config OWNER TO postgres;

--
-- TOC entry 240 (class 1259 OID 50412)
-- Name: dashboard_config_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.dashboard_config_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.dashboard_config_id_seq OWNER TO postgres;

--
-- TOC entry 5069 (class 0 OID 0)
-- Dependencies: 240
-- Name: dashboard_config_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.dashboard_config_id_seq OWNED BY public.dashboard_config.id;


--
-- TOC entry 218 (class 1259 OID 34052)
-- Name: estados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.estados (
    id_estado integer NOT NULL,
    nombre character varying(50) NOT NULL
);


ALTER TABLE public.estados OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 34051)
-- Name: estados_id_estado_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.estados_id_estado_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.estados_id_estado_seq OWNER TO postgres;

--
-- TOC entry 5070 (class 0 OID 0)
-- Dependencies: 217
-- Name: estados_id_estado_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.estados_id_estado_seq OWNED BY public.estados.id_estado;


--
-- TOC entry 228 (class 1259 OID 34156)
-- Name: fases_proyecto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fases_proyecto (
    id_fase integer NOT NULL,
    nombre_fase character varying(100) NOT NULL
);


ALTER TABLE public.fases_proyecto OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 34155)
-- Name: fases_proyecto_id_fase_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fases_proyecto_id_fase_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.fases_proyecto_id_fase_seq OWNER TO postgres;

--
-- TOC entry 5071 (class 0 OID 0)
-- Dependencies: 227
-- Name: fases_proyecto_id_fase_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fases_proyecto_id_fase_seq OWNED BY public.fases_proyecto.id_fase;


--
-- TOC entry 216 (class 1259 OID 34041)
-- Name: fichas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fichas (
    numero_ficha integer NOT NULL,
    codigo_programa integer NOT NULL,
    fecha_inicio date,
    fecha_fin date,
    estado_ficha character varying(50),
    porcentaje_avance numeric(5,2),
    porcentaje_aprobacion numeric(5,2)
);


ALTER TABLE public.fichas OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 50394)
-- Name: historial_indicadores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.historial_indicadores (
    id integer NOT NULL,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    aprendices_activos integer,
    juicios_aprobados integer,
    juicios_pendientes integer,
    total_aprendices integer,
    total_aprobados integer,
    total_pendientes integer,
    porcentaje_aprobacion numeric(5,2),
    porcentaje_avance numeric(5,2)
);


ALTER TABLE public.historial_indicadores OWNER TO postgres;

--
-- TOC entry 236 (class 1259 OID 50393)
-- Name: historial_indicadores_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.historial_indicadores_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.historial_indicadores_id_seq OWNER TO postgres;

--
-- TOC entry 5072 (class 0 OID 0)
-- Dependencies: 236
-- Name: historial_indicadores_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.historial_indicadores_id_seq OWNED BY public.historial_indicadores.id;


--
-- TOC entry 222 (class 1259 OID 34095)
-- Name: instructores; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.instructores (
    num_documento character varying(20) NOT NULL,
    nombres_apellidos character varying(150) NOT NULL,
    cargo character varying(100)
);


ALTER TABLE public.instructores OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 34101)
-- Name: juicios_catalogo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.juicios_catalogo (
    id_juicio_cat integer NOT NULL,
    descripcion character varying(50) NOT NULL
);


ALTER TABLE public.juicios_catalogo OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 34100)
-- Name: juicios_catalogo_id_juicio_cat_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.juicios_catalogo_id_juicio_cat_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.juicios_catalogo_id_juicio_cat_seq OWNER TO postgres;

--
-- TOC entry 5073 (class 0 OID 0)
-- Dependencies: 223
-- Name: juicios_catalogo_id_juicio_cat_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.juicios_catalogo_id_juicio_cat_seq OWNED BY public.juicios_catalogo.id_juicio_cat;


--
-- TOC entry 226 (class 1259 OID 34110)
-- Name: matricula_resultados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.matricula_resultados (
    id integer NOT NULL,
    num_documento_aprendiz character varying(20) NOT NULL,
    codigo_resul integer NOT NULL,
    id_juicio_cat integer NOT NULL,
    num_documento_instructor character varying(20) NOT NULL,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE public.matricula_resultados OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 34109)
-- Name: matricula_resultados_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.matricula_resultados_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.matricula_resultados_id_seq OWNER TO postgres;

--
-- TOC entry 5074 (class 0 OID 0)
-- Dependencies: 225
-- Name: matricula_resultados_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.matricula_resultados_id_seq OWNED BY public.matricula_resultados.id;


--
-- TOC entry 215 (class 1259 OID 34036)
-- Name: programas; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.programas (
    codigo_programa integer NOT NULL,
    nombre_programa character varying(150) NOT NULL,
    version character varying(10),
    modalidad character varying(50)
);


ALTER TABLE public.programas OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 34085)
-- Name: resultados; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.resultados (
    codigo_resul integer NOT NULL,
    nombre_resultado character varying(350) NOT NULL,
    codigo_comp integer NOT NULL
);


ALTER TABLE public.resultados OWNER TO postgres;

--
-- TOC entry 4816 (class 2604 OID 42209)
-- Name: actividad_competencias id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_competencias ALTER COLUMN id SET DEFAULT nextval('public.actividad_competencias_id_seq'::regclass);


--
-- TOC entry 4815 (class 2604 OID 42190)
-- Name: actividad_resultados id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_resultados ALTER COLUMN id SET DEFAULT nextval('public.actividad_resultados_id_seq'::regclass);


--
-- TOC entry 4813 (class 2604 OID 42175)
-- Name: actividades_fase id_actividad; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividades_fase ALTER COLUMN id_actividad SET DEFAULT nextval('public.actividades_fase_id_actividad_seq'::regclass);


--
-- TOC entry 4819 (class 2604 OID 50405)
-- Name: alertas id_alerta; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertas ALTER COLUMN id_alerta SET DEFAULT nextval('public.alertas_id_alerta_seq'::regclass);


--
-- TOC entry 4822 (class 2604 OID 50416)
-- Name: dashboard_config id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_config ALTER COLUMN id SET DEFAULT nextval('public.dashboard_config_id_seq'::regclass);


--
-- TOC entry 4808 (class 2604 OID 34055)
-- Name: estados id_estado; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estados ALTER COLUMN id_estado SET DEFAULT nextval('public.estados_id_estado_seq'::regclass);


--
-- TOC entry 4812 (class 2604 OID 34159)
-- Name: fases_proyecto id_fase; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fases_proyecto ALTER COLUMN id_fase SET DEFAULT nextval('public.fases_proyecto_id_fase_seq'::regclass);


--
-- TOC entry 4817 (class 2604 OID 50397)
-- Name: historial_indicadores id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_indicadores ALTER COLUMN id SET DEFAULT nextval('public.historial_indicadores_id_seq'::regclass);


--
-- TOC entry 4809 (class 2604 OID 34104)
-- Name: juicios_catalogo id_juicio_cat; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.juicios_catalogo ALTER COLUMN id_juicio_cat SET DEFAULT nextval('public.juicios_catalogo_id_juicio_cat_seq'::regclass);


--
-- TOC entry 4810 (class 2604 OID 34113)
-- Name: matricula_resultados id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matricula_resultados ALTER COLUMN id SET DEFAULT nextval('public.matricula_resultados_id_seq'::regclass);


--
-- TOC entry 5053 (class 0 OID 42206)
-- Dependencies: 235
-- Data for Name: actividad_competencias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actividad_competencias (id, id_actividad, codigo_comp) FROM stdin;
\.


--
-- TOC entry 5051 (class 0 OID 42187)
-- Dependencies: 233
-- Data for Name: actividad_resultados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actividad_resultados (id, id_actividad, codigo_resul) FROM stdin;
\.


--
-- TOC entry 5049 (class 0 OID 42172)
-- Dependencies: 231
-- Data for Name: actividades_fase; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.actividades_fase (id_actividad, id_fase, nombre_actividad, descripcion, orden) FROM stdin;
\.


--
-- TOC entry 5057 (class 0 OID 50402)
-- Dependencies: 239
-- Data for Name: alertas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alertas (id_alerta, tipo, nivel, descripcion, numero_documento, codigo_competencia, fecha_generada, estado) FROM stdin;
\.


--
-- TOC entry 5037 (class 0 OID 34060)
-- Dependencies: 219
-- Data for Name: aprendices; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.aprendices (numero_documento, tipo_documento, nombres, apellidos, id_estado, numero_ficha, nivel_riesgo) FROM stdin;
1001046982	CC	NICOL VALENTINA	MAHECHA BORDA	1	2773160	\N
1006419673	CC	BRAYAN STIVEN	HOYOS CESPEDES	2	3142784	\N
1006506936	CC	YULIZATH FERNANDA	CAICEDO GUTIERREZ	1	2773160	\N
1006508766	CC	IBSEN ALEXIS	SOTO ARTUNDUAGA	1	3142784	\N
1006513246	CC	JHON STIVEN	ESCOBAR HENAO	2	2773160	\N
1006508852	CC	CRISTIAN	CANTILLO MEJIA	1	3142784	\N
1006523628	CC	JUAN FELIPE	OBANDO ANTURI	1	2773160	\N
1006458870	CC	JHONNIER	DIAZ PERDOMO	1	3389756	\N
1006526763	CC	MAGDA LORENA	TRIVIÑO SARRIAS	1	2773160	\N
1006510328	CC	DANIEL FELIPE	VERA PERDOMO	1	3142784	\N
1006505845	CC	HARRINSON DE JESUS	MEJIA ECHEVERRY	1	3389756	\N
1006526827	CC	KENIER ALEXANDER	GONZALEZ MENDEZ	1	2773160	\N
1080361991	CC	JUAN SEBASTIAN	CARVAJAL HOME	1	3142784	\N
1006531207	CC	YARLEN YULENY	CARVAJAL HERNANDEZ	1	2773160	\N
1034660100	CC	ANGIE JULIETH	MONTOYA CONDE	1	3389756	\N
1006537604	CC	ANDREA XIMENA	COLLAZOS SANTANILLA	1	2773160	\N
1084331945	CC	ANDRES JULIAN	CRUZ HERNANDEZ	1	3142784	\N
1117500686	CC	YENIFER YERALDIN	SANCHEZ CONO	1	3389756	\N
1006539028	CC	KHAREN JULIANA	ZUÑIGA QUEVEDO	1	2773160	\N
1088255893	CC	BRAYAN STEVEN	VELASQUEZ ROA	1	3142784	\N
1117503976	CC	JHON KEVIN	GARCIA OLAYA	1	3389756	\N
1006632144	CC	MICHELL DANIELA	LUGO ORTIZ	1	2773160	\N
1115942896	CC	YEFRY	SERNA PUENTES	2	3142784	\N
1010183747	CC	MAYKER FABIAN	ORTEGA VERTEL	1	2773160	\N
1117547740	CC	KEVIN DANIEL	SALDAÑA SOGAMOSO	1	3389756	\N
1012317177	CC	LIZETH ESTEFANIA	OROZCO RAMIREZ	1	2773160	\N
1116204178	CC	PAULA DANIELA	CUELLAR RONDON	2	3142784	\N
1117549322	CC	PAULA ANDREA	GIRALDO ASCENCIO	1	3389756	\N
1061728211	TI	VANESA	MUÑOZ MELLIZO	1	2773160	\N
1116205722	CC	INGRI JULIETH	GASCA TENORIO	1	3142784	\N
1116202192	CC	LUZ VANESA	VARGAS PIMENTEL	1	2773160	\N
1117931523	TI	DAYANA	RAMIREZ ANDRADE	1	3389756	\N
1117484194	CC	YOHIS NATALIA	CONDE MORENO	1	2773160	\N
1117497987	CC	ESTEFANY	CUELLAR ANTURI	2	3142784	\N
1118363507	CC	JULIAN	CALAMBAS TROCHEZ	1	3389756	\N
1117487072	CC	KAREN DAYANA	USAQUEN GOMEZ	1	2773160	\N
1117506583	TI	JUAN CARLOS	BALTAZAR GUEVARA	2	3142784	\N
1118364581	CC	YUDERLY STEFANNIA	SANTA HURTADO	1	3389756	\N
1117492748	CC	KAREN JULIETH	PERDOMO DUARTE	1	2773160	\N
1117511568	CC	JHOAN STEVEN	ZAMBRANO VERA	1	3142784	\N
1117495913	TI	LAURA SOFIA	MONTEALEGRE PERDOMO	1	2773160	\N
1118367796	TI	ANNYEL STEVEN	LASTRA BELTRAN	1	3389756	\N
1117497251	CC	JAIDER ANDRES	SUAREZ QUINTERO	1	2773160	\N
1117513057	TI	YESSICA YULIETH	JARAMILLO HERRAN	1	3142784	\N
1118369645	TI	LISS ALEJANDRA	GALLEGO SÁNCHEZ	1	3389756	\N
1117529946	CC	ERIKA FERNANDA	VALENCIA CHAUX	1	2773160	\N
1117784339	CC	JHONATAN	CASTRO CALDERON	1	3142784	\N
1117545642	CC	YINA YULIETH	VIDAL GOMEZ	1	2773160	\N
1119212359	CC	ANDREA	ALBINO LOZANO	1	3389756	\N
1117545890	CC	ANA MILENA	CARVAJAL ANTURI	1	2773160	\N
1117811948	CC	EMERSON	CORREDOR MURCIA	1	3142784	\N
1119582126	CC	MAIRA CAROLINA	ANACONA CERQUERA	1	3389756	\N
1117816905	CC	DANIELA	PRADA LUJAN	1	2773160	\N
1118364706	CC	PATRICK DAMIAN	ORTIZ HERNANDEZ	1	3142784	\N
1118362482	CC	JUAN DAVID	RAMIREZ BERMEO	1	2773160	\N
1138924034	CC	VICTOR ANDRES	CAMACHO RIVERA	1	3389756	\N
1118367954	CC	GUSTAVO ADOLFO	CABRERA VANEGAS	1	3142784	\N
1118364127	CC	ANDRY YULIETH	CHAVARRO MUÑOZ	1	2773160	\N
1143324526	CC	JUAN DIEGO	RUZ PINEDA	2	3389756	\N
1118364195	TI	HOLMAN STIVEN	ORDOÑEZ VARGAS	1	2773160	\N
1118367962	TI	SANTIAGO	LIZCANO SUAREZ	1	3142784	\N
17653772	CC	JONH JAIRO	LOZANO BURGOS	1	3389756	\N
1118366385	TI	JHEREMIT YULBRAINER	CRUZ MORA	1	2773160	\N
1118368446	TI	JUAN DAVID	TRUJILLO NARANJO	1	3142784	\N
1119580993	TI	BRAYAN STIVEN	CUERO ALMARIO	2	2773160	\N
1051065897	CC	LUIS ESTEBAN	MORALES GASCA	1	3142784	\N
1137624175	CC	MARFRILLEYSURY	MOLINA MARIN	1	2773160	\N
1099742508	TI	JORGE ALEJANDRO	PEÑA MOTTA	1	3142784	\N
1115944629	CC	EDWARD FARLEY	RUIZ GUTIERREZ	1	2995479	\N
40611465	CC	LUZ NERY	VEGA ORTIZ	1	2773160	\N
1117496648	CC	MANUEL ANDRES	CARDENAS SUAREZ	1	3142784	\N
55161891	CC	LIBIA	PRECIADO TOVAR	1	2773160	\N
1117512328	CC	YULEINY	LUGO QUIMBAYO	1	3142784	\N
1004417452	CC	MARIA CAMILA	GUEVARA RAMIREZ	1	2995479	\N
1117931191	CC	SAHIRA MIRLETH	VARGAS SANCHEZ	1	3142784	\N
1118368430	TI	ISABELLA	LOPERA AYALA	1	3142784	\N
1006524033	CC	ANA SOFIA	RAMIREZ MEZA	2	2995479	\N
1118471378	TI	LEIDER FABIAN	RAMOS CANO	1	3142784	\N
1118471476	TI	JAIBER JULIAN	GUTIERREZ RIVERA	1	3142784	\N
1006524148	CC	JULIAN	CALDERON SALINAS	1	2995479	\N
1120498200	CC	ANGGIE MARCELA	OLMOS BERNAL	2	3142784	\N
1032499166	CC	DAVID FELIPE	RAMOS JOVEL	1	2995479	\N
1122726863	TI	WILLIAM SANTIAGO	BARRERO ROMERO	1	3142784	\N
1076502079	CC	ANDRES CAMILO	QUINTERO OCAMPO	1	2995479	\N
1130268455	CC	MARY JANES	ROMERO RIVAS	4	3142784	\N
1110583373	CC	LINA ALEXANDRA	GONZALEZ CUELLAR	1	2995479	\N
1116914600	CC	JOSE ANGEL	RODRIGUEZ CAMARA	1	2995479	\N
1117263160	CC	EDIER STIVEN	MARROQUIN VALENCIA	1	2995479	\N
1117263444	CC	LURAINE FRANDELLY	CANO MUÑOZ	1	2995479	\N
1117494319	CC	JUSTIN STIVEN	LINCH TRUJILLO	1	2995479	\N
1117498592	CC	CARLOS MARIO	POLANIA BALLEN	1	2995479	\N
1117499559	CC	WILFER	ORTIZ DUARTE	1	2995479	\N
1117500474	TI	MIGUEL STIVEN	CORTES DUARTE	1	2995479	\N
1117500652	CC	HEIDY DANIELA	VARGAS HIGUERA	1	2995479	\N
1117501573	CC	WILDER SANTIAGO	RESTREPO ALAPE	1	2995479	\N
1117502399	TI	BRAYAN CAMILO	PEREZ BRAVO	1	2995479	\N
1117502612	TI	JEISON STIVEN	AVILA VARON	1	2995479	\N
1117505020	TI	CRISTIAN SNEIDER	RAMIREZ MOTTA	1	2995479	\N
1117510789	TI	MICKE ALEJANDRO	LLANOS ALVAREZ	1	2995479	\N
1117811629	CC	JANNER	GONZALEZ HERRERA	1	2995479	\N
1118024401	TI	JHORMAN ALEXIS	HAYA ASENCIO	1	2995479	\N
1118364908	CC	WEIMAR	HOYOS OCAÑA	1	2995479	\N
1118366378	TI	BRAYAN ANDRES	HERNANDEZ ORTIZ	1	2995479	\N
\.


--
-- TOC entry 5038 (class 0 OID 34075)
-- Dependencies: 220
-- Data for Name: competencias; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.competencias (codigo_comp, nombre_comp, codigo_programa, color_semaforo) FROM stdin;
2	RESULTADOS DE APRENDIZAJE ETAPA PRACTICA	533321774	\N
36180	Enrique Low Murtra-Interactuar en el contexto productivo y social de acuerdo con principios  éticos para la construcción de una cultura de paz.	533321774	\N
36182	Resultado de Aprendizaje de la Inducción.	533321774	\N
37371	Utilizar herramientas informáticas de acuerdo con las necesidades de manejo de información	533321774	\N
37714	INTERACTUAR EN LENGUA INGLESA DE FORMA ORAL Y ESCRITA DENTRO DE CONTEXTOS SOCIALES Y LABORALES SEGÚN LOS CRITERIOS ESTABLECIDOS POR EL MARCO COMÚN EUROPEO DE REFERENCIA PARA LAS LENGUAS.	533321774	\N
37799	APLICAR PRÁCTICAS  DE PROTECCIÓN AMBIENTAL, SEGURIDAD Y SALUD EN EL TRABAJO DE ACUERDO CON LAS POLÍTICAS ORGANIZACIONALES  Y LA NORMATIVIDAD VIGENTE.	533321774	\N
37800	GENERAR HÁBITOS SALUDABLES DE VIDA MEDIANTE LA APLICACIÓN DE PROGRAMAS DE ACTIVIDAD FÍSICA EN LOS CONTEXTOS PRODUCTIVOS Y SOCIALES.	533321774	\N
37801	APLICACIÓN DE CONOCIMIENTOS DE LAS CIENCIAS NATURALES DE ACUERDO CON SITUACIONES DEL CONTEXTO PRODUCTIVO Y SOCIAL.	533321774	\N
37802	DESARROLLAR PROCESOS DE COMUNICACIÓN EFICACES Y EFECTIVOS, TENIENDO EN CUENTA SITUACIONES  DE ORDEN SOCIAL, PERSONAL Y PRODUCTIVO.	533321774	\N
38199	Orientar investigación formativa según referentes técnicos	533321774	\N
38356	Implementar la solución de software de acuerdo con los requisitos de operación y modelos de referencia	533321774	\N
38362	Diseñar la solución de software de acuerdo con procedimientos y requisitos técnicos	533321774	\N
38367	Estructurar propuesta técnica de servicio de tecnología de la información según requisitos técnicos y normativa	533321774	\N
38368	DESARROLLAR LA SOLUCIÓN DE SOFTWARE DE ACUERDO CON EL DISEÑO Y METODOLOGÍAS DE DESARROLLO	533321774	\N
38369	Controlar la calidad del servicio de software de acuerdo con los estándares técnicos	533321774	\N
38376	Evaluar requisitos de la solución de software de acuerdo con metodologías de análisis y estándares	533321774	\N
38392	Establecer requisitos de la solución de software de acuerdo con estándares y procedimiento técnico	533321774	\N
38558	Ejercer derechos fundamentales del trabajo en el marco de la constitución política y los convenios internacionales.	533321774	\N
38560	Razonar cuantitativamente frente a situaciones susceptibles de ser abordadas de manera matemática en contextos laborales, sociales y personales.	533321774	\N
38561	Gestionar procesos propios de la cultura emprendedora y empresarial de acuerdo con el perfil personal y los requerimientos de los contextos productivo y social.	533321774	\N
1	PROMOVER LA INTERACCIÓN IDÓNEA CONSIGO MISMO, CON LOS DEMÁS Y CON LA NATURALEZA EN LOS CONTEXTOS LABORAL Y SOCIAL	1477859297	\N
2855	CONTABILIZAR LOS RECURSOS DE OPERACIÓN, INVERSIÓN Y FINANCIACIÓN DE ACUERDO CON LAS NORMAS Y POLÍTICAS ORGANIZACIONALES	1477859297	\N
2856	PREPARAR Y PRESENTAR LA INFORMACIÓN CONTABLE Y FINANCIERA SEGÚN NORMAS LEGALES Y POLÍTICAS ORGANIZACIONALES	1477859297	\N
2863	ESTABLECER LAS DESVIACIONES DE LA PROGRAMACIÓN FRENTE A LA EJECUCIÓN DEL PLAN FINANCIERO.	1477859297	\N
2864	ANALIZAR LOS RESULTADOS CONTABLES Y FINANCIEROS SEGÚN LOS CRITERIOS DE EVALUACIÓN ESTABLECIDOS POR LA ORGANIZACIÓN	1477859297	\N
2865	VALIDAR LA APLICACIÓN DE LAS FASES Y PROCEDIMIENTOS DE CONTROL INTERNO DE LA GESTIÓN FINANCIERA DE ACUERDO CON POLÍTICAS ORGANIZACIONALES.	1477859297	\N
2872	DEFINIR OBJETIVOS FINANCIEROS DE ACUERDO CON POLÍTICAS ORGANIZACIONALES.	1477859297	\N
2873	DETERMINAR LOS RECURSOS FINANCIEROS DE ACUERDO CON EL PLAN DE ACCIÓN DE LA ORGANIZACIÓN	1477859297	\N
2874	RECOMENDAR LOS AJUSTES A LOS PROCEDIMIENTOS TENIENDO EN CUENTA LA NORMATIVIDAD VIGENTE Y LAS POLÍTICAS ORGANIZACIONALES.	1477859297	\N
2875	ESTABLECER EL POSICIONAMIENTO DE LA ORGANIZACIÓN FRENTE A LA COMPETENCIA SEGÚN POLÍTICA ORGANIZACIONAL.	1477859297	\N
2879	DISTRIBUIR LOS VALORES RECAUDADOS, LOS RECURSOS DE OPERACIÓN, INVERSIÓN Y FINANCIACIÓN DE ACUERDO CON EL PLAN FINANCIERO.	1477859297	\N
3226	COMPRENDER TEXTOS EN INGLÉS EN FORMA ESCRITA Y AUDITIVA	1477859297	\N
3227	PRODUCIR TEXTOS EN INGLÉS EN FORMA ESCRITA Y ORAL	1477859297	\N
37888	Reconocer recursos financieros de acuerdo con metodología y normativa	1292512061	\N
38415	Elaborar documentos de acuerdo con normas técnicas	1292512061	\N
38426	Atender clientes de acuerdo con procedimiento de servicio y normativa	1292512061	\N
39031	TRAMITAR CORRESPONDENCIA DE ACUERDO CON PROCESOS TÉCNICOS Y NORMATIVA	1292512061	\N
39811	Fomentar cultura emprendedora según habilidades y competencias personales	1292512061	\N
39939	Registrar información de acuerdo con normativa y procedimiento técnico	1292512061	\N
\.


--
-- TOC entry 5047 (class 0 OID 34164)
-- Dependencies: 229
-- Data for Name: competencias_fases; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.competencias_fases (codigo_comp, id_fase) FROM stdin;
\.


--
-- TOC entry 5059 (class 0 OID 50413)
-- Dependencies: 241
-- Data for Name: dashboard_config; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.dashboard_config (id, riesgo_bajo_max, riesgo_medio_max, riesgo_alto_min, verde_min, amarillo_min) FROM stdin;
\.


--
-- TOC entry 5036 (class 0 OID 34052)
-- Dependencies: 218
-- Data for Name: estados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.estados (id_estado, nombre) FROM stdin;
1	EN FORMACIÓN
2	RETIRO VOLUNTARIO
3	CANCELADO
4	TRASLADADO
5	APLAZADO
\.


--
-- TOC entry 5046 (class 0 OID 34156)
-- Dependencies: 228
-- Data for Name: fases_proyecto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fases_proyecto (id_fase, nombre_fase) FROM stdin;
1	Análisis
2	Planeación
3	Ejecución
4	Evaluación
\.


--
-- TOC entry 5034 (class 0 OID 34041)
-- Dependencies: 216
-- Data for Name: fichas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.fichas (numero_ficha, codigo_programa, fecha_inicio, fecha_fin, estado_ficha, porcentaje_avance, porcentaje_aprobacion) FROM stdin;
3142784	533321774	\N	\N	ACTIVA	\N	\N
3389756	1477859297	\N	\N	ACTIVA	\N	\N
2773160	1292512061	\N	\N	ACTIVA	\N	\N
2995479	533321774	\N	\N	ACTIVA	\N	\N
\.


--
-- TOC entry 5055 (class 0 OID 50394)
-- Dependencies: 237
-- Data for Name: historial_indicadores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.historial_indicadores (id, fecha_registro, aprendices_activos, juicios_aprobados, juicios_pendientes, total_aprendices, total_aprobados, total_pendientes, porcentaje_aprobacion, porcentaje_avance) FROM stdin;
\.


--
-- TOC entry 5040 (class 0 OID 34095)
-- Dependencies: 222
-- Data for Name: instructores; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.instructores (num_documento, nombres_apellidos, cargo) FROM stdin;
000000000	-	Instructor
1117523028	OSCAR CAMILO CASTRO MOPAN	Instructor
6801798	EDWIN ALEXANDER OSPINA PENNA	Instructor
1117546314	DIEGO ALEJANDRO PEÑA ROJAS	Instructor
17654594	JORGE ANDRES GIRALDO POSADA	Instructor
17648908	JUAN CARLOS YUSTRES CHAUX	Instructor
96353963	PABLO ANDRES MENESES MAYORAL	Instructor
40781077	YOLDI CLARITZA VASQUEZ CLAROS	Instructor
26632272	DOLLY ROCIO PARRA ESCOBAR	Instructor
1117499177	YOINER GARCIA FIGUEROA	Instructor
40776309	ANA CECILIA UMAÑA ESPAÑA	Instructor
1117515166	DIOSELINA CHAVARRO VALLEJO	Instructor
6801355	OSCAR EDUARDO YANGUAS ARGUELLO	Instructor
40778471	NORMA PIEDAD RIVERA PEÑA	Instructor
17653145	JAVIER LEONARDO MOTTA GIRALDO	Instructor
96328076	JOSE JAIBER DIAZ CASTRO	Instructor
17652688	WILLIAM DIAZ MONTAÑEZ	Instructor
17656065	EDWIN GUSTAVO DUSSAN MALAGON	Instructor
40758842	AYDA INES GOMEZ REYES	Instructor
1117532250	ANGEL IVAN DIAZ GONZALEZ	Instructor
28555809	LEIDI MILENA SANTAMARIA PEREZ	Instructor
6805131	JORGE ALBERTO ARIZA CABALLERO	Instructor
1026552707	JUAN PAULO HERMOSA CRUZ	Instructor
1077865671	JOSSYE ESTEBAN CALDERON LOSADA	Instructor
1117503960	CRISTIAN JAVIER CUBILLOS MARTINEZ	Instructor
1117507159	TATIANA MARCELA RAMIREZ SALAZAR	Instructor
17656565	MARIO DANIEL CARDOSO CORDOBA	Instructor
1098809645	NICOLÁS ALBERTO HERNÁNDEZ DURÁN	Instructor
\.


--
-- TOC entry 5042 (class 0 OID 34101)
-- Dependencies: 224
-- Data for Name: juicios_catalogo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.juicios_catalogo (id_juicio_cat, descripcion) FROM stdin;
1	APROBADO
2	POR EVALUAR
3	NO APROBADO
\.


--
-- TOC entry 5044 (class 0 OID 34110)
-- Dependencies: 226
-- Data for Name: matricula_resultados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.matricula_resultados (id, num_documento_aprendiz, codigo_resul, id_juicio_cat, num_documento_instructor, fecha_registro) FROM stdin;
1	1006419673	590803	2	000000000	2026-04-30 19:07:38
2	1006419673	593147	2	000000000	2026-04-30 19:07:38
3	1006419673	593148	2	000000000	2026-04-30 19:07:38
4	1006419673	593149	2	000000000	2026-04-30 19:07:38
5	1006419673	593150	2	000000000	2026-04-30 19:07:38
8	1006419673	593152	2	000000000	2026-04-30 19:07:38
6336	1001046982	595100	2	000000000	2026-05-06 19:40:46
6337	1001046982	595133	1	26632272	2026-05-06 19:40:46
6338	1001046982	595134	1	26632272	2026-05-06 19:40:46
6339	1001046982	595135	1	26632272	2026-05-06 19:40:46
6340	1001046982	595136	1	26632272	2026-05-06 19:40:46
6341	1001046982	595105	1	28555809	2026-05-06 19:40:46
6342	1001046982	595137	1	96353963	2026-05-06 19:40:46
6343	1001046982	595138	1	96353963	2026-05-06 19:40:46
6344	1001046982	595139	1	96353963	2026-05-06 19:40:46
6345	1001046982	595140	1	96353963	2026-05-06 19:40:46
6346	1001046982	595163	1	6805131	2026-05-06 19:40:46
6347	1001046982	595164	1	6805131	2026-05-06 19:40:46
6348	1001046982	595165	1	6805131	2026-05-06 19:40:46
6349	1001046982	595166	1	6805131	2026-05-06 19:40:46
6350	1001046982	595167	1	6805131	2026-05-06 19:40:46
6351	1001046982	595168	1	6805131	2026-05-06 19:40:46
6352	1001046982	595101	1	40776309	2026-05-06 19:40:46
6353	1001046982	595102	1	1026552707	2026-05-06 19:40:46
6354	1001046982	595103	1	40776309	2026-05-06 19:40:46
6355	1001046982	595104	1	1026552707	2026-05-06 19:40:46
6356	1001046982	595149	1	96328076	2026-05-06 19:40:46
6357	1001046982	595150	1	96328076	2026-05-06 19:40:46
6358	1001046982	595151	1	96328076	2026-05-06 19:40:46
6359	1001046982	595152	1	96328076	2026-05-06 19:40:46
6360	1001046982	595141	2	000000000	2026-05-06 19:40:46
6361	1001046982	595142	2	000000000	2026-05-06 19:40:46
9	1006419673	593153	2	000000000	2026-04-30 19:07:38
6362	1001046982	595143	2	000000000	2026-05-06 19:40:46
6363	1001046982	595144	2	000000000	2026-05-06 19:40:46
6364	1001046982	595158	2	000000000	2026-05-06 19:40:46
6365	1001046982	595159	2	000000000	2026-05-06 19:40:46
6366	1001046982	595160	2	000000000	2026-05-06 19:40:46
6367	1001046982	595161	2	000000000	2026-05-06 19:40:46
6368	1001046982	595162	2	000000000	2026-05-06 19:40:46
6369	1001046982	595106	1	28555809	2026-05-06 19:40:46
6370	1001046982	595107	1	28555809	2026-05-06 19:40:46
6371	1001046982	595108	1	28555809	2026-05-06 19:40:46
11	1006419673	593113	2	000000000	2026-04-30 19:07:38
6372	1001046982	595109	1	28555809	2026-05-06 19:40:46
6373	1001046982	595110	1	28555809	2026-05-06 19:40:46
6374	1001046982	595125	1	28555809	2026-05-06 19:40:46
6375	1001046982	595126	1	28555809	2026-05-06 19:40:46
6376	1001046982	595127	1	28555809	2026-05-06 19:40:46
6377	1001046982	595128	1	28555809	2026-05-06 19:40:46
6378	1001046982	595129	1	28555809	2026-05-06 19:40:47
12	1006419673	593114	2	000000000	2026-04-30 19:07:38
13	1006419673	593115	2	000000000	2026-04-30 19:07:38
14	1006419673	593116	2	000000000	2026-04-30 19:07:38
15	1006419673	593117	1	1117546314	2025-06-21 10:06:00
16	1006419673	593118	2	000000000	2026-04-30 19:07:38
17	1006419673	593155	2	000000000	2026-04-30 19:07:38
6379	1001046982	595130	1	28555809	2026-05-06 19:40:47
6380	1001046982	595131	1	28555809	2026-05-06 19:40:47
18	1006419673	593156	2	000000000	2026-04-30 19:07:38
6381	1001046982	595132	1	28555809	2026-05-06 19:40:47
6382	1001046982	595117	2	000000000	2026-05-06 19:40:47
19	1006419673	593157	2	000000000	2026-04-30 19:07:38
6383	1001046982	595118	2	000000000	2026-05-06 19:40:47
20	1006419673	593158	1	17654594	2025-06-02 19:06:00
21	1006419673	593119	2	000000000	2026-04-30 19:07:38
6384	1001046982	595119	1	1077865671	2026-05-06 19:40:47
22	1006419673	593120	1	17648908	2025-04-24 12:04:00
6385	1001046982	595120	1	1077865671	2026-05-06 19:40:47
23	1006419673	593121	2	000000000	2026-04-30 19:07:38
24	1006419673	593122	2	000000000	2026-04-30 19:07:38
25	1006419673	593159	2	000000000	2026-04-30 19:07:38
26	1006419673	593160	2	000000000	2026-04-30 19:07:38
27	1006419673	593161	2	000000000	2026-04-30 19:07:38
6386	1001046982	595145	1	1117503960	2026-05-06 19:40:47
6387	1001046982	595146	1	1117503960	2026-05-06 19:40:47
6388	1001046982	595147	1	1117503960	2026-05-06 19:40:47
6389	1001046982	595148	1	1117503960	2026-05-06 19:40:47
28	1006419673	593162	2	000000000	2026-04-30 19:07:38
29	1006419673	593224	2	000000000	2026-04-30 19:07:38
30	1006419673	593225	2	000000000	2026-04-30 19:07:38
31	1006419673	593226	2	000000000	2026-04-30 19:07:38
6390	1001046982	595111	1	28555809	2026-05-06 19:40:47
6391	1001046982	595112	1	28555809	2026-05-06 19:40:47
6392	1001046982	595113	1	28555809	2026-05-06 19:40:47
6393	1001046982	595114	1	28555809	2026-05-06 19:40:47
6394	1001046982	595115	1	28555809	2026-05-06 19:40:47
6395	1001046982	595116	1	28555809	2026-05-06 19:40:47
6396	1001046982	644275	1	28555809	2026-05-06 19:40:47
6397	1001046982	644276	1	28555809	2026-05-06 19:40:47
6398	1001046982	644277	1	28555809	2026-05-06 19:40:47
6399	1001046982	644278	1	28555809	2026-05-06 19:40:47
6400	1001046982	644279	1	6801355	2026-05-06 19:40:47
6401	1001046982	644280	1	6801355	2026-05-06 19:40:47
6402	1001046982	644281	1	6801355	2026-05-06 19:40:47
6403	1001046982	644282	1	6801355	2026-05-06 19:40:47
6404	1001046982	644323	1	96353963	2026-05-06 19:40:47
6405	1006506936	595100	2	000000000	2026-05-06 19:40:47
6406	1006506936	595133	1	26632272	2026-05-06 19:40:47
6407	1006506936	595134	1	26632272	2026-05-06 19:40:47
6408	1006506936	595135	1	26632272	2026-05-06 19:40:47
6409	1006506936	595136	1	26632272	2026-05-06 19:40:47
6410	1006506936	595105	1	28555809	2026-05-06 19:40:47
6411	1006506936	595137	1	96353963	2026-05-06 19:40:47
6412	1006506936	595138	1	96353963	2026-05-06 19:40:47
6413	1006506936	595139	1	96353963	2026-05-06 19:40:47
6414	1006506936	595140	1	96353963	2026-05-06 19:40:47
6415	1006506936	595163	1	6805131	2026-05-06 19:40:47
6416	1006506936	595164	1	6805131	2026-05-06 19:40:47
6417	1006506936	595165	1	6805131	2026-05-06 19:40:47
6418	1006506936	595166	1	6805131	2026-05-06 19:40:47
6419	1006506936	595167	1	6805131	2026-05-06 19:40:47
6420	1006506936	595168	1	6805131	2026-05-06 19:40:47
32	1006419673	593227	2	000000000	2026-04-30 19:07:38
6421	1006506936	595101	1	40776309	2026-05-06 19:40:47
33	1006419673	593235	2	000000000	2026-04-30 19:07:38
34	1006419673	593236	2	000000000	2026-04-30 19:07:38
6422	1006506936	595102	1	1026552707	2026-05-06 19:40:47
35	1006419673	593237	2	000000000	2026-04-30 19:07:38
6423	1006506936	595103	1	40776309	2026-05-06 19:40:47
6424	1006506936	595104	1	1026552707	2026-05-06 19:40:47
6425	1006506936	595149	1	96328076	2026-05-06 19:40:47
36	1006419673	593238	2	000000000	2026-04-30 19:07:38
6426	1006506936	595150	1	96328076	2026-05-06 19:40:47
37	1006419673	593109	2	000000000	2026-04-30 19:07:38
6427	1006506936	595151	1	96328076	2026-05-06 19:40:47
38	1006419673	593110	2	000000000	2026-04-30 19:07:38
6428	1006506936	595152	1	96328076	2026-05-06 19:40:47
6429	1006506936	595141	1	1117515166	2026-05-06 19:40:47
6430	1006506936	595142	1	1117515166	2026-05-06 19:40:47
6431	1006506936	595143	1	1117515166	2026-05-06 19:40:47
6432	1006506936	595144	1	1117515166	2026-05-06 19:40:47
39	1006419673	593111	2	000000000	2026-04-30 19:07:38
40	1006419673	593112	2	000000000	2026-04-30 19:07:38
41	1006419673	593100	2	000000000	2026-04-30 19:07:38
6433	1006506936	595158	2	000000000	2026-05-06 19:40:47
42	1006419673	593101	2	000000000	2026-04-30 19:07:38
6434	1006506936	595159	2	000000000	2026-05-06 19:40:47
43	1006419673	593102	2	000000000	2026-04-30 19:07:38
6435	1006506936	595160	2	000000000	2026-05-06 19:40:47
6436	1006506936	595161	2	000000000	2026-05-06 19:40:47
6437	1006506936	595162	2	000000000	2026-05-06 19:40:47
44	1006419673	593103	2	000000000	2026-04-30 19:07:38
45	1006419673	593060	2	000000000	2026-04-30 19:07:38
46	1006419673	593061	2	000000000	2026-04-30 19:07:38
47	1006419673	593062	2	000000000	2026-04-30 19:07:38
48	1006419673	593104	2	000000000	2026-04-30 19:07:38
49	1006419673	593105	2	000000000	2026-04-30 19:07:38
50	1006419673	593106	2	000000000	2026-04-30 19:07:38
51	1006419673	593107	2	000000000	2026-04-30 19:07:38
6438	1006506936	595106	1	28555809	2026-05-06 19:40:47
52	1006419673	593108	2	000000000	2026-04-30 19:07:38
53	1006419673	593144	2	000000000	2026-04-30 19:07:38
54	1006419673	593145	2	000000000	2026-04-30 19:07:38
55	1006419673	593146	2	000000000	2026-04-30 19:07:38
56	1006419673	592373	2	000000000	2026-04-30 19:07:38
57	1006419673	592374	2	000000000	2026-04-30 19:07:38
6439	1006506936	595107	1	28555809	2026-05-06 19:40:47
6440	1006506936	595108	1	28555809	2026-05-06 19:40:47
58	1006419673	592375	1	96353963	2025-05-25 15:05:00
6441	1006506936	595109	1	28555809	2026-05-06 19:40:47
6442	1006506936	595110	1	28555809	2026-05-06 19:40:47
59	1006419673	592376	2	000000000	2026-04-30 19:07:38
6443	1006506936	595125	1	28555809	2026-05-06 19:40:47
60	1006419673	593344	2	000000000	2026-04-30 19:07:38
61	1006419673	593345	2	000000000	2026-04-30 19:07:38
6444	1006506936	595126	1	28555809	2026-05-06 19:40:47
62	1006419673	593346	2	000000000	2026-04-30 19:07:38
6445	1006506936	595127	1	28555809	2026-05-06 19:40:47
63	1006419673	593347	2	000000000	2026-04-30 19:07:38
64	1006419673	593243	2	000000000	2026-04-30 19:07:38
65	1006419673	593244	2	000000000	2026-04-30 19:07:38
66	1006419673	593245	2	000000000	2026-04-30 19:07:38
67	1006419673	593246	2	000000000	2026-04-30 19:07:38
6446	1006506936	595128	1	28555809	2026-05-06 19:40:47
6447	1006506936	595129	1	28555809	2026-05-06 19:40:47
6448	1006506936	595130	1	28555809	2026-05-06 19:40:47
6449	1006506936	595131	1	28555809	2026-05-06 19:40:47
68	1006419673	593255	2	000000000	2026-04-30 19:07:38
69	1006419673	593256	1	40781077	2025-04-30 18:04:00
70	1006419673	593257	2	000000000	2026-04-30 19:07:38
71	1006419673	593258	2	000000000	2026-04-30 19:07:38
6450	1006506936	595132	1	28555809	2026-05-06 19:40:47
6451	1006506936	595117	2	000000000	2026-05-06 19:40:47
6452	1006506936	595118	2	000000000	2026-05-06 19:40:47
6453	1006506936	595119	1	1077865671	2026-05-06 19:40:47
6454	1006506936	595120	1	1077865671	2026-05-06 19:40:47
6455	1006506936	595145	1	1117503960	2026-05-06 19:40:47
72	1006419673	593259	2	000000000	2026-04-30 19:07:38
6456	1006506936	595146	1	1117503960	2026-05-06 19:40:47
73	1006419673	593340	2	000000000	2026-04-30 19:07:38
74	1006419673	593341	2	000000000	2026-04-30 19:07:38
6457	1006506936	595147	1	1117503960	2026-05-06 19:40:47
75	1006419673	593342	2	000000000	2026-04-30 19:07:38
6458	1006506936	595148	1	1117503960	2026-05-06 19:40:47
76	1006508766	590803	2	000000000	2026-04-30 19:07:38
6459	1006506936	595111	1	28555809	2026-05-06 19:40:47
77	1006508766	593147	1	26632272	2025-11-25 09:11:00
6460	1006506936	595112	1	28555809	2026-05-06 19:40:47
78	1006508766	593148	1	26632272	2025-11-25 09:11:00
6461	1006506936	595113	1	28555809	2026-05-06 19:40:47
79	1006508766	593149	1	26632272	2025-11-25 09:11:00
6462	1006506936	595114	1	28555809	2026-05-06 19:40:47
6463	1006506936	595115	1	28555809	2026-05-06 19:40:47
6464	1006506936	595116	1	28555809	2026-05-06 19:40:47
6465	1006506936	644275	1	28555809	2026-05-06 19:40:47
6466	1006506936	644276	1	28555809	2026-05-06 19:40:47
80	1006508766	593150	1	26632272	2025-11-25 09:11:00
81	1006508766	593343	1	1117523028	2025-02-16 16:02:00
82	1006508766	593151	1	6801798	2025-03-24 11:03:00
6467	1006506936	644277	1	28555809	2026-05-06 19:40:47
83	1006508766	593152	2	000000000	2026-04-30 19:07:38
6468	1006506936	644278	1	28555809	2026-05-06 19:40:47
84	1006508766	593153	2	000000000	2026-04-30 19:07:38
6469	1006506936	644279	1	6801355	2026-05-06 19:40:47
6470	1006506936	644280	1	6801355	2026-05-06 19:40:47
6471	1006506936	644281	1	6801355	2026-05-06 19:40:47
6472	1006506936	644282	1	6801355	2026-05-06 19:40:47
85	1006508766	593154	1	6801798	2025-03-24 11:03:00
86	1006508766	593113	2	000000000	2026-04-30 19:07:38
87	1006508766	593114	2	000000000	2026-04-30 19:07:38
88	1006508766	593115	1	1117499177	2026-03-24 08:03:00
89	1006508766	593116	2	000000000	2026-04-30 19:07:38
90	1006508766	593117	1	1117546314	2025-06-21 10:06:00
91	1006508766	593118	1	1117499177	2026-03-24 08:03:00
92	1006508766	593155	2	000000000	2026-04-30 19:07:38
6473	1006506936	644323	1	96353963	2026-05-06 19:40:47
93	1006508766	593156	1	40776309	2025-11-25 19:11:00
94	1006508766	593157	2	000000000	2026-04-30 19:07:38
95	1006508766	593158	1	17654594	2025-06-02 19:06:00
96	1006508766	593119	1	17648908	2025-12-16 20:12:00
97	1006508766	593120	1	17648908	2025-04-24 12:04:00
98	1006508766	593121	1	17648908	2025-12-16 20:12:00
6474	1006513246	595100	2	000000000	2026-05-06 19:40:47
6475	1006513246	595133	2	000000000	2026-05-06 19:40:47
99	1006508766	593122	1	17648908	2025-12-16 20:12:00
6476	1006513246	595134	2	000000000	2026-05-06 19:40:47
6477	1006513246	595135	2	000000000	2026-05-06 19:40:47
100	1006508766	593159	2	000000000	2026-04-30 19:07:38
6478	1006513246	595136	2	000000000	2026-05-06 19:40:47
101	1006508766	593160	2	000000000	2026-04-30 19:07:38
102	1006508766	593161	2	000000000	2026-04-30 19:07:38
6479	1006513246	595105	2	000000000	2026-05-06 19:40:47
103	1006508766	593162	2	000000000	2026-04-30 19:07:38
6480	1006513246	595137	2	000000000	2026-05-06 19:40:47
104	1006508766	593224	1	1117515166	2026-03-16 18:03:00
105	1006508766	593225	1	1117515166	2025-11-26 17:11:00
106	1006508766	593226	1	1117515166	2026-03-16 18:03:00
107	1006508766	593227	1	1117515166	2025-11-26 17:11:00
108	1006508766	593235	2	000000000	2026-04-30 19:07:38
6481	1006513246	595138	2	000000000	2026-05-06 19:40:47
6482	1006513246	595139	2	000000000	2026-05-06 19:40:47
6483	1006513246	595140	2	000000000	2026-05-06 19:40:47
6484	1006513246	595163	2	000000000	2026-05-06 19:40:47
109	1006508766	593236	2	000000000	2026-04-30 19:07:38
110	1006508766	593237	2	000000000	2026-04-30 19:07:38
111	1006508766	593238	2	000000000	2026-04-30 19:07:38
112	1006508766	593109	2	000000000	2026-04-30 19:07:38
6485	1006513246	595164	2	000000000	2026-05-06 19:40:47
6486	1006513246	595165	2	000000000	2026-05-06 19:40:47
6487	1006513246	595166	2	000000000	2026-05-06 19:40:47
6488	1006513246	595167	2	000000000	2026-05-06 19:40:47
6489	1006513246	595168	2	000000000	2026-05-06 19:40:47
6490	1006513246	595101	2	000000000	2026-05-06 19:40:47
113	1006508766	593110	2	000000000	2026-04-30 19:07:38
6491	1006513246	595102	2	000000000	2026-05-06 19:40:47
114	1006508766	593111	1	96353963	2025-11-28 11:11:00
115	1006508766	593112	2	000000000	2026-04-30 19:07:38
6492	1006513246	595103	2	000000000	2026-05-06 19:40:47
116	1006508766	593100	1	1117523028	2025-11-28 09:11:00
6493	1006513246	595104	2	000000000	2026-05-06 19:40:47
117	1006508766	593101	1	1117523028	2025-11-28 09:11:00
6494	1006513246	595149	2	000000000	2026-05-06 19:40:47
118	1006508766	593102	2	000000000	2026-04-30 19:07:38
6495	1006513246	595150	2	000000000	2026-05-06 19:40:47
119	1006508766	593103	1	1117523028	2025-11-28 09:11:00
6496	1006513246	595151	2	000000000	2026-05-06 19:40:47
120	1006508766	593060	2	000000000	2026-04-30 19:07:38
6497	1006513246	595152	2	000000000	2026-05-06 19:40:47
6498	1006513246	595141	2	000000000	2026-05-06 19:40:47
6499	1006513246	595142	2	000000000	2026-05-06 19:40:47
6500	1006513246	595143	2	000000000	2026-05-06 19:40:47
6501	1006513246	595144	2	000000000	2026-05-06 19:40:47
121	1006508766	593061	1	6801355	2025-07-23 11:07:00
122	1006508766	593062	2	000000000	2026-04-30 19:07:38
123	1006508766	593104	1	1117523028	2025-06-19 07:06:00
6502	1006513246	595158	2	000000000	2026-05-06 19:40:47
124	1006508766	593105	2	000000000	2026-04-30 19:07:38
6503	1006513246	595159	2	000000000	2026-05-06 19:40:47
125	1006508766	593106	1	1117523028	2025-11-28 09:11:00
6504	1006513246	595160	2	000000000	2026-05-06 19:40:47
6505	1006513246	595161	2	000000000	2026-05-06 19:40:47
6506	1006513246	595162	2	000000000	2026-05-06 19:40:47
126	1006508766	593107	2	000000000	2026-04-30 19:07:38
127	1006508766	593108	1	1117523028	2025-11-28 09:11:00
128	1006508766	593144	2	000000000	2026-04-30 19:07:38
129	1006508766	593145	2	000000000	2026-04-30 19:07:38
130	1006508766	593146	2	000000000	2026-04-30 19:07:38
131	1006508766	592373	2	000000000	2026-04-30 19:07:38
132	1006508766	592374	2	000000000	2026-04-30 19:07:38
133	1006508766	592375	1	96353963	2025-05-25 15:05:00
6507	1006513246	595106	2	000000000	2026-05-06 19:40:47
134	1006508766	592376	1	1117523028	2025-11-28 09:11:00
135	1006508766	593344	1	1117523028	2025-07-23 11:07:00
136	1006508766	593345	2	000000000	2026-04-30 19:07:38
137	1006508766	593346	1	1117523028	2025-07-23 11:07:00
138	1006508766	593347	2	000000000	2026-04-30 19:07:38
139	1006508766	593243	1	1117523028	2025-12-15 09:12:00
6508	1006513246	595107	2	000000000	2026-05-06 19:40:47
6509	1006513246	595108	2	000000000	2026-05-06 19:40:47
140	1006508766	593244	2	000000000	2026-04-30 19:07:38
6510	1006513246	595109	2	000000000	2026-05-06 19:40:47
6511	1006513246	595110	2	000000000	2026-05-06 19:40:47
141	1006508766	593245	2	000000000	2026-04-30 19:07:38
6512	1006513246	595125	2	000000000	2026-05-06 19:40:47
142	1006508766	593246	2	000000000	2026-04-30 19:07:38
143	1006508766	593255	1	40781077	2025-12-15 17:12:00
6513	1006513246	595126	2	000000000	2026-05-06 19:40:47
144	1006508766	593256	1	40781077	2025-04-30 18:04:00
6514	1006513246	595127	2	000000000	2026-05-06 19:40:47
145	1006508766	593257	1	40781077	2025-12-15 17:12:00
146	1006508766	593258	1	40781077	2025-12-05 09:12:00
6515	1006513246	595128	2	000000000	2026-05-06 19:40:47
147	1006508766	593259	1	40778471	2025-12-01 09:12:00
148	1006508766	593340	1	40778471	2025-12-01 09:12:00
6516	1006513246	595129	2	000000000	2026-05-06 19:40:47
6517	1006513246	595130	2	000000000	2026-05-06 19:40:47
6518	1006513246	595131	2	000000000	2026-05-06 19:40:47
6519	1006513246	595132	2	000000000	2026-05-06 19:40:47
149	1006508766	593341	1	40778471	2025-12-01 09:12:00
150	1006508766	593342	1	40778471	2025-12-01 09:12:00
151	1006508852	590803	2	000000000	2026-04-30 19:07:38
152	1006508852	593147	1	26632272	2025-11-25 09:11:00
6520	1006513246	595117	2	000000000	2026-05-06 19:40:47
6521	1006513246	595118	2	000000000	2026-05-06 19:40:47
6522	1006513246	595119	2	000000000	2026-05-06 19:40:47
6523	1006513246	595120	2	000000000	2026-05-06 19:40:47
6524	1006513246	595145	2	000000000	2026-05-06 19:40:47
6525	1006513246	595146	2	000000000	2026-05-06 19:40:47
153	1006508852	593148	1	26632272	2025-11-25 09:11:00
6526	1006513246	595147	2	000000000	2026-05-06 19:40:47
154	1006508852	593149	1	26632272	2025-11-25 09:11:00
155	1006508852	593150	1	26632272	2025-11-25 09:11:00
6527	1006513246	595148	2	000000000	2026-05-06 19:40:47
156	1006508852	593343	1	1117523028	2025-02-16 16:02:00
6528	1006513246	595111	2	000000000	2026-05-06 19:40:47
6529	1006513246	595112	2	000000000	2026-05-06 19:40:47
6530	1006513246	595113	2	000000000	2026-05-06 19:40:47
157	1006508852	593151	1	6801798	2025-03-24 11:03:00
6531	1006513246	595114	2	000000000	2026-05-06 19:40:47
158	1006508852	593152	2	000000000	2026-04-30 19:07:38
6532	1006513246	595115	2	000000000	2026-05-06 19:40:47
159	1006508852	593153	2	000000000	2026-04-30 19:07:38
6533	1006513246	595116	2	000000000	2026-05-06 19:40:47
6534	1006513246	644275	2	000000000	2026-05-06 19:40:47
6535	1006513246	644276	2	000000000	2026-05-06 19:40:47
6536	1006513246	644277	2	000000000	2026-05-06 19:40:47
6537	1006513246	644278	2	000000000	2026-05-06 19:40:47
160	1006508852	593154	1	6801798	2025-03-24 11:03:00
161	1006508852	593113	2	000000000	2026-04-30 19:07:38
162	1006508852	593114	2	000000000	2026-04-30 19:07:38
6538	1006513246	644279	2	000000000	2026-05-06 19:40:47
163	1006508852	593115	1	1117499177	2026-03-24 08:03:00
6539	1006513246	644280	2	000000000	2026-05-06 19:40:47
164	1006508852	593116	2	000000000	2026-04-30 19:07:38
6540	1006513246	644281	2	000000000	2026-05-06 19:40:47
6541	1006513246	644282	2	000000000	2026-05-06 19:40:47
6542	1006513246	644323	2	000000000	2026-05-06 19:40:47
165	1006508852	593117	1	1117546314	2025-06-21 10:06:00
166	1006508852	593118	1	1117499177	2026-03-24 08:03:00
167	1006508852	593155	2	000000000	2026-04-30 19:07:38
168	1006508852	593156	1	40776309	2025-11-25 19:11:00
169	1006508852	593157	2	000000000	2026-04-30 19:07:38
170	1006508852	593158	1	17654594	2025-06-02 19:06:00
171	1006508852	593119	1	17648908	2025-12-16 20:12:00
172	1006508852	593120	1	17648908	2025-04-24 12:04:00
6543	1006523628	595100	2	000000000	2026-05-06 19:40:47
173	1006508852	593121	1	17648908	2025-12-16 20:12:00
174	1006508852	593122	1	17648908	2025-12-16 20:12:00
175	1006508852	593159	2	000000000	2026-04-30 19:07:38
176	1006508852	593160	2	000000000	2026-04-30 19:07:38
177	1006508852	593161	2	000000000	2026-04-30 19:07:38
178	1006508852	593162	2	000000000	2026-04-30 19:07:38
6544	1006523628	595133	1	26632272	2026-05-06 19:40:47
6545	1006523628	595134	1	26632272	2026-05-06 19:40:47
179	1006508852	593224	1	1117515166	2026-03-16 18:03:00
6546	1006523628	595135	1	26632272	2026-05-06 19:40:47
6547	1006523628	595136	1	26632272	2026-05-06 19:40:47
180	1006508852	593225	1	1117515166	2025-11-26 17:11:00
6548	1006523628	595105	1	28555809	2026-05-06 19:40:47
181	1006508852	593226	1	1117515166	2026-03-16 18:03:00
182	1006508852	593227	1	1117515166	2025-11-26 17:11:00
6549	1006523628	595137	1	96353963	2026-05-06 19:40:47
183	1006508852	593235	2	000000000	2026-04-30 19:07:38
6550	1006523628	595138	1	96353963	2026-05-06 19:40:47
184	1006508852	593236	2	000000000	2026-04-30 19:07:38
185	1006508852	593237	2	000000000	2026-04-30 19:07:38
186	1006508852	593238	2	000000000	2026-04-30 19:07:38
187	1006508852	593109	2	000000000	2026-04-30 19:07:38
188	1006508852	593110	2	000000000	2026-04-30 19:07:38
6551	1006523628	595139	1	96353963	2026-05-06 19:40:47
6552	1006523628	595140	1	96353963	2026-05-06 19:40:47
6553	1006523628	595163	1	6805131	2026-05-06 19:40:47
6554	1006523628	595164	1	6805131	2026-05-06 19:40:47
189	1006508852	593111	1	96353963	2025-11-28 11:11:00
190	1006508852	593112	2	000000000	2026-04-30 19:07:38
191	1006508852	593100	1	1117523028	2025-11-28 09:11:00
192	1006508852	593101	1	1117523028	2025-11-28 09:11:00
6555	1006523628	595165	1	6805131	2026-05-06 19:40:47
6556	1006523628	595166	1	6805131	2026-05-06 19:40:47
6557	1006523628	595167	1	6805131	2026-05-06 19:40:47
6558	1006523628	595168	1	6805131	2026-05-06 19:40:47
6559	1006523628	595101	1	40776309	2026-05-06 19:40:47
6560	1006523628	595102	1	1026552707	2026-05-06 19:40:47
193	1006508852	593102	2	000000000	2026-04-30 19:07:38
6561	1006523628	595103	1	40776309	2026-05-06 19:40:47
194	1006508852	593103	1	1117523028	2025-11-28 09:11:00
195	1006508852	593060	2	000000000	2026-04-30 19:07:38
6562	1006523628	595104	1	1026552707	2026-05-06 19:40:47
196	1006508852	593061	1	6801355	2025-07-23 11:07:00
6563	1006523628	595149	1	96328076	2026-05-06 19:40:47
197	1006508852	593062	2	000000000	2026-04-30 19:07:38
6564	1006523628	595150	1	96328076	2026-05-06 19:40:47
198	1006508852	593104	1	1117523028	2025-06-19 07:06:00
6565	1006523628	595151	1	96328076	2026-05-06 19:40:47
199	1006508852	593105	2	000000000	2026-04-30 19:07:38
6566	1006523628	595152	1	96328076	2026-05-06 19:40:47
200	1006508852	593106	1	1117523028	2025-11-28 09:11:00
6567	1006523628	595141	1	1117515166	2026-05-06 19:40:47
6568	1006523628	595142	1	1117515166	2026-05-06 19:40:47
6569	1006523628	595143	1	1117515166	2026-05-06 19:40:47
6570	1006523628	595144	1	1117515166	2026-05-06 19:40:47
6571	1006523628	595158	2	000000000	2026-05-06 19:40:47
6572	1006523628	595159	2	000000000	2026-05-06 19:40:47
201	1006508852	593107	2	000000000	2026-04-30 19:07:38
202	1006508852	593108	1	1117523028	2025-11-28 09:11:00
203	1006508852	593144	2	000000000	2026-04-30 19:07:38
6573	1006523628	595160	2	000000000	2026-05-06 19:40:47
204	1006508852	593145	2	000000000	2026-04-30 19:07:38
6574	1006523628	595161	2	000000000	2026-05-06 19:40:47
205	1006508852	593146	2	000000000	2026-04-30 19:07:38
6575	1006523628	595162	2	000000000	2026-05-06 19:40:47
6576	1006523628	595106	1	28555809	2026-05-06 19:40:47
6577	1006523628	595107	1	28555809	2026-05-06 19:40:47
206	1006508852	592373	2	000000000	2026-04-30 19:07:38
207	1006508852	592374	2	000000000	2026-04-30 19:07:38
208	1006508852	592375	1	96353963	2025-05-25 15:05:00
209	1006508852	592376	1	1117523028	2025-11-28 09:11:00
210	1006508852	593344	1	1117523028	2025-07-23 11:07:00
211	1006508852	593345	2	000000000	2026-04-30 19:07:38
212	1006508852	593346	1	1117523028	2025-07-23 11:07:00
213	1006508852	593347	2	000000000	2026-04-30 19:07:38
6578	1006523628	595108	1	28555809	2026-05-06 19:40:47
214	1006508852	593243	1	1117523028	2025-12-15 09:12:00
215	1006508852	593244	2	000000000	2026-04-30 19:07:38
216	1006508852	593245	2	000000000	2026-04-30 19:07:38
217	1006508852	593246	2	000000000	2026-04-30 19:07:38
218	1006508852	593255	1	40781077	2025-12-15 17:12:00
219	1006508852	593256	1	40781077	2025-04-30 18:04:00
6579	1006523628	595109	1	28555809	2026-05-06 19:40:47
6580	1006523628	595110	1	28555809	2026-05-06 19:40:47
220	1006508852	593257	1	40781077	2025-12-15 17:12:00
6581	1006523628	595125	1	28555809	2026-05-06 19:40:47
6582	1006523628	595126	1	28555809	2026-05-06 19:40:47
221	1006508852	593258	1	40781077	2025-12-05 09:12:00
6583	1006523628	595127	1	28555809	2026-05-06 19:40:47
222	1006508852	593259	1	40778471	2025-12-01 11:12:00
223	1006508852	593340	1	40778471	2025-12-01 11:12:00
6584	1006523628	595128	1	28555809	2026-05-06 19:40:47
224	1006508852	593341	1	40778471	2025-12-01 11:12:00
6585	1006523628	595129	1	28555809	2026-05-06 19:40:47
225	1006508852	593342	1	40778471	2025-12-01 11:12:00
226	1006510328	590803	2	000000000	2026-04-30 19:07:38
227	1006510328	593147	1	26632272	2025-11-25 09:11:00
228	1006510328	593148	1	26632272	2025-11-25 09:11:00
229	1006510328	593149	1	26632272	2025-11-25 09:11:00
6586	1006523628	595130	1	28555809	2026-05-06 19:40:47
6587	1006523628	595131	1	28555809	2026-05-06 19:40:47
6588	1006523628	595132	1	28555809	2026-05-06 19:40:47
6589	1006523628	595117	2	000000000	2026-05-06 19:40:47
230	1006510328	593150	1	26632272	2025-11-25 09:11:00
231	1006510328	593343	1	1117523028	2025-02-16 16:02:00
232	1006510328	593151	1	6801798	2025-03-24 11:03:00
233	1006510328	593152	2	000000000	2026-04-30 19:07:38
6590	1006523628	595118	2	000000000	2026-05-06 19:40:47
6591	1006523628	595119	1	1077865671	2026-05-06 19:40:47
6592	1006523628	595120	1	1077865671	2026-05-06 19:40:47
6593	1006523628	595145	1	1117503960	2026-05-06 19:40:47
6594	1006523628	595146	1	1117503960	2026-05-06 19:40:47
6595	1006523628	595147	1	1117503960	2026-05-06 19:40:47
234	1006510328	593153	2	000000000	2026-04-30 19:07:38
6596	1006523628	595148	1	1117503960	2026-05-06 19:40:47
235	1006510328	593154	1	6801798	2025-03-24 11:03:00
236	1006510328	593113	2	000000000	2026-04-30 19:07:38
6597	1006523628	595111	1	28555809	2026-05-06 19:40:47
237	1006510328	593114	2	000000000	2026-04-30 19:07:38
6598	1006523628	595112	1	28555809	2026-05-06 19:40:47
238	1006510328	593115	1	1117499177	2026-03-24 08:03:00
6599	1006523628	595113	1	28555809	2026-05-06 19:40:47
239	1006510328	593116	2	000000000	2026-04-30 19:07:38
6600	1006523628	595114	1	28555809	2026-05-06 19:40:47
240	1006510328	593117	1	1117546314	2025-06-21 10:06:00
6601	1006523628	595115	1	28555809	2026-05-06 19:40:47
241	1006510328	593118	1	1117499177	2026-03-24 08:03:00
6602	1006523628	595116	1	28555809	2026-05-06 19:40:47
6603	1006523628	644275	1	28555809	2026-05-06 19:40:47
6604	1006523628	644276	1	28555809	2026-05-06 19:40:47
6605	1006523628	644277	1	28555809	2026-05-06 19:40:47
6606	1006523628	644278	1	28555809	2026-05-06 19:40:47
242	1006510328	593155	2	000000000	2026-04-30 19:07:38
243	1006510328	593156	1	40776309	2025-11-25 19:11:00
244	1006510328	593157	2	000000000	2026-04-30 19:07:38
6607	1006523628	644279	1	6801355	2026-05-06 19:40:47
245	1006510328	593158	1	17654594	2025-06-02 19:06:00
6608	1006523628	644280	1	6801355	2026-05-06 19:40:47
246	1006510328	593119	1	17648908	2025-12-16 20:12:00
6609	1006523628	644281	1	6801355	2026-05-06 19:40:47
6610	1006523628	644282	1	6801355	2026-05-06 19:40:47
6611	1006523628	644323	1	96353963	2026-05-06 19:40:47
247	1006510328	593120	1	17648908	2025-04-24 12:04:00
248	1006510328	593121	1	17648908	2025-12-16 20:12:00
249	1006510328	593122	1	17648908	2025-12-16 20:12:00
250	1006510328	593159	2	000000000	2026-04-30 19:07:38
251	1006510328	593160	2	000000000	2026-04-30 19:07:38
252	1006510328	593161	2	000000000	2026-04-30 19:07:38
253	1006510328	593162	2	000000000	2026-04-30 19:07:38
254	1006510328	593224	1	1117515166	2026-03-16 18:03:00
6612	1006526763	595100	2	000000000	2026-05-06 19:40:47
255	1006510328	593225	1	1117515166	2025-11-26 17:11:00
256	1006510328	593226	1	1117515166	2026-03-16 18:03:00
257	1006510328	593227	1	1117515166	2025-11-26 17:11:00
258	1006510328	593235	2	000000000	2026-04-30 19:07:38
259	1006510328	593236	2	000000000	2026-04-30 19:07:38
260	1006510328	593237	2	000000000	2026-04-30 19:07:38
6613	1006526763	595133	1	26632272	2026-05-06 19:40:47
6614	1006526763	595134	1	26632272	2026-05-06 19:40:47
6615	1006526763	595135	1	26632272	2026-05-06 19:40:47
6616	1006526763	595136	1	26632272	2026-05-06 19:40:47
6617	1006526763	595105	1	28555809	2026-05-06 19:40:47
261	1006510328	593238	2	000000000	2026-04-30 19:07:38
6618	1006526763	595137	1	96353963	2026-05-06 19:40:47
262	1006510328	593109	2	000000000	2026-04-30 19:07:38
263	1006510328	593110	2	000000000	2026-04-30 19:07:38
6619	1006526763	595138	1	96353963	2026-05-06 19:40:47
264	1006510328	593111	1	96353963	2025-11-28 11:11:00
6620	1006526763	595139	1	96353963	2026-05-06 19:40:47
265	1006510328	593112	2	000000000	2026-04-30 19:07:38
266	1006510328	593100	1	1117523028	2025-11-28 09:11:00
267	1006510328	593101	1	1117523028	2025-11-28 09:11:00
268	1006510328	593102	2	000000000	2026-04-30 19:07:38
269	1006510328	593103	1	1117523028	2025-11-28 09:11:00
6621	1006526763	595140	1	96353963	2026-05-06 19:40:47
6622	1006526763	595163	1	6805131	2026-05-06 19:40:47
6623	1006526763	595164	1	6805131	2026-05-06 19:40:47
6624	1006526763	595165	1	6805131	2026-05-06 19:40:47
270	1006510328	593060	2	000000000	2026-04-30 19:07:38
271	1006510328	593061	1	6801355	2025-07-23 11:07:00
272	1006510328	593062	2	000000000	2026-04-30 19:07:38
273	1006510328	593104	1	1117523028	2025-06-19 07:06:00
6625	1006526763	595166	1	6805131	2026-05-06 19:40:47
6626	1006526763	595167	1	6805131	2026-05-06 19:40:47
6627	1006526763	595168	1	6805131	2026-05-06 19:40:47
6628	1006526763	595101	1	40776309	2026-05-06 19:40:47
6629	1006526763	595102	1	1026552707	2026-05-06 19:40:47
6630	1006526763	595103	1	40776309	2026-05-06 19:40:47
274	1006510328	593105	2	000000000	2026-04-30 19:07:38
6631	1006526763	595104	1	1026552707	2026-05-06 19:40:47
275	1006510328	593106	1	1117523028	2025-11-28 09:11:00
276	1006510328	593107	2	000000000	2026-04-30 19:07:38
6632	1006526763	595149	1	96328076	2026-05-06 19:40:47
277	1006510328	593108	1	1117523028	2025-11-28 09:11:00
6633	1006526763	595150	1	96328076	2026-05-06 19:40:47
278	1006510328	593144	2	000000000	2026-04-30 19:07:38
6634	1006526763	595151	1	96328076	2026-05-06 19:40:47
279	1006510328	593145	2	000000000	2026-04-30 19:07:38
6635	1006526763	595152	1	96328076	2026-05-06 19:40:47
280	1006510328	593146	2	000000000	2026-04-30 19:07:38
6636	1006526763	595141	1	1117515166	2026-05-06 19:40:47
281	1006510328	592373	2	000000000	2026-04-30 19:07:38
6637	1006526763	595142	1	1117515166	2026-05-06 19:40:47
6638	1006526763	595143	1	1117515166	2026-05-06 19:40:47
6639	1006526763	595144	1	1117515166	2026-05-06 19:40:47
6640	1006526763	595158	2	000000000	2026-05-06 19:40:47
6641	1006526763	595159	2	000000000	2026-05-06 19:40:47
282	1006510328	592374	2	000000000	2026-04-30 19:07:38
283	1006510328	592375	1	96353963	2025-05-25 15:05:00
284	1006510328	592376	1	1117523028	2025-11-28 09:11:00
6642	1006526763	595160	2	000000000	2026-05-06 19:40:47
285	1006510328	593344	1	1117523028	2025-07-23 11:07:00
6643	1006526763	595161	2	000000000	2026-05-06 19:40:47
286	1006510328	593345	2	000000000	2026-04-30 19:07:38
6644	1006526763	595162	2	000000000	2026-05-06 19:40:47
6645	1006526763	595106	1	28555809	2026-05-06 19:40:47
6646	1006526763	595107	1	28555809	2026-05-06 19:40:47
287	1006510328	593346	1	1117523028	2025-07-23 11:07:00
288	1006510328	593347	2	000000000	2026-04-30 19:07:38
289	1006510328	593243	1	1117523028	2025-12-15 09:12:00
290	1006510328	593244	2	000000000	2026-04-30 19:07:38
291	1006510328	593245	2	000000000	2026-04-30 19:07:38
292	1006510328	593246	2	000000000	2026-04-30 19:07:38
293	1006510328	593255	1	40781077	2025-12-15 17:12:00
294	1006510328	593256	1	40781077	2025-04-30 18:04:00
6647	1006526763	595108	1	28555809	2026-05-06 19:40:47
295	1006510328	593257	1	40781077	2025-12-15 17:12:00
296	1006510328	593258	1	40781077	2025-12-05 09:12:00
297	1006510328	593259	1	40778471	2025-12-01 09:12:00
298	1006510328	593340	1	40778471	2025-12-01 09:12:00
299	1006510328	593341	1	40778471	2025-12-01 09:12:00
300	1006510328	593342	1	40778471	2025-12-01 09:12:00
6648	1006526763	595109	1	28555809	2026-05-06 19:40:47
6649	1006526763	595110	1	28555809	2026-05-06 19:40:47
301	1051065897	590803	2	000000000	2026-04-30 19:07:38
6650	1006526763	595125	1	28555809	2026-05-06 19:40:47
6651	1006526763	595126	1	28555809	2026-05-06 19:40:47
302	1051065897	593147	1	26632272	2025-11-25 09:11:00
6652	1006526763	595127	1	28555809	2026-05-06 19:40:47
303	1051065897	593148	1	26632272	2025-11-25 09:11:00
304	1051065897	593149	1	26632272	2025-11-25 09:11:00
6653	1006526763	595128	1	28555809	2026-05-06 19:40:47
305	1051065897	593150	1	26632272	2025-11-25 09:11:00
6654	1006526763	595129	1	28555809	2026-05-06 19:40:47
306	1051065897	593343	1	1117523028	2025-02-16 16:02:00
307	1051065897	593151	1	6801798	2025-03-24 11:03:00
308	1051065897	593152	2	000000000	2026-04-30 19:07:38
309	1051065897	593153	2	000000000	2026-04-30 19:07:38
310	1051065897	593154	1	6801798	2025-03-24 11:03:00
6655	1006526763	595130	1	28555809	2026-05-06 19:40:47
6656	1006526763	595131	1	28555809	2026-05-06 19:40:47
6657	1006526763	595132	1	28555809	2026-05-06 19:40:47
6658	1006526763	595117	2	000000000	2026-05-06 19:40:47
311	1051065897	593113	2	000000000	2026-04-30 19:07:38
312	1051065897	593114	2	000000000	2026-04-30 19:07:38
313	1051065897	593115	1	1117499177	2026-03-24 08:03:00
314	1051065897	593116	2	000000000	2026-04-30 19:07:38
6659	1006526763	595118	2	000000000	2026-05-06 19:40:47
6660	1006526763	595119	1	1077865671	2026-05-06 19:40:47
6661	1006526763	595120	1	1077865671	2026-05-06 19:40:47
6662	1006526763	595145	1	1117503960	2026-05-06 19:40:47
6663	1006526763	595146	1	1117503960	2026-05-06 19:40:47
6664	1006526763	595147	1	1117503960	2026-05-06 19:40:47
315	1051065897	593117	1	1117546314	2025-06-21 10:06:00
6665	1006526763	595148	1	1117503960	2026-05-06 19:40:47
316	1051065897	593118	1	1117499177	2026-03-24 08:03:00
317	1051065897	593155	2	000000000	2026-04-30 19:07:38
6666	1006526763	595111	1	28555809	2026-05-06 19:40:47
318	1051065897	593156	1	40776309	2025-11-25 19:11:00
6667	1006526763	595112	1	28555809	2026-05-06 19:40:47
6668	1006526763	595113	1	28555809	2026-05-06 19:40:47
319	1051065897	593157	2	000000000	2026-04-30 19:07:38
6669	1006526763	595114	1	28555809	2026-05-06 19:40:47
320	1051065897	593158	1	17654594	2025-06-02 19:06:00
6670	1006526763	595115	1	28555809	2026-05-06 19:40:47
321	1051065897	593119	1	17648908	2025-12-16 20:12:00
6671	1006526763	595116	1	28555809	2026-05-06 19:40:47
322	1051065897	593120	1	17648908	2025-04-24 12:04:00
6672	1006526763	644275	1	28555809	2026-05-06 19:40:47
6673	1006526763	644276	1	28555809	2026-05-06 19:40:47
6674	1006526763	644277	1	28555809	2026-05-06 19:40:47
6675	1006526763	644278	1	28555809	2026-05-06 19:40:47
6676	1006526763	644279	1	6801355	2026-05-06 19:40:47
323	1051065897	593121	1	17648908	2025-12-16 20:12:00
324	1051065897	593122	1	17648908	2025-12-16 20:12:00
325	1051065897	593159	2	000000000	2026-04-30 19:07:39
6677	1006526763	644280	1	6801355	2026-05-06 19:40:47
326	1051065897	593160	2	000000000	2026-04-30 19:07:39
6678	1006526763	644281	1	6801355	2026-05-06 19:40:48
327	1051065897	593161	2	000000000	2026-04-30 19:07:39
6679	1006526763	644282	1	6801355	2026-05-06 19:40:48
6680	1006526763	644323	1	96353963	2026-05-06 19:40:48
6681	1006526827	595100	2	000000000	2026-05-06 19:40:48
328	1051065897	593162	2	000000000	2026-04-30 19:07:39
329	1051065897	593224	1	1117515166	2026-03-16 18:03:00
330	1051065897	593225	1	1117515166	2025-11-26 17:11:00
331	1051065897	593226	1	1117515166	2026-03-16 18:03:00
332	1051065897	593227	1	1117515166	2025-11-26 17:11:00
333	1051065897	593235	2	000000000	2026-04-30 19:07:39
334	1051065897	593236	2	000000000	2026-04-30 19:07:39
335	1051065897	593237	2	000000000	2026-04-30 19:07:39
6682	1006526827	595133	1	26632272	2026-05-06 19:40:48
6683	1006526827	595134	1	26632272	2026-05-06 19:40:48
6684	1006526827	595135	1	26632272	2026-05-06 19:40:48
6685	1006526827	595136	1	26632272	2026-05-06 19:40:48
6686	1006526827	595105	1	28555809	2026-05-06 19:40:48
336	1051065897	593238	2	000000000	2026-04-30 19:07:39
337	1051065897	593109	2	000000000	2026-04-30 19:07:39
6687	1006526827	595137	1	96353963	2026-05-06 19:40:48
6688	1006526827	595138	1	96353963	2026-05-06 19:40:48
338	1051065897	593110	2	000000000	2026-04-30 19:07:39
6689	1006526827	595139	1	96353963	2026-05-06 19:40:48
6690	1006526827	595140	1	96353963	2026-05-06 19:40:48
6691	1006526827	595163	1	6805131	2026-05-06 19:40:48
6692	1006526827	595164	1	6805131	2026-05-06 19:40:48
339	1051065897	593111	1	96353963	2025-11-28 11:11:00
6693	1006526827	595165	1	6805131	2026-05-06 19:40:48
6694	1006526827	595166	1	6805131	2026-05-06 19:40:48
6695	1006526827	595167	1	6805131	2026-05-06 19:40:48
6696	1006526827	595168	1	6805131	2026-05-06 19:40:48
340	1051065897	593112	2	000000000	2026-04-30 19:07:39
6697	1006526827	595101	1	40776309	2026-05-06 19:40:48
341	1051065897	593100	1	1117523028	2025-11-28 09:11:00
6698	1006526827	595102	1	1026552707	2026-05-06 19:40:48
6699	1006526827	595103	1	40776309	2026-05-06 19:40:48
6700	1006526827	595104	1	1026552707	2026-05-06 19:40:48
6701	1006526827	595149	1	96328076	2026-05-06 19:40:48
6702	1006526827	595150	1	96328076	2026-05-06 19:40:48
6703	1006526827	595151	1	96328076	2026-05-06 19:40:48
6704	1006526827	595152	1	96328076	2026-05-06 19:40:48
6705	1006526827	595141	1	1117515166	2026-05-06 19:40:48
6706	1006526827	595142	1	1117515166	2026-05-06 19:40:48
6707	1006526827	595143	1	1117515166	2026-05-06 19:40:48
6708	1006526827	595144	1	1117515166	2026-05-06 19:40:48
6709	1006526827	595158	2	000000000	2026-05-06 19:40:48
6710	1006526827	595159	2	000000000	2026-05-06 19:40:48
6711	1006526827	595160	2	000000000	2026-05-06 19:40:48
6712	1006526827	595161	2	000000000	2026-05-06 19:40:48
6713	1006526827	595162	2	000000000	2026-05-06 19:40:48
6714	1006526827	595106	1	28555809	2026-05-06 19:40:48
6715	1006526827	595107	1	28555809	2026-05-06 19:40:48
6716	1006526827	595108	1	28555809	2026-05-06 19:40:48
6717	1006526827	595109	1	28555809	2026-05-06 19:40:48
6718	1006526827	595110	1	28555809	2026-05-06 19:40:48
6719	1006526827	595125	1	28555809	2026-05-06 19:40:48
6720	1006526827	595126	1	28555809	2026-05-06 19:40:48
342	1051065897	593101	1	1117523028	2025-11-28 09:11:00
6721	1006526827	595127	1	28555809	2026-05-06 19:40:48
343	1051065897	593102	2	000000000	2026-04-30 19:07:39
6722	1006526827	595128	1	28555809	2026-05-06 19:40:48
6723	1006526827	595129	1	28555809	2026-05-06 19:40:48
6724	1006526827	595130	1	28555809	2026-05-06 19:40:48
6725	1006526827	595131	1	28555809	2026-05-06 19:40:48
6726	1006526827	595132	1	28555809	2026-05-06 19:40:48
6727	1006526827	595117	2	000000000	2026-05-06 19:40:48
6728	1006526827	595118	2	000000000	2026-05-06 19:40:48
6729	1006526827	595119	1	1077865671	2026-05-06 19:40:48
6730	1006526827	595120	1	1077865671	2026-05-06 19:40:48
344	1051065897	593103	1	1117523028	2025-11-28 09:11:00
6731	1006526827	595145	1	1117503960	2026-05-06 19:40:48
345	1051065897	593060	2	000000000	2026-04-30 19:07:39
6732	1006526827	595146	1	1117503960	2026-05-06 19:40:48
346	1051065897	593061	1	6801355	2025-07-23 11:07:00
6733	1006526827	595147	1	1117503960	2026-05-06 19:40:48
6734	1006526827	595148	1	1117503960	2026-05-06 19:40:48
6735	1006526827	595111	1	28555809	2026-05-06 19:40:48
6736	1006526827	595112	1	28555809	2026-05-06 19:40:48
6737	1006526827	595113	1	28555809	2026-05-06 19:40:48
6738	1006526827	595114	1	28555809	2026-05-06 19:40:48
6739	1006526827	595115	1	28555809	2026-05-06 19:40:48
6740	1006526827	595116	1	28555809	2026-05-06 19:40:48
6741	1006526827	644275	1	28555809	2026-05-06 19:40:48
6742	1006526827	644276	1	28555809	2026-05-06 19:40:48
6743	1006526827	644277	1	28555809	2026-05-06 19:40:48
6744	1006526827	644278	1	28555809	2026-05-06 19:40:48
6745	1006526827	644279	1	6801355	2026-05-06 19:40:48
6746	1006526827	644280	1	6801355	2026-05-06 19:40:48
6747	1006526827	644281	1	6801355	2026-05-06 19:40:48
6748	1006526827	644282	1	6801355	2026-05-06 19:40:48
6749	1006526827	644323	1	96353963	2026-05-06 19:40:48
6750	1006531207	595100	2	000000000	2026-05-06 19:40:48
6751	1006531207	595133	2	000000000	2026-05-06 19:40:48
6752	1006531207	595134	2	000000000	2026-05-06 19:40:48
347	1051065897	593062	2	000000000	2026-04-30 19:07:39
348	1051065897	593104	1	1117523028	2025-06-19 07:06:00
6753	1006531207	595135	2	000000000	2026-05-06 19:40:48
6754	1006531207	595136	2	000000000	2026-05-06 19:40:48
349	1051065897	593105	2	000000000	2026-04-30 19:07:39
6755	1006531207	595105	1	28555809	2026-05-06 19:40:48
6756	1006531207	595137	1	96353963	2026-05-06 19:40:48
6757	1006531207	595138	1	96353963	2026-05-06 19:40:48
6758	1006531207	595139	1	96353963	2026-05-06 19:40:48
350	1051065897	593106	1	1117523028	2025-11-28 09:11:00
6759	1006531207	595140	1	96353963	2026-05-06 19:40:48
6760	1006531207	595163	2	000000000	2026-05-06 19:40:48
6761	1006531207	595164	2	000000000	2026-05-06 19:40:48
6762	1006531207	595165	1	6805131	2026-05-06 19:40:48
351	1051065897	593107	2	000000000	2026-04-30 19:07:39
6763	1006531207	595166	2	000000000	2026-05-06 19:40:48
352	1051065897	593108	1	1117523028	2025-11-28 09:11:00
6764	1006531207	595167	2	000000000	2026-05-06 19:40:48
6765	1006531207	595168	2	000000000	2026-05-06 19:40:48
6766	1006531207	595101	1	40776309	2026-05-06 19:40:48
6767	1006531207	595102	2	000000000	2026-05-06 19:40:48
6768	1006531207	595103	1	40776309	2026-05-06 19:40:48
6769	1006531207	595104	2	000000000	2026-05-06 19:40:48
6770	1006531207	595149	2	000000000	2026-05-06 19:40:48
6771	1006531207	595150	2	000000000	2026-05-06 19:40:48
6772	1006531207	595151	2	000000000	2026-05-06 19:40:48
6773	1006531207	595152	2	000000000	2026-05-06 19:40:48
6774	1006531207	595141	2	000000000	2026-05-06 19:40:48
6775	1006531207	595142	2	000000000	2026-05-06 19:40:48
6776	1006531207	595143	2	000000000	2026-05-06 19:40:48
6777	1006531207	595144	2	000000000	2026-05-06 19:40:48
6778	1006531207	595158	2	000000000	2026-05-06 19:40:48
6779	1006531207	595159	2	000000000	2026-05-06 19:40:48
6780	1006531207	595160	2	000000000	2026-05-06 19:40:48
6781	1006531207	595161	2	000000000	2026-05-06 19:40:48
6782	1006531207	595162	2	000000000	2026-05-06 19:40:48
6783	1006531207	595106	2	000000000	2026-05-06 19:40:48
6784	1006531207	595107	2	000000000	2026-05-06 19:40:48
6785	1006531207	595108	2	000000000	2026-05-06 19:40:48
6786	1006531207	595109	2	000000000	2026-05-06 19:40:48
353	1051065897	593144	2	000000000	2026-04-30 19:07:39
6787	1006531207	595110	2	000000000	2026-05-06 19:40:48
354	1051065897	593145	2	000000000	2026-04-30 19:07:39
6788	1006531207	595125	1	28555809	2026-05-06 19:40:48
6789	1006531207	595126	1	28555809	2026-05-06 19:40:48
6790	1006531207	595127	1	28555809	2026-05-06 19:40:48
6791	1006531207	595128	1	28555809	2026-05-06 19:40:48
6792	1006531207	595129	1	28555809	2026-05-06 19:40:48
6793	1006531207	595130	1	28555809	2026-05-06 19:40:48
6794	1006531207	595131	1	28555809	2026-05-06 19:40:48
6795	1006531207	595132	1	28555809	2026-05-06 19:40:48
6796	1006531207	595117	2	000000000	2026-05-06 19:40:48
355	1051065897	593146	2	000000000	2026-04-30 19:07:39
6797	1006531207	595118	2	000000000	2026-05-06 19:40:48
356	1051065897	592373	2	000000000	2026-04-30 19:07:39
6798	1006531207	595119	2	000000000	2026-05-06 19:40:48
357	1051065897	592374	2	000000000	2026-04-30 19:07:39
6799	1006531207	595120	2	000000000	2026-05-06 19:40:48
6800	1006531207	595145	2	000000000	2026-05-06 19:40:48
6801	1006531207	595146	2	000000000	2026-05-06 19:40:48
6802	1006531207	595147	2	000000000	2026-05-06 19:40:48
6803	1006531207	595148	2	000000000	2026-05-06 19:40:48
6804	1006531207	595111	2	000000000	2026-05-06 19:40:48
358	1051065897	592375	1	96353963	2025-05-25 15:05:00
6805	1006531207	595112	2	000000000	2026-05-06 19:40:48
6806	1006531207	595113	2	000000000	2026-05-06 19:40:48
6807	1006531207	595114	2	000000000	2026-05-06 19:40:48
6808	1006531207	595115	2	000000000	2026-05-06 19:40:48
6809	1006531207	595116	2	000000000	2026-05-06 19:40:48
6810	1006531207	644275	2	000000000	2026-05-06 19:40:48
6811	1006531207	644276	2	000000000	2026-05-06 19:40:48
359	1051065897	592376	1	1117523028	2025-11-28 09:11:00
360	1051065897	593344	1	1117523028	2025-07-23 11:07:00
361	1051065897	593345	2	000000000	2026-04-30 19:07:39
362	1051065897	593346	1	1117523028	2025-07-23 11:07:00
363	1051065897	593347	2	000000000	2026-04-30 19:07:39
364	1051065897	593243	1	1117523028	2025-12-15 09:12:00
6812	1006531207	644277	2	000000000	2026-05-06 19:40:48
6813	1006531207	644278	2	000000000	2026-05-06 19:40:48
365	1051065897	593244	2	000000000	2026-04-30 19:07:39
6814	1006531207	644279	2	000000000	2026-05-06 19:40:48
6815	1006531207	644280	2	000000000	2026-05-06 19:40:48
366	1051065897	593245	2	000000000	2026-04-30 19:07:39
6816	1006531207	644281	2	000000000	2026-05-06 19:40:48
367	1051065897	593246	2	000000000	2026-04-30 19:07:39
368	1051065897	593255	1	40781077	2025-12-15 17:12:00
6817	1006531207	644282	2	000000000	2026-05-06 19:40:48
369	1051065897	593256	1	40781077	2025-04-30 18:04:00
6818	1006531207	644323	1	96353963	2026-05-06 19:40:48
370	1051065897	593257	1	40781077	2025-12-15 17:12:00
371	1051065897	593258	1	40781077	2025-12-05 09:12:00
372	1051065897	593259	1	40778471	2025-12-01 11:12:00
373	1051065897	593340	1	40778471	2025-12-01 11:12:00
374	1051065897	593341	1	40778471	2025-12-01 11:12:00
6819	1006537604	595100	2	000000000	2026-05-06 19:40:48
6820	1006537604	595133	2	000000000	2026-05-06 19:40:48
6821	1006537604	595134	2	000000000	2026-05-06 19:40:48
6822	1006537604	595135	2	000000000	2026-05-06 19:40:48
375	1051065897	593342	1	40778471	2025-12-01 11:12:00
376	1080361991	590803	2	000000000	2026-04-30 19:07:39
377	1080361991	593147	1	26632272	2025-11-25 09:11:00
6823	1006537604	595136	2	000000000	2026-05-06 19:40:48
6824	1006537604	595105	2	000000000	2026-05-06 19:40:48
6825	1006537604	595137	2	000000000	2026-05-06 19:40:48
6826	1006537604	595138	2	000000000	2026-05-06 19:40:48
6827	1006537604	595139	2	000000000	2026-05-06 19:40:48
6828	1006537604	595140	2	000000000	2026-05-06 19:40:48
378	1080361991	593148	1	26632272	2025-11-25 09:11:00
6829	1006537604	595163	2	000000000	2026-05-06 19:40:48
379	1080361991	593149	1	26632272	2025-11-25 09:11:00
380	1080361991	593150	1	26632272	2025-11-25 09:11:00
6830	1006537604	595164	2	000000000	2026-05-06 19:40:48
381	1080361991	593343	1	1117523028	2025-02-16 16:02:00
6831	1006537604	595165	2	000000000	2026-05-06 19:40:48
382	1080361991	593151	1	6801798	2025-03-24 11:03:00
6832	1006537604	595166	2	000000000	2026-05-06 19:40:48
383	1080361991	593152	2	000000000	2026-04-30 19:07:39
6833	1006537604	595167	2	000000000	2026-05-06 19:40:48
384	1080361991	593153	2	000000000	2026-04-30 19:07:39
6834	1006537604	595168	2	000000000	2026-05-06 19:40:48
385	1080361991	593154	1	6801798	2025-03-24 11:03:00
6835	1006537604	595101	2	000000000	2026-05-06 19:40:48
6836	1006537604	595102	2	000000000	2026-05-06 19:40:48
6837	1006537604	595103	2	000000000	2026-05-06 19:40:48
6838	1006537604	595104	2	000000000	2026-05-06 19:40:48
6839	1006537604	595149	2	000000000	2026-05-06 19:40:48
386	1080361991	593113	2	000000000	2026-04-30 19:07:39
387	1080361991	593114	2	000000000	2026-04-30 19:07:39
388	1080361991	593115	1	1117499177	2026-03-24 08:03:00
6840	1006537604	595150	2	000000000	2026-05-06 19:40:48
389	1080361991	593116	2	000000000	2026-04-30 19:07:39
6841	1006537604	595151	2	000000000	2026-05-06 19:40:48
390	1080361991	593117	1	1117546314	2025-06-21 10:06:00
6842	1006537604	595152	2	000000000	2026-05-06 19:40:48
6843	1006537604	595141	2	000000000	2026-05-06 19:40:48
6844	1006537604	595142	2	000000000	2026-05-06 19:40:48
391	1080361991	593118	1	1117499177	2026-03-24 08:03:00
392	1080361991	593155	2	000000000	2026-04-30 19:07:39
393	1080361991	593156	1	40776309	2025-11-25 19:11:00
394	1080361991	593157	2	000000000	2026-04-30 19:07:39
395	1080361991	593158	1	17654594	2025-06-02 19:06:00
396	1080361991	593119	1	17648908	2025-12-16 20:12:00
397	1080361991	593120	1	17648908	2025-04-24 12:04:00
398	1080361991	593121	1	17648908	2025-12-16 20:12:00
6845	1006537604	595143	2	000000000	2026-05-06 19:40:48
399	1080361991	593122	1	17648908	2025-12-16 20:12:00
400	1080361991	593159	2	000000000	2026-04-30 19:07:39
401	1080361991	593160	2	000000000	2026-04-30 19:07:39
402	1080361991	593161	2	000000000	2026-04-30 19:07:39
403	1080361991	593162	2	000000000	2026-04-30 19:07:39
404	1080361991	593224	1	1117515166	2026-03-16 18:03:00
6846	1006537604	595144	2	000000000	2026-05-06 19:40:48
6847	1006537604	595158	2	000000000	2026-05-06 19:40:48
405	1080361991	593225	1	1117515166	2025-11-26 17:11:00
6848	1006537604	595159	2	000000000	2026-05-06 19:40:48
6849	1006537604	595160	2	000000000	2026-05-06 19:40:48
406	1080361991	593226	1	1117515166	2026-03-16 18:03:00
6850	1006537604	595161	2	000000000	2026-05-06 19:40:48
407	1080361991	593227	1	1117515166	2025-11-26 17:11:00
408	1080361991	593235	2	000000000	2026-04-30 19:07:39
6851	1006537604	595162	2	000000000	2026-05-06 19:40:48
409	1080361991	593236	2	000000000	2026-04-30 19:07:39
6852	1006537604	595106	2	000000000	2026-05-06 19:40:48
410	1080361991	593237	2	000000000	2026-04-30 19:07:39
411	1080361991	593238	2	000000000	2026-04-30 19:07:39
412	1080361991	593109	2	000000000	2026-04-30 19:07:39
413	1080361991	593110	2	000000000	2026-04-30 19:07:39
414	1080361991	593111	1	96353963	2025-11-28 11:11:00
6853	1006537604	595107	2	000000000	2026-05-06 19:40:48
6854	1006537604	595108	2	000000000	2026-05-06 19:40:48
6855	1006537604	595109	2	000000000	2026-05-06 19:40:48
6856	1006537604	595110	2	000000000	2026-05-06 19:40:48
415	1080361991	593112	2	000000000	2026-04-30 19:07:39
416	1080361991	593100	1	1117523028	2025-11-28 09:11:00
417	1080361991	593101	1	1117523028	2025-11-28 09:11:00
418	1080361991	593102	2	000000000	2026-04-30 19:07:39
6857	1006537604	595125	2	000000000	2026-05-06 19:40:48
6858	1006537604	595126	2	000000000	2026-05-06 19:40:48
6859	1006537604	595127	2	000000000	2026-05-06 19:40:48
6860	1006537604	595128	2	000000000	2026-05-06 19:40:48
6861	1006537604	595129	2	000000000	2026-05-06 19:40:48
6862	1006537604	595130	2	000000000	2026-05-06 19:40:48
419	1080361991	593103	1	1117523028	2025-11-28 09:11:00
6863	1006537604	595131	2	000000000	2026-05-06 19:40:48
420	1080361991	593060	2	000000000	2026-04-30 19:07:39
421	1080361991	593061	1	6801355	2025-07-23 11:07:00
6864	1006537604	595132	2	000000000	2026-05-06 19:40:48
422	1080361991	593062	2	000000000	2026-04-30 19:07:39
6865	1006537604	595117	2	000000000	2026-05-06 19:40:48
423	1080361991	593104	1	1117523028	2025-06-19 07:06:00
6866	1006537604	595118	2	000000000	2026-05-06 19:40:48
424	1080361991	593105	2	000000000	2026-04-30 19:07:39
6867	1006537604	595119	2	000000000	2026-05-06 19:40:48
425	1080361991	593106	1	1117523028	2025-11-28 09:11:00
6868	1006537604	595120	2	000000000	2026-05-06 19:40:48
426	1080361991	593107	2	000000000	2026-04-30 19:07:39
6869	1006537604	595145	2	000000000	2026-05-06 19:40:48
6870	1006537604	595146	2	000000000	2026-05-06 19:40:48
6871	1006537604	595147	2	000000000	2026-05-06 19:40:48
6872	1006537604	595148	2	000000000	2026-05-06 19:40:48
6873	1006537604	595111	2	000000000	2026-05-06 19:40:48
427	1080361991	593108	1	1117523028	2025-11-28 09:11:00
428	1080361991	593144	2	000000000	2026-04-30 19:07:39
429	1080361991	593145	2	000000000	2026-04-30 19:07:39
6874	1006537604	595112	2	000000000	2026-05-06 19:40:48
430	1080361991	593146	2	000000000	2026-04-30 19:07:39
6875	1006537604	595113	2	000000000	2026-05-06 19:40:48
6876	1006537604	595114	2	000000000	2026-05-06 19:40:48
6877	1006537604	595115	2	000000000	2026-05-06 19:40:48
6878	1006537604	595116	2	000000000	2026-05-06 19:40:48
6879	1006537604	644275	2	000000000	2026-05-06 19:40:48
431	1080361991	592373	2	000000000	2026-04-30 19:07:39
432	1080361991	592374	2	000000000	2026-04-30 19:07:39
433	1080361991	592375	1	96353963	2025-05-25 15:05:00
434	1080361991	592376	1	1117523028	2025-11-28 09:11:00
435	1080361991	593344	1	1117523028	2025-07-23 11:07:00
436	1080361991	593345	2	000000000	2026-04-30 19:07:39
437	1080361991	593346	1	1117523028	2025-07-23 11:07:00
438	1080361991	593347	2	000000000	2026-04-30 19:07:39
6880	1006537604	644276	2	000000000	2026-05-06 19:40:48
6881	1006537604	644277	2	000000000	2026-05-06 19:40:48
6882	1006537604	644278	2	000000000	2026-05-06 19:40:48
6883	1006537604	644279	2	000000000	2026-05-06 19:40:48
6884	1006537604	644280	2	000000000	2026-05-06 19:40:48
439	1080361991	593243	1	1117523028	2025-12-15 09:12:00
6885	1006537604	644281	2	000000000	2026-05-06 19:40:48
6886	1006537604	644282	2	000000000	2026-05-06 19:40:48
6887	1006537604	644323	2	000000000	2026-05-06 19:40:48
440	1080361991	593244	2	000000000	2026-04-30 19:07:39
6888	1006539028	595100	2	000000000	2026-05-06 19:40:48
6889	1006539028	595133	1	26632272	2026-05-06 19:40:48
6890	1006539028	595134	1	26632272	2026-05-06 19:40:48
6891	1006539028	595135	1	26632272	2026-05-06 19:40:48
441	1080361991	593245	2	000000000	2026-04-30 19:07:39
6892	1006539028	595136	1	26632272	2026-05-06 19:40:48
6893	1006539028	595105	1	28555809	2026-05-06 19:40:48
6894	1006539028	595137	1	96353963	2026-05-06 19:40:48
6895	1006539028	595138	1	96353963	2026-05-06 19:40:48
442	1080361991	593246	2	000000000	2026-04-30 19:07:39
6896	1006539028	595139	1	96353963	2026-05-06 19:40:48
443	1080361991	593255	1	40781077	2025-12-15 17:12:00
6897	1006539028	595140	1	96353963	2026-05-06 19:40:48
6898	1006539028	595163	1	6805131	2026-05-06 19:40:48
6899	1006539028	595164	1	6805131	2026-05-06 19:40:48
6900	1006539028	595165	1	6805131	2026-05-06 19:40:48
6901	1006539028	595166	1	6805131	2026-05-06 19:40:48
6902	1006539028	595167	1	6805131	2026-05-06 19:40:48
6903	1006539028	595168	1	6805131	2026-05-06 19:40:48
6904	1006539028	595101	1	40776309	2026-05-06 19:40:48
6905	1006539028	595102	1	1026552707	2026-05-06 19:40:48
6906	1006539028	595103	1	40776309	2026-05-06 19:40:48
6907	1006539028	595104	1	1026552707	2026-05-06 19:40:48
6908	1006539028	595149	1	96328076	2026-05-06 19:40:48
6909	1006539028	595150	1	96328076	2026-05-06 19:40:48
6910	1006539028	595151	1	96328076	2026-05-06 19:40:48
6911	1006539028	595152	1	96328076	2026-05-06 19:40:48
6912	1006539028	595141	1	1117515166	2026-05-06 19:40:48
6913	1006539028	595142	1	1117515166	2026-05-06 19:40:48
6914	1006539028	595143	1	1117515166	2026-05-06 19:40:48
6915	1006539028	595144	1	1117515166	2026-05-06 19:40:48
6916	1006539028	595158	2	000000000	2026-05-06 19:40:48
6917	1006539028	595159	2	000000000	2026-05-06 19:40:48
6918	1006539028	595160	2	000000000	2026-05-06 19:40:48
6919	1006539028	595161	2	000000000	2026-05-06 19:40:48
6920	1006539028	595162	2	000000000	2026-05-06 19:40:48
6921	1006539028	595106	1	28555809	2026-05-06 19:40:48
6922	1006539028	595107	1	28555809	2026-05-06 19:40:48
6923	1006539028	595108	1	28555809	2026-05-06 19:40:48
6924	1006539028	595109	1	28555809	2026-05-06 19:40:48
6925	1006539028	595110	1	28555809	2026-05-06 19:40:48
6926	1006539028	595125	1	28555809	2026-05-06 19:40:48
6927	1006539028	595126	1	28555809	2026-05-06 19:40:48
6928	1006539028	595127	1	28555809	2026-05-06 19:40:48
6929	1006539028	595128	1	28555809	2026-05-06 19:40:48
6930	1006539028	595129	1	28555809	2026-05-06 19:40:48
6931	1006539028	595130	1	28555809	2026-05-06 19:40:48
444	1080361991	593256	1	40781077	2025-04-30 18:04:00
6932	1006539028	595131	1	28555809	2026-05-06 19:40:48
6933	1006539028	595132	1	28555809	2026-05-06 19:40:48
6934	1006539028	595117	2	000000000	2026-05-06 19:40:48
6935	1006539028	595118	2	000000000	2026-05-06 19:40:48
6936	1006539028	595119	1	1077865671	2026-05-06 19:40:48
6937	1006539028	595120	1	1077865671	2026-05-06 19:40:48
6938	1006539028	595145	1	1117503960	2026-05-06 19:40:48
6939	1006539028	595146	1	1117503960	2026-05-06 19:40:48
6940	1006539028	595147	1	1117503960	2026-05-06 19:40:48
6941	1006539028	595148	1	1117503960	2026-05-06 19:40:48
445	1080361991	593257	1	40781077	2025-12-15 17:12:00
6942	1006539028	595111	1	28555809	2026-05-06 19:40:48
6943	1006539028	595112	1	28555809	2026-05-06 19:40:48
6944	1006539028	595113	1	28555809	2026-05-06 19:40:48
6945	1006539028	595114	1	28555809	2026-05-06 19:40:48
6946	1006539028	595115	1	28555809	2026-05-06 19:40:48
6947	1006539028	595116	1	28555809	2026-05-06 19:40:48
6948	1006539028	644275	1	28555809	2026-05-06 19:40:48
6949	1006539028	644276	1	28555809	2026-05-06 19:40:48
6950	1006539028	644277	1	28555809	2026-05-06 19:40:48
6951	1006539028	644278	1	28555809	2026-05-06 19:40:48
6952	1006539028	644279	1	6801355	2026-05-06 19:40:48
446	1080361991	593258	1	40781077	2025-12-05 09:12:00
447	1080361991	593259	1	40778471	2025-12-01 11:12:00
6953	1006539028	644280	1	6801355	2026-05-06 19:40:48
6954	1006539028	644281	1	6801355	2026-05-06 19:40:48
448	1080361991	593340	1	40778471	2025-12-01 11:12:00
6955	1006539028	644282	1	6801355	2026-05-06 19:40:48
6956	1006539028	644323	1	96353963	2026-05-06 19:40:48
6957	1006632144	595100	2	000000000	2026-05-06 19:40:48
6958	1006632144	595133	1	26632272	2026-05-06 19:40:48
6959	1006632144	595134	1	26632272	2026-05-06 19:40:48
6960	1006632144	595135	1	26632272	2026-05-06 19:40:48
6961	1006632144	595136	1	26632272	2026-05-06 19:40:48
6962	1006632144	595105	1	28555809	2026-05-06 19:40:48
6963	1006632144	595137	1	96353963	2026-05-06 19:40:48
6964	1006632144	595138	1	96353963	2026-05-06 19:40:48
6965	1006632144	595139	1	96353963	2026-05-06 19:40:48
6966	1006632144	595140	1	96353963	2026-05-06 19:40:48
6967	1006632144	595163	1	6805131	2026-05-06 19:40:48
6968	1006632144	595164	1	6805131	2026-05-06 19:40:48
6969	1006632144	595165	1	6805131	2026-05-06 19:40:48
6970	1006632144	595166	1	6805131	2026-05-06 19:40:48
6971	1006632144	595167	1	6805131	2026-05-06 19:40:48
6972	1006632144	595168	1	6805131	2026-05-06 19:40:48
6973	1006632144	595101	1	40776309	2026-05-06 19:40:48
6974	1006632144	595102	1	1026552707	2026-05-06 19:40:48
6975	1006632144	595103	1	40776309	2026-05-06 19:40:48
6976	1006632144	595104	1	1026552707	2026-05-06 19:40:48
6977	1006632144	595149	1	96328076	2026-05-06 19:40:48
6978	1006632144	595150	1	96328076	2026-05-06 19:40:48
6979	1006632144	595151	1	96328076	2026-05-06 19:40:48
6980	1006632144	595152	1	96328076	2026-05-06 19:40:48
6981	1006632144	595141	2	000000000	2026-05-06 19:40:48
6982	1006632144	595142	2	000000000	2026-05-06 19:40:48
6983	1006632144	595143	2	000000000	2026-05-06 19:40:48
6984	1006632144	595144	2	000000000	2026-05-06 19:40:48
6985	1006632144	595158	2	000000000	2026-05-06 19:40:48
6986	1006632144	595159	2	000000000	2026-05-06 19:40:48
6987	1006632144	595160	2	000000000	2026-05-06 19:40:48
6988	1006632144	595161	2	000000000	2026-05-06 19:40:48
6989	1006632144	595162	2	000000000	2026-05-06 19:40:48
6990	1006632144	595106	1	28555809	2026-05-06 19:40:48
6991	1006632144	595107	1	28555809	2026-05-06 19:40:48
6992	1006632144	595108	1	28555809	2026-05-06 19:40:48
6993	1006632144	595109	1	28555809	2026-05-06 19:40:48
6994	1006632144	595110	1	28555809	2026-05-06 19:40:48
6995	1006632144	595125	1	28555809	2026-05-06 19:40:48
6996	1006632144	595126	1	28555809	2026-05-06 19:40:48
6997	1006632144	595127	1	28555809	2026-05-06 19:40:48
6998	1006632144	595128	1	28555809	2026-05-06 19:40:48
6999	1006632144	595129	1	28555809	2026-05-06 19:40:48
7000	1006632144	595130	1	28555809	2026-05-06 19:40:48
7001	1006632144	595131	1	28555809	2026-05-06 19:40:48
7002	1006632144	595132	1	28555809	2026-05-06 19:40:48
7003	1006632144	595117	2	000000000	2026-05-06 19:40:48
7004	1006632144	595118	2	000000000	2026-05-06 19:40:48
7005	1006632144	595119	1	1077865671	2026-05-06 19:40:48
7006	1006632144	595120	1	1077865671	2026-05-06 19:40:48
7007	1006632144	595145	1	1117503960	2026-05-06 19:40:48
7008	1006632144	595146	1	1117503960	2026-05-06 19:40:48
7009	1006632144	595147	1	1117503960	2026-05-06 19:40:49
7010	1006632144	595148	1	1117503960	2026-05-06 19:40:49
7011	1006632144	595111	1	28555809	2026-05-06 19:40:49
7012	1006632144	595112	1	28555809	2026-05-06 19:40:49
7013	1006632144	595113	1	28555809	2026-05-06 19:40:49
7014	1006632144	595114	1	28555809	2026-05-06 19:40:49
7015	1006632144	595115	1	28555809	2026-05-06 19:40:49
7016	1006632144	595116	1	28555809	2026-05-06 19:40:49
7017	1006632144	644275	1	28555809	2026-05-06 19:40:49
7018	1006632144	644276	1	28555809	2026-05-06 19:40:49
7019	1006632144	644277	1	28555809	2026-05-06 19:40:49
7020	1006632144	644278	1	28555809	2026-05-06 19:40:49
7021	1006632144	644279	1	6801355	2026-05-06 19:40:49
449	1080361991	593341	1	40778471	2025-12-01 11:12:00
450	1080361991	593342	1	40778471	2025-12-01 11:12:00
451	1084331945	590803	2	000000000	2026-04-30 19:07:39
452	1084331945	593147	1	26632272	2025-11-25 09:11:00
453	1084331945	593148	1	26632272	2025-11-25 09:11:00
454	1084331945	593149	1	26632272	2025-11-25 09:11:00
7022	1006632144	644280	1	6801355	2026-05-06 19:40:49
7023	1006632144	644281	1	6801355	2026-05-06 19:40:49
455	1084331945	593150	1	26632272	2025-11-25 09:11:00
7024	1006632144	644282	1	6801355	2026-05-06 19:40:49
7025	1006632144	644323	1	96353963	2026-05-06 19:40:49
456	1084331945	593343	1	1117523028	2025-02-16 16:02:00
7026	1010183747	595100	2	000000000	2026-05-06 19:40:49
457	1084331945	593151	1	6801798	2025-03-24 11:03:00
458	1084331945	593152	2	000000000	2026-04-30 19:07:39
7027	1010183747	595133	2	000000000	2026-05-06 19:40:49
459	1084331945	593153	2	000000000	2026-04-30 19:07:39
7028	1010183747	595134	2	000000000	2026-05-06 19:40:49
460	1084331945	593154	1	6801798	2025-03-24 11:03:00
461	1084331945	593113	2	000000000	2026-04-30 19:07:39
462	1084331945	593114	2	000000000	2026-04-30 19:07:39
463	1084331945	593115	1	1117499177	2026-03-24 08:03:00
464	1084331945	593116	2	000000000	2026-04-30 19:07:39
7029	1010183747	595135	2	000000000	2026-05-06 19:40:49
7030	1010183747	595136	2	000000000	2026-05-06 19:40:49
7031	1010183747	595105	1	28555809	2026-05-06 19:40:49
7032	1010183747	595137	2	000000000	2026-05-06 19:40:49
465	1084331945	593117	1	1117546314	2025-06-21 10:06:00
466	1084331945	593118	1	1117499177	2026-03-24 08:03:00
467	1084331945	593155	2	000000000	2026-04-30 19:07:39
468	1084331945	593156	1	40776309	2025-11-25 19:11:00
7033	1010183747	595138	2	000000000	2026-05-06 19:40:49
7034	1010183747	595139	2	000000000	2026-05-06 19:40:49
7035	1010183747	595140	2	000000000	2026-05-06 19:40:49
7036	1010183747	595163	2	000000000	2026-05-06 19:40:49
7037	1010183747	595164	2	000000000	2026-05-06 19:40:49
7038	1010183747	595165	1	6805131	2026-05-06 19:40:49
469	1084331945	593157	2	000000000	2026-04-30 19:07:39
7039	1010183747	595166	2	000000000	2026-05-06 19:40:49
470	1084331945	593158	1	17654594	2025-06-02 19:06:00
471	1084331945	593119	1	17648908	2025-12-16 20:12:00
7040	1010183747	595167	2	000000000	2026-05-06 19:40:49
472	1084331945	593120	1	17648908	2025-04-24 12:04:00
7041	1010183747	595168	2	000000000	2026-05-06 19:40:49
473	1084331945	593121	1	17648908	2025-12-16 20:12:00
7042	1010183747	595101	1	40776309	2026-05-06 19:40:49
474	1084331945	593122	1	17648908	2025-12-16 20:12:00
7043	1010183747	595102	2	000000000	2026-05-06 19:40:49
475	1084331945	593159	2	000000000	2026-04-30 19:07:39
7044	1010183747	595103	1	40776309	2026-05-06 19:40:49
476	1084331945	593160	2	000000000	2026-04-30 19:07:39
7045	1010183747	595104	2	000000000	2026-05-06 19:40:49
7046	1010183747	595149	2	000000000	2026-05-06 19:40:49
7047	1010183747	595150	2	000000000	2026-05-06 19:40:49
7048	1010183747	595151	2	000000000	2026-05-06 19:40:49
7049	1010183747	595152	2	000000000	2026-05-06 19:40:49
7050	1010183747	595141	2	000000000	2026-05-06 19:40:49
477	1084331945	593161	2	000000000	2026-04-30 19:07:39
478	1084331945	593162	2	000000000	2026-04-30 19:07:39
479	1084331945	593224	1	1117515166	2026-03-16 18:03:00
7051	1010183747	595142	2	000000000	2026-05-06 19:40:49
480	1084331945	593225	1	1117515166	2025-11-26 17:11:00
7052	1010183747	595143	2	000000000	2026-05-06 19:40:49
481	1084331945	593226	1	1117515166	2026-03-16 18:03:00
7053	1010183747	595144	2	000000000	2026-05-06 19:40:49
7054	1010183747	595158	2	000000000	2026-05-06 19:40:49
7055	1010183747	595159	2	000000000	2026-05-06 19:40:49
482	1084331945	593227	1	1117515166	2025-11-26 17:11:00
483	1084331945	593235	2	000000000	2026-04-30 19:07:39
484	1084331945	593236	2	000000000	2026-04-30 19:07:39
485	1084331945	593237	2	000000000	2026-04-30 19:07:39
486	1084331945	593238	2	000000000	2026-04-30 19:07:39
487	1084331945	593109	2	000000000	2026-04-30 19:07:39
488	1084331945	593110	2	000000000	2026-04-30 19:07:39
489	1084331945	593111	1	96353963	2025-11-28 11:11:00
7056	1010183747	595160	2	000000000	2026-05-06 19:40:49
490	1084331945	593112	2	000000000	2026-04-30 19:07:39
491	1084331945	593100	1	1117523028	2025-11-28 09:11:00
492	1084331945	593101	1	1117523028	2025-11-28 09:11:00
493	1084331945	593102	2	000000000	2026-04-30 19:07:39
494	1084331945	593103	1	1117523028	2025-11-28 09:11:00
495	1084331945	593060	2	000000000	2026-04-30 19:07:39
7057	1010183747	595161	2	000000000	2026-05-06 19:40:49
7058	1010183747	595162	2	000000000	2026-05-06 19:40:49
496	1084331945	593061	1	6801355	2025-07-23 11:07:00
7059	1010183747	595106	2	000000000	2026-05-06 19:40:49
7060	1010183747	595107	2	000000000	2026-05-06 19:40:49
497	1084331945	593062	2	000000000	2026-04-30 19:07:39
7061	1010183747	595108	2	000000000	2026-05-06 19:40:49
498	1084331945	593104	1	1117523028	2025-06-19 07:06:00
499	1084331945	593105	2	000000000	2026-04-30 19:07:39
7062	1010183747	595109	2	000000000	2026-05-06 19:40:49
500	1084331945	593106	1	1117523028	2025-11-28 09:11:00
7063	1010183747	595110	2	000000000	2026-05-06 19:40:49
501	1084331945	593107	2	000000000	2026-04-30 19:07:39
502	1084331945	593108	1	1117523028	2025-11-28 09:11:00
503	1084331945	593144	2	000000000	2026-04-30 19:07:39
504	1084331945	593145	2	000000000	2026-04-30 19:07:39
505	1084331945	593146	2	000000000	2026-04-30 19:07:39
7064	1010183747	595125	1	28555809	2026-05-06 19:40:49
7065	1010183747	595126	1	28555809	2026-05-06 19:40:49
7066	1010183747	595127	1	28555809	2026-05-06 19:40:49
7067	1010183747	595128	1	28555809	2026-05-06 19:40:49
506	1084331945	592373	2	000000000	2026-04-30 19:07:39
507	1084331945	592374	2	000000000	2026-04-30 19:07:39
508	1084331945	592375	1	96353963	2025-05-25 15:05:00
509	1084331945	592376	1	1117523028	2025-11-28 09:11:00
7068	1010183747	595129	1	28555809	2026-05-06 19:40:49
7069	1010183747	595130	1	28555809	2026-05-06 19:40:49
7070	1010183747	595131	1	28555809	2026-05-06 19:40:49
7071	1010183747	595132	1	28555809	2026-05-06 19:40:49
7072	1010183747	595117	2	000000000	2026-05-06 19:40:49
7073	1010183747	595118	2	000000000	2026-05-06 19:40:49
510	1084331945	593344	1	1117523028	2025-07-23 11:07:00
7074	1010183747	595119	2	000000000	2026-05-06 19:40:49
511	1084331945	593345	2	000000000	2026-04-30 19:07:39
512	1084331945	593346	1	1117523028	2025-07-23 11:07:00
7075	1010183747	595120	2	000000000	2026-05-06 19:40:49
513	1084331945	593347	2	000000000	2026-04-30 19:07:39
7076	1010183747	595145	2	000000000	2026-05-06 19:40:49
514	1084331945	593243	1	1117523028	2025-12-15 09:12:00
7077	1010183747	595146	2	000000000	2026-05-06 19:40:49
515	1084331945	593244	2	000000000	2026-04-30 19:07:39
7078	1010183747	595147	2	000000000	2026-05-06 19:40:49
516	1084331945	593245	2	000000000	2026-04-30 19:07:39
7079	1010183747	595148	2	000000000	2026-05-06 19:40:49
517	1084331945	593246	2	000000000	2026-04-30 19:07:39
7080	1010183747	595111	2	000000000	2026-05-06 19:40:49
7081	1010183747	595112	2	000000000	2026-05-06 19:40:49
7082	1010183747	595113	2	000000000	2026-05-06 19:40:49
7083	1010183747	595114	2	000000000	2026-05-06 19:40:49
7084	1010183747	595115	2	000000000	2026-05-06 19:40:49
518	1084331945	593255	1	40781077	2025-12-15 17:12:00
519	1084331945	593256	1	40781077	2025-04-30 18:04:00
520	1084331945	593257	1	40781077	2025-12-15 17:12:00
7085	1010183747	595116	2	000000000	2026-05-06 19:40:49
521	1084331945	593258	1	40781077	2025-12-05 09:12:00
7086	1010183747	644275	2	000000000	2026-05-06 19:40:49
522	1084331945	593259	1	40778471	2025-12-01 11:12:00
7087	1010183747	644276	2	000000000	2026-05-06 19:40:49
7088	1010183747	644277	2	000000000	2026-05-06 19:40:49
7089	1010183747	644278	2	000000000	2026-05-06 19:40:49
523	1084331945	593340	1	40778471	2025-12-01 11:12:00
524	1084331945	593341	1	40778471	2025-12-01 11:12:00
525	1084331945	593342	1	40778471	2025-12-01 11:12:00
526	1088255893	590803	2	000000000	2026-04-30 19:07:39
527	1088255893	593147	1	26632272	2025-11-25 09:11:00
528	1088255893	593148	1	26632272	2025-11-25 09:11:00
529	1088255893	593149	1	26632272	2025-11-25 09:11:00
530	1088255893	593150	1	26632272	2025-11-25 09:11:00
7090	1010183747	644279	2	000000000	2026-05-06 19:40:49
531	1088255893	593343	1	1117523028	2025-02-16 16:02:00
532	1088255893	593151	1	6801798	2025-03-24 11:03:00
533	1088255893	593152	2	000000000	2026-04-30 19:07:39
534	1088255893	593153	2	000000000	2026-04-30 19:07:39
535	1088255893	593154	1	6801798	2025-03-24 11:03:00
536	1088255893	593113	2	000000000	2026-04-30 19:07:39
7091	1010183747	644280	2	000000000	2026-05-06 19:40:49
7092	1010183747	644281	2	000000000	2026-05-06 19:40:49
537	1088255893	593114	2	000000000	2026-04-30 19:07:39
7093	1010183747	644282	2	000000000	2026-05-06 19:40:49
7094	1010183747	644323	2	000000000	2026-05-06 19:40:49
7095	1012317177	595100	2	000000000	2026-05-06 19:40:49
538	1088255893	593115	1	1117499177	2026-03-24 08:03:00
539	1088255893	593116	2	000000000	2026-04-30 19:07:39
7096	1012317177	595133	1	26632272	2026-05-06 19:40:49
540	1088255893	593117	1	1117546314	2025-06-21 10:06:00
7097	1012317177	595134	1	26632272	2026-05-06 19:40:49
541	1088255893	593118	1	1117499177	2026-03-24 08:03:00
542	1088255893	593155	2	000000000	2026-04-30 19:07:39
543	1088255893	593156	1	40776309	2025-11-25 19:11:00
544	1088255893	593157	2	000000000	2026-04-30 19:07:39
545	1088255893	593158	1	17654594	2025-06-02 19:06:00
7098	1012317177	595135	1	26632272	2026-05-06 19:40:49
7099	1012317177	595136	1	26632272	2026-05-06 19:40:49
7100	1012317177	595105	1	28555809	2026-05-06 19:40:49
7101	1012317177	595137	1	96353963	2026-05-06 19:40:49
546	1088255893	593119	1	17648908	2025-12-16 20:12:00
547	1088255893	593120	1	17648908	2025-04-24 12:04:00
548	1088255893	593121	1	17648908	2025-12-16 20:12:00
549	1088255893	593122	1	17648908	2025-12-16 20:12:00
7102	1012317177	595138	1	96353963	2026-05-06 19:40:49
7103	1012317177	595139	1	96353963	2026-05-06 19:40:49
7104	1012317177	595140	1	96353963	2026-05-06 19:40:49
7105	1012317177	595163	1	6805131	2026-05-06 19:40:49
7106	1012317177	595164	1	6805131	2026-05-06 19:40:49
7107	1012317177	595165	1	6805131	2026-05-06 19:40:49
550	1088255893	593159	2	000000000	2026-04-30 19:07:39
7108	1012317177	595166	1	6805131	2026-05-06 19:40:49
551	1088255893	593160	2	000000000	2026-04-30 19:07:39
552	1088255893	593161	2	000000000	2026-04-30 19:07:39
7109	1012317177	595167	1	6805131	2026-05-06 19:40:49
553	1088255893	593162	2	000000000	2026-04-30 19:07:39
7110	1012317177	595168	1	6805131	2026-05-06 19:40:49
554	1088255893	593224	1	1117515166	2026-03-16 18:03:00
7111	1012317177	595101	1	40776309	2026-05-06 19:40:49
555	1088255893	593225	1	1117515166	2025-11-26 17:11:00
7112	1012317177	595102	1	1026552707	2026-05-06 19:40:49
556	1088255893	593226	1	1117515166	2026-03-16 18:03:00
7113	1012317177	595103	1	40776309	2026-05-06 19:40:49
557	1088255893	593227	1	1117515166	2025-11-26 17:11:00
7114	1012317177	595104	1	1026552707	2026-05-06 19:40:49
7115	1012317177	595149	1	96328076	2026-05-06 19:40:49
7116	1012317177	595150	1	96328076	2026-05-06 19:40:49
7117	1012317177	595151	1	96328076	2026-05-06 19:40:49
7118	1012317177	595152	1	96328076	2026-05-06 19:40:49
558	1088255893	593235	2	000000000	2026-04-30 19:07:39
559	1088255893	593236	2	000000000	2026-04-30 19:07:39
560	1088255893	593237	2	000000000	2026-04-30 19:07:39
7119	1012317177	595141	1	1117515166	2026-05-06 19:40:49
561	1088255893	593238	2	000000000	2026-04-30 19:07:39
7120	1012317177	595142	1	1117515166	2026-05-06 19:40:49
562	1088255893	593109	2	000000000	2026-04-30 19:07:39
7121	1012317177	595143	1	1117515166	2026-05-06 19:40:49
7122	1012317177	595144	1	1117515166	2026-05-06 19:40:49
7123	1012317177	595158	2	000000000	2026-05-06 19:40:49
563	1088255893	593110	2	000000000	2026-04-30 19:07:39
564	1088255893	593111	1	96353963	2025-11-28 11:11:00
565	1088255893	593112	2	000000000	2026-04-30 19:07:39
566	1088255893	593100	1	1117523028	2025-11-28 09:11:00
567	1088255893	593101	1	1117523028	2025-11-28 09:11:00
568	1088255893	593102	2	000000000	2026-04-30 19:07:39
569	1088255893	593103	1	1117523028	2025-11-28 09:11:00
570	1088255893	593060	2	000000000	2026-04-30 19:07:39
7124	1012317177	595159	2	000000000	2026-05-06 19:40:49
571	1088255893	593061	1	6801355	2025-07-23 11:07:00
572	1088255893	593062	2	000000000	2026-04-30 19:07:39
573	1088255893	593104	1	1117523028	2025-06-19 07:06:00
574	1088255893	593105	2	000000000	2026-04-30 19:07:39
575	1088255893	593106	1	1117523028	2025-11-28 09:11:00
576	1088255893	593107	2	000000000	2026-04-30 19:07:39
7125	1012317177	595160	2	000000000	2026-05-06 19:40:49
7126	1012317177	595161	2	000000000	2026-05-06 19:40:49
577	1088255893	593108	1	1117523028	2025-11-28 09:11:00
7127	1012317177	595162	2	000000000	2026-05-06 19:40:49
7128	1012317177	595106	1	28555809	2026-05-06 19:40:49
578	1088255893	593144	2	000000000	2026-04-30 19:07:39
7129	1012317177	595107	1	28555809	2026-05-06 19:40:49
579	1088255893	593145	2	000000000	2026-04-30 19:07:39
580	1088255893	593146	2	000000000	2026-04-30 19:07:39
7130	1012317177	595108	1	28555809	2026-05-06 19:40:49
581	1088255893	592373	2	000000000	2026-04-30 19:07:39
7131	1012317177	595109	1	28555809	2026-05-06 19:40:49
582	1088255893	592374	2	000000000	2026-04-30 19:07:39
583	1088255893	592375	1	96353963	2025-05-25 15:05:00
584	1088255893	592376	1	1117523028	2025-11-28 09:11:00
585	1088255893	593344	1	1117523028	2025-07-23 11:07:00
586	1088255893	593345	2	000000000	2026-04-30 19:07:39
7132	1012317177	595110	1	28555809	2026-05-06 19:40:49
7133	1012317177	595125	1	28555809	2026-05-06 19:40:49
7134	1012317177	595126	1	28555809	2026-05-06 19:40:49
7135	1012317177	595127	1	28555809	2026-05-06 19:40:49
587	1088255893	593346	1	1117523028	2025-07-23 11:07:00
588	1088255893	593347	2	000000000	2026-04-30 19:07:39
589	1088255893	593243	1	1117523028	2025-12-15 09:12:00
590	1088255893	593244	2	000000000	2026-04-30 19:07:39
7136	1012317177	595128	1	28555809	2026-05-06 19:40:49
7137	1012317177	595129	1	28555809	2026-05-06 19:40:49
7138	1012317177	595130	1	28555809	2026-05-06 19:40:49
7139	1012317177	595131	1	28555809	2026-05-06 19:40:49
7140	1012317177	595132	1	28555809	2026-05-06 19:40:49
7141	1012317177	595117	2	000000000	2026-05-06 19:40:49
591	1088255893	593245	2	000000000	2026-04-30 19:07:39
7142	1012317177	595118	2	000000000	2026-05-06 19:40:49
592	1088255893	593246	2	000000000	2026-04-30 19:07:39
593	1088255893	593255	1	40781077	2025-12-15 17:12:00
7143	1012317177	595119	1	1077865671	2026-05-06 19:40:49
594	1088255893	593256	1	40781077	2025-04-30 18:04:00
7144	1012317177	595120	1	1077865671	2026-05-06 19:40:49
7145	1012317177	595145	1	1117503960	2026-05-06 19:40:49
7146	1012317177	595146	1	1117503960	2026-05-06 19:40:49
595	1088255893	593257	1	40781077	2025-12-15 17:12:00
7147	1012317177	595147	1	1117503960	2026-05-06 19:40:49
596	1088255893	593258	1	40781077	2025-12-05 09:12:00
7148	1012317177	595148	1	1117503960	2026-05-06 19:40:49
597	1088255893	593259	1	40778471	2025-12-01 10:12:00
7149	1012317177	595111	1	28555809	2026-05-06 19:40:49
7150	1012317177	595112	1	28555809	2026-05-06 19:40:49
7151	1012317177	595113	1	28555809	2026-05-06 19:40:49
7152	1012317177	595114	1	28555809	2026-05-06 19:40:49
7153	1012317177	595115	1	28555809	2026-05-06 19:40:49
598	1088255893	593340	1	40778471	2025-12-01 10:12:00
599	1088255893	593341	1	40778471	2025-12-01 10:12:00
600	1088255893	593342	1	40778471	2025-12-01 10:12:00
7154	1012317177	595116	1	28555809	2026-05-06 19:40:49
601	1099742508	590803	2	000000000	2026-04-30 19:07:39
7155	1012317177	644275	1	28555809	2026-05-06 19:40:49
602	1099742508	593147	1	26632272	2025-11-25 09:11:00
7156	1012317177	644276	1	28555809	2026-05-06 19:40:49
7157	1012317177	644277	1	28555809	2026-05-06 19:40:49
7158	1012317177	644278	1	28555809	2026-05-06 19:40:49
603	1099742508	593148	1	26632272	2025-11-25 09:11:00
604	1099742508	593149	1	26632272	2025-11-25 09:11:00
605	1099742508	593150	1	26632272	2025-11-25 09:11:00
606	1099742508	593343	1	1117523028	2025-02-16 16:02:00
607	1099742508	593151	1	6801798	2025-03-24 11:03:00
608	1099742508	593152	2	000000000	2026-04-30 19:07:39
609	1099742508	593153	2	000000000	2026-04-30 19:07:39
610	1099742508	593154	1	6801798	2025-03-24 11:03:00
7159	1012317177	644279	1	6801355	2026-05-06 19:40:49
611	1099742508	593113	2	000000000	2026-04-30 19:07:39
612	1099742508	593114	2	000000000	2026-04-30 19:07:39
613	1099742508	593115	1	1117499177	2026-03-24 08:03:00
614	1099742508	593116	2	000000000	2026-04-30 19:07:39
615	1099742508	593117	1	1117546314	2025-06-21 10:06:00
616	1099742508	593118	1	1117499177	2026-03-24 08:03:00
7160	1012317177	644280	1	6801355	2026-05-06 19:40:49
7161	1012317177	644281	1	6801355	2026-05-06 19:40:49
617	1099742508	593155	2	000000000	2026-04-30 19:07:39
7162	1012317177	644282	1	6801355	2026-05-06 19:40:49
7163	1012317177	644323	1	96353963	2026-05-06 19:40:49
618	1099742508	593156	1	40776309	2025-11-25 19:11:00
7164	1061728211	595100	2	000000000	2026-05-06 19:40:49
619	1099742508	593157	2	000000000	2026-04-30 19:07:39
620	1099742508	593158	1	17654594	2025-06-02 19:06:00
7165	1061728211	595133	1	26632272	2026-05-06 19:40:49
621	1099742508	593119	1	17648908	2025-12-16 20:12:00
7166	1061728211	595134	1	26632272	2026-05-06 19:40:49
622	1099742508	593120	1	17648908	2025-04-24 12:04:00
623	1099742508	593121	1	17648908	2025-12-16 20:12:00
624	1099742508	593122	1	17648908	2025-12-16 20:12:00
625	1099742508	593159	2	000000000	2026-04-30 19:07:39
626	1099742508	593160	2	000000000	2026-04-30 19:07:39
7167	1061728211	595135	1	26632272	2026-05-06 19:40:49
7168	1061728211	595136	1	26632272	2026-05-06 19:40:49
7169	1061728211	595105	1	28555809	2026-05-06 19:40:49
7170	1061728211	595137	1	96353963	2026-05-06 19:40:49
627	1099742508	593161	2	000000000	2026-04-30 19:07:39
628	1099742508	593162	2	000000000	2026-04-30 19:07:39
629	1099742508	593224	1	1117515166	2026-03-16 18:03:00
630	1099742508	593225	1	1117515166	2025-11-26 17:11:00
7171	1061728211	595138	1	96353963	2026-05-06 19:40:49
7172	1061728211	595139	1	96353963	2026-05-06 19:40:49
7173	1061728211	595140	1	96353963	2026-05-06 19:40:49
7174	1061728211	595163	1	6805131	2026-05-06 19:40:49
7175	1061728211	595164	1	6805131	2026-05-06 19:40:49
7176	1061728211	595165	1	6805131	2026-05-06 19:40:49
631	1099742508	593226	1	1117515166	2026-03-16 18:03:00
7177	1061728211	595166	1	6805131	2026-05-06 19:40:49
632	1099742508	593227	1	1117515166	2025-11-26 17:11:00
633	1099742508	593235	2	000000000	2026-04-30 19:07:39
7178	1061728211	595167	1	6805131	2026-05-06 19:40:49
634	1099742508	593236	2	000000000	2026-04-30 19:07:39
7179	1061728211	595168	1	6805131	2026-05-06 19:40:49
635	1099742508	593237	2	000000000	2026-04-30 19:07:39
7180	1061728211	595101	1	40776309	2026-05-06 19:40:49
636	1099742508	593238	2	000000000	2026-04-30 19:07:39
7181	1061728211	595102	1	1026552707	2026-05-06 19:40:49
637	1099742508	593109	2	000000000	2026-04-30 19:07:39
7182	1061728211	595103	1	40776309	2026-05-06 19:40:49
638	1099742508	593110	2	000000000	2026-04-30 19:07:39
7183	1061728211	595104	1	1026552707	2026-05-06 19:40:49
7184	1061728211	595149	1	96328076	2026-05-06 19:40:49
7185	1061728211	595150	1	96328076	2026-05-06 19:40:49
7186	1061728211	595151	1	96328076	2026-05-06 19:40:49
7187	1061728211	595152	1	96328076	2026-05-06 19:40:49
639	1099742508	593111	1	96353963	2025-11-28 11:11:00
640	1099742508	593112	2	000000000	2026-04-30 19:07:39
641	1099742508	593100	1	1117523028	2025-11-28 09:11:00
7188	1061728211	595141	1	1117515166	2026-05-06 19:40:49
642	1099742508	593101	1	1117523028	2025-11-28 09:11:00
7189	1061728211	595142	1	1117515166	2026-05-06 19:40:49
643	1099742508	593102	2	000000000	2026-04-30 19:07:39
7190	1061728211	595143	1	1117515166	2026-05-06 19:40:49
7191	1061728211	595144	1	1117515166	2026-05-06 19:40:49
7192	1061728211	595158	2	000000000	2026-05-06 19:40:49
644	1099742508	593103	1	1117523028	2025-11-28 09:11:00
645	1099742508	593060	2	000000000	2026-04-30 19:07:39
646	1099742508	593061	1	6801355	2025-07-23 11:07:00
647	1099742508	593062	2	000000000	2026-04-30 19:07:39
648	1099742508	593104	1	1117523028	2025-06-19 07:06:00
649	1099742508	593105	2	000000000	2026-04-30 19:07:39
650	1099742508	593106	1	1117523028	2025-11-28 09:11:00
651	1099742508	593107	2	000000000	2026-04-30 19:07:39
7193	1061728211	595159	2	000000000	2026-05-06 19:40:49
652	1099742508	593108	1	1117523028	2025-11-28 09:11:00
653	1099742508	593144	2	000000000	2026-04-30 19:07:39
7194	1061728211	595160	2	000000000	2026-05-06 19:40:49
654	1099742508	593145	2	000000000	2026-04-30 19:07:39
655	1099742508	593146	2	000000000	2026-04-30 19:07:39
656	1099742508	592373	2	000000000	2026-04-30 19:07:39
657	1099742508	592374	2	000000000	2026-04-30 19:07:39
7195	1061728211	595161	2	000000000	2026-05-06 19:40:49
7196	1061728211	595162	2	000000000	2026-05-06 19:40:49
658	1099742508	592375	1	96353963	2025-05-25 15:05:00
7197	1061728211	595106	1	28555809	2026-05-06 19:40:49
7198	1061728211	595107	1	28555809	2026-05-06 19:40:49
659	1099742508	592376	1	1117523028	2025-11-28 09:11:00
7199	1061728211	595108	1	28555809	2026-05-06 19:40:49
660	1099742508	593344	1	1117523028	2025-07-23 11:07:00
661	1099742508	593345	2	000000000	2026-04-30 19:07:39
7200	1061728211	595109	1	28555809	2026-05-06 19:40:49
662	1099742508	593346	1	1117523028	2025-07-23 11:07:00
7201	1061728211	595110	1	28555809	2026-05-06 19:40:49
663	1099742508	593347	2	000000000	2026-04-30 19:07:39
664	1099742508	593243	1	1117523028	2025-12-15 09:12:00
665	1099742508	593244	2	000000000	2026-04-30 19:07:39
666	1099742508	593245	2	000000000	2026-04-30 19:07:39
667	1099742508	593246	2	000000000	2026-04-30 19:07:39
7202	1061728211	595125	1	28555809	2026-05-06 19:40:49
7203	1061728211	595126	1	28555809	2026-05-06 19:40:49
7204	1061728211	595127	1	28555809	2026-05-06 19:40:49
7205	1061728211	595128	1	28555809	2026-05-06 19:40:49
668	1099742508	593255	1	40781077	2025-12-15 17:12:00
669	1099742508	593256	1	40781077	2025-04-30 18:04:00
670	1099742508	593257	1	40781077	2025-12-15 17:12:00
671	1099742508	593258	1	40781077	2025-12-05 09:12:00
7206	1061728211	595129	1	28555809	2026-05-06 19:40:49
7207	1061728211	595130	1	28555809	2026-05-06 19:40:49
7208	1061728211	595131	1	28555809	2026-05-06 19:40:49
7209	1061728211	595132	1	28555809	2026-05-06 19:40:49
7210	1061728211	595117	2	000000000	2026-05-06 19:40:49
7211	1061728211	595118	2	000000000	2026-05-06 19:40:49
672	1099742508	593259	1	40778471	2025-12-01 11:12:00
7212	1061728211	595119	1	1077865671	2026-05-06 19:40:49
673	1099742508	593340	1	40778471	2025-12-01 11:12:00
674	1099742508	593341	1	40778471	2025-12-01 11:12:00
7213	1061728211	595120	1	1077865671	2026-05-06 19:40:49
675	1099742508	593342	1	40778471	2025-12-01 11:12:00
7214	1061728211	595145	1	1117503960	2026-05-06 19:40:49
676	1115942896	590803	2	000000000	2026-04-30 19:07:39
7215	1061728211	595146	1	1117503960	2026-05-06 19:40:49
677	1115942896	593147	2	000000000	2026-04-30 19:07:39
7216	1061728211	595147	1	1117503960	2026-05-06 19:40:49
678	1115942896	593148	2	000000000	2026-04-30 19:07:39
7217	1061728211	595148	1	1117503960	2026-05-06 19:40:49
679	1115942896	593149	2	000000000	2026-04-30 19:07:39
7218	1061728211	595111	1	28555809	2026-05-06 19:40:49
7219	1061728211	595112	1	28555809	2026-05-06 19:40:49
7220	1061728211	595113	1	28555809	2026-05-06 19:40:49
7221	1061728211	595114	1	28555809	2026-05-06 19:40:49
7222	1061728211	595115	1	28555809	2026-05-06 19:40:49
680	1115942896	593150	2	000000000	2026-04-30 19:07:39
681	1115942896	593343	1	1117523028	2025-02-16 16:02:00
682	1115942896	593151	1	6801798	2025-03-24 11:03:00
7223	1061728211	595116	1	28555809	2026-05-06 19:40:49
683	1115942896	593152	2	000000000	2026-04-30 19:07:39
7224	1061728211	644275	1	28555809	2026-05-06 19:40:49
684	1115942896	593153	2	000000000	2026-04-30 19:07:39
7225	1061728211	644276	1	28555809	2026-05-06 19:40:49
7226	1061728211	644277	1	28555809	2026-05-06 19:40:49
7227	1061728211	644278	1	28555809	2026-05-06 19:40:49
685	1115942896	593154	1	6801798	2025-03-24 11:03:00
686	1115942896	593113	2	000000000	2026-04-30 19:07:39
687	1115942896	593114	2	000000000	2026-04-30 19:07:39
688	1115942896	593115	2	000000000	2026-04-30 19:07:39
689	1115942896	593116	2	000000000	2026-04-30 19:07:39
690	1115942896	593117	1	1117546314	2025-06-21 10:06:00
691	1115942896	593118	2	000000000	2026-04-30 19:07:39
692	1115942896	593155	2	000000000	2026-04-30 19:07:39
7228	1061728211	644279	1	6801355	2026-05-06 19:40:49
693	1115942896	593156	2	000000000	2026-04-30 19:07:39
694	1115942896	593157	2	000000000	2026-04-30 19:07:39
695	1115942896	593158	1	17654594	2025-06-02 19:06:00
696	1115942896	593119	2	000000000	2026-04-30 19:07:40
697	1115942896	593120	1	17648908	2025-04-24 12:04:00
698	1115942896	593121	2	000000000	2026-04-30 19:07:40
7229	1061728211	644280	1	6801355	2026-05-06 19:40:49
7230	1061728211	644281	1	6801355	2026-05-06 19:40:49
699	1115942896	593122	2	000000000	2026-04-30 19:07:40
7231	1061728211	644282	1	6801355	2026-05-06 19:40:49
7232	1061728211	644323	1	96353963	2026-05-06 19:40:49
700	1115942896	593159	2	000000000	2026-04-30 19:07:40
7233	1116202192	595100	2	000000000	2026-05-06 19:40:49
701	1115942896	593160	2	000000000	2026-04-30 19:07:40
702	1115942896	593161	2	000000000	2026-04-30 19:07:40
7234	1116202192	595133	1	26632272	2026-05-06 19:40:49
703	1115942896	593162	2	000000000	2026-04-30 19:07:40
7235	1116202192	595134	1	26632272	2026-05-06 19:40:49
704	1115942896	593224	2	000000000	2026-04-30 19:07:40
705	1115942896	593225	2	000000000	2026-04-30 19:07:40
706	1115942896	593226	2	000000000	2026-04-30 19:07:40
707	1115942896	593227	2	000000000	2026-04-30 19:07:40
708	1115942896	593235	2	000000000	2026-04-30 19:07:40
7236	1116202192	595135	1	26632272	2026-05-06 19:40:49
7237	1116202192	595136	1	26632272	2026-05-06 19:40:49
7238	1116202192	595105	1	28555809	2026-05-06 19:40:49
7239	1116202192	595137	1	96353963	2026-05-06 19:40:49
709	1115942896	593236	2	000000000	2026-04-30 19:07:40
710	1115942896	593237	2	000000000	2026-04-30 19:07:40
711	1115942896	593238	2	000000000	2026-04-30 19:07:40
7240	1116202192	595138	1	96353963	2026-05-06 19:40:49
7241	1116202192	595139	1	96353963	2026-05-06 19:40:49
7242	1116202192	595140	1	96353963	2026-05-06 19:40:49
7243	1116202192	595163	1	6805131	2026-05-06 19:40:49
7244	1116202192	595164	1	6805131	2026-05-06 19:40:49
7245	1116202192	595165	1	6805131	2026-05-06 19:40:49
7246	1116202192	595166	1	6805131	2026-05-06 19:40:49
712	1115942896	593109	2	000000000	2026-04-30 19:07:40
7247	1116202192	595167	1	6805131	2026-05-06 19:40:49
713	1115942896	593110	2	000000000	2026-04-30 19:07:40
714	1115942896	593111	2	000000000	2026-04-30 19:07:40
7248	1116202192	595168	1	6805131	2026-05-06 19:40:49
715	1115942896	593112	2	000000000	2026-04-30 19:07:40
7249	1116202192	595101	1	40776309	2026-05-06 19:40:49
7250	1116202192	595102	1	1026552707	2026-05-06 19:40:49
7251	1116202192	595103	1	40776309	2026-05-06 19:40:49
716	1115942896	593100	2	000000000	2026-04-30 19:07:40
7252	1116202192	595104	1	1026552707	2026-05-06 19:40:49
717	1115942896	593101	2	000000000	2026-04-30 19:07:40
7253	1116202192	595149	1	96328076	2026-05-06 19:40:49
718	1115942896	593102	2	000000000	2026-04-30 19:07:40
7254	1116202192	595150	1	96328076	2026-05-06 19:40:49
7255	1116202192	595151	1	96328076	2026-05-06 19:40:49
7256	1116202192	595152	1	96328076	2026-05-06 19:40:49
7257	1116202192	595141	2	000000000	2026-05-06 19:40:49
7258	1116202192	595142	2	000000000	2026-05-06 19:40:49
719	1115942896	593103	2	000000000	2026-04-30 19:07:40
720	1115942896	593060	2	000000000	2026-04-30 19:07:40
721	1115942896	593061	1	6801355	2025-07-23 11:07:00
7259	1116202192	595143	2	000000000	2026-05-06 19:40:49
722	1115942896	593062	2	000000000	2026-04-30 19:07:40
7260	1116202192	595144	2	000000000	2026-05-06 19:40:49
723	1115942896	593104	1	1117523028	2025-06-19 07:06:00
7261	1116202192	595158	2	000000000	2026-05-06 19:40:49
7262	1116202192	595159	2	000000000	2026-05-06 19:40:49
7263	1116202192	595160	2	000000000	2026-05-06 19:40:49
724	1115942896	593105	2	000000000	2026-04-30 19:07:40
725	1115942896	593106	2	000000000	2026-04-30 19:07:40
726	1115942896	593107	2	000000000	2026-04-30 19:07:40
727	1115942896	593108	2	000000000	2026-04-30 19:07:40
728	1115942896	593144	2	000000000	2026-04-30 19:07:40
729	1115942896	593145	2	000000000	2026-04-30 19:07:40
730	1115942896	593146	2	000000000	2026-04-30 19:07:40
731	1115942896	592373	2	000000000	2026-04-30 19:07:40
7264	1116202192	595161	2	000000000	2026-05-06 19:40:49
732	1115942896	592374	2	000000000	2026-04-30 19:07:40
733	1115942896	592375	1	96353963	2025-05-25 15:05:00
734	1115942896	592376	2	000000000	2026-04-30 19:07:40
735	1115942896	593344	1	1117523028	2025-07-23 11:07:00
736	1115942896	593345	2	000000000	2026-04-30 19:07:40
737	1115942896	593346	1	1117523028	2025-07-23 11:07:00
7265	1116202192	595162	2	000000000	2026-05-06 19:40:49
7266	1116202192	595106	1	28555809	2026-05-06 19:40:49
738	1115942896	593347	2	000000000	2026-04-30 19:07:40
7267	1116202192	595107	1	28555809	2026-05-06 19:40:49
7268	1116202192	595108	1	28555809	2026-05-06 19:40:49
739	1115942896	593243	2	000000000	2026-04-30 19:07:40
7269	1116202192	595109	1	28555809	2026-05-06 19:40:49
740	1115942896	593244	2	000000000	2026-04-30 19:07:40
741	1115942896	593245	2	000000000	2026-04-30 19:07:40
7270	1116202192	595110	1	28555809	2026-05-06 19:40:49
742	1115942896	593246	2	000000000	2026-04-30 19:07:40
7271	1116202192	595125	1	28555809	2026-05-06 19:40:49
743	1115942896	593255	2	000000000	2026-04-30 19:07:40
744	1115942896	593256	1	40781077	2025-04-30 18:04:00
745	1115942896	593257	2	000000000	2026-04-30 19:07:40
746	1115942896	593258	2	000000000	2026-04-30 19:07:40
747	1115942896	593259	2	000000000	2026-04-30 19:07:40
7272	1116202192	595126	1	28555809	2026-05-06 19:40:49
7273	1116202192	595127	1	28555809	2026-05-06 19:40:49
7274	1116202192	595128	1	28555809	2026-05-06 19:40:49
7275	1116202192	595129	1	28555809	2026-05-06 19:40:49
748	1115942896	593340	2	000000000	2026-04-30 19:07:40
749	1115942896	593341	2	000000000	2026-04-30 19:07:40
750	1115942896	593342	2	000000000	2026-04-30 19:07:40
751	1116204178	590803	2	000000000	2026-04-30 19:07:40
7276	1116202192	595130	1	28555809	2026-05-06 19:40:49
7277	1116202192	595131	1	28555809	2026-05-06 19:40:49
7278	1116202192	595132	1	28555809	2026-05-06 19:40:49
7279	1116202192	595117	2	000000000	2026-05-06 19:40:49
7280	1116202192	595118	2	000000000	2026-05-06 19:40:49
7281	1116202192	595119	1	1077865671	2026-05-06 19:40:49
752	1116204178	593147	2	000000000	2026-04-30 19:07:40
7282	1116202192	595120	1	1077865671	2026-05-06 19:40:49
753	1116204178	593148	2	000000000	2026-04-30 19:07:40
754	1116204178	593149	2	000000000	2026-04-30 19:07:40
7283	1116202192	595145	1	1117503960	2026-05-06 19:40:49
755	1116204178	593150	2	000000000	2026-04-30 19:07:40
7284	1116202192	595146	1	1117503960	2026-05-06 19:40:49
756	1116204178	593343	1	1117523028	2025-02-16 16:02:00
7285	1116202192	595147	1	1117503960	2026-05-06 19:40:49
757	1116204178	593151	1	6801798	2025-03-24 11:03:00
7286	1116202192	595148	1	1117503960	2026-05-06 19:40:49
758	1116204178	593152	2	000000000	2026-04-30 19:07:40
7287	1116202192	595111	1	28555809	2026-05-06 19:40:49
759	1116204178	593153	2	000000000	2026-04-30 19:07:40
7288	1116202192	595112	1	28555809	2026-05-06 19:40:49
7289	1116202192	595113	1	28555809	2026-05-06 19:40:49
7290	1116202192	595114	1	28555809	2026-05-06 19:40:49
7291	1116202192	595115	1	28555809	2026-05-06 19:40:49
7292	1116202192	595116	1	28555809	2026-05-06 19:40:49
760	1116204178	593154	1	6801798	2025-03-24 11:03:00
761	1116204178	593113	2	000000000	2026-04-30 19:07:40
762	1116204178	593114	2	000000000	2026-04-30 19:07:40
7293	1116202192	644275	1	28555809	2026-05-06 19:40:49
763	1116204178	593115	2	000000000	2026-04-30 19:07:40
7294	1116202192	644276	1	28555809	2026-05-06 19:40:49
764	1116204178	593116	2	000000000	2026-04-30 19:07:40
7295	1116202192	644277	1	28555809	2026-05-06 19:40:49
7296	1116202192	644278	1	28555809	2026-05-06 19:40:49
7297	1116202192	644279	2	000000000	2026-05-06 19:40:49
765	1116204178	593117	1	1117546314	2025-06-21 10:06:00
7298	1116202192	644280	2	000000000	2026-05-06 19:40:49
766	1116204178	593118	2	000000000	2026-04-30 19:07:40
767	1116204178	593155	2	000000000	2026-04-30 19:07:40
768	1116204178	593156	2	000000000	2026-04-30 19:07:40
769	1116204178	593157	2	000000000	2026-04-30 19:07:40
770	1116204178	593158	1	17654594	2025-06-02 19:06:00
771	1116204178	593119	2	000000000	2026-04-30 19:07:40
772	1116204178	593120	1	17648908	2025-04-24 12:04:00
7299	1116202192	644281	2	000000000	2026-05-06 19:40:49
773	1116204178	593121	2	000000000	2026-04-30 19:07:40
774	1116204178	593122	2	000000000	2026-04-30 19:07:40
775	1116204178	593159	2	000000000	2026-04-30 19:07:40
776	1116204178	593160	2	000000000	2026-04-30 19:07:40
777	1116204178	593161	2	000000000	2026-04-30 19:07:40
778	1116204178	593162	2	000000000	2026-04-30 19:07:40
7300	1116202192	644282	2	000000000	2026-05-06 19:40:49
7301	1116202192	644323	1	96353963	2026-05-06 19:40:49
779	1116204178	593224	2	000000000	2026-04-30 19:07:40
7302	1117484194	595100	2	000000000	2026-05-06 19:40:49
7303	1117484194	595133	1	26632272	2026-05-06 19:40:49
780	1116204178	593225	2	000000000	2026-04-30 19:07:40
7304	1117484194	595134	1	26632272	2026-05-06 19:40:49
781	1116204178	593226	2	000000000	2026-04-30 19:07:40
782	1116204178	593227	2	000000000	2026-04-30 19:07:40
7305	1117484194	595135	1	26632272	2026-05-06 19:40:49
783	1116204178	593235	2	000000000	2026-04-30 19:07:40
7306	1117484194	595136	1	26632272	2026-05-06 19:40:49
784	1116204178	593236	2	000000000	2026-04-30 19:07:40
785	1116204178	593237	2	000000000	2026-04-30 19:07:40
786	1116204178	593238	2	000000000	2026-04-30 19:07:40
787	1116204178	593109	2	000000000	2026-04-30 19:07:40
788	1116204178	593110	2	000000000	2026-04-30 19:07:40
7307	1117484194	595105	1	28555809	2026-05-06 19:40:49
7308	1117484194	595137	1	96353963	2026-05-06 19:40:49
7309	1117484194	595138	1	96353963	2026-05-06 19:40:49
7310	1117484194	595139	1	96353963	2026-05-06 19:40:49
789	1116204178	593111	2	000000000	2026-04-30 19:07:40
790	1116204178	593112	2	000000000	2026-04-30 19:07:40
791	1116204178	593100	2	000000000	2026-04-30 19:07:40
792	1116204178	593101	2	000000000	2026-04-30 19:07:40
7311	1117484194	595140	1	96353963	2026-05-06 19:40:49
7312	1117484194	595163	1	6805131	2026-05-06 19:40:49
7313	1117484194	595164	1	6805131	2026-05-06 19:40:49
7314	1117484194	595165	1	6805131	2026-05-06 19:40:49
7315	1117484194	595166	1	6805131	2026-05-06 19:40:49
7316	1117484194	595167	1	6805131	2026-05-06 19:40:49
793	1116204178	593102	2	000000000	2026-04-30 19:07:40
7317	1117484194	595168	1	6805131	2026-05-06 19:40:49
794	1116204178	593103	2	000000000	2026-04-30 19:07:40
795	1116204178	593060	2	000000000	2026-04-30 19:07:40
7318	1117484194	595101	1	40776309	2026-05-06 19:40:49
796	1116204178	593061	1	6801355	2025-07-23 11:07:00
7319	1117484194	595102	1	1026552707	2026-05-06 19:40:49
797	1116204178	593062	2	000000000	2026-04-30 19:07:40
7320	1117484194	595103	1	40776309	2026-05-06 19:40:49
798	1116204178	593104	1	1117523028	2025-06-19 07:06:00
7321	1117484194	595104	1	1026552707	2026-05-06 19:40:49
799	1116204178	593105	2	000000000	2026-04-30 19:07:40
7322	1117484194	595149	1	96328076	2026-05-06 19:40:49
800	1116204178	593106	2	000000000	2026-04-30 19:07:40
7323	1117484194	595150	1	96328076	2026-05-06 19:40:49
7324	1117484194	595151	1	96328076	2026-05-06 19:40:49
7325	1117484194	595152	1	96328076	2026-05-06 19:40:49
7326	1117484194	595141	2	000000000	2026-05-06 19:40:49
7327	1117484194	595142	2	000000000	2026-05-06 19:40:49
801	1116204178	593107	2	000000000	2026-04-30 19:07:40
802	1116204178	593108	2	000000000	2026-04-30 19:07:40
803	1116204178	593144	2	000000000	2026-04-30 19:07:40
7328	1117484194	595143	2	000000000	2026-05-06 19:40:49
804	1116204178	593145	2	000000000	2026-04-30 19:07:40
7329	1117484194	595144	2	000000000	2026-05-06 19:40:49
805	1116204178	593146	2	000000000	2026-04-30 19:07:40
7330	1117484194	595158	2	000000000	2026-05-06 19:40:49
7331	1117484194	595159	2	000000000	2026-05-06 19:40:49
7332	1117484194	595160	2	000000000	2026-05-06 19:40:49
806	1116204178	592373	2	000000000	2026-04-30 19:07:40
807	1116204178	592374	2	000000000	2026-04-30 19:07:40
808	1116204178	592375	1	96353963	2025-05-25 15:05:00
809	1116204178	592376	2	000000000	2026-04-30 19:07:40
810	1116204178	593344	1	1117523028	2025-07-23 11:07:00
811	1116204178	593345	2	000000000	2026-04-30 19:07:40
812	1116204178	593346	1	1117523028	2025-07-23 11:07:00
813	1116204178	593347	2	000000000	2026-04-30 19:07:40
7333	1117484194	595161	2	000000000	2026-05-06 19:40:49
814	1116204178	593243	2	000000000	2026-04-30 19:07:40
815	1116204178	593244	2	000000000	2026-04-30 19:07:40
816	1116204178	593245	2	000000000	2026-04-30 19:07:40
817	1116204178	593246	2	000000000	2026-04-30 19:07:40
818	1116204178	593255	2	000000000	2026-04-30 19:07:40
819	1116204178	593256	1	40781077	2025-04-30 18:04:00
7334	1117484194	595162	2	000000000	2026-05-06 19:40:49
7335	1117484194	595106	1	28555809	2026-05-06 19:40:49
820	1116204178	593257	2	000000000	2026-04-30 19:07:40
7336	1117484194	595107	1	28555809	2026-05-06 19:40:49
7337	1117484194	595108	1	28555809	2026-05-06 19:40:49
821	1116204178	593258	2	000000000	2026-04-30 19:07:40
7338	1117484194	595109	1	28555809	2026-05-06 19:40:49
822	1116204178	593259	2	000000000	2026-04-30 19:07:40
823	1116204178	593340	2	000000000	2026-04-30 19:07:40
7339	1117484194	595110	1	28555809	2026-05-06 19:40:49
824	1116204178	593341	2	000000000	2026-04-30 19:07:40
7340	1117484194	595125	1	28555809	2026-05-06 19:40:49
825	1116204178	593342	2	000000000	2026-04-30 19:07:40
826	1116205722	590803	2	000000000	2026-04-30 19:07:40
827	1116205722	593147	1	26632272	2025-11-25 09:11:00
828	1116205722	593148	1	26632272	2025-11-25 09:11:00
7341	1117484194	595126	1	28555809	2026-05-06 19:40:49
7342	1117484194	595127	1	28555809	2026-05-06 19:40:49
7343	1117484194	595128	1	28555809	2026-05-06 19:40:49
7344	1117484194	595129	1	28555809	2026-05-06 19:40:49
7345	1117484194	595130	1	28555809	2026-05-06 19:40:49
829	1116205722	593149	1	26632272	2025-11-25 09:11:00
830	1116205722	593150	1	26632272	2025-11-25 09:11:00
831	1116205722	593343	1	1117523028	2025-02-16 16:02:00
832	1116205722	593151	1	6801798	2025-03-24 11:03:00
7346	1117484194	595131	1	28555809	2026-05-06 19:40:49
7347	1117484194	595132	1	28555809	2026-05-06 19:40:49
7348	1117484194	595117	2	000000000	2026-05-06 19:40:49
7349	1117484194	595118	2	000000000	2026-05-06 19:40:49
7350	1117484194	595119	1	1077865671	2026-05-06 19:40:49
7351	1117484194	595120	1	1077865671	2026-05-06 19:40:49
833	1116205722	593152	2	000000000	2026-04-30 19:07:40
7352	1117484194	595145	1	1117503960	2026-05-06 19:40:49
834	1116205722	593153	2	000000000	2026-04-30 19:07:40
835	1116205722	593154	1	6801798	2025-03-24 11:03:00
7353	1117484194	595146	1	1117503960	2026-05-06 19:40:49
836	1116205722	593113	2	000000000	2026-04-30 19:07:40
7354	1117484194	595147	1	1117503960	2026-05-06 19:40:49
7355	1117484194	595148	1	1117503960	2026-05-06 19:40:49
7356	1117484194	595111	1	28555809	2026-05-06 19:40:49
837	1116205722	593114	2	000000000	2026-04-30 19:07:40
7357	1117484194	595112	1	28555809	2026-05-06 19:40:49
838	1116205722	593115	1	1117499177	2026-03-24 08:03:00
7358	1117484194	595113	1	28555809	2026-05-06 19:40:49
839	1116205722	593116	2	000000000	2026-04-30 19:07:40
7359	1117484194	595114	1	28555809	2026-05-06 19:40:49
7360	1117484194	595115	1	28555809	2026-05-06 19:40:49
7361	1117484194	595116	1	28555809	2026-05-06 19:40:49
7362	1117484194	644275	1	28555809	2026-05-06 19:40:49
7363	1117484194	644276	1	28555809	2026-05-06 19:40:49
840	1116205722	593117	1	1117546314	2025-06-21 10:06:00
841	1116205722	593118	1	1117499177	2026-03-24 08:03:00
842	1116205722	593155	2	000000000	2026-04-30 19:07:40
7364	1117484194	644277	1	28555809	2026-05-06 19:40:49
843	1116205722	593156	1	40776309	2025-11-25 19:11:00
7365	1117484194	644278	1	28555809	2026-05-06 19:40:49
844	1116205722	593157	2	000000000	2026-04-30 19:07:40
7366	1117484194	644279	1	6801355	2026-05-06 19:40:49
7367	1117484194	644280	1	6801355	2026-05-06 19:40:49
7368	1117484194	644281	1	6801355	2026-05-06 19:40:49
845	1116205722	593158	1	17654594	2025-06-02 19:06:00
846	1116205722	593119	1	17648908	2025-12-16 20:12:00
847	1116205722	593120	1	17648908	2025-04-24 12:04:00
848	1116205722	593121	1	17648908	2025-12-16 20:12:00
849	1116205722	593122	1	17648908	2025-12-16 20:12:00
850	1116205722	593159	2	000000000	2026-04-30 19:07:40
851	1116205722	593160	2	000000000	2026-04-30 19:07:40
852	1116205722	593161	2	000000000	2026-04-30 19:07:40
7369	1117484194	644282	1	6801355	2026-05-06 19:40:50
853	1116205722	593162	2	000000000	2026-04-30 19:07:40
854	1116205722	593224	1	1117515166	2026-03-16 18:03:00
855	1116205722	593225	1	1117515166	2025-11-26 17:11:00
856	1116205722	593226	1	1117515166	2026-03-16 18:03:00
857	1116205722	593227	1	1117515166	2025-11-26 17:11:00
858	1116205722	593235	2	000000000	2026-04-30 19:07:40
7370	1117484194	644323	1	96353963	2026-05-06 19:40:50
7371	1117487072	595100	2	000000000	2026-05-06 19:40:50
859	1116205722	593236	2	000000000	2026-04-30 19:07:40
7372	1117487072	595133	1	26632272	2026-05-06 19:40:50
7373	1117487072	595134	1	26632272	2026-05-06 19:40:50
860	1116205722	593237	2	000000000	2026-04-30 19:07:40
7374	1117487072	595135	1	26632272	2026-05-06 19:40:50
861	1116205722	593238	2	000000000	2026-04-30 19:07:40
862	1116205722	593109	2	000000000	2026-04-30 19:07:40
7375	1117487072	595136	1	26632272	2026-05-06 19:40:50
863	1116205722	593110	2	000000000	2026-04-30 19:07:40
7376	1117487072	595105	1	28555809	2026-05-06 19:40:50
864	1116205722	593111	1	96353963	2025-11-28 11:11:00
865	1116205722	593112	2	000000000	2026-04-30 19:07:40
866	1116205722	593100	1	1117523028	2025-11-28 09:11:00
867	1116205722	593101	1	1117523028	2025-11-28 09:11:00
868	1116205722	593102	2	000000000	2026-04-30 19:07:40
7377	1117487072	595137	1	96353963	2026-05-06 19:40:50
7378	1117487072	595138	1	96353963	2026-05-06 19:40:50
7379	1117487072	595139	1	96353963	2026-05-06 19:40:50
7380	1117487072	595140	1	96353963	2026-05-06 19:40:50
869	1116205722	593103	1	1117523028	2025-11-28 09:11:00
870	1116205722	593060	2	000000000	2026-04-30 19:07:40
871	1116205722	593061	1	6801355	2025-07-23 11:07:00
872	1116205722	593062	2	000000000	2026-04-30 19:07:40
7381	1117487072	595163	1	6805131	2026-05-06 19:40:50
7382	1117487072	595164	1	6805131	2026-05-06 19:40:50
7383	1117487072	595165	1	6805131	2026-05-06 19:40:50
7384	1117487072	595166	1	6805131	2026-05-06 19:40:50
7385	1117487072	595167	1	6805131	2026-05-06 19:40:50
7386	1117487072	595168	1	6805131	2026-05-06 19:40:50
873	1116205722	593104	1	1117523028	2025-06-19 07:06:00
7387	1117487072	595101	1	40776309	2026-05-06 19:40:50
874	1116205722	593105	2	000000000	2026-04-30 19:07:40
875	1116205722	593106	1	1117523028	2025-11-28 09:11:00
7388	1117487072	595102	1	1026552707	2026-05-06 19:40:50
876	1116205722	593107	2	000000000	2026-04-30 19:07:40
7389	1117487072	595103	1	40776309	2026-05-06 19:40:50
877	1116205722	593108	1	1117523028	2025-11-28 09:11:00
7390	1117487072	595104	1	1026552707	2026-05-06 19:40:50
878	1116205722	593144	2	000000000	2026-04-30 19:07:40
7391	1117487072	595149	1	96328076	2026-05-06 19:40:50
879	1116205722	593145	2	000000000	2026-04-30 19:07:40
7392	1117487072	595150	1	96328076	2026-05-06 19:40:50
880	1116205722	593146	2	000000000	2026-04-30 19:07:40
7393	1117487072	595151	1	96328076	2026-05-06 19:40:50
7394	1117487072	595152	1	96328076	2026-05-06 19:40:50
7395	1117487072	595141	1	1117515166	2026-05-06 19:40:50
7396	1117487072	595142	1	1117515166	2026-05-06 19:40:50
7397	1117487072	595143	1	1117515166	2026-05-06 19:40:50
881	1116205722	592373	2	000000000	2026-04-30 19:07:40
7398	1117487072	595144	1	1117515166	2026-05-06 19:40:50
882	1116205722	592374	2	000000000	2026-04-30 19:07:40
883	1116205722	592375	1	96353963	2025-05-25 15:05:00
7399	1117487072	595158	2	000000000	2026-05-06 19:40:50
884	1116205722	592376	1	1117523028	2025-11-28 09:11:00
7400	1117487072	595159	2	000000000	2026-05-06 19:40:50
885	1116205722	593344	1	1117523028	2025-07-23 11:07:00
7401	1117487072	595160	2	000000000	2026-05-06 19:40:50
7402	1117487072	595161	2	000000000	2026-05-06 19:40:50
7403	1117487072	595162	2	000000000	2026-05-06 19:40:50
886	1116205722	593345	2	000000000	2026-04-30 19:07:40
887	1116205722	593346	1	1117523028	2025-07-23 11:07:00
888	1116205722	593347	2	000000000	2026-04-30 19:07:40
889	1116205722	593243	1	1117523028	2025-12-15 09:12:00
890	1116205722	593244	2	000000000	2026-04-30 19:07:40
891	1116205722	593245	2	000000000	2026-04-30 19:07:40
892	1116205722	593246	2	000000000	2026-04-30 19:07:40
893	1116205722	593255	1	40781077	2025-12-15 17:12:00
7404	1117487072	595106	1	28555809	2026-05-06 19:40:50
894	1116205722	593256	1	40781077	2025-04-30 18:04:00
895	1116205722	593257	1	40781077	2025-12-15 17:12:00
896	1116205722	593258	1	40781077	2025-12-05 09:12:00
897	1116205722	593259	1	40778471	2025-12-01 10:12:00
898	1116205722	593340	1	40778471	2025-12-01 10:12:00
899	1116205722	593341	1	40778471	2025-12-01 10:12:00
7405	1117487072	595107	1	28555809	2026-05-06 19:40:50
7406	1117487072	595108	1	28555809	2026-05-06 19:40:50
900	1116205722	593342	1	40778471	2025-12-01 10:12:00
7407	1117487072	595109	1	28555809	2026-05-06 19:40:50
7408	1117487072	595110	1	28555809	2026-05-06 19:40:50
901	1117496648	590803	2	000000000	2026-04-30 19:07:40
7409	1117487072	595125	1	28555809	2026-05-06 19:40:50
902	1117496648	593147	1	26632272	2025-11-25 09:11:00
903	1117496648	593148	1	26632272	2025-11-25 09:11:00
7410	1117487072	595126	1	28555809	2026-05-06 19:40:50
904	1117496648	593149	1	26632272	2025-11-25 09:11:00
7411	1117487072	595127	1	28555809	2026-05-06 19:40:50
905	1117496648	593150	1	26632272	2025-11-25 09:11:00
906	1117496648	593343	1	1117523028	2025-02-16 16:02:00
907	1117496648	593151	1	6801798	2025-03-24 11:03:00
908	1117496648	593152	2	000000000	2026-04-30 19:07:40
909	1117496648	593153	2	000000000	2026-04-30 19:07:40
7412	1117487072	595128	1	28555809	2026-05-06 19:40:50
7413	1117487072	595129	1	28555809	2026-05-06 19:40:50
7414	1117487072	595130	1	28555809	2026-05-06 19:40:50
7415	1117487072	595131	1	28555809	2026-05-06 19:40:50
910	1117496648	593154	1	6801798	2025-03-24 11:03:00
911	1117496648	593113	2	000000000	2026-04-30 19:07:40
912	1117496648	593114	2	000000000	2026-04-30 19:07:40
913	1117496648	593115	1	1117499177	2026-03-24 08:03:00
7416	1117487072	595132	1	28555809	2026-05-06 19:40:50
7417	1117487072	595117	2	000000000	2026-05-06 19:40:50
7418	1117487072	595118	2	000000000	2026-05-06 19:40:50
7419	1117487072	595119	1	1077865671	2026-05-06 19:40:50
7420	1117487072	595120	1	1077865671	2026-05-06 19:40:50
7421	1117487072	595145	1	1117503960	2026-05-06 19:40:50
914	1117496648	593116	2	000000000	2026-04-30 19:07:40
7422	1117487072	595146	1	1117503960	2026-05-06 19:40:50
915	1117496648	593117	1	1117546314	2025-06-21 10:06:00
916	1117496648	593118	1	1117499177	2026-03-24 08:03:00
7423	1117487072	595147	1	1117503960	2026-05-06 19:40:50
917	1117496648	593155	2	000000000	2026-04-30 19:07:40
7424	1117487072	595148	1	1117503960	2026-05-06 19:40:50
918	1117496648	593156	1	40776309	2025-11-25 19:11:00
7425	1117487072	595111	1	28555809	2026-05-06 19:40:50
919	1117496648	593157	2	000000000	2026-04-30 19:07:40
7426	1117487072	595112	1	28555809	2026-05-06 19:40:50
920	1117496648	593158	1	17654594	2025-06-02 19:06:00
7427	1117487072	595113	1	28555809	2026-05-06 19:40:50
921	1117496648	593119	1	17648908	2025-12-16 20:12:00
7428	1117487072	595114	1	28555809	2026-05-06 19:40:50
7429	1117487072	595115	1	28555809	2026-05-06 19:40:50
7430	1117487072	595116	1	28555809	2026-05-06 19:40:50
7431	1117487072	644275	1	28555809	2026-05-06 19:40:50
7432	1117487072	644276	1	28555809	2026-05-06 19:40:50
922	1117496648	593120	1	17648908	2025-04-24 12:04:00
923	1117496648	593121	1	17648908	2025-12-16 20:12:00
924	1117496648	593122	1	17648908	2025-12-16 20:12:00
7433	1117487072	644277	1	28555809	2026-05-06 19:40:50
925	1117496648	593159	2	000000000	2026-04-30 19:07:40
7434	1117487072	644278	1	28555809	2026-05-06 19:40:50
926	1117496648	593160	2	000000000	2026-04-30 19:07:40
7435	1117487072	644279	1	6801355	2026-05-06 19:40:50
7436	1117487072	644280	1	6801355	2026-05-06 19:40:50
7437	1117487072	644281	1	6801355	2026-05-06 19:40:50
927	1117496648	593161	2	000000000	2026-04-30 19:07:40
928	1117496648	593162	2	000000000	2026-04-30 19:07:40
929	1117496648	593224	1	1117515166	2026-03-16 18:03:00
930	1117496648	593225	1	1117515166	2025-11-26 17:11:00
931	1117496648	593226	1	1117515166	2026-03-16 18:03:00
932	1117496648	593227	1	1117515166	2025-11-26 17:11:00
933	1117496648	593235	2	000000000	2026-04-30 19:07:40
934	1117496648	593236	2	000000000	2026-04-30 19:07:40
7438	1117487072	644282	1	6801355	2026-05-06 19:40:50
935	1117496648	593237	2	000000000	2026-04-30 19:07:40
936	1117496648	593238	2	000000000	2026-04-30 19:07:40
937	1117496648	593109	2	000000000	2026-04-30 19:07:40
938	1117496648	593110	2	000000000	2026-04-30 19:07:40
939	1117496648	593111	1	96353963	2025-11-28 11:11:00
940	1117496648	593112	2	000000000	2026-04-30 19:07:40
7439	1117487072	644323	1	96353963	2026-05-06 19:40:50
7440	1117492748	595100	2	000000000	2026-05-06 19:40:50
941	1117496648	593100	1	1117523028	2025-11-28 09:11:00
7441	1117492748	595133	1	26632272	2026-05-06 19:40:50
7442	1117492748	595134	1	26632272	2026-05-06 19:40:50
942	1117496648	593101	1	1117523028	2025-11-28 09:11:00
7443	1117492748	595135	1	26632272	2026-05-06 19:40:50
943	1117496648	593102	2	000000000	2026-04-30 19:07:40
7444	1117492748	595136	1	26632272	2026-05-06 19:40:50
7445	1117492748	595105	1	28555809	2026-05-06 19:40:50
944	1117496648	593103	1	1117523028	2025-11-28 09:11:00
7446	1117492748	595137	1	96353963	2026-05-06 19:40:50
945	1117496648	593060	2	000000000	2026-04-30 19:07:40
946	1117496648	593061	1	6801355	2025-07-23 11:07:00
947	1117496648	593062	2	000000000	2026-04-30 19:07:40
948	1117496648	593104	1	1117523028	2025-06-19 07:06:00
949	1117496648	593105	2	000000000	2026-04-30 19:07:40
7447	1117492748	595138	1	96353963	2026-05-06 19:40:50
7448	1117492748	595139	1	96353963	2026-05-06 19:40:50
7449	1117492748	595140	1	96353963	2026-05-06 19:40:50
7450	1117492748	595163	1	6805131	2026-05-06 19:40:50
950	1117496648	593106	1	1117523028	2025-11-28 09:11:00
951	1117496648	593107	2	000000000	2026-04-30 19:07:40
952	1117496648	593108	1	1117523028	2025-11-28 09:11:00
953	1117496648	593144	2	000000000	2026-04-30 19:07:40
7451	1117492748	595164	1	6805131	2026-05-06 19:40:50
7452	1117492748	595165	1	6805131	2026-05-06 19:40:50
7453	1117492748	595166	1	6805131	2026-05-06 19:40:50
7454	1117492748	595167	1	6805131	2026-05-06 19:40:50
7455	1117492748	595168	1	6805131	2026-05-06 19:40:50
7456	1117492748	595101	1	40776309	2026-05-06 19:40:50
954	1117496648	593145	2	000000000	2026-04-30 19:07:40
7457	1117492748	595102	1	1026552707	2026-05-06 19:40:50
955	1117496648	593146	2	000000000	2026-04-30 19:07:40
956	1117496648	592373	2	000000000	2026-04-30 19:07:40
7458	1117492748	595103	1	40776309	2026-05-06 19:40:50
957	1117496648	592374	2	000000000	2026-04-30 19:07:40
7459	1117492748	595104	1	1026552707	2026-05-06 19:40:50
7460	1117492748	595149	1	96328076	2026-05-06 19:40:50
7461	1117492748	595150	1	96328076	2026-05-06 19:40:50
958	1117496648	592375	1	96353963	2025-05-25 15:05:00
7462	1117492748	595151	1	96328076	2026-05-06 19:40:50
959	1117496648	592376	1	1117523028	2025-11-28 09:11:00
7463	1117492748	595152	1	96328076	2026-05-06 19:40:50
960	1117496648	593344	1	1117523028	2025-07-23 11:07:00
7464	1117492748	595141	2	000000000	2026-05-06 19:40:50
7465	1117492748	595142	2	000000000	2026-05-06 19:40:50
7466	1117492748	595143	2	000000000	2026-05-06 19:40:50
7467	1117492748	595144	2	000000000	2026-05-06 19:40:50
7468	1117492748	595158	2	000000000	2026-05-06 19:40:50
961	1117496648	593345	2	000000000	2026-04-30 19:07:40
962	1117496648	593346	1	1117523028	2025-07-23 11:07:00
963	1117496648	593347	2	000000000	2026-04-30 19:07:40
7469	1117492748	595159	2	000000000	2026-05-06 19:40:50
964	1117496648	593243	1	1117523028	2025-12-15 09:12:00
7470	1117492748	595160	2	000000000	2026-05-06 19:40:50
965	1117496648	593244	2	000000000	2026-04-30 19:07:40
7471	1117492748	595161	2	000000000	2026-05-06 19:40:50
7472	1117492748	595162	2	000000000	2026-05-06 19:40:50
7473	1117492748	595106	1	28555809	2026-05-06 19:40:50
966	1117496648	593245	2	000000000	2026-04-30 19:07:40
967	1117496648	593246	2	000000000	2026-04-30 19:07:40
968	1117496648	593255	1	40781077	2025-12-15 17:12:00
969	1117496648	593256	1	40781077	2025-04-30 18:04:00
970	1117496648	593257	1	40781077	2025-12-15 17:12:00
971	1117496648	593258	1	40781077	2025-12-05 09:12:00
972	1117496648	593259	1	40778471	2025-12-01 11:12:00
973	1117496648	593340	1	40778471	2025-12-01 11:12:00
7474	1117492748	595107	1	28555809	2026-05-06 19:40:50
7475	1117492748	595108	1	28555809	2026-05-06 19:40:50
7476	1117492748	595109	1	28555809	2026-05-06 19:40:50
7477	1117492748	595110	1	28555809	2026-05-06 19:40:50
7478	1117492748	595125	1	28555809	2026-05-06 19:40:50
974	1117496648	593341	1	40778471	2025-12-01 11:12:00
975	1117496648	593342	1	40778471	2025-12-01 11:12:00
7479	1117492748	595126	1	28555809	2026-05-06 19:40:50
7480	1117492748	595127	1	28555809	2026-05-06 19:40:50
976	1117497987	590803	2	000000000	2026-04-30 19:07:40
7481	1117492748	595128	1	28555809	2026-05-06 19:40:50
7482	1117492748	595129	1	28555809	2026-05-06 19:40:50
7483	1117492748	595130	1	28555809	2026-05-06 19:40:50
7484	1117492748	595131	1	28555809	2026-05-06 19:40:50
977	1117497987	593147	2	000000000	2026-04-30 19:07:40
7485	1117492748	595132	1	28555809	2026-05-06 19:40:50
7486	1117492748	595117	2	000000000	2026-05-06 19:40:50
7487	1117492748	595118	2	000000000	2026-05-06 19:40:50
7488	1117492748	595119	1	1077865671	2026-05-06 19:40:50
978	1117497987	593148	2	000000000	2026-04-30 19:07:40
7489	1117492748	595120	1	1077865671	2026-05-06 19:40:50
979	1117497987	593149	2	000000000	2026-04-30 19:07:40
7490	1117492748	595145	1	1117503960	2026-05-06 19:40:50
7491	1117492748	595146	1	1117503960	2026-05-06 19:40:50
7492	1117492748	595147	1	1117503960	2026-05-06 19:40:50
7493	1117492748	595148	1	1117503960	2026-05-06 19:40:50
7494	1117492748	595111	1	28555809	2026-05-06 19:40:50
7495	1117492748	595112	1	28555809	2026-05-06 19:40:50
7496	1117492748	595113	1	28555809	2026-05-06 19:40:50
7497	1117492748	595114	1	28555809	2026-05-06 19:40:50
7498	1117492748	595115	1	28555809	2026-05-06 19:40:50
7499	1117492748	595116	1	28555809	2026-05-06 19:40:50
7500	1117492748	644275	1	28555809	2026-05-06 19:40:50
7501	1117492748	644276	1	28555809	2026-05-06 19:40:50
7502	1117492748	644277	1	28555809	2026-05-06 19:40:50
7503	1117492748	644278	1	28555809	2026-05-06 19:40:50
7504	1117492748	644279	1	6801355	2026-05-06 19:40:50
7505	1117492748	644280	1	6801355	2026-05-06 19:40:50
7506	1117492748	644281	1	6801355	2026-05-06 19:40:50
7507	1117492748	644282	1	6801355	2026-05-06 19:40:50
7508	1117492748	644323	1	96353963	2026-05-06 19:40:50
7509	1117495913	595100	2	000000000	2026-05-06 19:40:50
7510	1117495913	595133	1	26632272	2026-05-06 19:40:50
7511	1117495913	595134	1	26632272	2026-05-06 19:40:50
7512	1117495913	595135	1	26632272	2026-05-06 19:40:50
980	1117497987	593150	2	000000000	2026-04-30 19:07:40
7513	1117495913	595136	1	26632272	2026-05-06 19:40:50
981	1117497987	593343	1	1117523028	2025-02-16 16:02:00
7514	1117495913	595105	1	28555809	2026-05-06 19:40:50
7515	1117495913	595137	1	96353963	2026-05-06 19:40:50
7516	1117495913	595138	1	96353963	2026-05-06 19:40:50
7517	1117495913	595139	1	96353963	2026-05-06 19:40:50
7518	1117495913	595140	1	96353963	2026-05-06 19:40:50
7519	1117495913	595163	1	6805131	2026-05-06 19:40:50
7520	1117495913	595164	1	6805131	2026-05-06 19:40:50
7521	1117495913	595165	1	6805131	2026-05-06 19:40:50
7522	1117495913	595166	1	6805131	2026-05-06 19:40:50
7523	1117495913	595167	1	6805131	2026-05-06 19:40:50
982	1117497987	593151	1	6801798	2025-03-24 11:03:00
7524	1117495913	595168	1	6805131	2026-05-06 19:40:50
983	1117497987	593152	2	000000000	2026-04-30 19:07:40
7525	1117495913	595101	1	40776309	2026-05-06 19:40:50
984	1117497987	593153	2	000000000	2026-04-30 19:07:40
7526	1117495913	595102	1	1026552707	2026-05-06 19:40:50
7527	1117495913	595103	1	40776309	2026-05-06 19:40:50
7528	1117495913	595104	1	1026552707	2026-05-06 19:40:50
7529	1117495913	595149	1	96328076	2026-05-06 19:40:50
7530	1117495913	595150	1	96328076	2026-05-06 19:40:50
7531	1117495913	595151	1	96328076	2026-05-06 19:40:50
985	1117497987	593154	1	6801798	2025-03-24 11:03:00
7532	1117495913	595152	1	96328076	2026-05-06 19:40:50
7533	1117495913	595141	1	1117515166	2026-05-06 19:40:50
7534	1117495913	595142	1	1117515166	2026-05-06 19:40:50
7535	1117495913	595143	1	1117515166	2026-05-06 19:40:50
7536	1117495913	595144	1	1117515166	2026-05-06 19:40:50
7537	1117495913	595158	2	000000000	2026-05-06 19:40:50
7538	1117495913	595159	2	000000000	2026-05-06 19:40:50
986	1117497987	593113	2	000000000	2026-04-30 19:07:40
987	1117497987	593114	2	000000000	2026-04-30 19:07:40
988	1117497987	593115	2	000000000	2026-04-30 19:07:40
989	1117497987	593116	2	000000000	2026-04-30 19:07:40
990	1117497987	593117	1	1117546314	2025-06-21 10:06:00
991	1117497987	593118	2	000000000	2026-04-30 19:07:40
7539	1117495913	595160	2	000000000	2026-05-06 19:40:50
7540	1117495913	595161	2	000000000	2026-05-06 19:40:50
992	1117497987	593155	2	000000000	2026-04-30 19:07:40
7541	1117495913	595162	2	000000000	2026-05-06 19:40:50
7542	1117495913	595106	1	28555809	2026-05-06 19:40:50
993	1117497987	593156	2	000000000	2026-04-30 19:07:40
7543	1117495913	595107	1	28555809	2026-05-06 19:40:50
994	1117497987	593157	2	000000000	2026-04-30 19:07:40
995	1117497987	593158	1	17654594	2025-06-02 19:06:00
7544	1117495913	595108	1	28555809	2026-05-06 19:40:50
996	1117497987	593119	2	000000000	2026-04-30 19:07:40
7545	1117495913	595109	1	28555809	2026-05-06 19:40:50
997	1117497987	593120	1	17648908	2025-04-24 12:04:00
998	1117497987	593121	2	000000000	2026-04-30 19:07:40
999	1117497987	593122	2	000000000	2026-04-30 19:07:40
1000	1117497987	593159	2	000000000	2026-04-30 19:07:40
1001	1117497987	593160	2	000000000	2026-04-30 19:07:40
7546	1117495913	595110	1	28555809	2026-05-06 19:40:50
7547	1117495913	595125	1	28555809	2026-05-06 19:40:50
7548	1117495913	595126	1	28555809	2026-05-06 19:40:50
7549	1117495913	595127	1	28555809	2026-05-06 19:40:50
1002	1117497987	593161	2	000000000	2026-04-30 19:07:40
1003	1117497987	593162	2	000000000	2026-04-30 19:07:40
1004	1117497987	593224	2	000000000	2026-04-30 19:07:40
1005	1117497987	593225	2	000000000	2026-04-30 19:07:40
7550	1117495913	595128	1	28555809	2026-05-06 19:40:50
7551	1117495913	595129	1	28555809	2026-05-06 19:40:50
7552	1117495913	595130	1	28555809	2026-05-06 19:40:50
7553	1117495913	595131	1	28555809	2026-05-06 19:40:50
7554	1117495913	595132	1	28555809	2026-05-06 19:40:50
7555	1117495913	595117	2	000000000	2026-05-06 19:40:50
1006	1117497987	593226	2	000000000	2026-04-30 19:07:40
7556	1117495913	595118	2	000000000	2026-05-06 19:40:50
1007	1117497987	593227	2	000000000	2026-04-30 19:07:40
1008	1117497987	593235	2	000000000	2026-04-30 19:07:40
7557	1117495913	595119	1	1077865671	2026-05-06 19:40:50
1009	1117497987	593236	2	000000000	2026-04-30 19:07:40
7558	1117495913	595120	1	1077865671	2026-05-06 19:40:50
1010	1117497987	593237	2	000000000	2026-04-30 19:07:40
7559	1117495913	595145	1	1117503960	2026-05-06 19:40:50
1011	1117497987	593238	2	000000000	2026-04-30 19:07:40
7560	1117495913	595146	1	1117503960	2026-05-06 19:40:50
1012	1117497987	593109	2	000000000	2026-04-30 19:07:40
7561	1117495913	595147	1	1117503960	2026-05-06 19:40:50
1013	1117497987	593110	2	000000000	2026-04-30 19:07:40
7562	1117495913	595148	1	1117503960	2026-05-06 19:40:50
7563	1117495913	595111	2	000000000	2026-05-06 19:40:50
7564	1117495913	595112	2	000000000	2026-05-06 19:40:50
7565	1117495913	595113	2	000000000	2026-05-06 19:40:50
7566	1117495913	595114	2	000000000	2026-05-06 19:40:50
1014	1117497987	593111	2	000000000	2026-04-30 19:07:40
1015	1117497987	593112	2	000000000	2026-04-30 19:07:40
1016	1117497987	593100	2	000000000	2026-04-30 19:07:40
7567	1117495913	595115	2	000000000	2026-05-06 19:40:50
1017	1117497987	593101	2	000000000	2026-04-30 19:07:40
7568	1117495913	595116	2	000000000	2026-05-06 19:40:50
1018	1117497987	593102	2	000000000	2026-04-30 19:07:40
7569	1117495913	644275	1	28555809	2026-05-06 19:40:50
7570	1117495913	644276	1	28555809	2026-05-06 19:40:50
7571	1117495913	644277	1	28555809	2026-05-06 19:40:50
1019	1117497987	593103	2	000000000	2026-04-30 19:07:40
1020	1117497987	593060	2	000000000	2026-04-30 19:07:40
1021	1117497987	593061	2	000000000	2026-04-30 19:07:40
1022	1117497987	593062	2	000000000	2026-04-30 19:07:40
1023	1117497987	593104	2	000000000	2026-04-30 19:07:40
1024	1117497987	593105	2	000000000	2026-04-30 19:07:40
1025	1117497987	593106	2	000000000	2026-04-30 19:07:40
1026	1117497987	593107	2	000000000	2026-04-30 19:07:40
7572	1117495913	644278	1	28555809	2026-05-06 19:40:50
1027	1117497987	593108	2	000000000	2026-04-30 19:07:40
1028	1117497987	593144	2	000000000	2026-04-30 19:07:40
1029	1117497987	593145	2	000000000	2026-04-30 19:07:40
1030	1117497987	593146	2	000000000	2026-04-30 19:07:40
7573	1117495913	644279	1	6801355	2026-05-06 19:40:50
6	1006419673	593343	1	1117523028	2025-02-16 16:02:00
7	1006419673	593151	1	6801798	2025-03-24 11:03:00
7574	1117495913	644280	1	6801355	2026-05-06 19:40:50
7575	1117495913	644281	1	6801355	2026-05-06 19:40:50
10	1006419673	593154	1	6801798	2025-03-24 11:03:00
7576	1117495913	644282	1	6801355	2026-05-06 19:40:50
7577	1117495913	644323	1	96353963	2026-05-06 19:40:50
7578	1117497251	595100	2	000000000	2026-05-06 19:40:50
7579	1117497251	595133	1	26632272	2026-05-06 19:40:50
1031	1117497987	592373	2	000000000	2026-04-30 19:07:40
7580	1117497251	595134	1	26632272	2026-05-06 19:40:50
7581	1117497251	595135	1	26632272	2026-05-06 19:40:50
1032	1117497987	592374	2	000000000	2026-04-30 19:07:40
7582	1117497251	595136	1	26632272	2026-05-06 19:40:50
1033	1117497987	592375	1	96353963	2025-05-25 15:05:00
1034	1117497987	592376	2	000000000	2026-04-30 19:07:40
1035	1117497987	593344	2	000000000	2026-04-30 19:07:40
1036	1117497987	593345	2	000000000	2026-04-30 19:07:40
1037	1117497987	593346	2	000000000	2026-04-30 19:07:40
7583	1117497251	595105	1	28555809	2026-05-06 19:40:50
7584	1117497251	595137	1	96353963	2026-05-06 19:40:50
7585	1117497251	595138	1	96353963	2026-05-06 19:40:50
7586	1117497251	595139	1	96353963	2026-05-06 19:40:50
7587	1117497251	595140	1	96353963	2026-05-06 19:40:50
1038	1117497987	593347	2	000000000	2026-04-30 19:07:40
7588	1117497251	595163	1	6805131	2026-05-06 19:40:50
1039	1117497987	593243	2	000000000	2026-04-30 19:07:40
7589	1117497251	595164	1	6805131	2026-05-06 19:40:50
1040	1117497987	593244	2	000000000	2026-04-30 19:07:40
7590	1117497251	595165	1	6805131	2026-05-06 19:40:50
7591	1117497251	595166	1	6805131	2026-05-06 19:40:50
7592	1117497251	595167	1	6805131	2026-05-06 19:40:50
7593	1117497251	595168	1	6805131	2026-05-06 19:40:50
1041	1117497987	593245	2	000000000	2026-04-30 19:07:40
7594	1117497251	595101	1	40776309	2026-05-06 19:40:50
1042	1117497987	593246	2	000000000	2026-04-30 19:07:40
1043	1117497987	593255	2	000000000	2026-04-30 19:07:40
7595	1117497251	595102	1	1026552707	2026-05-06 19:40:50
1044	1117497987	593256	1	40781077	2025-04-30 18:04:00
7596	1117497251	595103	1	40776309	2026-05-06 19:40:50
1045	1117497987	593257	2	000000000	2026-04-30 19:07:40
7597	1117497251	595104	1	1026552707	2026-05-06 19:40:50
1046	1117497987	593258	2	000000000	2026-04-30 19:07:40
7598	1117497251	595149	1	96328076	2026-05-06 19:40:50
1047	1117497987	593259	2	000000000	2026-04-30 19:07:40
7599	1117497251	595150	1	96328076	2026-05-06 19:40:50
1048	1117497987	593340	2	000000000	2026-04-30 19:07:40
7600	1117497251	595151	1	96328076	2026-05-06 19:40:50
7601	1117497251	595152	1	96328076	2026-05-06 19:40:50
7602	1117497251	595141	2	000000000	2026-05-06 19:40:50
7603	1117497251	595142	2	000000000	2026-05-06 19:40:50
7604	1117497251	595143	2	000000000	2026-05-06 19:40:50
1049	1117497987	593341	2	000000000	2026-04-30 19:07:40
1050	1117497987	593342	2	000000000	2026-04-30 19:07:40
1051	1117506583	590803	2	000000000	2026-04-30 19:07:40
7605	1117497251	595144	2	000000000	2026-05-06 19:40:50
1052	1117506583	593147	2	000000000	2026-04-30 19:07:40
7606	1117497251	595158	2	000000000	2026-05-06 19:40:50
1053	1117506583	593148	2	000000000	2026-04-30 19:07:40
7607	1117497251	595159	2	000000000	2026-05-06 19:40:50
7608	1117497251	595160	2	000000000	2026-05-06 19:40:50
7609	1117497251	595161	2	000000000	2026-05-06 19:40:50
1054	1117506583	593149	2	000000000	2026-04-30 19:07:40
1055	1117506583	593150	2	000000000	2026-04-30 19:07:40
1056	1117506583	593343	1	1117523028	2025-02-16 16:02:00
1057	1117506583	593151	1	6801798	2025-03-24 11:03:00
1058	1117506583	593152	2	000000000	2026-04-30 19:07:40
1059	1117506583	593153	2	000000000	2026-04-30 19:07:40
1060	1117506583	593154	1	6801798	2025-03-24 11:03:00
1061	1117506583	593113	2	000000000	2026-04-30 19:07:40
2328	1006458870	589237	2	000000000	2026-04-30 18:31:43
2329	1006458870	589238	1	96328076	2026-02-26 18:02:00
2330	1006458870	589239	2	000000000	2026-04-30 18:31:43
2331	1006458870	589240	1	17652688	2025-12-18 14:12:00
2332	1006458870	589241	2	000000000	2026-04-30 18:31:43
2333	1006458870	589242	1	17652688	2025-12-18 14:12:00
2334	1006458870	589243	2	000000000	2026-04-30 18:31:43
2335	1006458870	589244	1	6801355	2026-04-26 22:04:00
2336	1006458870	589245	1	17656065	2026-04-16 11:04:00
2337	1006458870	589246	1	1117515166	2026-04-13 14:04:00
2338	1006458870	589247	1	96328076	2026-02-26 18:02:00
2339	1006458870	589248	1	17652688	2025-12-18 14:12:00
2340	1006458870	589249	2	000000000	2026-04-30 18:31:43
2341	1006458870	589250	1	40776309	2026-03-22 19:03:00
2342	1006458870	588712	2	000000000	2026-04-30 18:31:43
2343	1006458870	588980	2	000000000	2026-04-30 18:31:43
2344	1006458870	588981	2	000000000	2026-04-30 18:31:43
2345	1006458870	588982	2	000000000	2026-04-30 18:31:43
2346	1006458870	588983	2	000000000	2026-04-30 18:31:43
2347	1006458870	588984	2	000000000	2026-04-30 18:31:43
2348	1006458870	588985	2	000000000	2026-04-30 18:31:43
2349	1006458870	588986	2	000000000	2026-04-30 18:31:43
2350	1006458870	588987	2	000000000	2026-04-30 18:31:43
2351	1006458870	588988	2	000000000	2026-04-30 18:31:43
2352	1006458870	588989	2	000000000	2026-04-30 18:31:43
2353	1006458870	588990	2	000000000	2026-04-30 18:31:43
2354	1006458870	588991	1	40758842	2026-02-26 07:02:00
2355	1006458870	588992	2	000000000	2026-04-30 18:31:43
2356	1006458870	588940	2	000000000	2026-04-30 18:31:43
2357	1006458870	588941	2	000000000	2026-04-30 18:31:43
2358	1006458870	588942	2	000000000	2026-04-30 18:31:43
2359	1006458870	588943	2	000000000	2026-04-30 18:31:43
2360	1006458870	588944	2	000000000	2026-04-30 18:31:43
2361	1006458870	588945	2	000000000	2026-04-30 18:31:43
2362	1006458870	588946	2	000000000	2026-04-30 18:31:43
7610	1117497251	595162	2	000000000	2026-05-06 19:40:50
7611	1117497251	595106	1	28555809	2026-05-06 19:40:50
7612	1117497251	595107	1	28555809	2026-05-06 19:40:50
2363	1006458870	588947	2	000000000	2026-04-30 18:31:43
2364	1006458870	588948	2	000000000	2026-04-30 18:31:43
2365	1006458870	588949	2	000000000	2026-04-30 18:31:43
2366	1006458870	588950	2	000000000	2026-04-30 18:31:43
2367	1006458870	588951	2	000000000	2026-04-30 18:31:43
2368	1006458870	588952	2	000000000	2026-04-30 18:31:43
2369	1006458870	588953	2	000000000	2026-04-30 18:31:43
2370	1006458870	588954	2	000000000	2026-04-30 18:31:43
2371	1006458870	588955	2	000000000	2026-04-30 18:31:43
2372	1006458870	588956	2	000000000	2026-04-30 18:31:43
2373	1006458870	588993	2	000000000	2026-04-30 18:31:43
2374	1006458870	588994	2	000000000	2026-04-30 18:31:43
2375	1006458870	588995	2	000000000	2026-04-30 18:31:43
2376	1006458870	588996	2	000000000	2026-04-30 18:31:43
2377	1006458870	588997	2	000000000	2026-04-30 18:31:43
2378	1006458870	588998	2	000000000	2026-04-30 18:31:43
2379	1006458870	588999	2	000000000	2026-04-30 18:31:43
2380	1006458870	589000	2	000000000	2026-04-30 18:31:43
2381	1006458870	589001	2	000000000	2026-04-30 18:31:43
2382	1006458870	588957	1	40758842	2026-04-15 07:04:00
2383	1006458870	588958	1	40758842	2026-04-15 07:04:00
2384	1006458870	588959	2	000000000	2026-04-30 18:31:43
2385	1006458870	588960	2	000000000	2026-04-30 18:31:43
2386	1006458870	588961	2	000000000	2026-04-30 18:31:43
2387	1006458870	588962	2	000000000	2026-04-30 18:31:43
2388	1006458870	588963	2	000000000	2026-04-30 18:31:43
2389	1006458870	588964	2	000000000	2026-04-30 18:31:43
2390	1006458870	588965	2	000000000	2026-04-30 18:31:43
2391	1006458870	588966	2	000000000	2026-04-30 18:31:43
2392	1006458870	588967	2	000000000	2026-04-30 18:31:43
2393	1006458870	588968	2	000000000	2026-04-30 18:31:43
2394	1006458870	588969	2	000000000	2026-04-30 18:31:43
2395	1006458870	588970	2	000000000	2026-04-30 18:31:43
2396	1006458870	588971	2	000000000	2026-04-30 18:31:43
2397	1006458870	588972	2	000000000	2026-04-30 18:31:43
2398	1006458870	588973	2	000000000	2026-04-30 18:31:43
2399	1006458870	588974	2	000000000	2026-04-30 18:31:43
2400	1006458870	588975	2	000000000	2026-04-30 18:31:43
2401	1006458870	588976	2	000000000	2026-04-30 18:31:43
2402	1006458870	588977	2	000000000	2026-04-30 18:31:43
2403	1006458870	588978	2	000000000	2026-04-30 18:31:43
2404	1006458870	588979	2	000000000	2026-04-30 18:31:43
2405	1006458870	589020	2	000000000	2026-04-30 18:31:43
2406	1006458870	589021	2	000000000	2026-04-30 18:31:43
2407	1006458870	589022	2	000000000	2026-04-30 18:31:43
2408	1006458870	589251	2	000000000	2026-04-30 18:31:43
2409	1006458870	589252	1	1117532250	2026-03-20 07:03:00
2410	1006458870	589253	2	000000000	2026-04-30 18:31:43
2411	1006458870	589254	1	1117532250	2026-02-17 12:02:00
2412	1006458870	589255	2	000000000	2026-04-30 18:31:43
2413	1006458870	589256	2	000000000	2026-04-30 18:31:43
2414	1006458870	589257	2	000000000	2026-04-30 18:31:43
2415	1006458870	589258	2	000000000	2026-04-30 18:31:43
2416	1006458870	589259	2	000000000	2026-04-30 18:31:43
2417	1006458870	589300	2	000000000	2026-04-30 18:31:43
2418	1006458870	589301	2	000000000	2026-04-30 18:31:43
2419	1006458870	589302	2	000000000	2026-04-30 18:31:43
2420	1006458870	589303	2	000000000	2026-04-30 18:31:43
2421	1006458870	589304	2	000000000	2026-04-30 18:31:43
2422	1006458870	589305	2	000000000	2026-04-30 18:31:43
2423	1006458870	735222	2	000000000	2026-04-30 18:31:43
2424	1006458870	735223	2	000000000	2026-04-30 18:31:43
2425	1006458870	735224	2	000000000	2026-04-30 18:31:43
2426	1006458870	735225	2	000000000	2026-04-30 18:31:43
2427	1006505845	589237	2	000000000	2026-04-30 18:31:43
2428	1006505845	589238	1	96328076	2026-02-26 18:02:00
2429	1006505845	589239	2	000000000	2026-04-30 18:31:43
2430	1006505845	589240	1	17652688	2025-12-18 14:12:00
2431	1006505845	589241	2	000000000	2026-04-30 18:31:43
2432	1006505845	589242	1	17652688	2025-12-18 14:12:00
2433	1006505845	589243	2	000000000	2026-04-30 18:31:43
2434	1006505845	589244	1	6801355	2026-04-26 22:04:00
2435	1006505845	589245	1	17656065	2026-04-16 11:04:00
2436	1006505845	589246	1	1117515166	2026-04-13 14:04:00
2437	1006505845	589247	1	96328076	2026-02-26 18:02:00
2438	1006505845	589248	1	17652688	2025-12-18 14:12:00
2439	1006505845	589249	2	000000000	2026-04-30 18:31:43
2440	1006505845	589250	1	40776309	2026-03-22 19:03:00
2441	1006505845	588712	2	000000000	2026-04-30 18:31:43
2442	1006505845	588980	2	000000000	2026-04-30 18:31:43
2443	1006505845	588981	2	000000000	2026-04-30 18:31:43
2444	1006505845	588982	2	000000000	2026-04-30 18:31:43
2445	1006505845	588983	2	000000000	2026-04-30 18:31:43
2446	1006505845	588984	2	000000000	2026-04-30 18:31:43
2447	1006505845	588985	2	000000000	2026-04-30 18:31:43
2448	1006505845	588986	2	000000000	2026-04-30 18:31:43
2449	1006505845	588987	2	000000000	2026-04-30 18:31:43
2450	1006505845	588988	2	000000000	2026-04-30 18:31:43
2451	1006505845	588989	2	000000000	2026-04-30 18:31:43
2452	1006505845	588990	2	000000000	2026-04-30 18:31:43
2453	1006505845	588991	1	40758842	2026-02-26 07:02:00
2454	1006505845	588992	2	000000000	2026-04-30 18:31:43
2455	1006505845	588940	2	000000000	2026-04-30 18:31:43
2456	1006505845	588941	2	000000000	2026-04-30 18:31:43
2457	1006505845	588942	2	000000000	2026-04-30 18:31:43
2458	1006505845	588943	2	000000000	2026-04-30 18:31:43
2459	1006505845	588944	2	000000000	2026-04-30 18:31:43
2460	1006505845	588945	2	000000000	2026-04-30 18:31:43
2461	1006505845	588946	2	000000000	2026-04-30 18:31:43
2462	1006505845	588947	2	000000000	2026-04-30 18:31:43
2463	1006505845	588948	2	000000000	2026-04-30 18:31:43
2464	1006505845	588949	2	000000000	2026-04-30 18:31:43
2465	1006505845	588950	2	000000000	2026-04-30 18:31:44
2466	1006505845	588951	2	000000000	2026-04-30 18:31:44
2467	1006505845	588952	2	000000000	2026-04-30 18:31:44
2468	1006505845	588953	2	000000000	2026-04-30 18:31:44
2469	1006505845	588954	2	000000000	2026-04-30 18:31:44
2470	1006505845	588955	2	000000000	2026-04-30 18:31:44
2471	1006505845	588956	2	000000000	2026-04-30 18:31:44
2472	1006505845	588993	2	000000000	2026-04-30 18:31:44
2473	1006505845	588994	2	000000000	2026-04-30 18:31:44
2474	1006505845	588995	2	000000000	2026-04-30 18:31:44
2475	1006505845	588996	2	000000000	2026-04-30 18:31:44
2476	1006505845	588997	2	000000000	2026-04-30 18:31:44
2477	1006505845	588998	2	000000000	2026-04-30 18:31:44
2478	1006505845	588999	2	000000000	2026-04-30 18:31:44
2479	1006505845	589000	2	000000000	2026-04-30 18:31:44
2480	1006505845	589001	2	000000000	2026-04-30 18:31:44
2481	1006505845	588957	1	40758842	2026-04-15 07:04:00
2482	1006505845	588958	1	40758842	2026-04-15 07:04:00
2483	1006505845	588959	2	000000000	2026-04-30 18:31:44
2484	1006505845	588960	2	000000000	2026-04-30 18:31:44
2485	1006505845	588961	2	000000000	2026-04-30 18:31:44
2486	1006505845	588962	2	000000000	2026-04-30 18:31:44
2487	1006505845	588963	2	000000000	2026-04-30 18:31:44
2488	1006505845	588964	2	000000000	2026-04-30 18:31:44
2489	1006505845	588965	2	000000000	2026-04-30 18:31:44
2490	1006505845	588966	2	000000000	2026-04-30 18:31:44
2491	1006505845	588967	2	000000000	2026-04-30 18:31:44
2492	1006505845	588968	2	000000000	2026-04-30 18:31:44
2493	1006505845	588969	2	000000000	2026-04-30 18:31:44
2494	1006505845	588970	2	000000000	2026-04-30 18:31:44
2495	1006505845	588971	2	000000000	2026-04-30 18:31:44
2496	1006505845	588972	2	000000000	2026-04-30 18:31:44
2497	1006505845	588973	2	000000000	2026-04-30 18:31:44
2498	1006505845	588974	2	000000000	2026-04-30 18:31:44
2499	1006505845	588975	2	000000000	2026-04-30 18:31:44
2500	1006505845	588976	2	000000000	2026-04-30 18:31:44
2501	1006505845	588977	2	000000000	2026-04-30 18:31:44
2502	1006505845	588978	2	000000000	2026-04-30 18:31:44
2503	1006505845	588979	2	000000000	2026-04-30 18:31:44
2504	1006505845	589020	2	000000000	2026-04-30 18:31:44
2505	1006505845	589021	2	000000000	2026-04-30 18:31:44
2506	1006505845	589022	2	000000000	2026-04-30 18:31:44
2507	1006505845	589251	2	000000000	2026-04-30 18:31:44
2508	1006505845	589252	1	1117532250	2026-03-20 07:03:00
2509	1006505845	589253	2	000000000	2026-04-30 18:31:44
2510	1006505845	589254	1	1117532250	2026-02-17 12:02:00
2511	1006505845	589255	2	000000000	2026-04-30 18:31:44
2512	1006505845	589256	2	000000000	2026-04-30 18:31:44
2513	1006505845	589257	2	000000000	2026-04-30 18:31:44
2514	1006505845	589258	2	000000000	2026-04-30 18:31:44
2515	1006505845	589259	2	000000000	2026-04-30 18:31:44
2516	1006505845	589300	2	000000000	2026-04-30 18:31:44
2517	1006505845	589301	2	000000000	2026-04-30 18:31:44
2518	1006505845	589302	2	000000000	2026-04-30 18:31:44
2519	1006505845	589303	2	000000000	2026-04-30 18:31:44
2520	1006505845	589304	2	000000000	2026-04-30 18:31:44
2521	1006505845	589305	2	000000000	2026-04-30 18:31:44
2522	1006505845	735222	2	000000000	2026-04-30 18:31:44
2523	1006505845	735223	2	000000000	2026-04-30 18:31:44
2524	1006505845	735224	2	000000000	2026-04-30 18:31:44
2525	1006505845	735225	2	000000000	2026-04-30 18:31:44
2526	1034660100	589237	2	000000000	2026-04-30 18:31:44
2527	1034660100	589238	1	96328076	2026-02-26 18:02:00
2528	1034660100	589239	2	000000000	2026-04-30 18:31:44
2529	1034660100	589240	1	17652688	2025-12-18 14:12:00
2530	1034660100	589241	2	000000000	2026-04-30 18:31:44
2531	1034660100	589242	1	17652688	2025-12-18 14:12:00
2532	1034660100	589243	2	000000000	2026-04-30 18:31:44
2533	1034660100	589244	1	6801355	2026-04-26 22:04:00
2534	1034660100	589245	1	17656065	2026-04-16 11:04:00
2535	1034660100	589246	1	1117515166	2026-04-13 14:04:00
2536	1034660100	589247	1	96328076	2026-02-26 18:02:00
2537	1034660100	589248	1	17652688	2025-12-18 14:12:00
2538	1034660100	589249	2	000000000	2026-04-30 18:31:44
2539	1034660100	589250	1	40776309	2026-03-22 19:03:00
2540	1034660100	588712	2	000000000	2026-04-30 18:31:44
2541	1034660100	588980	2	000000000	2026-04-30 18:31:44
2542	1034660100	588981	2	000000000	2026-04-30 18:31:44
2543	1034660100	588982	2	000000000	2026-04-30 18:31:44
2544	1034660100	588983	2	000000000	2026-04-30 18:31:44
2545	1034660100	588984	2	000000000	2026-04-30 18:31:44
2546	1034660100	588985	2	000000000	2026-04-30 18:31:44
2547	1034660100	588986	2	000000000	2026-04-30 18:31:44
2548	1034660100	588987	2	000000000	2026-04-30 18:31:44
2549	1034660100	588988	2	000000000	2026-04-30 18:31:44
2550	1034660100	588989	2	000000000	2026-04-30 18:31:44
2551	1034660100	588990	2	000000000	2026-04-30 18:31:44
2552	1034660100	588991	1	40758842	2026-02-26 07:02:00
2553	1034660100	588992	2	000000000	2026-04-30 18:31:44
2554	1034660100	588940	2	000000000	2026-04-30 18:31:44
2555	1034660100	588941	2	000000000	2026-04-30 18:31:44
2556	1034660100	588942	2	000000000	2026-04-30 18:31:44
2557	1034660100	588943	2	000000000	2026-04-30 18:31:44
2558	1034660100	588944	2	000000000	2026-04-30 18:31:44
2559	1034660100	588945	2	000000000	2026-04-30 18:31:44
2560	1034660100	588946	2	000000000	2026-04-30 18:31:44
2561	1034660100	588947	2	000000000	2026-04-30 18:31:44
2562	1034660100	588948	2	000000000	2026-04-30 18:31:44
2563	1034660100	588949	2	000000000	2026-04-30 18:31:44
2564	1034660100	588950	2	000000000	2026-04-30 18:31:44
2565	1034660100	588951	2	000000000	2026-04-30 18:31:44
2566	1034660100	588952	2	000000000	2026-04-30 18:31:44
2567	1034660100	588953	2	000000000	2026-04-30 18:31:44
2568	1034660100	588954	2	000000000	2026-04-30 18:31:44
2569	1034660100	588955	2	000000000	2026-04-30 18:31:44
2570	1034660100	588956	2	000000000	2026-04-30 18:31:44
2571	1034660100	588993	2	000000000	2026-04-30 18:31:44
2572	1034660100	588994	2	000000000	2026-04-30 18:31:44
2573	1034660100	588995	2	000000000	2026-04-30 18:31:44
2574	1034660100	588996	2	000000000	2026-04-30 18:31:44
2575	1034660100	588997	2	000000000	2026-04-30 18:31:44
2576	1034660100	588998	2	000000000	2026-04-30 18:31:44
2577	1034660100	588999	2	000000000	2026-04-30 18:31:44
2578	1034660100	589000	2	000000000	2026-04-30 18:31:44
2579	1034660100	589001	2	000000000	2026-04-30 18:31:44
2580	1034660100	588957	1	40758842	2026-04-15 07:04:00
2581	1034660100	588958	1	40758842	2026-04-15 07:04:00
2582	1034660100	588959	2	000000000	2026-04-30 18:31:44
2583	1034660100	588960	2	000000000	2026-04-30 18:31:44
2584	1034660100	588961	2	000000000	2026-04-30 18:31:44
2585	1034660100	588962	2	000000000	2026-04-30 18:31:44
2586	1034660100	588963	2	000000000	2026-04-30 18:31:44
2587	1034660100	588964	2	000000000	2026-04-30 18:31:44
2588	1034660100	588965	2	000000000	2026-04-30 18:31:44
2589	1034660100	588966	2	000000000	2026-04-30 18:31:44
2590	1034660100	588967	2	000000000	2026-04-30 18:31:44
2591	1034660100	588968	2	000000000	2026-04-30 18:31:44
2592	1034660100	588969	2	000000000	2026-04-30 18:31:44
2593	1034660100	588970	2	000000000	2026-04-30 18:31:44
2594	1034660100	588971	2	000000000	2026-04-30 18:31:44
2595	1034660100	588972	2	000000000	2026-04-30 18:31:44
2596	1034660100	588973	2	000000000	2026-04-30 18:31:44
2597	1034660100	588974	2	000000000	2026-04-30 18:31:44
2598	1034660100	588975	2	000000000	2026-04-30 18:31:44
2599	1034660100	588976	2	000000000	2026-04-30 18:31:44
2600	1034660100	588977	2	000000000	2026-04-30 18:31:44
2601	1034660100	588978	2	000000000	2026-04-30 18:31:44
2602	1034660100	588979	2	000000000	2026-04-30 18:31:44
2603	1034660100	589020	2	000000000	2026-04-30 18:31:44
2604	1034660100	589021	2	000000000	2026-04-30 18:31:44
2605	1034660100	589022	2	000000000	2026-04-30 18:31:44
2606	1034660100	589251	2	000000000	2026-04-30 18:31:44
2607	1034660100	589252	1	1117532250	2026-03-20 07:03:00
2608	1034660100	589253	2	000000000	2026-04-30 18:31:44
2609	1034660100	589254	1	1117532250	2026-02-17 12:02:00
2610	1034660100	589255	2	000000000	2026-04-30 18:31:44
2611	1034660100	589256	2	000000000	2026-04-30 18:31:44
2612	1034660100	589257	2	000000000	2026-04-30 18:31:44
2613	1034660100	589258	2	000000000	2026-04-30 18:31:44
2614	1034660100	589259	2	000000000	2026-04-30 18:31:44
2615	1034660100	589300	2	000000000	2026-04-30 18:31:44
2616	1034660100	589301	2	000000000	2026-04-30 18:31:44
2617	1034660100	589302	2	000000000	2026-04-30 18:31:44
2618	1034660100	589303	2	000000000	2026-04-30 18:31:44
2619	1034660100	589304	2	000000000	2026-04-30 18:31:44
2620	1034660100	589305	2	000000000	2026-04-30 18:31:44
2621	1034660100	735222	2	000000000	2026-04-30 18:31:44
2622	1034660100	735223	2	000000000	2026-04-30 18:31:44
2623	1034660100	735224	2	000000000	2026-04-30 18:31:44
2624	1034660100	735225	2	000000000	2026-04-30 18:31:44
2625	1117500686	589237	2	000000000	2026-04-30 18:31:44
2626	1117500686	589238	1	96328076	2026-02-26 18:02:00
2627	1117500686	589239	2	000000000	2026-04-30 18:31:44
2628	1117500686	589240	1	17652688	2025-12-18 14:12:00
2629	1117500686	589241	2	000000000	2026-04-30 18:31:44
2630	1117500686	589242	1	17652688	2025-12-18 14:12:00
2631	1117500686	589243	2	000000000	2026-04-30 18:31:44
2632	1117500686	589244	1	6801355	2026-04-26 22:04:00
2633	1117500686	589245	1	17656065	2026-04-16 11:04:00
2634	1117500686	589246	1	1117515166	2026-04-13 14:04:00
2635	1117500686	589247	1	96328076	2026-02-26 18:02:00
2636	1117500686	589248	1	17652688	2025-12-18 14:12:00
2637	1117500686	589249	2	000000000	2026-04-30 18:31:44
2638	1117500686	589250	1	40776309	2026-03-22 19:03:00
2639	1117500686	588712	2	000000000	2026-04-30 18:31:44
2640	1117500686	588980	2	000000000	2026-04-30 18:31:44
2641	1117500686	588981	2	000000000	2026-04-30 18:31:44
2642	1117500686	588982	2	000000000	2026-04-30 18:31:44
2643	1117500686	588983	2	000000000	2026-04-30 18:31:44
2644	1117500686	588984	2	000000000	2026-04-30 18:31:44
2645	1117500686	588985	2	000000000	2026-04-30 18:31:44
2646	1117500686	588986	2	000000000	2026-04-30 18:31:44
2647	1117500686	588987	2	000000000	2026-04-30 18:31:44
2648	1117500686	588988	2	000000000	2026-04-30 18:31:44
2649	1117500686	588989	2	000000000	2026-04-30 18:31:44
2650	1117500686	588990	2	000000000	2026-04-30 18:31:44
2651	1117500686	588991	1	40758842	2026-02-26 07:02:00
2652	1117500686	588992	2	000000000	2026-04-30 18:31:44
2653	1117500686	588940	2	000000000	2026-04-30 18:31:44
2654	1117500686	588941	2	000000000	2026-04-30 18:31:44
2655	1117500686	588942	2	000000000	2026-04-30 18:31:44
2656	1117500686	588943	2	000000000	2026-04-30 18:31:44
2657	1117500686	588944	2	000000000	2026-04-30 18:31:44
2658	1117500686	588945	2	000000000	2026-04-30 18:31:44
2659	1117500686	588946	2	000000000	2026-04-30 18:31:44
2660	1117500686	588947	2	000000000	2026-04-30 18:31:44
2661	1117500686	588948	2	000000000	2026-04-30 18:31:44
2662	1117500686	588949	2	000000000	2026-04-30 18:31:44
2663	1117500686	588950	2	000000000	2026-04-30 18:31:44
2664	1117500686	588951	2	000000000	2026-04-30 18:31:44
2665	1117500686	588952	2	000000000	2026-04-30 18:31:44
2666	1117500686	588953	2	000000000	2026-04-30 18:31:44
2667	1117500686	588954	2	000000000	2026-04-30 18:31:44
2668	1117500686	588955	2	000000000	2026-04-30 18:31:44
2669	1117500686	588956	2	000000000	2026-04-30 18:31:44
2670	1117500686	588993	2	000000000	2026-04-30 18:31:44
2671	1117500686	588994	2	000000000	2026-04-30 18:31:44
2672	1117500686	588995	2	000000000	2026-04-30 18:31:44
2673	1117500686	588996	2	000000000	2026-04-30 18:31:44
2674	1117500686	588997	2	000000000	2026-04-30 18:31:44
2675	1117500686	588998	2	000000000	2026-04-30 18:31:44
2676	1117500686	588999	2	000000000	2026-04-30 18:31:44
2677	1117500686	589000	2	000000000	2026-04-30 18:31:44
2678	1117500686	589001	2	000000000	2026-04-30 18:31:44
2679	1117500686	588957	1	40758842	2026-04-15 07:04:00
2680	1117500686	588958	1	40758842	2026-04-15 07:04:00
2681	1117500686	588959	2	000000000	2026-04-30 18:31:44
2682	1117500686	588960	2	000000000	2026-04-30 18:31:44
2683	1117500686	588961	2	000000000	2026-04-30 18:31:44
2684	1117500686	588962	2	000000000	2026-04-30 18:31:44
2685	1117500686	588963	2	000000000	2026-04-30 18:31:44
2686	1117500686	588964	2	000000000	2026-04-30 18:31:44
2687	1117500686	588965	2	000000000	2026-04-30 18:31:44
2688	1117500686	588966	2	000000000	2026-04-30 18:31:44
2689	1117500686	588967	2	000000000	2026-04-30 18:31:44
2690	1117500686	588968	2	000000000	2026-04-30 18:31:44
2691	1117500686	588969	2	000000000	2026-04-30 18:31:44
2692	1117500686	588970	2	000000000	2026-04-30 18:31:44
2693	1117500686	588971	2	000000000	2026-04-30 18:31:44
2694	1117500686	588972	2	000000000	2026-04-30 18:31:44
2695	1117500686	588973	2	000000000	2026-04-30 18:31:44
2696	1117500686	588974	2	000000000	2026-04-30 18:31:44
2697	1117500686	588975	2	000000000	2026-04-30 18:31:44
2698	1117500686	588976	2	000000000	2026-04-30 18:31:44
2699	1117500686	588977	2	000000000	2026-04-30 18:31:44
2700	1117500686	588978	2	000000000	2026-04-30 18:31:44
2701	1117500686	588979	2	000000000	2026-04-30 18:31:44
2702	1117500686	589020	2	000000000	2026-04-30 18:31:44
2703	1117500686	589021	2	000000000	2026-04-30 18:31:44
2704	1117500686	589022	2	000000000	2026-04-30 18:31:44
2705	1117500686	589251	2	000000000	2026-04-30 18:31:44
2706	1117500686	589252	1	1117532250	2026-03-20 07:03:00
2707	1117500686	589253	2	000000000	2026-04-30 18:31:44
2708	1117500686	589254	1	1117532250	2026-02-17 12:02:00
2709	1117500686	589255	2	000000000	2026-04-30 18:31:44
2710	1117500686	589256	2	000000000	2026-04-30 18:31:44
2711	1117500686	589257	2	000000000	2026-04-30 18:31:44
2712	1117500686	589258	2	000000000	2026-04-30 18:31:44
2713	1117500686	589259	2	000000000	2026-04-30 18:31:44
2714	1117500686	589300	2	000000000	2026-04-30 18:31:44
2715	1117500686	589301	2	000000000	2026-04-30 18:31:44
2716	1117500686	589302	2	000000000	2026-04-30 18:31:44
2717	1117500686	589303	2	000000000	2026-04-30 18:31:44
2718	1117500686	589304	2	000000000	2026-04-30 18:31:44
2719	1117500686	589305	2	000000000	2026-04-30 18:31:44
2720	1117500686	735222	2	000000000	2026-04-30 18:31:44
2721	1117500686	735223	2	000000000	2026-04-30 18:31:44
2722	1117500686	735224	2	000000000	2026-04-30 18:31:44
2723	1117500686	735225	2	000000000	2026-04-30 18:31:44
2724	1117503976	589237	2	000000000	2026-04-30 18:31:44
2725	1117503976	589238	2	000000000	2026-04-30 18:31:44
2726	1117503976	589239	2	000000000	2026-04-30 18:31:44
2727	1117503976	589240	1	17652688	2025-12-18 14:12:00
2728	1117503976	589241	2	000000000	2026-04-30 18:31:44
2729	1117503976	589242	1	17652688	2025-12-18 14:12:00
2730	1117503976	589243	2	000000000	2026-04-30 18:31:44
2731	1117503976	589244	2	000000000	2026-04-30 18:31:44
2732	1117503976	589245	2	000000000	2026-04-30 18:31:45
2733	1117503976	589246	2	000000000	2026-04-30 18:31:45
2734	1117503976	589247	2	000000000	2026-04-30 18:31:45
2735	1117503976	589248	1	17652688	2025-12-18 14:12:00
2736	1117503976	589249	2	000000000	2026-04-30 18:31:45
2737	1117503976	589250	2	000000000	2026-04-30 18:31:45
2738	1117503976	588712	2	000000000	2026-04-30 18:31:45
2739	1117503976	588980	2	000000000	2026-04-30 18:31:45
2740	1117503976	588981	2	000000000	2026-04-30 18:31:45
2741	1117503976	588982	2	000000000	2026-04-30 18:31:45
2742	1117503976	588983	2	000000000	2026-04-30 18:31:45
2743	1117503976	588984	2	000000000	2026-04-30 18:31:45
2744	1117503976	588985	2	000000000	2026-04-30 18:31:45
2745	1117503976	588986	2	000000000	2026-04-30 18:31:45
2746	1117503976	588987	2	000000000	2026-04-30 18:31:45
2747	1117503976	588988	2	000000000	2026-04-30 18:31:45
2748	1117503976	588989	2	000000000	2026-04-30 18:31:45
2749	1117503976	588990	2	000000000	2026-04-30 18:31:45
2750	1117503976	588991	2	000000000	2026-04-30 18:31:45
2751	1117503976	588992	2	000000000	2026-04-30 18:31:45
2752	1117503976	588940	2	000000000	2026-04-30 18:31:45
2753	1117503976	588941	2	000000000	2026-04-30 18:31:45
2754	1117503976	588942	2	000000000	2026-04-30 18:31:45
2755	1117503976	588943	2	000000000	2026-04-30 18:31:45
2756	1117503976	588944	2	000000000	2026-04-30 18:31:45
2757	1117503976	588945	2	000000000	2026-04-30 18:31:45
2758	1117503976	588946	2	000000000	2026-04-30 18:31:45
2759	1117503976	588947	2	000000000	2026-04-30 18:31:45
2760	1117503976	588948	2	000000000	2026-04-30 18:31:45
2761	1117503976	588949	2	000000000	2026-04-30 18:31:45
2762	1117503976	588950	2	000000000	2026-04-30 18:31:45
2763	1117503976	588951	2	000000000	2026-04-30 18:31:45
2764	1117503976	588952	2	000000000	2026-04-30 18:31:45
2765	1117503976	588953	2	000000000	2026-04-30 18:31:45
2766	1117503976	588954	2	000000000	2026-04-30 18:31:45
2767	1117503976	588955	2	000000000	2026-04-30 18:31:45
2768	1117503976	588956	2	000000000	2026-04-30 18:31:45
2769	1117503976	588993	2	000000000	2026-04-30 18:31:45
2770	1117503976	588994	2	000000000	2026-04-30 18:31:45
2771	1117503976	588995	2	000000000	2026-04-30 18:31:45
2772	1117503976	588996	2	000000000	2026-04-30 18:31:45
2773	1117503976	588997	2	000000000	2026-04-30 18:31:45
2774	1117503976	588998	2	000000000	2026-04-30 18:31:45
2775	1117503976	588999	2	000000000	2026-04-30 18:31:45
2776	1117503976	589000	2	000000000	2026-04-30 18:31:45
2777	1117503976	589001	2	000000000	2026-04-30 18:31:45
2778	1117503976	588957	2	000000000	2026-04-30 18:31:45
2779	1117503976	588958	2	000000000	2026-04-30 18:31:45
2780	1117503976	588959	2	000000000	2026-04-30 18:31:45
2781	1117503976	588960	2	000000000	2026-04-30 18:31:45
2782	1117503976	588961	2	000000000	2026-04-30 18:31:45
2783	1117503976	588962	2	000000000	2026-04-30 18:31:45
2784	1117503976	588963	2	000000000	2026-04-30 18:31:45
2785	1117503976	588964	2	000000000	2026-04-30 18:31:45
2786	1117503976	588965	2	000000000	2026-04-30 18:31:45
2787	1117503976	588966	2	000000000	2026-04-30 18:31:45
2788	1117503976	588967	2	000000000	2026-04-30 18:31:45
2789	1117503976	588968	2	000000000	2026-04-30 18:31:45
2790	1117503976	588969	2	000000000	2026-04-30 18:31:45
2791	1117503976	588970	2	000000000	2026-04-30 18:31:45
2792	1117503976	588971	2	000000000	2026-04-30 18:31:45
2793	1117503976	588972	2	000000000	2026-04-30 18:31:45
2794	1117503976	588973	2	000000000	2026-04-30 18:31:45
2795	1117503976	588974	2	000000000	2026-04-30 18:31:45
2796	1117503976	588975	2	000000000	2026-04-30 18:31:45
2797	1117503976	588976	2	000000000	2026-04-30 18:31:45
2798	1117503976	588977	2	000000000	2026-04-30 18:31:45
2799	1117503976	588978	2	000000000	2026-04-30 18:31:45
2800	1117503976	588979	2	000000000	2026-04-30 18:31:45
2801	1117503976	589020	2	000000000	2026-04-30 18:31:45
2802	1117503976	589021	2	000000000	2026-04-30 18:31:45
2803	1117503976	589022	2	000000000	2026-04-30 18:31:45
2804	1117503976	589251	2	000000000	2026-04-30 18:31:45
2805	1117503976	589252	2	000000000	2026-04-30 18:31:45
2806	1117503976	589253	2	000000000	2026-04-30 18:31:45
2807	1117503976	589254	2	000000000	2026-04-30 18:31:45
2808	1117503976	589255	2	000000000	2026-04-30 18:31:45
2809	1117503976	589256	2	000000000	2026-04-30 18:31:45
2810	1117503976	589257	2	000000000	2026-04-30 18:31:45
2811	1117503976	589258	2	000000000	2026-04-30 18:31:45
2812	1117503976	589259	2	000000000	2026-04-30 18:31:45
2813	1117503976	589300	2	000000000	2026-04-30 18:31:45
2814	1117503976	589301	2	000000000	2026-04-30 18:31:45
2815	1117503976	589302	2	000000000	2026-04-30 18:31:45
2816	1117503976	589303	2	000000000	2026-04-30 18:31:45
2817	1117503976	589304	2	000000000	2026-04-30 18:31:45
2818	1117503976	589305	2	000000000	2026-04-30 18:31:45
2819	1117503976	735222	2	000000000	2026-04-30 18:31:45
2820	1117503976	735223	2	000000000	2026-04-30 18:31:45
2821	1117503976	735224	2	000000000	2026-04-30 18:31:45
2822	1117503976	735225	2	000000000	2026-04-30 18:31:45
2823	1117547740	589237	2	000000000	2026-04-30 18:31:45
2824	1117547740	589238	1	96328076	2026-02-26 18:02:00
2825	1117547740	589239	2	000000000	2026-04-30 18:31:45
2826	1117547740	589240	1	17652688	2025-12-18 14:12:00
2827	1117547740	589241	2	000000000	2026-04-30 18:31:45
2828	1117547740	589242	1	17652688	2025-12-18 14:12:00
2829	1117547740	589243	2	000000000	2026-04-30 18:31:45
2830	1117547740	589244	1	6801355	2026-04-26 22:04:00
2831	1117547740	589245	1	17656065	2026-04-16 11:04:00
2832	1117547740	589246	1	1117515166	2026-04-13 14:04:00
2833	1117547740	589247	1	96328076	2026-02-26 18:02:00
2834	1117547740	589248	1	17652688	2025-12-18 14:12:00
2835	1117547740	589249	2	000000000	2026-04-30 18:31:45
2836	1117547740	589250	1	40776309	2026-03-22 19:03:00
2837	1117547740	588712	2	000000000	2026-04-30 18:31:45
2838	1117547740	588980	2	000000000	2026-04-30 18:31:45
2839	1117547740	588981	2	000000000	2026-04-30 18:31:45
2840	1117547740	588982	2	000000000	2026-04-30 18:31:45
2841	1117547740	588983	2	000000000	2026-04-30 18:31:45
2842	1117547740	588984	2	000000000	2026-04-30 18:31:45
2843	1117547740	588985	2	000000000	2026-04-30 18:31:45
2844	1117547740	588986	2	000000000	2026-04-30 18:31:45
2845	1117547740	588987	2	000000000	2026-04-30 18:31:45
2846	1117547740	588988	2	000000000	2026-04-30 18:31:45
2847	1117547740	588989	2	000000000	2026-04-30 18:31:45
2848	1117547740	588990	2	000000000	2026-04-30 18:31:45
2849	1117547740	588991	1	40758842	2026-02-26 07:02:00
2850	1117547740	588992	2	000000000	2026-04-30 18:31:45
2851	1117547740	588940	2	000000000	2026-04-30 18:31:45
2852	1117547740	588941	2	000000000	2026-04-30 18:31:45
2853	1117547740	588942	2	000000000	2026-04-30 18:31:45
2854	1117547740	588943	2	000000000	2026-04-30 18:31:45
2855	1117547740	588944	2	000000000	2026-04-30 18:31:45
2856	1117547740	588945	2	000000000	2026-04-30 18:31:45
2857	1117547740	588946	2	000000000	2026-04-30 18:31:45
2858	1117547740	588947	2	000000000	2026-04-30 18:31:45
2859	1117547740	588948	2	000000000	2026-04-30 18:31:45
2860	1117547740	588949	2	000000000	2026-04-30 18:31:45
2861	1117547740	588950	2	000000000	2026-04-30 18:31:45
2862	1117547740	588951	2	000000000	2026-04-30 18:31:45
2863	1117547740	588952	2	000000000	2026-04-30 18:31:45
2864	1117547740	588953	2	000000000	2026-04-30 18:31:45
2865	1117547740	588954	2	000000000	2026-04-30 18:31:45
2866	1117547740	588955	2	000000000	2026-04-30 18:31:45
2867	1117547740	588956	2	000000000	2026-04-30 18:31:45
2868	1117547740	588993	2	000000000	2026-04-30 18:31:45
2869	1117547740	588994	2	000000000	2026-04-30 18:31:45
2870	1117547740	588995	2	000000000	2026-04-30 18:31:45
2871	1117547740	588996	2	000000000	2026-04-30 18:31:45
2872	1117547740	588997	2	000000000	2026-04-30 18:31:45
2873	1117547740	588998	2	000000000	2026-04-30 18:31:45
2874	1117547740	588999	2	000000000	2026-04-30 18:31:45
2875	1117547740	589000	2	000000000	2026-04-30 18:31:45
2876	1117547740	589001	2	000000000	2026-04-30 18:31:45
2877	1117547740	588957	1	40758842	2026-04-15 07:04:00
2878	1117547740	588958	1	40758842	2026-04-15 07:04:00
2879	1117547740	588959	2	000000000	2026-04-30 18:31:45
2880	1117547740	588960	2	000000000	2026-04-30 18:31:45
2881	1117547740	588961	2	000000000	2026-04-30 18:31:45
2882	1117547740	588962	2	000000000	2026-04-30 18:31:45
2883	1117547740	588963	2	000000000	2026-04-30 18:31:45
2884	1117547740	588964	2	000000000	2026-04-30 18:31:45
2885	1117547740	588965	2	000000000	2026-04-30 18:31:45
2886	1117547740	588966	2	000000000	2026-04-30 18:31:45
2887	1117547740	588967	2	000000000	2026-04-30 18:31:45
2888	1117547740	588968	2	000000000	2026-04-30 18:31:45
2889	1117547740	588969	2	000000000	2026-04-30 18:31:45
2890	1117547740	588970	2	000000000	2026-04-30 18:31:45
2891	1117547740	588971	2	000000000	2026-04-30 18:31:45
2892	1117547740	588972	2	000000000	2026-04-30 18:31:45
2893	1117547740	588973	2	000000000	2026-04-30 18:31:45
2894	1117547740	588974	2	000000000	2026-04-30 18:31:45
2895	1117547740	588975	2	000000000	2026-04-30 18:31:45
2896	1117547740	588976	2	000000000	2026-04-30 18:31:45
2897	1117547740	588977	2	000000000	2026-04-30 18:31:45
2898	1117547740	588978	2	000000000	2026-04-30 18:31:45
2899	1117547740	588979	2	000000000	2026-04-30 18:31:45
2900	1117547740	589020	2	000000000	2026-04-30 18:31:45
2901	1117547740	589021	2	000000000	2026-04-30 18:31:45
2902	1117547740	589022	2	000000000	2026-04-30 18:31:45
2903	1117547740	589251	2	000000000	2026-04-30 18:31:45
2904	1117547740	589252	1	1117532250	2026-03-20 07:03:00
2905	1117547740	589253	2	000000000	2026-04-30 18:31:45
2906	1117547740	589254	1	1117532250	2026-02-17 12:02:00
2907	1117547740	589255	2	000000000	2026-04-30 18:31:45
2908	1117547740	589256	2	000000000	2026-04-30 18:31:45
2909	1117547740	589257	2	000000000	2026-04-30 18:31:45
2910	1117547740	589258	2	000000000	2026-04-30 18:31:45
2911	1117547740	589259	2	000000000	2026-04-30 18:31:45
2912	1117547740	589300	2	000000000	2026-04-30 18:31:45
2913	1117547740	589301	2	000000000	2026-04-30 18:31:45
2914	1117547740	589302	2	000000000	2026-04-30 18:31:45
2915	1117547740	589303	2	000000000	2026-04-30 18:31:45
2916	1117547740	589304	2	000000000	2026-04-30 18:31:45
2917	1117547740	589305	2	000000000	2026-04-30 18:31:45
2918	1117547740	735222	2	000000000	2026-04-30 18:31:45
2919	1117547740	735223	2	000000000	2026-04-30 18:31:45
2920	1117547740	735224	2	000000000	2026-04-30 18:31:45
2921	1117547740	735225	2	000000000	2026-04-30 18:31:45
2922	1117549322	589237	2	000000000	2026-04-30 18:31:45
2923	1117549322	589238	1	96328076	2026-02-26 18:02:00
2924	1117549322	589239	2	000000000	2026-04-30 18:31:45
2925	1117549322	589240	1	17652688	2025-12-18 14:12:00
2926	1117549322	589241	2	000000000	2026-04-30 18:31:45
2927	1117549322	589242	1	17652688	2025-12-18 14:12:00
2928	1117549322	589243	2	000000000	2026-04-30 18:31:45
2929	1117549322	589244	1	6801355	2026-04-26 22:04:00
2930	1117549322	589245	1	17656065	2026-04-16 11:04:00
2931	1117549322	589246	1	1117515166	2026-04-13 14:04:00
2932	1117549322	589247	1	96328076	2026-02-26 18:02:00
2933	1117549322	589248	1	17652688	2025-12-18 14:12:00
2934	1117549322	589249	2	000000000	2026-04-30 18:31:45
2935	1117549322	589250	1	40776309	2026-03-22 19:03:00
2936	1117549322	588712	2	000000000	2026-04-30 18:31:45
2937	1117549322	588980	2	000000000	2026-04-30 18:31:45
2938	1117549322	588981	2	000000000	2026-04-30 18:31:45
2939	1117549322	588982	2	000000000	2026-04-30 18:31:45
2940	1117549322	588983	2	000000000	2026-04-30 18:31:45
2941	1117549322	588984	2	000000000	2026-04-30 18:31:45
2942	1117549322	588985	2	000000000	2026-04-30 18:31:45
2943	1117549322	588986	2	000000000	2026-04-30 18:31:45
2944	1117549322	588987	2	000000000	2026-04-30 18:31:45
2945	1117549322	588988	2	000000000	2026-04-30 18:31:45
2946	1117549322	588989	2	000000000	2026-04-30 18:31:45
2947	1117549322	588990	2	000000000	2026-04-30 18:31:45
2948	1117549322	588991	1	40758842	2026-02-26 07:02:00
2949	1117549322	588992	2	000000000	2026-04-30 18:31:45
2950	1117549322	588940	2	000000000	2026-04-30 18:31:45
2951	1117549322	588941	2	000000000	2026-04-30 18:31:45
2952	1117549322	588942	2	000000000	2026-04-30 18:31:45
2953	1117549322	588943	2	000000000	2026-04-30 18:31:45
2954	1117549322	588944	2	000000000	2026-04-30 18:31:45
2955	1117549322	588945	2	000000000	2026-04-30 18:31:45
2956	1117549322	588946	2	000000000	2026-04-30 18:31:45
2957	1117549322	588947	2	000000000	2026-04-30 18:31:45
2958	1117549322	588948	2	000000000	2026-04-30 18:31:45
2959	1117549322	588949	2	000000000	2026-04-30 18:31:45
2960	1117549322	588950	2	000000000	2026-04-30 18:31:45
2961	1117549322	588951	2	000000000	2026-04-30 18:31:45
2962	1117549322	588952	2	000000000	2026-04-30 18:31:45
2963	1117549322	588953	2	000000000	2026-04-30 18:31:45
2964	1117549322	588954	2	000000000	2026-04-30 18:31:45
2965	1117549322	588955	2	000000000	2026-04-30 18:31:45
2966	1117549322	588956	2	000000000	2026-04-30 18:31:45
2967	1117549322	588993	2	000000000	2026-04-30 18:31:45
2968	1117549322	588994	2	000000000	2026-04-30 18:31:45
2969	1117549322	588995	2	000000000	2026-04-30 18:31:45
2970	1117549322	588996	2	000000000	2026-04-30 18:31:45
2971	1117549322	588997	2	000000000	2026-04-30 18:31:45
2972	1117549322	588998	2	000000000	2026-04-30 18:31:45
2973	1117549322	588999	2	000000000	2026-04-30 18:31:45
2974	1117549322	589000	2	000000000	2026-04-30 18:31:45
2975	1117549322	589001	2	000000000	2026-04-30 18:31:45
2976	1117549322	588957	1	40758842	2026-04-15 07:04:00
2977	1117549322	588958	1	40758842	2026-04-15 07:04:00
2978	1117549322	588959	2	000000000	2026-04-30 18:31:45
2979	1117549322	588960	2	000000000	2026-04-30 18:31:45
2980	1117549322	588961	2	000000000	2026-04-30 18:31:45
2981	1117549322	588962	2	000000000	2026-04-30 18:31:45
2982	1117549322	588963	2	000000000	2026-04-30 18:31:45
2983	1117549322	588964	2	000000000	2026-04-30 18:31:45
2984	1117549322	588965	2	000000000	2026-04-30 18:31:45
2985	1117549322	588966	2	000000000	2026-04-30 18:31:45
2986	1117549322	588967	2	000000000	2026-04-30 18:31:45
2987	1117549322	588968	2	000000000	2026-04-30 18:31:45
2988	1117549322	588969	2	000000000	2026-04-30 18:31:45
2989	1117549322	588970	2	000000000	2026-04-30 18:31:45
2990	1117549322	588971	2	000000000	2026-04-30 18:31:45
2991	1117549322	588972	2	000000000	2026-04-30 18:31:45
2992	1117549322	588973	2	000000000	2026-04-30 18:31:45
2993	1117549322	588974	2	000000000	2026-04-30 18:31:45
2994	1117549322	588975	2	000000000	2026-04-30 18:31:45
2995	1117549322	588976	2	000000000	2026-04-30 18:31:45
2996	1117549322	588977	2	000000000	2026-04-30 18:31:45
2997	1117549322	588978	2	000000000	2026-04-30 18:31:45
2998	1117549322	588979	2	000000000	2026-04-30 18:31:45
2999	1117549322	589020	2	000000000	2026-04-30 18:31:45
3000	1117549322	589021	2	000000000	2026-04-30 18:31:45
3001	1117549322	589022	2	000000000	2026-04-30 18:31:45
3002	1117549322	589251	2	000000000	2026-04-30 18:31:45
3003	1117549322	589252	1	1117532250	2026-03-20 07:03:00
3004	1117549322	589253	2	000000000	2026-04-30 18:31:45
3005	1117549322	589254	1	1117532250	2026-02-17 12:02:00
3006	1117549322	589255	2	000000000	2026-04-30 18:31:45
3007	1117549322	589256	2	000000000	2026-04-30 18:31:45
3008	1117549322	589257	2	000000000	2026-04-30 18:31:45
3009	1117549322	589258	2	000000000	2026-04-30 18:31:45
3010	1117549322	589259	2	000000000	2026-04-30 18:31:45
3011	1117549322	589300	2	000000000	2026-04-30 18:31:45
3012	1117549322	589301	2	000000000	2026-04-30 18:31:45
3013	1117549322	589302	2	000000000	2026-04-30 18:31:45
3014	1117549322	589303	2	000000000	2026-04-30 18:31:45
3015	1117549322	589304	2	000000000	2026-04-30 18:31:45
3016	1117549322	589305	2	000000000	2026-04-30 18:31:45
3017	1117549322	735222	2	000000000	2026-04-30 18:31:45
3018	1117549322	735223	2	000000000	2026-04-30 18:31:45
3019	1117549322	735224	2	000000000	2026-04-30 18:31:45
3020	1117549322	735225	2	000000000	2026-04-30 18:31:45
3021	1117931523	589237	2	000000000	2026-04-30 18:31:45
3022	1117931523	589238	1	96328076	2026-02-26 18:02:00
3023	1117931523	589239	2	000000000	2026-04-30 18:31:45
3024	1117931523	589240	1	17652688	2025-12-18 14:12:00
3025	1117931523	589241	2	000000000	2026-04-30 18:31:45
3026	1117931523	589242	1	17652688	2025-12-18 14:12:00
3027	1117931523	589243	2	000000000	2026-04-30 18:31:45
3028	1117931523	589244	1	6801355	2026-04-26 22:04:00
3029	1117931523	589245	1	17656065	2026-04-16 11:04:00
3030	1117931523	589246	1	1117515166	2026-04-13 14:04:00
3031	1117931523	589247	1	96328076	2026-02-26 18:02:00
3032	1117931523	589248	1	17652688	2025-12-18 14:12:00
3033	1117931523	589249	2	000000000	2026-04-30 18:31:45
3034	1117931523	589250	1	40776309	2026-03-22 19:03:00
3035	1117931523	588712	2	000000000	2026-04-30 18:31:45
3036	1117931523	588980	2	000000000	2026-04-30 18:31:45
3037	1117931523	588981	2	000000000	2026-04-30 18:31:45
3038	1117931523	588982	2	000000000	2026-04-30 18:31:45
3039	1117931523	588983	2	000000000	2026-04-30 18:31:45
3040	1117931523	588984	2	000000000	2026-04-30 18:31:45
3041	1117931523	588985	2	000000000	2026-04-30 18:31:45
3042	1117931523	588986	2	000000000	2026-04-30 18:31:45
3043	1117931523	588987	2	000000000	2026-04-30 18:31:45
3044	1117931523	588988	2	000000000	2026-04-30 18:31:45
3045	1117931523	588989	2	000000000	2026-04-30 18:31:45
3046	1117931523	588990	2	000000000	2026-04-30 18:31:45
3047	1117931523	588991	1	40758842	2026-02-26 07:02:00
3048	1117931523	588992	2	000000000	2026-04-30 18:31:45
3049	1117931523	588940	2	000000000	2026-04-30 18:31:45
3050	1117931523	588941	2	000000000	2026-04-30 18:31:45
3051	1117931523	588942	2	000000000	2026-04-30 18:31:45
3052	1117931523	588943	2	000000000	2026-04-30 18:31:45
3053	1117931523	588944	2	000000000	2026-04-30 18:31:45
3054	1117931523	588945	2	000000000	2026-04-30 18:31:45
3055	1117931523	588946	2	000000000	2026-04-30 18:31:45
3056	1117931523	588947	2	000000000	2026-04-30 18:31:45
3057	1117931523	588948	2	000000000	2026-04-30 18:31:45
3058	1117931523	588949	2	000000000	2026-04-30 18:31:45
3059	1117931523	588950	2	000000000	2026-04-30 18:31:45
3060	1117931523	588951	2	000000000	2026-04-30 18:31:45
3061	1117931523	588952	2	000000000	2026-04-30 18:31:45
3062	1117931523	588953	2	000000000	2026-04-30 18:31:45
3063	1117931523	588954	2	000000000	2026-04-30 18:31:45
3064	1117931523	588955	2	000000000	2026-04-30 18:31:45
3065	1117931523	588956	2	000000000	2026-04-30 18:31:45
3066	1117931523	588993	2	000000000	2026-04-30 18:31:45
3067	1117931523	588994	2	000000000	2026-04-30 18:31:45
3068	1117931523	588995	2	000000000	2026-04-30 18:31:45
3069	1117931523	588996	2	000000000	2026-04-30 18:31:45
3070	1117931523	588997	2	000000000	2026-04-30 18:31:45
3071	1117931523	588998	2	000000000	2026-04-30 18:31:45
3072	1117931523	588999	2	000000000	2026-04-30 18:31:45
3073	1117931523	589000	2	000000000	2026-04-30 18:31:45
3074	1117931523	589001	2	000000000	2026-04-30 18:31:45
3075	1117931523	588957	1	40758842	2026-04-15 07:04:00
3076	1117931523	588958	1	40758842	2026-04-15 07:04:00
3077	1117931523	588959	2	000000000	2026-04-30 18:31:46
3078	1117931523	588960	2	000000000	2026-04-30 18:31:46
3079	1117931523	588961	2	000000000	2026-04-30 18:31:46
3080	1117931523	588962	2	000000000	2026-04-30 18:31:46
3081	1117931523	588963	2	000000000	2026-04-30 18:31:46
3082	1117931523	588964	2	000000000	2026-04-30 18:31:46
3083	1117931523	588965	2	000000000	2026-04-30 18:31:46
3084	1117931523	588966	2	000000000	2026-04-30 18:31:46
3085	1117931523	588967	2	000000000	2026-04-30 18:31:46
3086	1117931523	588968	2	000000000	2026-04-30 18:31:46
3087	1117931523	588969	2	000000000	2026-04-30 18:31:46
3088	1117931523	588970	2	000000000	2026-04-30 18:31:46
3089	1117931523	588971	2	000000000	2026-04-30 18:31:46
3090	1117931523	588972	2	000000000	2026-04-30 18:31:46
3091	1117931523	588973	2	000000000	2026-04-30 18:31:46
3092	1117931523	588974	2	000000000	2026-04-30 18:31:46
3093	1117931523	588975	2	000000000	2026-04-30 18:31:46
3094	1117931523	588976	2	000000000	2026-04-30 18:31:46
3095	1117931523	588977	2	000000000	2026-04-30 18:31:46
3096	1117931523	588978	2	000000000	2026-04-30 18:31:46
3097	1117931523	588979	2	000000000	2026-04-30 18:31:46
3098	1117931523	589020	2	000000000	2026-04-30 18:31:46
3099	1117931523	589021	2	000000000	2026-04-30 18:31:46
3100	1117931523	589022	2	000000000	2026-04-30 18:31:46
3101	1117931523	589251	2	000000000	2026-04-30 18:31:46
3102	1117931523	589252	1	1117532250	2026-03-20 07:03:00
3103	1117931523	589253	2	000000000	2026-04-30 18:31:46
3104	1117931523	589254	1	1117532250	2026-02-17 12:02:00
3105	1117931523	589255	2	000000000	2026-04-30 18:31:46
3106	1117931523	589256	2	000000000	2026-04-30 18:31:46
3107	1117931523	589257	2	000000000	2026-04-30 18:31:46
3108	1117931523	589258	2	000000000	2026-04-30 18:31:46
3109	1117931523	589259	2	000000000	2026-04-30 18:31:46
3110	1117931523	589300	2	000000000	2026-04-30 18:31:46
3111	1117931523	589301	2	000000000	2026-04-30 18:31:46
3112	1117931523	589302	2	000000000	2026-04-30 18:31:46
3113	1117931523	589303	2	000000000	2026-04-30 18:31:46
3114	1117931523	589304	2	000000000	2026-04-30 18:31:46
3115	1117931523	589305	2	000000000	2026-04-30 18:31:46
3116	1117931523	735222	2	000000000	2026-04-30 18:31:46
3117	1117931523	735223	2	000000000	2026-04-30 18:31:46
3118	1117931523	735224	2	000000000	2026-04-30 18:31:46
3119	1117931523	735225	2	000000000	2026-04-30 18:31:46
3120	1118363507	589237	2	000000000	2026-04-30 18:31:46
3121	1118363507	589238	1	96328076	2026-02-26 18:02:00
3122	1118363507	589239	2	000000000	2026-04-30 18:31:46
3123	1118363507	589240	1	17652688	2025-12-18 14:12:00
3124	1118363507	589241	2	000000000	2026-04-30 18:31:46
3125	1118363507	589242	1	17652688	2025-12-18 14:12:00
3126	1118363507	589243	2	000000000	2026-04-30 18:31:46
3127	1118363507	589244	1	6801355	2026-04-26 22:04:00
3128	1118363507	589245	1	17656065	2026-04-16 11:04:00
3129	1118363507	589246	1	1117515166	2026-04-13 14:04:00
3130	1118363507	589247	1	96328076	2026-02-26 18:02:00
3131	1118363507	589248	1	17652688	2025-12-18 14:12:00
3132	1118363507	589249	2	000000000	2026-04-30 18:31:46
3133	1118363507	589250	1	40776309	2026-03-22 19:03:00
3134	1118363507	588712	2	000000000	2026-04-30 18:31:46
3135	1118363507	588980	2	000000000	2026-04-30 18:31:46
3136	1118363507	588981	2	000000000	2026-04-30 18:31:46
3137	1118363507	588982	2	000000000	2026-04-30 18:31:46
3138	1118363507	588983	2	000000000	2026-04-30 18:31:46
3139	1118363507	588984	2	000000000	2026-04-30 18:31:46
3140	1118363507	588985	2	000000000	2026-04-30 18:31:46
3141	1118363507	588986	2	000000000	2026-04-30 18:31:46
3142	1118363507	588987	2	000000000	2026-04-30 18:31:46
3143	1118363507	588988	2	000000000	2026-04-30 18:31:46
3144	1118363507	588989	2	000000000	2026-04-30 18:31:46
3145	1118363507	588990	2	000000000	2026-04-30 18:31:46
3146	1118363507	588991	1	40758842	2026-02-26 07:02:00
3147	1118363507	588992	2	000000000	2026-04-30 18:31:46
3148	1118363507	588940	2	000000000	2026-04-30 18:31:46
3149	1118363507	588941	2	000000000	2026-04-30 18:31:46
3150	1118363507	588942	2	000000000	2026-04-30 18:31:46
3151	1118363507	588943	2	000000000	2026-04-30 18:31:46
3152	1118363507	588944	2	000000000	2026-04-30 18:31:46
3153	1118363507	588945	2	000000000	2026-04-30 18:31:46
3154	1118363507	588946	2	000000000	2026-04-30 18:31:46
3155	1118363507	588947	2	000000000	2026-04-30 18:31:46
3156	1118363507	588948	2	000000000	2026-04-30 18:31:46
3157	1118363507	588949	2	000000000	2026-04-30 18:31:46
3158	1118363507	588950	2	000000000	2026-04-30 18:31:46
3159	1118363507	588951	2	000000000	2026-04-30 18:31:46
3160	1118363507	588952	2	000000000	2026-04-30 18:31:46
3161	1118363507	588953	2	000000000	2026-04-30 18:31:46
3162	1118363507	588954	2	000000000	2026-04-30 18:31:46
3163	1118363507	588955	2	000000000	2026-04-30 18:31:46
3164	1118363507	588956	2	000000000	2026-04-30 18:31:46
3165	1118363507	588993	2	000000000	2026-04-30 18:31:46
3166	1118363507	588994	2	000000000	2026-04-30 18:31:46
3167	1118363507	588995	2	000000000	2026-04-30 18:31:46
3168	1118363507	588996	2	000000000	2026-04-30 18:31:46
3169	1118363507	588997	2	000000000	2026-04-30 18:31:46
3170	1118363507	588998	2	000000000	2026-04-30 18:31:46
3171	1118363507	588999	2	000000000	2026-04-30 18:31:46
3172	1118363507	589000	2	000000000	2026-04-30 18:31:46
3173	1118363507	589001	2	000000000	2026-04-30 18:31:46
3174	1118363507	588957	1	40758842	2026-04-15 07:04:00
3175	1118363507	588958	1	40758842	2026-04-15 07:04:00
3176	1118363507	588959	2	000000000	2026-04-30 18:31:46
3177	1118363507	588960	2	000000000	2026-04-30 18:31:46
3178	1118363507	588961	2	000000000	2026-04-30 18:31:46
3179	1118363507	588962	2	000000000	2026-04-30 18:31:46
3180	1118363507	588963	2	000000000	2026-04-30 18:31:46
3181	1118363507	588964	2	000000000	2026-04-30 18:31:46
3182	1118363507	588965	2	000000000	2026-04-30 18:31:46
3183	1118363507	588966	2	000000000	2026-04-30 18:31:46
3184	1118363507	588967	2	000000000	2026-04-30 18:31:46
3185	1118363507	588968	2	000000000	2026-04-30 18:31:46
3186	1118363507	588969	2	000000000	2026-04-30 18:31:46
3187	1118363507	588970	2	000000000	2026-04-30 18:31:46
3188	1118363507	588971	2	000000000	2026-04-30 18:31:46
3189	1118363507	588972	2	000000000	2026-04-30 18:31:46
3190	1118363507	588973	2	000000000	2026-04-30 18:31:46
3191	1118363507	588974	2	000000000	2026-04-30 18:31:46
3192	1118363507	588975	2	000000000	2026-04-30 18:31:46
3193	1118363507	588976	2	000000000	2026-04-30 18:31:46
3194	1118363507	588977	2	000000000	2026-04-30 18:31:46
3195	1118363507	588978	2	000000000	2026-04-30 18:31:46
3196	1118363507	588979	2	000000000	2026-04-30 18:31:46
3197	1118363507	589020	2	000000000	2026-04-30 18:31:46
3198	1118363507	589021	2	000000000	2026-04-30 18:31:46
3199	1118363507	589022	2	000000000	2026-04-30 18:31:46
3200	1118363507	589251	2	000000000	2026-04-30 18:31:46
3201	1118363507	589252	1	1117532250	2026-03-20 07:03:00
3202	1118363507	589253	2	000000000	2026-04-30 18:31:46
3203	1118363507	589254	1	1117532250	2026-02-17 12:02:00
3204	1118363507	589255	2	000000000	2026-04-30 18:31:46
3205	1118363507	589256	2	000000000	2026-04-30 18:31:46
3206	1118363507	589257	2	000000000	2026-04-30 18:31:46
3207	1118363507	589258	2	000000000	2026-04-30 18:31:46
3208	1118363507	589259	2	000000000	2026-04-30 18:31:46
3209	1118363507	589300	2	000000000	2026-04-30 18:31:46
3210	1118363507	589301	2	000000000	2026-04-30 18:31:46
3211	1118363507	589302	2	000000000	2026-04-30 18:31:46
3212	1118363507	589303	2	000000000	2026-04-30 18:31:46
3213	1118363507	589304	2	000000000	2026-04-30 18:31:46
3214	1118363507	589305	2	000000000	2026-04-30 18:31:46
3215	1118363507	735222	2	000000000	2026-04-30 18:31:46
3216	1118363507	735223	2	000000000	2026-04-30 18:31:46
3217	1118363507	735224	2	000000000	2026-04-30 18:31:46
3218	1118363507	735225	2	000000000	2026-04-30 18:31:46
3219	1118364581	589237	2	000000000	2026-04-30 18:31:46
3220	1118364581	589238	1	96328076	2026-02-26 18:02:00
3221	1118364581	589239	2	000000000	2026-04-30 18:31:46
3222	1118364581	589240	1	17652688	2025-12-18 14:12:00
3223	1118364581	589241	2	000000000	2026-04-30 18:31:46
3224	1118364581	589242	1	17652688	2025-12-18 14:12:00
3225	1118364581	589243	2	000000000	2026-04-30 18:31:46
3226	1118364581	589244	1	6801355	2026-04-26 22:04:00
3227	1118364581	589245	1	17656065	2026-04-16 11:04:00
3228	1118364581	589246	1	1117515166	2026-04-13 14:04:00
3229	1118364581	589247	1	96328076	2026-02-26 18:02:00
3230	1118364581	589248	1	17652688	2025-12-18 14:12:00
3231	1118364581	589249	2	000000000	2026-04-30 18:31:46
3232	1118364581	589250	1	40776309	2026-03-22 19:03:00
3233	1118364581	588712	2	000000000	2026-04-30 18:31:46
3234	1118364581	588980	2	000000000	2026-04-30 18:31:46
3235	1118364581	588981	2	000000000	2026-04-30 18:31:46
3236	1118364581	588982	2	000000000	2026-04-30 18:31:46
3237	1118364581	588983	2	000000000	2026-04-30 18:31:46
3238	1118364581	588984	2	000000000	2026-04-30 18:31:46
3239	1118364581	588985	2	000000000	2026-04-30 18:31:46
3240	1118364581	588986	2	000000000	2026-04-30 18:31:46
3241	1118364581	588987	2	000000000	2026-04-30 18:31:46
3242	1118364581	588988	2	000000000	2026-04-30 18:31:46
3243	1118364581	588989	2	000000000	2026-04-30 18:31:46
3244	1118364581	588990	2	000000000	2026-04-30 18:31:46
3245	1118364581	588991	1	40758842	2026-02-26 07:02:00
3246	1118364581	588992	2	000000000	2026-04-30 18:31:46
3247	1118364581	588940	2	000000000	2026-04-30 18:31:46
3248	1118364581	588941	2	000000000	2026-04-30 18:31:46
3249	1118364581	588942	2	000000000	2026-04-30 18:31:46
3250	1118364581	588943	2	000000000	2026-04-30 18:31:46
3251	1118364581	588944	2	000000000	2026-04-30 18:31:46
3252	1118364581	588945	2	000000000	2026-04-30 18:31:46
3253	1118364581	588946	2	000000000	2026-04-30 18:31:46
3254	1118364581	588947	2	000000000	2026-04-30 18:31:46
3255	1118364581	588948	2	000000000	2026-04-30 18:31:46
3256	1118364581	588949	2	000000000	2026-04-30 18:31:46
3257	1118364581	588950	2	000000000	2026-04-30 18:31:46
3258	1118364581	588951	2	000000000	2026-04-30 18:31:46
3259	1118364581	588952	2	000000000	2026-04-30 18:31:46
3260	1118364581	588953	2	000000000	2026-04-30 18:31:46
3261	1118364581	588954	2	000000000	2026-04-30 18:31:46
3262	1118364581	588955	2	000000000	2026-04-30 18:31:46
3263	1118364581	588956	2	000000000	2026-04-30 18:31:46
3264	1118364581	588993	2	000000000	2026-04-30 18:31:46
3265	1118364581	588994	2	000000000	2026-04-30 18:31:46
3266	1118364581	588995	2	000000000	2026-04-30 18:31:46
3267	1118364581	588996	2	000000000	2026-04-30 18:31:46
3268	1118364581	588997	2	000000000	2026-04-30 18:31:46
3269	1118364581	588998	2	000000000	2026-04-30 18:31:46
3270	1118364581	588999	2	000000000	2026-04-30 18:31:46
3271	1118364581	589000	2	000000000	2026-04-30 18:31:46
3272	1118364581	589001	2	000000000	2026-04-30 18:31:46
3273	1118364581	588957	1	40758842	2026-04-15 07:04:00
3274	1118364581	588958	1	40758842	2026-04-15 07:04:00
3275	1118364581	588959	2	000000000	2026-04-30 18:31:46
3276	1118364581	588960	2	000000000	2026-04-30 18:31:46
3277	1118364581	588961	2	000000000	2026-04-30 18:31:46
3278	1118364581	588962	2	000000000	2026-04-30 18:31:46
3279	1118364581	588963	2	000000000	2026-04-30 18:31:46
3280	1118364581	588964	2	000000000	2026-04-30 18:31:46
3281	1118364581	588965	2	000000000	2026-04-30 18:31:46
3282	1118364581	588966	2	000000000	2026-04-30 18:31:46
3283	1118364581	588967	2	000000000	2026-04-30 18:31:46
3284	1118364581	588968	2	000000000	2026-04-30 18:31:46
3285	1118364581	588969	2	000000000	2026-04-30 18:31:46
3286	1118364581	588970	2	000000000	2026-04-30 18:31:46
3287	1118364581	588971	2	000000000	2026-04-30 18:31:46
3288	1118364581	588972	2	000000000	2026-04-30 18:31:46
3289	1118364581	588973	2	000000000	2026-04-30 18:31:46
3290	1118364581	588974	2	000000000	2026-04-30 18:31:46
3291	1118364581	588975	2	000000000	2026-04-30 18:31:46
3292	1118364581	588976	2	000000000	2026-04-30 18:31:46
3293	1118364581	588977	2	000000000	2026-04-30 18:31:46
3294	1118364581	588978	2	000000000	2026-04-30 18:31:46
3295	1118364581	588979	2	000000000	2026-04-30 18:31:46
3296	1118364581	589020	2	000000000	2026-04-30 18:31:46
3297	1118364581	589021	2	000000000	2026-04-30 18:31:46
3298	1118364581	589022	2	000000000	2026-04-30 18:31:46
3299	1118364581	589251	2	000000000	2026-04-30 18:31:46
3300	1118364581	589252	1	1117532250	2026-03-20 07:03:00
3301	1118364581	589253	2	000000000	2026-04-30 18:31:46
3302	1118364581	589254	1	1117532250	2026-02-17 12:02:00
3303	1118364581	589255	2	000000000	2026-04-30 18:31:46
3304	1118364581	589256	2	000000000	2026-04-30 18:31:46
3305	1118364581	589257	2	000000000	2026-04-30 18:31:46
3306	1118364581	589258	2	000000000	2026-04-30 18:31:46
3307	1118364581	589259	2	000000000	2026-04-30 18:31:46
3308	1118364581	589300	2	000000000	2026-04-30 18:31:46
3309	1118364581	589301	2	000000000	2026-04-30 18:31:46
3310	1118364581	589302	2	000000000	2026-04-30 18:31:46
3311	1118364581	589303	2	000000000	2026-04-30 18:31:46
3312	1118364581	589304	2	000000000	2026-04-30 18:31:46
3313	1118364581	589305	2	000000000	2026-04-30 18:31:46
3314	1118364581	735222	2	000000000	2026-04-30 18:31:46
3315	1118364581	735223	2	000000000	2026-04-30 18:31:46
3316	1118364581	735224	2	000000000	2026-04-30 18:31:46
3317	1118364581	735225	2	000000000	2026-04-30 18:31:46
3318	1118367796	589237	2	000000000	2026-04-30 18:31:46
3319	1118367796	589238	1	96328076	2026-02-26 18:02:00
3320	1118367796	589239	2	000000000	2026-04-30 18:31:46
3321	1118367796	589240	1	17652688	2025-12-18 14:12:00
3322	1118367796	589241	2	000000000	2026-04-30 18:31:46
3323	1118367796	589242	1	17652688	2025-12-18 14:12:00
3324	1118367796	589243	2	000000000	2026-04-30 18:31:46
3325	1118367796	589244	1	6801355	2026-04-26 22:04:00
3326	1118367796	589245	1	17656065	2026-04-16 11:04:00
3327	1118367796	589246	1	1117515166	2026-04-13 14:04:00
3328	1118367796	589247	1	96328076	2026-02-26 18:02:00
3329	1118367796	589248	1	17652688	2025-12-18 14:12:00
3330	1118367796	589249	2	000000000	2026-04-30 18:31:46
3331	1118367796	589250	1	40776309	2026-03-22 19:03:00
3332	1118367796	588712	2	000000000	2026-04-30 18:31:46
3333	1118367796	588980	2	000000000	2026-04-30 18:31:46
3334	1118367796	588981	2	000000000	2026-04-30 18:31:46
3335	1118367796	588982	2	000000000	2026-04-30 18:31:46
3336	1118367796	588983	2	000000000	2026-04-30 18:31:46
3337	1118367796	588984	2	000000000	2026-04-30 18:31:46
3338	1118367796	588985	2	000000000	2026-04-30 18:31:46
3339	1118367796	588986	2	000000000	2026-04-30 18:31:46
3340	1118367796	588987	2	000000000	2026-04-30 18:31:46
3341	1118367796	588988	2	000000000	2026-04-30 18:31:46
3342	1118367796	588989	2	000000000	2026-04-30 18:31:46
3343	1118367796	588990	2	000000000	2026-04-30 18:31:46
3344	1118367796	588991	1	40758842	2026-02-26 07:02:00
3345	1118367796	588992	2	000000000	2026-04-30 18:31:46
3346	1118367796	588940	2	000000000	2026-04-30 18:31:46
3347	1118367796	588941	2	000000000	2026-04-30 18:31:46
3348	1118367796	588942	2	000000000	2026-04-30 18:31:46
3349	1118367796	588943	2	000000000	2026-04-30 18:31:46
3350	1118367796	588944	2	000000000	2026-04-30 18:31:46
3351	1118367796	588945	2	000000000	2026-04-30 18:31:46
3352	1118367796	588946	2	000000000	2026-04-30 18:31:46
3353	1118367796	588947	2	000000000	2026-04-30 18:31:46
3354	1118367796	588948	2	000000000	2026-04-30 18:31:46
3355	1118367796	588949	2	000000000	2026-04-30 18:31:46
3356	1118367796	588950	2	000000000	2026-04-30 18:31:46
3357	1118367796	588951	2	000000000	2026-04-30 18:31:46
3358	1118367796	588952	2	000000000	2026-04-30 18:31:46
3359	1118367796	588953	2	000000000	2026-04-30 18:31:46
3360	1118367796	588954	2	000000000	2026-04-30 18:31:46
3361	1118367796	588955	2	000000000	2026-04-30 18:31:46
3362	1118367796	588956	2	000000000	2026-04-30 18:31:46
3363	1118367796	588993	2	000000000	2026-04-30 18:31:46
3364	1118367796	588994	2	000000000	2026-04-30 18:31:46
3365	1118367796	588995	2	000000000	2026-04-30 18:31:46
3366	1118367796	588996	2	000000000	2026-04-30 18:31:46
3367	1118367796	588997	2	000000000	2026-04-30 18:31:46
3368	1118367796	588998	2	000000000	2026-04-30 18:31:46
3369	1118367796	588999	2	000000000	2026-04-30 18:31:46
3370	1118367796	589000	2	000000000	2026-04-30 18:31:46
3371	1118367796	589001	2	000000000	2026-04-30 18:31:46
3372	1118367796	588957	1	40758842	2026-04-15 07:04:00
3373	1118367796	588958	1	40758842	2026-04-15 07:04:00
3374	1118367796	588959	2	000000000	2026-04-30 18:31:46
3375	1118367796	588960	2	000000000	2026-04-30 18:31:46
3376	1118367796	588961	2	000000000	2026-04-30 18:31:46
3377	1118367796	588962	2	000000000	2026-04-30 18:31:46
3378	1118367796	588963	2	000000000	2026-04-30 18:31:46
3379	1118367796	588964	2	000000000	2026-04-30 18:31:46
3380	1118367796	588965	2	000000000	2026-04-30 18:31:46
3381	1118367796	588966	2	000000000	2026-04-30 18:31:46
3382	1118367796	588967	2	000000000	2026-04-30 18:31:46
3383	1118367796	588968	2	000000000	2026-04-30 18:31:46
3384	1118367796	588969	2	000000000	2026-04-30 18:31:46
3385	1118367796	588970	2	000000000	2026-04-30 18:31:46
3386	1118367796	588971	2	000000000	2026-04-30 18:31:46
3387	1118367796	588972	2	000000000	2026-04-30 18:31:46
3388	1118367796	588973	2	000000000	2026-04-30 18:31:46
3389	1118367796	588974	2	000000000	2026-04-30 18:31:46
3390	1118367796	588975	2	000000000	2026-04-30 18:31:46
3391	1118367796	588976	2	000000000	2026-04-30 18:31:46
3392	1118367796	588977	2	000000000	2026-04-30 18:31:46
3393	1118367796	588978	2	000000000	2026-04-30 18:31:47
3394	1118367796	588979	2	000000000	2026-04-30 18:31:47
3395	1118367796	589020	2	000000000	2026-04-30 18:31:47
3396	1118367796	589021	2	000000000	2026-04-30 18:31:47
3397	1118367796	589022	2	000000000	2026-04-30 18:31:47
3398	1118367796	589251	2	000000000	2026-04-30 18:31:47
3399	1118367796	589252	1	1117532250	2026-03-20 07:03:00
3400	1118367796	589253	2	000000000	2026-04-30 18:31:47
3401	1118367796	589254	1	1117532250	2026-02-17 12:02:00
3402	1118367796	589255	2	000000000	2026-04-30 18:31:47
3403	1118367796	589256	2	000000000	2026-04-30 18:31:47
3404	1118367796	589257	2	000000000	2026-04-30 18:31:47
3405	1118367796	589258	2	000000000	2026-04-30 18:31:47
3406	1118367796	589259	2	000000000	2026-04-30 18:31:47
3407	1118367796	589300	2	000000000	2026-04-30 18:31:47
3408	1118367796	589301	2	000000000	2026-04-30 18:31:47
3409	1118367796	589302	2	000000000	2026-04-30 18:31:47
3410	1118367796	589303	2	000000000	2026-04-30 18:31:47
3411	1118367796	589304	2	000000000	2026-04-30 18:31:47
3412	1118367796	589305	2	000000000	2026-04-30 18:31:47
3413	1118367796	735222	2	000000000	2026-04-30 18:31:47
3414	1118367796	735223	2	000000000	2026-04-30 18:31:47
3415	1118367796	735224	2	000000000	2026-04-30 18:31:47
3416	1118367796	735225	2	000000000	2026-04-30 18:31:47
3417	1118369645	589237	2	000000000	2026-04-30 18:31:47
3418	1118369645	589238	1	96328076	2026-02-26 18:02:00
3419	1118369645	589239	2	000000000	2026-04-30 18:31:47
3420	1118369645	589240	1	17652688	2025-12-18 14:12:00
3421	1118369645	589241	2	000000000	2026-04-30 18:31:47
3422	1118369645	589242	1	17652688	2025-12-18 14:12:00
3423	1118369645	589243	2	000000000	2026-04-30 18:31:47
3424	1118369645	589244	1	6801355	2026-04-26 22:04:00
3425	1118369645	589245	1	17656065	2026-04-16 11:04:00
3426	1118369645	589246	1	1117515166	2026-04-13 14:04:00
3427	1118369645	589247	1	96328076	2026-02-26 18:02:00
3428	1118369645	589248	1	17652688	2025-12-18 14:12:00
3429	1118369645	589249	2	000000000	2026-04-30 18:31:47
3430	1118369645	589250	1	40776309	2026-03-22 19:03:00
3431	1118369645	588712	2	000000000	2026-04-30 18:31:47
3432	1118369645	588980	2	000000000	2026-04-30 18:31:47
3433	1118369645	588981	2	000000000	2026-04-30 18:31:47
3434	1118369645	588982	2	000000000	2026-04-30 18:31:47
3435	1118369645	588983	2	000000000	2026-04-30 18:31:47
3436	1118369645	588984	2	000000000	2026-04-30 18:31:47
3437	1118369645	588985	2	000000000	2026-04-30 18:31:47
3438	1118369645	588986	2	000000000	2026-04-30 18:31:47
3439	1118369645	588987	2	000000000	2026-04-30 18:31:47
3440	1118369645	588988	2	000000000	2026-04-30 18:31:47
3441	1118369645	588989	2	000000000	2026-04-30 18:31:47
3442	1118369645	588990	2	000000000	2026-04-30 18:31:47
3443	1118369645	588991	1	40758842	2026-02-26 07:02:00
3444	1118369645	588992	2	000000000	2026-04-30 18:31:47
3445	1118369645	588940	2	000000000	2026-04-30 18:31:47
3446	1118369645	588941	2	000000000	2026-04-30 18:31:47
3447	1118369645	588942	2	000000000	2026-04-30 18:31:47
3448	1118369645	588943	2	000000000	2026-04-30 18:31:47
3449	1118369645	588944	2	000000000	2026-04-30 18:31:47
3450	1118369645	588945	2	000000000	2026-04-30 18:31:47
3451	1118369645	588946	2	000000000	2026-04-30 18:31:47
3452	1118369645	588947	2	000000000	2026-04-30 18:31:47
3453	1118369645	588948	2	000000000	2026-04-30 18:31:47
3454	1118369645	588949	2	000000000	2026-04-30 18:31:47
3455	1118369645	588950	2	000000000	2026-04-30 18:31:47
3456	1118369645	588951	2	000000000	2026-04-30 18:31:47
3457	1118369645	588952	2	000000000	2026-04-30 18:31:47
3458	1118369645	588953	2	000000000	2026-04-30 18:31:47
3459	1118369645	588954	2	000000000	2026-04-30 18:31:47
3460	1118369645	588955	2	000000000	2026-04-30 18:31:47
3461	1118369645	588956	2	000000000	2026-04-30 18:31:47
3462	1118369645	588993	2	000000000	2026-04-30 18:31:47
3463	1118369645	588994	2	000000000	2026-04-30 18:31:47
3464	1118369645	588995	2	000000000	2026-04-30 18:31:47
3465	1118369645	588996	2	000000000	2026-04-30 18:31:47
3466	1118369645	588997	2	000000000	2026-04-30 18:31:47
3467	1118369645	588998	2	000000000	2026-04-30 18:31:47
3468	1118369645	588999	2	000000000	2026-04-30 18:31:47
3469	1118369645	589000	2	000000000	2026-04-30 18:31:47
3470	1118369645	589001	2	000000000	2026-04-30 18:31:47
3471	1118369645	588957	1	40758842	2026-04-15 07:04:00
3472	1118369645	588958	1	40758842	2026-04-15 07:04:00
3473	1118369645	588959	2	000000000	2026-04-30 18:31:47
3474	1118369645	588960	2	000000000	2026-04-30 18:31:47
3475	1118369645	588961	2	000000000	2026-04-30 18:31:47
3476	1118369645	588962	2	000000000	2026-04-30 18:31:47
3477	1118369645	588963	2	000000000	2026-04-30 18:31:47
3478	1118369645	588964	2	000000000	2026-04-30 18:31:47
3479	1118369645	588965	2	000000000	2026-04-30 18:31:47
3480	1118369645	588966	2	000000000	2026-04-30 18:31:47
3481	1118369645	588967	2	000000000	2026-04-30 18:31:47
3482	1118369645	588968	2	000000000	2026-04-30 18:31:47
3483	1118369645	588969	2	000000000	2026-04-30 18:31:47
3484	1118369645	588970	2	000000000	2026-04-30 18:31:47
3485	1118369645	588971	2	000000000	2026-04-30 18:31:47
3486	1118369645	588972	2	000000000	2026-04-30 18:31:47
3487	1118369645	588973	2	000000000	2026-04-30 18:31:47
3488	1118369645	588974	2	000000000	2026-04-30 18:31:47
3489	1118369645	588975	2	000000000	2026-04-30 18:31:47
3490	1118369645	588976	2	000000000	2026-04-30 18:31:47
3491	1118369645	588977	2	000000000	2026-04-30 18:31:47
3492	1118369645	588978	2	000000000	2026-04-30 18:31:47
3493	1118369645	588979	2	000000000	2026-04-30 18:31:47
3494	1118369645	589020	2	000000000	2026-04-30 18:31:47
3495	1118369645	589021	2	000000000	2026-04-30 18:31:47
3496	1118369645	589022	2	000000000	2026-04-30 18:31:47
3497	1118369645	589251	2	000000000	2026-04-30 18:31:47
3498	1118369645	589252	1	1117532250	2026-03-20 07:03:00
3499	1118369645	589253	2	000000000	2026-04-30 18:31:47
3500	1118369645	589254	1	1117532250	2026-02-17 12:02:00
3501	1118369645	589255	2	000000000	2026-04-30 18:31:47
3502	1118369645	589256	2	000000000	2026-04-30 18:31:47
3503	1118369645	589257	2	000000000	2026-04-30 18:31:47
3504	1118369645	589258	2	000000000	2026-04-30 18:31:47
3505	1118369645	589259	2	000000000	2026-04-30 18:31:47
3506	1118369645	589300	2	000000000	2026-04-30 18:31:47
3507	1118369645	589301	2	000000000	2026-04-30 18:31:47
3508	1118369645	589302	2	000000000	2026-04-30 18:31:47
3509	1118369645	589303	2	000000000	2026-04-30 18:31:47
3510	1118369645	589304	2	000000000	2026-04-30 18:31:47
3511	1118369645	589305	2	000000000	2026-04-30 18:31:47
3512	1118369645	735222	2	000000000	2026-04-30 18:31:47
3513	1118369645	735223	2	000000000	2026-04-30 18:31:47
3514	1118369645	735224	2	000000000	2026-04-30 18:31:47
3515	1118369645	735225	2	000000000	2026-04-30 18:31:47
3516	1119212359	589237	2	000000000	2026-04-30 18:31:47
3517	1119212359	589238	2	000000000	2026-04-30 18:31:47
3518	1119212359	589239	2	000000000	2026-04-30 18:31:47
3519	1119212359	589240	1	17652688	2025-12-18 14:12:00
3520	1119212359	589241	2	000000000	2026-04-30 18:31:47
3521	1119212359	589242	1	17652688	2025-12-18 14:12:00
3522	1119212359	589243	2	000000000	2026-04-30 18:31:47
3523	1119212359	589244	2	000000000	2026-04-30 18:31:47
3524	1119212359	589245	2	000000000	2026-04-30 18:31:47
3525	1119212359	589246	2	000000000	2026-04-30 18:31:47
3526	1119212359	589247	2	000000000	2026-04-30 18:31:47
3527	1119212359	589248	1	17652688	2025-12-18 14:12:00
3528	1119212359	589249	2	000000000	2026-04-30 18:31:47
3529	1119212359	589250	2	000000000	2026-04-30 18:31:47
3530	1119212359	588712	2	000000000	2026-04-30 18:31:47
3531	1119212359	588980	2	000000000	2026-04-30 18:31:47
3532	1119212359	588981	2	000000000	2026-04-30 18:31:47
3533	1119212359	588982	2	000000000	2026-04-30 18:31:47
3534	1119212359	588983	2	000000000	2026-04-30 18:31:47
3535	1119212359	588984	2	000000000	2026-04-30 18:31:47
3536	1119212359	588985	2	000000000	2026-04-30 18:31:47
3537	1119212359	588986	2	000000000	2026-04-30 18:31:47
3538	1119212359	588987	2	000000000	2026-04-30 18:31:47
3539	1119212359	588988	2	000000000	2026-04-30 18:31:47
3540	1119212359	588989	2	000000000	2026-04-30 18:31:47
3541	1119212359	588990	2	000000000	2026-04-30 18:31:47
3542	1119212359	588991	2	000000000	2026-04-30 18:31:47
3543	1119212359	588992	2	000000000	2026-04-30 18:31:47
3544	1119212359	588940	2	000000000	2026-04-30 18:31:47
3545	1119212359	588941	2	000000000	2026-04-30 18:31:47
3546	1119212359	588942	2	000000000	2026-04-30 18:31:47
3547	1119212359	588943	2	000000000	2026-04-30 18:31:47
3548	1119212359	588944	2	000000000	2026-04-30 18:31:47
3549	1119212359	588945	2	000000000	2026-04-30 18:31:47
3550	1119212359	588946	2	000000000	2026-04-30 18:31:47
3551	1119212359	588947	2	000000000	2026-04-30 18:31:47
3552	1119212359	588948	2	000000000	2026-04-30 18:31:47
3553	1119212359	588949	2	000000000	2026-04-30 18:31:47
3554	1119212359	588950	2	000000000	2026-04-30 18:31:47
3555	1119212359	588951	2	000000000	2026-04-30 18:31:47
3556	1119212359	588952	2	000000000	2026-04-30 18:31:47
3557	1119212359	588953	2	000000000	2026-04-30 18:31:47
3558	1119212359	588954	2	000000000	2026-04-30 18:31:47
3559	1119212359	588955	2	000000000	2026-04-30 18:31:47
3560	1119212359	588956	2	000000000	2026-04-30 18:31:47
3561	1119212359	588993	2	000000000	2026-04-30 18:31:47
3562	1119212359	588994	2	000000000	2026-04-30 18:31:47
3563	1119212359	588995	2	000000000	2026-04-30 18:31:47
3564	1119212359	588996	2	000000000	2026-04-30 18:31:47
3565	1119212359	588997	2	000000000	2026-04-30 18:31:47
3566	1119212359	588998	2	000000000	2026-04-30 18:31:47
3567	1119212359	588999	2	000000000	2026-04-30 18:31:47
3568	1119212359	589000	2	000000000	2026-04-30 18:31:47
3569	1119212359	589001	2	000000000	2026-04-30 18:31:47
3570	1119212359	588957	2	000000000	2026-04-30 18:31:47
3571	1119212359	588958	2	000000000	2026-04-30 18:31:47
3572	1119212359	588959	2	000000000	2026-04-30 18:31:47
3573	1119212359	588960	2	000000000	2026-04-30 18:31:47
3574	1119212359	588961	2	000000000	2026-04-30 18:31:47
3575	1119212359	588962	2	000000000	2026-04-30 18:31:47
3576	1119212359	588963	2	000000000	2026-04-30 18:31:47
3577	1119212359	588964	2	000000000	2026-04-30 18:31:47
3578	1119212359	588965	2	000000000	2026-04-30 18:31:47
3579	1119212359	588966	2	000000000	2026-04-30 18:31:47
3580	1119212359	588967	2	000000000	2026-04-30 18:31:47
3581	1119212359	588968	2	000000000	2026-04-30 18:31:47
3582	1119212359	588969	2	000000000	2026-04-30 18:31:47
3583	1119212359	588970	2	000000000	2026-04-30 18:31:47
3584	1119212359	588971	2	000000000	2026-04-30 18:31:47
3585	1119212359	588972	2	000000000	2026-04-30 18:31:47
3586	1119212359	588973	2	000000000	2026-04-30 18:31:47
3587	1119212359	588974	2	000000000	2026-04-30 18:31:47
3588	1119212359	588975	2	000000000	2026-04-30 18:31:47
3589	1119212359	588976	2	000000000	2026-04-30 18:31:47
3590	1119212359	588977	2	000000000	2026-04-30 18:31:47
3591	1119212359	588978	2	000000000	2026-04-30 18:31:47
3592	1119212359	588979	2	000000000	2026-04-30 18:31:47
3593	1119212359	589020	2	000000000	2026-04-30 18:31:47
3594	1119212359	589021	2	000000000	2026-04-30 18:31:47
3595	1119212359	589022	2	000000000	2026-04-30 18:31:47
3596	1119212359	589251	2	000000000	2026-04-30 18:31:47
3597	1119212359	589252	2	000000000	2026-04-30 18:31:47
3598	1119212359	589253	2	000000000	2026-04-30 18:31:47
3599	1119212359	589254	2	000000000	2026-04-30 18:31:47
3600	1119212359	589255	2	000000000	2026-04-30 18:31:47
3601	1119212359	589256	2	000000000	2026-04-30 18:31:47
3602	1119212359	589257	2	000000000	2026-04-30 18:31:47
3603	1119212359	589258	2	000000000	2026-04-30 18:31:47
3604	1119212359	589259	2	000000000	2026-04-30 18:31:47
3605	1119212359	589300	2	000000000	2026-04-30 18:31:47
3606	1119212359	589301	2	000000000	2026-04-30 18:31:47
3607	1119212359	589302	2	000000000	2026-04-30 18:31:47
3608	1119212359	589303	2	000000000	2026-04-30 18:31:47
3609	1119212359	589304	2	000000000	2026-04-30 18:31:47
3610	1119212359	589305	2	000000000	2026-04-30 18:31:47
3611	1119212359	735222	2	000000000	2026-04-30 18:31:47
3612	1119212359	735223	2	000000000	2026-04-30 18:31:47
3613	1119212359	735224	2	000000000	2026-04-30 18:31:47
3614	1119212359	735225	2	000000000	2026-04-30 18:31:47
3615	1119582126	589237	2	000000000	2026-04-30 18:31:47
3616	1119582126	589238	2	000000000	2026-04-30 18:31:47
3617	1119582126	589239	2	000000000	2026-04-30 18:31:47
3618	1119582126	589240	1	17652688	2025-12-18 14:12:00
3619	1119582126	589241	2	000000000	2026-04-30 18:31:47
3620	1119582126	589242	1	17652688	2025-12-18 14:12:00
3621	1119582126	589243	2	000000000	2026-04-30 18:31:47
3622	1119582126	589244	2	000000000	2026-04-30 18:31:47
3623	1119582126	589245	2	000000000	2026-04-30 18:31:47
3624	1119582126	589246	2	000000000	2026-04-30 18:31:47
3625	1119582126	589247	2	000000000	2026-04-30 18:31:47
3626	1119582126	589248	1	17652688	2025-12-18 14:12:00
3627	1119582126	589249	2	000000000	2026-04-30 18:31:47
3628	1119582126	589250	2	000000000	2026-04-30 18:31:47
3629	1119582126	588712	2	000000000	2026-04-30 18:31:47
3630	1119582126	588980	2	000000000	2026-04-30 18:31:47
3631	1119582126	588981	2	000000000	2026-04-30 18:31:47
3632	1119582126	588982	2	000000000	2026-04-30 18:31:47
3633	1119582126	588983	2	000000000	2026-04-30 18:31:47
3634	1119582126	588984	2	000000000	2026-04-30 18:31:47
3635	1119582126	588985	2	000000000	2026-04-30 18:31:47
3636	1119582126	588986	2	000000000	2026-04-30 18:31:47
3637	1119582126	588987	2	000000000	2026-04-30 18:31:47
3638	1119582126	588988	2	000000000	2026-04-30 18:31:47
3639	1119582126	588989	2	000000000	2026-04-30 18:31:47
3640	1119582126	588990	2	000000000	2026-04-30 18:31:47
3641	1119582126	588991	2	000000000	2026-04-30 18:31:47
3642	1119582126	588992	2	000000000	2026-04-30 18:31:47
3643	1119582126	588940	2	000000000	2026-04-30 18:31:47
3644	1119582126	588941	2	000000000	2026-04-30 18:31:47
3645	1119582126	588942	2	000000000	2026-04-30 18:31:47
3646	1119582126	588943	2	000000000	2026-04-30 18:31:47
3647	1119582126	588944	2	000000000	2026-04-30 18:31:47
3648	1119582126	588945	2	000000000	2026-04-30 18:31:47
3649	1119582126	588946	2	000000000	2026-04-30 18:31:47
3650	1119582126	588947	2	000000000	2026-04-30 18:31:47
3651	1119582126	588948	2	000000000	2026-04-30 18:31:47
3652	1119582126	588949	2	000000000	2026-04-30 18:31:47
3653	1119582126	588950	2	000000000	2026-04-30 18:31:47
3654	1119582126	588951	2	000000000	2026-04-30 18:31:47
3655	1119582126	588952	2	000000000	2026-04-30 18:31:47
3656	1119582126	588953	2	000000000	2026-04-30 18:31:47
3657	1119582126	588954	2	000000000	2026-04-30 18:31:47
3658	1119582126	588955	2	000000000	2026-04-30 18:31:47
3659	1119582126	588956	2	000000000	2026-04-30 18:31:47
3660	1119582126	588993	2	000000000	2026-04-30 18:31:47
3661	1119582126	588994	2	000000000	2026-04-30 18:31:47
3662	1119582126	588995	2	000000000	2026-04-30 18:31:47
3663	1119582126	588996	2	000000000	2026-04-30 18:31:47
3664	1119582126	588997	2	000000000	2026-04-30 18:31:47
3665	1119582126	588998	2	000000000	2026-04-30 18:31:47
3666	1119582126	588999	2	000000000	2026-04-30 18:31:47
3667	1119582126	589000	2	000000000	2026-04-30 18:31:47
3668	1119582126	589001	2	000000000	2026-04-30 18:31:47
3669	1119582126	588957	2	000000000	2026-04-30 18:31:47
3670	1119582126	588958	2	000000000	2026-04-30 18:31:47
3671	1119582126	588959	2	000000000	2026-04-30 18:31:47
3672	1119582126	588960	2	000000000	2026-04-30 18:31:47
3673	1119582126	588961	2	000000000	2026-04-30 18:31:47
3674	1119582126	588962	2	000000000	2026-04-30 18:31:47
3675	1119582126	588963	2	000000000	2026-04-30 18:31:47
3676	1119582126	588964	2	000000000	2026-04-30 18:31:47
3677	1119582126	588965	2	000000000	2026-04-30 18:31:47
3678	1119582126	588966	2	000000000	2026-04-30 18:31:47
3679	1119582126	588967	2	000000000	2026-04-30 18:31:47
3680	1119582126	588968	2	000000000	2026-04-30 18:31:47
3681	1119582126	588969	2	000000000	2026-04-30 18:31:47
3682	1119582126	588970	2	000000000	2026-04-30 18:31:47
3683	1119582126	588971	2	000000000	2026-04-30 18:31:47
3684	1119582126	588972	2	000000000	2026-04-30 18:31:47
3685	1119582126	588973	2	000000000	2026-04-30 18:31:47
3686	1119582126	588974	2	000000000	2026-04-30 18:31:47
3687	1119582126	588975	2	000000000	2026-04-30 18:31:47
3688	1119582126	588976	2	000000000	2026-04-30 18:31:47
3689	1119582126	588977	2	000000000	2026-04-30 18:31:47
3690	1119582126	588978	2	000000000	2026-04-30 18:31:47
3691	1119582126	588979	2	000000000	2026-04-30 18:31:47
3692	1119582126	589020	2	000000000	2026-04-30 18:31:47
3693	1119582126	589021	2	000000000	2026-04-30 18:31:47
3694	1119582126	589022	2	000000000	2026-04-30 18:31:47
3695	1119582126	589251	2	000000000	2026-04-30 18:31:47
3696	1119582126	589252	2	000000000	2026-04-30 18:31:47
3697	1119582126	589253	2	000000000	2026-04-30 18:31:47
3698	1119582126	589254	2	000000000	2026-04-30 18:31:47
3699	1119582126	589255	2	000000000	2026-04-30 18:31:47
3700	1119582126	589256	2	000000000	2026-04-30 18:31:47
3701	1119582126	589257	2	000000000	2026-04-30 18:31:47
3702	1119582126	589258	2	000000000	2026-04-30 18:31:47
3703	1119582126	589259	2	000000000	2026-04-30 18:31:47
3704	1119582126	589300	2	000000000	2026-04-30 18:31:47
3705	1119582126	589301	2	000000000	2026-04-30 18:31:47
3706	1119582126	589302	2	000000000	2026-04-30 18:31:47
3707	1119582126	589303	2	000000000	2026-04-30 18:31:47
3708	1119582126	589304	2	000000000	2026-04-30 18:31:47
3709	1119582126	589305	2	000000000	2026-04-30 18:31:47
3710	1119582126	735222	2	000000000	2026-04-30 18:31:47
3711	1119582126	735223	2	000000000	2026-04-30 18:31:47
3712	1119582126	735224	2	000000000	2026-04-30 18:31:47
3713	1119582126	735225	2	000000000	2026-04-30 18:31:47
3714	1138924034	589237	2	000000000	2026-04-30 18:31:47
3715	1138924034	589238	1	96328076	2026-02-26 18:02:00
3716	1138924034	589239	2	000000000	2026-04-30 18:31:47
3717	1138924034	589240	1	17652688	2025-12-18 14:12:00
3718	1138924034	589241	2	000000000	2026-04-30 18:31:47
3719	1138924034	589242	1	17652688	2025-12-18 14:12:00
3720	1138924034	589243	2	000000000	2026-04-30 18:31:47
3721	1138924034	589244	1	6801355	2026-04-26 22:04:00
3722	1138924034	589245	1	17656065	2026-04-16 11:04:00
3723	1138924034	589246	1	1117515166	2026-04-13 14:04:00
3724	1138924034	589247	1	96328076	2026-02-26 18:02:00
3725	1138924034	589248	1	17652688	2025-12-18 14:12:00
3726	1138924034	589249	2	000000000	2026-04-30 18:31:47
3727	1138924034	589250	1	40776309	2026-03-22 19:03:00
3728	1138924034	588712	2	000000000	2026-04-30 18:31:47
3729	1138924034	588980	2	000000000	2026-04-30 18:31:47
3730	1138924034	588981	2	000000000	2026-04-30 18:31:47
3731	1138924034	588982	2	000000000	2026-04-30 18:31:47
3732	1138924034	588983	2	000000000	2026-04-30 18:31:47
3733	1138924034	588984	2	000000000	2026-04-30 18:31:47
3734	1138924034	588985	2	000000000	2026-04-30 18:31:47
3735	1138924034	588986	2	000000000	2026-04-30 18:31:47
3736	1138924034	588987	2	000000000	2026-04-30 18:31:47
3737	1138924034	588988	2	000000000	2026-04-30 18:31:47
3738	1138924034	588989	2	000000000	2026-04-30 18:31:47
3739	1138924034	588990	2	000000000	2026-04-30 18:31:47
3740	1138924034	588991	1	40758842	2026-02-26 07:02:00
3741	1138924034	588992	2	000000000	2026-04-30 18:31:47
3742	1138924034	588940	2	000000000	2026-04-30 18:31:47
3743	1138924034	588941	2	000000000	2026-04-30 18:31:47
3744	1138924034	588942	2	000000000	2026-04-30 18:31:47
3745	1138924034	588943	2	000000000	2026-04-30 18:31:47
3746	1138924034	588944	2	000000000	2026-04-30 18:31:47
3747	1138924034	588945	2	000000000	2026-04-30 18:31:47
3748	1138924034	588946	2	000000000	2026-04-30 18:31:47
3749	1138924034	588947	2	000000000	2026-04-30 18:31:47
3750	1138924034	588948	2	000000000	2026-04-30 18:31:47
3751	1138924034	588949	2	000000000	2026-04-30 18:31:47
3752	1138924034	588950	2	000000000	2026-04-30 18:31:47
3753	1138924034	588951	2	000000000	2026-04-30 18:31:47
3754	1138924034	588952	2	000000000	2026-04-30 18:31:47
3755	1138924034	588953	2	000000000	2026-04-30 18:31:47
3756	1138924034	588954	2	000000000	2026-04-30 18:31:47
3757	1138924034	588955	2	000000000	2026-04-30 18:31:47
3758	1138924034	588956	2	000000000	2026-04-30 18:31:47
3759	1138924034	588993	2	000000000	2026-04-30 18:31:47
3760	1138924034	588994	2	000000000	2026-04-30 18:31:47
3761	1138924034	588995	2	000000000	2026-04-30 18:31:47
3762	1138924034	588996	2	000000000	2026-04-30 18:31:47
3763	1138924034	588997	2	000000000	2026-04-30 18:31:47
3764	1138924034	588998	2	000000000	2026-04-30 18:31:47
3765	1138924034	588999	2	000000000	2026-04-30 18:31:47
3766	1138924034	589000	2	000000000	2026-04-30 18:31:47
3767	1138924034	589001	2	000000000	2026-04-30 18:31:47
3768	1138924034	588957	1	40758842	2026-04-15 07:04:00
3769	1138924034	588958	1	40758842	2026-04-15 07:04:00
3770	1138924034	588959	2	000000000	2026-04-30 18:31:48
3771	1138924034	588960	2	000000000	2026-04-30 18:31:48
3772	1138924034	588961	2	000000000	2026-04-30 18:31:48
3773	1138924034	588962	2	000000000	2026-04-30 18:31:48
3774	1138924034	588963	2	000000000	2026-04-30 18:31:48
3775	1138924034	588964	2	000000000	2026-04-30 18:31:48
3776	1138924034	588965	2	000000000	2026-04-30 18:31:48
3777	1138924034	588966	2	000000000	2026-04-30 18:31:48
3778	1138924034	588967	2	000000000	2026-04-30 18:31:48
3779	1138924034	588968	2	000000000	2026-04-30 18:31:48
3780	1138924034	588969	2	000000000	2026-04-30 18:31:48
3781	1138924034	588970	2	000000000	2026-04-30 18:31:48
3782	1138924034	588971	2	000000000	2026-04-30 18:31:48
3783	1138924034	588972	2	000000000	2026-04-30 18:31:48
3784	1138924034	588973	2	000000000	2026-04-30 18:31:48
3785	1138924034	588974	2	000000000	2026-04-30 18:31:48
3786	1138924034	588975	2	000000000	2026-04-30 18:31:48
3787	1138924034	588976	2	000000000	2026-04-30 18:31:48
3788	1138924034	588977	2	000000000	2026-04-30 18:31:48
3789	1138924034	588978	2	000000000	2026-04-30 18:31:48
3790	1138924034	588979	2	000000000	2026-04-30 18:31:48
3791	1138924034	589020	2	000000000	2026-04-30 18:31:48
3792	1138924034	589021	2	000000000	2026-04-30 18:31:48
3793	1138924034	589022	2	000000000	2026-04-30 18:31:48
3794	1138924034	589251	2	000000000	2026-04-30 18:31:48
3795	1138924034	589252	1	1117532250	2026-03-20 07:03:00
3796	1138924034	589253	2	000000000	2026-04-30 18:31:48
3797	1138924034	589254	1	1117532250	2026-02-17 12:02:00
3798	1138924034	589255	2	000000000	2026-04-30 18:31:48
3799	1138924034	589256	2	000000000	2026-04-30 18:31:48
3800	1138924034	589257	2	000000000	2026-04-30 18:31:48
3801	1138924034	589258	2	000000000	2026-04-30 18:31:48
3802	1138924034	589259	2	000000000	2026-04-30 18:31:48
3803	1138924034	589300	2	000000000	2026-04-30 18:31:48
3804	1138924034	589301	2	000000000	2026-04-30 18:31:48
3805	1138924034	589302	2	000000000	2026-04-30 18:31:48
3806	1138924034	589303	2	000000000	2026-04-30 18:31:48
3807	1138924034	589304	2	000000000	2026-04-30 18:31:48
3808	1138924034	589305	2	000000000	2026-04-30 18:31:48
3809	1138924034	735222	2	000000000	2026-04-30 18:31:48
3810	1138924034	735223	2	000000000	2026-04-30 18:31:48
3811	1138924034	735224	2	000000000	2026-04-30 18:31:48
3812	1138924034	735225	2	000000000	2026-04-30 18:31:48
3813	1143324526	589237	2	000000000	2026-04-30 18:31:48
3814	1143324526	589238	2	000000000	2026-04-30 18:31:48
3815	1143324526	589239	2	000000000	2026-04-30 18:31:48
3816	1143324526	589240	2	000000000	2026-04-30 18:31:48
3817	1143324526	589241	2	000000000	2026-04-30 18:31:48
3818	1143324526	589242	2	000000000	2026-04-30 18:31:48
3819	1143324526	589243	2	000000000	2026-04-30 18:31:48
3820	1143324526	589244	2	000000000	2026-04-30 18:31:48
3821	1143324526	589245	2	000000000	2026-04-30 18:31:48
3822	1143324526	589246	2	000000000	2026-04-30 18:31:48
3823	1143324526	589247	2	000000000	2026-04-30 18:31:48
3824	1143324526	589248	2	000000000	2026-04-30 18:31:48
3825	1143324526	589249	2	000000000	2026-04-30 18:31:48
3826	1143324526	589250	2	000000000	2026-04-30 18:31:48
3827	1143324526	588712	2	000000000	2026-04-30 18:31:48
3828	1143324526	588980	2	000000000	2026-04-30 18:31:48
3829	1143324526	588981	2	000000000	2026-04-30 18:31:48
3830	1143324526	588982	2	000000000	2026-04-30 18:31:48
3831	1143324526	588983	2	000000000	2026-04-30 18:31:48
3832	1143324526	588984	2	000000000	2026-04-30 18:31:48
3833	1143324526	588985	2	000000000	2026-04-30 18:31:48
3834	1143324526	588986	2	000000000	2026-04-30 18:31:48
3835	1143324526	588987	2	000000000	2026-04-30 18:31:48
3836	1143324526	588988	2	000000000	2026-04-30 18:31:48
3837	1143324526	588989	2	000000000	2026-04-30 18:31:48
3838	1143324526	588990	2	000000000	2026-04-30 18:31:48
3839	1143324526	588991	2	000000000	2026-04-30 18:31:48
3840	1143324526	588992	2	000000000	2026-04-30 18:31:48
3841	1143324526	588940	2	000000000	2026-04-30 18:31:48
3842	1143324526	588941	2	000000000	2026-04-30 18:31:48
3843	1143324526	588942	2	000000000	2026-04-30 18:31:48
3844	1143324526	588943	2	000000000	2026-04-30 18:31:48
3845	1143324526	588944	2	000000000	2026-04-30 18:31:48
3846	1143324526	588945	2	000000000	2026-04-30 18:31:48
3847	1143324526	588946	2	000000000	2026-04-30 18:31:48
3848	1143324526	588947	2	000000000	2026-04-30 18:31:48
3849	1143324526	588948	2	000000000	2026-04-30 18:31:48
3850	1143324526	588949	2	000000000	2026-04-30 18:31:48
3851	1143324526	588950	2	000000000	2026-04-30 18:31:48
3852	1143324526	588951	2	000000000	2026-04-30 18:31:48
3853	1143324526	588952	2	000000000	2026-04-30 18:31:48
3854	1143324526	588953	2	000000000	2026-04-30 18:31:48
3855	1143324526	588954	2	000000000	2026-04-30 18:31:48
3856	1143324526	588955	2	000000000	2026-04-30 18:31:48
3857	1143324526	588956	2	000000000	2026-04-30 18:31:48
3858	1143324526	588993	2	000000000	2026-04-30 18:31:48
3859	1143324526	588994	2	000000000	2026-04-30 18:31:48
3860	1143324526	588995	2	000000000	2026-04-30 18:31:48
3861	1143324526	588996	2	000000000	2026-04-30 18:31:48
3862	1143324526	588997	2	000000000	2026-04-30 18:31:48
3863	1143324526	588998	2	000000000	2026-04-30 18:31:48
3864	1143324526	588999	2	000000000	2026-04-30 18:31:48
3865	1143324526	589000	2	000000000	2026-04-30 18:31:48
3866	1143324526	589001	2	000000000	2026-04-30 18:31:48
3867	1143324526	588957	2	000000000	2026-04-30 18:31:48
3868	1143324526	588958	2	000000000	2026-04-30 18:31:48
3869	1143324526	588959	2	000000000	2026-04-30 18:31:48
3870	1143324526	588960	2	000000000	2026-04-30 18:31:48
3871	1143324526	588961	2	000000000	2026-04-30 18:31:48
3872	1143324526	588962	2	000000000	2026-04-30 18:31:48
3873	1143324526	588963	2	000000000	2026-04-30 18:31:48
3874	1143324526	588964	2	000000000	2026-04-30 18:31:48
3875	1143324526	588965	2	000000000	2026-04-30 18:31:48
3876	1143324526	588966	2	000000000	2026-04-30 18:31:48
3877	1143324526	588967	2	000000000	2026-04-30 18:31:48
3878	1143324526	588968	2	000000000	2026-04-30 18:31:48
3879	1143324526	588969	2	000000000	2026-04-30 18:31:48
3880	1143324526	588970	2	000000000	2026-04-30 18:31:48
3881	1143324526	588971	2	000000000	2026-04-30 18:31:48
3882	1143324526	588972	2	000000000	2026-04-30 18:31:48
3883	1143324526	588973	2	000000000	2026-04-30 18:31:48
3884	1143324526	588974	2	000000000	2026-04-30 18:31:48
3885	1143324526	588975	2	000000000	2026-04-30 18:31:48
3886	1143324526	588976	2	000000000	2026-04-30 18:31:48
3887	1143324526	588977	2	000000000	2026-04-30 18:31:48
3888	1143324526	588978	2	000000000	2026-04-30 18:31:48
3889	1143324526	588979	2	000000000	2026-04-30 18:31:48
3890	1143324526	589020	2	000000000	2026-04-30 18:31:48
3891	1143324526	589021	2	000000000	2026-04-30 18:31:48
3892	1143324526	589022	2	000000000	2026-04-30 18:31:48
3893	1143324526	589251	2	000000000	2026-04-30 18:31:48
3894	1143324526	589252	2	000000000	2026-04-30 18:31:48
3895	1143324526	589253	2	000000000	2026-04-30 18:31:48
3896	1143324526	589254	2	000000000	2026-04-30 18:31:48
3897	1143324526	589255	2	000000000	2026-04-30 18:31:48
3898	1143324526	589256	2	000000000	2026-04-30 18:31:48
3899	1143324526	589257	2	000000000	2026-04-30 18:31:48
3900	1143324526	589258	2	000000000	2026-04-30 18:31:48
3901	1143324526	589259	2	000000000	2026-04-30 18:31:48
3902	1143324526	589300	2	000000000	2026-04-30 18:31:48
3903	1143324526	589301	2	000000000	2026-04-30 18:31:48
3904	1143324526	589302	2	000000000	2026-04-30 18:31:48
3905	1143324526	589303	2	000000000	2026-04-30 18:31:48
3906	1143324526	589304	2	000000000	2026-04-30 18:31:48
3907	1143324526	589305	2	000000000	2026-04-30 18:31:48
3908	1143324526	735222	2	000000000	2026-04-30 18:31:48
3909	1143324526	735223	2	000000000	2026-04-30 18:31:48
3910	1143324526	735224	2	000000000	2026-04-30 18:31:48
3911	1143324526	735225	2	000000000	2026-04-30 18:31:48
3912	17653772	589237	2	000000000	2026-04-30 18:31:48
3913	17653772	589238	1	96328076	2026-02-26 18:02:00
3914	17653772	589239	2	000000000	2026-04-30 18:31:48
3915	17653772	589240	1	17652688	2025-12-18 14:12:00
3916	17653772	589241	2	000000000	2026-04-30 18:31:48
3917	17653772	589242	1	17652688	2025-12-18 14:12:00
3918	17653772	589243	2	000000000	2026-04-30 18:31:48
3919	17653772	589244	1	6801355	2026-04-26 22:04:00
3920	17653772	589245	1	17656065	2026-04-16 11:04:00
3921	17653772	589246	1	1117515166	2026-04-13 14:04:00
3922	17653772	589247	1	96328076	2026-02-26 18:02:00
3923	17653772	589248	1	17652688	2025-12-18 14:12:00
3924	17653772	589249	2	000000000	2026-04-30 18:31:48
3925	17653772	589250	1	40776309	2026-03-22 19:03:00
3926	17653772	588712	2	000000000	2026-04-30 18:31:48
3927	17653772	588980	2	000000000	2026-04-30 18:31:48
3928	17653772	588981	2	000000000	2026-04-30 18:31:48
3929	17653772	588982	2	000000000	2026-04-30 18:31:48
3930	17653772	588983	2	000000000	2026-04-30 18:31:48
3931	17653772	588984	2	000000000	2026-04-30 18:31:48
3932	17653772	588985	2	000000000	2026-04-30 18:31:48
3933	17653772	588986	2	000000000	2026-04-30 18:31:48
3934	17653772	588987	2	000000000	2026-04-30 18:31:48
3935	17653772	588988	2	000000000	2026-04-30 18:31:48
3936	17653772	588989	2	000000000	2026-04-30 18:31:48
3937	17653772	588990	2	000000000	2026-04-30 18:31:48
3938	17653772	588991	1	40758842	2026-02-26 07:02:00
3939	17653772	588992	2	000000000	2026-04-30 18:31:48
3940	17653772	588940	2	000000000	2026-04-30 18:31:48
3941	17653772	588941	2	000000000	2026-04-30 18:31:48
3942	17653772	588942	2	000000000	2026-04-30 18:31:48
3943	17653772	588943	2	000000000	2026-04-30 18:31:48
3944	17653772	588944	2	000000000	2026-04-30 18:31:48
3945	17653772	588945	2	000000000	2026-04-30 18:31:48
3946	17653772	588946	2	000000000	2026-04-30 18:31:48
3947	17653772	588947	2	000000000	2026-04-30 18:31:48
3948	17653772	588948	2	000000000	2026-04-30 18:31:48
3949	17653772	588949	2	000000000	2026-04-30 18:31:48
3950	17653772	588950	2	000000000	2026-04-30 18:31:48
3951	17653772	588951	2	000000000	2026-04-30 18:31:48
3952	17653772	588952	2	000000000	2026-04-30 18:31:48
3953	17653772	588953	2	000000000	2026-04-30 18:31:48
3954	17653772	588954	2	000000000	2026-04-30 18:31:48
3955	17653772	588955	2	000000000	2026-04-30 18:31:48
3956	17653772	588956	2	000000000	2026-04-30 18:31:48
3957	17653772	588993	2	000000000	2026-04-30 18:31:48
3958	17653772	588994	2	000000000	2026-04-30 18:31:48
3959	17653772	588995	2	000000000	2026-04-30 18:31:48
3960	17653772	588996	2	000000000	2026-04-30 18:31:48
3961	17653772	588997	2	000000000	2026-04-30 18:31:48
3962	17653772	588998	2	000000000	2026-04-30 18:31:48
3963	17653772	588999	2	000000000	2026-04-30 18:31:48
3964	17653772	589000	2	000000000	2026-04-30 18:31:48
3965	17653772	589001	2	000000000	2026-04-30 18:31:48
3966	17653772	588957	1	40758842	2026-04-15 07:04:00
3967	17653772	588958	1	40758842	2026-04-15 07:04:00
3968	17653772	588959	2	000000000	2026-04-30 18:31:48
3969	17653772	588960	2	000000000	2026-04-30 18:31:48
3970	17653772	588961	2	000000000	2026-04-30 18:31:48
3971	17653772	588962	2	000000000	2026-04-30 18:31:48
3972	17653772	588963	2	000000000	2026-04-30 18:31:48
3973	17653772	588964	2	000000000	2026-04-30 18:31:48
3974	17653772	588965	2	000000000	2026-04-30 18:31:48
3975	17653772	588966	2	000000000	2026-04-30 18:31:48
3976	17653772	588967	2	000000000	2026-04-30 18:31:48
3977	17653772	588968	2	000000000	2026-04-30 18:31:48
3978	17653772	588969	2	000000000	2026-04-30 18:31:48
3979	17653772	588970	2	000000000	2026-04-30 18:31:48
3980	17653772	588971	2	000000000	2026-04-30 18:31:48
3981	17653772	588972	2	000000000	2026-04-30 18:31:48
3982	17653772	588973	2	000000000	2026-04-30 18:31:48
3983	17653772	588974	2	000000000	2026-04-30 18:31:48
3984	17653772	588975	2	000000000	2026-04-30 18:31:48
3985	17653772	588976	2	000000000	2026-04-30 18:31:48
3986	17653772	588977	2	000000000	2026-04-30 18:31:48
3987	17653772	588978	2	000000000	2026-04-30 18:31:48
3988	17653772	588979	2	000000000	2026-04-30 18:31:48
3989	17653772	589020	2	000000000	2026-04-30 18:31:48
3990	17653772	589021	2	000000000	2026-04-30 18:31:48
3991	17653772	589022	2	000000000	2026-04-30 18:31:48
3992	17653772	589251	2	000000000	2026-04-30 18:31:48
3993	17653772	589252	1	1117532250	2026-03-20 07:03:00
3994	17653772	589253	2	000000000	2026-04-30 18:31:48
3995	17653772	589254	1	1117532250	2026-02-17 12:02:00
3996	17653772	589255	2	000000000	2026-04-30 18:31:48
3997	17653772	589256	2	000000000	2026-04-30 18:31:48
3998	17653772	589257	2	000000000	2026-04-30 18:31:48
3999	17653772	589258	2	000000000	2026-04-30 18:31:48
4000	17653772	589259	2	000000000	2026-04-30 18:31:48
4001	17653772	589300	2	000000000	2026-04-30 18:31:48
4002	17653772	589301	2	000000000	2026-04-30 18:31:48
4003	17653772	589302	2	000000000	2026-04-30 18:31:48
4004	17653772	589303	2	000000000	2026-04-30 18:31:48
4005	17653772	589304	2	000000000	2026-04-30 18:31:48
4006	17653772	589305	2	000000000	2026-04-30 18:31:48
4007	17653772	735222	2	000000000	2026-04-30 18:31:48
4008	17653772	735223	2	000000000	2026-04-30 18:31:48
4009	17653772	735224	2	000000000	2026-04-30 18:31:48
4010	17653772	735225	2	000000000	2026-04-30 18:31:48
7613	1117497251	595108	1	28555809	2026-05-06 19:40:50
7614	1117497251	595109	1	28555809	2026-05-06 19:40:50
7615	1117497251	595110	1	28555809	2026-05-06 19:40:50
7616	1117497251	595125	1	28555809	2026-05-06 19:40:50
7617	1117497251	595126	1	28555809	2026-05-06 19:40:50
7618	1117497251	595127	1	28555809	2026-05-06 19:40:50
7619	1117497251	595128	1	28555809	2026-05-06 19:40:50
7620	1117497251	595129	1	28555809	2026-05-06 19:40:50
7621	1117497251	595130	1	28555809	2026-05-06 19:40:50
7622	1117497251	595131	1	28555809	2026-05-06 19:40:50
7623	1117497251	595132	1	28555809	2026-05-06 19:40:50
7624	1117497251	595117	2	000000000	2026-05-06 19:40:50
7625	1117497251	595118	2	000000000	2026-05-06 19:40:50
7626	1117497251	595119	1	1077865671	2026-05-06 19:40:50
7627	1117497251	595120	1	1077865671	2026-05-06 19:40:50
7628	1117497251	595145	1	1117503960	2026-05-06 19:40:50
7629	1117497251	595146	1	1117503960	2026-05-06 19:40:50
7630	1117497251	595147	1	1117503960	2026-05-06 19:40:50
7631	1117497251	595148	1	1117503960	2026-05-06 19:40:50
7632	1117497251	595111	1	28555809	2026-05-06 19:40:50
7633	1117497251	595112	1	28555809	2026-05-06 19:40:50
7634	1117497251	595113	1	28555809	2026-05-06 19:40:50
7635	1117497251	595114	1	28555809	2026-05-06 19:40:50
7636	1117497251	595115	1	28555809	2026-05-06 19:40:50
7637	1117497251	595116	1	28555809	2026-05-06 19:40:50
7638	1117497251	644275	1	28555809	2026-05-06 19:40:50
7639	1117497251	644276	1	28555809	2026-05-06 19:40:50
7640	1117497251	644277	1	28555809	2026-05-06 19:40:50
7641	1117497251	644278	1	28555809	2026-05-06 19:40:50
7642	1117497251	644279	1	6801355	2026-05-06 19:40:50
7643	1117497251	644280	1	6801355	2026-05-06 19:40:50
7644	1117497251	644281	1	6801355	2026-05-06 19:40:50
7645	1117497251	644282	1	6801355	2026-05-06 19:40:50
7646	1117497251	644323	1	96353963	2026-05-06 19:40:50
7647	1117529946	595100	2	000000000	2026-05-06 19:40:50
7648	1117529946	595133	1	26632272	2026-05-06 19:40:50
7649	1117529946	595134	1	26632272	2026-05-06 19:40:50
7650	1117529946	595135	1	26632272	2026-05-06 19:40:50
7651	1117529946	595136	1	26632272	2026-05-06 19:40:50
7652	1117529946	595105	1	28555809	2026-05-06 19:40:50
7653	1117529946	595137	1	96353963	2026-05-06 19:40:50
7654	1117529946	595138	1	96353963	2026-05-06 19:40:50
7655	1117529946	595139	1	96353963	2026-05-06 19:40:50
7656	1117529946	595140	1	96353963	2026-05-06 19:40:50
7657	1117529946	595163	1	6805131	2026-05-06 19:40:50
7658	1117529946	595164	1	6805131	2026-05-06 19:40:50
7659	1117529946	595165	1	6805131	2026-05-06 19:40:50
7660	1117529946	595166	1	6805131	2026-05-06 19:40:50
7661	1117529946	595167	1	6805131	2026-05-06 19:40:50
7662	1117529946	595168	1	6805131	2026-05-06 19:40:50
7663	1117529946	595101	1	40776309	2026-05-06 19:40:50
7664	1117529946	595102	1	1026552707	2026-05-06 19:40:50
7665	1117529946	595103	1	40776309	2026-05-06 19:40:50
7666	1117529946	595104	1	1026552707	2026-05-06 19:40:50
7667	1117529946	595149	1	96328076	2026-05-06 19:40:50
7668	1117529946	595150	1	96328076	2026-05-06 19:40:50
7669	1117529946	595151	1	96328076	2026-05-06 19:40:50
7670	1117529946	595152	1	96328076	2026-05-06 19:40:50
7671	1117529946	595141	1	1117515166	2026-05-06 19:40:50
7672	1117529946	595142	1	1117515166	2026-05-06 19:40:50
7673	1117529946	595143	1	1117515166	2026-05-06 19:40:50
7674	1117529946	595144	1	1117515166	2026-05-06 19:40:50
7675	1117529946	595158	2	000000000	2026-05-06 19:40:50
7676	1117529946	595159	2	000000000	2026-05-06 19:40:50
7677	1117529946	595160	2	000000000	2026-05-06 19:40:50
7678	1117529946	595161	2	000000000	2026-05-06 19:40:50
7679	1117529946	595162	2	000000000	2026-05-06 19:40:50
7680	1117529946	595106	1	28555809	2026-05-06 19:40:50
7681	1117529946	595107	1	28555809	2026-05-06 19:40:50
7682	1117529946	595108	1	28555809	2026-05-06 19:40:50
7683	1117529946	595109	1	28555809	2026-05-06 19:40:50
7684	1117529946	595110	1	28555809	2026-05-06 19:40:50
7685	1117529946	595125	1	28555809	2026-05-06 19:40:50
7686	1117529946	595126	1	28555809	2026-05-06 19:40:50
7687	1117529946	595127	1	28555809	2026-05-06 19:40:50
7688	1117529946	595128	1	28555809	2026-05-06 19:40:50
7689	1117529946	595129	1	28555809	2026-05-06 19:40:50
7690	1117529946	595130	1	28555809	2026-05-06 19:40:50
7691	1117529946	595131	1	28555809	2026-05-06 19:40:50
7692	1117529946	595132	1	28555809	2026-05-06 19:40:50
7693	1117529946	595117	2	000000000	2026-05-06 19:40:50
7694	1117529946	595118	2	000000000	2026-05-06 19:40:50
7695	1117529946	595119	1	1077865671	2026-05-06 19:40:50
7696	1117529946	595120	1	1077865671	2026-05-06 19:40:50
7697	1117529946	595145	1	1117503960	2026-05-06 19:40:50
7698	1117529946	595146	1	1117503960	2026-05-06 19:40:50
7699	1117529946	595147	1	1117503960	2026-05-06 19:40:50
7700	1117529946	595148	1	1117503960	2026-05-06 19:40:50
7701	1117529946	595111	1	28555809	2026-05-06 19:40:50
7702	1117529946	595112	1	28555809	2026-05-06 19:40:50
7703	1117529946	595113	1	28555809	2026-05-06 19:40:50
7704	1117529946	595114	1	28555809	2026-05-06 19:40:50
7705	1117529946	595115	1	28555809	2026-05-06 19:40:50
7706	1117529946	595116	1	28555809	2026-05-06 19:40:50
7707	1117529946	644275	1	28555809	2026-05-06 19:40:50
7708	1117529946	644276	1	28555809	2026-05-06 19:40:50
7709	1117529946	644277	1	28555809	2026-05-06 19:40:50
7710	1117529946	644278	1	28555809	2026-05-06 19:40:50
7711	1117529946	644279	1	6801355	2026-05-06 19:40:50
7712	1117529946	644280	1	6801355	2026-05-06 19:40:50
7713	1117529946	644281	1	6801355	2026-05-06 19:40:51
7714	1117529946	644282	1	6801355	2026-05-06 19:40:51
7715	1117529946	644323	1	96353963	2026-05-06 19:40:51
7716	1117545642	595100	2	000000000	2026-05-06 19:40:51
7717	1117545642	595133	1	26632272	2026-05-06 19:40:51
7718	1117545642	595134	1	26632272	2026-05-06 19:40:51
7719	1117545642	595135	1	26632272	2026-05-06 19:40:51
7720	1117545642	595136	1	26632272	2026-05-06 19:40:51
7721	1117545642	595105	1	28555809	2026-05-06 19:40:51
7722	1117545642	595137	1	96353963	2026-05-06 19:40:51
7723	1117545642	595138	1	96353963	2026-05-06 19:40:51
7724	1117545642	595139	1	96353963	2026-05-06 19:40:51
7725	1117545642	595140	1	96353963	2026-05-06 19:40:51
7726	1117545642	595163	1	6805131	2026-05-06 19:40:51
7727	1117545642	595164	1	6805131	2026-05-06 19:40:51
7728	1117545642	595165	1	6805131	2026-05-06 19:40:51
7729	1117545642	595166	1	6805131	2026-05-06 19:40:51
7730	1117545642	595167	1	6805131	2026-05-06 19:40:51
7731	1117545642	595168	1	6805131	2026-05-06 19:40:51
7732	1117545642	595101	1	40776309	2026-05-06 19:40:51
7733	1117545642	595102	1	1026552707	2026-05-06 19:40:51
7734	1117545642	595103	1	40776309	2026-05-06 19:40:51
7735	1117545642	595104	1	1026552707	2026-05-06 19:40:51
7736	1117545642	595149	1	96328076	2026-05-06 19:40:51
7737	1117545642	595150	1	96328076	2026-05-06 19:40:51
7738	1117545642	595151	1	96328076	2026-05-06 19:40:51
7739	1117545642	595152	1	96328076	2026-05-06 19:40:51
7740	1117545642	595141	1	1117515166	2026-05-06 19:40:51
7741	1117545642	595142	1	1117515166	2026-05-06 19:40:51
7742	1117545642	595143	1	1117515166	2026-05-06 19:40:51
7743	1117545642	595144	1	1117515166	2026-05-06 19:40:51
7744	1117545642	595158	2	000000000	2026-05-06 19:40:51
7745	1117545642	595159	2	000000000	2026-05-06 19:40:51
7746	1117545642	595160	2	000000000	2026-05-06 19:40:51
7747	1117545642	595161	2	000000000	2026-05-06 19:40:51
7748	1117545642	595162	2	000000000	2026-05-06 19:40:51
7749	1117545642	595106	1	28555809	2026-05-06 19:40:51
7750	1117545642	595107	1	28555809	2026-05-06 19:40:51
7751	1117545642	595108	1	28555809	2026-05-06 19:40:51
7752	1117545642	595109	1	28555809	2026-05-06 19:40:51
7753	1117545642	595110	1	28555809	2026-05-06 19:40:51
7754	1117545642	595125	1	28555809	2026-05-06 19:40:51
7755	1117545642	595126	1	28555809	2026-05-06 19:40:51
7756	1117545642	595127	1	28555809	2026-05-06 19:40:51
7757	1117545642	595128	1	28555809	2026-05-06 19:40:51
7758	1117545642	595129	1	28555809	2026-05-06 19:40:51
7759	1117545642	595130	1	28555809	2026-05-06 19:40:51
7760	1117545642	595131	1	28555809	2026-05-06 19:40:51
7761	1117545642	595132	1	28555809	2026-05-06 19:40:51
7762	1117545642	595117	2	000000000	2026-05-06 19:40:51
7763	1117545642	595118	2	000000000	2026-05-06 19:40:51
7764	1117545642	595119	1	1077865671	2026-05-06 19:40:51
7765	1117545642	595120	1	1077865671	2026-05-06 19:40:51
7766	1117545642	595145	1	1117503960	2026-05-06 19:40:51
7767	1117545642	595146	1	1117503960	2026-05-06 19:40:51
7768	1117545642	595147	1	1117503960	2026-05-06 19:40:51
7769	1117545642	595148	1	1117503960	2026-05-06 19:40:51
7770	1117545642	595111	1	28555809	2026-05-06 19:40:51
7771	1117545642	595112	1	28555809	2026-05-06 19:40:51
7772	1117545642	595113	1	28555809	2026-05-06 19:40:51
7773	1117545642	595114	1	28555809	2026-05-06 19:40:51
7774	1117545642	595115	1	28555809	2026-05-06 19:40:51
7775	1117545642	595116	1	28555809	2026-05-06 19:40:51
7776	1117545642	644275	1	28555809	2026-05-06 19:40:51
7777	1117545642	644276	1	28555809	2026-05-06 19:40:51
7778	1117545642	644277	1	28555809	2026-05-06 19:40:51
7779	1117545642	644278	1	28555809	2026-05-06 19:40:51
7780	1117545642	644279	1	6801355	2026-05-06 19:40:51
7781	1117545642	644280	1	6801355	2026-05-06 19:40:51
7782	1117545642	644281	1	6801355	2026-05-06 19:40:51
7783	1117545642	644282	1	6801355	2026-05-06 19:40:51
7784	1117545642	644323	1	96353963	2026-05-06 19:40:51
7785	1117545890	595100	2	000000000	2026-05-06 19:40:51
9432	1117499559	592375	1	6801355	2024-11-29 19:11:00
7786	1117545890	595133	2	000000000	2026-05-06 19:40:51
7787	1117545890	595134	2	000000000	2026-05-06 19:40:51
7788	1117545890	595135	2	000000000	2026-05-06 19:40:51
7789	1117545890	595136	2	000000000	2026-05-06 19:40:51
7790	1117545890	595105	2	000000000	2026-05-06 19:40:51
7791	1117545890	595137	2	000000000	2026-05-06 19:40:51
7792	1117545890	595138	2	000000000	2026-05-06 19:40:51
7793	1117545890	595139	2	000000000	2026-05-06 19:40:51
7794	1117545890	595140	2	000000000	2026-05-06 19:40:51
7795	1117545890	595163	2	000000000	2026-05-06 19:40:51
7796	1117545890	595164	2	000000000	2026-05-06 19:40:51
7797	1117545890	595165	2	000000000	2026-05-06 19:40:51
7798	1117545890	595166	2	000000000	2026-05-06 19:40:51
7799	1117545890	595167	2	000000000	2026-05-06 19:40:51
7800	1117545890	595168	2	000000000	2026-05-06 19:40:51
7801	1117545890	595101	2	000000000	2026-05-06 19:40:51
7802	1117545890	595102	2	000000000	2026-05-06 19:40:51
7803	1117545890	595103	2	000000000	2026-05-06 19:40:51
7804	1117545890	595104	2	000000000	2026-05-06 19:40:51
7805	1117545890	595149	2	000000000	2026-05-06 19:40:51
7806	1117545890	595150	2	000000000	2026-05-06 19:40:51
7807	1117545890	595151	2	000000000	2026-05-06 19:40:51
7808	1117545890	595152	2	000000000	2026-05-06 19:40:51
7809	1117545890	595141	2	000000000	2026-05-06 19:40:51
7810	1117545890	595142	2	000000000	2026-05-06 19:40:51
7811	1117545890	595143	2	000000000	2026-05-06 19:40:51
7812	1117545890	595144	2	000000000	2026-05-06 19:40:51
7813	1117545890	595158	2	000000000	2026-05-06 19:40:51
7814	1117545890	595159	2	000000000	2026-05-06 19:40:51
7815	1117545890	595160	2	000000000	2026-05-06 19:40:51
7816	1117545890	595161	2	000000000	2026-05-06 19:40:51
7817	1117545890	595162	2	000000000	2026-05-06 19:40:51
7818	1117545890	595106	2	000000000	2026-05-06 19:40:51
7819	1117545890	595107	2	000000000	2026-05-06 19:40:51
7820	1117545890	595108	2	000000000	2026-05-06 19:40:51
7821	1117545890	595109	2	000000000	2026-05-06 19:40:51
7822	1117545890	595110	2	000000000	2026-05-06 19:40:51
7823	1117545890	595125	2	000000000	2026-05-06 19:40:51
7824	1117545890	595126	2	000000000	2026-05-06 19:40:51
7825	1117545890	595127	2	000000000	2026-05-06 19:40:51
7826	1117545890	595128	2	000000000	2026-05-06 19:40:51
7827	1117545890	595129	2	000000000	2026-05-06 19:40:51
7828	1117545890	595130	2	000000000	2026-05-06 19:40:51
7829	1117545890	595131	2	000000000	2026-05-06 19:40:51
7830	1117545890	595132	2	000000000	2026-05-06 19:40:51
7831	1117545890	595117	2	000000000	2026-05-06 19:40:51
7832	1117545890	595118	2	000000000	2026-05-06 19:40:51
7833	1117545890	595119	2	000000000	2026-05-06 19:40:51
7834	1117545890	595120	2	000000000	2026-05-06 19:40:51
7835	1117545890	595145	2	000000000	2026-05-06 19:40:51
7836	1117545890	595146	2	000000000	2026-05-06 19:40:51
7837	1117545890	595147	2	000000000	2026-05-06 19:40:51
7838	1117545890	595148	2	000000000	2026-05-06 19:40:51
7839	1117545890	595111	2	000000000	2026-05-06 19:40:51
7840	1117545890	595112	2	000000000	2026-05-06 19:40:51
7841	1117545890	595113	2	000000000	2026-05-06 19:40:51
7842	1117545890	595114	2	000000000	2026-05-06 19:40:51
7843	1117545890	595115	2	000000000	2026-05-06 19:40:51
7844	1117545890	595116	2	000000000	2026-05-06 19:40:51
7845	1117545890	644275	2	000000000	2026-05-06 19:40:51
7846	1117545890	644276	2	000000000	2026-05-06 19:40:51
7847	1117545890	644277	2	000000000	2026-05-06 19:40:51
7848	1117545890	644278	2	000000000	2026-05-06 19:40:51
7849	1117545890	644279	2	000000000	2026-05-06 19:40:51
7850	1117545890	644280	2	000000000	2026-05-06 19:40:51
7851	1117545890	644281	2	000000000	2026-05-06 19:40:51
7852	1117545890	644282	2	000000000	2026-05-06 19:40:51
7853	1117545890	644323	2	000000000	2026-05-06 19:40:51
7854	1117816905	595100	2	000000000	2026-05-06 19:40:51
7855	1117816905	595133	1	26632272	2026-05-06 19:40:51
7856	1117816905	595134	1	26632272	2026-05-06 19:40:51
7857	1117816905	595135	1	26632272	2026-05-06 19:40:51
7858	1117816905	595136	1	26632272	2026-05-06 19:40:51
7859	1117816905	595105	1	28555809	2026-05-06 19:40:51
7860	1117816905	595137	1	96353963	2026-05-06 19:40:51
7861	1117816905	595138	1	96353963	2026-05-06 19:40:51
7862	1117816905	595139	1	96353963	2026-05-06 19:40:51
7863	1117816905	595140	1	96353963	2026-05-06 19:40:51
7864	1117816905	595163	1	6805131	2026-05-06 19:40:51
7865	1117816905	595164	1	6805131	2026-05-06 19:40:51
7866	1117816905	595165	1	6805131	2026-05-06 19:40:51
7867	1117816905	595166	1	6805131	2026-05-06 19:40:51
7868	1117816905	595167	1	6805131	2026-05-06 19:40:51
7869	1117816905	595168	1	6805131	2026-05-06 19:40:51
7870	1117816905	595101	1	40776309	2026-05-06 19:40:51
7871	1117816905	595102	1	1026552707	2026-05-06 19:40:51
7872	1117816905	595103	1	40776309	2026-05-06 19:40:51
7873	1117816905	595104	1	1026552707	2026-05-06 19:40:51
7874	1117816905	595149	1	96328076	2026-05-06 19:40:51
7875	1117816905	595150	1	96328076	2026-05-06 19:40:51
7876	1117816905	595151	1	96328076	2026-05-06 19:40:51
7877	1117816905	595152	1	96328076	2026-05-06 19:40:51
7878	1117816905	595141	1	1117515166	2026-05-06 19:40:51
7879	1117816905	595142	1	1117515166	2026-05-06 19:40:51
7880	1117816905	595143	1	1117515166	2026-05-06 19:40:51
7881	1117816905	595144	1	1117515166	2026-05-06 19:40:51
7882	1117816905	595158	2	000000000	2026-05-06 19:40:51
7883	1117816905	595159	2	000000000	2026-05-06 19:40:51
7884	1117816905	595160	2	000000000	2026-05-06 19:40:51
7885	1117816905	595161	2	000000000	2026-05-06 19:40:51
7886	1117816905	595162	2	000000000	2026-05-06 19:40:51
7887	1117816905	595106	1	28555809	2026-05-06 19:40:51
7888	1117816905	595107	1	28555809	2026-05-06 19:40:51
7889	1117816905	595108	1	28555809	2026-05-06 19:40:51
7890	1117816905	595109	1	28555809	2026-05-06 19:40:51
7891	1117816905	595110	1	28555809	2026-05-06 19:40:51
7892	1117816905	595125	1	28555809	2026-05-06 19:40:51
7893	1117816905	595126	1	28555809	2026-05-06 19:40:51
7894	1117816905	595127	1	28555809	2026-05-06 19:40:51
7895	1117816905	595128	1	28555809	2026-05-06 19:40:51
7896	1117816905	595129	1	28555809	2026-05-06 19:40:51
7897	1117816905	595130	1	28555809	2026-05-06 19:40:51
7898	1117816905	595131	1	28555809	2026-05-06 19:40:51
7899	1117816905	595132	1	28555809	2026-05-06 19:40:51
7900	1117816905	595117	2	000000000	2026-05-06 19:40:51
7901	1117816905	595118	2	000000000	2026-05-06 19:40:51
7902	1117816905	595119	1	1077865671	2026-05-06 19:40:51
7903	1117816905	595120	1	1077865671	2026-05-06 19:40:51
7904	1117816905	595145	1	1117503960	2026-05-06 19:40:51
7905	1117816905	595146	1	1117503960	2026-05-06 19:40:51
7906	1117816905	595147	1	1117503960	2026-05-06 19:40:51
7907	1117816905	595148	1	1117503960	2026-05-06 19:40:51
7908	1117816905	595111	1	28555809	2026-05-06 19:40:51
7909	1117816905	595112	1	28555809	2026-05-06 19:40:51
7910	1117816905	595113	1	28555809	2026-05-06 19:40:51
7911	1117816905	595114	1	28555809	2026-05-06 19:40:51
7912	1117816905	595115	1	28555809	2026-05-06 19:40:51
7913	1117816905	595116	1	28555809	2026-05-06 19:40:51
7914	1117816905	644275	1	28555809	2026-05-06 19:40:51
7915	1117816905	644276	1	28555809	2026-05-06 19:40:51
7916	1117816905	644277	1	28555809	2026-05-06 19:40:51
7917	1117816905	644278	1	28555809	2026-05-06 19:40:51
7918	1117816905	644279	1	6801355	2026-05-06 19:40:51
7919	1117816905	644280	1	6801355	2026-05-06 19:40:51
7920	1117816905	644281	1	6801355	2026-05-06 19:40:51
7921	1117816905	644282	1	6801355	2026-05-06 19:40:51
7922	1117816905	644323	1	96353963	2026-05-06 19:40:51
7923	1118362482	595100	2	000000000	2026-05-06 19:40:51
7924	1118362482	595133	1	26632272	2026-05-06 19:40:51
7925	1118362482	595134	1	26632272	2026-05-06 19:40:51
7926	1118362482	595135	1	26632272	2026-05-06 19:40:51
7927	1118362482	595136	1	26632272	2026-05-06 19:40:51
7928	1118362482	595105	1	28555809	2026-05-06 19:40:51
7929	1118362482	595137	1	96353963	2026-05-06 19:40:51
7930	1118362482	595138	1	96353963	2026-05-06 19:40:51
7931	1118362482	595139	1	96353963	2026-05-06 19:40:51
7932	1118362482	595140	1	96353963	2026-05-06 19:40:51
7933	1118362482	595163	1	6805131	2026-05-06 19:40:51
7934	1118362482	595164	1	6805131	2026-05-06 19:40:51
7935	1118362482	595165	1	6805131	2026-05-06 19:40:51
7936	1118362482	595166	1	6805131	2026-05-06 19:40:51
7937	1118362482	595167	1	6805131	2026-05-06 19:40:51
7938	1118362482	595168	1	6805131	2026-05-06 19:40:51
7939	1118362482	595101	1	40776309	2026-05-06 19:40:51
7940	1118362482	595102	1	1026552707	2026-05-06 19:40:51
7941	1118362482	595103	1	40776309	2026-05-06 19:40:51
7942	1118362482	595104	1	1026552707	2026-05-06 19:40:51
7943	1118362482	595149	1	96328076	2026-05-06 19:40:51
7944	1118362482	595150	1	96328076	2026-05-06 19:40:51
7945	1118362482	595151	1	96328076	2026-05-06 19:40:51
7946	1118362482	595152	1	96328076	2026-05-06 19:40:51
7947	1118362482	595141	2	000000000	2026-05-06 19:40:51
7948	1118362482	595142	2	000000000	2026-05-06 19:40:51
7949	1118362482	595143	2	000000000	2026-05-06 19:40:51
7950	1118362482	595144	2	000000000	2026-05-06 19:40:51
7951	1118362482	595158	2	000000000	2026-05-06 19:40:51
7952	1118362482	595159	2	000000000	2026-05-06 19:40:51
7953	1118362482	595160	2	000000000	2026-05-06 19:40:51
7954	1118362482	595161	2	000000000	2026-05-06 19:40:51
7955	1118362482	595162	2	000000000	2026-05-06 19:40:51
7956	1118362482	595106	1	28555809	2026-05-06 19:40:51
7957	1118362482	595107	1	28555809	2026-05-06 19:40:51
7958	1118362482	595108	1	28555809	2026-05-06 19:40:51
7959	1118362482	595109	1	28555809	2026-05-06 19:40:51
7960	1118362482	595110	1	28555809	2026-05-06 19:40:51
7961	1118362482	595125	1	28555809	2026-05-06 19:40:51
7962	1118362482	595126	1	28555809	2026-05-06 19:40:51
7963	1118362482	595127	1	28555809	2026-05-06 19:40:51
7964	1118362482	595128	1	28555809	2026-05-06 19:40:51
7965	1118362482	595129	1	28555809	2026-05-06 19:40:51
7966	1118362482	595130	1	28555809	2026-05-06 19:40:51
7967	1118362482	595131	1	28555809	2026-05-06 19:40:51
7968	1118362482	595132	1	28555809	2026-05-06 19:40:51
7969	1118362482	595117	2	000000000	2026-05-06 19:40:51
7970	1118362482	595118	2	000000000	2026-05-06 19:40:51
7971	1118362482	595119	1	1077865671	2026-05-06 19:40:51
7972	1118362482	595120	1	1077865671	2026-05-06 19:40:51
7973	1118362482	595145	1	1117503960	2026-05-06 19:40:51
7974	1118362482	595146	1	1117503960	2026-05-06 19:40:51
7975	1118362482	595147	1	1117503960	2026-05-06 19:40:51
7976	1118362482	595148	1	1117503960	2026-05-06 19:40:51
7977	1118362482	595111	2	000000000	2026-05-06 19:40:51
7978	1118362482	595112	2	000000000	2026-05-06 19:40:51
7979	1118362482	595113	2	000000000	2026-05-06 19:40:51
7980	1118362482	595114	2	000000000	2026-05-06 19:40:51
7981	1118362482	595115	2	000000000	2026-05-06 19:40:51
7982	1118362482	595116	2	000000000	2026-05-06 19:40:51
7983	1118362482	644275	1	28555809	2026-05-06 19:40:51
7984	1118362482	644276	1	28555809	2026-05-06 19:40:51
7985	1118362482	644277	1	28555809	2026-05-06 19:40:51
7986	1118362482	644278	1	28555809	2026-05-06 19:40:51
7987	1118362482	644279	1	6801355	2026-05-06 19:40:51
7988	1118362482	644280	1	6801355	2026-05-06 19:40:51
7989	1118362482	644281	1	6801355	2026-05-06 19:40:51
7990	1118362482	644282	1	6801355	2026-05-06 19:40:51
7991	1118362482	644323	1	96353963	2026-05-06 19:40:51
7992	1118364127	595100	2	000000000	2026-05-06 19:40:51
7993	1118364127	595133	1	26632272	2026-05-06 19:40:51
7994	1118364127	595134	1	26632272	2026-05-06 19:40:51
7995	1118364127	595135	1	26632272	2026-05-06 19:40:51
7996	1118364127	595136	1	26632272	2026-05-06 19:40:51
7997	1118364127	595105	1	28555809	2026-05-06 19:40:51
7998	1118364127	595137	1	96353963	2026-05-06 19:40:51
7999	1118364127	595138	1	96353963	2026-05-06 19:40:51
8000	1118364127	595139	1	96353963	2026-05-06 19:40:51
8001	1118364127	595140	1	96353963	2026-05-06 19:40:51
8002	1118364127	595163	1	6805131	2026-05-06 19:40:51
8003	1118364127	595164	1	6805131	2026-05-06 19:40:51
8004	1118364127	595165	1	6805131	2026-05-06 19:40:51
8005	1118364127	595166	1	6805131	2026-05-06 19:40:51
8006	1118364127	595167	1	6805131	2026-05-06 19:40:51
8007	1118364127	595168	1	6805131	2026-05-06 19:40:51
8008	1118364127	595101	1	40776309	2026-05-06 19:40:51
8009	1118364127	595102	1	1026552707	2026-05-06 19:40:51
8010	1118364127	595103	1	40776309	2026-05-06 19:40:51
8011	1118364127	595104	1	1026552707	2026-05-06 19:40:51
8012	1118364127	595149	1	96328076	2026-05-06 19:40:51
8013	1118364127	595150	1	96328076	2026-05-06 19:40:51
8014	1118364127	595151	1	96328076	2026-05-06 19:40:51
8015	1118364127	595152	1	96328076	2026-05-06 19:40:51
8016	1118364127	595141	1	1117515166	2026-05-06 19:40:51
8017	1118364127	595142	1	1117515166	2026-05-06 19:40:51
8018	1118364127	595143	1	1117515166	2026-05-06 19:40:51
8019	1118364127	595144	1	1117515166	2026-05-06 19:40:51
8020	1118364127	595158	2	000000000	2026-05-06 19:40:51
8021	1118364127	595159	2	000000000	2026-05-06 19:40:51
8022	1118364127	595160	2	000000000	2026-05-06 19:40:51
8023	1118364127	595161	2	000000000	2026-05-06 19:40:51
8024	1118364127	595162	2	000000000	2026-05-06 19:40:51
8025	1118364127	595106	1	28555809	2026-05-06 19:40:51
8026	1118364127	595107	1	28555809	2026-05-06 19:40:51
8027	1118364127	595108	1	28555809	2026-05-06 19:40:51
8028	1118364127	595109	1	28555809	2026-05-06 19:40:51
8029	1118364127	595110	1	28555809	2026-05-06 19:40:51
8030	1118364127	595125	1	28555809	2026-05-06 19:40:51
8031	1118364127	595126	1	28555809	2026-05-06 19:40:51
8032	1118364127	595127	1	28555809	2026-05-06 19:40:51
8033	1118364127	595128	1	28555809	2026-05-06 19:40:51
8034	1118364127	595129	1	28555809	2026-05-06 19:40:51
8035	1118364127	595130	1	28555809	2026-05-06 19:40:51
8036	1118364127	595131	1	28555809	2026-05-06 19:40:51
8037	1118364127	595132	1	28555809	2026-05-06 19:40:51
8038	1118364127	595117	2	000000000	2026-05-06 19:40:51
8039	1118364127	595118	2	000000000	2026-05-06 19:40:51
8040	1118364127	595119	1	1077865671	2026-05-06 19:40:51
8041	1118364127	595120	1	1077865671	2026-05-06 19:40:51
8042	1118364127	595145	1	1117503960	2026-05-06 19:40:51
8043	1118364127	595146	1	1117503960	2026-05-06 19:40:51
8044	1118364127	595147	1	1117503960	2026-05-06 19:40:51
8045	1118364127	595148	1	1117503960	2026-05-06 19:40:51
8046	1118364127	595111	1	28555809	2026-05-06 19:40:51
8047	1118364127	595112	1	28555809	2026-05-06 19:40:51
8048	1118364127	595113	1	28555809	2026-05-06 19:40:51
8049	1118364127	595114	1	28555809	2026-05-06 19:40:51
8050	1118364127	595115	1	28555809	2026-05-06 19:40:51
8051	1118364127	595116	1	28555809	2026-05-06 19:40:51
8052	1118364127	644275	1	28555809	2026-05-06 19:40:51
8053	1118364127	644276	1	28555809	2026-05-06 19:40:51
8054	1118364127	644277	1	28555809	2026-05-06 19:40:51
8055	1118364127	644278	1	28555809	2026-05-06 19:40:51
8056	1118364127	644279	1	6801355	2026-05-06 19:40:51
8057	1118364127	644280	1	6801355	2026-05-06 19:40:51
8058	1118364127	644281	1	6801355	2026-05-06 19:40:51
8059	1118364127	644282	1	6801355	2026-05-06 19:40:51
8060	1118364127	644323	1	96353963	2026-05-06 19:40:51
8061	1118364195	595100	2	000000000	2026-05-06 19:40:51
8062	1118364195	595133	1	26632272	2026-05-06 19:40:51
8063	1118364195	595134	1	26632272	2026-05-06 19:40:51
8064	1118364195	595135	1	26632272	2026-05-06 19:40:51
8065	1118364195	595136	1	26632272	2026-05-06 19:40:51
8066	1118364195	595105	1	28555809	2026-05-06 19:40:51
8067	1118364195	595137	1	96353963	2026-05-06 19:40:51
8068	1118364195	595138	1	96353963	2026-05-06 19:40:51
8069	1118364195	595139	1	96353963	2026-05-06 19:40:52
8070	1118364195	595140	1	96353963	2026-05-06 19:40:52
8071	1118364195	595163	1	6805131	2026-05-06 19:40:52
8072	1118364195	595164	1	6805131	2026-05-06 19:40:52
8073	1118364195	595165	1	6805131	2026-05-06 19:40:52
8074	1118364195	595166	1	6805131	2026-05-06 19:40:52
8075	1118364195	595167	1	6805131	2026-05-06 19:40:52
8076	1118364195	595168	1	6805131	2026-05-06 19:40:52
8077	1118364195	595101	1	40776309	2026-05-06 19:40:52
8078	1118364195	595102	1	1026552707	2026-05-06 19:40:52
8079	1118364195	595103	1	40776309	2026-05-06 19:40:52
8080	1118364195	595104	1	1026552707	2026-05-06 19:40:52
8081	1118364195	595149	1	96328076	2026-05-06 19:40:52
8082	1118364195	595150	1	96328076	2026-05-06 19:40:52
8083	1118364195	595151	1	96328076	2026-05-06 19:40:52
8084	1118364195	595152	1	96328076	2026-05-06 19:40:52
8085	1118364195	595141	1	1117515166	2026-05-06 19:40:52
8086	1118364195	595142	1	1117515166	2026-05-06 19:40:52
8087	1118364195	595143	1	1117515166	2026-05-06 19:40:52
8088	1118364195	595144	1	1117515166	2026-05-06 19:40:52
8089	1118364195	595158	2	000000000	2026-05-06 19:40:52
8090	1118364195	595159	2	000000000	2026-05-06 19:40:52
8091	1118364195	595160	2	000000000	2026-05-06 19:40:52
8092	1118364195	595161	2	000000000	2026-05-06 19:40:52
8093	1118364195	595162	2	000000000	2026-05-06 19:40:52
8094	1118364195	595106	1	28555809	2026-05-06 19:40:52
8095	1118364195	595107	1	28555809	2026-05-06 19:40:52
8096	1118364195	595108	1	28555809	2026-05-06 19:40:52
8097	1118364195	595109	1	28555809	2026-05-06 19:40:52
8098	1118364195	595110	1	28555809	2026-05-06 19:40:52
8099	1118364195	595125	1	28555809	2026-05-06 19:40:52
8100	1118364195	595126	1	28555809	2026-05-06 19:40:52
8101	1118364195	595127	1	28555809	2026-05-06 19:40:52
8102	1118364195	595128	1	28555809	2026-05-06 19:40:52
8103	1118364195	595129	1	28555809	2026-05-06 19:40:52
8104	1118364195	595130	1	28555809	2026-05-06 19:40:52
8105	1118364195	595131	1	28555809	2026-05-06 19:40:52
8106	1118364195	595132	1	28555809	2026-05-06 19:40:52
8107	1118364195	595117	2	000000000	2026-05-06 19:40:52
8108	1118364195	595118	2	000000000	2026-05-06 19:40:52
8109	1118364195	595119	1	1077865671	2026-05-06 19:40:52
8110	1118364195	595120	1	1077865671	2026-05-06 19:40:52
8111	1118364195	595145	1	1117503960	2026-05-06 19:40:52
8112	1118364195	595146	1	1117503960	2026-05-06 19:40:52
8113	1118364195	595147	1	1117503960	2026-05-06 19:40:52
8114	1118364195	595148	1	1117503960	2026-05-06 19:40:52
8115	1118364195	595111	1	28555809	2026-05-06 19:40:52
8116	1118364195	595112	1	28555809	2026-05-06 19:40:52
8117	1118364195	595113	1	28555809	2026-05-06 19:40:52
8118	1118364195	595114	1	28555809	2026-05-06 19:40:52
8119	1118364195	595115	1	28555809	2026-05-06 19:40:52
8120	1118364195	595116	1	28555809	2026-05-06 19:40:52
8121	1118364195	644275	1	28555809	2026-05-06 19:40:52
8122	1118364195	644276	1	28555809	2026-05-06 19:40:52
8123	1118364195	644277	1	28555809	2026-05-06 19:40:52
8124	1118364195	644278	1	28555809	2026-05-06 19:40:52
8125	1118364195	644279	1	6801355	2026-05-06 19:40:52
8126	1118364195	644280	1	6801355	2026-05-06 19:40:52
8127	1118364195	644281	1	6801355	2026-05-06 19:40:52
8128	1118364195	644282	1	6801355	2026-05-06 19:40:52
8129	1118364195	644323	1	96353963	2026-05-06 19:40:52
8130	1118366385	595100	2	000000000	2026-05-06 19:40:52
8131	1118366385	595133	1	26632272	2026-05-06 19:40:52
8132	1118366385	595134	1	26632272	2026-05-06 19:40:52
8133	1118366385	595135	1	26632272	2026-05-06 19:40:52
8134	1118366385	595136	1	26632272	2026-05-06 19:40:52
8135	1118366385	595105	1	28555809	2026-05-06 19:40:52
8136	1118366385	595137	1	96353963	2026-05-06 19:40:52
8137	1118366385	595138	1	96353963	2026-05-06 19:40:52
8138	1118366385	595139	1	96353963	2026-05-06 19:40:52
8139	1118366385	595140	1	96353963	2026-05-06 19:40:52
8140	1118366385	595163	1	6805131	2026-05-06 19:40:52
8141	1118366385	595164	1	6805131	2026-05-06 19:40:52
8142	1118366385	595165	1	6805131	2026-05-06 19:40:52
8143	1118366385	595166	1	6805131	2026-05-06 19:40:52
8144	1118366385	595167	1	6805131	2026-05-06 19:40:52
8145	1118366385	595168	1	6805131	2026-05-06 19:40:52
8146	1118366385	595101	1	40776309	2026-05-06 19:40:52
8147	1118366385	595102	1	1026552707	2026-05-06 19:40:52
8148	1118366385	595103	1	40776309	2026-05-06 19:40:52
8149	1118366385	595104	1	1026552707	2026-05-06 19:40:52
8150	1118366385	595149	1	96328076	2026-05-06 19:40:52
8151	1118366385	595150	1	96328076	2026-05-06 19:40:52
8152	1118366385	595151	1	96328076	2026-05-06 19:40:52
8153	1118366385	595152	1	96328076	2026-05-06 19:40:52
8154	1118366385	595141	2	000000000	2026-05-06 19:40:52
8155	1118366385	595142	2	000000000	2026-05-06 19:40:52
8156	1118366385	595143	2	000000000	2026-05-06 19:40:52
8157	1118366385	595144	2	000000000	2026-05-06 19:40:52
8158	1118366385	595158	2	000000000	2026-05-06 19:40:52
8159	1118366385	595159	2	000000000	2026-05-06 19:40:52
8160	1118366385	595160	2	000000000	2026-05-06 19:40:52
8161	1118366385	595161	2	000000000	2026-05-06 19:40:52
8162	1118366385	595162	2	000000000	2026-05-06 19:40:52
8163	1118366385	595106	1	28555809	2026-05-06 19:40:52
8164	1118366385	595107	1	28555809	2026-05-06 19:40:52
8165	1118366385	595108	1	28555809	2026-05-06 19:40:52
8166	1118366385	595109	1	28555809	2026-05-06 19:40:52
8167	1118366385	595110	1	28555809	2026-05-06 19:40:52
8168	1118366385	595125	1	28555809	2026-05-06 19:40:52
8169	1118366385	595126	1	28555809	2026-05-06 19:40:52
8170	1118366385	595127	1	28555809	2026-05-06 19:40:52
8171	1118366385	595128	1	28555809	2026-05-06 19:40:52
8172	1118366385	595129	1	28555809	2026-05-06 19:40:52
8173	1118366385	595130	1	28555809	2026-05-06 19:40:52
8174	1118366385	595131	1	28555809	2026-05-06 19:40:52
8175	1118366385	595132	1	28555809	2026-05-06 19:40:52
8176	1118366385	595117	2	000000000	2026-05-06 19:40:52
8177	1118366385	595118	2	000000000	2026-05-06 19:40:52
8178	1118366385	595119	1	1077865671	2026-05-06 19:40:52
8179	1118366385	595120	1	1077865671	2026-05-06 19:40:52
8180	1118366385	595145	1	1117503960	2026-05-06 19:40:52
8181	1118366385	595146	1	1117503960	2026-05-06 19:40:52
8182	1118366385	595147	1	1117503960	2026-05-06 19:40:52
8183	1118366385	595148	1	1117503960	2026-05-06 19:40:52
8184	1118366385	595111	1	28555809	2026-05-06 19:40:52
8185	1118366385	595112	1	28555809	2026-05-06 19:40:52
8186	1118366385	595113	1	28555809	2026-05-06 19:40:52
8187	1118366385	595114	1	28555809	2026-05-06 19:40:52
8188	1118366385	595115	1	28555809	2026-05-06 19:40:52
8189	1118366385	595116	1	28555809	2026-05-06 19:40:52
8190	1118366385	644275	1	28555809	2026-05-06 19:40:52
8191	1118366385	644276	1	28555809	2026-05-06 19:40:52
8192	1118366385	644277	1	28555809	2026-05-06 19:40:52
8193	1118366385	644278	1	28555809	2026-05-06 19:40:52
8194	1118366385	644279	1	6801355	2026-05-06 19:40:52
8195	1118366385	644280	1	6801355	2026-05-06 19:40:52
8196	1118366385	644281	1	6801355	2026-05-06 19:40:52
8197	1118366385	644282	1	6801355	2026-05-06 19:40:52
8198	1118366385	644323	1	96353963	2026-05-06 19:40:52
8199	1119580993	595100	2	000000000	2026-05-06 19:40:52
8200	1119580993	595133	2	000000000	2026-05-06 19:40:52
8201	1119580993	595134	2	000000000	2026-05-06 19:40:52
8202	1119580993	595135	2	000000000	2026-05-06 19:40:52
8203	1119580993	595136	2	000000000	2026-05-06 19:40:52
8204	1119580993	595105	2	000000000	2026-05-06 19:40:52
8205	1119580993	595137	2	000000000	2026-05-06 19:40:52
8206	1119580993	595138	2	000000000	2026-05-06 19:40:52
8207	1119580993	595139	2	000000000	2026-05-06 19:40:52
8208	1119580993	595140	2	000000000	2026-05-06 19:40:52
8209	1119580993	595163	2	000000000	2026-05-06 19:40:52
8210	1119580993	595164	2	000000000	2026-05-06 19:40:52
8211	1119580993	595165	2	000000000	2026-05-06 19:40:52
8212	1119580993	595166	2	000000000	2026-05-06 19:40:52
8213	1119580993	595167	2	000000000	2026-05-06 19:40:52
8214	1119580993	595168	2	000000000	2026-05-06 19:40:52
8215	1119580993	595101	2	000000000	2026-05-06 19:40:52
8216	1119580993	595102	2	000000000	2026-05-06 19:40:52
8217	1119580993	595103	2	000000000	2026-05-06 19:40:52
8218	1119580993	595104	2	000000000	2026-05-06 19:40:52
8219	1119580993	595149	2	000000000	2026-05-06 19:40:52
9433	1117499559	592376	1	6801355	2024-11-29 19:11:00
8220	1119580993	595150	2	000000000	2026-05-06 19:40:52
8221	1119580993	595151	2	000000000	2026-05-06 19:40:52
8222	1119580993	595152	2	000000000	2026-05-06 19:40:52
8223	1119580993	595141	2	000000000	2026-05-06 19:40:52
8224	1119580993	595142	2	000000000	2026-05-06 19:40:52
8225	1119580993	595143	2	000000000	2026-05-06 19:40:52
8226	1119580993	595144	2	000000000	2026-05-06 19:40:52
8227	1119580993	595158	2	000000000	2026-05-06 19:40:52
8228	1119580993	595159	2	000000000	2026-05-06 19:40:52
8229	1119580993	595160	2	000000000	2026-05-06 19:40:52
8230	1119580993	595161	2	000000000	2026-05-06 19:40:52
8231	1119580993	595162	2	000000000	2026-05-06 19:40:52
8232	1119580993	595106	2	000000000	2026-05-06 19:40:52
8233	1119580993	595107	2	000000000	2026-05-06 19:40:52
8234	1119580993	595108	2	000000000	2026-05-06 19:40:52
8235	1119580993	595109	2	000000000	2026-05-06 19:40:52
8236	1119580993	595110	2	000000000	2026-05-06 19:40:52
8237	1119580993	595125	2	000000000	2026-05-06 19:40:52
8238	1119580993	595126	2	000000000	2026-05-06 19:40:52
8239	1119580993	595127	2	000000000	2026-05-06 19:40:52
8240	1119580993	595128	2	000000000	2026-05-06 19:40:52
8241	1119580993	595129	2	000000000	2026-05-06 19:40:52
8242	1119580993	595130	2	000000000	2026-05-06 19:40:52
8243	1119580993	595131	2	000000000	2026-05-06 19:40:52
8244	1119580993	595132	2	000000000	2026-05-06 19:40:52
8245	1119580993	595117	2	000000000	2026-05-06 19:40:52
8246	1119580993	595118	2	000000000	2026-05-06 19:40:52
8247	1119580993	595119	2	000000000	2026-05-06 19:40:52
8248	1119580993	595120	2	000000000	2026-05-06 19:40:52
8249	1119580993	595145	2	000000000	2026-05-06 19:40:52
8250	1119580993	595146	2	000000000	2026-05-06 19:40:52
8251	1119580993	595147	2	000000000	2026-05-06 19:40:52
8252	1119580993	595148	2	000000000	2026-05-06 19:40:52
8253	1119580993	595111	2	000000000	2026-05-06 19:40:52
8254	1119580993	595112	2	000000000	2026-05-06 19:40:52
8255	1119580993	595113	2	000000000	2026-05-06 19:40:52
8256	1119580993	595114	2	000000000	2026-05-06 19:40:52
8257	1119580993	595115	2	000000000	2026-05-06 19:40:52
8258	1119580993	595116	2	000000000	2026-05-06 19:40:52
8259	1119580993	644275	2	000000000	2026-05-06 19:40:52
8260	1119580993	644276	2	000000000	2026-05-06 19:40:52
8261	1119580993	644277	2	000000000	2026-05-06 19:40:52
8262	1119580993	644278	2	000000000	2026-05-06 19:40:52
8263	1119580993	644279	2	000000000	2026-05-06 19:40:52
8264	1119580993	644280	2	000000000	2026-05-06 19:40:52
8265	1119580993	644281	2	000000000	2026-05-06 19:40:52
8266	1119580993	644282	2	000000000	2026-05-06 19:40:52
8267	1119580993	644323	2	000000000	2026-05-06 19:40:52
8268	1137624175	595100	2	000000000	2026-05-06 19:40:52
8269	1137624175	595133	1	26632272	2026-05-06 19:40:52
8270	1137624175	595134	1	26632272	2026-05-06 19:40:52
8271	1137624175	595135	1	26632272	2026-05-06 19:40:52
8272	1137624175	595136	1	26632272	2026-05-06 19:40:52
8273	1137624175	595105	1	28555809	2026-05-06 19:40:52
8274	1137624175	595137	1	96353963	2026-05-06 19:40:52
8275	1137624175	595138	1	96353963	2026-05-06 19:40:52
8276	1137624175	595139	1	96353963	2026-05-06 19:40:52
8277	1137624175	595140	1	96353963	2026-05-06 19:40:52
8278	1137624175	595163	1	6805131	2026-05-06 19:40:52
8279	1137624175	595164	1	6805131	2026-05-06 19:40:52
8280	1137624175	595165	1	6805131	2026-05-06 19:40:52
8281	1137624175	595166	1	6805131	2026-05-06 19:40:52
8282	1137624175	595167	1	6805131	2026-05-06 19:40:52
8283	1137624175	595168	1	6805131	2026-05-06 19:40:52
8284	1137624175	595101	1	40776309	2026-05-06 19:40:52
8285	1137624175	595102	1	1026552707	2026-05-06 19:40:52
8286	1137624175	595103	1	40776309	2026-05-06 19:40:52
8287	1137624175	595104	1	1026552707	2026-05-06 19:40:52
8288	1137624175	595149	1	96328076	2026-05-06 19:40:52
8289	1137624175	595150	1	96328076	2026-05-06 19:40:52
8290	1137624175	595151	1	96328076	2026-05-06 19:40:52
8291	1137624175	595152	1	96328076	2026-05-06 19:40:52
8292	1137624175	595141	1	1117515166	2026-05-06 19:40:52
8293	1137624175	595142	1	1117515166	2026-05-06 19:40:52
8294	1137624175	595143	1	1117515166	2026-05-06 19:40:52
8295	1137624175	595144	1	1117515166	2026-05-06 19:40:52
8296	1137624175	595158	2	000000000	2026-05-06 19:40:52
8297	1137624175	595159	2	000000000	2026-05-06 19:40:52
8298	1137624175	595160	2	000000000	2026-05-06 19:40:52
8299	1137624175	595161	2	000000000	2026-05-06 19:40:52
8300	1137624175	595162	2	000000000	2026-05-06 19:40:52
8301	1137624175	595106	1	28555809	2026-05-06 19:40:52
8302	1137624175	595107	1	28555809	2026-05-06 19:40:52
8303	1137624175	595108	1	28555809	2026-05-06 19:40:52
8304	1137624175	595109	1	28555809	2026-05-06 19:40:52
8305	1137624175	595110	1	28555809	2026-05-06 19:40:52
8306	1137624175	595125	1	28555809	2026-05-06 19:40:52
8307	1137624175	595126	1	28555809	2026-05-06 19:40:52
8308	1137624175	595127	1	28555809	2026-05-06 19:40:52
8309	1137624175	595128	1	28555809	2026-05-06 19:40:52
8310	1137624175	595129	1	28555809	2026-05-06 19:40:52
8311	1137624175	595130	1	28555809	2026-05-06 19:40:52
8312	1137624175	595131	1	28555809	2026-05-06 19:40:52
8313	1137624175	595132	1	28555809	2026-05-06 19:40:52
8314	1137624175	595117	2	000000000	2026-05-06 19:40:52
8315	1137624175	595118	2	000000000	2026-05-06 19:40:52
8316	1137624175	595119	1	1077865671	2026-05-06 19:40:52
8317	1137624175	595120	1	1077865671	2026-05-06 19:40:52
8318	1137624175	595145	1	1117503960	2026-05-06 19:40:52
8319	1137624175	595146	1	1117503960	2026-05-06 19:40:52
8320	1137624175	595147	1	1117503960	2026-05-06 19:40:52
8321	1137624175	595148	1	1117503960	2026-05-06 19:40:52
8322	1137624175	595111	1	28555809	2026-05-06 19:40:52
8323	1137624175	595112	1	28555809	2026-05-06 19:40:52
8324	1137624175	595113	1	28555809	2026-05-06 19:40:52
8325	1137624175	595114	1	28555809	2026-05-06 19:40:52
8326	1137624175	595115	1	28555809	2026-05-06 19:40:52
8327	1137624175	595116	1	28555809	2026-05-06 19:40:52
8328	1137624175	644275	1	28555809	2026-05-06 19:40:52
8329	1137624175	644276	1	28555809	2026-05-06 19:40:52
8330	1137624175	644277	1	28555809	2026-05-06 19:40:52
8331	1137624175	644278	1	28555809	2026-05-06 19:40:52
8332	1137624175	644279	1	6801355	2026-05-06 19:40:52
8333	1137624175	644280	1	6801355	2026-05-06 19:40:52
8334	1137624175	644281	1	6801355	2026-05-06 19:40:52
8335	1137624175	644282	1	6801355	2026-05-06 19:40:52
8336	1137624175	644323	1	96353963	2026-05-06 19:40:52
8337	40611465	595100	2	000000000	2026-05-06 19:40:52
8338	40611465	595133	1	26632272	2026-05-06 19:40:52
8339	40611465	595134	1	26632272	2026-05-06 19:40:52
8340	40611465	595135	1	26632272	2026-05-06 19:40:52
8341	40611465	595136	1	26632272	2026-05-06 19:40:52
8342	40611465	595105	1	28555809	2026-05-06 19:40:52
8343	40611465	595137	1	96353963	2026-05-06 19:40:52
8344	40611465	595138	1	96353963	2026-05-06 19:40:52
8345	40611465	595139	1	96353963	2026-05-06 19:40:52
8346	40611465	595140	1	96353963	2026-05-06 19:40:52
8347	40611465	595163	1	6805131	2026-05-06 19:40:52
8348	40611465	595164	1	6805131	2026-05-06 19:40:52
8349	40611465	595165	1	6805131	2026-05-06 19:40:52
8350	40611465	595166	1	6805131	2026-05-06 19:40:52
8351	40611465	595167	1	6805131	2026-05-06 19:40:52
8352	40611465	595168	1	6805131	2026-05-06 19:40:52
8353	40611465	595101	1	40776309	2026-05-06 19:40:52
8354	40611465	595102	1	1026552707	2026-05-06 19:40:52
8355	40611465	595103	1	40776309	2026-05-06 19:40:52
8356	40611465	595104	1	1026552707	2026-05-06 19:40:52
8357	40611465	595149	1	96328076	2026-05-06 19:40:52
8358	40611465	595150	1	96328076	2026-05-06 19:40:52
8359	40611465	595151	1	96328076	2026-05-06 19:40:52
8360	40611465	595152	1	96328076	2026-05-06 19:40:52
8361	40611465	595141	1	1117515166	2026-05-06 19:40:52
8362	40611465	595142	1	1117515166	2026-05-06 19:40:52
8363	40611465	595143	1	1117515166	2026-05-06 19:40:52
8364	40611465	595144	1	1117515166	2026-05-06 19:40:52
8365	40611465	595158	2	000000000	2026-05-06 19:40:52
8366	40611465	595159	2	000000000	2026-05-06 19:40:52
8367	40611465	595160	2	000000000	2026-05-06 19:40:52
8368	40611465	595161	2	000000000	2026-05-06 19:40:52
8369	40611465	595162	2	000000000	2026-05-06 19:40:52
8370	40611465	595106	1	28555809	2026-05-06 19:40:52
8371	40611465	595107	1	28555809	2026-05-06 19:40:52
8372	40611465	595108	1	28555809	2026-05-06 19:40:52
8373	40611465	595109	1	28555809	2026-05-06 19:40:52
8374	40611465	595110	1	28555809	2026-05-06 19:40:52
8375	40611465	595125	1	28555809	2026-05-06 19:40:52
8376	40611465	595126	1	28555809	2026-05-06 19:40:52
8377	40611465	595127	1	28555809	2026-05-06 19:40:52
8378	40611465	595128	1	28555809	2026-05-06 19:40:52
8379	40611465	595129	1	28555809	2026-05-06 19:40:52
8380	40611465	595130	1	28555809	2026-05-06 19:40:52
8381	40611465	595131	1	28555809	2026-05-06 19:40:52
8382	40611465	595132	1	28555809	2026-05-06 19:40:52
8383	40611465	595117	2	000000000	2026-05-06 19:40:52
8384	40611465	595118	2	000000000	2026-05-06 19:40:52
8385	40611465	595119	1	1077865671	2026-05-06 19:40:52
8386	40611465	595120	1	1077865671	2026-05-06 19:40:52
8387	40611465	595145	1	1117503960	2026-05-06 19:40:52
8388	40611465	595146	1	1117503960	2026-05-06 19:40:52
8389	40611465	595147	1	1117503960	2026-05-06 19:40:52
8390	40611465	595148	1	1117503960	2026-05-06 19:40:52
8391	40611465	595111	1	28555809	2026-05-06 19:40:52
8392	40611465	595112	1	28555809	2026-05-06 19:40:52
8393	40611465	595113	1	28555809	2026-05-06 19:40:52
8394	40611465	595114	1	28555809	2026-05-06 19:40:52
8395	40611465	595115	1	28555809	2026-05-06 19:40:52
8396	40611465	595116	1	28555809	2026-05-06 19:40:52
8397	40611465	644275	1	28555809	2026-05-06 19:40:52
8398	40611465	644276	1	28555809	2026-05-06 19:40:52
8399	40611465	644277	1	28555809	2026-05-06 19:40:52
8400	40611465	644278	1	28555809	2026-05-06 19:40:52
8401	40611465	644279	1	6801355	2026-05-06 19:40:53
8402	40611465	644280	1	6801355	2026-05-06 19:40:53
8403	40611465	644281	1	6801355	2026-05-06 19:40:53
8404	40611465	644282	1	6801355	2026-05-06 19:40:53
8405	40611465	644323	1	96353963	2026-05-06 19:40:53
8406	55161891	595100	2	000000000	2026-05-06 19:40:53
8407	55161891	595133	2	000000000	2026-05-06 19:40:53
8408	55161891	595134	2	000000000	2026-05-06 19:40:53
8409	55161891	595135	2	000000000	2026-05-06 19:40:53
8410	55161891	595136	2	000000000	2026-05-06 19:40:53
8411	55161891	595105	2	000000000	2026-05-06 19:40:53
8412	55161891	595137	2	000000000	2026-05-06 19:40:53
8413	55161891	595138	2	000000000	2026-05-06 19:40:53
8414	55161891	595139	2	000000000	2026-05-06 19:40:53
8415	55161891	595140	2	000000000	2026-05-06 19:40:53
8416	55161891	595163	2	000000000	2026-05-06 19:40:53
8417	55161891	595164	2	000000000	2026-05-06 19:40:53
8418	55161891	595165	2	000000000	2026-05-06 19:40:53
8419	55161891	595166	2	000000000	2026-05-06 19:40:53
8420	55161891	595167	2	000000000	2026-05-06 19:40:53
8421	55161891	595168	2	000000000	2026-05-06 19:40:53
8422	55161891	595101	2	000000000	2026-05-06 19:40:53
8423	55161891	595102	2	000000000	2026-05-06 19:40:53
8424	55161891	595103	2	000000000	2026-05-06 19:40:53
8425	55161891	595104	2	000000000	2026-05-06 19:40:53
8426	55161891	595149	2	000000000	2026-05-06 19:40:53
8427	55161891	595150	2	000000000	2026-05-06 19:40:53
8428	55161891	595151	2	000000000	2026-05-06 19:40:53
8429	55161891	595152	2	000000000	2026-05-06 19:40:53
8430	55161891	595141	2	000000000	2026-05-06 19:40:53
8431	55161891	595142	2	000000000	2026-05-06 19:40:53
8432	55161891	595143	2	000000000	2026-05-06 19:40:53
8433	55161891	595144	2	000000000	2026-05-06 19:40:53
8434	55161891	595158	2	000000000	2026-05-06 19:40:53
8435	55161891	595159	2	000000000	2026-05-06 19:40:53
9434	1117499559	593344	1	6801355	2024-11-29 19:11:00
8436	55161891	595160	2	000000000	2026-05-06 19:40:53
8437	55161891	595161	2	000000000	2026-05-06 19:40:53
8438	55161891	595162	2	000000000	2026-05-06 19:40:53
8439	55161891	595106	2	000000000	2026-05-06 19:40:53
8440	55161891	595107	2	000000000	2026-05-06 19:40:53
8441	55161891	595108	2	000000000	2026-05-06 19:40:53
8442	55161891	595109	2	000000000	2026-05-06 19:40:53
8443	55161891	595110	2	000000000	2026-05-06 19:40:53
8444	55161891	595125	2	000000000	2026-05-06 19:40:53
8445	55161891	595126	2	000000000	2026-05-06 19:40:53
8446	55161891	595127	2	000000000	2026-05-06 19:40:53
8447	55161891	595128	2	000000000	2026-05-06 19:40:53
8448	55161891	595129	2	000000000	2026-05-06 19:40:53
8449	55161891	595130	2	000000000	2026-05-06 19:40:53
8450	55161891	595131	2	000000000	2026-05-06 19:40:53
8451	55161891	595132	2	000000000	2026-05-06 19:40:53
8452	55161891	595117	2	000000000	2026-05-06 19:40:53
8453	55161891	595118	2	000000000	2026-05-06 19:40:53
8454	55161891	595119	2	000000000	2026-05-06 19:40:53
8455	55161891	595120	2	000000000	2026-05-06 19:40:53
8456	55161891	595145	2	000000000	2026-05-06 19:40:53
8457	55161891	595146	2	000000000	2026-05-06 19:40:53
8458	55161891	595147	2	000000000	2026-05-06 19:40:53
8459	55161891	595148	2	000000000	2026-05-06 19:40:53
8460	55161891	595111	2	000000000	2026-05-06 19:40:53
8461	55161891	595112	2	000000000	2026-05-06 19:40:53
8462	55161891	595113	2	000000000	2026-05-06 19:40:53
8463	55161891	595114	2	000000000	2026-05-06 19:40:53
8464	55161891	595115	2	000000000	2026-05-06 19:40:53
8465	55161891	595116	2	000000000	2026-05-06 19:40:53
8466	55161891	644275	2	000000000	2026-05-06 19:40:53
8467	55161891	644276	2	000000000	2026-05-06 19:40:53
8468	55161891	644277	2	000000000	2026-05-06 19:40:53
8469	55161891	644278	2	000000000	2026-05-06 19:40:53
8470	55161891	644279	2	000000000	2026-05-06 19:40:53
8471	55161891	644280	2	000000000	2026-05-06 19:40:53
8472	55161891	644281	2	000000000	2026-05-06 19:40:53
8473	55161891	644282	2	000000000	2026-05-06 19:40:53
8474	55161891	644323	2	000000000	2026-05-06 19:40:53
8475	1004417452	590803	2	000000000	2026-07-01 19:29:33
8476	1004417452	593147	2	000000000	2026-07-01 19:29:33
8477	1004417452	593148	2	000000000	2026-07-01 19:29:33
8478	1004417452	593149	2	000000000	2026-07-01 19:29:33
8479	1004417452	593150	2	000000000	2026-07-01 19:29:33
8480	1004417452	593343	1	6801355	2024-08-16 16:08:00
8481	1004417452	593151	1	1117507159	2025-03-25 07:03:00
8482	1004417452	593152	1	1117507159	2025-04-07 23:04:00
8483	1004417452	593153	1	1117507159	2025-03-25 07:03:00
8484	1004417452	593154	1	1117507159	2025-03-25 07:03:00
8485	1004417452	593113	2	17656565	2024-12-12 16:12:00
8486	1004417452	593114	2	17656565	2024-12-12 16:12:00
8487	1004417452	593115	1	1098809645	2024-11-29 20:11:00
8488	1004417452	593116	2	17656565	2024-12-12 16:12:00
8489	1004417452	593117	1	1098809645	2024-11-29 20:11:00
8490	1004417452	593118	2	17656565	2024-12-12 16:12:00
8491	1004417452	593155	2	000000000	2026-07-01 19:29:33
8492	1004417452	593156	2	000000000	2026-07-01 19:29:33
8493	1004417452	593157	2	000000000	2026-07-01 19:29:33
8494	1004417452	593158	2	000000000	2026-07-01 19:29:33
8495	1004417452	593119	2	000000000	2026-07-01 19:29:33
8496	1004417452	593120	2	000000000	2026-07-01 19:29:33
8497	1004417452	593121	2	000000000	2026-07-01 19:29:33
8498	1004417452	593122	2	000000000	2026-07-01 19:29:33
8499	1004417452	593159	2	000000000	2026-07-01 19:29:33
8500	1004417452	593160	2	000000000	2026-07-01 19:29:33
8501	1004417452	593161	2	000000000	2026-07-01 19:29:33
8502	1004417452	593162	2	000000000	2026-07-01 19:29:33
8503	1004417452	593224	2	000000000	2026-07-01 19:29:33
8504	1004417452	593225	2	000000000	2026-07-01 19:29:33
8505	1004417452	593226	2	000000000	2026-07-01 19:29:33
8506	1004417452	593227	2	000000000	2026-07-01 19:29:33
8507	1004417452	593235	2	000000000	2026-07-01 19:29:33
8508	1004417452	593236	2	000000000	2026-07-01 19:29:33
8509	1004417452	593237	2	000000000	2026-07-01 19:29:33
8510	1004417452	593238	2	000000000	2026-07-01 19:29:33
8511	1004417452	593109	2	000000000	2026-07-01 19:29:33
8512	1004417452	593110	2	000000000	2026-07-01 19:29:33
8513	1004417452	593111	2	000000000	2026-07-01 19:29:33
8514	1004417452	593112	2	000000000	2026-07-01 19:29:33
8515	1004417452	593100	2	000000000	2026-07-01 19:29:33
8516	1004417452	593101	2	000000000	2026-07-01 19:29:33
8517	1004417452	593102	2	000000000	2026-07-01 19:29:33
8518	1004417452	593103	1	96353963	2024-12-05 06:12:00
8519	1004417452	593060	2	000000000	2026-07-01 19:29:33
8520	1004417452	593061	2	000000000	2026-07-01 19:29:33
8521	1004417452	593062	2	000000000	2026-07-01 19:29:33
8522	1004417452	593104	2	000000000	2026-07-01 19:29:33
8523	1004417452	593105	2	000000000	2026-07-01 19:29:33
8524	1004417452	593106	2	000000000	2026-07-01 19:29:33
8525	1004417452	593107	2	000000000	2026-07-01 19:29:33
8526	1004417452	593108	2	000000000	2026-07-01 19:29:33
8527	1004417452	593144	2	000000000	2026-07-01 19:29:33
8528	1004417452	593145	2	000000000	2026-07-01 19:29:34
8529	1004417452	593146	2	000000000	2026-07-01 19:29:34
8530	1004417452	592373	1	6801355	2024-11-29 19:11:00
8531	1004417452	592374	2	000000000	2026-07-01 19:29:34
8532	1004417452	592375	1	6801355	2024-11-29 19:11:00
8533	1004417452	592376	1	6801355	2024-11-29 19:11:00
8534	1004417452	593344	1	6801355	2024-11-29 19:11:00
8535	1004417452	593345	1	6801355	2024-11-29 19:11:00
8536	1004417452	593346	1	6801355	2024-11-29 19:11:00
8537	1004417452	593347	1	6801355	2024-11-29 19:11:00
8538	1004417452	593243	2	000000000	2026-07-01 19:29:34
8539	1004417452	593244	2	000000000	2026-07-01 19:29:34
8540	1004417452	593245	2	000000000	2026-07-01 19:29:34
8541	1004417452	593246	2	000000000	2026-07-01 19:29:34
8542	1004417452	593255	1	40781077	2024-12-03 18:12:00
8543	1004417452	593256	1	40781077	2024-12-03 18:12:00
8544	1004417452	593257	1	40781077	2024-12-03 18:12:00
8545	1004417452	593258	1	40781077	2024-12-03 18:12:00
8546	1004417452	593259	2	000000000	2026-07-01 19:29:34
8547	1004417452	593340	2	000000000	2026-07-01 19:29:34
8548	1004417452	593341	2	000000000	2026-07-01 19:29:34
8549	1004417452	593342	2	000000000	2026-07-01 19:29:34
8550	1006524033	590803	2	000000000	2026-07-01 19:29:34
8551	1006524033	593147	2	000000000	2026-07-01 19:29:34
8552	1006524033	593148	2	000000000	2026-07-01 19:29:34
8553	1006524033	593149	2	000000000	2026-07-01 19:29:34
8554	1006524033	593150	2	000000000	2026-07-01 19:29:34
8555	1006524033	593343	2	000000000	2026-07-01 19:29:34
8556	1006524033	593151	2	000000000	2026-07-01 19:29:34
8557	1006524033	593152	2	000000000	2026-07-01 19:29:34
8558	1006524033	593153	2	000000000	2026-07-01 19:29:34
8559	1006524033	593154	2	000000000	2026-07-01 19:29:34
8560	1006524033	593113	2	000000000	2026-07-01 19:29:34
8561	1006524033	593114	2	000000000	2026-07-01 19:29:34
8562	1006524033	593115	2	000000000	2026-07-01 19:29:34
8563	1006524033	593116	2	000000000	2026-07-01 19:29:34
8564	1006524033	593117	2	000000000	2026-07-01 19:29:34
8565	1006524033	593118	2	000000000	2026-07-01 19:29:34
8566	1006524033	593155	2	000000000	2026-07-01 19:29:34
8567	1006524033	593156	2	000000000	2026-07-01 19:29:34
8568	1006524033	593157	2	000000000	2026-07-01 19:29:34
8569	1006524033	593158	2	000000000	2026-07-01 19:29:34
8570	1006524033	593119	2	000000000	2026-07-01 19:29:34
8571	1006524033	593120	2	000000000	2026-07-01 19:29:34
8572	1006524033	593121	2	000000000	2026-07-01 19:29:34
8573	1006524033	593122	2	000000000	2026-07-01 19:29:34
8574	1006524033	593159	2	000000000	2026-07-01 19:29:34
8575	1006524033	593160	2	000000000	2026-07-01 19:29:34
8576	1006524033	593161	2	000000000	2026-07-01 19:29:34
8577	1006524033	593162	2	000000000	2026-07-01 19:29:34
8578	1006524033	593224	2	000000000	2026-07-01 19:29:34
8579	1006524033	593225	2	000000000	2026-07-01 19:29:34
8580	1006524033	593226	2	000000000	2026-07-01 19:29:34
8581	1006524033	593227	2	000000000	2026-07-01 19:29:34
8582	1006524033	593235	2	000000000	2026-07-01 19:29:34
8583	1006524033	593236	2	000000000	2026-07-01 19:29:34
8584	1006524033	593237	2	000000000	2026-07-01 19:29:34
8585	1006524033	593238	2	000000000	2026-07-01 19:29:34
8586	1006524033	593109	2	000000000	2026-07-01 19:29:34
8587	1006524033	593110	2	000000000	2026-07-01 19:29:34
8588	1006524033	593111	2	000000000	2026-07-01 19:29:34
8589	1006524033	593112	2	000000000	2026-07-01 19:29:34
8590	1006524033	593100	2	000000000	2026-07-01 19:29:34
8591	1006524033	593101	2	000000000	2026-07-01 19:29:34
8592	1006524033	593102	2	000000000	2026-07-01 19:29:34
8593	1006524033	593103	2	000000000	2026-07-01 19:29:34
8594	1006524033	593060	2	000000000	2026-07-01 19:29:34
8595	1006524033	593061	2	000000000	2026-07-01 19:29:34
8596	1006524033	593062	2	000000000	2026-07-01 19:29:34
8597	1006524033	593104	2	000000000	2026-07-01 19:29:34
8598	1006524033	593105	2	000000000	2026-07-01 19:29:34
8599	1006524033	593106	2	000000000	2026-07-01 19:29:34
8600	1006524033	593107	2	000000000	2026-07-01 19:29:34
8601	1006524033	593108	2	000000000	2026-07-01 19:29:34
8602	1006524033	593144	2	000000000	2026-07-01 19:29:34
8603	1006524033	593145	2	000000000	2026-07-01 19:29:34
8604	1006524033	593146	2	000000000	2026-07-01 19:29:34
8605	1006524033	592373	2	000000000	2026-07-01 19:29:34
8606	1006524033	592374	2	000000000	2026-07-01 19:29:34
8607	1006524033	592375	2	000000000	2026-07-01 19:29:34
8608	1006524033	592376	2	000000000	2026-07-01 19:29:34
8609	1006524033	593344	2	000000000	2026-07-01 19:29:34
8610	1006524033	593345	2	000000000	2026-07-01 19:29:34
8611	1006524033	593346	2	000000000	2026-07-01 19:29:34
8612	1006524033	593347	2	000000000	2026-07-01 19:29:34
8613	1006524033	593243	2	000000000	2026-07-01 19:29:34
8614	1006524033	593244	2	000000000	2026-07-01 19:29:35
8615	1006524033	593245	2	000000000	2026-07-01 19:29:35
8616	1006524033	593246	2	000000000	2026-07-01 19:29:35
8617	1006524033	593255	2	000000000	2026-07-01 19:29:35
8618	1006524033	593256	2	000000000	2026-07-01 19:29:35
8619	1006524033	593257	2	000000000	2026-07-01 19:29:35
8620	1006524033	593258	2	000000000	2026-07-01 19:29:35
8621	1006524033	593259	2	000000000	2026-07-01 19:29:35
8622	1006524033	593340	2	000000000	2026-07-01 19:29:35
8623	1006524033	593341	2	000000000	2026-07-01 19:29:35
8624	1006524033	593342	2	000000000	2026-07-01 19:29:35
8625	1006524148	590803	2	000000000	2026-07-01 19:29:35
8626	1006524148	593147	2	000000000	2026-07-01 19:29:35
8627	1006524148	593148	2	000000000	2026-07-01 19:29:35
8628	1006524148	593149	2	000000000	2026-07-01 19:29:35
8629	1006524148	593150	2	000000000	2026-07-01 19:29:35
8630	1006524148	593343	1	6801355	2024-08-16 16:08:00
8631	1006524148	593151	1	1117507159	2025-03-25 07:03:00
8632	1006524148	593152	1	1117507159	2025-04-07 23:04:00
8633	1006524148	593153	1	1117507159	2025-03-25 07:03:00
8634	1006524148	593154	1	1117507159	2025-03-25 07:03:00
8635	1006524148	593113	2	17656565	2024-12-12 16:12:00
8636	1006524148	593114	2	17656565	2024-12-12 16:12:00
8637	1006524148	593115	1	1098809645	2024-11-19 17:11:00
8638	1006524148	593116	2	17656565	2024-12-12 16:12:00
8639	1006524148	593117	1	1098809645	2024-11-29 20:11:00
8640	1006524148	593118	2	17656565	2024-12-12 16:12:00
8641	1006524148	593155	2	000000000	2026-07-01 19:29:35
8642	1006524148	593156	2	000000000	2026-07-01 19:29:35
8643	1006524148	593157	2	000000000	2026-07-01 19:29:35
8644	1006524148	593158	2	000000000	2026-07-01 19:29:35
8645	1006524148	593119	2	000000000	2026-07-01 19:29:35
8646	1006524148	593120	2	000000000	2026-07-01 19:29:35
8647	1006524148	593121	2	000000000	2026-07-01 19:29:35
8648	1006524148	593122	2	000000000	2026-07-01 19:29:35
8649	1006524148	593159	2	000000000	2026-07-01 19:29:35
8650	1006524148	593160	2	000000000	2026-07-01 19:29:35
8651	1006524148	593161	2	000000000	2026-07-01 19:29:35
8652	1006524148	593162	2	000000000	2026-07-01 19:29:35
8653	1006524148	593224	2	000000000	2026-07-01 19:29:35
8654	1006524148	593225	2	000000000	2026-07-01 19:29:35
8655	1006524148	593226	2	000000000	2026-07-01 19:29:35
8656	1006524148	593227	2	000000000	2026-07-01 19:29:35
8657	1006524148	593235	2	000000000	2026-07-01 19:29:35
8658	1006524148	593236	2	000000000	2026-07-01 19:29:35
8659	1006524148	593237	2	000000000	2026-07-01 19:29:35
8660	1006524148	593238	2	000000000	2026-07-01 19:29:35
8661	1006524148	593109	2	000000000	2026-07-01 19:29:35
8662	1006524148	593110	2	000000000	2026-07-01 19:29:35
8663	1006524148	593111	2	000000000	2026-07-01 19:29:35
8664	1006524148	593112	2	000000000	2026-07-01 19:29:35
8665	1006524148	593100	2	000000000	2026-07-01 19:29:35
8666	1006524148	593101	2	000000000	2026-07-01 19:29:35
8667	1006524148	593102	2	000000000	2026-07-01 19:29:35
8668	1006524148	593103	1	96353963	2024-12-05 06:12:00
8669	1006524148	593060	2	000000000	2026-07-01 19:29:35
8670	1006524148	593061	2	000000000	2026-07-01 19:29:35
8671	1006524148	593062	2	000000000	2026-07-01 19:29:35
8672	1006524148	593104	2	000000000	2026-07-01 19:29:35
8673	1006524148	593105	2	000000000	2026-07-01 19:29:35
8674	1006524148	593106	2	000000000	2026-07-01 19:29:35
8675	1006524148	593107	2	000000000	2026-07-01 19:29:35
8676	1006524148	593108	2	000000000	2026-07-01 19:29:35
8677	1006524148	593144	2	000000000	2026-07-01 19:29:35
8678	1006524148	593145	2	000000000	2026-07-01 19:29:35
8679	1006524148	593146	2	000000000	2026-07-01 19:29:35
1062	1117506583	593114	2	000000000	2026-04-30 19:07:40
1063	1117506583	593115	2	000000000	2026-04-30 19:07:40
1064	1117506583	593116	2	000000000	2026-04-30 19:07:40
1065	1117506583	593117	2	000000000	2026-04-30 19:07:40
1066	1117506583	593118	2	000000000	2026-04-30 19:07:40
1067	1117506583	593155	2	000000000	2026-04-30 19:07:40
1068	1117506583	593156	2	000000000	2026-04-30 19:07:40
1069	1117506583	593157	2	000000000	2026-04-30 19:07:40
1070	1117506583	593158	2	000000000	2026-04-30 19:07:40
1071	1117506583	593119	2	000000000	2026-04-30 19:07:40
1072	1117506583	593120	2	000000000	2026-04-30 19:07:40
1073	1117506583	593121	2	000000000	2026-04-30 19:07:40
1074	1117506583	593122	2	000000000	2026-04-30 19:07:40
1075	1117506583	593159	2	000000000	2026-04-30 19:07:40
1076	1117506583	593160	2	000000000	2026-04-30 19:07:40
1077	1117506583	593161	2	000000000	2026-04-30 19:07:41
1078	1117506583	593162	2	000000000	2026-04-30 19:07:41
1079	1117506583	593224	2	000000000	2026-04-30 19:07:41
1080	1117506583	593225	2	000000000	2026-04-30 19:07:41
1081	1117506583	593226	2	000000000	2026-04-30 19:07:41
1082	1117506583	593227	2	000000000	2026-04-30 19:07:41
1083	1117506583	593235	2	000000000	2026-04-30 19:07:41
1084	1117506583	593236	2	000000000	2026-04-30 19:07:41
1085	1117506583	593237	2	000000000	2026-04-30 19:07:41
1086	1117506583	593238	2	000000000	2026-04-30 19:07:41
1087	1117506583	593109	2	000000000	2026-04-30 19:07:41
1088	1117506583	593110	2	000000000	2026-04-30 19:07:41
1089	1117506583	593111	2	000000000	2026-04-30 19:07:41
1090	1117506583	593112	2	000000000	2026-04-30 19:07:41
1091	1117506583	593100	2	000000000	2026-04-30 19:07:41
1092	1117506583	593101	2	000000000	2026-04-30 19:07:41
1093	1117506583	593102	2	000000000	2026-04-30 19:07:41
1094	1117506583	593103	2	000000000	2026-04-30 19:07:41
1095	1117506583	593060	2	000000000	2026-04-30 19:07:41
1096	1117506583	593061	2	000000000	2026-04-30 19:07:41
1097	1117506583	593062	2	000000000	2026-04-30 19:07:41
1098	1117506583	593104	2	000000000	2026-04-30 19:07:41
1099	1117506583	593105	2	000000000	2026-04-30 19:07:41
1100	1117506583	593106	2	000000000	2026-04-30 19:07:41
1101	1117506583	593107	2	000000000	2026-04-30 19:07:41
1102	1117506583	593108	2	000000000	2026-04-30 19:07:41
1103	1117506583	593144	2	000000000	2026-04-30 19:07:41
1104	1117506583	593145	2	000000000	2026-04-30 19:07:41
1105	1117506583	593146	2	000000000	2026-04-30 19:07:41
1106	1117506583	592373	2	000000000	2026-04-30 19:07:41
1107	1117506583	592374	2	000000000	2026-04-30 19:07:41
1108	1117506583	592375	2	000000000	2026-04-30 19:07:41
1109	1117506583	592376	2	000000000	2026-04-30 19:07:41
1110	1117506583	593344	2	000000000	2026-04-30 19:07:41
1111	1117506583	593345	2	000000000	2026-04-30 19:07:41
1112	1117506583	593346	2	000000000	2026-04-30 19:07:41
1113	1117506583	593347	2	000000000	2026-04-30 19:07:41
1114	1117506583	593243	2	000000000	2026-04-30 19:07:41
1115	1117506583	593244	2	000000000	2026-04-30 19:07:41
1116	1117506583	593245	2	000000000	2026-04-30 19:07:41
1117	1117506583	593246	2	000000000	2026-04-30 19:07:41
1118	1117506583	593255	2	000000000	2026-04-30 19:07:41
1119	1117506583	593256	2	000000000	2026-04-30 19:07:41
1120	1117506583	593257	2	000000000	2026-04-30 19:07:41
1121	1117506583	593258	2	000000000	2026-04-30 19:07:41
1122	1117506583	593259	2	000000000	2026-04-30 19:07:41
1123	1117506583	593340	2	000000000	2026-04-30 19:07:41
1124	1117506583	593341	2	000000000	2026-04-30 19:07:41
1125	1117506583	593342	2	000000000	2026-04-30 19:07:41
1126	1117511568	590803	2	000000000	2026-04-30 19:07:41
1127	1117511568	593147	1	26632272	2025-11-25 09:11:00
1128	1117511568	593148	1	26632272	2025-11-25 09:11:00
1129	1117511568	593149	1	26632272	2025-11-25 09:11:00
1130	1117511568	593150	1	26632272	2025-11-25 09:11:00
1131	1117511568	593343	1	1117523028	2025-02-16 16:02:00
1132	1117511568	593151	1	6801798	2025-03-24 11:03:00
1133	1117511568	593152	2	000000000	2026-04-30 19:07:41
1134	1117511568	593153	2	000000000	2026-04-30 19:07:41
1135	1117511568	593154	1	6801798	2025-03-24 11:03:00
1136	1117511568	593113	2	000000000	2026-04-30 19:07:41
1137	1117511568	593114	2	000000000	2026-04-30 19:07:41
1138	1117511568	593115	1	1117499177	2026-03-24 08:03:00
1139	1117511568	593116	2	000000000	2026-04-30 19:07:41
1140	1117511568	593117	1	1117546314	2025-06-21 10:06:00
1141	1117511568	593118	1	1117499177	2026-03-24 08:03:00
1142	1117511568	593155	2	000000000	2026-04-30 19:07:41
1143	1117511568	593156	1	40776309	2025-11-25 19:11:00
1144	1117511568	593157	2	000000000	2026-04-30 19:07:41
1145	1117511568	593158	1	17654594	2025-06-02 19:06:00
1146	1117511568	593119	1	17648908	2025-12-16 20:12:00
1147	1117511568	593120	1	17648908	2025-04-24 12:04:00
1148	1117511568	593121	1	17648908	2025-12-16 20:12:00
1149	1117511568	593122	1	17648908	2025-12-16 20:12:00
1150	1117511568	593159	2	000000000	2026-04-30 19:07:41
1151	1117511568	593160	2	000000000	2026-04-30 19:07:41
1152	1117511568	593161	2	000000000	2026-04-30 19:07:41
1153	1117511568	593162	2	000000000	2026-04-30 19:07:41
1154	1117511568	593224	1	1117515166	2026-03-16 18:03:00
1155	1117511568	593225	1	1117515166	2025-11-26 17:11:00
1156	1117511568	593226	1	1117515166	2026-03-16 18:03:00
1157	1117511568	593227	1	1117515166	2025-11-26 17:11:00
1158	1117511568	593235	2	000000000	2026-04-30 19:07:41
1159	1117511568	593236	2	000000000	2026-04-30 19:07:41
1160	1117511568	593237	2	000000000	2026-04-30 19:07:41
1161	1117511568	593238	2	000000000	2026-04-30 19:07:41
1162	1117511568	593109	2	000000000	2026-04-30 19:07:41
1163	1117511568	593110	2	000000000	2026-04-30 19:07:41
1164	1117511568	593111	1	96353963	2025-11-28 11:11:00
1165	1117511568	593112	2	000000000	2026-04-30 19:07:41
1166	1117511568	593100	1	1117523028	2025-11-28 09:11:00
1167	1117511568	593101	1	1117523028	2025-11-28 09:11:00
1168	1117511568	593102	2	000000000	2026-04-30 19:07:41
1169	1117511568	593103	1	1117523028	2025-11-28 09:11:00
1170	1117511568	593060	2	000000000	2026-04-30 19:07:41
1171	1117511568	593061	1	6801355	2025-07-23 11:07:00
1172	1117511568	593062	2	000000000	2026-04-30 19:07:41
1173	1117511568	593104	1	1117523028	2025-06-19 07:06:00
1174	1117511568	593105	2	000000000	2026-04-30 19:07:41
1175	1117511568	593106	1	1117523028	2025-11-28 09:11:00
1176	1117511568	593107	2	000000000	2026-04-30 19:07:41
1177	1117511568	593108	1	1117523028	2025-11-28 09:11:00
1178	1117511568	593144	2	000000000	2026-04-30 19:07:41
1179	1117511568	593145	2	000000000	2026-04-30 19:07:41
1180	1117511568	593146	2	000000000	2026-04-30 19:07:41
1181	1117511568	592373	2	000000000	2026-04-30 19:07:41
1182	1117511568	592374	2	000000000	2026-04-30 19:07:41
1183	1117511568	592375	1	96353963	2025-05-25 15:05:00
1184	1117511568	592376	1	1117523028	2025-11-28 09:11:00
1185	1117511568	593344	1	1117523028	2025-07-23 11:07:00
1186	1117511568	593345	2	000000000	2026-04-30 19:07:41
1187	1117511568	593346	1	1117523028	2025-07-23 11:07:00
1188	1117511568	593347	2	000000000	2026-04-30 19:07:41
1189	1117511568	593243	1	1117523028	2025-12-15 09:12:00
1190	1117511568	593244	2	000000000	2026-04-30 19:07:41
1191	1117511568	593245	2	000000000	2026-04-30 19:07:41
1192	1117511568	593246	2	000000000	2026-04-30 19:07:41
1193	1117511568	593255	1	40781077	2025-12-15 17:12:00
1194	1117511568	593256	1	40781077	2025-04-30 18:04:00
1195	1117511568	593257	1	40781077	2025-12-15 17:12:00
1196	1117511568	593258	1	40781077	2025-12-05 09:12:00
1197	1117511568	593259	1	40778471	2025-12-01 11:12:00
1198	1117511568	593340	1	40778471	2025-12-01 11:12:00
1199	1117511568	593341	1	40778471	2025-12-01 11:12:00
1200	1117511568	593342	1	40778471	2025-12-01 11:12:00
1201	1117512328	590803	2	000000000	2026-04-30 19:07:41
1202	1117512328	593147	1	26632272	2025-11-25 10:11:00
1203	1117512328	593148	1	26632272	2025-11-25 10:11:00
1204	1117512328	593149	1	26632272	2025-11-25 10:11:00
1205	1117512328	593150	1	26632272	2025-11-25 10:11:00
1206	1117512328	593343	1	1117523028	2025-02-16 16:02:00
1207	1117512328	593151	1	6801798	2025-03-24 11:03:00
1208	1117512328	593152	2	000000000	2026-04-30 19:07:41
1209	1117512328	593153	2	000000000	2026-04-30 19:07:41
1210	1117512328	593154	1	6801798	2025-03-24 11:03:00
1211	1117512328	593113	2	000000000	2026-04-30 19:07:41
1212	1117512328	593114	2	000000000	2026-04-30 19:07:41
1213	1117512328	593115	1	1117499177	2026-03-24 08:03:00
1214	1117512328	593116	2	000000000	2026-04-30 19:07:41
1215	1117512328	593117	1	1117546314	2025-06-21 10:06:00
1216	1117512328	593118	1	1117499177	2026-03-24 08:03:00
1217	1117512328	593155	2	000000000	2026-04-30 19:07:41
1218	1117512328	593156	1	40776309	2025-11-25 19:11:00
1219	1117512328	593157	2	000000000	2026-04-30 19:07:41
1220	1117512328	593158	1	17654594	2025-06-02 19:06:00
1221	1117512328	593119	1	17648908	2025-12-16 20:12:00
1222	1117512328	593120	1	17648908	2025-04-24 12:04:00
1223	1117512328	593121	1	17648908	2025-12-16 20:12:00
1224	1117512328	593122	1	17648908	2025-12-16 20:12:00
1225	1117512328	593159	2	000000000	2026-04-30 19:07:41
1226	1117512328	593160	2	000000000	2026-04-30 19:07:41
1227	1117512328	593161	2	000000000	2026-04-30 19:07:41
1228	1117512328	593162	2	000000000	2026-04-30 19:07:41
1229	1117512328	593224	1	1117515166	2026-03-16 18:03:00
1230	1117512328	593225	1	1117515166	2025-11-26 17:11:00
1231	1117512328	593226	1	1117515166	2026-03-16 18:03:00
1232	1117512328	593227	1	1117515166	2025-11-26 17:11:00
1233	1117512328	593235	2	000000000	2026-04-30 19:07:41
1234	1117512328	593236	2	000000000	2026-04-30 19:07:41
1235	1117512328	593237	2	000000000	2026-04-30 19:07:41
1236	1117512328	593238	2	000000000	2026-04-30 19:07:41
1237	1117512328	593109	2	000000000	2026-04-30 19:07:41
1238	1117512328	593110	2	000000000	2026-04-30 19:07:41
1239	1117512328	593111	1	96353963	2025-11-28 11:11:00
1240	1117512328	593112	2	000000000	2026-04-30 19:07:41
1241	1117512328	593100	1	1117523028	2025-11-28 09:11:00
1242	1117512328	593101	1	1117523028	2025-11-28 09:11:00
1243	1117512328	593102	2	000000000	2026-04-30 19:07:41
1244	1117512328	593103	1	1117523028	2025-11-28 09:11:00
1245	1117512328	593060	2	000000000	2026-04-30 19:07:41
1246	1117512328	593061	1	6801355	2025-07-23 11:07:00
8680	1006524148	592373	1	6801355	2024-11-29 19:11:00
1247	1117512328	593062	2	000000000	2026-04-30 19:07:41
1248	1117512328	593104	1	1117523028	2025-06-19 07:06:00
1249	1117512328	593105	2	000000000	2026-04-30 19:07:41
1250	1117512328	593106	1	1117523028	2025-11-28 09:11:00
1251	1117512328	593107	2	000000000	2026-04-30 19:07:41
1252	1117512328	593108	1	1117523028	2025-11-28 09:11:00
1253	1117512328	593144	2	000000000	2026-04-30 19:07:41
1254	1117512328	593145	2	000000000	2026-04-30 19:07:41
1255	1117512328	593146	2	000000000	2026-04-30 19:07:41
1256	1117512328	592373	2	000000000	2026-04-30 19:07:41
1257	1117512328	592374	2	000000000	2026-04-30 19:07:41
1258	1117512328	592375	1	96353963	2025-05-25 15:05:00
1259	1117512328	592376	1	1117523028	2025-11-28 09:11:00
1260	1117512328	593344	1	1117523028	2025-07-23 11:07:00
1261	1117512328	593345	2	000000000	2026-04-30 19:07:41
1262	1117512328	593346	1	1117523028	2025-07-23 11:07:00
1263	1117512328	593347	2	000000000	2026-04-30 19:07:41
1264	1117512328	593243	1	1117523028	2025-12-15 09:12:00
1265	1117512328	593244	2	000000000	2026-04-30 19:07:41
1266	1117512328	593245	2	000000000	2026-04-30 19:07:41
1267	1117512328	593246	2	000000000	2026-04-30 19:07:41
1268	1117512328	593255	1	40781077	2025-12-15 17:12:00
1269	1117512328	593256	1	40781077	2025-04-30 18:04:00
1270	1117512328	593257	1	40781077	2025-12-15 17:12:00
1271	1117512328	593258	1	40781077	2025-12-05 09:12:00
1272	1117512328	593259	1	40778471	2025-12-01 10:12:00
1273	1117512328	593340	1	40778471	2025-12-01 10:12:00
1274	1117512328	593341	1	40778471	2025-12-01 10:12:00
1275	1117512328	593342	1	40778471	2025-12-01 10:12:00
1276	1117513057	590803	2	000000000	2026-04-30 19:07:41
1277	1117513057	593147	1	26632272	2025-11-25 10:11:00
1278	1117513057	593148	1	26632272	2025-11-25 10:11:00
1279	1117513057	593149	1	26632272	2025-11-25 10:11:00
1280	1117513057	593150	1	26632272	2025-11-25 10:11:00
1281	1117513057	593343	1	1117523028	2025-02-16 16:02:00
1282	1117513057	593151	1	6801798	2025-03-24 11:03:00
1283	1117513057	593152	2	000000000	2026-04-30 19:07:41
1284	1117513057	593153	2	000000000	2026-04-30 19:07:41
1285	1117513057	593154	1	6801798	2025-03-24 11:03:00
1286	1117513057	593113	2	000000000	2026-04-30 19:07:41
1287	1117513057	593114	2	000000000	2026-04-30 19:07:41
1288	1117513057	593115	1	1117499177	2026-03-24 08:03:00
1289	1117513057	593116	2	000000000	2026-04-30 19:07:41
1290	1117513057	593117	1	1117546314	2025-06-21 10:06:00
1291	1117513057	593118	1	1117499177	2026-03-24 08:03:00
1292	1117513057	593155	2	000000000	2026-04-30 19:07:41
1293	1117513057	593156	1	40776309	2025-11-25 19:11:00
1294	1117513057	593157	2	000000000	2026-04-30 19:07:41
1295	1117513057	593158	1	17654594	2025-06-02 19:06:00
1296	1117513057	593119	1	17648908	2025-12-16 20:12:00
1297	1117513057	593120	1	17648908	2025-04-24 12:04:00
1298	1117513057	593121	1	17648908	2025-12-16 20:12:00
1299	1117513057	593122	1	17648908	2025-12-16 20:12:00
1300	1117513057	593159	2	000000000	2026-04-30 19:07:41
1301	1117513057	593160	2	000000000	2026-04-30 19:07:41
1302	1117513057	593161	2	000000000	2026-04-30 19:07:41
1303	1117513057	593162	2	000000000	2026-04-30 19:07:41
1304	1117513057	593224	1	1117515166	2026-03-16 18:03:00
1305	1117513057	593225	1	1117515166	2025-11-26 17:11:00
1306	1117513057	593226	1	1117515166	2026-03-16 18:03:00
1307	1117513057	593227	1	1117515166	2025-11-26 17:11:00
1308	1117513057	593235	2	000000000	2026-04-30 19:07:41
1309	1117513057	593236	2	000000000	2026-04-30 19:07:41
1310	1117513057	593237	2	000000000	2026-04-30 19:07:41
1311	1117513057	593238	2	000000000	2026-04-30 19:07:41
1312	1117513057	593109	2	000000000	2026-04-30 19:07:41
1313	1117513057	593110	2	000000000	2026-04-30 19:07:41
1314	1117513057	593111	1	96353963	2025-11-28 11:11:00
1315	1117513057	593112	2	000000000	2026-04-30 19:07:41
1316	1117513057	593100	1	1117523028	2025-11-28 09:11:00
1317	1117513057	593101	1	1117523028	2025-11-28 09:11:00
1318	1117513057	593102	2	000000000	2026-04-30 19:07:41
1319	1117513057	593103	1	1117523028	2025-11-28 09:11:00
1320	1117513057	593060	2	000000000	2026-04-30 19:07:41
1321	1117513057	593061	1	6801355	2025-07-23 11:07:00
1322	1117513057	593062	2	000000000	2026-04-30 19:07:41
1323	1117513057	593104	1	1117523028	2025-06-19 07:06:00
1324	1117513057	593105	2	000000000	2026-04-30 19:07:41
1325	1117513057	593106	1	1117523028	2025-11-28 09:11:00
1326	1117513057	593107	2	000000000	2026-04-30 19:07:41
1327	1117513057	593108	1	1117523028	2025-11-28 09:11:00
1328	1117513057	593144	2	000000000	2026-04-30 19:07:41
1329	1117513057	593145	2	000000000	2026-04-30 19:07:41
1330	1117513057	593146	2	000000000	2026-04-30 19:07:41
1331	1117513057	592373	2	000000000	2026-04-30 19:07:41
1332	1117513057	592374	2	000000000	2026-04-30 19:07:41
1333	1117513057	592375	1	96353963	2025-05-25 15:05:00
1334	1117513057	592376	1	1117523028	2025-11-28 09:11:00
1335	1117513057	593344	1	1117523028	2025-07-23 11:07:00
1336	1117513057	593345	2	000000000	2026-04-30 19:07:41
1337	1117513057	593346	1	1117523028	2025-07-23 11:07:00
1338	1117513057	593347	2	000000000	2026-04-30 19:07:41
1339	1117513057	593243	1	1117523028	2025-12-15 09:12:00
1340	1117513057	593244	2	000000000	2026-04-30 19:07:41
1341	1117513057	593245	2	000000000	2026-04-30 19:07:41
1342	1117513057	593246	2	000000000	2026-04-30 19:07:41
1343	1117513057	593255	1	40781077	2025-12-15 17:12:00
1344	1117513057	593256	1	40781077	2025-04-30 18:04:00
1345	1117513057	593257	1	40781077	2025-12-15 17:12:00
1346	1117513057	593258	1	40781077	2025-12-05 09:12:00
1347	1117513057	593259	1	40778471	2025-12-01 11:12:00
1348	1117513057	593340	1	40778471	2025-12-01 11:12:00
1349	1117513057	593341	1	40778471	2025-12-01 11:12:00
1350	1117513057	593342	1	40778471	2025-12-01 11:12:00
1351	1117784339	590803	2	000000000	2026-04-30 19:07:41
1352	1117784339	593147	1	26632272	2025-11-25 09:11:00
1353	1117784339	593148	1	26632272	2025-11-25 09:11:00
1354	1117784339	593149	1	26632272	2025-11-25 09:11:00
1355	1117784339	593150	1	26632272	2025-11-25 09:11:00
1356	1117784339	593343	1	1117523028	2025-02-16 16:02:00
1357	1117784339	593151	1	6801798	2025-03-24 11:03:00
1358	1117784339	593152	2	000000000	2026-04-30 19:07:41
1359	1117784339	593153	2	000000000	2026-04-30 19:07:41
1360	1117784339	593154	1	6801798	2025-03-24 11:03:00
1361	1117784339	593113	2	000000000	2026-04-30 19:07:41
1362	1117784339	593114	2	000000000	2026-04-30 19:07:41
1363	1117784339	593115	1	1117499177	2026-03-24 08:03:00
1364	1117784339	593116	2	000000000	2026-04-30 19:07:41
1365	1117784339	593117	1	1117546314	2025-06-21 10:06:00
1366	1117784339	593118	1	1117499177	2026-03-24 08:03:00
1367	1117784339	593155	2	000000000	2026-04-30 19:07:41
1368	1117784339	593156	1	40776309	2025-11-25 19:11:00
1369	1117784339	593157	2	000000000	2026-04-30 19:07:41
1370	1117784339	593158	1	17654594	2025-06-02 19:06:00
1371	1117784339	593119	1	17648908	2025-12-16 20:12:00
1372	1117784339	593120	1	17648908	2025-04-24 12:04:00
1373	1117784339	593121	1	17648908	2025-12-16 20:12:00
1374	1117784339	593122	1	17648908	2025-12-16 20:12:00
1375	1117784339	593159	2	000000000	2026-04-30 19:07:41
1376	1117784339	593160	2	000000000	2026-04-30 19:07:41
1377	1117784339	593161	2	000000000	2026-04-30 19:07:41
1378	1117784339	593162	2	000000000	2026-04-30 19:07:41
1379	1117784339	593224	1	1117515166	2026-03-16 18:03:00
1380	1117784339	593225	1	1117515166	2025-11-26 17:11:00
1381	1117784339	593226	1	1117515166	2026-03-16 18:03:00
1382	1117784339	593227	1	1117515166	2025-11-26 17:11:00
1383	1117784339	593235	2	000000000	2026-04-30 19:07:41
1384	1117784339	593236	2	000000000	2026-04-30 19:07:41
1385	1117784339	593237	2	000000000	2026-04-30 19:07:41
1386	1117784339	593238	2	000000000	2026-04-30 19:07:41
1387	1117784339	593109	2	000000000	2026-04-30 19:07:41
1388	1117784339	593110	2	000000000	2026-04-30 19:07:41
1389	1117784339	593111	1	96353963	2025-11-28 11:11:00
1390	1117784339	593112	2	000000000	2026-04-30 19:07:41
1391	1117784339	593100	1	1117523028	2025-11-28 09:11:00
1392	1117784339	593101	1	1117523028	2025-11-28 09:11:00
1393	1117784339	593102	2	000000000	2026-04-30 19:07:41
1394	1117784339	593103	1	1117523028	2025-11-28 09:11:00
1395	1117784339	593060	2	000000000	2026-04-30 19:07:41
1396	1117784339	593061	1	6801355	2025-07-23 11:07:00
1397	1117784339	593062	2	000000000	2026-04-30 19:07:41
1398	1117784339	593104	1	1117523028	2025-06-19 07:06:00
1399	1117784339	593105	2	000000000	2026-04-30 19:07:41
1400	1117784339	593106	1	1117523028	2025-11-28 09:11:00
1401	1117784339	593107	2	000000000	2026-04-30 19:07:41
1402	1117784339	593108	1	1117523028	2025-11-28 09:11:00
1403	1117784339	593144	2	000000000	2026-04-30 19:07:41
1404	1117784339	593145	2	000000000	2026-04-30 19:07:41
1405	1117784339	593146	2	000000000	2026-04-30 19:07:41
1406	1117784339	592373	2	000000000	2026-04-30 19:07:41
1407	1117784339	592374	2	000000000	2026-04-30 19:07:41
1408	1117784339	592375	1	96353963	2025-05-25 15:05:00
1409	1117784339	592376	1	1117523028	2025-11-28 09:11:00
1410	1117784339	593344	1	1117523028	2025-07-23 11:07:00
1411	1117784339	593345	2	000000000	2026-04-30 19:07:41
1412	1117784339	593346	1	1117523028	2025-07-23 11:07:00
1413	1117784339	593347	2	000000000	2026-04-30 19:07:41
1414	1117784339	593243	1	1117523028	2025-12-15 09:12:00
1415	1117784339	593244	2	000000000	2026-04-30 19:07:41
1416	1117784339	593245	2	000000000	2026-04-30 19:07:41
1417	1117784339	593246	2	000000000	2026-04-30 19:07:41
1418	1117784339	593255	1	40781077	2025-12-15 17:12:00
1419	1117784339	593256	1	40781077	2025-04-30 18:04:00
1420	1117784339	593257	1	40781077	2025-12-15 17:12:00
1421	1117784339	593258	1	40781077	2025-12-05 09:12:00
1422	1117784339	593259	1	40778471	2025-12-01 10:12:00
1423	1117784339	593340	1	40778471	2025-12-01 10:12:00
1424	1117784339	593341	1	40778471	2025-12-01 10:12:00
1425	1117784339	593342	1	40778471	2025-12-01 10:12:00
1426	1117811948	590803	2	000000000	2026-04-30 19:07:41
1427	1117811948	593147	1	26632272	2025-11-25 09:11:00
1428	1117811948	593148	1	26632272	2025-11-25 09:11:00
1429	1117811948	593149	1	26632272	2025-11-25 09:11:00
1430	1117811948	593150	1	26632272	2025-11-25 09:11:00
1431	1117811948	593343	1	1117523028	2025-02-16 16:02:00
1432	1117811948	593151	1	6801798	2025-03-24 11:03:00
1433	1117811948	593152	2	000000000	2026-04-30 19:07:41
1434	1117811948	593153	2	000000000	2026-04-30 19:07:41
1435	1117811948	593154	1	6801798	2025-03-24 11:03:00
1436	1117811948	593113	2	000000000	2026-04-30 19:07:41
1437	1117811948	593114	2	000000000	2026-04-30 19:07:41
1438	1117811948	593115	1	1117499177	2026-03-24 08:03:00
1439	1117811948	593116	2	000000000	2026-04-30 19:07:41
1440	1117811948	593117	1	1117546314	2025-06-21 10:06:00
1441	1117811948	593118	1	1117499177	2026-03-24 08:03:00
1442	1117811948	593155	2	000000000	2026-04-30 19:07:41
1443	1117811948	593156	1	40776309	2025-11-25 19:11:00
1444	1117811948	593157	2	000000000	2026-04-30 19:07:41
1445	1117811948	593158	1	17654594	2025-06-02 19:06:00
1446	1117811948	593119	1	17648908	2025-12-16 20:12:00
1447	1117811948	593120	1	17648908	2025-04-24 12:04:00
1448	1117811948	593121	1	17648908	2025-12-16 20:12:00
1449	1117811948	593122	1	17648908	2025-12-16 20:12:00
1450	1117811948	593159	2	000000000	2026-04-30 19:07:41
1451	1117811948	593160	2	000000000	2026-04-30 19:07:41
1452	1117811948	593161	2	000000000	2026-04-30 19:07:42
1453	1117811948	593162	2	000000000	2026-04-30 19:07:42
1454	1117811948	593224	1	1117515166	2026-03-16 18:03:00
1455	1117811948	593225	1	1117515166	2025-11-26 17:11:00
1456	1117811948	593226	1	1117515166	2026-03-16 18:03:00
1457	1117811948	593227	1	1117515166	2025-11-26 17:11:00
1458	1117811948	593235	2	000000000	2026-04-30 19:07:42
1459	1117811948	593236	2	000000000	2026-04-30 19:07:42
1460	1117811948	593237	2	000000000	2026-04-30 19:07:42
1461	1117811948	593238	2	000000000	2026-04-30 19:07:42
1462	1117811948	593109	2	000000000	2026-04-30 19:07:42
1463	1117811948	593110	2	000000000	2026-04-30 19:07:42
1464	1117811948	593111	1	96353963	2025-11-28 11:11:00
1465	1117811948	593112	2	000000000	2026-04-30 19:07:42
1466	1117811948	593100	1	1117523028	2025-11-28 09:11:00
1467	1117811948	593101	1	1117523028	2025-11-28 09:11:00
1468	1117811948	593102	2	000000000	2026-04-30 19:07:42
1469	1117811948	593103	1	1117523028	2025-11-28 09:11:00
1470	1117811948	593060	2	000000000	2026-04-30 19:07:42
1471	1117811948	593061	1	6801355	2025-07-23 11:07:00
1472	1117811948	593062	2	000000000	2026-04-30 19:07:42
1473	1117811948	593104	1	1117523028	2025-06-19 07:06:00
1474	1117811948	593105	2	000000000	2026-04-30 19:07:42
1475	1117811948	593106	1	1117523028	2025-11-28 09:11:00
1476	1117811948	593107	2	000000000	2026-04-30 19:07:42
1477	1117811948	593108	1	1117523028	2025-11-28 09:11:00
1478	1117811948	593144	2	000000000	2026-04-30 19:07:42
1479	1117811948	593145	2	000000000	2026-04-30 19:07:42
1480	1117811948	593146	2	000000000	2026-04-30 19:07:42
1481	1117811948	592373	2	000000000	2026-04-30 19:07:42
1482	1117811948	592374	2	000000000	2026-04-30 19:07:42
1483	1117811948	592375	1	96353963	2025-05-25 15:05:00
1484	1117811948	592376	1	1117523028	2025-11-28 09:11:00
1485	1117811948	593344	1	1117523028	2025-07-23 11:07:00
1486	1117811948	593345	2	000000000	2026-04-30 19:07:42
1487	1117811948	593346	1	1117523028	2025-07-23 11:07:00
1488	1117811948	593347	2	000000000	2026-04-30 19:07:42
1489	1117811948	593243	1	1117523028	2025-12-15 09:12:00
1490	1117811948	593244	2	000000000	2026-04-30 19:07:42
1491	1117811948	593245	2	000000000	2026-04-30 19:07:42
1492	1117811948	593246	2	000000000	2026-04-30 19:07:42
1493	1117811948	593255	1	40781077	2025-12-15 17:12:00
1494	1117811948	593256	1	40781077	2025-04-30 18:04:00
1495	1117811948	593257	1	40781077	2025-12-15 17:12:00
1496	1117811948	593258	1	40781077	2025-12-05 09:12:00
1497	1117811948	593259	1	40778471	2025-12-01 11:12:00
1498	1117811948	593340	1	40778471	2025-12-01 11:12:00
1499	1117811948	593341	1	40778471	2025-12-01 11:12:00
1500	1117811948	593342	1	40778471	2025-12-01 11:12:00
1501	1117931191	590803	2	000000000	2026-04-30 19:07:42
1502	1117931191	593147	1	26632272	2025-11-25 10:11:00
1503	1117931191	593148	1	26632272	2025-11-25 10:11:00
1504	1117931191	593149	1	26632272	2025-11-25 10:11:00
1505	1117931191	593150	1	26632272	2025-11-25 10:11:00
1506	1117931191	593343	1	1117523028	2025-02-16 16:02:00
1507	1117931191	593151	1	6801798	2025-03-24 11:03:00
1508	1117931191	593152	2	000000000	2026-04-30 19:07:42
1509	1117931191	593153	2	000000000	2026-04-30 19:07:42
1510	1117931191	593154	1	6801798	2025-03-24 11:03:00
1511	1117931191	593113	2	000000000	2026-04-30 19:07:42
1512	1117931191	593114	2	000000000	2026-04-30 19:07:42
1513	1117931191	593115	1	1117499177	2026-03-24 08:03:00
1514	1117931191	593116	2	000000000	2026-04-30 19:07:42
1515	1117931191	593117	1	1117546314	2025-06-21 10:06:00
1516	1117931191	593118	1	1117499177	2026-03-24 08:03:00
1517	1117931191	593155	2	000000000	2026-04-30 19:07:42
1518	1117931191	593156	1	40776309	2025-11-25 19:11:00
1519	1117931191	593157	2	000000000	2026-04-30 19:07:42
1520	1117931191	593158	1	17654594	2025-06-02 19:06:00
1521	1117931191	593119	1	17648908	2025-12-16 20:12:00
1522	1117931191	593120	1	17648908	2025-04-24 12:04:00
1523	1117931191	593121	1	17648908	2025-12-16 20:12:00
1524	1117931191	593122	1	17648908	2025-12-16 20:12:00
1525	1117931191	593159	2	000000000	2026-04-30 19:07:42
1526	1117931191	593160	2	000000000	2026-04-30 19:07:42
1527	1117931191	593161	2	000000000	2026-04-30 19:07:42
1528	1117931191	593162	2	000000000	2026-04-30 19:07:42
1529	1117931191	593224	1	1117515166	2026-03-16 18:03:00
1530	1117931191	593225	1	1117515166	2025-11-26 17:11:00
1531	1117931191	593226	1	1117515166	2026-03-16 18:03:00
1532	1117931191	593227	1	1117515166	2025-11-26 17:11:00
1533	1117931191	593235	2	000000000	2026-04-30 19:07:42
1534	1117931191	593236	2	000000000	2026-04-30 19:07:42
1535	1117931191	593237	2	000000000	2026-04-30 19:07:42
1536	1117931191	593238	2	000000000	2026-04-30 19:07:42
1537	1117931191	593109	2	000000000	2026-04-30 19:07:42
1538	1117931191	593110	2	000000000	2026-04-30 19:07:42
1539	1117931191	593111	1	96353963	2025-11-28 11:11:00
1540	1117931191	593112	2	000000000	2026-04-30 19:07:42
1541	1117931191	593100	1	1117523028	2025-11-28 09:11:00
1542	1117931191	593101	1	1117523028	2025-11-28 09:11:00
1543	1117931191	593102	2	000000000	2026-04-30 19:07:42
1544	1117931191	593103	1	1117523028	2025-11-28 09:11:00
1545	1117931191	593060	2	000000000	2026-04-30 19:07:42
1546	1117931191	593061	1	6801355	2025-07-23 11:07:00
1547	1117931191	593062	2	000000000	2026-04-30 19:07:42
1548	1117931191	593104	1	1117523028	2025-06-19 07:06:00
1549	1117931191	593105	2	000000000	2026-04-30 19:07:42
1550	1117931191	593106	1	1117523028	2025-11-28 09:11:00
1551	1117931191	593107	2	000000000	2026-04-30 19:07:42
1552	1117931191	593108	1	1117523028	2025-11-28 09:11:00
1553	1117931191	593144	2	000000000	2026-04-30 19:07:42
1554	1117931191	593145	2	000000000	2026-04-30 19:07:42
1555	1117931191	593146	2	000000000	2026-04-30 19:07:42
1556	1117931191	592373	2	000000000	2026-04-30 19:07:42
1557	1117931191	592374	2	000000000	2026-04-30 19:07:42
1558	1117931191	592375	1	96353963	2025-05-25 15:05:00
1559	1117931191	592376	1	1117523028	2025-11-28 09:11:00
1560	1117931191	593344	1	1117523028	2025-07-23 11:07:00
1561	1117931191	593345	2	000000000	2026-04-30 19:07:42
1562	1117931191	593346	1	1117523028	2025-07-23 11:07:00
1563	1117931191	593347	2	000000000	2026-04-30 19:07:42
1564	1117931191	593243	1	1117523028	2025-12-15 09:12:00
1565	1117931191	593244	2	000000000	2026-04-30 19:07:42
1566	1117931191	593245	2	000000000	2026-04-30 19:07:42
1567	1117931191	593246	2	000000000	2026-04-30 19:07:42
1568	1117931191	593255	1	40781077	2025-12-15 17:12:00
9435	1117499559	593345	1	6801355	2024-11-29 19:11:00
1569	1117931191	593256	1	40781077	2025-04-30 18:04:00
1570	1117931191	593257	1	40781077	2025-12-15 17:12:00
1571	1117931191	593258	1	40781077	2025-12-05 09:12:00
1572	1117931191	593259	1	40778471	2025-12-01 11:12:00
1573	1117931191	593340	1	40778471	2025-12-01 11:12:00
1574	1117931191	593341	1	40778471	2025-12-01 11:12:00
1575	1117931191	593342	1	40778471	2025-12-01 11:12:00
1576	1118364706	590803	2	000000000	2026-04-30 19:07:42
1577	1118364706	593147	1	26632272	2025-12-09 08:12:00
1578	1118364706	593148	1	26632272	2025-12-09 08:12:00
1579	1118364706	593149	1	26632272	2025-12-09 08:12:00
1580	1118364706	593150	1	26632272	2025-12-09 08:12:00
1581	1118364706	593343	1	1117523028	2025-02-16 16:02:00
1582	1118364706	593151	1	6801798	2025-03-24 11:03:00
1583	1118364706	593152	2	000000000	2026-04-30 19:07:42
1584	1118364706	593153	2	000000000	2026-04-30 19:07:42
1585	1118364706	593154	1	6801798	2025-03-24 11:03:00
1586	1118364706	593113	2	000000000	2026-04-30 19:07:42
1587	1118364706	593114	2	000000000	2026-04-30 19:07:42
1588	1118364706	593115	1	1117499177	2026-03-24 08:03:00
1589	1118364706	593116	2	000000000	2026-04-30 19:07:42
1590	1118364706	593117	1	1117546314	2025-06-21 10:06:00
1591	1118364706	593118	1	1117499177	2026-03-24 08:03:00
1592	1118364706	593155	2	000000000	2026-04-30 19:07:42
1593	1118364706	593156	1	40776309	2025-12-04 09:12:00
1594	1118364706	593157	2	000000000	2026-04-30 19:07:42
1595	1118364706	593158	1	17654594	2025-06-02 19:06:00
1596	1118364706	593119	1	17648908	2025-12-16 20:12:00
1597	1118364706	593120	1	17648908	2025-04-24 12:04:00
1598	1118364706	593121	1	17648908	2025-12-16 20:12:00
1599	1118364706	593122	1	17648908	2025-12-16 20:12:00
1600	1118364706	593159	2	000000000	2026-04-30 19:07:42
1601	1118364706	593160	2	000000000	2026-04-30 19:07:42
1602	1118364706	593161	2	000000000	2026-04-30 19:07:42
1603	1118364706	593162	2	000000000	2026-04-30 19:07:42
1604	1118364706	593224	1	1117515166	2026-03-16 18:03:00
1605	1118364706	593225	1	1117515166	2025-12-11 13:12:00
1606	1118364706	593226	1	1117515166	2026-03-16 18:03:00
1607	1118364706	593227	1	1117515166	2025-12-11 13:12:00
1608	1118364706	593235	2	000000000	2026-04-30 19:07:42
1609	1118364706	593236	2	000000000	2026-04-30 19:07:42
1610	1118364706	593237	2	000000000	2026-04-30 19:07:42
1611	1118364706	593238	2	000000000	2026-04-30 19:07:42
1612	1118364706	593109	2	000000000	2026-04-30 19:07:42
1613	1118364706	593110	2	000000000	2026-04-30 19:07:42
1614	1118364706	593111	1	96353963	2025-12-04 13:12:00
1615	1118364706	593112	2	000000000	2026-04-30 19:07:42
1616	1118364706	593100	1	1117523028	2025-12-04 17:12:00
1617	1118364706	593101	1	1117523028	2025-12-04 17:12:00
1618	1118364706	593102	2	000000000	2026-04-30 19:07:42
1619	1118364706	593103	1	1117523028	2025-12-04 17:12:00
1620	1118364706	593060	2	000000000	2026-04-30 19:07:42
1621	1118364706	593061	1	6801355	2025-07-23 11:07:00
1622	1118364706	593062	2	000000000	2026-04-30 19:07:42
1623	1118364706	593104	1	1117523028	2025-06-19 07:06:00
1624	1118364706	593105	2	000000000	2026-04-30 19:07:42
1625	1118364706	593106	1	1117523028	2025-12-18 11:12:00
1626	1118364706	593107	2	000000000	2026-04-30 19:07:42
1627	1118364706	593108	1	1117523028	2025-12-18 11:12:00
1628	1118364706	593144	2	000000000	2026-04-30 19:07:42
1629	1118364706	593145	2	000000000	2026-04-30 19:07:42
1630	1118364706	593146	2	000000000	2026-04-30 19:07:42
1631	1118364706	592373	2	000000000	2026-04-30 19:07:42
1632	1118364706	592374	2	000000000	2026-04-30 19:07:42
1633	1118364706	592375	1	96353963	2025-05-25 15:05:00
1634	1118364706	592376	1	1117523028	2025-12-18 11:12:00
1635	1118364706	593344	1	1117523028	2025-07-23 11:07:00
1636	1118364706	593345	2	000000000	2026-04-30 19:07:42
1637	1118364706	593346	1	1117523028	2025-07-23 11:07:00
1638	1118364706	593347	2	000000000	2026-04-30 19:07:42
1639	1118364706	593243	1	1117523028	2025-12-15 09:12:00
1640	1118364706	593244	2	000000000	2026-04-30 19:07:42
1641	1118364706	593245	2	000000000	2026-04-30 19:07:42
1642	1118364706	593246	2	000000000	2026-04-30 19:07:42
1643	1118364706	593255	1	40781077	2025-12-15 17:12:00
1644	1118364706	593256	1	40781077	2025-04-30 18:04:00
1645	1118364706	593257	1	40781077	2025-12-15 17:12:00
1646	1118364706	593258	1	40781077	2025-12-05 09:12:00
1647	1118364706	593259	1	40778471	2025-12-08 18:12:00
1648	1118364706	593340	1	40778471	2025-12-08 18:12:00
1649	1118364706	593341	1	40778471	2025-12-08 18:12:00
1650	1118364706	593342	1	40778471	2025-12-08 18:12:00
1651	1118367954	590803	2	000000000	2026-04-30 19:07:42
1652	1118367954	593147	1	26632272	2025-11-25 09:11:00
1653	1118367954	593148	1	26632272	2025-11-25 09:11:00
1654	1118367954	593149	1	26632272	2025-11-25 09:11:00
1655	1118367954	593150	1	26632272	2025-11-25 09:11:00
1656	1118367954	593343	1	1117523028	2025-02-16 16:02:00
1657	1118367954	593151	1	6801798	2025-03-24 11:03:00
1658	1118367954	593152	2	000000000	2026-04-30 19:07:42
1659	1118367954	593153	2	000000000	2026-04-30 19:07:42
1660	1118367954	593154	1	6801798	2025-03-24 11:03:00
1661	1118367954	593113	2	000000000	2026-04-30 19:07:42
1662	1118367954	593114	2	000000000	2026-04-30 19:07:42
1663	1118367954	593115	1	1117499177	2026-03-24 08:03:00
1664	1118367954	593116	2	000000000	2026-04-30 19:07:42
1665	1118367954	593117	1	1117546314	2025-06-21 10:06:00
1666	1118367954	593118	1	1117499177	2026-03-24 08:03:00
1667	1118367954	593155	2	000000000	2026-04-30 19:07:42
1668	1118367954	593156	1	40776309	2025-11-25 19:11:00
1669	1118367954	593157	2	000000000	2026-04-30 19:07:42
1670	1118367954	593158	1	17654594	2025-06-02 19:06:00
1671	1118367954	593119	1	17648908	2025-12-16 20:12:00
1672	1118367954	593120	1	17648908	2025-04-24 12:04:00
1673	1118367954	593121	1	17648908	2025-12-16 20:12:00
1674	1118367954	593122	1	17648908	2025-12-16 20:12:00
1675	1118367954	593159	2	000000000	2026-04-30 19:07:42
1676	1118367954	593160	2	000000000	2026-04-30 19:07:42
1677	1118367954	593161	2	000000000	2026-04-30 19:07:42
1678	1118367954	593162	2	000000000	2026-04-30 19:07:42
1679	1118367954	593224	1	1117515166	2026-03-16 18:03:00
1680	1118367954	593225	1	1117515166	2025-11-26 17:11:00
1681	1118367954	593226	1	1117515166	2026-03-16 18:03:00
1682	1118367954	593227	1	1117515166	2025-11-26 17:11:00
1683	1118367954	593235	2	000000000	2026-04-30 19:07:42
1684	1118367954	593236	2	000000000	2026-04-30 19:07:42
1685	1118367954	593237	2	000000000	2026-04-30 19:07:42
1686	1118367954	593238	2	000000000	2026-04-30 19:07:42
1687	1118367954	593109	2	000000000	2026-04-30 19:07:42
1688	1118367954	593110	2	000000000	2026-04-30 19:07:42
1689	1118367954	593111	1	96353963	2025-11-28 11:11:00
1690	1118367954	593112	2	000000000	2026-04-30 19:07:42
1691	1118367954	593100	1	1117523028	2025-11-28 09:11:00
1692	1118367954	593101	1	1117523028	2025-11-28 09:11:00
1693	1118367954	593102	2	000000000	2026-04-30 19:07:42
1694	1118367954	593103	1	1117523028	2025-11-28 09:11:00
1695	1118367954	593060	2	000000000	2026-04-30 19:07:42
1696	1118367954	593061	1	6801355	2025-07-23 11:07:00
1697	1118367954	593062	2	000000000	2026-04-30 19:07:42
1698	1118367954	593104	1	1117523028	2025-06-19 07:06:00
1699	1118367954	593105	2	000000000	2026-04-30 19:07:42
1700	1118367954	593106	1	1117523028	2025-11-28 09:11:00
1701	1118367954	593107	2	000000000	2026-04-30 19:07:42
1702	1118367954	593108	1	1117523028	2025-11-28 09:11:00
1703	1118367954	593144	2	000000000	2026-04-30 19:07:42
1704	1118367954	593145	2	000000000	2026-04-30 19:07:42
1705	1118367954	593146	2	000000000	2026-04-30 19:07:42
1706	1118367954	592373	2	000000000	2026-04-30 19:07:42
1707	1118367954	592374	2	000000000	2026-04-30 19:07:42
1708	1118367954	592375	1	96353963	2025-05-25 15:05:00
1709	1118367954	592376	1	1117523028	2025-11-28 09:11:00
1710	1118367954	593344	1	1117523028	2025-07-23 11:07:00
1711	1118367954	593345	2	000000000	2026-04-30 19:07:42
1712	1118367954	593346	1	1117523028	2025-07-23 11:07:00
1713	1118367954	593347	2	000000000	2026-04-30 19:07:42
1714	1118367954	593243	1	1117523028	2025-12-15 09:12:00
1715	1118367954	593244	2	000000000	2026-04-30 19:07:42
1716	1118367954	593245	2	000000000	2026-04-30 19:07:42
1717	1118367954	593246	2	000000000	2026-04-30 19:07:42
1718	1118367954	593255	1	40781077	2025-12-15 17:12:00
1719	1118367954	593256	1	40781077	2025-04-30 18:04:00
1720	1118367954	593257	1	40781077	2025-12-15 17:12:00
1721	1118367954	593258	1	40781077	2025-12-05 09:12:00
1722	1118367954	593259	1	40778471	2025-12-01 11:12:00
1723	1118367954	593340	1	40778471	2025-12-01 11:12:00
1724	1118367954	593341	1	40778471	2025-12-01 11:12:00
1725	1118367954	593342	1	40778471	2025-12-01 11:12:00
1726	1118367962	590803	2	000000000	2026-04-30 19:07:42
1727	1118367962	593147	1	26632272	2025-11-25 10:11:00
1728	1118367962	593148	1	26632272	2025-11-25 10:11:00
1729	1118367962	593149	1	26632272	2025-11-25 10:11:00
1730	1118367962	593150	1	26632272	2025-11-25 10:11:00
1731	1118367962	593343	1	1117523028	2025-02-16 16:02:00
1732	1118367962	593151	1	6801798	2025-03-24 11:03:00
1733	1118367962	593152	2	000000000	2026-04-30 19:07:42
1734	1118367962	593153	2	000000000	2026-04-30 19:07:42
1735	1118367962	593154	1	6801798	2025-03-24 11:03:00
1736	1118367962	593113	2	000000000	2026-04-30 19:07:42
1737	1118367962	593114	2	000000000	2026-04-30 19:07:42
1738	1118367962	593115	1	1117499177	2026-03-24 08:03:00
1739	1118367962	593116	2	000000000	2026-04-30 19:07:42
1740	1118367962	593117	1	1117546314	2025-06-21 10:06:00
1741	1118367962	593118	1	1117499177	2026-03-24 08:03:00
1742	1118367962	593155	2	000000000	2026-04-30 19:07:42
1743	1118367962	593156	1	40776309	2025-11-25 19:11:00
1744	1118367962	593157	2	000000000	2026-04-30 19:07:42
1745	1118367962	593158	1	17654594	2025-06-02 19:06:00
1746	1118367962	593119	1	17648908	2025-12-16 20:12:00
1747	1118367962	593120	1	17648908	2025-04-24 12:04:00
1748	1118367962	593121	1	17648908	2025-12-16 20:12:00
1749	1118367962	593122	1	17648908	2025-12-16 20:12:00
1750	1118367962	593159	2	000000000	2026-04-30 19:07:42
1751	1118367962	593160	2	000000000	2026-04-30 19:07:42
1752	1118367962	593161	2	000000000	2026-04-30 19:07:42
1753	1118367962	593162	2	000000000	2026-04-30 19:07:42
1754	1118367962	593224	1	1117515166	2026-03-16 18:03:00
1755	1118367962	593225	1	1117515166	2025-11-26 17:11:00
1756	1118367962	593226	1	1117515166	2026-03-16 18:03:00
1757	1118367962	593227	1	1117515166	2025-11-26 17:11:00
1758	1118367962	593235	2	000000000	2026-04-30 19:07:42
1759	1118367962	593236	2	000000000	2026-04-30 19:07:42
1760	1118367962	593237	2	000000000	2026-04-30 19:07:42
1761	1118367962	593238	2	000000000	2026-04-30 19:07:42
1762	1118367962	593109	2	000000000	2026-04-30 19:07:42
1763	1118367962	593110	2	000000000	2026-04-30 19:07:42
1764	1118367962	593111	1	96353963	2025-11-28 11:11:00
1765	1118367962	593112	2	000000000	2026-04-30 19:07:42
1766	1118367962	593100	1	1117523028	2025-11-28 09:11:00
1767	1118367962	593101	1	1117523028	2025-11-28 09:11:00
1768	1118367962	593102	2	000000000	2026-04-30 19:07:42
1769	1118367962	593103	1	1117523028	2025-11-28 09:11:00
1770	1118367962	593060	2	000000000	2026-04-30 19:07:42
1771	1118367962	593061	1	6801355	2025-07-23 11:07:00
1772	1118367962	593062	2	000000000	2026-04-30 19:07:42
1773	1118367962	593104	1	1117523028	2025-06-19 07:06:00
1774	1118367962	593105	2	000000000	2026-04-30 19:07:42
1775	1118367962	593106	1	1117523028	2025-11-28 09:11:00
1776	1118367962	593107	2	000000000	2026-04-30 19:07:42
1777	1118367962	593108	1	1117523028	2025-11-28 09:11:00
1778	1118367962	593144	2	000000000	2026-04-30 19:07:42
1779	1118367962	593145	2	000000000	2026-04-30 19:07:42
1780	1118367962	593146	2	000000000	2026-04-30 19:07:42
1781	1118367962	592373	2	000000000	2026-04-30 19:07:42
1782	1118367962	592374	2	000000000	2026-04-30 19:07:42
1783	1118367962	592375	1	96353963	2025-05-25 15:05:00
9436	1117499559	593346	1	6801355	2024-11-29 19:11:00
1784	1118367962	592376	1	1117523028	2025-11-28 09:11:00
1785	1118367962	593344	1	1117523028	2025-07-23 11:07:00
1786	1118367962	593345	2	000000000	2026-04-30 19:07:42
1787	1118367962	593346	1	1117523028	2025-07-23 11:07:00
1788	1118367962	593347	2	000000000	2026-04-30 19:07:42
1789	1118367962	593243	1	1117523028	2025-12-15 09:12:00
1790	1118367962	593244	2	000000000	2026-04-30 19:07:42
1791	1118367962	593245	2	000000000	2026-04-30 19:07:42
1792	1118367962	593246	2	000000000	2026-04-30 19:07:42
1793	1118367962	593255	1	40781077	2025-12-15 17:12:00
1794	1118367962	593256	1	40781077	2025-04-30 18:04:00
1795	1118367962	593257	1	40781077	2025-12-15 17:12:00
1796	1118367962	593258	1	40781077	2025-12-05 09:12:00
1797	1118367962	593259	1	40778471	2025-12-01 11:12:00
1798	1118367962	593340	1	40778471	2025-12-01 11:12:00
1799	1118367962	593341	1	40778471	2025-12-01 11:12:00
1800	1118367962	593342	1	40778471	2025-12-01 11:12:00
1801	1118368430	590803	2	000000000	2026-04-30 19:07:42
1802	1118368430	593147	1	26632272	2025-11-25 09:11:00
1803	1118368430	593148	1	26632272	2025-11-25 09:11:00
1804	1118368430	593149	1	26632272	2025-11-25 09:11:00
1805	1118368430	593150	1	26632272	2025-11-25 09:11:00
1806	1118368430	593343	1	1117523028	2025-02-16 16:02:00
1807	1118368430	593151	1	6801798	2025-03-24 11:03:00
1808	1118368430	593152	2	000000000	2026-04-30 19:07:42
1809	1118368430	593153	2	000000000	2026-04-30 19:07:42
1810	1118368430	593154	1	6801798	2025-03-24 11:03:00
1811	1118368430	593113	2	000000000	2026-04-30 19:07:42
1812	1118368430	593114	2	000000000	2026-04-30 19:07:42
1813	1118368430	593115	1	1117499177	2026-03-24 08:03:00
1814	1118368430	593116	2	000000000	2026-04-30 19:07:42
1815	1118368430	593117	1	1117546314	2025-06-21 10:06:00
1816	1118368430	593118	1	1117499177	2026-03-24 08:03:00
1817	1118368430	593155	2	000000000	2026-04-30 19:07:42
1818	1118368430	593156	1	40776309	2025-11-25 19:11:00
1819	1118368430	593157	2	000000000	2026-04-30 19:07:42
1820	1118368430	593158	1	17654594	2025-06-02 19:06:00
1821	1118368430	593119	1	17648908	2025-12-16 20:12:00
1822	1118368430	593120	1	17648908	2025-04-24 12:04:00
1823	1118368430	593121	1	17648908	2025-12-16 20:12:00
1824	1118368430	593122	1	17648908	2025-12-16 20:12:00
1825	1118368430	593159	2	000000000	2026-04-30 19:07:42
1826	1118368430	593160	2	000000000	2026-04-30 19:07:42
1827	1118368430	593161	2	000000000	2026-04-30 19:07:42
1828	1118368430	593162	2	000000000	2026-04-30 19:07:42
1829	1118368430	593224	1	1117515166	2026-03-16 18:03:00
1830	1118368430	593225	1	1117515166	2025-11-26 17:11:00
1831	1118368430	593226	1	1117515166	2026-03-16 18:03:00
1832	1118368430	593227	1	1117515166	2025-11-26 17:11:00
1833	1118368430	593235	2	000000000	2026-04-30 19:07:43
1834	1118368430	593236	2	000000000	2026-04-30 19:07:43
1835	1118368430	593237	2	000000000	2026-04-30 19:07:43
1836	1118368430	593238	2	000000000	2026-04-30 19:07:43
1837	1118368430	593109	2	000000000	2026-04-30 19:07:43
1838	1118368430	593110	2	000000000	2026-04-30 19:07:43
1839	1118368430	593111	1	96353963	2025-11-28 11:11:00
1840	1118368430	593112	2	000000000	2026-04-30 19:07:43
1841	1118368430	593100	1	1117523028	2025-11-28 09:11:00
1842	1118368430	593101	1	1117523028	2025-11-28 09:11:00
1843	1118368430	593102	2	000000000	2026-04-30 19:07:43
1844	1118368430	593103	1	1117523028	2025-11-28 09:11:00
1845	1118368430	593060	2	000000000	2026-04-30 19:07:43
1846	1118368430	593061	1	6801355	2025-07-23 11:07:00
1847	1118368430	593062	2	000000000	2026-04-30 19:07:43
1848	1118368430	593104	1	1117523028	2025-06-19 07:06:00
1849	1118368430	593105	2	000000000	2026-04-30 19:07:43
1850	1118368430	593106	1	1117523028	2025-11-28 09:11:00
1851	1118368430	593107	2	000000000	2026-04-30 19:07:43
1852	1118368430	593108	1	1117523028	2025-11-28 09:11:00
1853	1118368430	593144	2	000000000	2026-04-30 19:07:43
1854	1118368430	593145	2	000000000	2026-04-30 19:07:43
1855	1118368430	593146	2	000000000	2026-04-30 19:07:43
1856	1118368430	592373	2	000000000	2026-04-30 19:07:43
1857	1118368430	592374	2	000000000	2026-04-30 19:07:43
1858	1118368430	592375	1	96353963	2025-05-25 15:05:00
1859	1118368430	592376	1	1117523028	2025-11-28 09:11:00
1860	1118368430	593344	1	1117523028	2025-07-23 11:07:00
1861	1118368430	593345	2	000000000	2026-04-30 19:07:43
1862	1118368430	593346	1	1117523028	2025-07-23 11:07:00
1863	1118368430	593347	2	000000000	2026-04-30 19:07:43
1864	1118368430	593243	1	1117523028	2025-12-15 09:12:00
1865	1118368430	593244	2	000000000	2026-04-30 19:07:43
1866	1118368430	593245	2	000000000	2026-04-30 19:07:43
1867	1118368430	593246	2	000000000	2026-04-30 19:07:43
1868	1118368430	593255	1	40781077	2025-12-15 17:12:00
1869	1118368430	593256	1	40781077	2025-04-30 18:04:00
1870	1118368430	593257	1	40781077	2025-12-15 17:12:00
1871	1118368430	593258	1	40781077	2025-12-05 09:12:00
1872	1118368430	593259	1	40778471	2025-12-01 10:12:00
1873	1118368430	593340	1	40778471	2025-12-01 10:12:00
1874	1118368430	593341	1	40778471	2025-12-01 10:12:00
1875	1118368430	593342	1	40778471	2025-12-01 10:12:00
1876	1118368446	590803	2	000000000	2026-04-30 19:07:43
1877	1118368446	593147	1	26632272	2025-11-25 09:11:00
1878	1118368446	593148	1	26632272	2025-11-25 09:11:00
1879	1118368446	593149	1	26632272	2025-11-25 09:11:00
1880	1118368446	593150	1	26632272	2025-11-25 09:11:00
1881	1118368446	593343	1	1117523028	2025-02-16 16:02:00
1882	1118368446	593151	1	6801798	2025-03-24 11:03:00
1883	1118368446	593152	2	000000000	2026-04-30 19:07:43
1884	1118368446	593153	2	000000000	2026-04-30 19:07:43
1885	1118368446	593154	1	6801798	2025-03-24 11:03:00
1886	1118368446	593113	2	000000000	2026-04-30 19:07:43
1887	1118368446	593114	2	000000000	2026-04-30 19:07:43
1888	1118368446	593115	1	1117499177	2026-03-24 08:03:00
1889	1118368446	593116	2	000000000	2026-04-30 19:07:43
1890	1118368446	593117	1	1117546314	2025-06-21 10:06:00
1891	1118368446	593118	1	1117499177	2026-03-24 08:03:00
1892	1118368446	593155	2	000000000	2026-04-30 19:07:43
1893	1118368446	593156	1	40776309	2025-11-25 19:11:00
1894	1118368446	593157	2	000000000	2026-04-30 19:07:43
1895	1118368446	593158	1	17654594	2025-06-02 19:06:00
1896	1118368446	593119	1	17648908	2025-12-16 20:12:00
1897	1118368446	593120	1	17648908	2025-04-24 12:04:00
1898	1118368446	593121	1	17648908	2025-12-16 20:12:00
1899	1118368446	593122	1	17648908	2025-12-16 20:12:00
1900	1118368446	593159	2	000000000	2026-04-30 19:07:43
1901	1118368446	593160	2	000000000	2026-04-30 19:07:43
1902	1118368446	593161	2	000000000	2026-04-30 19:07:43
1903	1118368446	593162	2	000000000	2026-04-30 19:07:43
1904	1118368446	593224	1	1117515166	2026-03-16 18:03:00
1905	1118368446	593225	1	1117515166	2025-11-26 17:11:00
1906	1118368446	593226	1	1117515166	2026-03-16 18:03:00
1907	1118368446	593227	1	1117515166	2025-11-26 17:11:00
1908	1118368446	593235	2	000000000	2026-04-30 19:07:43
1909	1118368446	593236	2	000000000	2026-04-30 19:07:43
1910	1118368446	593237	2	000000000	2026-04-30 19:07:43
1911	1118368446	593238	2	000000000	2026-04-30 19:07:43
1912	1118368446	593109	2	000000000	2026-04-30 19:07:43
1913	1118368446	593110	2	000000000	2026-04-30 19:07:43
1914	1118368446	593111	1	96353963	2025-11-28 11:11:00
1915	1118368446	593112	2	000000000	2026-04-30 19:07:43
1916	1118368446	593100	1	1117523028	2025-11-28 09:11:00
1917	1118368446	593101	1	1117523028	2025-11-28 09:11:00
1918	1118368446	593102	2	000000000	2026-04-30 19:07:43
1919	1118368446	593103	1	1117523028	2025-11-28 09:11:00
1920	1118368446	593060	2	000000000	2026-04-30 19:07:43
1921	1118368446	593061	1	6801355	2025-07-23 11:07:00
1922	1118368446	593062	2	000000000	2026-04-30 19:07:43
1923	1118368446	593104	1	1117523028	2025-06-19 07:06:00
1924	1118368446	593105	2	000000000	2026-04-30 19:07:43
1925	1118368446	593106	1	1117523028	2025-11-28 09:11:00
1926	1118368446	593107	2	000000000	2026-04-30 19:07:43
1927	1118368446	593108	1	1117523028	2025-11-28 09:11:00
1928	1118368446	593144	2	000000000	2026-04-30 19:07:43
1929	1118368446	593145	2	000000000	2026-04-30 19:07:43
1930	1118368446	593146	2	000000000	2026-04-30 19:07:43
1931	1118368446	592373	2	000000000	2026-04-30 19:07:43
1932	1118368446	592374	2	000000000	2026-04-30 19:07:43
1933	1118368446	592375	1	96353963	2025-05-25 15:05:00
1934	1118368446	592376	1	1117523028	2025-11-28 09:11:00
1935	1118368446	593344	1	1117523028	2025-07-23 11:07:00
1936	1118368446	593345	2	000000000	2026-04-30 19:07:43
1937	1118368446	593346	1	1117523028	2025-07-23 11:07:00
1938	1118368446	593347	2	000000000	2026-04-30 19:07:43
1939	1118368446	593243	1	1117523028	2025-12-15 09:12:00
1940	1118368446	593244	2	000000000	2026-04-30 19:07:43
1941	1118368446	593245	2	000000000	2026-04-30 19:07:43
1942	1118368446	593246	2	000000000	2026-04-30 19:07:43
1943	1118368446	593255	1	40781077	2025-12-15 17:12:00
1944	1118368446	593256	1	40781077	2025-04-30 18:04:00
1945	1118368446	593257	1	40781077	2025-12-15 17:12:00
1946	1118368446	593258	1	40781077	2025-12-05 09:12:00
1947	1118368446	593259	1	40778471	2025-12-01 09:12:00
1948	1118368446	593340	1	40778471	2025-12-01 09:12:00
1949	1118368446	593341	1	40778471	2025-12-01 09:12:00
1950	1118368446	593342	1	40778471	2025-12-01 09:12:00
1951	1118471378	590803	2	000000000	2026-04-30 19:07:43
1952	1118471378	593147	1	26632272	2025-11-25 09:11:00
1953	1118471378	593148	1	26632272	2025-11-25 09:11:00
1954	1118471378	593149	1	26632272	2025-11-25 09:11:00
1955	1118471378	593150	1	26632272	2025-11-25 09:11:00
1956	1118471378	593343	1	1117523028	2025-02-16 16:02:00
1957	1118471378	593151	1	6801798	2025-03-24 11:03:00
1958	1118471378	593152	2	000000000	2026-04-30 19:07:43
1959	1118471378	593153	2	000000000	2026-04-30 19:07:43
1960	1118471378	593154	1	6801798	2025-03-24 11:03:00
1961	1118471378	593113	2	000000000	2026-04-30 19:07:43
1962	1118471378	593114	2	000000000	2026-04-30 19:07:43
1963	1118471378	593115	1	1117499177	2026-03-24 08:03:00
1964	1118471378	593116	2	000000000	2026-04-30 19:07:43
1965	1118471378	593117	1	1117546314	2025-06-21 10:06:00
1966	1118471378	593118	1	1117499177	2026-03-24 08:03:00
1967	1118471378	593155	2	000000000	2026-04-30 19:07:43
1968	1118471378	593156	1	40776309	2025-11-25 19:11:00
1969	1118471378	593157	2	000000000	2026-04-30 19:07:43
1970	1118471378	593158	1	17654594	2025-06-02 19:06:00
1971	1118471378	593119	1	17648908	2025-12-16 20:12:00
1972	1118471378	593120	1	17648908	2025-04-24 12:04:00
1973	1118471378	593121	1	17648908	2025-12-16 20:12:00
1974	1118471378	593122	1	17648908	2025-12-16 20:12:00
1975	1118471378	593159	2	000000000	2026-04-30 19:07:43
1976	1118471378	593160	2	000000000	2026-04-30 19:07:43
1977	1118471378	593161	2	000000000	2026-04-30 19:07:43
1978	1118471378	593162	2	000000000	2026-04-30 19:07:43
1979	1118471378	593224	1	1117515166	2026-03-16 18:03:00
1980	1118471378	593225	1	1117515166	2025-11-26 17:11:00
1981	1118471378	593226	1	1117515166	2026-03-16 18:03:00
1982	1118471378	593227	1	1117515166	2025-11-26 17:11:00
1983	1118471378	593235	2	000000000	2026-04-30 19:07:43
1984	1118471378	593236	2	000000000	2026-04-30 19:07:43
1985	1118471378	593237	2	000000000	2026-04-30 19:07:43
1986	1118471378	593238	2	000000000	2026-04-30 19:07:43
1987	1118471378	593109	2	000000000	2026-04-30 19:07:43
1988	1118471378	593110	2	000000000	2026-04-30 19:07:43
1989	1118471378	593111	1	96353963	2025-11-28 11:11:00
1990	1118471378	593112	2	000000000	2026-04-30 19:07:43
1991	1118471378	593100	1	1117523028	2025-11-28 09:11:00
1992	1118471378	593101	1	1117523028	2025-11-28 09:11:00
1993	1118471378	593102	2	000000000	2026-04-30 19:07:43
1994	1118471378	593103	1	1117523028	2025-11-28 09:11:00
1995	1118471378	593060	2	000000000	2026-04-30 19:07:43
1996	1118471378	593061	1	6801355	2025-07-23 11:07:00
1997	1118471378	593062	2	000000000	2026-04-30 19:07:43
1998	1118471378	593104	1	1117523028	2025-06-19 07:06:00
9437	1117499559	593347	1	6801355	2024-11-29 19:11:00
1999	1118471378	593105	2	000000000	2026-04-30 19:07:43
2000	1118471378	593106	1	1117523028	2025-11-28 09:11:00
2001	1118471378	593107	2	000000000	2026-04-30 19:07:43
2002	1118471378	593108	1	1117523028	2025-11-28 09:11:00
2003	1118471378	593144	2	000000000	2026-04-30 19:07:43
2004	1118471378	593145	2	000000000	2026-04-30 19:07:43
2005	1118471378	593146	2	000000000	2026-04-30 19:07:43
2006	1118471378	592373	2	000000000	2026-04-30 19:07:43
2007	1118471378	592374	2	000000000	2026-04-30 19:07:43
2008	1118471378	592375	1	96353963	2025-05-25 15:05:00
2009	1118471378	592376	1	1117523028	2025-11-28 09:11:00
2010	1118471378	593344	1	1117523028	2025-07-23 11:07:00
2011	1118471378	593345	2	000000000	2026-04-30 19:07:43
2012	1118471378	593346	1	1117523028	2025-07-23 11:07:00
2013	1118471378	593347	2	000000000	2026-04-30 19:07:43
2014	1118471378	593243	1	1117523028	2025-12-15 09:12:00
2015	1118471378	593244	2	000000000	2026-04-30 19:07:43
2016	1118471378	593245	2	000000000	2026-04-30 19:07:43
2017	1118471378	593246	2	000000000	2026-04-30 19:07:43
2018	1118471378	593255	1	40781077	2025-12-15 17:12:00
2019	1118471378	593256	1	40781077	2025-04-30 18:04:00
2020	1118471378	593257	1	40781077	2025-12-15 17:12:00
2021	1118471378	593258	1	40781077	2025-12-05 09:12:00
2022	1118471378	593259	1	40778471	2025-12-01 09:12:00
2023	1118471378	593340	1	40778471	2025-12-01 09:12:00
2024	1118471378	593341	1	40778471	2025-12-01 09:12:00
2025	1118471378	593342	1	40778471	2025-12-01 09:12:00
2026	1118471476	590803	2	000000000	2026-04-30 19:07:43
2027	1118471476	593147	1	26632272	2025-11-25 09:11:00
2028	1118471476	593148	1	26632272	2025-11-25 09:11:00
2029	1118471476	593149	1	26632272	2025-11-25 09:11:00
2030	1118471476	593150	1	26632272	2025-11-25 09:11:00
2031	1118471476	593343	1	1117523028	2025-02-16 16:02:00
2032	1118471476	593151	1	6801798	2025-03-24 11:03:00
2033	1118471476	593152	2	000000000	2026-04-30 19:07:43
2034	1118471476	593153	2	000000000	2026-04-30 19:07:43
2035	1118471476	593154	1	6801798	2025-03-24 11:03:00
2036	1118471476	593113	2	000000000	2026-04-30 19:07:43
2037	1118471476	593114	2	000000000	2026-04-30 19:07:43
2038	1118471476	593115	1	1117499177	2026-03-24 08:03:00
2039	1118471476	593116	2	000000000	2026-04-30 19:07:43
2040	1118471476	593117	1	1117546314	2025-06-21 10:06:00
2041	1118471476	593118	1	1117499177	2026-03-24 08:03:00
2042	1118471476	593155	2	000000000	2026-04-30 19:07:43
2043	1118471476	593156	1	40776309	2025-11-25 19:11:00
2044	1118471476	593157	2	000000000	2026-04-30 19:07:43
2045	1118471476	593158	1	17654594	2025-06-02 19:06:00
2046	1118471476	593119	1	17648908	2025-12-16 20:12:00
2047	1118471476	593120	1	17648908	2025-04-24 12:04:00
2048	1118471476	593121	1	17648908	2025-12-16 20:12:00
2049	1118471476	593122	1	17648908	2025-12-16 20:12:00
2050	1118471476	593159	2	000000000	2026-04-30 19:07:43
2051	1118471476	593160	2	000000000	2026-04-30 19:07:43
2052	1118471476	593161	2	000000000	2026-04-30 19:07:43
2053	1118471476	593162	2	000000000	2026-04-30 19:07:43
2054	1118471476	593224	1	1117515166	2026-03-16 18:03:00
2055	1118471476	593225	1	1117515166	2025-11-26 17:11:00
2056	1118471476	593226	1	1117515166	2026-03-16 18:03:00
2057	1118471476	593227	1	1117515166	2025-11-26 17:11:00
2058	1118471476	593235	2	000000000	2026-04-30 19:07:43
2059	1118471476	593236	2	000000000	2026-04-30 19:07:43
2060	1118471476	593237	2	000000000	2026-04-30 19:07:43
2061	1118471476	593238	2	000000000	2026-04-30 19:07:43
2062	1118471476	593109	2	000000000	2026-04-30 19:07:43
2063	1118471476	593110	2	000000000	2026-04-30 19:07:43
2064	1118471476	593111	1	96353963	2025-11-28 11:11:00
2065	1118471476	593112	2	000000000	2026-04-30 19:07:43
2066	1118471476	593100	1	1117523028	2025-11-28 09:11:00
2067	1118471476	593101	1	1117523028	2025-11-28 09:11:00
2068	1118471476	593102	2	000000000	2026-04-30 19:07:43
2069	1118471476	593103	1	1117523028	2025-11-28 09:11:00
2070	1118471476	593060	2	000000000	2026-04-30 19:07:43
2071	1118471476	593061	1	6801355	2025-07-23 11:07:00
2072	1118471476	593062	2	000000000	2026-04-30 19:07:43
2073	1118471476	593104	1	1117523028	2025-06-19 07:06:00
2074	1118471476	593105	2	000000000	2026-04-30 19:07:43
2075	1118471476	593106	1	1117523028	2025-11-28 09:11:00
2076	1118471476	593107	2	000000000	2026-04-30 19:07:43
2077	1118471476	593108	1	1117523028	2025-11-28 09:11:00
2078	1118471476	593144	2	000000000	2026-04-30 19:07:43
2079	1118471476	593145	2	000000000	2026-04-30 19:07:43
2080	1118471476	593146	2	000000000	2026-04-30 19:07:43
2081	1118471476	592373	2	000000000	2026-04-30 19:07:43
2082	1118471476	592374	2	000000000	2026-04-30 19:07:43
2083	1118471476	592375	1	96353963	2025-05-25 15:05:00
2084	1118471476	592376	1	1117523028	2025-11-28 09:11:00
2085	1118471476	593344	1	1117523028	2025-07-23 11:07:00
2086	1118471476	593345	2	000000000	2026-04-30 19:07:43
2087	1118471476	593346	1	1117523028	2025-07-23 11:07:00
2088	1118471476	593347	2	000000000	2026-04-30 19:07:43
2089	1118471476	593243	1	1117523028	2025-12-15 09:12:00
2090	1118471476	593244	2	000000000	2026-04-30 19:07:43
2091	1118471476	593245	2	000000000	2026-04-30 19:07:43
2092	1118471476	593246	2	000000000	2026-04-30 19:07:43
2093	1118471476	593255	1	40781077	2025-12-15 17:12:00
2094	1118471476	593256	1	40781077	2025-04-30 18:04:00
2095	1118471476	593257	1	40781077	2025-12-15 17:12:00
2096	1118471476	593258	1	40781077	2025-12-05 09:12:00
2097	1118471476	593259	1	40778471	2025-12-01 09:12:00
2098	1118471476	593340	1	40778471	2025-12-01 09:12:00
2099	1118471476	593341	1	40778471	2025-12-01 09:12:00
2100	1118471476	593342	1	40778471	2025-12-01 09:12:00
2101	1120498200	590803	2	000000000	2026-04-30 19:07:43
2102	1120498200	593147	2	000000000	2026-04-30 19:07:43
2103	1120498200	593148	2	000000000	2026-04-30 19:07:43
2104	1120498200	593149	2	000000000	2026-04-30 19:07:43
2105	1120498200	593150	2	000000000	2026-04-30 19:07:43
2106	1120498200	593343	1	1117523028	2025-02-16 16:02:00
2107	1120498200	593151	1	6801798	2025-03-24 11:03:00
2108	1120498200	593152	2	000000000	2026-04-30 19:07:43
2109	1120498200	593153	2	000000000	2026-04-30 19:07:43
2110	1120498200	593154	1	6801798	2025-03-24 11:03:00
2111	1120498200	593113	2	000000000	2026-04-30 19:07:43
2112	1120498200	593114	2	000000000	2026-04-30 19:07:43
2113	1120498200	593115	2	000000000	2026-04-30 19:07:43
2114	1120498200	593116	2	000000000	2026-04-30 19:07:43
2115	1120498200	593117	1	1117546314	2025-06-21 10:06:00
2116	1120498200	593118	2	000000000	2026-04-30 19:07:43
2117	1120498200	593155	2	000000000	2026-04-30 19:07:43
2118	1120498200	593156	2	000000000	2026-04-30 19:07:43
2119	1120498200	593157	2	000000000	2026-04-30 19:07:43
2120	1120498200	593158	1	17654594	2025-06-02 19:06:00
2121	1120498200	593119	2	000000000	2026-04-30 19:07:43
2122	1120498200	593120	1	17648908	2025-04-24 12:04:00
2123	1120498200	593121	2	000000000	2026-04-30 19:07:43
2124	1120498200	593122	2	000000000	2026-04-30 19:07:43
2125	1120498200	593159	2	000000000	2026-04-30 19:07:43
2126	1120498200	593160	2	000000000	2026-04-30 19:07:43
2127	1120498200	593161	2	000000000	2026-04-30 19:07:43
2128	1120498200	593162	2	000000000	2026-04-30 19:07:43
2129	1120498200	593224	2	000000000	2026-04-30 19:07:43
2130	1120498200	593225	2	000000000	2026-04-30 19:07:43
2131	1120498200	593226	2	000000000	2026-04-30 19:07:43
2132	1120498200	593227	2	000000000	2026-04-30 19:07:43
2133	1120498200	593235	2	000000000	2026-04-30 19:07:43
2134	1120498200	593236	2	000000000	2026-04-30 19:07:43
2135	1120498200	593237	2	000000000	2026-04-30 19:07:43
2136	1120498200	593238	2	000000000	2026-04-30 19:07:43
2137	1120498200	593109	2	000000000	2026-04-30 19:07:43
2138	1120498200	593110	2	000000000	2026-04-30 19:07:43
2139	1120498200	593111	2	000000000	2026-04-30 19:07:43
2140	1120498200	593112	2	000000000	2026-04-30 19:07:43
2141	1120498200	593100	2	000000000	2026-04-30 19:07:43
2142	1120498200	593101	2	000000000	2026-04-30 19:07:43
2143	1120498200	593102	2	000000000	2026-04-30 19:07:43
2144	1120498200	593103	2	000000000	2026-04-30 19:07:43
2145	1120498200	593060	2	000000000	2026-04-30 19:07:43
2146	1120498200	593061	1	6801355	2025-07-23 11:07:00
2147	1120498200	593062	2	000000000	2026-04-30 19:07:43
2148	1120498200	593104	1	1117523028	2025-06-19 07:06:00
2149	1120498200	593105	2	000000000	2026-04-30 19:07:43
2150	1120498200	593106	2	000000000	2026-04-30 19:07:43
2151	1120498200	593107	2	000000000	2026-04-30 19:07:43
2152	1120498200	593108	2	000000000	2026-04-30 19:07:43
2153	1120498200	593144	2	000000000	2026-04-30 19:07:43
2154	1120498200	593145	2	000000000	2026-04-30 19:07:43
2155	1120498200	593146	2	000000000	2026-04-30 19:07:43
2156	1120498200	592373	2	000000000	2026-04-30 19:07:43
2157	1120498200	592374	2	000000000	2026-04-30 19:07:43
2158	1120498200	592375	1	96353963	2025-05-25 15:05:00
2159	1120498200	592376	2	000000000	2026-04-30 19:07:43
2160	1120498200	593344	1	1117523028	2025-07-23 11:07:00
2161	1120498200	593345	2	000000000	2026-04-30 19:07:43
2162	1120498200	593346	1	1117523028	2025-07-23 11:07:00
2163	1120498200	593347	2	000000000	2026-04-30 19:07:43
2164	1120498200	593243	2	000000000	2026-04-30 19:07:43
2165	1120498200	593244	2	000000000	2026-04-30 19:07:43
2166	1120498200	593245	2	000000000	2026-04-30 19:07:43
2167	1120498200	593246	2	000000000	2026-04-30 19:07:43
2168	1120498200	593255	2	000000000	2026-04-30 19:07:43
2169	1120498200	593256	1	40781077	2025-04-30 18:04:00
2170	1120498200	593257	2	000000000	2026-04-30 19:07:43
2171	1120498200	593258	2	000000000	2026-04-30 19:07:43
2172	1120498200	593259	2	000000000	2026-04-30 19:07:43
2173	1120498200	593340	2	000000000	2026-04-30 19:07:43
2174	1120498200	593341	2	000000000	2026-04-30 19:07:43
2175	1120498200	593342	2	000000000	2026-04-30 19:07:43
2176	1122726863	590803	2	000000000	2026-04-30 19:07:43
2177	1122726863	593147	1	26632272	2025-11-25 10:11:00
2178	1122726863	593148	1	26632272	2025-11-25 10:11:00
2179	1122726863	593149	1	26632272	2025-11-25 10:11:00
2180	1122726863	593150	1	26632272	2025-11-25 10:11:00
2181	1122726863	593343	1	1117523028	2025-02-16 16:02:00
2182	1122726863	593151	1	6801798	2025-03-24 11:03:00
2183	1122726863	593152	2	000000000	2026-04-30 19:07:43
2184	1122726863	593153	2	000000000	2026-04-30 19:07:43
2185	1122726863	593154	1	6801798	2025-03-24 11:03:00
2186	1122726863	593113	2	000000000	2026-04-30 19:07:43
2187	1122726863	593114	2	000000000	2026-04-30 19:07:43
2188	1122726863	593115	1	1117499177	2026-03-24 08:03:00
2189	1122726863	593116	2	000000000	2026-04-30 19:07:43
2190	1122726863	593117	1	1117546314	2025-06-21 10:06:00
2191	1122726863	593118	1	1117499177	2026-03-24 08:03:00
2192	1122726863	593155	2	000000000	2026-04-30 19:07:43
2193	1122726863	593156	1	40776309	2025-11-25 19:11:00
2194	1122726863	593157	2	000000000	2026-04-30 19:07:43
2195	1122726863	593158	1	17654594	2025-06-02 19:06:00
2196	1122726863	593119	1	17648908	2025-12-16 20:12:00
2197	1122726863	593120	1	17648908	2025-04-24 12:04:00
2198	1122726863	593121	1	17648908	2025-12-16 20:12:00
2199	1122726863	593122	1	17648908	2025-12-16 20:12:00
2200	1122726863	593159	2	000000000	2026-04-30 19:07:43
2201	1122726863	593160	2	000000000	2026-04-30 19:07:43
2202	1122726863	593161	2	000000000	2026-04-30 19:07:43
2203	1122726863	593162	2	000000000	2026-04-30 19:07:44
2204	1122726863	593224	1	1117515166	2026-03-16 18:03:00
2205	1122726863	593225	1	1117515166	2025-11-26 17:11:00
2206	1122726863	593226	1	1117515166	2026-03-16 18:03:00
2207	1122726863	593227	1	1117515166	2025-11-26 17:11:00
2208	1122726863	593235	2	000000000	2026-04-30 19:07:44
2209	1122726863	593236	2	000000000	2026-04-30 19:07:44
2210	1122726863	593237	2	000000000	2026-04-30 19:07:44
2211	1122726863	593238	2	000000000	2026-04-30 19:07:44
2212	1122726863	593109	2	000000000	2026-04-30 19:07:44
2213	1122726863	593110	2	000000000	2026-04-30 19:07:44
2214	1122726863	593111	1	96353963	2025-11-28 11:11:00
2215	1122726863	593112	2	000000000	2026-04-30 19:07:44
2216	1122726863	593100	1	1117523028	2025-11-28 09:11:00
2217	1122726863	593101	1	1117523028	2025-11-28 09:11:00
2218	1122726863	593102	2	000000000	2026-04-30 19:07:44
2219	1122726863	593103	1	1117523028	2025-11-28 09:11:00
2220	1122726863	593060	2	000000000	2026-04-30 19:07:44
2221	1122726863	593061	1	6801355	2025-07-23 11:07:00
2222	1122726863	593062	2	000000000	2026-04-30 19:07:44
2223	1122726863	593104	1	1117523028	2025-06-19 07:06:00
2224	1122726863	593105	2	000000000	2026-04-30 19:07:44
2225	1122726863	593106	1	1117523028	2025-11-28 09:11:00
2226	1122726863	593107	2	000000000	2026-04-30 19:07:44
2227	1122726863	593108	1	1117523028	2025-11-28 09:11:00
2228	1122726863	593144	2	000000000	2026-04-30 19:07:44
2229	1122726863	593145	2	000000000	2026-04-30 19:07:44
2230	1122726863	593146	2	000000000	2026-04-30 19:07:44
2231	1122726863	592373	2	000000000	2026-04-30 19:07:44
2232	1122726863	592374	2	000000000	2026-04-30 19:07:44
2233	1122726863	592375	1	96353963	2025-05-25 15:05:00
2234	1122726863	592376	1	1117523028	2025-11-28 09:11:00
2235	1122726863	593344	1	1117523028	2025-07-23 11:07:00
2236	1122726863	593345	2	000000000	2026-04-30 19:07:44
2237	1122726863	593346	1	1117523028	2025-07-23 11:07:00
2238	1122726863	593347	2	000000000	2026-04-30 19:07:44
2239	1122726863	593243	1	1117523028	2025-12-15 09:12:00
2240	1122726863	593244	2	000000000	2026-04-30 19:07:44
2241	1122726863	593245	2	000000000	2026-04-30 19:07:44
2242	1122726863	593246	2	000000000	2026-04-30 19:07:44
2243	1122726863	593255	1	40781077	2025-12-15 17:12:00
2244	1122726863	593256	1	40781077	2025-04-30 18:04:00
2245	1122726863	593257	1	40781077	2025-12-15 17:12:00
2246	1122726863	593258	1	40781077	2025-12-05 09:12:00
2247	1122726863	593259	1	40778471	2025-12-01 11:12:00
2248	1122726863	593340	1	40778471	2025-12-01 11:12:00
2249	1122726863	593341	1	40778471	2025-12-01 11:12:00
2250	1122726863	593342	1	40778471	2025-12-01 11:12:00
2251	1130268455	590803	2	000000000	2026-04-30 19:07:44
2252	1130268455	593147	1	26632272	2025-11-25 09:11:00
2253	1130268455	593148	1	26632272	2025-11-25 09:11:00
2254	1130268455	593149	1	26632272	2025-11-25 09:11:00
2255	1130268455	593150	1	26632272	2025-11-25 09:11:00
2256	1130268455	593343	1	1117523028	2025-02-16 16:02:00
2257	1130268455	593151	1	6801798	2025-03-24 11:03:00
2258	1130268455	593152	2	000000000	2026-04-30 19:07:44
2259	1130268455	593153	2	000000000	2026-04-30 19:07:44
2260	1130268455	593154	1	6801798	2025-03-24 11:03:00
2261	1130268455	593113	2	000000000	2026-04-30 19:07:44
2262	1130268455	593114	2	000000000	2026-04-30 19:07:44
2263	1130268455	593115	2	000000000	2026-04-30 19:07:44
2264	1130268455	593116	2	000000000	2026-04-30 19:07:44
2265	1130268455	593117	1	1117546314	2025-06-21 10:06:00
2266	1130268455	593118	2	000000000	2026-04-30 19:07:44
2267	1130268455	593155	2	000000000	2026-04-30 19:07:44
2268	1130268455	593156	1	40776309	2025-11-25 19:11:00
2269	1130268455	593157	2	000000000	2026-04-30 19:07:44
2270	1130268455	593158	1	17654594	2025-06-02 19:06:00
2271	1130268455	593119	1	17648908	2025-12-05 13:12:00
2272	1130268455	593120	1	17648908	2025-04-24 12:04:00
2273	1130268455	593121	1	17648908	2025-12-05 13:12:00
2274	1130268455	593122	1	17648908	2025-12-05 13:12:00
2275	1130268455	593159	2	000000000	2026-04-30 19:07:44
2276	1130268455	593160	2	000000000	2026-04-30 19:07:44
2277	1130268455	593161	2	000000000	2026-04-30 19:07:44
2278	1130268455	593162	2	000000000	2026-04-30 19:07:44
2279	1130268455	593224	2	000000000	2026-04-30 19:07:44
2280	1130268455	593225	1	1117515166	2025-11-26 17:11:00
2281	1130268455	593226	2	000000000	2026-04-30 19:07:44
2282	1130268455	593227	1	1117515166	2025-11-26 17:11:00
2283	1130268455	593235	2	000000000	2026-04-30 19:07:44
2284	1130268455	593236	1	17653145	2025-11-25 13:11:00
2285	1130268455	593237	2	000000000	2026-04-30 19:07:44
2286	1130268455	593238	2	000000000	2026-04-30 19:07:44
2287	1130268455	593109	2	000000000	2026-04-30 19:07:44
2288	1130268455	593110	2	000000000	2026-04-30 19:07:44
2289	1130268455	593111	1	96353963	2025-11-28 11:11:00
2290	1130268455	593112	2	000000000	2026-04-30 19:07:44
2291	1130268455	593100	1	1117523028	2025-11-28 09:11:00
2292	1130268455	593101	1	1117523028	2025-11-28 09:11:00
2293	1130268455	593102	2	000000000	2026-04-30 19:07:44
2294	1130268455	593103	1	1117523028	2025-11-28 09:11:00
2295	1130268455	593060	2	000000000	2026-04-30 19:07:44
2296	1130268455	593061	1	6801355	2025-07-23 11:07:00
2297	1130268455	593062	2	000000000	2026-04-30 19:07:44
2298	1130268455	593104	1	1117523028	2025-06-19 07:06:00
2299	1130268455	593105	2	000000000	2026-04-30 19:07:44
2300	1130268455	593106	1	1117523028	2025-11-28 09:11:00
2301	1130268455	593107	2	000000000	2026-04-30 19:07:44
2302	1130268455	593108	1	1117523028	2025-11-28 09:11:00
2303	1130268455	593144	2	000000000	2026-04-30 19:07:44
2304	1130268455	593145	2	000000000	2026-04-30 19:07:44
2305	1130268455	593146	2	000000000	2026-04-30 19:07:44
2306	1130268455	592373	2	000000000	2026-04-30 19:07:44
2307	1130268455	592374	2	000000000	2026-04-30 19:07:44
2308	1130268455	592375	1	96353963	2025-05-25 15:05:00
2309	1130268455	592376	1	1117523028	2025-11-28 09:11:00
2310	1130268455	593344	1	1117523028	2025-07-23 11:07:00
2311	1130268455	593345	2	000000000	2026-04-30 19:07:44
2312	1130268455	593346	1	1117523028	2025-07-23 11:07:00
2313	1130268455	593347	2	000000000	2026-04-30 19:07:44
2314	1130268455	593243	1	1117523028	2025-12-15 09:12:00
2315	1130268455	593244	2	000000000	2026-04-30 19:07:44
2316	1130268455	593245	2	000000000	2026-04-30 19:07:44
2317	1130268455	593246	2	000000000	2026-04-30 19:07:44
2318	1130268455	593255	1	40781077	2025-12-15 17:12:00
2319	1130268455	593256	1	40781077	2025-04-30 18:04:00
2320	1130268455	593257	1	40781077	2025-12-15 17:12:00
2321	1130268455	593258	1	40781077	2025-12-05 09:12:00
2322	1130268455	593259	1	40778471	2025-12-08 18:12:00
2323	1130268455	593340	1	40778471	2025-12-08 18:12:00
2324	1130268455	593341	1	40778471	2025-12-08 18:12:00
2325	1130268455	593342	1	40778471	2025-12-08 18:12:00
8681	1006524148	592374	2	000000000	2026-07-01 19:29:35
8682	1006524148	592375	1	6801355	2024-11-29 19:11:00
8683	1006524148	592376	1	6801355	2024-11-29 19:11:00
8684	1006524148	593344	1	6801355	2024-11-29 19:11:00
8685	1006524148	593345	1	6801355	2024-11-29 19:11:00
8686	1006524148	593346	1	6801355	2024-11-29 19:11:00
8687	1006524148	593347	1	6801355	2024-11-29 19:11:00
8688	1006524148	593243	2	000000000	2026-07-01 19:29:35
8689	1006524148	593244	2	000000000	2026-07-01 19:29:35
8690	1006524148	593245	2	000000000	2026-07-01 19:29:35
8691	1006524148	593246	2	000000000	2026-07-01 19:29:35
8692	1006524148	593255	1	40781077	2024-12-03 18:12:00
8693	1006524148	593256	1	40781077	2024-12-03 18:12:00
8694	1006524148	593257	1	40781077	2024-12-03 18:12:00
8695	1006524148	593258	1	40781077	2024-12-03 18:12:00
8696	1006524148	593259	2	000000000	2026-07-01 19:29:36
8697	1006524148	593340	2	000000000	2026-07-01 19:29:36
8698	1006524148	593341	2	000000000	2026-07-01 19:29:36
8699	1006524148	593342	2	000000000	2026-07-01 19:29:36
8700	1032499166	590803	2	000000000	2026-07-01 19:29:36
8701	1032499166	593147	2	000000000	2026-07-01 19:29:36
8702	1032499166	593148	2	000000000	2026-07-01 19:29:36
8703	1032499166	593149	2	000000000	2026-07-01 19:29:36
8704	1032499166	593150	2	000000000	2026-07-01 19:29:36
8705	1032499166	593343	1	6801355	2024-08-16 16:08:00
8706	1032499166	593151	2	000000000	2026-07-01 19:29:36
8707	1032499166	593152	2	000000000	2026-07-01 19:29:36
8708	1032499166	593153	2	000000000	2026-07-01 19:29:36
8709	1032499166	593154	2	000000000	2026-07-01 19:29:36
8710	1032499166	593113	2	000000000	2026-07-01 19:29:36
8711	1032499166	593114	2	000000000	2026-07-01 19:29:36
8712	1032499166	593115	2	000000000	2026-07-01 19:29:36
8713	1032499166	593116	2	000000000	2026-07-01 19:29:36
8714	1032499166	593117	2	000000000	2026-07-01 19:29:36
8715	1032499166	593118	2	000000000	2026-07-01 19:29:36
8716	1032499166	593155	2	000000000	2026-07-01 19:29:36
8717	1032499166	593156	2	000000000	2026-07-01 19:29:36
8718	1032499166	593157	2	000000000	2026-07-01 19:29:36
8719	1032499166	593158	2	000000000	2026-07-01 19:29:36
8720	1032499166	593119	2	000000000	2026-07-01 19:29:36
8721	1032499166	593120	2	000000000	2026-07-01 19:29:36
8722	1032499166	593121	2	000000000	2026-07-01 19:29:36
8723	1032499166	593122	2	000000000	2026-07-01 19:29:36
8724	1032499166	593159	2	000000000	2026-07-01 19:29:36
8725	1032499166	593160	2	000000000	2026-07-01 19:29:36
8726	1032499166	593161	2	000000000	2026-07-01 19:29:36
8727	1032499166	593162	2	000000000	2026-07-01 19:29:36
8728	1032499166	593224	2	000000000	2026-07-01 19:29:36
8729	1032499166	593225	2	000000000	2026-07-01 19:29:36
8730	1032499166	593226	2	000000000	2026-07-01 19:29:36
8731	1032499166	593227	2	000000000	2026-07-01 19:29:36
8732	1032499166	593235	2	000000000	2026-07-01 19:29:36
8733	1032499166	593236	2	000000000	2026-07-01 19:29:36
8734	1032499166	593237	2	000000000	2026-07-01 19:29:36
8735	1032499166	593238	2	000000000	2026-07-01 19:29:36
8736	1032499166	593109	2	000000000	2026-07-01 19:29:36
8737	1032499166	593110	2	000000000	2026-07-01 19:29:36
8738	1032499166	593111	2	000000000	2026-07-01 19:29:36
8739	1032499166	593112	2	000000000	2026-07-01 19:29:36
8740	1032499166	593100	2	000000000	2026-07-01 19:29:36
8741	1032499166	593101	2	000000000	2026-07-01 19:29:36
8742	1032499166	593102	2	000000000	2026-07-01 19:29:36
8743	1032499166	593103	2	000000000	2026-07-01 19:29:36
8744	1032499166	593060	2	000000000	2026-07-01 19:29:36
8745	1032499166	593061	2	000000000	2026-07-01 19:29:36
8746	1032499166	593062	2	000000000	2026-07-01 19:29:36
8747	1032499166	593104	2	000000000	2026-07-01 19:29:36
8748	1032499166	593105	2	000000000	2026-07-01 19:29:36
8749	1032499166	593106	2	000000000	2026-07-01 19:29:36
8750	1032499166	593107	2	000000000	2026-07-01 19:29:36
8751	1032499166	593108	2	000000000	2026-07-01 19:29:36
8752	1032499166	593144	2	000000000	2026-07-01 19:29:36
8753	1032499166	593145	2	000000000	2026-07-01 19:29:36
8754	1032499166	593146	2	000000000	2026-07-01 19:29:36
8755	1032499166	592373	2	000000000	2026-07-01 19:29:36
8756	1032499166	592374	2	000000000	2026-07-01 19:29:36
8757	1032499166	592375	2	000000000	2026-07-01 19:29:36
8758	1032499166	592376	2	000000000	2026-07-01 19:29:36
8759	1032499166	593344	2	000000000	2026-07-01 19:29:36
8760	1032499166	593345	2	000000000	2026-07-01 19:29:36
8761	1032499166	593346	2	000000000	2026-07-01 19:29:36
8762	1032499166	593347	2	000000000	2026-07-01 19:29:37
8763	1032499166	593243	2	000000000	2026-07-01 19:29:37
8764	1032499166	593244	2	000000000	2026-07-01 19:29:37
8765	1032499166	593245	2	000000000	2026-07-01 19:29:37
8766	1032499166	593246	2	000000000	2026-07-01 19:29:37
8767	1032499166	593255	2	000000000	2026-07-01 19:29:37
8768	1032499166	593256	2	000000000	2026-07-01 19:29:37
8769	1032499166	593257	2	000000000	2026-07-01 19:29:37
8770	1032499166	593258	2	000000000	2026-07-01 19:29:37
8771	1032499166	593259	2	000000000	2026-07-01 19:29:37
8772	1032499166	593340	2	000000000	2026-07-01 19:29:37
8773	1032499166	593341	2	000000000	2026-07-01 19:29:37
8774	1032499166	593342	2	000000000	2026-07-01 19:29:37
8775	1076502079	590803	2	000000000	2026-07-01 19:29:37
8776	1076502079	593147	2	000000000	2026-07-01 19:29:37
8777	1076502079	593148	2	000000000	2026-07-01 19:29:37
8778	1076502079	593149	2	000000000	2026-07-01 19:29:37
8779	1076502079	593150	2	000000000	2026-07-01 19:29:37
8780	1076502079	593343	1	6801355	2024-08-16 16:08:00
8781	1076502079	593151	1	1117507159	2025-03-25 07:03:00
8782	1076502079	593152	1	1117507159	2025-04-07 23:04:00
8783	1076502079	593153	1	1117507159	2025-03-25 07:03:00
8784	1076502079	593154	1	1117507159	2025-03-25 07:03:00
8785	1076502079	593113	2	17656565	2024-12-12 16:12:00
8786	1076502079	593114	2	17656565	2024-12-12 16:12:00
8787	1076502079	593115	1	1098809645	2024-11-29 20:11:00
8788	1076502079	593116	2	17656565	2024-12-12 16:12:00
8789	1076502079	593117	1	1098809645	2024-11-29 20:11:00
8790	1076502079	593118	2	17656565	2024-12-12 16:12:00
8791	1076502079	593155	2	000000000	2026-07-01 19:29:37
8792	1076502079	593156	2	000000000	2026-07-01 19:29:37
8793	1076502079	593157	2	000000000	2026-07-01 19:29:37
8794	1076502079	593158	2	000000000	2026-07-01 19:29:37
8795	1076502079	593119	2	000000000	2026-07-01 19:29:37
8796	1076502079	593120	2	000000000	2026-07-01 19:29:37
8797	1076502079	593121	2	000000000	2026-07-01 19:29:37
8798	1076502079	593122	2	000000000	2026-07-01 19:29:37
8799	1076502079	593159	2	000000000	2026-07-01 19:29:37
8800	1076502079	593160	2	000000000	2026-07-01 19:29:37
8801	1076502079	593161	2	000000000	2026-07-01 19:29:37
8802	1076502079	593162	2	000000000	2026-07-01 19:29:37
8803	1076502079	593224	2	000000000	2026-07-01 19:29:37
8804	1076502079	593225	2	000000000	2026-07-01 19:29:37
8805	1076502079	593226	2	000000000	2026-07-01 19:29:37
8806	1076502079	593227	2	000000000	2026-07-01 19:29:37
8807	1076502079	593235	2	000000000	2026-07-01 19:29:37
8808	1076502079	593236	2	000000000	2026-07-01 19:29:37
8809	1076502079	593237	2	000000000	2026-07-01 19:29:37
8810	1076502079	593238	2	000000000	2026-07-01 19:29:37
8811	1076502079	593109	2	000000000	2026-07-01 19:29:37
8812	1076502079	593110	2	000000000	2026-07-01 19:29:37
8813	1076502079	593111	2	000000000	2026-07-01 19:29:37
8814	1076502079	593112	2	000000000	2026-07-01 19:29:37
8815	1076502079	593100	2	000000000	2026-07-01 19:29:37
8816	1076502079	593101	2	000000000	2026-07-01 19:29:37
8817	1076502079	593102	2	000000000	2026-07-01 19:29:37
8818	1076502079	593103	1	96353963	2024-12-05 06:12:00
8819	1076502079	593060	2	000000000	2026-07-01 19:29:37
8820	1076502079	593061	2	000000000	2026-07-01 19:29:37
8821	1076502079	593062	2	000000000	2026-07-01 19:29:37
8822	1076502079	593104	2	000000000	2026-07-01 19:29:37
8823	1076502079	593105	2	000000000	2026-07-01 19:29:37
8824	1076502079	593106	2	000000000	2026-07-01 19:29:37
8825	1076502079	593107	2	000000000	2026-07-01 19:29:37
8826	1076502079	593108	2	000000000	2026-07-01 19:29:37
8827	1076502079	593144	2	000000000	2026-07-01 19:29:37
8828	1076502079	593145	2	000000000	2026-07-01 19:29:37
8829	1076502079	593146	2	000000000	2026-07-01 19:29:37
8830	1076502079	592373	1	6801355	2024-11-29 19:11:00
8831	1076502079	592374	2	000000000	2026-07-01 19:29:37
8832	1076502079	592375	1	6801355	2024-11-29 19:11:00
8833	1076502079	592376	1	6801355	2024-11-29 19:11:00
8834	1076502079	593344	1	6801355	2024-11-29 19:11:00
8835	1076502079	593345	1	6801355	2024-11-29 19:11:00
8836	1076502079	593346	1	6801355	2024-11-29 19:11:00
8837	1076502079	593347	1	6801355	2024-11-29 19:11:00
8838	1076502079	593243	2	000000000	2026-07-01 19:29:38
8839	1076502079	593244	2	000000000	2026-07-01 19:29:38
8840	1076502079	593245	2	000000000	2026-07-01 19:29:38
8841	1076502079	593246	2	000000000	2026-07-01 19:29:38
8842	1076502079	593255	1	40781077	2024-12-03 18:12:00
8843	1076502079	593256	1	40781077	2024-12-03 18:12:00
8844	1076502079	593257	1	40781077	2024-12-03 18:12:00
8845	1076502079	593258	1	40781077	2024-12-03 18:12:00
8846	1076502079	593259	2	000000000	2026-07-01 19:29:38
8847	1076502079	593340	2	000000000	2026-07-01 19:29:38
8848	1076502079	593341	2	000000000	2026-07-01 19:29:38
8849	1076502079	593342	2	000000000	2026-07-01 19:29:38
8850	1110583373	590803	2	000000000	2026-07-01 19:29:38
8851	1110583373	593147	2	000000000	2026-07-01 19:29:38
8852	1110583373	593148	2	000000000	2026-07-01 19:29:38
8853	1110583373	593149	2	000000000	2026-07-01 19:29:38
8854	1110583373	593150	2	000000000	2026-07-01 19:29:38
8855	1110583373	593343	2	000000000	2026-07-01 19:29:38
8856	1110583373	593151	2	000000000	2026-07-01 19:29:38
8857	1110583373	593152	2	000000000	2026-07-01 19:29:38
8858	1110583373	593153	2	000000000	2026-07-01 19:29:38
8859	1110583373	593154	2	000000000	2026-07-01 19:29:38
8860	1110583373	593113	2	000000000	2026-07-01 19:29:38
8861	1110583373	593114	2	000000000	2026-07-01 19:29:38
8862	1110583373	593115	2	000000000	2026-07-01 19:29:38
8863	1110583373	593116	2	000000000	2026-07-01 19:29:38
8864	1110583373	593117	2	000000000	2026-07-01 19:29:38
8865	1110583373	593118	2	000000000	2026-07-01 19:29:38
8866	1110583373	593155	2	000000000	2026-07-01 19:29:38
8867	1110583373	593156	2	000000000	2026-07-01 19:29:38
8868	1110583373	593157	2	000000000	2026-07-01 19:29:38
8869	1110583373	593158	2	000000000	2026-07-01 19:29:38
8870	1110583373	593119	2	000000000	2026-07-01 19:29:38
8871	1110583373	593120	2	000000000	2026-07-01 19:29:38
8872	1110583373	593121	2	000000000	2026-07-01 19:29:38
8873	1110583373	593122	2	000000000	2026-07-01 19:29:38
8874	1110583373	593159	2	000000000	2026-07-01 19:29:38
8875	1110583373	593160	2	000000000	2026-07-01 19:29:38
8876	1110583373	593161	2	000000000	2026-07-01 19:29:38
8877	1110583373	593162	2	000000000	2026-07-01 19:29:38
8878	1110583373	593224	2	000000000	2026-07-01 19:29:38
8879	1110583373	593225	2	000000000	2026-07-01 19:29:38
8880	1110583373	593226	2	000000000	2026-07-01 19:29:38
8881	1110583373	593227	2	000000000	2026-07-01 19:29:38
8882	1110583373	593235	2	000000000	2026-07-01 19:29:38
8883	1110583373	593236	2	000000000	2026-07-01 19:29:38
8884	1110583373	593237	2	000000000	2026-07-01 19:29:38
8885	1110583373	593238	2	000000000	2026-07-01 19:29:38
8886	1110583373	593109	2	000000000	2026-07-01 19:29:38
8887	1110583373	593110	2	000000000	2026-07-01 19:29:38
8888	1110583373	593111	2	000000000	2026-07-01 19:29:38
8889	1110583373	593112	2	000000000	2026-07-01 19:29:38
8890	1110583373	593100	2	000000000	2026-07-01 19:29:38
8891	1110583373	593101	2	000000000	2026-07-01 19:29:38
8892	1110583373	593102	2	000000000	2026-07-01 19:29:38
8893	1110583373	593103	2	000000000	2026-07-01 19:29:38
8894	1110583373	593060	2	000000000	2026-07-01 19:29:38
8895	1110583373	593061	2	000000000	2026-07-01 19:29:38
8896	1110583373	593062	2	000000000	2026-07-01 19:29:38
8897	1110583373	593104	2	000000000	2026-07-01 19:29:38
8898	1110583373	593105	2	000000000	2026-07-01 19:29:38
8899	1110583373	593106	2	000000000	2026-07-01 19:29:38
8900	1110583373	593107	2	000000000	2026-07-01 19:29:38
8901	1110583373	593108	2	000000000	2026-07-01 19:29:38
8902	1110583373	593144	2	000000000	2026-07-01 19:29:38
8903	1110583373	593145	2	000000000	2026-07-01 19:29:38
8904	1110583373	593146	2	000000000	2026-07-01 19:29:38
8905	1110583373	592373	2	000000000	2026-07-01 19:29:38
8906	1110583373	592374	2	000000000	2026-07-01 19:29:38
8907	1110583373	592375	2	000000000	2026-07-01 19:29:38
8908	1110583373	592376	2	000000000	2026-07-01 19:29:39
8909	1110583373	593344	2	000000000	2026-07-01 19:29:39
8910	1110583373	593345	2	000000000	2026-07-01 19:29:39
8911	1110583373	593346	2	000000000	2026-07-01 19:29:39
8912	1110583373	593347	2	000000000	2026-07-01 19:29:39
8913	1110583373	593243	2	000000000	2026-07-01 19:29:39
8914	1110583373	593244	2	000000000	2026-07-01 19:29:39
8915	1110583373	593245	2	000000000	2026-07-01 19:29:39
8916	1110583373	593246	2	000000000	2026-07-01 19:29:39
8917	1110583373	593255	2	000000000	2026-07-01 19:29:39
8918	1110583373	593256	2	000000000	2026-07-01 19:29:39
8919	1110583373	593257	2	000000000	2026-07-01 19:29:39
8920	1110583373	593258	2	000000000	2026-07-01 19:29:39
8921	1110583373	593259	2	000000000	2026-07-01 19:29:39
8922	1110583373	593340	2	000000000	2026-07-01 19:29:39
8923	1110583373	593341	2	000000000	2026-07-01 19:29:39
8924	1110583373	593342	2	000000000	2026-07-01 19:29:39
8925	1115944629	590803	2	000000000	2026-07-01 19:29:39
8926	1115944629	593147	2	000000000	2026-07-01 19:29:39
8927	1115944629	593148	2	000000000	2026-07-01 19:29:39
8928	1115944629	593149	2	000000000	2026-07-01 19:29:39
8929	1115944629	593150	2	000000000	2026-07-01 19:29:39
8930	1115944629	593343	1	6801355	2024-08-16 16:08:00
8931	1115944629	593151	2	000000000	2026-07-01 19:29:39
8932	1115944629	593152	2	000000000	2026-07-01 19:29:39
8933	1115944629	593153	2	000000000	2026-07-01 19:29:39
8934	1115944629	593154	2	000000000	2026-07-01 19:29:39
8935	1115944629	593113	2	17656565	2024-12-12 16:12:00
8936	1115944629	593114	2	17656565	2024-12-12 16:12:00
8937	1115944629	593115	1	1098809645	2024-11-29 20:11:00
8938	1115944629	593116	2	17656565	2024-12-12 16:12:00
8939	1115944629	593117	1	1098809645	2024-11-29 20:11:00
8940	1115944629	593118	2	17656565	2024-12-12 16:12:00
8941	1115944629	593155	2	000000000	2026-07-01 19:29:39
8942	1115944629	593156	2	000000000	2026-07-01 19:29:39
8943	1115944629	593157	2	000000000	2026-07-01 19:29:39
8944	1115944629	593158	2	000000000	2026-07-01 19:29:39
8945	1115944629	593119	2	000000000	2026-07-01 19:29:39
8946	1115944629	593120	2	000000000	2026-07-01 19:29:39
8947	1115944629	593121	2	000000000	2026-07-01 19:29:39
8948	1115944629	593122	2	000000000	2026-07-01 19:29:39
8949	1115944629	593159	2	000000000	2026-07-01 19:29:39
8950	1115944629	593160	2	000000000	2026-07-01 19:29:39
8951	1115944629	593161	2	000000000	2026-07-01 19:29:39
8952	1115944629	593162	2	000000000	2026-07-01 19:29:39
8953	1115944629	593224	2	000000000	2026-07-01 19:29:39
8954	1115944629	593225	2	000000000	2026-07-01 19:29:39
8955	1115944629	593226	2	000000000	2026-07-01 19:29:39
8956	1115944629	593227	2	000000000	2026-07-01 19:29:39
8957	1115944629	593235	2	000000000	2026-07-01 19:29:39
8958	1115944629	593236	2	000000000	2026-07-01 19:29:39
8959	1115944629	593237	2	000000000	2026-07-01 19:29:39
8960	1115944629	593238	2	000000000	2026-07-01 19:29:39
8961	1115944629	593109	2	000000000	2026-07-01 19:29:39
8962	1115944629	593110	2	000000000	2026-07-01 19:29:39
8963	1115944629	593111	2	000000000	2026-07-01 19:29:39
8964	1115944629	593112	2	000000000	2026-07-01 19:29:39
8965	1115944629	593100	2	000000000	2026-07-01 19:29:39
8966	1115944629	593101	2	000000000	2026-07-01 19:29:39
8967	1115944629	593102	2	000000000	2026-07-01 19:29:39
8968	1115944629	593103	1	96353963	2024-12-05 06:12:00
8969	1115944629	593060	2	000000000	2026-07-01 19:29:39
8970	1115944629	593061	2	000000000	2026-07-01 19:29:39
8971	1115944629	593062	2	000000000	2026-07-01 19:29:39
8972	1115944629	593104	2	000000000	2026-07-01 19:29:39
8973	1115944629	593105	2	000000000	2026-07-01 19:29:39
8974	1115944629	593106	2	000000000	2026-07-01 19:29:39
8975	1115944629	593107	2	000000000	2026-07-01 19:29:39
8976	1115944629	593108	2	000000000	2026-07-01 19:29:39
8977	1115944629	593144	2	000000000	2026-07-01 19:29:39
8978	1115944629	593145	2	000000000	2026-07-01 19:29:39
8979	1115944629	593146	2	000000000	2026-07-01 19:29:39
8980	1115944629	592373	1	6801355	2024-11-29 19:11:00
8981	1115944629	592374	2	000000000	2026-07-01 19:29:39
8982	1115944629	592375	1	6801355	2024-11-29 19:11:00
8983	1115944629	592376	1	6801355	2024-11-29 19:11:00
8984	1115944629	593344	1	6801355	2024-11-29 19:11:00
8985	1115944629	593345	1	6801355	2024-11-29 19:11:00
8986	1115944629	593346	1	6801355	2024-11-29 19:11:00
8987	1115944629	593347	1	6801355	2024-11-29 19:11:00
8988	1115944629	593243	2	000000000	2026-07-01 19:29:39
8989	1115944629	593244	2	000000000	2026-07-01 19:29:39
8990	1115944629	593245	2	000000000	2026-07-01 19:29:39
8991	1115944629	593246	2	000000000	2026-07-01 19:29:39
8992	1115944629	593255	1	40781077	2024-12-03 18:12:00
8993	1115944629	593256	1	40781077	2024-12-03 18:12:00
8994	1115944629	593257	1	40781077	2024-12-03 18:12:00
8995	1115944629	593258	1	40781077	2024-12-03 18:12:00
8996	1115944629	593259	2	000000000	2026-07-01 19:29:39
8997	1115944629	593340	2	000000000	2026-07-01 19:29:40
8998	1115944629	593341	2	000000000	2026-07-01 19:29:40
8999	1115944629	593342	2	000000000	2026-07-01 19:29:40
9000	1116914600	590803	2	000000000	2026-07-01 19:29:40
9001	1116914600	593147	2	000000000	2026-07-01 19:29:40
9002	1116914600	593148	2	000000000	2026-07-01 19:29:40
9003	1116914600	593149	2	000000000	2026-07-01 19:29:40
9004	1116914600	593150	2	000000000	2026-07-01 19:29:40
9005	1116914600	593343	1	6801355	2024-08-16 16:08:00
9006	1116914600	593151	1	1117507159	2025-03-25 07:03:00
9007	1116914600	593152	1	1117507159	2025-04-07 23:04:00
9008	1116914600	593153	1	1117507159	2025-03-25 07:03:00
9009	1116914600	593154	1	1117507159	2025-03-25 07:03:00
9010	1116914600	593113	2	17656565	2024-12-12 16:12:00
9011	1116914600	593114	2	17656565	2024-12-12 16:12:00
9012	1116914600	593115	1	1098809645	2024-11-29 20:11:00
9013	1116914600	593116	2	17656565	2024-12-12 16:12:00
9014	1116914600	593117	1	1098809645	2024-11-29 20:11:00
9015	1116914600	593118	2	17656565	2024-12-12 16:12:00
9016	1116914600	593155	2	000000000	2026-07-01 19:29:40
9017	1116914600	593156	2	000000000	2026-07-01 19:29:40
9018	1116914600	593157	2	000000000	2026-07-01 19:29:40
9019	1116914600	593158	2	000000000	2026-07-01 19:29:40
9020	1116914600	593119	2	000000000	2026-07-01 19:29:40
9021	1116914600	593120	2	000000000	2026-07-01 19:29:40
9022	1116914600	593121	2	000000000	2026-07-01 19:29:40
9023	1116914600	593122	2	000000000	2026-07-01 19:29:40
9024	1116914600	593159	2	000000000	2026-07-01 19:29:40
9025	1116914600	593160	2	000000000	2026-07-01 19:29:40
9026	1116914600	593161	2	000000000	2026-07-01 19:29:40
9027	1116914600	593162	2	000000000	2026-07-01 19:29:40
9028	1116914600	593224	2	000000000	2026-07-01 19:29:40
9029	1116914600	593225	2	000000000	2026-07-01 19:29:40
9030	1116914600	593226	2	000000000	2026-07-01 19:29:40
9031	1116914600	593227	2	000000000	2026-07-01 19:29:40
9032	1116914600	593235	2	000000000	2026-07-01 19:29:40
9033	1116914600	593236	2	000000000	2026-07-01 19:29:40
9034	1116914600	593237	2	000000000	2026-07-01 19:29:40
9035	1116914600	593238	2	000000000	2026-07-01 19:29:40
9036	1116914600	593109	2	000000000	2026-07-01 19:29:40
9037	1116914600	593110	2	000000000	2026-07-01 19:29:40
9038	1116914600	593111	2	000000000	2026-07-01 19:29:40
9039	1116914600	593112	2	000000000	2026-07-01 19:29:40
9040	1116914600	593100	2	000000000	2026-07-01 19:29:40
9041	1116914600	593101	2	000000000	2026-07-01 19:29:40
9042	1116914600	593102	2	000000000	2026-07-01 19:29:40
9043	1116914600	593103	1	96353963	2024-12-05 06:12:00
9044	1116914600	593060	2	000000000	2026-07-01 19:29:40
9045	1116914600	593061	2	000000000	2026-07-01 19:29:40
9046	1116914600	593062	2	000000000	2026-07-01 19:29:40
9047	1116914600	593104	2	000000000	2026-07-01 19:29:40
9048	1116914600	593105	2	000000000	2026-07-01 19:29:40
9049	1116914600	593106	2	000000000	2026-07-01 19:29:40
9050	1116914600	593107	2	000000000	2026-07-01 19:29:40
9051	1116914600	593108	2	000000000	2026-07-01 19:29:40
9052	1116914600	593144	2	000000000	2026-07-01 19:29:40
9053	1116914600	593145	2	000000000	2026-07-01 19:29:40
9054	1116914600	593146	2	000000000	2026-07-01 19:29:40
9055	1116914600	592373	1	6801355	2024-11-29 19:11:00
9056	1116914600	592374	2	000000000	2026-07-01 19:29:40
9057	1116914600	592375	1	6801355	2024-11-29 19:11:00
9058	1116914600	592376	1	6801355	2024-11-29 19:11:00
9059	1116914600	593344	1	6801355	2024-11-29 19:11:00
9060	1116914600	593345	1	6801355	2024-11-29 19:11:00
9061	1116914600	593346	1	6801355	2024-11-29 19:11:00
9062	1116914600	593347	1	6801355	2024-11-29 19:11:00
9063	1116914600	593243	2	000000000	2026-07-01 19:29:40
9064	1116914600	593244	2	000000000	2026-07-01 19:29:40
9065	1116914600	593245	2	000000000	2026-07-01 19:29:40
9066	1116914600	593246	2	000000000	2026-07-01 19:29:40
9067	1116914600	593255	1	40781077	2024-12-03 18:12:00
9068	1116914600	593256	1	40781077	2024-12-03 18:12:00
9069	1116914600	593257	1	40781077	2024-12-03 18:12:00
9070	1116914600	593258	1	40781077	2024-12-03 18:12:00
9071	1116914600	593259	2	000000000	2026-07-01 19:29:40
9072	1116914600	593340	2	000000000	2026-07-01 19:29:40
9073	1116914600	593341	2	000000000	2026-07-01 19:29:40
9074	1116914600	593342	2	000000000	2026-07-01 19:29:40
9075	1117263160	590803	2	000000000	2026-07-01 19:29:40
9076	1117263160	593147	2	000000000	2026-07-01 19:29:40
9077	1117263160	593148	2	000000000	2026-07-01 19:29:40
9078	1117263160	593149	2	000000000	2026-07-01 19:29:40
9079	1117263160	593150	2	000000000	2026-07-01 19:29:40
9080	1117263160	593343	1	6801355	2024-08-16 16:08:00
9081	1117263160	593151	1	1117507159	2025-03-25 07:03:00
9082	1117263160	593152	1	1117507159	2025-04-07 23:04:00
9083	1117263160	593153	1	1117507159	2025-03-25 07:03:00
9084	1117263160	593154	1	1117507159	2025-03-25 07:03:00
9085	1117263160	593113	2	17656565	2024-12-12 16:12:00
9086	1117263160	593114	2	17656565	2024-12-12 16:12:00
9087	1117263160	593115	1	1098809645	2024-11-19 17:11:00
9088	1117263160	593116	2	17656565	2024-12-12 16:12:00
9089	1117263160	593117	1	1098809645	2024-11-29 20:11:00
9090	1117263160	593118	2	17656565	2024-12-12 16:12:00
9091	1117263160	593155	2	000000000	2026-07-01 19:29:41
9092	1117263160	593156	2	000000000	2026-07-01 19:29:41
9093	1117263160	593157	2	000000000	2026-07-01 19:29:41
9094	1117263160	593158	2	000000000	2026-07-01 19:29:41
9095	1117263160	593119	2	000000000	2026-07-01 19:29:41
9096	1117263160	593120	2	000000000	2026-07-01 19:29:41
9097	1117263160	593121	2	000000000	2026-07-01 19:29:41
9098	1117263160	593122	2	000000000	2026-07-01 19:29:41
9099	1117263160	593159	2	000000000	2026-07-01 19:29:41
9100	1117263160	593160	2	000000000	2026-07-01 19:29:41
9101	1117263160	593161	2	000000000	2026-07-01 19:29:41
9102	1117263160	593162	2	000000000	2026-07-01 19:29:41
9103	1117263160	593224	2	000000000	2026-07-01 19:29:41
9104	1117263160	593225	2	000000000	2026-07-01 19:29:41
9105	1117263160	593226	2	000000000	2026-07-01 19:29:41
9106	1117263160	593227	2	000000000	2026-07-01 19:29:41
9107	1117263160	593235	2	000000000	2026-07-01 19:29:41
9108	1117263160	593236	2	000000000	2026-07-01 19:29:41
9109	1117263160	593237	2	000000000	2026-07-01 19:29:41
9110	1117263160	593238	2	000000000	2026-07-01 19:29:41
9111	1117263160	593109	2	000000000	2026-07-01 19:29:41
9112	1117263160	593110	2	000000000	2026-07-01 19:29:41
9113	1117263160	593111	2	000000000	2026-07-01 19:29:41
9114	1117263160	593112	2	000000000	2026-07-01 19:29:41
9115	1117263160	593100	2	000000000	2026-07-01 19:29:41
9116	1117263160	593101	2	000000000	2026-07-01 19:29:41
9117	1117263160	593102	2	000000000	2026-07-01 19:29:41
9118	1117263160	593103	1	96353963	2024-12-05 06:12:00
9119	1117263160	593060	2	000000000	2026-07-01 19:29:41
9120	1117263160	593061	2	000000000	2026-07-01 19:29:41
9121	1117263160	593062	2	000000000	2026-07-01 19:29:41
9122	1117263160	593104	2	000000000	2026-07-01 19:29:41
9123	1117263160	593105	2	000000000	2026-07-01 19:29:41
9124	1117263160	593106	2	000000000	2026-07-01 19:29:41
9125	1117263160	593107	2	000000000	2026-07-01 19:29:41
9126	1117263160	593108	2	000000000	2026-07-01 19:29:41
9127	1117263160	593144	2	000000000	2026-07-01 19:29:41
9128	1117263160	593145	2	000000000	2026-07-01 19:29:41
9129	1117263160	593146	2	000000000	2026-07-01 19:29:41
9130	1117263160	592373	1	6801355	2024-11-29 19:11:00
9131	1117263160	592374	2	000000000	2026-07-01 19:29:41
9132	1117263160	592375	1	6801355	2024-11-29 19:11:00
9133	1117263160	592376	1	6801355	2024-11-29 19:11:00
9134	1117263160	593344	1	6801355	2024-11-29 19:11:00
9135	1117263160	593345	1	6801355	2024-11-29 19:11:00
9136	1117263160	593346	1	6801355	2024-11-29 19:11:00
9137	1117263160	593347	1	6801355	2024-11-29 19:11:00
9138	1117263160	593243	2	000000000	2026-07-01 19:29:41
9139	1117263160	593244	2	000000000	2026-07-01 19:29:41
9140	1117263160	593245	2	000000000	2026-07-01 19:29:41
9141	1117263160	593246	2	000000000	2026-07-01 19:29:41
9142	1117263160	593255	1	40781077	2024-12-03 18:12:00
9143	1117263160	593256	1	40781077	2024-12-03 18:12:00
9144	1117263160	593257	1	40781077	2024-12-03 18:12:00
9145	1117263160	593258	1	40781077	2024-12-03 18:12:00
9146	1117263160	593259	2	000000000	2026-07-01 19:29:41
9147	1117263160	593340	2	000000000	2026-07-01 19:29:41
9148	1117263160	593341	2	000000000	2026-07-01 19:29:41
9149	1117263160	593342	2	000000000	2026-07-01 19:29:41
9150	1117263444	590803	2	000000000	2026-07-01 19:29:41
9151	1117263444	593147	2	000000000	2026-07-01 19:29:41
9152	1117263444	593148	2	000000000	2026-07-01 19:29:41
9153	1117263444	593149	2	000000000	2026-07-01 19:29:41
9154	1117263444	593150	2	000000000	2026-07-01 19:29:41
9155	1117263444	593343	1	6801355	2024-08-16 16:08:00
9156	1117263444	593151	1	1117507159	2025-03-25 07:03:00
9157	1117263444	593152	1	1117507159	2025-04-07 23:04:00
9158	1117263444	593153	1	1117507159	2025-03-25 07:03:00
9159	1117263444	593154	1	1117507159	2025-03-25 07:03:00
9160	1117263444	593113	2	17656565	2024-12-12 16:12:00
9161	1117263444	593114	2	17656565	2024-12-12 16:12:00
9162	1117263444	593115	1	1098809645	2024-11-19 17:11:00
9163	1117263444	593116	2	17656565	2024-12-12 16:12:00
9164	1117263444	593117	1	1098809645	2024-11-29 20:11:00
9165	1117263444	593118	2	17656565	2024-12-12 16:12:00
9166	1117263444	593155	2	000000000	2026-07-01 19:29:41
9167	1117263444	593156	2	000000000	2026-07-01 19:29:41
9168	1117263444	593157	2	000000000	2026-07-01 19:29:41
9169	1117263444	593158	2	000000000	2026-07-01 19:29:41
9170	1117263444	593119	2	000000000	2026-07-01 19:29:41
9171	1117263444	593120	2	000000000	2026-07-01 19:29:41
9172	1117263444	593121	2	000000000	2026-07-01 19:29:41
9173	1117263444	593122	2	000000000	2026-07-01 19:29:41
9174	1117263444	593159	2	000000000	2026-07-01 19:29:41
9175	1117263444	593160	2	000000000	2026-07-01 19:29:41
9176	1117263444	593161	2	000000000	2026-07-01 19:29:41
9177	1117263444	593162	2	000000000	2026-07-01 19:29:41
9178	1117263444	593224	2	000000000	2026-07-01 19:29:42
9179	1117263444	593225	2	000000000	2026-07-01 19:29:42
9180	1117263444	593226	2	000000000	2026-07-01 19:29:42
9181	1117263444	593227	2	000000000	2026-07-01 19:29:42
9182	1117263444	593235	2	000000000	2026-07-01 19:29:42
9183	1117263444	593236	2	000000000	2026-07-01 19:29:42
9184	1117263444	593237	2	000000000	2026-07-01 19:29:42
9185	1117263444	593238	2	000000000	2026-07-01 19:29:42
9186	1117263444	593109	2	000000000	2026-07-01 19:29:42
9187	1117263444	593110	2	000000000	2026-07-01 19:29:42
9188	1117263444	593111	2	000000000	2026-07-01 19:29:42
9189	1117263444	593112	2	000000000	2026-07-01 19:29:42
9190	1117263444	593100	2	000000000	2026-07-01 19:29:42
9191	1117263444	593101	2	000000000	2026-07-01 19:29:42
9192	1117263444	593102	2	000000000	2026-07-01 19:29:42
9193	1117263444	593103	1	96353963	2024-12-05 06:12:00
9194	1117263444	593060	2	000000000	2026-07-01 19:29:42
9195	1117263444	593061	2	000000000	2026-07-01 19:29:42
9196	1117263444	593062	2	000000000	2026-07-01 19:29:42
9197	1117263444	593104	2	000000000	2026-07-01 19:29:42
9198	1117263444	593105	2	000000000	2026-07-01 19:29:42
9199	1117263444	593106	2	000000000	2026-07-01 19:29:42
9200	1117263444	593107	2	000000000	2026-07-01 19:29:42
9201	1117263444	593108	2	000000000	2026-07-01 19:29:42
9202	1117263444	593144	2	000000000	2026-07-01 19:29:42
9203	1117263444	593145	2	000000000	2026-07-01 19:29:42
9204	1117263444	593146	2	000000000	2026-07-01 19:29:42
9205	1117263444	592373	1	6801355	2024-11-29 19:11:00
9206	1117263444	592374	2	000000000	2026-07-01 19:29:42
9207	1117263444	592375	1	6801355	2024-11-29 19:11:00
9208	1117263444	592376	1	6801355	2024-11-29 19:11:00
9209	1117263444	593344	1	6801355	2024-11-29 19:11:00
9210	1117263444	593345	1	6801355	2024-11-29 19:11:00
9211	1117263444	593346	1	6801355	2024-11-29 19:11:00
9212	1117263444	593347	1	6801355	2024-11-29 19:11:00
9213	1117263444	593243	2	000000000	2026-07-01 19:29:42
9214	1117263444	593244	2	000000000	2026-07-01 19:29:42
9215	1117263444	593245	2	000000000	2026-07-01 19:29:42
9216	1117263444	593246	2	000000000	2026-07-01 19:29:42
9217	1117263444	593255	1	40781077	2024-12-03 18:12:00
9218	1117263444	593256	1	40781077	2024-12-03 18:12:00
9219	1117263444	593257	1	40781077	2024-12-03 18:12:00
9220	1117263444	593258	1	40781077	2024-12-03 18:12:00
9221	1117263444	593259	2	000000000	2026-07-01 19:29:42
9222	1117263444	593340	2	000000000	2026-07-01 19:29:42
9223	1117263444	593341	2	000000000	2026-07-01 19:29:42
9224	1117263444	593342	2	000000000	2026-07-01 19:29:42
9225	1117494319	590803	2	000000000	2026-07-01 19:29:42
9226	1117494319	593147	2	000000000	2026-07-01 19:29:42
9227	1117494319	593148	2	000000000	2026-07-01 19:29:42
9228	1117494319	593149	2	000000000	2026-07-01 19:29:42
9229	1117494319	593150	2	000000000	2026-07-01 19:29:42
9230	1117494319	593343	1	6801355	2024-08-16 16:08:00
9231	1117494319	593151	2	000000000	2026-07-01 19:29:42
9232	1117494319	593152	2	000000000	2026-07-01 19:29:42
9233	1117494319	593153	2	000000000	2026-07-01 19:29:42
9234	1117494319	593154	2	000000000	2026-07-01 19:29:42
9235	1117494319	593113	2	000000000	2026-07-01 19:29:42
9236	1117494319	593114	2	000000000	2026-07-01 19:29:42
9237	1117494319	593115	2	000000000	2026-07-01 19:29:42
9238	1117494319	593116	2	000000000	2026-07-01 19:29:42
9239	1117494319	593117	2	000000000	2026-07-01 19:29:42
9240	1117494319	593118	2	000000000	2026-07-01 19:29:42
9241	1117494319	593155	2	000000000	2026-07-01 19:29:42
9242	1117494319	593156	2	000000000	2026-07-01 19:29:42
9243	1117494319	593157	2	000000000	2026-07-01 19:29:42
9244	1117494319	593158	2	000000000	2026-07-01 19:29:42
9245	1117494319	593119	2	000000000	2026-07-01 19:29:42
9246	1117494319	593120	2	000000000	2026-07-01 19:29:42
9247	1117494319	593121	2	000000000	2026-07-01 19:29:42
9248	1117494319	593122	2	000000000	2026-07-01 19:29:42
9249	1117494319	593159	2	000000000	2026-07-01 19:29:42
9250	1117494319	593160	2	000000000	2026-07-01 19:29:42
9251	1117494319	593161	2	000000000	2026-07-01 19:29:42
9252	1117494319	593162	2	000000000	2026-07-01 19:29:42
9253	1117494319	593224	2	000000000	2026-07-01 19:29:42
9254	1117494319	593225	2	000000000	2026-07-01 19:29:42
9255	1117494319	593226	2	000000000	2026-07-01 19:29:42
9256	1117494319	593227	2	000000000	2026-07-01 19:29:42
9257	1117494319	593235	2	000000000	2026-07-01 19:29:42
9258	1117494319	593236	2	000000000	2026-07-01 19:29:42
9259	1117494319	593237	2	000000000	2026-07-01 19:29:42
9260	1117494319	593238	2	000000000	2026-07-01 19:29:42
9261	1117494319	593109	2	000000000	2026-07-01 19:29:42
9262	1117494319	593110	2	000000000	2026-07-01 19:29:42
9263	1117494319	593111	2	000000000	2026-07-01 19:29:42
9264	1117494319	593112	2	000000000	2026-07-01 19:29:42
9265	1117494319	593100	2	000000000	2026-07-01 19:29:42
9266	1117494319	593101	2	000000000	2026-07-01 19:29:42
9267	1117494319	593102	2	000000000	2026-07-01 19:29:42
9268	1117494319	593103	2	000000000	2026-07-01 19:29:42
9269	1117494319	593060	2	000000000	2026-07-01 19:29:42
9270	1117494319	593061	2	000000000	2026-07-01 19:29:42
9271	1117494319	593062	2	000000000	2026-07-01 19:29:42
9272	1117494319	593104	2	000000000	2026-07-01 19:29:42
9273	1117494319	593105	2	000000000	2026-07-01 19:29:43
9274	1117494319	593106	2	000000000	2026-07-01 19:29:43
9275	1117494319	593107	2	000000000	2026-07-01 19:29:43
9276	1117494319	593108	2	000000000	2026-07-01 19:29:43
9277	1117494319	593144	2	000000000	2026-07-01 19:29:43
9278	1117494319	593145	2	000000000	2026-07-01 19:29:43
9279	1117494319	593146	2	000000000	2026-07-01 19:29:43
9280	1117494319	592373	2	000000000	2026-07-01 19:29:43
9281	1117494319	592374	2	000000000	2026-07-01 19:29:43
9282	1117494319	592375	2	000000000	2026-07-01 19:29:43
9283	1117494319	592376	2	000000000	2026-07-01 19:29:43
9284	1117494319	593344	2	000000000	2026-07-01 19:29:43
9285	1117494319	593345	2	000000000	2026-07-01 19:29:43
9286	1117494319	593346	2	000000000	2026-07-01 19:29:43
9287	1117494319	593347	2	000000000	2026-07-01 19:29:43
9288	1117494319	593243	2	000000000	2026-07-01 19:29:43
9289	1117494319	593244	2	000000000	2026-07-01 19:29:43
9290	1117494319	593245	2	000000000	2026-07-01 19:29:43
9291	1117494319	593246	2	000000000	2026-07-01 19:29:43
9292	1117494319	593255	2	000000000	2026-07-01 19:29:43
9293	1117494319	593256	2	000000000	2026-07-01 19:29:43
9294	1117494319	593257	2	000000000	2026-07-01 19:29:43
9295	1117494319	593258	2	000000000	2026-07-01 19:29:43
9296	1117494319	593259	2	000000000	2026-07-01 19:29:43
9297	1117494319	593340	2	000000000	2026-07-01 19:29:43
9298	1117494319	593341	2	000000000	2026-07-01 19:29:43
9299	1117494319	593342	2	000000000	2026-07-01 19:29:43
9300	1117498592	590803	2	000000000	2026-07-01 19:29:43
9301	1117498592	593147	2	000000000	2026-07-01 19:29:43
9302	1117498592	593148	2	000000000	2026-07-01 19:29:43
9303	1117498592	593149	2	000000000	2026-07-01 19:29:43
9304	1117498592	593150	2	000000000	2026-07-01 19:29:43
9305	1117498592	593343	1	6801355	2024-08-16 16:08:00
9306	1117498592	593151	2	000000000	2026-07-01 19:29:43
9307	1117498592	593152	2	000000000	2026-07-01 19:29:43
9308	1117498592	593153	2	000000000	2026-07-01 19:29:43
9309	1117498592	593154	2	000000000	2026-07-01 19:29:43
9310	1117498592	593113	2	17656565	2024-12-12 16:12:00
9311	1117498592	593114	2	17656565	2024-12-12 16:12:00
9312	1117498592	593115	1	1098809645	2024-11-19 17:11:00
9313	1117498592	593116	2	17656565	2024-12-12 16:12:00
9314	1117498592	593117	1	1098809645	2024-11-29 20:11:00
9315	1117498592	593118	2	17656565	2024-12-12 16:12:00
9316	1117498592	593155	2	000000000	2026-07-01 19:29:43
9317	1117498592	593156	2	000000000	2026-07-01 19:29:43
9318	1117498592	593157	2	000000000	2026-07-01 19:29:43
9319	1117498592	593158	2	000000000	2026-07-01 19:29:43
9320	1117498592	593119	2	000000000	2026-07-01 19:29:43
9321	1117498592	593120	2	000000000	2026-07-01 19:29:43
9322	1117498592	593121	2	000000000	2026-07-01 19:29:43
9323	1117498592	593122	2	000000000	2026-07-01 19:29:43
9324	1117498592	593159	2	000000000	2026-07-01 19:29:43
9325	1117498592	593160	2	000000000	2026-07-01 19:29:43
9326	1117498592	593161	2	000000000	2026-07-01 19:29:43
9327	1117498592	593162	2	000000000	2026-07-01 19:29:43
9328	1117498592	593224	2	000000000	2026-07-01 19:29:43
9329	1117498592	593225	2	000000000	2026-07-01 19:29:43
9330	1117498592	593226	2	000000000	2026-07-01 19:29:43
9331	1117498592	593227	2	000000000	2026-07-01 19:29:43
9332	1117498592	593235	2	000000000	2026-07-01 19:29:43
9333	1117498592	593236	2	000000000	2026-07-01 19:29:43
9334	1117498592	593237	2	000000000	2026-07-01 19:29:43
9335	1117498592	593238	2	000000000	2026-07-01 19:29:43
9336	1117498592	593109	2	000000000	2026-07-01 19:29:43
9337	1117498592	593110	2	000000000	2026-07-01 19:29:43
9338	1117498592	593111	2	000000000	2026-07-01 19:29:43
9339	1117498592	593112	2	000000000	2026-07-01 19:29:43
9340	1117498592	593100	2	000000000	2026-07-01 19:29:43
9341	1117498592	593101	2	000000000	2026-07-01 19:29:43
9342	1117498592	593102	2	000000000	2026-07-01 19:29:43
9343	1117498592	593103	1	96353963	2024-12-05 06:12:00
9344	1117498592	593060	2	000000000	2026-07-01 19:29:43
9345	1117498592	593061	2	000000000	2026-07-01 19:29:43
9346	1117498592	593062	2	000000000	2026-07-01 19:29:43
9347	1117498592	593104	2	000000000	2026-07-01 19:29:43
9348	1117498592	593105	2	000000000	2026-07-01 19:29:43
9349	1117498592	593106	2	000000000	2026-07-01 19:29:43
9350	1117498592	593107	2	000000000	2026-07-01 19:29:43
9351	1117498592	593108	2	000000000	2026-07-01 19:29:43
9352	1117498592	593144	2	000000000	2026-07-01 19:29:43
9353	1117498592	593145	2	000000000	2026-07-01 19:29:43
9354	1117498592	593146	2	000000000	2026-07-01 19:29:43
9355	1117498592	592373	1	6801355	2024-11-29 19:11:00
9356	1117498592	592374	2	000000000	2026-07-01 19:29:44
9357	1117498592	592375	1	6801355	2024-11-29 19:11:00
9358	1117498592	592376	1	6801355	2024-11-29 19:11:00
9359	1117498592	593344	1	6801355	2024-11-29 19:11:00
9360	1117498592	593345	1	6801355	2024-11-29 19:11:00
9361	1117498592	593346	1	6801355	2024-11-29 19:11:00
9362	1117498592	593347	1	6801355	2024-11-29 19:11:00
9363	1117498592	593243	2	000000000	2026-07-01 19:29:44
9364	1117498592	593244	2	000000000	2026-07-01 19:29:44
9365	1117498592	593245	2	000000000	2026-07-01 19:29:44
9366	1117498592	593246	2	000000000	2026-07-01 19:29:44
9367	1117498592	593255	1	40781077	2024-12-03 18:12:00
9368	1117498592	593256	1	40781077	2024-12-03 18:12:00
9369	1117498592	593257	1	40781077	2024-12-03 18:12:00
9370	1117498592	593258	1	40781077	2024-12-03 18:12:00
9371	1117498592	593259	2	000000000	2026-07-01 19:29:44
9372	1117498592	593340	2	000000000	2026-07-01 19:29:44
9373	1117498592	593341	2	000000000	2026-07-01 19:29:44
9374	1117498592	593342	2	000000000	2026-07-01 19:29:44
9375	1117499559	590803	2	000000000	2026-07-01 19:29:44
9376	1117499559	593147	2	000000000	2026-07-01 19:29:44
9377	1117499559	593148	2	000000000	2026-07-01 19:29:44
9378	1117499559	593149	2	000000000	2026-07-01 19:29:44
9379	1117499559	593150	2	000000000	2026-07-01 19:29:44
9380	1117499559	593343	1	6801355	2024-08-16 16:08:00
9381	1117499559	593151	1	1117507159	2025-03-25 07:03:00
9382	1117499559	593152	1	1117507159	2025-04-07 23:04:00
9383	1117499559	593153	1	1117507159	2025-03-25 07:03:00
9384	1117499559	593154	1	1117507159	2025-03-25 07:03:00
9385	1117499559	593113	2	17656565	2024-12-12 16:12:00
9386	1117499559	593114	2	17656565	2024-12-12 16:12:00
9387	1117499559	593115	1	1098809645	2024-11-29 20:11:00
9388	1117499559	593116	2	17656565	2024-12-12 16:12:00
9389	1117499559	593117	1	1098809645	2024-11-29 20:11:00
9390	1117499559	593118	2	17656565	2024-12-12 16:12:00
9391	1117499559	593155	2	000000000	2026-07-01 19:29:44
9392	1117499559	593156	2	000000000	2026-07-01 19:29:44
9393	1117499559	593157	2	000000000	2026-07-01 19:29:44
9394	1117499559	593158	2	000000000	2026-07-01 19:29:44
9395	1117499559	593119	2	000000000	2026-07-01 19:29:44
9396	1117499559	593120	2	000000000	2026-07-01 19:29:44
9397	1117499559	593121	2	000000000	2026-07-01 19:29:44
9398	1117499559	593122	2	000000000	2026-07-01 19:29:44
9399	1117499559	593159	2	000000000	2026-07-01 19:29:44
9400	1117499559	593160	2	000000000	2026-07-01 19:29:44
9401	1117499559	593161	2	000000000	2026-07-01 19:29:44
9402	1117499559	593162	2	000000000	2026-07-01 19:29:44
9403	1117499559	593224	2	000000000	2026-07-01 19:29:44
9404	1117499559	593225	2	000000000	2026-07-01 19:29:44
9405	1117499559	593226	2	000000000	2026-07-01 19:29:44
9406	1117499559	593227	2	000000000	2026-07-01 19:29:44
9407	1117499559	593235	2	000000000	2026-07-01 19:29:44
9408	1117499559	593236	2	000000000	2026-07-01 19:29:44
9409	1117499559	593237	2	000000000	2026-07-01 19:29:44
9410	1117499559	593238	2	000000000	2026-07-01 19:29:44
9411	1117499559	593109	2	000000000	2026-07-01 19:29:44
9412	1117499559	593110	2	000000000	2026-07-01 19:29:44
9413	1117499559	593111	2	000000000	2026-07-01 19:29:44
9414	1117499559	593112	2	000000000	2026-07-01 19:29:44
9415	1117499559	593100	2	000000000	2026-07-01 19:29:44
9416	1117499559	593101	2	000000000	2026-07-01 19:29:44
9417	1117499559	593102	2	000000000	2026-07-01 19:29:44
9418	1117499559	593103	1	96353963	2024-12-05 06:12:00
9419	1117499559	593060	2	000000000	2026-07-01 19:29:44
9420	1117499559	593061	2	000000000	2026-07-01 19:29:44
9421	1117499559	593062	2	000000000	2026-07-01 19:29:44
9422	1117499559	593104	2	000000000	2026-07-01 19:29:44
9423	1117499559	593105	2	000000000	2026-07-01 19:29:44
9424	1117499559	593106	2	000000000	2026-07-01 19:29:44
9425	1117499559	593107	2	000000000	2026-07-01 19:29:44
9426	1117499559	593108	2	000000000	2026-07-01 19:29:44
9427	1117499559	593144	2	000000000	2026-07-01 19:29:44
9428	1117499559	593145	2	000000000	2026-07-01 19:29:44
9429	1117499559	593146	2	000000000	2026-07-01 19:29:44
9430	1117499559	592373	1	6801355	2024-11-29 19:11:00
9431	1117499559	592374	2	000000000	2026-07-01 19:29:44
9438	1117499559	593243	2	000000000	2026-07-01 19:29:45
9439	1117499559	593244	2	000000000	2026-07-01 19:29:45
9440	1117499559	593245	2	000000000	2026-07-01 19:29:45
9441	1117499559	593246	2	000000000	2026-07-01 19:29:45
9442	1117499559	593255	1	40781077	2024-12-03 18:12:00
9443	1117499559	593256	1	40781077	2024-12-03 18:12:00
9444	1117499559	593257	1	40781077	2024-12-03 18:12:00
9445	1117499559	593258	1	40781077	2024-12-03 18:12:00
9446	1117499559	593259	2	000000000	2026-07-01 19:29:45
9447	1117499559	593340	2	000000000	2026-07-01 19:29:45
9448	1117499559	593341	2	000000000	2026-07-01 19:29:45
9449	1117499559	593342	2	000000000	2026-07-01 19:29:45
9450	1117500474	590803	2	000000000	2026-07-01 19:29:45
9451	1117500474	593147	2	000000000	2026-07-01 19:29:45
9452	1117500474	593148	2	000000000	2026-07-01 19:29:45
9453	1117500474	593149	2	000000000	2026-07-01 19:29:45
9454	1117500474	593150	2	000000000	2026-07-01 19:29:45
9455	1117500474	593343	1	6801355	2024-08-16 16:08:00
9456	1117500474	593151	1	1117507159	2025-03-25 07:03:00
9457	1117500474	593152	1	1117507159	2025-04-07 23:04:00
9458	1117500474	593153	1	1117507159	2025-03-25 07:03:00
9459	1117500474	593154	1	1117507159	2025-03-25 07:03:00
9460	1117500474	593113	2	17656565	2024-12-12 16:12:00
9461	1117500474	593114	2	17656565	2024-12-12 16:12:00
9462	1117500474	593115	1	1098809645	2024-11-29 20:11:00
9463	1117500474	593116	2	17656565	2024-12-12 16:12:00
9464	1117500474	593117	1	1098809645	2024-11-29 20:11:00
9465	1117500474	593118	2	17656565	2024-12-12 16:12:00
9466	1117500474	593155	2	000000000	2026-07-01 19:29:45
9467	1117500474	593156	2	000000000	2026-07-01 19:29:45
9468	1117500474	593157	2	000000000	2026-07-01 19:29:45
9469	1117500474	593158	2	000000000	2026-07-01 19:29:45
9470	1117500474	593119	2	000000000	2026-07-01 19:29:45
9471	1117500474	593120	2	000000000	2026-07-01 19:29:45
9472	1117500474	593121	2	000000000	2026-07-01 19:29:45
9473	1117500474	593122	2	000000000	2026-07-01 19:29:45
9474	1117500474	593159	2	000000000	2026-07-01 19:29:45
9475	1117500474	593160	2	000000000	2026-07-01 19:29:45
9476	1117500474	593161	2	000000000	2026-07-01 19:29:45
9477	1117500474	593162	2	000000000	2026-07-01 19:29:45
9478	1117500474	593224	2	000000000	2026-07-01 19:29:45
9479	1117500474	593225	2	000000000	2026-07-01 19:29:45
9480	1117500474	593226	2	000000000	2026-07-01 19:29:45
9481	1117500474	593227	2	000000000	2026-07-01 19:29:45
9482	1117500474	593235	2	000000000	2026-07-01 19:29:45
9483	1117500474	593236	2	000000000	2026-07-01 19:29:45
9484	1117500474	593237	2	000000000	2026-07-01 19:29:45
9485	1117500474	593238	2	000000000	2026-07-01 19:29:45
9486	1117500474	593109	2	000000000	2026-07-01 19:29:45
9487	1117500474	593110	2	000000000	2026-07-01 19:29:45
9488	1117500474	593111	2	000000000	2026-07-01 19:29:45
9489	1117500474	593112	2	000000000	2026-07-01 19:29:45
9490	1117500474	593100	2	000000000	2026-07-01 19:29:45
9491	1117500474	593101	2	000000000	2026-07-01 19:29:45
9492	1117500474	593102	2	000000000	2026-07-01 19:29:45
9493	1117500474	593103	1	96353963	2024-12-05 06:12:00
9494	1117500474	593060	2	000000000	2026-07-01 19:29:45
9495	1117500474	593061	2	000000000	2026-07-01 19:29:45
9496	1117500474	593062	2	000000000	2026-07-01 19:29:45
9497	1117500474	593104	2	000000000	2026-07-01 19:29:45
9498	1117500474	593105	2	000000000	2026-07-01 19:29:45
9499	1117500474	593106	2	000000000	2026-07-01 19:29:45
9500	1117500474	593107	2	000000000	2026-07-01 19:29:45
9501	1117500474	593108	2	000000000	2026-07-01 19:29:45
9502	1117500474	593144	2	000000000	2026-07-01 19:29:45
9503	1117500474	593145	2	000000000	2026-07-01 19:29:45
9504	1117500474	593146	2	000000000	2026-07-01 19:29:45
9505	1117500474	592373	1	6801355	2024-11-29 19:11:00
9506	1117500474	592374	2	000000000	2026-07-01 19:29:45
9507	1117500474	592375	1	6801355	2024-11-29 19:11:00
9508	1117500474	592376	1	6801355	2024-11-29 19:11:00
9509	1117500474	593344	1	6801355	2024-11-29 19:11:00
9510	1117500474	593345	1	6801355	2024-11-29 19:11:00
9511	1117500474	593346	1	6801355	2024-11-29 19:11:00
9512	1117500474	593347	1	6801355	2024-11-29 19:11:00
9513	1117500474	593243	2	000000000	2026-07-01 19:29:45
9514	1117500474	593244	2	000000000	2026-07-01 19:29:45
9515	1117500474	593245	2	000000000	2026-07-01 19:29:45
9516	1117500474	593246	2	000000000	2026-07-01 19:29:45
9517	1117500474	593255	1	40781077	2024-12-03 18:12:00
9518	1117500474	593256	1	40781077	2024-12-03 18:12:00
9519	1117500474	593257	1	40781077	2024-12-03 18:12:00
9520	1117500474	593258	1	40781077	2024-12-03 18:12:00
9521	1117500474	593259	2	000000000	2026-07-01 19:29:45
9522	1117500474	593340	2	000000000	2026-07-01 19:29:45
9523	1117500474	593341	2	000000000	2026-07-01 19:29:45
9524	1117500474	593342	2	000000000	2026-07-01 19:29:45
9525	1117500652	590803	2	000000000	2026-07-01 19:29:45
9526	1117500652	593147	2	000000000	2026-07-01 19:29:45
9527	1117500652	593148	2	000000000	2026-07-01 19:29:45
9528	1117500652	593149	2	000000000	2026-07-01 19:29:46
9529	1117500652	593150	2	000000000	2026-07-01 19:29:46
9530	1117500652	593343	1	6801355	2024-08-16 16:08:00
9531	1117500652	593151	1	1117507159	2025-03-25 07:03:00
9532	1117500652	593152	1	1117507159	2025-04-07 23:04:00
9533	1117500652	593153	1	1117507159	2025-03-25 07:03:00
9534	1117500652	593154	1	1117507159	2025-03-25 07:03:00
9535	1117500652	593113	2	17656565	2024-12-12 16:12:00
9536	1117500652	593114	2	17656565	2024-12-12 16:12:00
9537	1117500652	593115	1	1098809645	2024-11-29 20:11:00
9538	1117500652	593116	2	17656565	2024-12-12 16:12:00
9539	1117500652	593117	1	1098809645	2024-11-29 20:11:00
9540	1117500652	593118	2	17656565	2024-12-12 16:12:00
9541	1117500652	593155	2	000000000	2026-07-01 19:29:46
9542	1117500652	593156	2	000000000	2026-07-01 19:29:46
9543	1117500652	593157	2	000000000	2026-07-01 19:29:46
9544	1117500652	593158	2	000000000	2026-07-01 19:29:46
9545	1117500652	593119	2	000000000	2026-07-01 19:29:46
9546	1117500652	593120	2	000000000	2026-07-01 19:29:46
9547	1117500652	593121	2	000000000	2026-07-01 19:29:46
9548	1117500652	593122	2	000000000	2026-07-01 19:29:46
9549	1117500652	593159	2	000000000	2026-07-01 19:29:46
9550	1117500652	593160	2	000000000	2026-07-01 19:29:46
9551	1117500652	593161	2	000000000	2026-07-01 19:29:46
9552	1117500652	593162	2	000000000	2026-07-01 19:29:46
9553	1117500652	593224	2	000000000	2026-07-01 19:29:46
9554	1117500652	593225	2	000000000	2026-07-01 19:29:46
9555	1117500652	593226	2	000000000	2026-07-01 19:29:46
9556	1117500652	593227	2	000000000	2026-07-01 19:29:46
9557	1117500652	593235	2	000000000	2026-07-01 19:29:46
9558	1117500652	593236	2	000000000	2026-07-01 19:29:46
9559	1117500652	593237	2	000000000	2026-07-01 19:29:46
9560	1117500652	593238	2	000000000	2026-07-01 19:29:46
9561	1117500652	593109	2	000000000	2026-07-01 19:29:46
9562	1117500652	593110	2	000000000	2026-07-01 19:29:46
9563	1117500652	593111	2	000000000	2026-07-01 19:29:46
9564	1117500652	593112	2	000000000	2026-07-01 19:29:46
9565	1117500652	593100	2	000000000	2026-07-01 19:29:46
9566	1117500652	593101	2	000000000	2026-07-01 19:29:46
9567	1117500652	593102	2	000000000	2026-07-01 19:29:46
9568	1117500652	593103	1	96353963	2024-12-05 06:12:00
9569	1117500652	593060	2	000000000	2026-07-01 19:29:46
9570	1117500652	593061	2	000000000	2026-07-01 19:29:46
9571	1117500652	593062	2	000000000	2026-07-01 19:29:46
9572	1117500652	593104	2	000000000	2026-07-01 19:29:46
9573	1117500652	593105	2	000000000	2026-07-01 19:29:46
9574	1117500652	593106	2	000000000	2026-07-01 19:29:46
9575	1117500652	593107	2	000000000	2026-07-01 19:29:46
9576	1117500652	593108	2	000000000	2026-07-01 19:29:46
9577	1117500652	593144	2	000000000	2026-07-01 19:29:46
9578	1117500652	593145	2	000000000	2026-07-01 19:29:46
9579	1117500652	593146	2	000000000	2026-07-01 19:29:46
9580	1117500652	592373	1	6801355	2024-11-29 19:11:00
9581	1117500652	592374	2	000000000	2026-07-01 19:29:46
9582	1117500652	592375	1	6801355	2024-11-29 19:11:00
9583	1117500652	592376	1	6801355	2024-11-29 19:11:00
9584	1117500652	593344	1	6801355	2024-11-29 19:11:00
9585	1117500652	593345	1	6801355	2024-11-29 19:11:00
9586	1117500652	593346	1	6801355	2024-11-29 19:11:00
9587	1117500652	593347	1	6801355	2024-11-29 19:11:00
9588	1117500652	593243	2	000000000	2026-07-01 19:29:46
9589	1117500652	593244	2	000000000	2026-07-01 19:29:46
9590	1117500652	593245	2	000000000	2026-07-01 19:29:46
9591	1117500652	593246	2	000000000	2026-07-01 19:29:46
9592	1117500652	593255	1	40781077	2024-12-03 18:12:00
9593	1117500652	593256	1	40781077	2024-12-03 18:12:00
9594	1117500652	593257	1	40781077	2024-12-03 18:12:00
9595	1117500652	593258	1	40781077	2024-12-03 18:12:00
9596	1117500652	593259	2	000000000	2026-07-01 19:29:46
9597	1117500652	593340	2	000000000	2026-07-01 19:29:46
9598	1117500652	593341	2	000000000	2026-07-01 19:29:46
9599	1117500652	593342	2	000000000	2026-07-01 19:29:46
9600	1117501573	590803	2	000000000	2026-07-01 19:29:46
9601	1117501573	593147	2	000000000	2026-07-01 19:29:46
9602	1117501573	593148	2	000000000	2026-07-01 19:29:46
9603	1117501573	593149	2	000000000	2026-07-01 19:29:46
9604	1117501573	593150	2	000000000	2026-07-01 19:29:46
9605	1117501573	593343	1	6801355	2024-08-16 16:08:00
9606	1117501573	593151	1	1117507159	2025-03-25 07:03:00
9607	1117501573	593152	1	1117507159	2025-04-07 23:04:00
9608	1117501573	593153	1	1117507159	2025-03-25 07:03:00
9609	1117501573	593154	1	1117507159	2025-03-25 07:03:00
9610	1117501573	593113	2	17656565	2024-12-12 16:12:00
9611	1117501573	593114	2	17656565	2024-12-12 16:12:00
9612	1117501573	593115	1	1098809645	2024-11-29 20:11:00
9613	1117501573	593116	2	17656565	2024-12-12 16:12:00
9614	1117501573	593117	1	1098809645	2024-11-29 20:11:00
9615	1117501573	593118	2	17656565	2024-12-12 16:12:00
9616	1117501573	593155	2	000000000	2026-07-01 19:29:46
9617	1117501573	593156	2	000000000	2026-07-01 19:29:46
9618	1117501573	593157	2	000000000	2026-07-01 19:29:46
9619	1117501573	593158	2	000000000	2026-07-01 19:29:46
9620	1117501573	593119	2	000000000	2026-07-01 19:29:46
9621	1117501573	593120	2	000000000	2026-07-01 19:29:46
9622	1117501573	593121	2	000000000	2026-07-01 19:29:46
9623	1117501573	593122	2	000000000	2026-07-01 19:29:46
9624	1117501573	593159	2	000000000	2026-07-01 19:29:46
9625	1117501573	593160	2	000000000	2026-07-01 19:29:46
9626	1117501573	593161	2	000000000	2026-07-01 19:29:46
9627	1117501573	593162	2	000000000	2026-07-01 19:29:47
9628	1117501573	593224	2	000000000	2026-07-01 19:29:47
9629	1117501573	593225	2	000000000	2026-07-01 19:29:47
9630	1117501573	593226	2	000000000	2026-07-01 19:29:47
9631	1117501573	593227	2	000000000	2026-07-01 19:29:47
9632	1117501573	593235	2	000000000	2026-07-01 19:29:47
9633	1117501573	593236	2	000000000	2026-07-01 19:29:47
9634	1117501573	593237	2	000000000	2026-07-01 19:29:47
9635	1117501573	593238	2	000000000	2026-07-01 19:29:47
9636	1117501573	593109	2	000000000	2026-07-01 19:29:47
9637	1117501573	593110	2	000000000	2026-07-01 19:29:47
9638	1117501573	593111	2	000000000	2026-07-01 19:29:47
9639	1117501573	593112	2	000000000	2026-07-01 19:29:47
9640	1117501573	593100	2	000000000	2026-07-01 19:29:47
9641	1117501573	593101	2	000000000	2026-07-01 19:29:47
9642	1117501573	593102	2	000000000	2026-07-01 19:29:47
9643	1117501573	593103	1	96353963	2024-12-05 06:12:00
9644	1117501573	593060	2	000000000	2026-07-01 19:29:47
9645	1117501573	593061	2	000000000	2026-07-01 19:29:47
9646	1117501573	593062	2	000000000	2026-07-01 19:29:47
9647	1117501573	593104	2	000000000	2026-07-01 19:29:47
9648	1117501573	593105	2	000000000	2026-07-01 19:29:47
9649	1117501573	593106	2	000000000	2026-07-01 19:29:47
9650	1117501573	593107	2	000000000	2026-07-01 19:29:47
9651	1117501573	593108	2	000000000	2026-07-01 19:29:47
9652	1117501573	593144	2	000000000	2026-07-01 19:29:47
9653	1117501573	593145	2	000000000	2026-07-01 19:29:47
9654	1117501573	593146	2	000000000	2026-07-01 19:29:47
9655	1117501573	592373	1	6801355	2024-11-29 19:11:00
9656	1117501573	592374	2	000000000	2026-07-01 19:29:47
9657	1117501573	592375	1	6801355	2024-11-29 19:11:00
9658	1117501573	592376	1	6801355	2024-11-29 19:11:00
9659	1117501573	593344	1	6801355	2024-11-29 19:11:00
9660	1117501573	593345	1	6801355	2024-11-29 19:11:00
9661	1117501573	593346	1	6801355	2024-11-29 19:11:00
9662	1117501573	593347	1	6801355	2024-11-29 19:11:00
9663	1117501573	593243	2	000000000	2026-07-01 19:29:47
9664	1117501573	593244	2	000000000	2026-07-01 19:29:47
9665	1117501573	593245	2	000000000	2026-07-01 19:29:47
9666	1117501573	593246	2	000000000	2026-07-01 19:29:47
9667	1117501573	593255	1	40781077	2024-12-03 18:12:00
9668	1117501573	593256	1	40781077	2024-12-03 18:12:00
9669	1117501573	593257	1	40781077	2024-12-03 18:12:00
9670	1117501573	593258	1	40781077	2024-12-03 18:12:00
9671	1117501573	593259	2	000000000	2026-07-01 19:29:47
9672	1117501573	593340	2	000000000	2026-07-01 19:29:47
9673	1117501573	593341	2	000000000	2026-07-01 19:29:47
9674	1117501573	593342	2	000000000	2026-07-01 19:29:47
9675	1117502399	590803	2	000000000	2026-07-01 19:29:47
9676	1117502399	593147	2	000000000	2026-07-01 19:29:47
9677	1117502399	593148	2	000000000	2026-07-01 19:29:47
9678	1117502399	593149	2	000000000	2026-07-01 19:29:47
9679	1117502399	593150	2	000000000	2026-07-01 19:29:47
9680	1117502399	593343	1	6801355	2024-08-16 16:08:00
9681	1117502399	593151	2	000000000	2026-07-01 19:29:47
9682	1117502399	593152	2	000000000	2026-07-01 19:29:47
9683	1117502399	593153	2	000000000	2026-07-01 19:29:47
9684	1117502399	593154	2	000000000	2026-07-01 19:29:47
9685	1117502399	593113	2	000000000	2026-07-01 19:29:47
9686	1117502399	593114	2	000000000	2026-07-01 19:29:47
9687	1117502399	593115	2	000000000	2026-07-01 19:29:47
9688	1117502399	593116	2	000000000	2026-07-01 19:29:47
9689	1117502399	593117	2	000000000	2026-07-01 19:29:47
9690	1117502399	593118	2	000000000	2026-07-01 19:29:47
9691	1117502399	593155	2	000000000	2026-07-01 19:29:47
9692	1117502399	593156	2	000000000	2026-07-01 19:29:47
9693	1117502399	593157	2	000000000	2026-07-01 19:29:47
9694	1117502399	593158	2	000000000	2026-07-01 19:29:47
9695	1117502399	593119	2	000000000	2026-07-01 19:29:47
9696	1117502399	593120	2	000000000	2026-07-01 19:29:47
9697	1117502399	593121	2	000000000	2026-07-01 19:29:47
9698	1117502399	593122	2	000000000	2026-07-01 19:29:47
9699	1117502399	593159	2	000000000	2026-07-01 19:29:47
9700	1117502399	593160	2	000000000	2026-07-01 19:29:47
9701	1117502399	593161	2	000000000	2026-07-01 19:29:47
9702	1117502399	593162	2	000000000	2026-07-01 19:29:47
9703	1117502399	593224	2	000000000	2026-07-01 19:29:47
9704	1117502399	593225	2	000000000	2026-07-01 19:29:47
9705	1117502399	593226	2	000000000	2026-07-01 19:29:47
9706	1117502399	593227	2	000000000	2026-07-01 19:29:47
9707	1117502399	593235	2	000000000	2026-07-01 19:29:47
9708	1117502399	593236	2	000000000	2026-07-01 19:29:47
9709	1117502399	593237	2	000000000	2026-07-01 19:29:47
9710	1117502399	593238	2	000000000	2026-07-01 19:29:47
9711	1117502399	593109	2	000000000	2026-07-01 19:29:47
9712	1117502399	593110	2	000000000	2026-07-01 19:29:47
9713	1117502399	593111	2	000000000	2026-07-01 19:29:47
9714	1117502399	593112	2	000000000	2026-07-01 19:29:47
9715	1117502399	593100	2	000000000	2026-07-01 19:29:47
9716	1117502399	593101	2	000000000	2026-07-01 19:29:47
9717	1117502399	593102	2	000000000	2026-07-01 19:29:47
9718	1117502399	593103	2	000000000	2026-07-01 19:29:47
9719	1117502399	593060	2	000000000	2026-07-01 19:29:47
9720	1117502399	593061	2	000000000	2026-07-01 19:29:47
9721	1117502399	593062	2	000000000	2026-07-01 19:29:47
9722	1117502399	593104	2	000000000	2026-07-01 19:29:48
9723	1117502399	593105	2	000000000	2026-07-01 19:29:48
9724	1117502399	593106	2	000000000	2026-07-01 19:29:48
9725	1117502399	593107	2	000000000	2026-07-01 19:29:48
9726	1117502399	593108	2	000000000	2026-07-01 19:29:48
9727	1117502399	593144	2	000000000	2026-07-01 19:29:48
9728	1117502399	593145	2	000000000	2026-07-01 19:29:48
9729	1117502399	593146	2	000000000	2026-07-01 19:29:48
9730	1117502399	592373	2	000000000	2026-07-01 19:29:48
9731	1117502399	592374	2	000000000	2026-07-01 19:29:48
9732	1117502399	592375	2	000000000	2026-07-01 19:29:48
9733	1117502399	592376	2	000000000	2026-07-01 19:29:48
9734	1117502399	593344	2	000000000	2026-07-01 19:29:48
9735	1117502399	593345	2	000000000	2026-07-01 19:29:48
9736	1117502399	593346	2	000000000	2026-07-01 19:29:48
9737	1117502399	593347	2	000000000	2026-07-01 19:29:48
9738	1117502399	593243	2	000000000	2026-07-01 19:29:48
9739	1117502399	593244	2	000000000	2026-07-01 19:29:48
9740	1117502399	593245	2	000000000	2026-07-01 19:29:48
9741	1117502399	593246	2	000000000	2026-07-01 19:29:48
9742	1117502399	593255	2	000000000	2026-07-01 19:29:48
9743	1117502399	593256	2	000000000	2026-07-01 19:29:48
9744	1117502399	593257	2	000000000	2026-07-01 19:29:48
9745	1117502399	593258	2	000000000	2026-07-01 19:29:48
9746	1117502399	593259	2	000000000	2026-07-01 19:29:48
9747	1117502399	593340	2	000000000	2026-07-01 19:29:48
9748	1117502399	593341	2	000000000	2026-07-01 19:29:48
9749	1117502399	593342	2	000000000	2026-07-01 19:29:48
9750	1117502612	590803	2	000000000	2026-07-01 19:29:48
9751	1117502612	593147	2	000000000	2026-07-01 19:29:48
9752	1117502612	593148	2	000000000	2026-07-01 19:29:48
9753	1117502612	593149	2	000000000	2026-07-01 19:29:48
9754	1117502612	593150	2	000000000	2026-07-01 19:29:48
9755	1117502612	593343	1	6801355	2024-08-16 16:08:00
9756	1117502612	593151	2	000000000	2026-07-01 19:29:48
9757	1117502612	593152	2	000000000	2026-07-01 19:29:48
9758	1117502612	593153	2	000000000	2026-07-01 19:29:48
9759	1117502612	593154	2	000000000	2026-07-01 19:29:48
9760	1117502612	593113	2	000000000	2026-07-01 19:29:48
9761	1117502612	593114	2	000000000	2026-07-01 19:29:48
9762	1117502612	593115	2	000000000	2026-07-01 19:29:48
9763	1117502612	593116	2	000000000	2026-07-01 19:29:48
9764	1117502612	593117	2	000000000	2026-07-01 19:29:48
9765	1117502612	593118	2	000000000	2026-07-01 19:29:48
9766	1117502612	593155	2	000000000	2026-07-01 19:29:48
9767	1117502612	593156	2	000000000	2026-07-01 19:29:48
9768	1117502612	593157	2	000000000	2026-07-01 19:29:48
9769	1117502612	593158	2	000000000	2026-07-01 19:29:48
9770	1117502612	593119	2	000000000	2026-07-01 19:29:48
9771	1117502612	593120	2	000000000	2026-07-01 19:29:48
9772	1117502612	593121	2	000000000	2026-07-01 19:29:48
9773	1117502612	593122	2	000000000	2026-07-01 19:29:48
9774	1117502612	593159	2	000000000	2026-07-01 19:29:48
9775	1117502612	593160	2	000000000	2026-07-01 19:29:48
9776	1117502612	593161	2	000000000	2026-07-01 19:29:48
9777	1117502612	593162	2	000000000	2026-07-01 19:29:48
9778	1117502612	593224	2	000000000	2026-07-01 19:29:48
9779	1117502612	593225	2	000000000	2026-07-01 19:29:48
9780	1117502612	593226	2	000000000	2026-07-01 19:29:48
9781	1117502612	593227	2	000000000	2026-07-01 19:29:48
9782	1117502612	593235	2	000000000	2026-07-01 19:29:48
9783	1117502612	593236	2	000000000	2026-07-01 19:29:48
9784	1117502612	593237	2	000000000	2026-07-01 19:29:48
9785	1117502612	593238	2	000000000	2026-07-01 19:29:48
9786	1117502612	593109	2	000000000	2026-07-01 19:29:48
9787	1117502612	593110	2	000000000	2026-07-01 19:29:48
9788	1117502612	593111	2	000000000	2026-07-01 19:29:48
9789	1117502612	593112	2	000000000	2026-07-01 19:29:48
9790	1117502612	593100	2	000000000	2026-07-01 19:29:48
9791	1117502612	593101	2	000000000	2026-07-01 19:29:48
9792	1117502612	593102	2	000000000	2026-07-01 19:29:48
9793	1117502612	593103	2	000000000	2026-07-01 19:29:48
9794	1117502612	593060	2	000000000	2026-07-01 19:29:48
9795	1117502612	593061	2	000000000	2026-07-01 19:29:48
9796	1117502612	593062	2	000000000	2026-07-01 19:29:48
9797	1117502612	593104	2	000000000	2026-07-01 19:29:48
9798	1117502612	593105	2	000000000	2026-07-01 19:29:48
9799	1117502612	593106	2	000000000	2026-07-01 19:29:48
9800	1117502612	593107	2	000000000	2026-07-01 19:29:48
9801	1117502612	593108	2	000000000	2026-07-01 19:29:48
9802	1117502612	593144	2	000000000	2026-07-01 19:29:48
9803	1117502612	593145	2	000000000	2026-07-01 19:29:48
9804	1117502612	593146	2	000000000	2026-07-01 19:29:48
9805	1117502612	592373	2	000000000	2026-07-01 19:29:48
9806	1117502612	592374	2	000000000	2026-07-01 19:29:48
9807	1117502612	592375	2	000000000	2026-07-01 19:29:48
9808	1117502612	592376	2	000000000	2026-07-01 19:29:48
9809	1117502612	593344	2	000000000	2026-07-01 19:29:48
9810	1117502612	593345	2	000000000	2026-07-01 19:29:48
9811	1117502612	593346	2	000000000	2026-07-01 19:29:48
9812	1117502612	593347	2	000000000	2026-07-01 19:29:48
9813	1117502612	593243	2	000000000	2026-07-01 19:29:48
9814	1117502612	593244	2	000000000	2026-07-01 19:29:49
9815	1117502612	593245	2	000000000	2026-07-01 19:29:49
9816	1117502612	593246	2	000000000	2026-07-01 19:29:49
9817	1117502612	593255	2	000000000	2026-07-01 19:29:49
9818	1117502612	593256	2	000000000	2026-07-01 19:29:49
9819	1117502612	593257	2	000000000	2026-07-01 19:29:49
9820	1117502612	593258	2	000000000	2026-07-01 19:29:49
9821	1117502612	593259	2	000000000	2026-07-01 19:29:49
9822	1117502612	593340	2	000000000	2026-07-01 19:29:49
9823	1117502612	593341	2	000000000	2026-07-01 19:29:49
9824	1117502612	593342	2	000000000	2026-07-01 19:29:49
9825	1117505020	590803	2	000000000	2026-07-01 19:29:49
9826	1117505020	593147	2	000000000	2026-07-01 19:29:49
9827	1117505020	593148	2	000000000	2026-07-01 19:29:49
9828	1117505020	593149	2	000000000	2026-07-01 19:29:49
9829	1117505020	593150	2	000000000	2026-07-01 19:29:49
9830	1117505020	593343	1	6801355	2024-08-16 16:08:00
9831	1117505020	593151	1	1117507159	2025-03-25 07:03:00
9832	1117505020	593152	1	1117507159	2025-04-07 23:04:00
9833	1117505020	593153	1	1117507159	2025-03-25 07:03:00
9834	1117505020	593154	1	1117507159	2025-03-25 07:03:00
9835	1117505020	593113	2	17656565	2024-12-12 16:12:00
9836	1117505020	593114	2	17656565	2024-12-12 16:12:00
9837	1117505020	593115	1	1098809645	2024-11-19 17:11:00
9838	1117505020	593116	2	17656565	2024-12-12 16:12:00
9839	1117505020	593117	1	1098809645	2024-11-29 20:11:00
9840	1117505020	593118	2	17656565	2024-12-12 16:12:00
9841	1117505020	593155	2	000000000	2026-07-01 19:29:49
9842	1117505020	593156	2	000000000	2026-07-01 19:29:49
9843	1117505020	593157	2	000000000	2026-07-01 19:29:49
9844	1117505020	593158	2	000000000	2026-07-01 19:29:49
9845	1117505020	593119	2	000000000	2026-07-01 19:29:49
9846	1117505020	593120	2	000000000	2026-07-01 19:29:49
9847	1117505020	593121	2	000000000	2026-07-01 19:29:49
9848	1117505020	593122	2	000000000	2026-07-01 19:29:49
9849	1117505020	593159	2	000000000	2026-07-01 19:29:49
9850	1117505020	593160	2	000000000	2026-07-01 19:29:49
9851	1117505020	593161	2	000000000	2026-07-01 19:29:49
9852	1117505020	593162	2	000000000	2026-07-01 19:29:49
9853	1117505020	593224	2	000000000	2026-07-01 19:29:49
9854	1117505020	593225	2	000000000	2026-07-01 19:29:49
9855	1117505020	593226	2	000000000	2026-07-01 19:29:49
9856	1117505020	593227	2	000000000	2026-07-01 19:29:49
9857	1117505020	593235	2	000000000	2026-07-01 19:29:49
9858	1117505020	593236	2	000000000	2026-07-01 19:29:49
9859	1117505020	593237	2	000000000	2026-07-01 19:29:49
9860	1117505020	593238	2	000000000	2026-07-01 19:29:49
9861	1117505020	593109	2	000000000	2026-07-01 19:29:49
9862	1117505020	593110	2	000000000	2026-07-01 19:29:49
9863	1117505020	593111	2	000000000	2026-07-01 19:29:49
9864	1117505020	593112	2	000000000	2026-07-01 19:29:49
9865	1117505020	593100	2	000000000	2026-07-01 19:29:49
9866	1117505020	593101	2	000000000	2026-07-01 19:29:49
9867	1117505020	593102	2	000000000	2026-07-01 19:29:49
9868	1117505020	593103	1	96353963	2024-12-05 06:12:00
9869	1117505020	593060	2	000000000	2026-07-01 19:29:49
9870	1117505020	593061	2	000000000	2026-07-01 19:29:49
9871	1117505020	593062	2	000000000	2026-07-01 19:29:49
9872	1117505020	593104	2	000000000	2026-07-01 19:29:49
9873	1117505020	593105	2	000000000	2026-07-01 19:29:49
9874	1117505020	593106	2	000000000	2026-07-01 19:29:49
9875	1117505020	593107	2	000000000	2026-07-01 19:29:49
9876	1117505020	593108	2	000000000	2026-07-01 19:29:49
9877	1117505020	593144	2	000000000	2026-07-01 19:29:49
9878	1117505020	593145	2	000000000	2026-07-01 19:29:49
9879	1117505020	593146	2	000000000	2026-07-01 19:29:49
9880	1117505020	592373	1	6801355	2024-11-29 19:11:00
9881	1117505020	592374	2	000000000	2026-07-01 19:29:49
9882	1117505020	592375	1	6801355	2024-11-29 19:11:00
9883	1117505020	592376	1	6801355	2024-11-29 19:11:00
9884	1117505020	593344	1	6801355	2024-11-29 19:11:00
9885	1117505020	593345	1	6801355	2024-11-29 19:11:00
9886	1117505020	593346	1	6801355	2024-11-29 19:11:00
9887	1117505020	593347	1	6801355	2024-11-29 19:11:00
9888	1117505020	593243	2	000000000	2026-07-01 19:29:49
9889	1117505020	593244	2	000000000	2026-07-01 19:29:49
9890	1117505020	593245	2	000000000	2026-07-01 19:29:49
9891	1117505020	593246	2	000000000	2026-07-01 19:29:49
9892	1117505020	593255	1	40781077	2024-12-03 18:12:00
9893	1117505020	593256	1	40781077	2024-12-03 18:12:00
9894	1117505020	593257	1	40781077	2024-12-03 18:12:00
9895	1117505020	593258	1	40781077	2024-12-03 18:12:00
9896	1117505020	593259	2	000000000	2026-07-01 19:29:49
9897	1117505020	593340	2	000000000	2026-07-01 19:29:49
9898	1117505020	593341	2	000000000	2026-07-01 19:29:49
9899	1117505020	593342	2	000000000	2026-07-01 19:29:49
9900	1117510789	590803	2	000000000	2026-07-01 19:29:49
9901	1117510789	593147	2	000000000	2026-07-01 19:29:49
9902	1117510789	593148	2	000000000	2026-07-01 19:29:49
9903	1117510789	593149	2	000000000	2026-07-01 19:29:49
9904	1117510789	593150	2	000000000	2026-07-01 19:29:49
9905	1117510789	593343	1	6801355	2024-08-16 16:08:00
9906	1117510789	593151	1	1117507159	2025-03-25 07:03:00
9907	1117510789	593152	1	1117507159	2025-04-07 23:04:00
9908	1117510789	593153	1	1117507159	2025-03-25 07:03:00
9909	1117510789	593154	1	1117507159	2025-03-25 07:03:00
9910	1117510789	593113	2	17656565	2024-12-12 16:12:00
9911	1117510789	593114	2	17656565	2024-12-12 16:12:00
9912	1117510789	593115	1	1098809645	2024-11-29 20:11:00
9913	1117510789	593116	2	17656565	2024-12-12 16:12:00
9914	1117510789	593117	1	1098809645	2024-11-29 20:11:00
9915	1117510789	593118	2	17656565	2024-12-12 16:12:00
9916	1117510789	593155	2	000000000	2026-07-01 19:29:50
9917	1117510789	593156	2	000000000	2026-07-01 19:29:50
9918	1117510789	593157	2	000000000	2026-07-01 19:29:50
9919	1117510789	593158	2	000000000	2026-07-01 19:29:50
9920	1117510789	593119	2	000000000	2026-07-01 19:29:50
9921	1117510789	593120	2	000000000	2026-07-01 19:29:50
9922	1117510789	593121	2	000000000	2026-07-01 19:29:50
9923	1117510789	593122	2	000000000	2026-07-01 19:29:50
9924	1117510789	593159	2	000000000	2026-07-01 19:29:50
9925	1117510789	593160	2	000000000	2026-07-01 19:29:50
9926	1117510789	593161	2	000000000	2026-07-01 19:29:50
9927	1117510789	593162	2	000000000	2026-07-01 19:29:50
9928	1117510789	593224	2	000000000	2026-07-01 19:29:50
9929	1117510789	593225	2	000000000	2026-07-01 19:29:50
9930	1117510789	593226	2	000000000	2026-07-01 19:29:50
9931	1117510789	593227	2	000000000	2026-07-01 19:29:50
9932	1117510789	593235	2	000000000	2026-07-01 19:29:50
9933	1117510789	593236	2	000000000	2026-07-01 19:29:50
9934	1117510789	593237	2	000000000	2026-07-01 19:29:50
9935	1117510789	593238	2	000000000	2026-07-01 19:29:50
9936	1117510789	593109	2	000000000	2026-07-01 19:29:50
9937	1117510789	593110	2	000000000	2026-07-01 19:29:50
9938	1117510789	593111	2	000000000	2026-07-01 19:29:50
9939	1117510789	593112	2	000000000	2026-07-01 19:29:50
9940	1117510789	593100	2	000000000	2026-07-01 19:29:50
9941	1117510789	593101	2	000000000	2026-07-01 19:29:50
9942	1117510789	593102	2	000000000	2026-07-01 19:29:50
9943	1117510789	593103	1	96353963	2024-12-05 06:12:00
9944	1117510789	593060	2	000000000	2026-07-01 19:29:50
9945	1117510789	593061	2	000000000	2026-07-01 19:29:50
9946	1117510789	593062	2	000000000	2026-07-01 19:29:50
9947	1117510789	593104	2	000000000	2026-07-01 19:29:50
9948	1117510789	593105	2	000000000	2026-07-01 19:29:50
9949	1117510789	593106	2	000000000	2026-07-01 19:29:50
9950	1117510789	593107	2	000000000	2026-07-01 19:29:50
9951	1117510789	593108	2	000000000	2026-07-01 19:29:50
9952	1117510789	593144	2	000000000	2026-07-01 19:29:50
9953	1117510789	593145	2	000000000	2026-07-01 19:29:50
9954	1117510789	593146	2	000000000	2026-07-01 19:29:50
9955	1117510789	592373	1	6801355	2024-11-29 19:11:00
9956	1117510789	592374	2	000000000	2026-07-01 19:29:50
9957	1117510789	592375	1	6801355	2024-11-29 19:11:00
9958	1117510789	592376	1	6801355	2024-11-29 19:11:00
9959	1117510789	593344	1	6801355	2024-11-29 19:11:00
9960	1117510789	593345	1	6801355	2024-11-29 19:11:00
9961	1117510789	593346	1	6801355	2024-11-29 19:11:00
9962	1117510789	593347	1	6801355	2024-11-29 19:11:00
9963	1117510789	593243	2	000000000	2026-07-01 19:29:50
9964	1117510789	593244	2	000000000	2026-07-01 19:29:50
9965	1117510789	593245	2	000000000	2026-07-01 19:29:50
9966	1117510789	593246	2	000000000	2026-07-01 19:29:50
9967	1117510789	593255	1	40781077	2024-12-03 18:12:00
9968	1117510789	593256	1	40781077	2024-12-03 18:12:00
9969	1117510789	593257	1	40781077	2024-12-03 18:12:00
9970	1117510789	593258	1	40781077	2024-12-03 18:12:00
9971	1117510789	593259	2	000000000	2026-07-01 19:29:50
9972	1117510789	593340	2	000000000	2026-07-01 19:29:50
9973	1117510789	593341	2	000000000	2026-07-01 19:29:50
9974	1117510789	593342	2	000000000	2026-07-01 19:29:50
9975	1117811629	590803	2	000000000	2026-07-01 19:29:50
9976	1117811629	593147	2	000000000	2026-07-01 19:29:50
9977	1117811629	593148	2	000000000	2026-07-01 19:29:50
9978	1117811629	593149	2	000000000	2026-07-01 19:29:50
9979	1117811629	593150	2	000000000	2026-07-01 19:29:50
9980	1117811629	593343	1	6801355	2024-08-16 16:08:00
9981	1117811629	593151	1	1117507159	2025-03-25 07:03:00
9982	1117811629	593152	1	1117507159	2025-04-07 23:04:00
9983	1117811629	593153	1	1117507159	2025-03-25 07:03:00
9984	1117811629	593154	1	1117507159	2025-03-25 07:03:00
9985	1117811629	593113	2	17656565	2024-12-12 16:12:00
9986	1117811629	593114	2	17656565	2024-12-12 16:12:00
9987	1117811629	593115	1	1098809645	2024-11-29 20:11:00
9988	1117811629	593116	2	17656565	2024-12-12 16:12:00
9989	1117811629	593117	1	1098809645	2024-11-29 20:11:00
9990	1117811629	593118	2	17656565	2024-12-12 16:12:00
9991	1117811629	593155	2	000000000	2026-07-01 19:29:50
9992	1117811629	593156	2	000000000	2026-07-01 19:29:50
9993	1117811629	593157	2	000000000	2026-07-01 19:29:50
9994	1117811629	593158	2	000000000	2026-07-01 19:29:50
9995	1117811629	593119	2	000000000	2026-07-01 19:29:50
9996	1117811629	593120	2	000000000	2026-07-01 19:29:50
9997	1117811629	593121	2	000000000	2026-07-01 19:29:50
9998	1117811629	593122	2	000000000	2026-07-01 19:29:50
9999	1117811629	593159	2	000000000	2026-07-01 19:29:50
10000	1117811629	593160	2	000000000	2026-07-01 19:29:51
10001	1117811629	593161	2	000000000	2026-07-01 19:29:51
10002	1117811629	593162	2	000000000	2026-07-01 19:29:51
10003	1117811629	593224	2	000000000	2026-07-01 19:29:51
10004	1117811629	593225	2	000000000	2026-07-01 19:29:51
10005	1117811629	593226	2	000000000	2026-07-01 19:29:51
10006	1117811629	593227	2	000000000	2026-07-01 19:29:51
10007	1117811629	593235	2	000000000	2026-07-01 19:29:51
10008	1117811629	593236	2	000000000	2026-07-01 19:29:51
10009	1117811629	593237	2	000000000	2026-07-01 19:29:51
10010	1117811629	593238	2	000000000	2026-07-01 19:29:51
10011	1117811629	593109	2	000000000	2026-07-01 19:29:51
10012	1117811629	593110	2	000000000	2026-07-01 19:29:51
10013	1117811629	593111	2	000000000	2026-07-01 19:29:51
10014	1117811629	593112	2	000000000	2026-07-01 19:29:51
10015	1117811629	593100	2	000000000	2026-07-01 19:29:51
10016	1117811629	593101	2	000000000	2026-07-01 19:29:51
10017	1117811629	593102	2	000000000	2026-07-01 19:29:51
10018	1117811629	593103	1	96353963	2024-12-05 06:12:00
10019	1117811629	593060	2	000000000	2026-07-01 19:29:51
10020	1117811629	593061	2	000000000	2026-07-01 19:29:51
10021	1117811629	593062	2	000000000	2026-07-01 19:29:51
10022	1117811629	593104	2	000000000	2026-07-01 19:29:51
10023	1117811629	593105	2	000000000	2026-07-01 19:29:51
10024	1117811629	593106	2	000000000	2026-07-01 19:29:51
10025	1117811629	593107	2	000000000	2026-07-01 19:29:51
10026	1117811629	593108	2	000000000	2026-07-01 19:29:51
10027	1117811629	593144	2	000000000	2026-07-01 19:29:51
10028	1117811629	593145	2	000000000	2026-07-01 19:29:51
10029	1117811629	593146	2	000000000	2026-07-01 19:29:51
10030	1117811629	592373	1	6801355	2024-11-29 19:11:00
10031	1117811629	592374	2	000000000	2026-07-01 19:29:51
10032	1117811629	592375	1	6801355	2024-11-29 19:11:00
10033	1117811629	592376	1	6801355	2024-11-29 19:11:00
10034	1117811629	593344	1	6801355	2024-11-29 19:11:00
10035	1117811629	593345	1	6801355	2024-11-29 19:11:00
10036	1117811629	593346	1	6801355	2024-11-29 19:11:00
10037	1117811629	593347	1	6801355	2024-11-29 19:11:00
10038	1117811629	593243	2	000000000	2026-07-01 19:29:51
10039	1117811629	593244	2	000000000	2026-07-01 19:29:51
10040	1117811629	593245	2	000000000	2026-07-01 19:29:51
10041	1117811629	593246	2	000000000	2026-07-01 19:29:51
10042	1117811629	593255	1	40781077	2024-12-03 18:12:00
10043	1117811629	593256	1	40781077	2024-12-03 18:12:00
10044	1117811629	593257	1	40781077	2024-12-03 18:12:00
10045	1117811629	593258	1	40781077	2024-12-03 18:12:00
10046	1117811629	593259	2	000000000	2026-07-01 19:29:51
10047	1117811629	593340	2	000000000	2026-07-01 19:29:51
10048	1117811629	593341	2	000000000	2026-07-01 19:29:51
10049	1117811629	593342	2	000000000	2026-07-01 19:29:51
10050	1118024401	590803	2	000000000	2026-07-01 19:29:51
10051	1118024401	593147	2	000000000	2026-07-01 19:29:51
10052	1118024401	593148	2	000000000	2026-07-01 19:29:51
10053	1118024401	593149	2	000000000	2026-07-01 19:29:51
10054	1118024401	593150	2	000000000	2026-07-01 19:29:51
10055	1118024401	593343	1	6801355	2024-08-16 16:08:00
10056	1118024401	593151	1	1117507159	2025-03-25 07:03:00
10057	1118024401	593152	1	1117507159	2025-04-07 23:04:00
10058	1118024401	593153	1	1117507159	2025-03-25 07:03:00
10059	1118024401	593154	1	1117507159	2025-03-25 07:03:00
10060	1118024401	593113	2	17656565	2024-12-12 16:12:00
10061	1118024401	593114	2	17656565	2024-12-12 16:12:00
10062	1118024401	593115	1	1098809645	2024-11-29 20:11:00
10063	1118024401	593116	2	17656565	2024-12-12 16:12:00
10064	1118024401	593117	1	1098809645	2024-11-29 20:11:00
10065	1118024401	593118	2	17656565	2024-12-12 16:12:00
10066	1118024401	593155	2	000000000	2026-07-01 19:29:51
10067	1118024401	593156	2	000000000	2026-07-01 19:29:51
10068	1118024401	593157	2	000000000	2026-07-01 19:29:51
10069	1118024401	593158	2	000000000	2026-07-01 19:29:51
10070	1118024401	593119	2	000000000	2026-07-01 19:29:51
10071	1118024401	593120	2	000000000	2026-07-01 19:29:51
10072	1118024401	593121	2	000000000	2026-07-01 19:29:51
10073	1118024401	593122	2	000000000	2026-07-01 19:29:51
10074	1118024401	593159	2	000000000	2026-07-01 19:29:51
10075	1118024401	593160	2	000000000	2026-07-01 19:29:51
10076	1118024401	593161	2	000000000	2026-07-01 19:29:51
10077	1118024401	593162	2	000000000	2026-07-01 19:29:51
10078	1118024401	593224	2	000000000	2026-07-01 19:29:51
10079	1118024401	593225	2	000000000	2026-07-01 19:29:51
10080	1118024401	593226	2	000000000	2026-07-01 19:29:51
10081	1118024401	593227	2	000000000	2026-07-01 19:29:51
10082	1118024401	593235	2	000000000	2026-07-01 19:29:51
10083	1118024401	593236	2	000000000	2026-07-01 19:29:51
10084	1118024401	593237	2	000000000	2026-07-01 19:29:51
10085	1118024401	593238	2	000000000	2026-07-01 19:29:51
10086	1118024401	593109	2	000000000	2026-07-01 19:29:51
10087	1118024401	593110	2	000000000	2026-07-01 19:29:51
10088	1118024401	593111	2	000000000	2026-07-01 19:29:51
10089	1118024401	593112	2	000000000	2026-07-01 19:29:51
10090	1118024401	593100	2	000000000	2026-07-01 19:29:52
10091	1118024401	593101	2	000000000	2026-07-01 19:29:52
10092	1118024401	593102	2	000000000	2026-07-01 19:29:52
10093	1118024401	593103	1	96353963	2024-12-05 06:12:00
10094	1118024401	593060	2	000000000	2026-07-01 19:29:52
10095	1118024401	593061	2	000000000	2026-07-01 19:29:52
10096	1118024401	593062	2	000000000	2026-07-01 19:29:52
10097	1118024401	593104	2	000000000	2026-07-01 19:29:52
10098	1118024401	593105	2	000000000	2026-07-01 19:29:52
10099	1118024401	593106	2	000000000	2026-07-01 19:29:52
10100	1118024401	593107	2	000000000	2026-07-01 19:29:52
10101	1118024401	593108	2	000000000	2026-07-01 19:29:52
10102	1118024401	593144	2	000000000	2026-07-01 19:29:52
10103	1118024401	593145	2	000000000	2026-07-01 19:29:52
10104	1118024401	593146	2	000000000	2026-07-01 19:29:52
10105	1118024401	592373	1	6801355	2024-11-29 19:11:00
10106	1118024401	592374	2	000000000	2026-07-01 19:29:52
10107	1118024401	592375	1	6801355	2024-11-29 19:11:00
10108	1118024401	592376	1	6801355	2024-11-29 19:11:00
10109	1118024401	593344	1	6801355	2024-11-29 19:11:00
10110	1118024401	593345	1	6801355	2024-11-29 19:11:00
10111	1118024401	593346	1	6801355	2024-11-29 19:11:00
10112	1118024401	593347	1	6801355	2024-11-29 19:11:00
10113	1118024401	593243	2	000000000	2026-07-01 19:29:52
10114	1118024401	593244	2	000000000	2026-07-01 19:29:52
10115	1118024401	593245	2	000000000	2026-07-01 19:29:52
10116	1118024401	593246	2	000000000	2026-07-01 19:29:52
10117	1118024401	593255	1	40781077	2024-12-03 18:12:00
10118	1118024401	593256	1	40781077	2024-12-03 18:12:00
10119	1118024401	593257	1	40781077	2024-12-03 18:12:00
10120	1118024401	593258	1	40781077	2024-12-03 18:12:00
10121	1118024401	593259	2	000000000	2026-07-01 19:29:52
10122	1118024401	593340	2	000000000	2026-07-01 19:29:52
10123	1118024401	593341	2	000000000	2026-07-01 19:29:52
10124	1118024401	593342	2	000000000	2026-07-01 19:29:52
10125	1118364908	590803	2	000000000	2026-07-01 19:29:52
10126	1118364908	593147	2	000000000	2026-07-01 19:29:52
10127	1118364908	593148	2	000000000	2026-07-01 19:29:52
10128	1118364908	593149	2	000000000	2026-07-01 19:29:52
10129	1118364908	593150	2	000000000	2026-07-01 19:29:52
10130	1118364908	593343	1	6801355	2024-08-16 16:08:00
10131	1118364908	593151	1	1117507159	2025-03-25 07:03:00
10132	1118364908	593152	1	1117507159	2025-04-07 23:04:00
10133	1118364908	593153	1	1117507159	2025-03-25 07:03:00
10134	1118364908	593154	1	1117507159	2025-03-25 07:03:00
10135	1118364908	593113	2	17656565	2024-12-12 16:12:00
10136	1118364908	593114	2	17656565	2024-12-12 16:12:00
10137	1118364908	593115	1	1098809645	2024-11-29 20:11:00
10138	1118364908	593116	2	17656565	2024-12-12 16:12:00
10139	1118364908	593117	1	1098809645	2024-11-29 20:11:00
10140	1118364908	593118	2	17656565	2024-12-12 16:12:00
10141	1118364908	593155	2	000000000	2026-07-01 19:29:52
10142	1118364908	593156	2	000000000	2026-07-01 19:29:52
10143	1118364908	593157	2	000000000	2026-07-01 19:29:52
10144	1118364908	593158	2	000000000	2026-07-01 19:29:52
10145	1118364908	593119	2	000000000	2026-07-01 19:29:52
10146	1118364908	593120	2	000000000	2026-07-01 19:29:52
10147	1118364908	593121	2	000000000	2026-07-01 19:29:52
10148	1118364908	593122	2	000000000	2026-07-01 19:29:52
10149	1118364908	593159	2	000000000	2026-07-01 19:29:52
10150	1118364908	593160	2	000000000	2026-07-01 19:29:52
10151	1118364908	593161	2	000000000	2026-07-01 19:29:52
10152	1118364908	593162	2	000000000	2026-07-01 19:29:52
10153	1118364908	593224	2	000000000	2026-07-01 19:29:52
10154	1118364908	593225	2	000000000	2026-07-01 19:29:52
10155	1118364908	593226	2	000000000	2026-07-01 19:29:52
10156	1118364908	593227	2	000000000	2026-07-01 19:29:52
10157	1118364908	593235	2	000000000	2026-07-01 19:29:52
10158	1118364908	593236	2	000000000	2026-07-01 19:29:52
10159	1118364908	593237	2	000000000	2026-07-01 19:29:52
10160	1118364908	593238	2	000000000	2026-07-01 19:29:52
10161	1118364908	593109	2	000000000	2026-07-01 19:29:52
10162	1118364908	593110	2	000000000	2026-07-01 19:29:52
10163	1118364908	593111	2	000000000	2026-07-01 19:29:52
10164	1118364908	593112	2	000000000	2026-07-01 19:29:52
10165	1118364908	593100	2	000000000	2026-07-01 19:29:52
10166	1118364908	593101	2	000000000	2026-07-01 19:29:52
10167	1118364908	593102	2	000000000	2026-07-01 19:29:52
10168	1118364908	593103	1	96353963	2024-12-05 06:12:00
10169	1118364908	593060	2	000000000	2026-07-01 19:29:52
10170	1118364908	593061	2	000000000	2026-07-01 19:29:52
10171	1118364908	593062	2	000000000	2026-07-01 19:29:52
10172	1118364908	593104	2	000000000	2026-07-01 19:29:52
10173	1118364908	593105	2	000000000	2026-07-01 19:29:52
10174	1118364908	593106	2	000000000	2026-07-01 19:29:52
10175	1118364908	593107	2	000000000	2026-07-01 19:29:52
10176	1118364908	593108	2	000000000	2026-07-01 19:29:52
10177	1118364908	593144	2	000000000	2026-07-01 19:29:52
10178	1118364908	593145	2	000000000	2026-07-01 19:29:52
10179	1118364908	593146	2	000000000	2026-07-01 19:29:52
10180	1118364908	592373	1	6801355	2024-11-29 19:11:00
10181	1118364908	592374	2	000000000	2026-07-01 19:29:52
10182	1118364908	592375	1	6801355	2024-11-29 19:11:00
10183	1118364908	592376	1	6801355	2024-11-29 19:11:00
10184	1118364908	593344	1	6801355	2024-11-29 19:11:00
10185	1118364908	593345	1	6801355	2024-11-29 19:11:00
10186	1118364908	593346	1	6801355	2024-11-29 19:11:00
10187	1118364908	593347	1	6801355	2024-11-29 19:11:00
10188	1118364908	593243	2	000000000	2026-07-01 19:29:53
10189	1118364908	593244	2	000000000	2026-07-01 19:29:53
10190	1118364908	593245	2	000000000	2026-07-01 19:29:53
10191	1118364908	593246	2	000000000	2026-07-01 19:29:53
10192	1118364908	593255	1	40781077	2024-12-03 18:12:00
10193	1118364908	593256	1	40781077	2024-12-03 18:12:00
10194	1118364908	593257	1	40781077	2024-12-03 18:12:00
10195	1118364908	593258	1	40781077	2024-12-03 18:12:00
10196	1118364908	593259	2	000000000	2026-07-01 19:29:53
10197	1118364908	593340	2	000000000	2026-07-01 19:29:53
10198	1118364908	593341	2	000000000	2026-07-01 19:29:53
10199	1118364908	593342	2	000000000	2026-07-01 19:29:53
10200	1118366378	590803	2	000000000	2026-07-01 19:29:53
10201	1118366378	593147	2	000000000	2026-07-01 19:29:53
10202	1118366378	593148	2	000000000	2026-07-01 19:29:53
10203	1118366378	593149	2	000000000	2026-07-01 19:29:53
10204	1118366378	593150	2	000000000	2026-07-01 19:29:53
10205	1118366378	593343	1	6801355	2024-08-16 16:08:00
10206	1118366378	593151	1	1117507159	2025-03-25 07:03:00
10207	1118366378	593152	1	1117507159	2025-04-07 23:04:00
10208	1118366378	593153	1	1117507159	2025-03-25 07:03:00
10209	1118366378	593154	1	1117507159	2025-03-25 07:03:00
10210	1118366378	593113	2	17656565	2024-12-12 16:12:00
10211	1118366378	593114	2	17656565	2024-12-12 16:12:00
10212	1118366378	593115	1	1098809645	2024-11-29 20:11:00
10213	1118366378	593116	2	17656565	2024-12-12 16:12:00
10214	1118366378	593117	1	1098809645	2024-11-29 20:11:00
10215	1118366378	593118	2	17656565	2024-12-12 16:12:00
10216	1118366378	593155	2	000000000	2026-07-01 19:29:53
10217	1118366378	593156	2	000000000	2026-07-01 19:29:53
10218	1118366378	593157	2	000000000	2026-07-01 19:29:53
10219	1118366378	593158	2	000000000	2026-07-01 19:29:53
10220	1118366378	593119	2	000000000	2026-07-01 19:29:53
10221	1118366378	593120	2	000000000	2026-07-01 19:29:53
10222	1118366378	593121	2	000000000	2026-07-01 19:29:53
10223	1118366378	593122	2	000000000	2026-07-01 19:29:53
10224	1118366378	593159	2	000000000	2026-07-01 19:29:53
10225	1118366378	593160	2	000000000	2026-07-01 19:29:53
10226	1118366378	593161	2	000000000	2026-07-01 19:29:53
10227	1118366378	593162	2	000000000	2026-07-01 19:29:53
10228	1118366378	593224	2	000000000	2026-07-01 19:29:53
10229	1118366378	593225	2	000000000	2026-07-01 19:29:53
10230	1118366378	593226	2	000000000	2026-07-01 19:29:53
10231	1118366378	593227	2	000000000	2026-07-01 19:29:53
10232	1118366378	593235	2	000000000	2026-07-01 19:29:53
10233	1118366378	593236	2	000000000	2026-07-01 19:29:53
10234	1118366378	593237	2	000000000	2026-07-01 19:29:53
10235	1118366378	593238	2	000000000	2026-07-01 19:29:53
10236	1118366378	593109	2	000000000	2026-07-01 19:29:53
10237	1118366378	593110	2	000000000	2026-07-01 19:29:53
10238	1118366378	593111	2	000000000	2026-07-01 19:29:53
10239	1118366378	593112	2	000000000	2026-07-01 19:29:53
10240	1118366378	593100	2	000000000	2026-07-01 19:29:53
10241	1118366378	593101	2	000000000	2026-07-01 19:29:53
10242	1118366378	593102	2	000000000	2026-07-01 19:29:53
10243	1118366378	593103	1	96353963	2024-12-05 06:12:00
10244	1118366378	593060	2	000000000	2026-07-01 19:29:53
10245	1118366378	593061	2	000000000	2026-07-01 19:29:53
10246	1118366378	593062	2	000000000	2026-07-01 19:29:53
10247	1118366378	593104	2	000000000	2026-07-01 19:29:53
10248	1118366378	593105	2	000000000	2026-07-01 19:29:53
10249	1118366378	593106	2	000000000	2026-07-01 19:29:53
10250	1118366378	593107	2	000000000	2026-07-01 19:29:53
10251	1118366378	593108	2	000000000	2026-07-01 19:29:53
10252	1118366378	593144	2	000000000	2026-07-01 19:29:53
10253	1118366378	593145	2	000000000	2026-07-01 19:29:53
10254	1118366378	593146	2	000000000	2026-07-01 19:29:53
10255	1118366378	592373	1	6801355	2024-11-29 19:11:00
10256	1118366378	592374	2	000000000	2026-07-01 19:29:53
10257	1118366378	592375	1	6801355	2024-11-29 19:11:00
10258	1118366378	592376	1	6801355	2024-11-29 19:11:00
10259	1118366378	593344	1	6801355	2024-11-29 19:11:00
10260	1118366378	593345	1	6801355	2024-11-29 19:11:00
10261	1118366378	593346	1	6801355	2024-11-29 19:11:00
10262	1118366378	593347	1	6801355	2024-11-29 19:11:00
10263	1118366378	593243	2	000000000	2026-07-01 19:29:53
10264	1118366378	593244	2	000000000	2026-07-01 19:29:53
10265	1118366378	593245	2	000000000	2026-07-01 19:29:53
10266	1118366378	593246	2	000000000	2026-07-01 19:29:53
10267	1118366378	593255	1	40781077	2024-12-03 18:12:00
10268	1118366378	593256	1	40781077	2024-12-03 18:12:00
10269	1118366378	593257	1	40781077	2024-12-03 18:12:00
10270	1118366378	593258	1	40781077	2024-12-03 18:12:00
10271	1118366378	593259	2	000000000	2026-07-01 19:29:53
10272	1118366378	593340	2	000000000	2026-07-01 19:29:53
10273	1118366378	593341	2	000000000	2026-07-01 19:29:53
10274	1118366378	593342	2	000000000	2026-07-01 19:29:53
\.


--
-- TOC entry 5033 (class 0 OID 34036)
-- Dependencies: 215
-- Data for Name: programas; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.programas (codigo_programa, nombre_programa, version, modalidad) FROM stdin;
533321774	ANALISIS Y DESARROLLO DE SOFTWARE.	1.0	PRESENCIAL
1477859297	GESTION CONTABLE Y FINANCIERA	1.0	PRESENCIAL
1292512061	ASISTENCIA ADMINISTRATIVA .	1.0	PRESENCIAL
\.


--
-- TOC entry 5039 (class 0 OID 34085)
-- Dependencies: 221
-- Data for Name: resultados; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.resultados (codigo_resul, nombre_resultado, codigo_comp) FROM stdin;
590803	APLICAR EN LA RESOLUCIÓN DE PROBLEMAS REALES DEL SECTOR PRODUCTIVO, LOS CONOCIMIENTOS, HABILIDADES Y DESTREZAS PERTINENTES A LAS COMPETENCIAS DEL PROGRAMA DE FORMACIÓN ASUMIENDO ESTRATEGIAS Y METODOLOGÍAS DE AUTOGESTIÓN	2
593147	02  ESTABLECER RELACIONES DE CRECIMIENTO PERSONAL Y COMUNITARIO A PARTIR DEL BIEN COMÚN COMO APORTE PARA EL DESARROLLO SOCIAL.	36180
593148	03  PROMOVER EL USO RACIONAL DE LOS RECURSOS NATURALES A PARTIR DE CRITERIOS DE SOSTENIBILIDAD Y SUSTENTABILIDAD ÉTICA Y NORMATIVA VIGENTE.	36180
593149	01  PROMOVER MI DIGNIDAD Y LA DEL OTRO A PARTIR DE LOS PRINCIPIOS Y VALORES ÉTICOS COMO APORTE EN LA INSTAURACIÓN DE UNA CULTURA DE PAZ.	36180
593150	04  CONTRIBUIR CON EL FORTALECIMIENTO DE LA CULTURA DE PAZ A PARTIR DE LA DIGNIDAD HUMANA Y LAS ESTRATEGIAS PARA LA TRANSFORMACIÓN DE CONFLICTOS.	36180
593343	01  IDENTIFICAR LA DINÁMICA ORGANIZACIONAL DEL SENA Y EL ROL DE LA FORMACIÓN PROFESIONAL INTEGRAL DE ACUERDO CON SU PROYECTO DE VIDA Y EL DESARROLLO PROFESIONAL.	36182
593151	02  APLICAR FUNCIONALIDADES DE HERRAMIENTAS Y SERVICIOS TIC, DE ACUERDO CON MANUALES DE USO, PROCEDIMIENTOS ESTABLECIDOS Y BUENAS PRÁCTICAS.	37371
593152	04  OPTIMIZAR LOS RESULTADOS, DE ACUERDO CON LA VERIFICACIÓN.	37371
593153	03  EVALUAR LOS RESULTADOS, DE ACUERDO CON LOS REQUERIMIENTOS.	37371
593154	01  ALISTAR HERRAMIENTAS DE TECNOLOGÍAS DE LA INFORMACIÓN Y LA COMUNICACIÓN (TIC), DE ACUERDO CON LAS NECESIDADES DE PROCESAMIENTO DE INFORMACIÓN Y COMUNICACIÓN.	37371
593113	06  EXPLICAR LAS FUNCIONES DE SU OCUPACIÓN LABORAL USANDO EXPRESIONES DE ACUERDO AL NIVEL REQUERIDO POR EL PROGRAMA DE FORMACIÓN.	37714
593114	04  IMPLEMENTAR ACCIONES DE MEJORA RELACIONADAS CON EL USO DE EXPRESIONES, ESTRUCTURAS Y DESEMPEÑO SEGÚN LOS RESULTADOS DE APRENDIZAJE FORMULADOS PARA EL PROGRAMA.	37714
593115	02  INTERCAMBIAR OPINIONES SOBRE SITUACIONES COTIDIANAS Y LABORALES ACTUALES, PASADAS Y FUTURAS EN CONTEXTOS SOCIALES ORALES Y ESCRITOS.	37714
593116	05  PRESENTAR UN PROCESO PARA LA REALIZACIÓN DE UNA ACTIVIDAD EN SU QUEHACER LABORAL DE ACUERDO CON LOS PROCEDIMIENTOS ESTABLECIDOS DESDE SU PROGRAMA DE FORMACIÓN.	37714
593117	01  COMPRENDER INFORMACIÓN SOBRE SITUACIONES COTIDIANAS Y LABORALES ACTUALES Y FUTURAS A TRAVÉS DE INTERACCIONES SOCIALES DE FORMA ORAL Y ESCRITA.	37714
593118	03  DISCUTIR SOBRE POSIBLES SOLUCIONES A PROBLEMAS DENTRO DE UN RANGO VARIADO DE CONTEXTOS SOCIALES Y LABORALES.	37714
593155	04  PROPONER ACCIONES DE MEJORA PARA EL MANEJO AMBIENTAL Y EL CONTROL DE LA SST, DE ACUERDO CON ESTRATEGIAS DE TRABAJO, COLABORATIVO, COOPERATIVO Y COORDINADO EN EL CONTEXTO PRODUCTIVO Y SOCIAL.	37799
593156	01  ANALIZAR LAS ESTRATEGIAS PARA LA PREVENCIÓN Y CONTROL DE LOS IMPACTOS AMBIENTALES Y DE LOS ACCIDENTES Y ENFERMEDADES LABORALES (ATEL) DE ACUERDO CON LAS POLÍTICAS ORGANIZACIONALES Y EL ENTORNO SOCIAL.	37799
593157	03  REALIZAR SEGUIMIENTO Y ACOMPAÑAMIENTO AL DESARROLLO DE LOS PLANES Y PROGRAMAS AMBIENTALES Y SST, SEGÚN EL  ÁREA DE DESEMPEÑO.	37799
593158	02  IMPLEMENTAR ESTRATEGIAS PARA EL CONTROL DE LOS IMPACTOS AMBIENTALES Y DE LOS ACCIDENTES Y ENFERMEDADES   DE ACUERDO  CON LOS PLANES Y PROGRAMAS  ESTABLECIDOS POR LA ORGANIZACIÓN.	37799
593119	02  PRACTICAR HÁBITOS SALUDABLES MEDIANTE LA APLICACIÓN DE  FUNDAMENTOS DE NUTRICIÓN E HIGIENE.	37800
593120	01  DESARROLLAR HABILIDADES PSICOMOTRICES EN EL CONTEXTO PRODUCTIVO Y SOCIAL.	37800
593121	03  EJECUTAR ACTIVIDADES DE ACONDICIONAMIENTO FÍSICO ORIENTADAS HACIA EL MEJORAMIENTO DE LA CONDICIÓN FÍSICA EN LOS CONTEXTOS PRODUCTIVO Y SOCIAL.	37800
593122	04  IMPLEMENTAR UN PLAN DE ERGONOMÍA Y PAUSAS ACTIVAS SEGÚN LAS CARACTERÍSTICAS DE LA FUNCIÓN PRODUCTIVA.	37800
593159	02  SOLUCIONAR PROBLEMAS ASOCIADOS CON EL SECTOR PRODUCTIVO CON BASE EN LOS PRINCIPIOS Y LEYES DE LA FÍSICA.	37801
593160	04  PROPONER ACCIONES DE MEJORA EN LOS PROCESOS PRODUCTIVOS DE ACUERDO CON LOS PRINCIPIOS Y LEYES DE LA FÍSICA.	37801
593161	03  VERIFICAR LAS TRANSFORMACIONES FÍSICAS DE LA MATERIA UTILIZANDO HERRAMIENTAS TECNOLÓGICAS.	37801
593162	01  IDENTIFICAR LOS PRINCIPIOS Y LEYES DE LA FÍSICA EN LA SOLUCIÓN DE PROBLEMAS DE ACUERDO AL CONTEXTO PRODUCTIVO.	37801
593224	03  RELACIONAR LOS PROCESOS COMUNICATIVOS TENIENDO EN CUENTA CRITERIOS DE LÓGICA Y RACIONALIDAD.	37802
593225	01  ANALIZAR LOS COMPONENTES DE LA COMUNICACIÓN SEGÚN SUS CARACTERÍSTICAS, INTENCIONALIDAD Y CONTEXTO.	37802
593226	04  ESTABLECER PROCESOS DE ENRIQUECIMIENTO LEXICAL Y ACCIONES DE MEJORAMIENTO EN EL DESARROLLO DE PROCESOS COMUNICATIVOS SEGÚN REQUERIMIENTOS DEL CONTEXTO.	37802
593227	02  ARGUMENTAR EN FORMA ORAL Y ESCRITA ATENDIENDO LAS EXIGENCIAS Y PARTICULARIDADES DE LAS DIVERSAS SITUACIONES COMUNICATIVAS MEDIANTE LOS DISTINTOS SISTEMAS DE REPRESENTACIÓN.	37802
593235	04  PROPONER SOLUCIONES A LAS NECESIDADES DEL CONTEXTO SEGÚN RESULTADOS DE LA INVESTIGACIÓN.	38199
593236	01  ANALIZAR EL CONTEXTO PRODUCTIVO SEGÚN SUS CARACTERÍSTICAS Y NECESIDADES.	38199
593237	03  ARGUMENTAR ASPECTOS TEÓRICOS DEL PROYECTO SEGÚN REFERENTES NACIONALES E INTERNACIONALES.	38199
593238	02  ESTRUCTURAR EL PROYECTO DE ACUERDO A CRITERIOS DE LA INVESTIGACIÓN.	38199
593109	03  DOCUMENTAR EL PROCESO DE IMPLANTACIÓN DE SOFTWARE SIGUIENDO ESTÁNDARES DE CALIDAD.	38356
593110	02  DESPLEGAR EL SOFTWARE DE ACUERDO CON LA ARQUITECTURA Y LAS POLÍTICAS ESTABLECIDAS.	38356
593111	01  PLANEAR ACTIVIDADES DE IMPLANTACIÓN DEL SOFTWARE DE ACUERDO CON LAS CONDICIONES DEL SISTEMA.	38356
593112	04  IMPLANTAR EL SOFTWARE DE ACUERDO CON LOS NIVELES DE SERVICIO ESTABLECIDOS CON EL CLIENTE.	38356
593100	03  DETERMINAR LAS CARACTERÍSTICAS TÉCNICAS DE LA INTERFAZ GRÁFICA DEL SOFTWARE ADOPTANDO ESTÁNDARES.	38362
593101	02  ESTRUCTURAR EL MODELO DE DATOS DEL SOFTWARE DE ACUERDO CON LAS ESPECIFICACIONES DEL ANÁLISIS.	38362
593102	04  VERIFICAR LOS ENTREGABLES DE LA FASE DE DISEÑO DEL SOFTWARE DE ACUERDO CON LO ESTABLECIDO EN EL INFORME DE ANÁLISIS.	38362
593103	01  ELABORAR LOS ARTEFACTOS DE DISEÑO DEL SOFTWARE SIGUIENDO LAS PRÁCTICAS DE LA METODOLOGÍA SELECCIONADA.	38362
593060	01  DEFINIR ESPECIFICACIONES TÉCNICAS DEL SOFTWARE DE ACUERDO CON LAS CARACTERÍSTICAS DEL SOFTWARE A CONSTRUIR.	38367
593061	03  VALIDAR LAS CONDICIONES DE LA PROPUESTA TÉCNICA DEL SOFTWARE DE ACUERDO CON LOS INTERESES DE LAS PARTES.	38367
593062	02  ELABORAR PROPUESTA TÉCNICA DEL SOFTWARE DE ACUERDO CON LAS ESPECIFICACIONES TÉCNICAS DEFINIDAS.	38367
593104	03  CREAR COMPONENTES FRONT-END DEL SOFTWARE DE ACUERDO CON EL DISEÑO.	38368
593105	05  REALIZAR PRUEBAS AL SOFTWARE PARA VERIFICAR SU FUNCIONALIDAD.	38368
593106	01  PLANEAR ACTIVIDADES DE CONSTRUCCIÓN DEL SOFTWARE DE ACUERDO CON EL DISEÑO ESTABLECIDO.	38368
593107	02  CONSTRUIR LA BASE DE DATOS PARA EL SOFTWARE A PARTIR DEL MODELO DE DATOS.	38368
593108	04  CODIFICAR EL SOFTWARE DE ACUERDO CON EL DISEÑO ESTABLECIDO.	38368
593144	02  VERIFICAR LA CALIDAD DEL SOFTWARE DE ACUERDO CON LAS PRÁCTICAS ASOCIADAS EN LOS PROCESOS DE DESARROLLO.	38369
593145	03  REALIZAR ACTIVIDADES DE MEJORA DE LA CALIDAD DEL SOFTWARE A PARTIR DE LOS RESULTADOS DE LA VERIFICACIÓN.	38369
593146	01  INCORPORAR ACTIVIDADES DE ASEGURAMIENTO DE LA CALIDAD DEL SOFTWARE DE ACUERDO CON ESTÁNDARES DE LA INDUSTRIA.	38369
592373	02  MODELAR LAS FUNCIONES DEL SOFTWARE DE ACUERDO CON EL INFORME DE REQUISITOS.	38376
592374	04  VERIFICAR LOS MODELOS REALIZADOS EN LA FASE DE ANÁLISIS DE ACUERDO CON LO ESTABLECIDO EN EL INFORME DE REQUISITOS.	38376
592375	01 PLANEAR ACTIVIDADES DE ANÁLISIS DE ACUERDO CON LA METODOLOGÍA SELECCIONADA.	38376
592376	03  DESARROLLAR PROCESOS LÓGICOS A TRAVÉS DE LA IMPLEMENTACIÓN DE ALGORITMOS.	38376
593344	02  RECOLECTAR INFORMACIÓN DEL SOFTWARE A CONSTRUIR DE ACUERDO CON LAS NECESIDADES DEL CLIENTE.	38392
593345	04  VALIDAR EL INFORME DE REQUISITOS DE ACUERDO CON LAS NECESIDADES DEL CLIENTE.	38392
593346	01  CARACTERIZAR LOS PROCESOS DE LA ORGANIZACIÓN DE ACUERDO CON EL SOFTWARE A CONSTRUIR.	38392
593347	03  ESTABLECER LOS REQUISITOS DEL SOFTWARE DE ACUERDO CON LA INFORMACIÓN RECOLECTADA.	38392
593243	01- Reconocer el trabajo como factor de movilidad social y transformación vital con referencia a la fenomenología y a los derechos fundamentales en el trabajo.	38558
593244	03- Practicar los derechos fundamentales en el trabajo de acuerdo con la Constitución Política y los Convenios Internacionales.	38558
593245	02- Valorar la importancia de la ciudadanía laboral con base en el estudio de los derechos humanos y fundamentales en el trabajo.	38558
593246	04- Participar en acciones solidarias teniendo en cuenta el ejercicio de los derechos humanos, de los pueblos y de la naturaleza.	38558
593255	03  RESOLVER PROBLEMAS MATEMÁTICOS A PARTIR DE SITUACIONES GENERADAS EN EL CONTEXTO SOCIAL Y PRODUCTIVO.	38560
593256	01  IDENTIFICAR MODELOS MATEMÁTICOS DE ACUERDO CON LOS REQUERIMIENTOS DEL PROBLEMA PLANTEADO  EN CONTEXTOS SOCIALES Y PRODUCTIVO.	38560
593257	04  PROPONER ACCIONES DE MEJORA FRENTE A LOS RESULTADOS DE LOS PROCEDIMIENTOS MATEMÁTICOS DE ACUERDO CON EL PROBLEMA PLANTEADO.	38560
593258	02  PLANTEAR PROBLEMAS MATEMÁTICOS A PARTIR DE SITUACIONES GENERADAS EN EL CONTEXTO SOCIAL Y PRODUCTIVO.	38560
593259	02  CARACTERIZAR LA IDEA DE NEGOCIO TENIENDO EN CUENTA LAS OPORTUNIDADES Y NECESIDADES DEL SECTOR PRODUCTIVO Y SOCIAL.	38561
593340	03  ESTRUCTURAR EL PLAN DE NEGOCIO DE ACUERDO CON LAS CARACTERÍSTICAS EMPRESARIALES Y TENDENCIAS DE MERCADO.	38561
593341	04  VALORAR LA PROPUESTA DE NEGOCIO CONFORME CON SU ESTRUCTURA Y NECESIDADES DEL SECTOR PRODUCTIVO Y SOCIAL.	38561
593342	01  INTEGRAR ELEMENTOS DE LA CULTURA EMPRENDEDORA TENIENDO EN CUENTA EL PERFIL PERSONAL Y EL CONTEXTO DE DESARROLLO SOCIAL.	38561
589237	INTERACTUAR EN LOS CONTEXTOS PRODUCTIVOS Y SOCIALES EN FUNCIÓN DE LOS PRINCIPIOS Y VALORES UNIVERSALES.	1
589238	APLICAR TÉCNICAS DE CULTURA FÍSICA PARA EL MEJORAMIENTO DE SU EXPRESIÓN CORPORAL, DESEMPEÑO LABORAL SEGÚN LA NATURALEZA Y COMPLEJIDAD DEL ÁREA OCUPACIONAL.	1
589239	REDIMENSIONAR PERMANENTEMENTE SU PROYECTO DE VIDA DE ACUERDO CON LAS CIRCUNSTANCIAS DEL CONTEXTO Y CON VISIÓN PROSPECTIVA.	1
589240	CONCERTAR ALTERNATIVAS Y ACCIONES DE FORMACIÓN PARA EL DESARROLLO DE LAS COMPETENCIAS DEL PROGRAMA FORMACIÓN, CON BASE EN LA POLÍTICA INSTITUCIONAL.	1
589241	GENERAR PROCESOS AUTÓNOMOS Y DE TRABAJO COLABORATIVO PERMANENTES, FORTALECIENDO EL EQUILIBRIO DE LOS COMPONENTES RACIONALES Y EMOCIONALES ORIENTADOS HACIA EL DESARROLLO HUMANO INTEGRAL.	1
589242	IDENTIFICAR LAS OPORTUNIDADES QUE EL SENA OFRECE EN EL MARCO DE LA FORMACIÓN PROFESIONAL DE ACUERDO CON EL CONTEXTO NACIONAL E INTERNACIONAL.	1
589243	ASUMIR ACTITUDES CRÍTICAS , ARGUMENTATIVAS Y PROPOSITIVAS EN FUNCIÓN DE LA RESOLUCIÓN DE PROBLEMAS DE CARÁCTER PRODUCTIVO Y SOCIAL.	1
589244	GESTIONAR LA INFORMACIÓN DE ACUERDO CON LOS PROCEDIMIENTOS ESTABLECIDOS Y CON LAS TECNOLOGÍAS DE LA INFORMACIÓN Y LA COMUNICACIÓN DISPONIBLES.	1
589245	ASUMIR RESPONSABLEMENTE LOS CRITERIOS DE PRESERVACIÓN Y CONSERVACIÓN DEL MEDIO AMBIENTE Y DE DESARROLLO SOSTENIBLE, EN EL EJERCICIO DE SU DESEMPEÑO LABORAL Y SOCIAL.	1
589246	DESARROLLAR PROCESOS COMUNICATIVOS EFICACES Y ASERTIVOS DENTRO DE CRITERIOS DE RACIONALIDAD QUE POSIBILITEN LA CONVIVENCIA, EL ESTABLECIMIENTO DE ACUERDOS, LA CONSTRUCCIÓN COLECTIVA DEL CONOCIMIENTO Y LA RESOLUCIÓN DE PROBLEMAS DE CARÁCTER PRODUCTIVO Y SOCIAL.	1
589247	DESARROLLAR PERMANENTEMENTE LAS HABILIDADES PSICOMOTRICES Y DE PENSAMIENTO EN LA EJECUCIÓN DE LOS PROCESOS DE APRENDIZAJE.	1
589248	RECONOCER EL ROL DE LOS PARTICIPANTES EN EL PROCESO FORMATIVO, EL PAPEL DE LOS AMBIENTES DE APRENDIZAJE Y LA METODOLOGÍA DE FORMACIÓN, DE ACUERDO CON LA DINÁMICA ORGANIZACIONAL DEL SENA	1
589249	ASUMIR LOS DEBERES Y DERECHOS CON BASE EN LAS LEYES Y LA NORMATIVA INSTITUCIONAL EN EL MARCO DE SU PROYECTO DE VIDA.	1
589250	GENERAR HÁBITOS SALUDABLES EN SU ESTILO DE VIDA PARA GARANTIZAR LA PREVENCIÓN DE RIESGOS OCUPACIONALES DE ACUERDO CON EL DIAGNÓSTICO DE SU CONDICIÓN FÍSICA INDIVIDUAL Y LA NATURALEZA Y COMPLEJIDAD DE SU DESEMPEÑO LABORAL.	1
588712	APLICAR EN LA RESOLUCIÓN DE PROBLEMAS REALES DEL SECTOR PRODUCTIVO, LOS CONOCIMIENTOS, HABILIDADES Y DESTREZAS PERTINENTES A LAS COMPETENCIAS DEL PROGRAMA DE FORMACIÓN ASUMIENDO ESTRATEGIAS Y METODOLOGÍAS DE AUTOGESTIÓN	2
588980	3. CODIFICAR Y DILIGENCIAR DOCUMENTOS DE ACUERDO CON EL PUC DEL SECTOR	2855
588981	2. CLASIFICAR DOCUMENTOS COMERCIALES Y TÍTULOS VALORES SEGÚN EL OBJETIVO DEL REGISTRO.	2855
588982	6. APLICAR LOS ELEMENTOS Y PROCEDIMIENTOS PARA EL CICLO CONTABLE EN UN PROCESO MANUAL Y SISTEMATIZADO.	2855
588983	10. DILIGENCIAR LOS SOPORTES CONTABLES REQUERIDOS EN EL REGISTRO Y CONTROL DE COSTOS DE PRODUCCIÓN SEGÚN PARÁMETROS ORGANIZACIONALES	2855
588984	13. CONOCER EL COMPONENTE DOCUMENTAL, DE GESTIÓN Y DE REPORTES DE LA CONTABILIDAD PRESUPUESTAL DE UN ENTE PÚBLICO, DE ACUERDO CON EL ESTATUTO ORGÁNICO DEL PRESUPUESTO NACIONAL.	2855
588985	8. INTERPRETAR LOS CONCEPTOS Y PROPÓSITOS DE LA CONTABILIDAD DE COSTOS, PARA UNA EFECTIVA APLICACIÓN EN ACTIVIDADES DE COSTEO POR PROCESOS, POR ÓRDENES DE PRODUCCIÓN O CUALQUIER OTRO SISTEMA DE COSTOS.	2855
588986	5. REGISTRAR   LOS   HECHOS ECONÓMICOS  SEGÚN\tLAS NORMAS COMERCIALES, TRIBUTARIAS Y LABORALES.	2855
588987	11. CONTABILIZAR LAS ACTIVIDADES PROPIAS DEL PROCESO DE COSTOS DE PRODUCCIÓN O PRESTACIÓN DE SERVICIOS PARA PRODUCIR LOS REPORTES QUE LA ORGANIZACIÓN REQUIERA.	2855
588988	4. CONTABILIZAR LOS DIFERENTES TIPOS DE OPERACIÓN EN EL DESARROLLO DEL OBJETO SOCIAL DE LA EMPRESA.	2855
588989	12. PREPARAR LOS ESTADOS FINANCIEROS Y ANEXOS DE COSTOS QUE RESPONDAN A LOS REQUERIMIENTOS ORGANIZACIONALES	2855
588990	7. ELABORAR EL CIERRE Y AJUSTES DEL CICLO CONTABLE, UTILIZANDO UN PROCESO MANUAL Y SISTEMATIZADO.	2855
588991	1. IDENTIFICAR  LOS  TIPOS  DE  ENTIDADES,  SEGÚN  SU ORGANIZACIÓN PRINCIPIOS CORPORATIVOS, ASPECTOS LEGALES Y ACTIVIDADES.	2855
588992	9. APLICAR  LOS  DIFERENTES  SISTEMAS\tDE  COSTEO  TENIENDO  EN  CUENTA\tLOS MÉTODOS Y TÉCNICAS EXISTENTES PARA LA DETERMINACIÓN DE LOS COSTOS DE PRODUCCIÓN O DE LA PRESTACIÓN DE SERVICIOS.	2855
588940	3. ELABORAR LOS ESTADOS FINANCIEROS BÁSICOS UTILIZANDO HERRAMIENTAS INFORMÁTICAS	2856
588941	5. PRESENTAR COMENTARIOS INTERPRETATIVOS A LOS ESTADOS FINANCIEROS PARA COMPLEMENTAR LA INFORMACIÓN.	2856
588942	2. IDENTIFICAR Y SELECCIONAR LAS CUENTAS QUE CONFORMAN LOS ESTADOS FINANCIEROS BÁSICOS DE ACUERDO AL PLAN ÚNICO DE CUENTAS.	2856
588943	1. APLICAR LAS NORMAS RELATIVAS A LA PRESENTACIÓN DE ESTADOS FINANCIEROS BÁSICOS CONFORME A LOS PRINCIPIOS DE CONTABILIDAD GENERALMENTE ACEPTADOS.	2856
588944	4. PREPARAR NOTAS A LOS ESTADOS FINANCIEROS PARA PRESENTACIÓN A LOS USUARIOS DE LA INFORMACIÓN.	2856
588945	6. REPROGRAMAR LAS DIFERENCIAS ENTRE LO PRESUPUESTADO Y LO EJECUTADO PARA AJUSTAR EL PLAN ESTRATÉGICO.	2863
588946	1. VALIDAR LOS RESULTADOS FINANCIEROS CON RESPECTO AL PLAN ESTRATÉGICO Y A LAS POLÍTICAS ORGANIZACIONALES.	2863
588947	4. ANALIZAR LOS RESULTADOS PRESUPUÉSTALES RESPECTO AL PLAN ESTRATÉGICO.	2863
588948	3. CONSOLIDAR LAS VARIACIONES QUE SE PRESENTAN ENTRE EL EJECUTADO Y LO PRESUPUESTADO ANALIZAR LOS RESULTADOS PRESUPUÉSTALES.	2863
588949	2. IDENTIFICAR\tY DETERMINAR LAS VARIACIONES ENTRE LO EJECUTADO Y LO PRESUPUESTADO.	2863
588950	5. ANALIZAR COMPARATIVAMENTE LAS DIFERENCIAS ENTRE LO PRESUPUESTADO Y LO EJECUTADO PARA RECOMENDAR LOS AJUSTES.	2863
588951	5. INVESTIGAR Y CONCLUIR SOBRE PROBLEMAS FINANCIEROS DE LA ORGANIZACIÓN PARA APLICACIÓN DE CORRECTIVOS.	2864
588952	1. CONCEPTUALIZAR LA SITUACIÓN FINANCIERA DE LA EMPRESA RESPECTO AL ENTORNO ECONÓMICO Y LEGAL.	2864
588953	6. PRESENTAR RECOMENDACIONES PARA SOLUCIONAR LOS PROBLEMAS FINANCIEROS DE LA ORGANIZACIÓN.	2864
588954	3. APLICAR\tLOS\tINDICADORES\tFINANCIEROS\tPARA\tDETERMINAR\tLA\tLIQUIDEZ, RENTABILIDAD, NIVEL DE ENDEUDAMIENTO, ACTIVIDAD, EBITDA Y EL VALOR ECONÓMICO AGREGADO DE LA EMPRESA.	2864
588955	2. UTILIZAR LOS ÍNDICES DE INFLACIÓN Y DEVALUACIÓN PARA RE EXPRESAR LA INFORMACIÓN CONTABLE Y FINANCIERA.	2864
588956	4. CONCLUIR Y PRESENTAR INFORME SOBRE LA SITUACIÓN FINANCIERA DE LA ORGANIZACIÓN PARA LA TOMA DE DECISIONES	2864
588993	8. ELABORAR EL INFORME DE RIESGO TENIENDO EN CUENTA LOS INDICADORES DE GESTIÓN CONTABLE Y FINANCIERA.	2865
588994	4. IDENTIFICAR LAS POLÍTICAS Y PROCEDIMIENTOS DE CONTROL INTERNO DE LA ORGANIZACIÓN PARA EVALUACIÓN DE LA GESTIÓN.	2865
588995	2. INTERPRETAR LAS NORMAS DE AUDITORÍA GENERALMENTE ACEPTADAS PARA APLICACIÓN A LA INFORMACIÓN.	2865
588996	9. DEMOSTRAR SEGURIDAD Y TRANSPARENCIA EN LOS INFORMES DE INCONSISTENCIAS Y RIESGOS DE LA ORGANIZACIÓN PARA EL MEJORAMIENTO CONTINUO DEL CONTROL INTERNO	2865
588997	3. VERIFICAR LA APLICACIÓN DE NORMAS DE CONTROL INTERNO VIGENTES PARA VERIFICACIÓN SEGÚN POLÍTICAS DE LA ORGANIZACIÓN.	2865
588998	1. IDENTIFICAR LOS DIFERENTES TIPOS DE AUDITORIA SEGÚN PROCEDIMIENTOS DE AUDITORÍA	2865
588999	5. DEMOSTRAR SEGURIDAD Y TRANSPARENCIA EN LA APLICACIÓN DE NORMAS DE AUDITORIA Y DE CONTROL INTERNO PARA LA CONFIABILIDAD DE LA INFORMACIÓN	2865
589000	7. REPORTAR LAS INCONSISTENCIAS ENCONTRADAS SEGÚN NORMAS VIGENTES Y ORGANIZACIONALES.	2865
589001	6. ELABORAR EL MAPA DE RIESGO ORGANIZACIONAL CON LAS INCONSISTENCIAS ENCONTRADAS PARA REPROGRAMACIÓN DEL CONTROL INTERNO	2865
588957	1. DETERMINAR EL PRESUPUESTO MAESTRO DE LA ORGANIZACIÓN PARA LA EJECUCIÓN DEL PLAN FINANCIERO.	2872
588958	2. ELABORAR PROYECTO DE INVERSIÓN, SEGÚN LAS POLÍTICAS DE LA EMPRESA Y, SIGUIENDO LOS LINEAMIENTOS DE LA NORMATIVIDAD VIGENTE	2872
588959	2. PRONOSTICAR UNIDADES, PRECIOS Y COSTOS DE ACUERDO A TÉCNICAS DE COSTEO.	2873
588960	10. PROPONER ALTERNATIVAS DE INVERSIÓN O FINANCIAMIENTO PARA USO DE LOS RECURSOS	2873
588961	3. PRESUPUESTAR INGRESOS OPERATIVOS, DE INVERSIÓN Y FINANCIAMIENTO CONFORME A PROCEDIMIENTOS DE PRESUPUESTACIÓN.	2873
588962	1. ESTRUCTURAR INFORMACIÓN FINANCIERA Y ESTADÍSTICA PARA LA ELABORACIÓN DEL PLAN DE ACCIÓN.	2873
588963	7. PROYECTAR ESTADO DE RESULTADOS PARA LA TOMA DE DECISIONES.	2873
588964	4. PRESUPUESTAR EGRESOS OPERATIVOS, DE INVERSIÓN Y FINANCIAMIENTO PARA LA UTILIZACIÓN DE LOS RECURSOS.	2873
588965	5. CONSOLIDAR EL PRESUPUESTO PARA EL DISEÑO DE PLANES ESTRATÉGICOS.	2873
588966	9. PLANIFICAR INGRESOS Y EGRESOS EN EFECTIVO PARA LA FIJACIÓN DE LOS FLUJOS DE CAJA ESPERADOS.	2873
588967	6. PROYECTAR ESTADO DE COSTOS DE PRODUCCIÓN DE ACUERDO A NORMAS CONTABLES.	2873
588968	8. PROYECTAR BALANCE GENERAL PARA LA DETERMINACIÓN DE LA SITUACIÓN FINANCIERA FUTURA.	2873
588969	4. INTERPRETAR LOS RESULTADOS OBTENIDOS UNA VEZ HA APLICADO LOS INDICADORES DE GESTIÓN.	2874
588970	3. ELABORAR Y PRESENTAR EL INFORME DE LAS VARIACIONES A LOS PROCEDIMIENTOS DE LA ORGANIZACIÓN.	2874
588971	1. ELABORAR UN INFORME SOBRE LAS MODIFICACIONES PRESENTADAS A LAS NORMAS LEGALES VIGENTES.	2874
588972	2. MEDIR EL IMPACTO Y VIABILIDAD QUE LAS MODIFICACIONES A LAS NORMAS GENERAN EN LA ORGANIZACIÓN.	2874
588973	5. ESTABLECER EL PLAN DE SEGUIMIENTO A CORRECTIVOS, NORMAS Y MODIFICACIONES A PROCEDIMIENTOS DE LA ORGANIZACIÓN.	2874
588974	2. CUANTIFICAR Y ANALIZAR LA INFORMACIÓN DE GESTIÓN CONTABLE Y FINANCIERA DE LA ORGANIZACIÓN RESPECTO A LA COMPETENCIA.	2875
588975	1. CONSOLIDAR LA INFORMACIÓN DE LA GESTIÓN CONTABLE Y FINANCIERA DE LA ORGANIZACIÓN PARA COMPARACIÓN CON EL SECTOR.	2875
588976	4. ESTABLECER EL POSICIONAMIENTO DE LA ORGANIZACIÓN PARA LA DETERMINACIÓN DEL PLAN DE ACCIÓN.	2875
588977	3. DETERMINAR DESVIACIONES Y CONFRONTAR INFORMES DE COMPARACIÓN DE LA ORGANIZACIÓN PARA LA DETERMINACIÓN DE TENDENCIAS DEL MERCADO.	2875
588978	3. PROGRAMAR LOS DESEMBOLSOS DE RECURSOS FINANCIEROS DE ACUERDO CON EL PLAN OPERATIVO, EL MERCADO FINANCIERO Y EL FLUJO DE CAJA.	2879
588979	2. IDENTIFICAR LAS FUENTES DE RECURSOS DE ACUERDO CON EL FLUJO DE CAJA PROYECTADO	2879
589020	1. IDENTIFICAR LAS NECESIDADES DE RECURSOS FINANCIEROS POR ÁREA Y PROYECTO DE ACUERDO CON EL PLAN OPERATIVO DE LA ORGANIZACIÓN.	2879
589021	4. SITUAR LOS RECURSOS POR CADA ÁREA Y PROYECTO ESTABLECIDO EN EL PLAN FINANCIERO DE LA ORGANIZACIÓN PARA SU EJECUCIÓN.	2879
589022	5. EJECUTAR LOS RECURSOS DE OPERACIÓN DE ACUERDO CON EL PLAN FINANCIERO DE LA ORGANIZACIÓN.	2879
589251	ENCONTRAR INFORMACIÓN ESPECÍFICA Y PREDECIBLE EN ESCRITOS SENCILLOS Y COTIDIANOS	3226
589252	ENCONTRAR VOCABULARIO Y EXPRESIONES DE INGLÉS TÉCNICO EN ANUNCIOS, FOLLETOS, PÁGINAS WEB, ETC	3226
589253	REALIZAR INTERCAMBIOS SOCIALES Y PRÁCTICOS MUY BREVES, CON UN VOCABULARIO SUFICIENTE PARA HACER UNA EXPOSICIÓN O MANTENER UNA CONVERSACIÓN SENCILLA SOBRE TEMAS TÉCNICOS	3226
589254	LEER TEXTOS MUY BREVES Y SENCILLOS EN INGLÉS GENERAL Y TÉCNICO	3226
589255	COMPRENDER FRASES Y VOCABULARIO HABITUAL SOBRE TEMAS DE INTERÉS PERSONAL Y TEMAS TÉCNICOS	3226
589256	COMUNICARSE EN TAREAS SENCILLAS Y HABITUALES QUE REQUIEREN UN INTERCAMBIO SIMPLE Y DIRECTO DE INFORMACIÓN COTIDIANA Y TÉCNICA	3226
589257	COMPRENDER LA IDEA PRINCIPAL EN AVISOS Y MENSAJES BREVES, CLAROS Y SENCILLOS EN INGLÉS TÉCNICO	3226
589258	COMPRENDER LAS IDEAS PRINCIPALES DE TEXTOS COMPLEJOS EN INGLÉS QUE TRATAN DE TEMAS TANTO CONCRETOS COMO ABSTRACTOS, INCLUSO SI SON DE CARÁCTER TÉCNICO, SIEMPRE QUE ESTÉN DENTRO DE SU CAMPO DE ESPECIALIZACIÓN	3227
589259	COMPRENDER UNA AMPLIA VARIEDAD DE FRASES Y VOCABULARIO EN INGLÉS SOBRE TEMAS DE INTERÉS PERSONAL Y TEMAS TÉCNICOS	3227
589300	ENCONTRAR Y UTILIZAR SIN ESFUERZO VOCABULARIO Y EXPRESIONES DE INGLÉS TÉCNICO EN ARTÍCULOS DE REVISTAS, LIBROS ESPECIALIZADOS, PÁGINAS WEB, ETC	3227
589301	IDENTIFICAR FORMAS GRAMATICALES BÁSICAS EN TEXTOS Y DOCUMENTOS ELEMENTALES ESCRITOS EN INGLÉS	3227
589302	REPRODUCIR EN INGLÉS FRASES O ENUNCIADOS SIMPLES QUE PERMITAN EXPRESAR DE FORMA LENTA IDEAS O CONCEPTOS	3227
589303	BUSCAR DE MANERA SISTEMÁTICA INFORMACIÓN ESPECÍFICA Y DETALLADA EN ESCRITOS EN INGLÉS, MAS ESTRUCTURADOS Y CON MAYOR CONTENIDO TÉCNICO	3227
589304	RELACIONARSE CON HABLANTES NATIVOS EN UN GRADO SUFICIENTE DE FLUIDEZ Y NATURALIDAD, DE MODO QUE LA COMUNICACIÓN SE REALICE SIN ESFUERZO POR PARTE DE LOS INTERLOCUTORES	3227
589305	LEER TEXTOS COMPLEJOS Y CON UN VOCABULARIO MÁS ESPECÍFICO, EN INGLÉS GENERAL Y TÉCNICO	3227
735222	03- Practicar los derechos fundamentales en el trabajo de acuerdo con la Constitución Política y los Convenios Internacionales.	38558
735223	01- Reconocer el trabajo como factor de movilidad social y transformación vital con referencia a la fenomenología y a los derechos fundamentales en el trabajo.	38558
735224	02- Valorar la importancia de la ciudadanía laboral con base en el estudio de los derechos humanos y fundamentales en el trabajo.	38558
735225	04- Participar en acciones solidarias teniendo en cuenta el ejercicio de los derechos humanos, de los pueblos y de la naturaleza.	38558
595100	APLICAR EN LA RESOLUCIÓN DE PROBLEMAS REALES DEL SECTOR PRODUCTIVO, LOS CONOCIMIENTOS, HABILIDADES Y DESTREZAS PERTINENTES A LAS COMPETENCIAS DEL PROGRAMA DE FORMACIÓN ASUMIENDO ESTRATEGIAS Y METODOLOGÍAS DE AUTOGESTIÓN	2
595133	04 CONTRIBUIR CON EL FORTALECIMIENTO DE LA CULTURA DE PAZ A PARTIR DE LA DIGNIDAD HUMANA Y LAS ESTRATEGIAS PARA LA TRANSFORMACIÓN DE CONFLICTOS	36180
595134	01 PROMOVER MI DIGNIDAD Y LA DEL OTRO A PARTIR DE LOS PRINCIPIOS Y VALORES ÉTICOS COMO APORTE EN LA INSTAURACIÓN DE UNA CULTURA DE PAZ.	36180
595135	02 ESTABLECER RELACIONES DE CRECIMIENTO PERSONAL Y COMUNITARIO A PARTIR DEL BIEN COMÚN COMO APORTE PARA EL DESARROLLO SOCIAL.	36180
595136	03 PROMOVER EL USO RACIONAL DE LOS RECURSOS NATURALES A PARTIR DE CRITERIOS DE SOSTENIBILIDAD Y SUSTENTABILIDAD ÉTICA Y NORMATIVA VIGENTE	36180
595105	IDENTIFICAR LA DINÁMICA ORGANIZACIONAL DEL SENA Y EL ROL DE LA FORMACIÓN PROFESIONAL INTEGRAL DE ACUERDO CON SU PROYECTO DE VIDA Y EL DESARROLLO PROFESIONAL.	36182
595137	02 USAR HERRAMIENTAS TIC, DE ACUERDO CON LOS REQUERIMIENTOS, MANUALES DE FUNCIONAMIENTO, PROCEDIMIENTOS Y ESTÁNDARES	37371
595138	04 IMPLEMENTAR BUENAS PRÁCTICAS DE USO, DE ACUERDO CON LA TECNOLOGÍA EMPLEADA	37371
595139	01 SELECCIONAR HERRAMIENTAS DE TECNOLOGÍAS DE LA INFORMACIÓN Y LA COMUNICACIÓN (TIC), DE ACUERDO CON LAS NECESIDADES IDENTIFICADAS	37371
595140	03 VERIFICAR LOS RESULTADOS OBTENIDOS, DE ACUERDO CON LOS REQUERIMIENTOS	37371
595163	06 PONER EN PRÁCTICA VOCABULARIO BÁSICO Y EXPRESIONES COMUNES DE SU ÁREA OCUPACIONAL EN CONTEXTOS ESPECÍFICOS DE SU TRABAJO POR MEDIO DEL USO DE FRASES SENCILLAS EN FORMA ORAL Y ESCRITA	37714
595164	05 COMUNICARSE DE MANERA SENCILLA EN INGLÉS EN FORMA ORAL Y ESCRITA CON UN VISITANTE O COLEGA EN UN CONTEXTO LABORAL COTIDIANO.	37714
595165	01 COMPRENDER INFORMACIÓN BÁSICA ORAL Y ESCRITA EN INGLÉS ACERCA DE SÍ MISMO, DE LAS PERSONAS Y DE SU CONTEXTO INMEDIATO EN REALIDADES PRESENTES E HISTORIAS DE VIDA.	37714
595166	02 DESCRIBIR  A  NIVEL  BÁSICO,  DE  FORMA  ORAL  Y  ESCRITA  EN  INGLÉS PERSONAS, SITUACIONES Y LUGARES DE ACUERDO CON SUS COSTUMBRES Y EXPERIENCIAS DE VIDA.	37714
595167	04 LLEVAR A CABO ACCIONES DE MEJORA RELACIONADAS CON EL INTERCAMBIO DE INFORMACIÓN BÁSICA EN INGLÉS, SOBRE SÍ MISMO, OTRAS PERSONAS, SU CONTEXTO INMEDIATO ASÍ COMO DE EXPERIENCIAS  PASADAS.	37714
595168	03 PARTICIPAR EN INTERCAMBIOS CONVERSACIONALES BÁSICOS EN FORMA ORAL Y ESCRITA EN INGLÉS EN DIFERENTES SITUACIONES SOCIALES TANTO EN LA COTIDIANIDAD COMO EN EXPERIENCIAS PASADAS.	37714
595101	02 EFECTUAR LAS  ACCIONES  PARA LA PREVENCIÓN Y CONTROL DE LA PROBLEMÁTICA AMBIENTAL Y DE SST, TENIENDO EN CUENTA LOS PROCEDIMIENTOS ESTABLECIDOS POR LA ORGANIZACIÓN.	37799
595102	03 VERIFICAR LAS CONDICIONES AMBIENTALES Y DE SST ACORDE CON LOS LINEAMIENTOS ESTABLECIDOS PARA EL ÁREA DE DESEMPEÑO LABORA	37799
595103	01 INTERPRETAR LOS PROBLEMAS  AMBIENTALES Y DE SST TENIENDO EN CUENTA LOS PLANES Y PROGRAMAS ESTABLECIDOS POR LA ORGANIZACIÓN Y EL ENTORNO SOCIAL.	37799
595104	04 REPORTAR LAS CONDICIONES Y ACTOS QUE AFECTEN LA PROTECCIÓN DEL MEDIO AMBIENTE Y LA SST, DE ACUERDO CON LOS LINEAMIENTOS ESTABLECIDOS EN EL CONTEXTO ORGANIZACIONAL Y SOCIAL.	37799
595149	04 IMPLEMENTAR UN PLAN DE ERGONOMÍA Y PAUSAS ACTIVAS SEGÚN LAS CARACTERÍSTICAS DE LA FUNCIÓN PRODUCTIVA.	37800
595150	02 PRACTICAR HÁBITOS SALUDABLES MEDIANTE LA APLICACIÓN DE FUNDAMENTOS DE NUTRICIÓN E HIGIENE.	37800
595151	01 DESARROLLAR HABILIDADES PSICOMOTRICES EN EL CONTEXTO PRODUCTIVO Y SOCIAL.	37800
595152	03 EJECUTAR ACTIVIDADES DE ACONDICIONAMIENTO FÍSICO ORIENTADAS HACIA EL MEJORAMIENTO DE LA CONDICIÓN FÍSICA EN LOS CONTEXTOS PRODUCTIVO Y SOCIAL.	37800
595141	03 VALIDAR LA IMPORTANCIA DE LOS PROCESOS COMUNICATIVOS TENIENDO EN CUENTA CRITERIOS DE LÓGICA Y RACIONALIDAD.	37802
595142	02 DECODIFICAR MENSAJES COMUNICATIVOS EN SITUACIONES DE LA VIDA SOCIAL Y LABORAL, TENIENDO EN CUENTA EL CONTEXTO DE LA COMUNICACIÓN.	37802
595143	04 APLICAR ACCIONES DE MEJORAMIENTO EN EL DESARROLLO DE PROCESOS COMUNICATIVOS SEGÚN REQUERIMIENTOS DEL CONTEXTO.	37802
595144	01 INTERPRETAR EL SENTIDO DE LA COMUNICACIÓN COMO MEDIO DE EXPRESIÓN SOCIAL, CULTURAL, LABORAL Y ARTÍSTICA	37802
595158	01 INTERPRETAR LAS POLÍTICAS DE CONTABILIDAD Y DE INFORMACIÓN FINANCIERA, TENIENDO EN CUENTA LA NORMATIVA Y LAS POLÍTICAS INSTITUCIONALES.	37888
595159	02 CLASIFICAR LOS DOCUMENTOS GENERADOS EN    LOS HECHOS ECONÓMICOS, TENIENDO EN CUENTA LAS POLÍTICAS DE CONTABILIDAD, DE INFORMACIÓN FINANCIERA Y LA NORMATIVA.	37888
595160	03 REGISTRAR LA INFORMACIÓN CONTABLE Y FINANCIERA DE LA EMPRESA CONTENIDA EN LOS DOCUMENTOS Y SOPORTES CONTABLES, TENIENDO EN CUENTA LA CLASIFICACIÓN Y LAS NORMAS DE LA ORGANIZACIÓN DE FORMA MANUAL O SISTEMATIZADA	37888
595161	05 ARCHIVAR LOS DOCUMENTOS SOPORTADOS DE ACUERDO A LA NORMATIVA Y POLÍTICAS DE LA ORGANIZACIÓN.	37888
595162	04 ELABORAR INFORMES ORIGINADOS DE LAS TRANSACCIONES CONTABLES REGISTRADAS DE FORMA MANUAL O SISTEMATIZADA ACUERDO CON NORMATIVA Y POLÍTICAS INSTITUCIONALES.	37888
595106	02 PROYECTAR LA REDACCIÓN DE LOS DOCUMENTOS EMPRESARIALES Y DE TEXTOS DE ACUERDO CON EL ASUNTO, LA NORMA TÉCNICA GRAMATICAL, TIPO DE TEXTO Y LA POLÍTICA ORGANIZACIONAL.	38415
595107	05 CORREGIR LOS TEXTOS Y DOCUMENTOS REDACTADOS TENIENDO EN CUENTA LAS OBSERVACIONES, LAS NORMAS GRAMATICALES, TÉCNICAS Y LAS POLÍTICAS DE LA ORGANIZACIÓN.	38415
595108	01 RECONOCER EL DOCUMENTO DE ACUERDO CON EL ASUNTO, LA NORMA TÉCNICA Y TIPO DE TEXTO.	38415
595109	04 COMPROBAR QUE LOS DOCUMENTOS ELABORADOS CUMPLAN CON LA NORMA TÉCNICA, GRAMATICAL, Y POLÍTICAS DE LA ORGANIZACIÓN.	38415
595110	03 ELABORAR DOCUMENTOS EMPRESARIALES Y DE TEXTOS, TENIENDO EN CUENTA LA REDACCIÓN, LAS TÉCNICAS DE DIGITACIÓN Y TRANSCRIPCIÓN, LA TECNOLOGÍA DISPONIBLE, VELOCIDAD, PRECISIÓN; NORMAS DE SEGURIDAD Y SALUD EN EL TRABAJO, NORMATIVA Y POLÍTICAS DE LA ORGANIZACIÓN.	38415
595125	04 UTILIZAR MEDIOS Y TECNOLOGÍA DISPONIBLE EN LOS PROTOCOLOS DE ATENCIÓN A CLIENTES Y USUARIOS DE ACUERDO CON POLÍTICAS ORGANIZACIONALES, NORMATIVA Y RECURSOS DISPONIBLES	38426
595126	03 PROPORCIONAR DILIGENTEMENTE ATENCIÓN Y SERVICIO AL CLIENTE, CARA A CARA, APLICANDO ACTITUDES Y VALORES; EL PROTOCOLO, LA ETIQUETA Y LAS POLÍTICAS DE LA ORGANIZACIÓN, DE ACUERDO CON LOS ESTÁNDARES DE CALIDAD ESTABLECIDOS.	38426
595127	08 APLICAR ACCIONES DE MEJORA FRENTE A SITUACIONES RELACIONADAS CON EL SERVICIO, DE ACUERDO CON POLÍTICAS ORGANIZACIONALES Y NORMATIVA VIGENTE.	38426
595128	05 PARTICIPAR EN LAS REUNIONES ORGANIZACIONALES, TENIENDO EN CUENTA EL PROTOCOLO Y POLÍTICAS	38426
595129	06 VERIFICAR LA APLICACIÓN DE ATENCIÓN Y SERVICIO AL CLIENTE, CARA A CARA, Y A TRAVÉS DE MEDIOS TECNOLÓGICOS, DE ACUERDO CON LA POLÍTICA INSTITUCIONAL Y LOS ESTÁNDARES DE CALIDAD ESTABLECIDOS.	38426
595130	02 PREPARAR LA PARTICIPACIÓN EN LAS REUNIONES DE LA ORGANIZACIÓN, TENIENDO EN CUENTA EL OBJETO, LAS RESPONSABILIDADES ASIGNADAS Y LAS  POLÍTICAS INSTITUCIONALES	38426
595131	07 RECONOCER LAS NO CONFORMIDADES RESPECTO A LA REALIZACIÓN DEL EVENTO, DE ACUERDO CON EL PROPÓSITO, OBJETIVO Y PLAN.	38426
595132	01 RECONOCER LA ORGANIZACIÓN, TIPOS DE CLIENTES, PRODUCTOS Y SERVICIOS QUE OFRECE, TENIENDO EN CUENTA SU OBJETO SOCIAL Y NORMATIVIDAD LEGAL VIGENTE.	38426
595117	03- Practicar los derechos fundamentales en el trabajo de acuerdo con la Constitución Política y los Convenios Internacionales.	38558
595118	04- Participar en acciones solidarias teniendo en cuenta el ejercicio de los derechos humanos, de los pueblos y de la naturaleza.	38558
595119	01- Reconocer el trabajo como factor de movilidad social y transformación vital con referencia a la fenomenología y a los derechos fundamentales en el trabajo.	38558
595120	02- Valorar la importancia de la ciudadanía laboral con base en el estudio de los derechos humanos y fundamentales en el trabajo.	38558
595145	03 SOLUCIONAR PROBLEMAS DEL ENTORNO PRODUCTIVO Y SOCIAL APLICANDO PRINCIPIOS MATEMÁTICOS	38560
595146	02 PLANTEAR PROBLEMAS ARITMÉTICOS, GEOMÉTRICOS Y MÉTRICOS DE ACUERDO CON LOS CONTEXTOS PRODUCTIVO Y SOCIAL	38560
595147	01 IDENTIFICAR SITUACIONES PROBLEMÁTICAS ASOCIADAS A SUS NECESIDADES DE CONTEXTO APLICANDO PROCEDIMIENTOS MATEMÁTICOS	38560
595148	04 VERIFICAR LOS RESULTADOS DE LOS PROCEDIMIENTOS MATEMÁTICOS CONFORME CON LOS REQUERIMIENTOS DE LOS DIFERENTES CONTEXTOS	38560
595111	04 CONSERVAR Y PRESERVAR    LOS DOCUMENTOS (SOPORTE FÍSICO O DIGITAL) PARA EL SUMINISTRO DE INFORMACIÓN DE ACUERDO CON LAS NORMAS TÉCNICAS, LA TECNOLOGÍA DISPONIBLE, LA NORMATIVA Y POLÍTICAS INSTITUCIONALES	39031
595112	06 PRESENTAR INFORME DEL PROCESO DE RECIBO Y DESPACHO DE LOS DOCUMENTOS DE OFICINA, TENIENDO EN CUENTA   LOS PROCEDIMIENTOS	39031
595113	03 DESPACHAR LOS DOCUMENTOS FÍSICOS Y/O ELECTRÓNICOS GENERADOS EN LAS UNIDADES ADMINISTRATIVAS, TENIENDO EN CUENTA LA NORMATIVA Y POLÍTICAS INSTITUCIONALES.	39031
595114	01 RECONOCER EL ENTORNO DE EMPRESA Y LA RELACIÓN DE ACTIVIDADES ADMINISTRATIVAS, APLICADAS AL TRÁMITE DE LOS DOCUMENTOS DE  OFICINA  DE ACUERDO CON LA NORMATIVA Y POLÍTICA INSTITUCIONALES.	39031
595115	05 COMPROBAR EL   INGRESO Y DESPACHO   DE LOS DOCUMENTOS  FÍSICOS Y/O ELECTRÓNICOS Y QUE CUMPLAN CON LA NORMATIVA,  Y POLÍTICAS ORGANIZACIONALES	39031
595116	02 RECIBIR LOS DOCUMENTOS FÍSICOS Y/O ELECTRÓNICOS DE ACUERDO   CON LA NORMATIVA Y POLÍTICAS INSTITUCIONALES.	39031
644275	RA1. ESTABLECER CARACTERÍSTICAS Y COMPETENCIAS EMPRENDEDORAS PERSONALES DE ACUERDO CON SUS POTENCIALIDADES, OBJETIVOS Y EL ENTORNO	39811
644276	RA4. RELACIONAR LA IMPORTANCIA DE LA NEGOCIACIÓN CON EL EMPRENDIMIENTO SEGÚN LAS NECESIDADES Y ELEMENTOS DE LA NEGOCIACIÓN.	39811
644277	RA2. APROPIAR EL PROCESO DE TOMA DE DECISIONES PERSONALES EN SU COTIDIANIDAD, SEGÚN EL COMPORTAMIENTO EMPRENDEDOR	39811
644278	RA3. EMPLEAR CAPACIDAD CREATIVA E INNOVADORA SEGÚN ESTRATEGIA EMPRENDEDORA	39811
644279	01 RECONOCER LOS SISTEMAS DE INFORMACIÓN DE ACUERDO A LA DISPONIBILIDAD Y LAS NECESIDADES DE LA ORGANIZACIÓN	39939
644280	04 CONSOLIDAR INFORMACIÓN DE MANERA FÍSICA O ELECTRÓNICA HACIENDO USO DE LA TECNOLOGÍA DISPONIBLE.	39939
644281	05 ELABORAR REPORTES DE ACUERDO CON LOS REQUERIMIENTOS DE INFORMACIÓN	39939
644282	02 UTILIZAR RECURSOS TECNOLÓGICOS DE LA UNIDAD ADMINISTRATIVA DE ACUERDO A LAS TECNOLOGÍAS DISPONIBLES.	39939
644323	03 PROCESAR DATOS UTILIZANDO HERRAMIENTAS INFORMÁTICAS DE ACUERDO A LAS NECESIDADES DE LAS UNIDADES ADMINISTRATIVAS.	39939
\.


--
-- TOC entry 5075 (class 0 OID 0)
-- Dependencies: 234
-- Name: actividad_competencias_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actividad_competencias_id_seq', 1, false);


--
-- TOC entry 5076 (class 0 OID 0)
-- Dependencies: 232
-- Name: actividad_resultados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actividad_resultados_id_seq', 1, false);


--
-- TOC entry 5077 (class 0 OID 0)
-- Dependencies: 230
-- Name: actividades_fase_id_actividad_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.actividades_fase_id_actividad_seq', 1, false);


--
-- TOC entry 5078 (class 0 OID 0)
-- Dependencies: 238
-- Name: alertas_id_alerta_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alertas_id_alerta_seq', 1, false);


--
-- TOC entry 5079 (class 0 OID 0)
-- Dependencies: 240
-- Name: dashboard_config_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.dashboard_config_id_seq', 1, false);


--
-- TOC entry 5080 (class 0 OID 0)
-- Dependencies: 217
-- Name: estados_id_estado_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.estados_id_estado_seq', 5, true);


--
-- TOC entry 5081 (class 0 OID 0)
-- Dependencies: 227
-- Name: fases_proyecto_id_fase_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.fases_proyecto_id_fase_seq', 1, false);


--
-- TOC entry 5082 (class 0 OID 0)
-- Dependencies: 236
-- Name: historial_indicadores_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.historial_indicadores_id_seq', 1, false);


--
-- TOC entry 5083 (class 0 OID 0)
-- Dependencies: 223
-- Name: juicios_catalogo_id_juicio_cat_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.juicios_catalogo_id_juicio_cat_seq', 36, true);


--
-- TOC entry 5084 (class 0 OID 0)
-- Dependencies: 225
-- Name: matricula_resultados_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.matricula_resultados_id_seq', 10274, true);


--
-- TOC entry 4865 (class 2606 OID 42213)
-- Name: actividad_competencias actividad_competencias_id_actividad_codigo_comp_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_competencias
    ADD CONSTRAINT actividad_competencias_id_actividad_codigo_comp_key UNIQUE (id_actividad, codigo_comp);


--
-- TOC entry 4867 (class 2606 OID 42211)
-- Name: actividad_competencias actividad_competencias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_competencias
    ADD CONSTRAINT actividad_competencias_pkey PRIMARY KEY (id);


--
-- TOC entry 4861 (class 2606 OID 42194)
-- Name: actividad_resultados actividad_resultados_id_actividad_codigo_resul_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_resultados
    ADD CONSTRAINT actividad_resultados_id_actividad_codigo_resul_key UNIQUE (id_actividad, codigo_resul);


--
-- TOC entry 4863 (class 2606 OID 42192)
-- Name: actividad_resultados actividad_resultados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_resultados
    ADD CONSTRAINT actividad_resultados_pkey PRIMARY KEY (id);


--
-- TOC entry 4859 (class 2606 OID 42180)
-- Name: actividades_fase actividades_fase_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividades_fase
    ADD CONSTRAINT actividades_fase_pkey PRIMARY KEY (id_actividad);


--
-- TOC entry 4871 (class 2606 OID 50411)
-- Name: alertas alertas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alertas
    ADD CONSTRAINT alertas_pkey PRIMARY KEY (id_alerta);


--
-- TOC entry 4837 (class 2606 OID 34064)
-- Name: aprendices aprendices_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aprendices
    ADD CONSTRAINT aprendices_pkey PRIMARY KEY (numero_documento);


--
-- TOC entry 4857 (class 2606 OID 34168)
-- Name: competencias_fases competencias_fases_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competencias_fases
    ADD CONSTRAINT competencias_fases_pkey PRIMARY KEY (codigo_comp);


--
-- TOC entry 4839 (class 2606 OID 34079)
-- Name: competencias competencias_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competencias
    ADD CONSTRAINT competencias_pkey PRIMARY KEY (codigo_comp);


--
-- TOC entry 4873 (class 2606 OID 50423)
-- Name: dashboard_config dashboard_config_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.dashboard_config
    ADD CONSTRAINT dashboard_config_pkey PRIMARY KEY (id);


--
-- TOC entry 4833 (class 2606 OID 34059)
-- Name: estados estados_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estados
    ADD CONSTRAINT estados_nombre_key UNIQUE (nombre);


--
-- TOC entry 4835 (class 2606 OID 34057)
-- Name: estados estados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.estados
    ADD CONSTRAINT estados_pkey PRIMARY KEY (id_estado);


--
-- TOC entry 4853 (class 2606 OID 34163)
-- Name: fases_proyecto fases_proyecto_nombre_fase_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fases_proyecto
    ADD CONSTRAINT fases_proyecto_nombre_fase_key UNIQUE (nombre_fase);


--
-- TOC entry 4855 (class 2606 OID 34161)
-- Name: fases_proyecto fases_proyecto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fases_proyecto
    ADD CONSTRAINT fases_proyecto_pkey PRIMARY KEY (id_fase);


--
-- TOC entry 4831 (class 2606 OID 34045)
-- Name: fichas fichas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fichas
    ADD CONSTRAINT fichas_pkey PRIMARY KEY (numero_ficha);


--
-- TOC entry 4869 (class 2606 OID 50400)
-- Name: historial_indicadores historial_indicadores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.historial_indicadores
    ADD CONSTRAINT historial_indicadores_pkey PRIMARY KEY (id);


--
-- TOC entry 4843 (class 2606 OID 34099)
-- Name: instructores instructores_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.instructores
    ADD CONSTRAINT instructores_pkey PRIMARY KEY (num_documento);


--
-- TOC entry 4845 (class 2606 OID 34108)
-- Name: juicios_catalogo juicios_catalogo_descripcion_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.juicios_catalogo
    ADD CONSTRAINT juicios_catalogo_descripcion_key UNIQUE (descripcion);


--
-- TOC entry 4847 (class 2606 OID 34106)
-- Name: juicios_catalogo juicios_catalogo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.juicios_catalogo
    ADD CONSTRAINT juicios_catalogo_pkey PRIMARY KEY (id_juicio_cat);


--
-- TOC entry 4849 (class 2606 OID 34118)
-- Name: matricula_resultados matricula_resultados_num_documento_aprendiz_codigo_resul_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matricula_resultados
    ADD CONSTRAINT matricula_resultados_num_documento_aprendiz_codigo_resul_key UNIQUE (num_documento_aprendiz, codigo_resul);


--
-- TOC entry 4851 (class 2606 OID 34116)
-- Name: matricula_resultados matricula_resultados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matricula_resultados
    ADD CONSTRAINT matricula_resultados_pkey PRIMARY KEY (id);


--
-- TOC entry 4829 (class 2606 OID 34040)
-- Name: programas programas_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.programas
    ADD CONSTRAINT programas_pkey PRIMARY KEY (codigo_programa);


--
-- TOC entry 4841 (class 2606 OID 34089)
-- Name: resultados resultados_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultados
    ADD CONSTRAINT resultados_pkey PRIMARY KEY (codigo_resul);


--
-- TOC entry 4888 (class 2606 OID 42219)
-- Name: actividad_competencias actividad_competencias_codigo_comp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_competencias
    ADD CONSTRAINT actividad_competencias_codigo_comp_fkey FOREIGN KEY (codigo_comp) REFERENCES public.competencias(codigo_comp) ON DELETE CASCADE;


--
-- TOC entry 4889 (class 2606 OID 42214)
-- Name: actividad_competencias actividad_competencias_id_actividad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_competencias
    ADD CONSTRAINT actividad_competencias_id_actividad_fkey FOREIGN KEY (id_actividad) REFERENCES public.actividades_fase(id_actividad) ON DELETE CASCADE;


--
-- TOC entry 4886 (class 2606 OID 42200)
-- Name: actividad_resultados actividad_resultados_codigo_resul_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_resultados
    ADD CONSTRAINT actividad_resultados_codigo_resul_fkey FOREIGN KEY (codigo_resul) REFERENCES public.resultados(codigo_resul) ON DELETE CASCADE;


--
-- TOC entry 4887 (class 2606 OID 42195)
-- Name: actividad_resultados actividad_resultados_id_actividad_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividad_resultados
    ADD CONSTRAINT actividad_resultados_id_actividad_fkey FOREIGN KEY (id_actividad) REFERENCES public.actividades_fase(id_actividad) ON DELETE CASCADE;


--
-- TOC entry 4885 (class 2606 OID 42181)
-- Name: actividades_fase actividades_fase_id_fase_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.actividades_fase
    ADD CONSTRAINT actividades_fase_id_fase_fkey FOREIGN KEY (id_fase) REFERENCES public.fases_proyecto(id_fase) ON DELETE CASCADE;


--
-- TOC entry 4875 (class 2606 OID 34065)
-- Name: aprendices aprendices_id_estado_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aprendices
    ADD CONSTRAINT aprendices_id_estado_fkey FOREIGN KEY (id_estado) REFERENCES public.estados(id_estado);


--
-- TOC entry 4876 (class 2606 OID 34070)
-- Name: aprendices aprendices_numero_ficha_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.aprendices
    ADD CONSTRAINT aprendices_numero_ficha_fkey FOREIGN KEY (numero_ficha) REFERENCES public.fichas(numero_ficha);


--
-- TOC entry 4877 (class 2606 OID 34080)
-- Name: competencias competencias_codigo_programa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competencias
    ADD CONSTRAINT competencias_codigo_programa_fkey FOREIGN KEY (codigo_programa) REFERENCES public.programas(codigo_programa);


--
-- TOC entry 4883 (class 2606 OID 34169)
-- Name: competencias_fases competencias_fases_codigo_comp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competencias_fases
    ADD CONSTRAINT competencias_fases_codigo_comp_fkey FOREIGN KEY (codigo_comp) REFERENCES public.competencias(codigo_comp) ON DELETE CASCADE;


--
-- TOC entry 4884 (class 2606 OID 34174)
-- Name: competencias_fases competencias_fases_id_fase_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.competencias_fases
    ADD CONSTRAINT competencias_fases_id_fase_fkey FOREIGN KEY (id_fase) REFERENCES public.fases_proyecto(id_fase) ON DELETE CASCADE;


--
-- TOC entry 4874 (class 2606 OID 34046)
-- Name: fichas fichas_codigo_programa_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fichas
    ADD CONSTRAINT fichas_codigo_programa_fkey FOREIGN KEY (codigo_programa) REFERENCES public.programas(codigo_programa);


--
-- TOC entry 4879 (class 2606 OID 34124)
-- Name: matricula_resultados matricula_resultados_codigo_resul_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matricula_resultados
    ADD CONSTRAINT matricula_resultados_codigo_resul_fkey FOREIGN KEY (codigo_resul) REFERENCES public.resultados(codigo_resul);


--
-- TOC entry 4880 (class 2606 OID 34129)
-- Name: matricula_resultados matricula_resultados_id_juicio_cat_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matricula_resultados
    ADD CONSTRAINT matricula_resultados_id_juicio_cat_fkey FOREIGN KEY (id_juicio_cat) REFERENCES public.juicios_catalogo(id_juicio_cat);


--
-- TOC entry 4881 (class 2606 OID 34119)
-- Name: matricula_resultados matricula_resultados_num_documento_aprendiz_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matricula_resultados
    ADD CONSTRAINT matricula_resultados_num_documento_aprendiz_fkey FOREIGN KEY (num_documento_aprendiz) REFERENCES public.aprendices(numero_documento);


--
-- TOC entry 4882 (class 2606 OID 34134)
-- Name: matricula_resultados matricula_resultados_num_documento_instructor_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.matricula_resultados
    ADD CONSTRAINT matricula_resultados_num_documento_instructor_fkey FOREIGN KEY (num_documento_instructor) REFERENCES public.instructores(num_documento);


--
-- TOC entry 4878 (class 2606 OID 34090)
-- Name: resultados resultados_codigo_comp_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.resultados
    ADD CONSTRAINT resultados_codigo_comp_fkey FOREIGN KEY (codigo_comp) REFERENCES public.competencias(codigo_comp);


-- Completed on 2026-08-13 14:42:53

--
-- PostgreSQL database dump complete
--

\unrestrict ThXiZGa5qw1BiUcn3A4qWc0j14Yo5GY9chv9ryowVYobOypkX6Yc9GbELaRkw7N

