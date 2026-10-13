-- =============================================================================
-- SCRIPT DDL MULTI-SGBD: SQL SERVER (SGBD 3)
-- Proyecto: Red Social Pascualina (Tarea 4)
-- Características: IDENTITY(1,1), DATETIME2, NVARCHAR(MAX) con ISJSON()
-- =============================================================================

IF OBJECT_ID('dbo.Asistentes_Eventos', 'U') IS NOT NULL DROP TABLE dbo.Asistentes_Eventos;
IF OBJECT_ID('dbo.Comentarios', 'U') IS NOT NULL DROP TABLE dbo.Comentarios;
IF OBJECT_ID('dbo.Eventos', 'U') IS NOT NULL DROP TABLE dbo.Eventos;
IF OBJECT_ID('dbo.Usuarios_Habilidades', 'U') IS NOT NULL DROP TABLE dbo.Usuarios_Habilidades;
IF OBJECT_ID('dbo.Usuarios_Intereses', 'U') IS NOT NULL DROP TABLE dbo.Usuarios_Intereses;
IF OBJECT_ID('dbo.Habilidades', 'U') IS NOT NULL DROP TABLE dbo.Habilidades;
IF OBJECT_ID('dbo.Intereses', 'U') IS NOT NULL DROP TABLE dbo.Intereses;
IF OBJECT_ID('dbo.Conexiones', 'U') IS NOT NULL DROP TABLE dbo.Conexiones;
IF OBJECT_ID('dbo.Usuarios_Grupos', 'U') IS NOT NULL DROP TABLE dbo.Usuarios_Grupos;
IF OBJECT_ID('dbo.Publicaciones', 'U') IS NOT NULL DROP TABLE dbo.Publicaciones;
IF OBJECT_ID('dbo.Grupos', 'U') IS NOT NULL DROP TABLE dbo.Grupos;
IF OBJECT_ID('dbo.Perfiles', 'U') IS NOT NULL DROP TABLE dbo.Perfiles;
IF OBJECT_ID('dbo.Usuarios', 'U') IS NOT NULL DROP TABLE dbo.Usuarios;

-- 1. Usuarios
CREATE TABLE Usuarios (
    id_usuario INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    correo NVARCHAR(150) NOT NULL UNIQUE,
    carrera NVARCHAR(100),
    fecha_registro DATETIME2 DEFAULT GETDATE()
);

-- 2. Perfiles
CREATE TABLE Perfiles (
    id_perfil INT IDENTITY(1,1) PRIMARY KEY,
    id_usuario INT NOT NULL UNIQUE,
    biografia NVARCHAR(MAX),
    CONSTRAINT fk_perfiles_usuarios FOREIGN KEY (id_usuario)
        REFERENCES Usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE
);

-- 3. Grupos
CREATE TABLE Grupos (
    id_grupo INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    tematica NVARCHAR(50),
    fecha_creacion DATE DEFAULT CAST(GETDATE() AS DATE)
);

-- 4. Publicaciones (Usa NVARCHAR(MAX) respaldado por restricción CHECK ISJSON)
CREATE TABLE Publicaciones (
    id_publicacion INT IDENTITY(1,1) PRIMARY KEY,
    contenido NVARCHAR(MAX) NOT NULL,
    fecha DATETIME2 DEFAULT GETDATE(),
    id_usuario INT NOT NULL,
    metadatos_interaccion NVARCHAR(MAX),
    CONSTRAINT fk_publicaciones_usuarios FOREIGN KEY (id_usuario)
        REFERENCES Usuarios(id_usuario) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT chk_json_publicaciones CHECK (metadatos_interaccion IS NULL OR ISJSON(metadatos_interaccion) > 0)
);

-- 5. Usuarios_Grupos
CREATE TABLE Usuarios_Grupos (
    id_usuario INT NOT NULL,
    id_grupo INT NOT NULL,
    fecha_union DATE DEFAULT CAST(GETDATE() AS DATE),
    rol NVARCHAR(30) DEFAULT 'Miembro',
    PRIMARY KEY (id_usuario, id_grupo),
    CONSTRAINT fk_ug_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_ug_grupos FOREIGN KEY (id_grupo) REFERENCES Grupos(id_grupo) ON DELETE CASCADE
);

-- 6. Conexiones
CREATE TABLE Conexiones (
    id_usuario INT NOT NULL,
    id_usuario_seguido INT NOT NULL,
    fecha_conexion DATE DEFAULT CAST(GETDATE() AS DATE),
    PRIMARY KEY (id_usuario, id_usuario_seguido),
    CONSTRAINT fk_conex_seguidor FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE NO ACTION,
    CONSTRAINT fk_conex_seguido FOREIGN KEY (id_usuario_seguido) REFERENCES Usuarios(id_usuario) ON DELETE NO ACTION
);

-- 7. Eventos (Usa NVARCHAR(MAX) respaldado por restricción CHECK ISJSON)
CREATE TABLE Eventos (
    id_evento INT IDENTITY(1,1) PRIMARY KEY,
    titulo NVARCHAR(150) NOT NULL,
    descripcion NVARCHAR(MAX),
    fecha DATE NOT NULL,
    lugar NVARCHAR(100),
    id_grupo INT,
    telemetria_aforo NVARCHAR(MAX),
    CONSTRAINT fk_eventos_grupos FOREIGN KEY (id_grupo)
        REFERENCES Grupos(id_grupo) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT chk_json_eventos CHECK (telemetria_aforo IS NULL OR ISJSON(telemetria_aforo) > 0)
);

-- 8. Comentarios
CREATE TABLE Comentarios (
    id_comentario INT IDENTITY(1,1) PRIMARY KEY,
    contenido NVARCHAR(MAX) NOT NULL,
    fecha DATETIME2 DEFAULT GETDATE(),
    id_usuario INT NOT NULL,
    id_publicacion INT NOT NULL,
    CONSTRAINT fk_comentarios_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE NO ACTION,
    CONSTRAINT fk_comentarios_publicaciones FOREIGN KEY (id_publicacion) REFERENCES Publicaciones(id_publicacion) ON DELETE CASCADE
);

-- 9. Catálogos
CREATE TABLE Intereses (
    id_interes INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE Habilidades (
    id_habilidad INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL UNIQUE
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
    nivel NVARCHAR(20) DEFAULT 'Básico',
    PRIMARY KEY (id_usuario, id_habilidad),
    CONSTRAINT fk_uh_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_uh_habilidades FOREIGN KEY (id_habilidad) REFERENCES Habilidades(id_habilidad) ON DELETE CASCADE
);

-- 11. Asistentes Eventos
CREATE TABLE Asistentes_Eventos (
    id_usuario INT NOT NULL,
    id_evento INT NOT NULL,
    confirmado BIT DEFAULT 0,
    PRIMARY KEY (id_usuario, id_evento),
    CONSTRAINT fk_ae_usuarios FOREIGN KEY (id_usuario) REFERENCES Usuarios(id_usuario) ON DELETE CASCADE,
    CONSTRAINT fk_ae_eventos FOREIGN KEY (id_evento) REFERENCES Eventos(id_evento) ON DELETE CASCADE
);