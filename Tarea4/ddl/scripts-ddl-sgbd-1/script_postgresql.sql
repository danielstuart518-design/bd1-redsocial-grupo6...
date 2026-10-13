-- =============================================================================
-- SCRIPT DDL MULTI-SGBD: POSTGRESQL (SGBD 1)
-- Proyecto: Red Social Pascualina (Tarea 4)
-- Características: SERIAL, TIMESTAMP, JSONB para Big Data / IoT
-- =============================================================================

DROP TABLE IF EXISTS Asistentes_Eventos CASCADE;
DROP TABLE IF EXISTS Comentarios CASCADE;
DROP TABLE IF EXISTS Eventos CASCADE;
DROP TABLE IF EXISTS Usuarios_Habilidades CASCADE;
DROP TABLE IF EXISTS Usuarios_Intereses CASCADE;
DROP TABLE IF EXISTS Habilidades CASCADE;
DROP TABLE IF EXISTS Intereses CASCADE;
DROP TABLE IF EXISTS Conexiones CASCADE;
DROP TABLE IF EXISTS Usuarios_Grupos CASCADE;
DROP TABLE IF EXISTS Publicaciones CASCADE;
DROP TABLE IF EXISTS Grupos CASCADE;
DROP TABLE IF EXISTS Perfiles CASCADE;
DROP TABLE IF EXISTS Usuarios CASCADE;

-- 1. Usuarios
CREATE TABLE Usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    carrera VARCHAR(100),
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Perfiles
CREATE TABLE Perfiles (
    id_perfil SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    biografia TEXT,
    CONSTRAINT fk_perfiles_usuarios FOREIGN KEY (id_usuario)
        REFERENCES Usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3. Grupos
CREATE TABLE Grupos (
    id_grupo SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tematica VARCHAR(50),
    fecha_creacion DATE DEFAULT CURRENT_DATE
);

-- 4. Publicaciones (Incluye JSONB para Big Data / Analítica de interacciones)
CREATE TABLE Publicaciones (
    id_publicacion SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT NOT NULL,
    metadatos_interaccion JSONB, -- Campo NoSQL / Big Data
    CONSTRAINT fk_publicaciones_usuarios FOREIGN KEY (id_usuario)
        REFERENCES Usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 5. Usuarios_Grupos
CREATE TABLE Usuarios_Grupos (
    id_usuario INT NOT NULL,
    id_grupo INT NOT NULL,
    fecha_union DATE DEFAULT CURRENT_DATE,
    rol VARCHAR(30) DEFAULT 'Miembro',
    PRIMARY KEY (id_usuario, id_grupo),
    CONSTRAINT fk_ug_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_ug_grupos FOREIGN KEY (id_grupo) REFERENCES Grupos(id_grupo) ON DELETE CASCADE
);

-- 6. Conexiones
CREATE TABLE Conexiones (
    id_usuario INT NOT NULL,
    id_usuario_seguido INT NOT NULL,
    fecha_conexion DATE DEFAULT CURRENT_DATE,
    PRIMARY KEY (id_usuario, id_usuario_seguido),
    CONSTRAINT fk_conex_seguidor FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_conex_seguido FOREIGN KEY (id_usuario_seguido) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
);

-- 7. Eventos (Incluye JSONB para IoT / Telemetría de sensores del campus)
CREATE TABLE Eventos (
    id_evento SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    fecha DATE NOT NULL,
    lugar VARCHAR(100),
    id_grupo INT,
    telemetria_aforo JSONB, -- Campo NoSQL / IoT
    CONSTRAINT fk_eventos_grupos FOREIGN KEY (id_grupo)
        REFERENCES Grupos(id_grupo) ON DELETE SET NULL ON UPDATE CASCADE
);

-- 8. Comentarios
CREATE TABLE Comentarios (
    id_comentario SERIAL PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT NOT NULL,
    id_publicacion INT NOT NULL,
    CONSTRAINT fk_comentarios_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_comentarios_publicaciones FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion) ON DELETE CASCADE
);

-- 9. Catálogos
CREATE TABLE Intereses (
    id_interes SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Habilidades (
    id_habilidad SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
);

-- 10. Tablas intermedias
CREATE TABLE Usuarios_Intereses (
    id_usuario INT NOT NULL,
    id_interes INT NOT NULL,
    PRIMARY KEY (id_usuario, id_interes),
    CONSTRAINT fk_ui_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_ui_intereses FOREIGN KEY (id_interes) REFERENCES Intereses(id_interes) ON DELETE CASCADE
);

CREATE TABLE Usuarios_Habilidades (
    id_usuario INT NOT NULL,
    id_habilidad INT NOT NULL,
    nivel VARCHAR(20) DEFAULT 'Básico',
    PRIMARY KEY (id_usuario, id_habilidad),
    CONSTRAINT fk_uh_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_uh_habilidades FOREIGN KEY (id_habilidad) REFERENCES Habilidades(id_habilidad) ON DELETE CASCADE
);

-- 11. Asistentes Eventos
CREATE TABLE Asistentes_Eventos (
    id_usuario INT NOT NULL,
    id_evento INT NOT NULL,
    confirmado BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id_usuario, id_evento),
    CONSTRAINT fk_ae_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_ae_eventos FOREIGN KEY (id_evento) REFERENCES Eventos(id_evento) ON DELETE CASCADE
);