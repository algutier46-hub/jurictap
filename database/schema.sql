CREATE TABLE usuarios(
id_usuario INT AUTO_INCREMENT PRIMARY KEY,
nombres VARCHAR(100) NOT NULL,
apellidos VARCHAR(100) NOT NULL,
tipo_documento ENUM('CC','CE','TI','PP') NOT NULL,
numero_documento VARCHAR(20) UNIQUE NOT NULL,
telefono VARCHAR(20),
direccion VARCHAR(200),
fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
estado BOOLEAN DEFAULT TRUE
);
CREATE TABLE auth_usuarios(
id_auth INT AUTO_INCREMENT PRIMARY KEY,
id_usuario INT NOT NULL,
usuario_login VARCHAR(100) UNIQUE NOT NULL,
correo_login VARCHAR(150) UNIQUE NOT NULL,
password_hash VARCHAR(255) NOT NULL,
intentos_fallidos INT DEFAULT 0,
cuenta_bloqueada BOOLEAN DEFAULT FALSE,
ultimo_acceso DATETIME,
ultimo_cambio_clave DATETIME,
FOREIGN KEY(id_usuario)
REFERENCES usuarios(id_usuario)
);
CREATE TABLE roles(
id_rol INT AUTO_INCREMENT PRIMARY KEY,
nombre_rol VARCHAR(50) UNIQUE NOT NULL,
descripcion VARCHAR(200)
);
CREATE TABLE permisos(
id_permiso INT AUTO_INCREMENT PRIMARY KEY,
nombre_permiso VARCHAR(100) UNIQUE NOT NULL,
descripcion VARCHAR(255)
);
CREATE TABLE rol_permisos(
id_rol INT NOT NULL,
id_permiso INT NOT NULL,
PRIMARY KEY(id_rol,id_permiso),
FOREIGN KEY(id_rol)
REFERENCES roles(id_rol),
FOREIGN KEY(id_permiso)
REFERENCES permisos(id_permiso)
);
CREATE TABLE usuario_roles(
id_usuario INT NOT NULL,
id_rol INT NOT NULL,
PRIMARY KEY(id_usuario,id_rol),
FOREIGN KEY(id_usuario)
REFERENCES usuarios(id_usuario),
FOREIGN KEY(id_rol)
REFERENCES roles(id_rol)
);
CREATE TABLE consultorios(
id_consultorio INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(150) NOT NULL,
direccion VARCHAR(200),
telefono VARCHAR(20),
correo VARCHAR(100),
estado BOOLEAN DEFAULT TRUE
);
CREATE TABLE integrantes_consultorio(
id_integrante INT AUTO_INCREMENT PRIMARY KEY,
id_consultorio INT NOT NULL,
id_usuario INT NOT NULL,
tipo_integrante ENUM(
'ESTUDIANTE',
'ABOGADO',
'DOCENTE',
'COORDINADOR'
) NOT NULL,
disponible BOOLEAN DEFAULT TRUE,
fecha_ingreso TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(id_consultorio)
REFERENCES consultorios(id_consultorio),
FOREIGN KEY(id_usuario)
REFERENCES usuarios(id_usuario)
);
CREATE TABLE casos(
id_caso INT AUTO_INCREMENT PRIMARY KEY,
numero_radicado VARCHAR(30) UNIQUE NOT NULL,
id_usuario INT NOT NULL,
categoria VARCHAR(100),
asunto VARCHAR(200) NOT NULL,
descripcion TEXT NOT NULL,
prioridad ENUM(
'BAJA',
'MEDIA',
'ALTA'
) DEFAULT 'MEDIA',
estado ENUM(
'RADICADO',
'IA',
'EN_REVISION',
'ASIGNADO',
'EN_PROCESO',
'CERRADO'
) DEFAULT 'RADICADO',
fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
fecha_cierre DATETIME NULL,
FOREIGN KEY(id_usuario)
REFERENCES usuarios(id_usuario)
);
CREATE TABLE equipos_caso(
id_equipo_caso INT AUTO_INCREMENT PRIMARY KEY,
id_caso INT NOT NULL,
id_integrante INT NOT NULL,
rol_caso ENUM(
'PRACTICANTE',
'SUPERVISOR',
'REVISOR',
'COORDINADOR'
) NOT NULL,
responsable_principal BOOLEAN DEFAULT FALSE,
fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(id_caso)
REFERENCES casos(id_caso),
FOREIGN KEY(id_integrante)
REFERENCES integrantes_consultorio(id_integrante)
);
CREATE TABLE actuaciones(
id_actuacion INT AUTO_INCREMENT PRIMARY KEY,
id_caso INT NOT NULL,
id_integrante INT NOT NULL,
tipo_actuacion VARCHAR(100),
descripcion TEXT NOT NULL,
fecha_actuacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(id_caso)
REFERENCES casos(id_caso),
FOREIGN KEY(id_integrante)
REFERENCES integrantes_consultorio(id_integrante)
);
CREATE TABLE documentos_caso(
id_documento INT AUTO_INCREMENT PRIMARY KEY,
id_caso INT NOT NULL,
nombre_documento VARCHAR(255) NOT NULL,
ruta_archivo VARCHAR(500) NOT NULL,
tipo_documento VARCHAR(100),
fecha_carga TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(id_caso)
REFERENCES casos(id_caso)
);
CREATE TABLE historial_estado(
id_historial INT AUTO_INCREMENT PRIMARY KEY,
id_caso INT NOT NULL,
estado_anterior VARCHAR(50),
estado_nuevo VARCHAR(50),
observacion TEXT,
fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(id_caso)
REFERENCES casos(id_caso)
);
CREATE TABLE orientaciones_ia(
id_orientacion INT AUTO_INCREMENT PRIMARY KEY,
id_caso INT NULL,
pregunta_usuario LONGTEXT NOT NULL,
respuesta_ia LONGTEXT NOT NULL,
nivel_confianza DECIMAL(5,2),
requiere_revision BOOLEAN DEFAULT TRUE,
fecha_respuesta TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(id_caso)
REFERENCES casos(id_caso)
);
CREATE TABLE auditoria_ia(
id_auditoria_ia BIGINT AUTO_INCREMENT PRIMARY KEY,
id_usuario INT,
id_caso INT,
pregunta LONGTEXT,
respuesta LONGTEXT,
nivel_confianza DECIMAL(5,2),
enviado_consultorio BOOLEAN DEFAULT FALSE,
fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(id_usuario)
REFERENCES usuarios(id_usuario),
FOREIGN KEY(id_caso)
REFERENCES casos(id_caso)
);
CREATE TABLE auditoria_eventos(
id_evento BIGINT AUTO_INCREMENT PRIMARY KEY,
id_usuario INT,
modulo VARCHAR(100),
accion VARCHAR(100),
descripcion TEXT,
ip_origen VARCHAR(50),
fecha_evento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(id_usuario)
REFERENCES usuarios(id_usuario)
);
CREATE TABLE auditoria_accesos(
id_acceso BIGINT AUTO_INCREMENT PRIMARY KEY,
id_usuario INT NULL,
usuario_login VARCHAR(100),
resultado ENUM(
'EXITOSO',
'FALLIDO'
),
ip_origen VARCHAR(50),
navegador TEXT,
fecha_intento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
FOREIGN KEY(id_usuario)
REFERENCES usuarios(id_usuario)
);
INSERT INTO roles(nombre_rol,descripcion)
VALUES
('ADMINISTRADOR','Control total de la plataforma'),
('COORDINADOR','Gestiona consultorios y equipos'),
('ABOGADO','Supervisa y atiende casos'),
('DOCENTE','Valida procesos académicos'),
('ESTUDIANTE','Desarrolla prácticas jurídicas'),
('CIUDADANO','Solicita orientación jurídica');
