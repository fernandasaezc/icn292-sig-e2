# 00 · Caso PYME: Dinecom y su mesa de servicio Dinecom Care

Este es el mismo caso de la Entrega 1 ([repositorio de la Entrega 1](https://github.com/emg46408-cmd/Proyecto-entrega-1-.git)); en la Entrega 2 se mantiene la PYME, el problema y el equipo.

## 1. La PYME

Dinecom es una empresa mediana del sector de equipos informáticos, con entre 11 y 50 empleados, que opera desde 2001. Es integradora de tecnologías para el acondicionamiento de salas de reunión, videoconferencia y continuidad operativa, bajo el concepto de una "sastrería de proyectos". Tiene dos dependencias en Santiago: el área de proyectos (Las Condes) y la mesa de servicio **Dinecom Care** (Providencia).

**Evidencia de existencia:** perfil corporativo oficial de la empresa en LinkedIn, sitio web `www.dinecom.cl` y canales de contacto oficiales: teléfono (02) 2 7993380 y correo de soporte `servicedesk@dinecom.cl`.

## 2. Problema de negocio

La continuidad operativa de Dinecom Care depende de un proceso manual: los tickets llegan por teléfono y correo, y un ejecutivo transcribe a mano los datos de contacto y el diagnóstico primario. Esto produce:

- Errores y datos incompletos por el registro manual y disperso (llamadas, correos y planillas).
- Falta de folio único y de registro sistemático de tiempos, por lo que el tiempo de respuesta, el tiempo medio de resolución (MTTR) y el cumplimiento del SLA no se pueden observar.
- Retraso en la derivación entre los 3 niveles de escalamiento, que se coordina manualmente.
- Dificultad para cumplir el uptime garantizado a los clientes.

Según el levantamiento de la Entrega 1, la mesa resuelve de forma remota cerca del 60 % al 65 % de los casos. Esa cifra es una referencia declarada, no una medición del sistema propuesto.

## 3. Objetivo del SIG

Implementar una plataforma centralizada tipo Help Desk que automatice el ciclo de vida de los tickets de soporte técnico: estandarizar la captura de solicitudes, enrutarlas a los técnicos según la complejidad del incidente y dar a la gerencia indicadores para evaluar el cumplimiento de los SLA.

## 4. Actores

| Actor | Rol en el caso |
| :--- | :--- |
| Cliente / usuario final | Personal de empresas clientes (Falabella, Banco de Chile, SQM, Sodimac, CAF, entre otras) que usa salas de reunión y auditorios. Detecta la falla y contacta a la mesa de servicio. |
| Operador de mesa de servicio (N1) | Recibe las solicitudes por teléfono o correo, valida los datos obligatorios y genera y asigna el ticket. |
| Técnico especialista (N2) | Interviene cuando se necesita una visita presencial en las dependencias del cliente. |
| Gerente de Servicios (N3) | Responsable del escalamiento. Se le recurre cuando un ticket no se resuelve en los niveles operativos o hay un cliente crítico. |
| SIG propuesto | Plataforma Help Desk que automatiza el ciclo de vida de los tickets y registra las métricas del servicio. |

## 5. Alcance

**Dentro del alcance**

- Registro digital y centralizado de tickets provenientes de canales digitales.
- Asignación automática de folio y categorización por niveles de escalamiento.
- Indicadores de tiempos y estado de los casos para la gerencia.
- Notificaciones automáticas por correo al cliente.

**Fuera del alcance**

- Facturación electrónica o cobro de los servicios de soporte.
- Control de inventario de repuestos y equipos en bodega.
- Aplicación móvil nativa para técnicos en terreno.

## 6. Qué se construyó en la Entrega 2

El detalle está en los demás documentos de esta carpeta: requerimientos ([01](01-requerimientos.md)), BPMN to-be final ([02](02-bpmn.md)), modelo de datos en 3FN ([03](03-modelo-datos.md)), base de datos y consultas en MySQL 8.0 ([04](04-sql-consultas.md)) y un flujo de automatización en n8n ([05](05-automatizacion-n8n.md)).
