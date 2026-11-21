
USE dinecom_sig;

-- CONSULTA 1: Porcentaje de resolución en N1 vs. referencia E1 (60-65%)
SELECT
    t.nivel_escalamiento,
    COUNT(*) AS tickets_cerrados,
    ROUND(
        100.0 * COUNT(*) / (SELECT COUNT(*) FROM ticket WHERE fecha_cierre IS NOT NULL),
        2
    ) AS porcentaje_resolucion
FROM ticket t
WHERE t.fecha_cierre IS NOT NULL
GROUP BY t.nivel_escalamiento
ORDER BY t.nivel_escalamiento;


-- CONSULTA 2A: MTTR promedio (horas) por nivel de escalamiento
SELECT
    t.nivel_escalamiento,
    COUNT(*) AS tickets_cerrados,
    ROUND(
        AVG(TIMESTAMPDIFF(MINUTE, t.fecha_creacion, t.fecha_cierre) / 60.0),
        2
    ) AS mttr_horas
FROM ticket t
WHERE t.fecha_cierre IS NOT NULL
GROUP BY t.nivel_escalamiento
ORDER BY t.nivel_escalamiento;


-- CONSULTA 2B: MTTR promedio (horas) por cliente
SELECT
    c.razon_social,
    COUNT(t.id_ticket) AS tickets_cerrados,
    ROUND(
        AVG(TIMESTAMPDIFF(MINUTE, t.fecha_creacion, t.fecha_cierre) / 60.0),
        2
    ) AS mttr_horas
FROM ticket t
JOIN sala s    ON t.id_sala = s.id_sala
JOIN cliente c ON s.id_cliente = c.id_cliente
WHERE t.fecha_cierre IS NOT NULL
GROUP BY c.razon_social
ORDER BY mttr_horas DESC;


-- CONSULTA 3A: Detalle de tickets cerrados que incumplieron el SLA
SELECT
    t.id_ticket AS folio,
    c.razon_social AS cliente,
    p.nombre_prioridad AS prioridad,
    t.nivel_escalamiento,
    p.sla_horas,
    ROUND(TIMESTAMPDIFF(MINUTE, t.fecha_creacion, t.fecha_cierre) / 60.0, 2) AS horas_resolucion,
    ROUND((TIMESTAMPDIFF(MINUTE, t.fecha_creacion, t.fecha_cierre) / 60.0) - p.sla_horas, 2) AS exceso_horas
FROM ticket t
JOIN sala s          ON t.id_sala = s.id_sala
JOIN cliente c       ON s.id_cliente = c.id_cliente
JOIN prioridad_sla p ON t.id_prioridad = p.id_prioridad
WHERE t.fecha_cierre IS NOT NULL
  AND (TIMESTAMPDIFF(MINUTE, t.fecha_creacion, t.fecha_cierre) / 60.0) > p.sla_horas
ORDER BY exceso_horas DESC;


-- CONSULTA 3B: Tasa global de cumplimiento de SLA (%)
SELECT
    COUNT(*) AS total_cerrados,
    SUM(
        CASE
            WHEN (TIMESTAMPDIFF(MINUTE, t.fecha_creacion, t.fecha_cierre) / 60.0) <= p.sla_horas
            THEN 1 ELSE 0
        END
    ) AS dentro_sla,
    ROUND(
        100.0 * SUM(
            CASE
                WHEN (TIMESTAMPDIFF(MINUTE, t.fecha_creacion, t.fecha_cierre) / 60.0) <= p.sla_horas
                THEN 1 ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS pct_cumplimiento_sla
FROM ticket t
JOIN prioridad_sla p ON t.id_prioridad = p.id_prioridad
WHERE t.fecha_cierre IS NOT NULL;


-- CONSULTA 4: Tickets activos y garantías en curso (tablero operativo)
SELECT
    t.id_ticket AS folio,
    c.razon_social AS cliente,
    s.nombre_sala,
    p.nombre_prioridad AS prioridad,
    v.estado_actual,
    t.nivel_escalamiento,
    a.nombre AS agente_asignado,
    COALESCE(CONCAT(g.fabricante, ' (', g.resultado, ')'), 'Sin garantia') AS estado_garantia
FROM ticket t
JOIN v_ticket_estado_actual v ON t.id_ticket = v.id_ticket
JOIN sala s                   ON t.id_sala = s.id_sala
JOIN cliente c                ON s.id_cliente = c.id_cliente
JOIN prioridad_sla p          ON t.id_prioridad = p.id_prioridad
JOIN agente a                 ON t.id_agente_asignado = a.id_agente
LEFT JOIN garantia g          ON t.id_ticket = g.id_ticket
WHERE v.estado_actual <> 'Cerrado'
ORDER BY p.sla_horas ASC, t.fecha_creacion ASC;