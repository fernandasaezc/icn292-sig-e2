
DROP DATABASE IF EXISTS dinecom_sig;
CREATE DATABASE dinecom_sig
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE dinecom_sig;

-- 1. Organizaciones clientes
CREATE TABLE cliente (
    id_cliente   INT AUTO_INCREMENT PRIMARY KEY,
    razon_social VARCHAR(120) NOT NULL UNIQUE,
    rubro        VARCHAR(80)  NOT NULL
);

-- 2. Contactos / usuarios finales de cada cliente
CREATE TABLE contacto (
    id_contacto INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente  INT          NOT NULL,
    nombre      VARCHAR(100) NOT NULL,
    cargo       VARCHAR(80)  NOT NULL,
    correo      VARCHAR(120) NOT NULL UNIQUE,
    celular     VARCHAR(25)  NOT NULL,
    CONSTRAINT fk_contacto_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- 3. Salas audiovisuales por cliente
CREATE TABLE sala (
    id_sala     INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente  INT          NOT NULL,
    nombre_sala VARCHAR(100) NOT NULL,
    ubicacion   VARCHAR(150) NOT NULL,
    CONSTRAINT fk_sala_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);

-- 4. Catálogo de roles y nivel de atención (elimina dependencia transitiva en 3FN)
CREATE TABLE rol_agente (
    id_rol         INT AUTO_INCREMENT PRIMARY KEY,
    nombre_rol     VARCHAR(60) NOT NULL UNIQUE,
    nivel_atencion CHAR(2)     NOT NULL,
    CONSTRAINT chk_rol_nivel
        CHECK (nivel_atencion IN ('N1', 'N2', 'N3'))
);

-- 5. Agentes internos de Dinecom Care
CREATE TABLE agente (
    id_agente INT AUTO_INCREMENT PRIMARY KEY,
    id_rol    INT          NOT NULL,
    nombre    VARCHAR(100) NOT NULL,
    correo    VARCHAR(120) NOT NULL UNIQUE,
    CONSTRAINT fk_agente_rol
        FOREIGN KEY (id_rol) REFERENCES rol_agente(id_rol)
);

-- 6. Catálogo de prioridades y SLA en horas (soporta RF3 y KPIs en 3FN)
CREATE TABLE prioridad_sla (
    id_prioridad             INT AUTO_INCREMENT PRIMARY KEY,
    nombre_prioridad         VARCHAR(20) NOT NULL UNIQUE,
    sla_horas                INT         NOT NULL,
    requiere_alerta_gerencia BOOLEAN     NOT NULL DEFAULT FALSE,
    CONSTRAINT chk_sla_positivo
        CHECK (sla_horas > 0)
);

-- 7. Tickets de soporte (folio único autogenerado; sin estado_actual redundante)
CREATE TABLE ticket (
    id_ticket            INT AUTO_INCREMENT PRIMARY KEY,
    id_contacto          INT         NOT NULL,
    id_sala              INT         NOT NULL,
    id_agente_asignado   INT         NOT NULL,
    id_prioridad         INT         NOT NULL,
    canal_origen         VARCHAR(20) NOT NULL,
    detalle_problema     TEXT        NOT NULL,
    diagnostico_primario TEXT,
    nivel_escalamiento   CHAR(2)     NOT NULL DEFAULT 'N1',
    fecha_creacion       DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_cierre         DATETIME    NULL,
    CONSTRAINT fk_ticket_contacto
        FOREIGN KEY (id_contacto) REFERENCES contacto(id_contacto),
    CONSTRAINT fk_ticket_sala
        FOREIGN KEY (id_sala) REFERENCES sala(id_sala),
    CONSTRAINT fk_ticket_agente
        FOREIGN KEY (id_agente_asignado) REFERENCES agente(id_agente),
    CONSTRAINT fk_ticket_prioridad
        FOREIGN KEY (id_prioridad) REFERENCES prioridad_sla(id_prioridad),
    CONSTRAINT chk_ticket_canal
        CHECK (canal_origen IN ('Telefono', 'Correo', 'Web')),
    CONSTRAINT chk_ticket_nivel
        CHECK (nivel_escalamiento IN ('N1', 'N2', 'N3')),
    CONSTRAINT chk_ticket_fechas
        CHECK (fecha_cierre IS NULL OR fecha_cierre >= fecha_creacion)
);

-- 8. Bitácora cronológica de estados (fuente única de verdad del estado)
CREATE TABLE historial_estado (
    id_historial INT AUTO_INCREMENT PRIMARY KEY,
    id_ticket    INT         NOT NULL,
    id_agente    INT         NOT NULL,
    estado       VARCHAR(20) NOT NULL,
    comentario   TEXT,
    fecha_hora   DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_historial_ticket
        FOREIGN KEY (id_ticket) REFERENCES ticket(id_ticket) ON DELETE CASCADE,
    CONSTRAINT fk_historial_agente
        FOREIGN KEY (id_agente) REFERENCES agente(id_agente),
    CONSTRAINT chk_historial_estado
        CHECK (estado IN ('Abierto', 'En proceso', 'Escalado', 'Cerrado'))
);

-- 9. Garantías / RMA con fabricantes externos (relación 1 a 0..1 con ticket)
CREATE TABLE garantia (
    id_garantia   INT AUTO_INCREMENT PRIMARY KEY,
    id_ticket     INT         NOT NULL UNIQUE,
    fabricante    VARCHAR(60) NOT NULL,
    fecha_envio   DATE        NOT NULL,
    fecha_retorno DATE        NULL,
    resultado     VARCHAR(20) NOT NULL,
    CONSTRAINT fk_garantia_ticket
        FOREIGN KEY (id_ticket) REFERENCES ticket(id_ticket),
    CONSTRAINT chk_garantia_fechas
        CHECK (fecha_retorno IS NULL OR fecha_retorno >= fecha_envio),
    CONSTRAINT chk_garantia_resultado
        CHECK (resultado IN ('En revision', 'Reemplazado', 'Reparado', 'Rechazado'))
);

-- 10. Registro auditable de notificaciones (cliente y alerta crítica a gerencia)
CREATE TABLE notificacion (
    id_notificacion   INT AUTO_INCREMENT PRIMARY KEY,
    id_ticket         INT         NOT NULL,
    destinatario_tipo VARCHAR(20) NOT NULL,
    tipo              VARCHAR(30) NOT NULL,
    fecha_envio       DATETIME    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notificacion_ticket
        FOREIGN KEY (id_ticket) REFERENCES ticket(id_ticket) ON DELETE CASCADE,
    CONSTRAINT chk_notif_destinatario
        CHECK (destinatario_tipo IN ('Cliente', 'Gerencia')),
    CONSTRAINT chk_notif_tipo
        CHECK (tipo IN ('Creacion', 'Cambio Estado', 'Alerta Critica', 'Cierre'))
);

-- Vista de apoyo: deriva el estado actual desde historial_estado sin violar 3FN
CREATE VIEW v_ticket_estado_actual AS
SELECT
    id_ticket,
    estado     AS estado_actual,
    fecha_hora AS fecha_ultimo_estado,
    id_agente  AS ultimo_agente
FROM (
    SELECT
        h.id_ticket,
        h.estado,
        h.fecha_hora,
        h.id_agente,
        ROW_NUMBER() OVER (
            PARTITION BY h.id_ticket
            ORDER BY h.fecha_hora DESC, h.id_historial DESC
        ) AS rn
    FROM historial_estado h
) AS ranked
WHERE rn = 1;