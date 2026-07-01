-- SISTEMA DE GESTIÓN DE JUICIOS EVALUATIVOS
-- Modelo adaptado para PostgreSQL

CREATE TABLE programas (
    codigo_programa INT NOT NULL,
    nombre_programa VARCHAR(150) NOT NULL,
    version VARCHAR(10),
    modalidad VARCHAR(50),
    PRIMARY KEY (codigo_programa)
);

CREATE TABLE fichas (
    numero_ficha INT NOT NULL,
    codigo_programa INT NOT NULL,
    fecha_inicio DATE,
    fecha_fin DATE,
    estado_ficha VARCHAR(50),
    PRIMARY KEY (numero_ficha),
    FOREIGN KEY (codigo_programa) REFERENCES programas(codigo_programa)
);

CREATE TABLE estados (
    id_estado SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE aprendices (
    numero_documento VARCHAR(20) NOT NULL,
    tipo_documento VARCHAR(20),
    nombres VARCHAR(80),
    apellidos VARCHAR(80),
    id_estado INT NOT NULL,
    numero_ficha INT NOT NULL,
    PRIMARY KEY (numero_documento),
    FOREIGN KEY (id_estado) REFERENCES estados(id_estado),
    FOREIGN KEY (numero_ficha) REFERENCES fichas(numero_ficha)
);

CREATE TABLE competencias (
    codigo_comp INT NOT NULL,
    nombre_comp VARCHAR(250) NOT NULL,
    codigo_programa INT NOT NULL,
    PRIMARY KEY (codigo_comp),
    FOREIGN KEY (codigo_programa) REFERENCES programas(codigo_programa)
);

CREATE TABLE resultados (
    codigo_resul INT NOT NULL,
    nombre_resultado VARCHAR(350) NOT NULL,
    codigo_comp INT NOT NULL,
    PRIMARY KEY (codigo_resul),
    FOREIGN KEY (codigo_comp) REFERENCES competencias(codigo_comp)
);

CREATE TABLE instructores (
    num_documento VARCHAR(20) NOT NULL,
    nombres_apellidos VARCHAR(150) NOT NULL,
    cargo VARCHAR(100),
    PRIMARY KEY (num_documento)
);

CREATE TABLE juicios_catalogo (
    id_juicio_cat SERIAL PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE matricula_resultados (
    id SERIAL PRIMARY KEY,
    num_documento_aprendiz VARCHAR(20) NOT NULL,
    codigo_resul INT NOT NULL,
    id_juicio_cat INT NOT NULL,
    num_documento_instructor VARCHAR(20) NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (num_documento_aprendiz) REFERENCES aprendices(numero_documento),
    FOREIGN KEY (codigo_resul) REFERENCES resultados(codigo_resul),
    FOREIGN KEY (id_juicio_cat) REFERENCES juicios_catalogo(id_juicio_cat),
    FOREIGN KEY (num_documento_instructor) REFERENCES instructores(num_documento),
    UNIQUE (num_documento_aprendiz, codigo_resul)
);

-- Datos iniciales
INSERT INTO estados (nombre) VALUES ('EN FORMACIÓN'), ('RETIRO VOLUNTARIO'), ('CANCELADO'), ('TRASLADADO'), ('APLAZADO') ON CONFLICT DO NOTHING;
INSERT INTO juicios_catalogo (descripcion) VALUES ('APROBADO'), ('POR EVALUAR'), ('NO APROBADO') ON CONFLICT DO NOTHING;
