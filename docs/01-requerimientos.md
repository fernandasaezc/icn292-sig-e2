# 01 · Requerimientos

Los requerimientos vienen de la Entrega 1 y están priorizados con la metodología MoSCoW (Must, Should, Could). La columna "Cobertura en la Entrega 2" dice qué existe hoy en el repositorio para cada uno; no se marca como cubierto lo que no está construido.

## 1. Requisitos funcionales

| N.º | Requisito | Prioridad | Cobertura en la Entrega 2 |
| :-: | :--- | :-: | :--- |
| RF1 | Registrar una solicitud con los datos de contacto, la organización mandante, el detalle del problema y la sala afectada. | Must | Tablas `contacto`, `cliente`, `sala` y `ticket` con campos obligatorios (`NOT NULL`). El flujo de n8n (tarea A1) crea el ticket al recibir la solicitud. No hay interfaz de usuario. |
| RF2 | Generar un folio único e irrepetible al crear el ticket. | Must | `ticket.id_ticket` autoincremental, usado como folio. |
| RF3 | Derivar el ticket por los niveles de soporte, con alerta automática al Gerente de Servicios en casos críticos. | Should | `ticket.nivel_escalamiento`, `rol_agente` y `prioridad_sla` (indicador `requiere_alerta_gerencia`). El flujo de n8n envía la alerta (tarea A4); la prioridad llega ya definida en la solicitud. |
| RF4 | Consultar el estado actual de un ticket (abierto, en proceso, escalado, cerrado). | Must | Vista `v_ticket_estado_actual`, que lee el último estado de `historial_estado`. La consulta Q4 la usa. No hay interfaz de consulta para clientes. |
| RF5 | Cerrar un ticket solo tras registrar la validación de la solución o el respaldo de la garantía. | Must | Estado `Cerrado` en `historial_estado` y tabla `garantia`. El cierre automático (tarea A5) no está implementado en n8n; los cierres existen en los datos del seed. |
| RF6 | Panel de control con indicadores de tickets, tiempos de respuesta y uso de las salas. | Should | Parcial: las consultas Q1 a Q4 de `db/queries.sql` entregan resolución por nivel, MTTR, cumplimiento de SLA e incidentes críticos activos. No hay panel visual ni indicador de uso de salas. |
| RF7 | Guardar una bitácora cronológica de notas y acciones durante la vida del ticket. | Could | `historial_estado` guarda estado, agente, comentario y fecha y hora de cada cambio. |
| RF8 | Enviar correos automáticos al cliente por la creación, la asignación y los cambios de estado. | Should | Tabla `notificacion`. El flujo de n8n envía el correo de ticket creado (A2). Los correos de asignación, de cambio de estado y de cierre (A6) no están implementados. |

## 2. Requisitos no funcionales

| N.º | Requisito | Prioridad | Cobertura en la Entrega 2 |
| :-: | :--- | :-: | :--- |
| RNF1 | Disponibilidad de al menos 99,5 %. | Must | No evaluado: no hay un sistema desplegado. |
| RNF2 | Procesar consultas y guardar tickets en menos de 2 segundos. | Must | No medido. |
| RNF3 | Control de acceso por roles (operador, técnico, gerente). | Must | No implementado. El flujo de n8n usa un usuario de base de datos dedicado (`n8n_user`), pero no hay autenticación por roles de aplicación. |
| RNF4 | Interfaz fácil de aprender (menos de dos horas de capacitación). | Should | No evaluado: no hay interfaz. |
| RNF5 | Escalabilidad para un aumento del 50 % del volumen de tickets. | Could | No evaluado. |

## 3. Cambios respecto a la Entrega 1

- Se agregó la **prioridad y el SLA** de cada ticket (`prioridad_sla`), que la Entrega 1 no tenía. Habilita RF3 (alertas críticas) y el cálculo del cumplimiento de SLA.
- La Entrega 1 hablaba de cinco requisitos funcionales priorizados al construir el modelo de datos; en esta entrega se documentan los ocho.
- Los demás cambios (motor de base de datos, normalización a 3FN y BPMN) están en [`CHANGELOG.md`](CHANGELOG.md).
