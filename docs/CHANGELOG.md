# CHANGELOG · Cambios relevantes desde la Entrega 1

La Entrega 1 está en <https://github.com/emg46408-cmd/Proyecto-entrega-1-.git>. Este repositorio corresponde a la Entrega 2.

## v1.0-e2 · Entrega 2

### Se mantiene

- El mismo caso PYME (Dinecom y su mesa de servicio Dinecom Care) y el mismo equipo.
- Los tres niveles de escalamiento (N1, N2 y N3) y las 8 entidades centrales del modelo de la Entrega 1.

### Motor de base de datos

- **Antes:** PostgreSQL en Docker, como stack tentativo.
- **Ahora:** MySQL 8.0 (MySQL Workbench). Facilita reproducir el trabajo en un entorno limpio y es compatible con la herramienta del curso. Los scripts requieren MySQL 8.0.16 o superior para que se apliquen las restricciones `CHECK`.

### Modelo de datos (3FN)

- Se separó la tabla catálogo `rol_agente`: `agente` mezclaba el rol y el nivel de atención, lo que dejaba una dependencia transitiva.
- Se creó `prioridad_sla` (`Critica` 4 h, `Alta` 8 h, `Media` 16 h, `Baja` 24 h) con el indicador `requiere_alerta_gerencia`. Habilita el cálculo de SLA y las alertas críticas (RF3).
- Se eliminó `estado_actual` de `ticket` para evitar que se desincronice del historial. El estado vigente se obtiene con la vista `v_ticket_estado_actual`.
- Se formalizaron todas las cardinalidades, incluida `notificacion`, que audita los correos al cliente y las alertas a gerencia.
- Resultado: 10 tablas y 1 vista. Los valores de catálogo se guardan sin tildes para ser compatibles con las restricciones `CHECK`.

### Base de datos y consultas

- Scripts nuevos en `db/`: `schema.sql`, `seed.sql` (datos sintéticos: 15 tickets, 12 notificaciones) y `queries.sql` (consultas Q1 a Q4).
- Las consultas están interpretadas en [`docs/04-sql-consultas.md`](04-sql-consultas.md).

### BPMN

- Se separó el carril de la Gerencia de Servicios (N3) y el Fabricante quedó como participante aparte.
- Se agregó la compuerta «¿Caso crítico?» y la alerta automática al Gerente (RF3).
- Se agregó el correo al cliente al crear el ticket (RF8).
- Se marcaron las tareas automáticas A1 a A6.

### Automatización

- Flujo de n8n `Dinecom_Care_Nuevo_Ticket` (8 nodos), exportado en `n8n/`. Implementa A1, A2 y A4; A3 es parcial y A5 y A6 quedaron diseñadas en el BPMN, pero sin implementar.

### Requerimientos y documentación

- Los 8 requisitos funcionales y los 5 no funcionales se documentan en [`01-requerimientos.md`](01-requerimientos.md), con su cobertura real en esta entrega.
- Se agregaron `README.md` (con la prueba de reproducción), la carpeta `docs/`, la declaración de uso de IA y el informe en `informe/`.
