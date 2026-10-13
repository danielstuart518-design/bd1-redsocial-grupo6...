-- =============================================================================
-- SCRIPT DDL MULTI-SGBD: MYSQL (SGBD 2)
-- Proyecto: Red Social Pascualina (Tarea 4)
-- Características: AUTO_INCREMENT, DATETIME, JSON nativo
-- =============================================================================

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS Asistentes_Eventos;
DROP TABLE IF EXISTS Comentarios;
DROP TABLE IF EXISTS Eventos;
DROP TABLE IF EXISTS Usuarios_Habilidades;
DROP TABLE IF EXISTS Usuarios_Intereses;
DROP TABLE IF EXISTS Habilidades;
DROP TABLE IF EXISTS Intereses;
DROP TABLE IF EXISTS Conexiones;
DROP TABLE IF EXISTS Usuarios_Grupos;
DROP TABLE IF EXISTS Publicaciones;
DROP TABLE IF EXISTS Grupos;
DROP TABLE IF EXISTS Perfiles;
DROP TABLE IF EXISTS Usuarios;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Usuarios
CREATE TABLE Usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    carrera VARCHAR(100),
    fecha_registro DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- 2. Perfiles
CREATE TABLE Perfiles (
    id_perfil INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    biografia TEXT,
    CONSTRAINT fk_perfiles_usuarios FOREIGN KEY (id_usuario)
        REFERENCES Usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 3. Grupos
CREATE TABLE Grupos (
    id_grupo INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tematica VARCHAR(50),
    fecha_creacion DATE DEFAULT (CURRENT_DATE)
) ENGINE=InnoDB;

-- 4. Publicaciones (Incluye tipo JSON para Big Data)
CREATE TABLE Publicaciones (
    id_publicacion INT AUTO_INCREMENT PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT NOT NULL,
    metadatos_interaccion JSON, -- Campo NoSQL / Big Data
    CONSTRAINT fk_publicaciones_usuarios FOREIGN KEY (id_usuario)
        REFERENCES Usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Usuarios_Grupos
CREATE TABLE Usuarios_Grupos (
    id_usuario INT NOT NULL,
    id_grupo INT NOT NULL,
    fecha_union DATE DEFAULT (CURRENT_DATE),
    rol VARCHAR(30) DEFAULT 'Miembro',
    PRIMARY KEY (id_usuario, id_grupo),
    CONSTRAINT fk_ug_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_ug_grupos FOREIGN KEY (id_grupo) REFERENCES Grupos(id_grupo) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 6. Conexiones
CREATE TABLE Conexiones (
    id_usuario INT NOT NULL,
    id_usuario_seguido INT NOT NULL,
    fecha_conexion DATE DEFAULT (CURRENT_DATE),
    PRIMARY KEY (id_usuario, id_usuario_seguido),
    CONSTRAINT fk_conex_seguidor FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_conex_seguido FOREIGN KEY (id_usuario_seguido) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 7. Eventos (Incluye tipo JSON para IoT)
CREATE TABLE Eventos (
    id_evento INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    descripcion TEXT,
    fecha DATE NOT NULL,
    lugar VARCHAR(100),
    id_grupo INT,
    telemetria_aforo JSON, -- Campo NoSQL / IoT
    CONSTRAINT fk_eventos_grupos FOREIGN KEY (id_grupo)
        REFERENCES Grupos(id_grupo) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 8. Comentarios
CREATE TABLE Comentarios (
    id_comentario INT AUTO_INCREMENT PRIMARY KEY,
    contenido TEXT NOT NULL,
    fecha DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT NOT NULL,
    id_publicacion INT NOT NULL,
    CONSTRAINT fk_comentarios_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_comentarios_publicaciones FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 9. Catálogos
CREATE TABLE Intereses (
    id_interes INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE Habilidades (
    id_habilidad INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB;

-- 10. Tablas intermedias
CREATE TABLE Usuarios_Intereses (
    id_usuario INT NOT NULL,
    id_interes INT NOT NULL,
    PRIMARY KEY (id_usuario, id_interes),
    CONSTRAINT fk_ui_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_ui_intereses FOREIGN KEY (id_interes) REFERENCES Intereses(id_interes) ON DELETE CASCADE
) ENGINE=InnoDB;

CREATE TABLE Usuarios_Habilidades (
    id_usuario INT NOT NULL,
    id_habilidad INT NOT NULL,
    nivel VARCHAR(20) DEFAULT 'Básico',
    PRIMARY KEY (id_usuario, id_habilidad),
    CONSTRAINT fk_uh_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_uh_habilidades FOREIGN KEY (id_habilidad) REFERENCES Habilidades(id_habilidad) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 11. Asistentes Eventos
CREATE TABLE Asistentes_Eventos (
    id_usuario INT NOT NULL,
    id_evento INT NOT NULL,
    confirmado BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (id_usuario, id_evento),
    CONSTRAINT fk_ae_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_ae_eventos FOREIGN KEY (id_evento) REFERENCES Eventos(id_evento) ON DELETE CASCADE
) ENGINE=InnoDB;