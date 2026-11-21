
USE dinecom_sig;

INSERT INTO cliente (id_cliente, razon_social, rubro) VALUES
(1, 'Falabella S.A.',          'Retail'),
(2, 'Banco de Chile',          'Banca y Finanzas'),
(3, 'SQM S.A.',                'Mineria'),
(4, 'Sodimac S.A.',            'Retail y Construccion'),
(5, 'CAF Banco de Desarrollo', 'Financiero Institucional');

INSERT INTO contacto (id_contacto, id_cliente, nombre, cargo, correo, celular) VALUES
(1, 1, 'Carolina Mendez', 'Jefa Soporte TI',              'cmendez@cliente-falabella.cl', '+56981001001'),
(2, 1, 'Rodrigo Silva',   'Analista Infraestructura',     'rsilva@cliente-falabella.cl',  '+56981001002'),
(3, 2, 'Marcela Fuentes', 'Coordinadora Directorio',      'mfuentes@cliente-bchile.cl',   '+56982002001'),
(4, 3, 'Andres Paredes',  'Ingeniero TI Operaciones',     'aparedes@cliente-sqm.cl',      '+56983003001'),
(5, 4, 'Paula Contreras', 'Encargada Salas Corporativas', 'pcontreras@cliente-sodimac.cl','+56984004001'),
(6, 5, 'Felipe Araya',    'Especialista TI',              'faraya@cliente-caf.cl',        '+56985005001');

INSERT INTO sala (id_sala, id_cliente, nombre_sala, ubicacion) VALUES
(1, 1, 'Sala Directorio Piso 20',    'Edificio Catedral, Santiago'),
(2, 1, 'Sala Reunion 14B',           'Edificio Catedral, Santiago'),
(3, 2, 'Salon Directorio Principal', 'Casa Matriz Ahumada, Santiago'),
(4, 2, 'Sala Comite Riesgo',         'Casa Matriz Ahumada, Santiago'),
(5, 3, 'Sala Monitoreo Norte',       'Oficina Corporativa Las Condes'),
(6, 4, 'Sala Capacitacion Central',  'Casa Matriz Renca'),
(7, 5, 'Auditorio Institucional',    'Oficina Las Condes');

INSERT INTO rol_agente (id_rol, nombre_rol, nivel_atencion) VALUES
(1, 'Operador Mesa de Servicio',    'N1'),
(2, 'Tecnico Especialista Terreno', 'N2'),
(3, 'Gerente de Servicios',         'N3');

INSERT INTO agente (id_agente, id_rol, nombre, correo) VALUES
(1, 1, 'Diego Rojas',      'drojas@dinecom-demo.cl'),
(2, 1, 'Camila Torres',    'ctorres@dinecom-demo.cl'),
(3, 2, 'Matias Vega',      'mvega@dinecom-demo.cl'),
(4, 2, 'Ignacio Morales',  'imorales@dinecom-demo.cl'),
(5, 3, 'Cristian Cornejo', 'ccornejo@dinecom-demo.cl');

INSERT INTO prioridad_sla (id_prioridad, nombre_prioridad, sla_horas, requiere_alerta_gerencia) VALUES
(1, 'Critica', 4,  TRUE),
(2, 'Alta',    8,  FALSE),
(3, 'Media',   16, FALSE),
(4, 'Baja',    24, FALSE);

INSERT INTO ticket (
    id_ticket, id_contacto, id_sala, id_agente_asignado, id_prioridad,
    canal_origen, detalle_problema, diagnostico_primario, nivel_escalamiento,
    fecha_creacion, fecha_cierre
) VALUES
-- 8 tickets resueltos en N1 (soporte remoto)
(1,  1, 1, 1, 1, 'Telefono', 'Sin senal HDMI en pantalla principal previo a reunion', 'Cable HDMI desconectado tras aseo',                'N1', '2026-10-01 08:30:00', '2026-10-01 09:15:00'),
(2,  2, 2, 2, 3, 'Correo',   'Tableta de agendamiento fuera de linea',                'Reinicio remoto de panel tactil',                  'N1', '2026-10-02 10:00:00', '2026-10-02 11:30:00'),
(3,  3, 3, 1, 1, 'Telefono', 'Audio con eco en videoconferencia Teams',               'Reconfiguracion remota microfono cielo',           'N1', '2026-10-03 09:00:00', '2026-10-03 10:00:00'),
(4,  4, 5, 2, 2, 'Correo',   'Falla enlace interoperabilidad Pexip con Zoom',         'Ajuste de credenciales sala en panel Pexip',       'N1', '2026-10-05 14:00:00', '2026-10-05 16:00:00'),
(5,  5, 6, 1, 3, 'Web',      'Usuario no logra proyectar desde notebook',             'Puerto USB bloqueado; guia por app web',           'N1', '2026-10-06 11:00:00', '2026-10-06 11:45:00'),
(6,  6, 7, 2, 2, 'Correo',   'Camara IA no realiza encuadre automatico',              'Actualizacion remota firmware camara',             'N1', '2026-10-07 15:00:00', '2026-10-07 17:30:00'),
(7,  1, 2, 1, 4, 'Web',      'Duda configuracion escenas de domotica',                'Capacitacion breve via telefonica',                'N1', '2026-10-08 09:30:00', '2026-10-08 10:30:00'),
(8,  3, 4, 2, 1, 'Telefono', 'Sala no responde al boton unirse en Outlook',           'Desincronizacion calendario; resuelto remoto',     'N1', '2026-10-09 08:00:00', '2026-10-09 09:00:00'),
-- 3 tickets resueltos en N2 (visita en terreno)
(9,  3, 3, 3, 1, 'Telefono', 'Distribuidor video sin salida a pantalla secundaria',   'Requiere revision fisica y recableado bajo mesa',  'N2', '2026-10-12 08:30:00', '2026-10-12 14:30:00'),
(10, 4, 5, 4, 2, 'Correo',   'Intermitencia en panel tactil de control',              'Conector de red danado en mesa',                   'N2', '2026-10-14 09:00:00', '2026-10-14 15:00:00'),
(11, 5, 6, 3, 3, 'Web',      'Microfono inalambrico sin enlace con receptor',         'Descalibracion de frecuencias en sitio',           'N2', '2026-10-16 10:00:00', '2026-10-16 16:30:00'),
-- 2 tickets resueltos en N3 (gerencia + garantía fabricante)
(12, 1, 1, 5, 1, 'Telefono', 'Falla critica en modulo de video Cisco',                'Hardware defectuoso; gestion RMA fabricante',      'N3', '2026-10-20 09:00:00', '2026-10-22 15:00:00'),
(13, 6, 7, 5, 2, 'Correo',   'Distribuidor Kramer no enciende tras corte electrico',  'Falla de placa; reemplazo bajo garantia',          'N3', '2026-10-25 10:00:00', '2026-10-27 10:00:00'),
-- 2 tickets actualmente abiertos / en curso
(14, 2, 1, 4, 1, 'Telefono', 'Caida intermitente de audio en sala directorio',        'Escalado a terreno para medicion acustica',        'N2', '2026-11-19 15:00:00', NULL),
(15, 4, 5, 5, 1, 'Correo',   'Equipo videoconferencia sin arranque de sistema',       'Escalado a N3 por garantia con fabricante Poly',   'N3', '2026-11-20 09:00:00', NULL);

INSERT INTO historial_estado (id_historial, id_ticket, id_agente, estado, comentario, fecha_hora) VALUES
(1,  1,  1, 'Abierto',    'Ingreso solicitud telefonica',                 '2026-10-01 08:30:00'),
(2,  1,  1, 'En proceso', 'Diagnostico remoto con usuario',               '2026-10-01 08:40:00'),
(3,  1,  1, 'Cerrado',    'Usuario reconecto HDMI; sala operativa',       '2026-10-01 09:15:00'),
(4,  2,  2, 'Abierto',    'Ingreso por correo servicedesk',               '2026-10-02 10:00:00'),
(5,  2,  2, 'Cerrado',    'Reinicio remoto validado',                     '2026-10-02 11:30:00'),
(6,  3,  1, 'Abierto',    'Reporte urgente previo a directorio',          '2026-10-03 09:00:00'),
(7,  3,  1, 'Cerrado',    'Calibracion remota exitosa',                   '2026-10-03 10:00:00'),
(8,  4,  2, 'Abierto',    'Solicitud enlace Pexip',                       '2026-10-05 14:00:00'),
(9,  4,  2, 'Cerrado',    'Credenciales restauradas',                     '2026-10-05 16:00:00'),
(10, 5,  1, 'Abierto',    'Ingreso portal web',                           '2026-10-06 11:00:00'),
(11, 5,  1, 'Cerrado',    'Conexion por codigo web validada',             '2026-10-06 11:45:00'),
(12, 6,  2, 'Abierto',    'Reporte camara sin tracking IA',               '2026-10-07 15:00:00'),
(13, 6,  2, 'Cerrado',    'Firmware actualizado remotamente',             '2026-10-07 17:30:00'),
(14, 7,  1, 'Abierto',    'Consulta de uso escenas',                      '2026-10-08 09:30:00'),
(15, 7,  1, 'Cerrado',    'Guia completada con usuario',                  '2026-10-08 10:30:00'),
(16, 8,  2, 'Abierto',    'Falla integracion Outlook',                    '2026-10-09 08:00:00'),
(17, 8,  2, 'Cerrado',    'Servicio de sala resincronizado',              '2026-10-09 09:00:00'),
(18, 9,  1, 'Abierto',    'Ingreso telefonico critico',                   '2026-10-12 08:30:00'),
(19, 9,  3, 'Escalado',   'Derivado a N2 para visita terreno',            '2026-10-12 09:15:00'),
(20, 9,  3, 'Cerrado',    'Cableado reemplazado y probado en sitio',      '2026-10-12 14:30:00'),
(21, 10, 2, 'Abierto',    'Ingreso por correo',                           '2026-10-14 09:00:00'),
(22, 10, 4, 'Escalado',   'Derivado a N2 terreno',                        '2026-10-14 10:00:00'),
(23, 10, 4, 'Cerrado',    'Conector RJ45 reemplazado',                    '2026-10-14 15:00:00'),
(24, 11, 1, 'Abierto',    'Ingreso web',                                  '2026-10-16 10:00:00'),
(25, 11, 3, 'Escalado',   'Derivado a N2',                                '2026-10-16 11:00:00'),
(26, 11, 3, 'Cerrado',    'Frecuencias ajustadas en sitio',               '2026-10-16 16:30:00'),
(27, 12, 1, 'Abierto',    'Falla critica en sala directorio',             '2026-10-20 09:00:00'),
(28, 12, 3, 'Escalado',   'Revision N2 confirma dano hardware',           '2026-10-20 11:00:00'),
(29, 12, 5, 'Escalado',   'Escalado a N3 gerencia y RMA Cisco',           '2026-10-20 12:00:00'),
(30, 12, 3, 'Cerrado',    'Equipo reemplazo reinstalado y validado',      '2026-10-22 15:00:00'),
(31, 13, 2, 'Abierto',    'Equipo sin energia',                           '2026-10-25 10:00:00'),
(32, 13, 5, 'Escalado',   'Gestion garantia fabricante Kramer',           '2026-10-25 13:00:00'),
(33, 13, 4, 'Cerrado',    'Unidad reemplazada y verificada',              '2026-10-27 10:00:00'),
(34, 14, 1, 'Abierto',    'Falla intermitente audio',                     '2026-11-19 15:00:00'),
(35, 14, 4, 'En proceso', 'Tecnico N2 asignado en terreno',               '2026-11-19 16:00:00'),
(36, 15, 2, 'Abierto',    'Equipo no inicia',                             '2026-11-20 09:00:00'),
(37, 15, 5, 'Escalado',   'RMA iniciado con Poly',                        '2026-11-20 10:30:00');

INSERT INTO garantia (id_garantia, id_ticket, fabricante, fecha_envio, fecha_retorno, resultado) VALUES
(1, 12, 'Cisco',  '2026-10-20', '2026-10-22', 'Reemplazado'),
(2, 13, 'Kramer', '2026-10-25', '2026-10-27', 'Reemplazado'),
(3, 15, 'Poly',   '2026-11-20', NULL,         'En revision');

INSERT INTO notificacion (id_notificacion, id_ticket, destinatario_tipo, tipo, fecha_envio) VALUES
(1, 1,  'Cliente',  'Creacion',       '2026-10-01 08:30:05'),
(2, 1,  'Gerencia', 'Alerta Critica', '2026-10-01 08:30:06'),
(3, 1,  'Cliente',  'Cierre',         '2026-10-01 09:15:10'),
(4, 9,  'Gerencia', 'Alerta Critica', '2026-10-12 08:30:05'),
(5, 9,  'Cliente',  'Cierre',         '2026-10-12 14:30:10'),
(6, 12, 'Gerencia', 'Alerta Critica', '2026-10-20 09:00:05'),
(7, 12, 'Cliente',  'Cierre',         '2026-10-22 15:00:10'),
(8, 15, 'Cliente',  'Creacion',       '2026-11-20 09:00:05'),
(9, 15, 'Gerencia', 'Alerta Critica', '2026-11-20 09:00:06');