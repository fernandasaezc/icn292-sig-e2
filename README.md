# SIG Dinecom Care — ICN-292 · Entrega 2

Solución de Sistema de Información para la Gestión (SIG) para **Dinecom Care**, desarrollada en el ramo **ICN-292 Sistemas de Información para la Gestión** (UTFSM, 2026-2, paralelo P101).

El sistema gestiona tickets de soporte técnico y garantías de las salas de reunión de clientes corporativos, con niveles de escalamiento (N1, N2, N3), SLA por prioridad y alertas a gerencia. Este repositorio contiene la documentación, la base de datos (MySQL 8.0) y el respaldo del trabajo de la Entrega 2.

**Versión defendida:** tag `v1.0-e2`

**Integrantes:** Antonia Mena, Fernanda Sáez, Vicente Novoa, Valentina Sáez y Carlos Martínez.

## Estructura del repositorio

```text
├── README.md                    Este archivo: lógica del repositorio y prueba de oro
├── ENLACE_GITHUB.txt            URL del repositorio y tag de la versión defendida
├── assets/                      Imágenes usadas en la documentación (ER y capturas de consultas)
├── db/
│   ├── schema.sql               Crea la base dinecom_sig, sus tablas, claves y restricciones
│   ├── seed.sql                 Carga datos sintéticos coherentes con el caso
│   └── queries.sql              Consultas de negocio (Q1, Q2A, Q2B, Q3A, Q3B, Q4)
├── docs/
│   ├── 00-caso-pyme.md          Caso de la PYME
│   ├── 01-requerimientos.md     Requerimientos (adaptados de la Entrega 1)
│   ├── 02-bpmn.md               Modelo BPMN final
│   ├── 03-modelo-datos.md       Modelo E/R en 3FN
│   ├── 04-sql-consultas.md      Diseño SQL y resultados interpretados de las consultas
│   ├── 05-automatizacion-n8n.md Automatización en n8n
│   ├── DECLARACION_IA.md        Declaración de uso de inteligencia artificial
│   └── CHANGELOG.md             Cambios relevantes desde la Entrega 1
├── n8n/                         Flujo de automatización exportado (sin credenciales)
├── informe/                     Informe final en PDF y Word/LaTeX
└── presentacion/                Presentación de la defensa
```

## Prueba de oro: clonar, cargar la base y ejecutar las consultas

### Requisitos

- **MySQL 8.0.16 o superior** (desde esa versión se aplican las restricciones `CHECK`). Se probó con MySQL 26.10.0 Community Server.
- **Git**.
- Opcional: MySQL Workbench.

### 1. Clonar el repositorio

```bash
git clone https://github.com/fernandasaezc/icn292-sig-e2.git
cd icn292-sig-e2
```

### 2. Crear y cargar la base de datos

> `schema.sql` elimina y vuelve a crear la base `dinecom_sig`. Si ya existe, se pierde su contenido. Puede ejecutarse más de una vez.

**Opción A — MySQL Workbench**

1. Abrir una conexión a tu servidor MySQL 8.0.
2. Menú **File → Open SQL Script** y elegir `db/schema.sql`. Ejecutarlo con el ícono del rayo.
3. Repetir con `db/seed.sql`.

**Opción B — Línea de comandos** (desde la carpeta del repositorio)

```bash
mysql -u root -p < db/schema.sql
mysql -u root -p < db/seed.sql
```

> En Windows, usar CMD o Git Bash. PowerShell no acepta el operador `<`; en ese caso usar la Opción A.

**Verificación rápida:** la base debe quedar con 15 tickets.

```bash
mysql -u root -p -e "SELECT COUNT(*) AS tickets FROM dinecom_sig.ticket;"
```

### 3. Ejecutar las consultas

- **Workbench:** abrir `db/queries.sql` y ejecutarlo. Cada consulta devuelve su propia tabla de resultados.
- **Línea de comandos:**

```bash
mysql -u root -p < db/queries.sql
```

### Resultados esperados

| Consulta | Qué mide | Resultado |
| :--- | :--- | :--- |
| Q1 | Resolución por nivel | N1 8 tickets (61,54 %), N2 3 (23,08 %), N3 2 (15,38 %) |
| Q2A | MTTR por nivel | N1 1,31 h · N2 6,17 h · N3 51,00 h |
| Q2B | MTTR por cliente | CAF 25,25 h · Falabella 14,31 h · SQM 4,00 h · Sodimac 3,63 h · Banco de Chile 2,67 h |
| Q3A | Tickets fuera de SLA | Folios 12, 13 y 9 |
| Q3B | Cumplimiento de SLA | 10 de 13 tickets cerrados (76,92 %) |
| Q4 | Críticos activos | Folios 14 y 15 |

La interpretación de cada resultado y las capturas están en [`docs/04-sql-consultas.md`](docs/04-sql-consultas.md).

## Datos

Los datos de `db/seed.sql` son **sintéticos**. El nombre del Gerente de Servicios corresponde a la persona del caso; su correo y el resto de los datos son ficticios. Los porcentajes y promedios ilustran el funcionamiento del modelo, no el desempeño real de la empresa.

## Documentación

- [00 · Caso PYME](docs/00-caso-pyme.md)
- [01 · Requerimientos](docs/01-requerimientos.md)
- [02 · BPMN](docs/02-bpmn.md)
- [03 · Modelo de datos](docs/03-modelo-datos.md)
- [04 · SQL y consultas](docs/04-sql-consultas.md)
- [05 · Automatización n8n](docs/05-automatizacion-n8n.md)
- [Declaración de uso de IA](docs/DECLARACION_IA.md)
- [Changelog desde la Entrega 1](docs/CHANGELOG.md)
