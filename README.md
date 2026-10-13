# bd1-redsocial-grupo6

## Integrantes del equipo
* Eisson Javier Oyola Tique
* Julian Quintero Copete
* Jonathan Andres Serna Velasco
* Daniel Alejandro Stuart Muñoz

---

## Breve descripción del caso
El proyecto consiste en la implementación y adaptación del **modelo físico de base de datos** para la **Red Social Estudiantil Pascualina** en tres Sistemas de Gestión de Bases de Datos (SGBD) relacionales, integrando capacidades NoSQL para escenarios de Big Data e IoT.

La plataforma permite a la comunidad estudiantil:
* **Crear perfiles:** Compartir áreas de estudio, intereses, habilidades y deportes.
* **Conectar con compañeros:** Encontrar y seguir a otros estudiantes para tutorías y mentorías.
* **Publicar actualizaciones:** Compartir preguntas, recursos útiles, noticias tecnológicas o memes universitarios.
* **Crear y unirse a grupos:** Organizar equipos de estudio, hackatones o clubes de interés.
* **Programar eventos:** Anunciar y coordinar reuniones de estudio, talleres o actividades sociales.

En esta cuarta etapa, el modelo se implementa mediante scripts DDL en **PostgreSQL, MySQL y SQL Server**. Además, se incorpora el uso de tipos de datos semiestructurados (**JSON / JSONB**) en tablas clave para el almacenamiento de métricas de uso, telemetría o interacciones masivas (Big Data / IoT), acompañados de diccionarios de datos genéricos y físicos específicos para cada motor.

---

## Estructura del repositorio (Tarea 4)

```text
bd1-redsocial-grupo6/
├── README.md
└── Tarea4/
    ├── Diccionarios/
    │   ├── diccionario-generico-actualizado.pdf
    │   ├── diccionario-sgbd-1/ (PostgreSQL)
    │   ├── diccionario-sgbd-2/ (MySQL)
    │   └── diccionario-sgbd-3/ (SQL Server)
    ├── ddl/
    │   ├── scripts-ddl-sgbd-1/ (script_postgresql.sql)
    │   ├── scripts-ddl-sgbd-2/ (script_mysql.sql)
    │   └── scripts-ddl-sgbd-3/ (script_sqlserver.sql)
    ├── Informe/
    │   └── informe_tecnico_comparativo.pdf
    └── Video/
        └── enlace_video.txt
