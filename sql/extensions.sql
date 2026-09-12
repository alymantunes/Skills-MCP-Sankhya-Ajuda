-- =====================================================================
-- Extensoes exigidas pelo schema — criadas ANTES dele.
--
-- `schema.sql` diz no proprio cabecalho que `vector`, `unaccent` e `pg_trgm`
-- sao instaladas por `scripts/setup_db.sh` como superusuario antes que ele
-- rode. Isso vale no caminho do Cenario #2 (Postgres existente, setup_db.sh na
-- mao), mas NAO no caminho do Docker: o compose monta `schema.sql` direto em
-- `/docker-entrypoint-initdb.d/` e o setup_db.sh nunca entra na historia.
--
-- O resultado era o init morrer na primeira instrucao:
--
--     ERROR: text search dictionary "unaccent" does not exist
--
-- e — pior que o erro — deixar o volume com um banco PELA METADE. Na subida
-- seguinte o entrypoint ve o diretorio populado, imprime "Skipping
-- initialization" e segue: o banco fica sem as tabelas, sem erro novo, e o
-- sintoma vira "o MCP nao acha nada" em vez de "o banco nao subiu".
--
-- Este arquivo e montado como `00-extensions.sql`: o initdb executa em ordem
-- de nome, entao ele vem antes de `01-schema.sql`. `IF NOT EXISTS` em todas,
-- para continuar valendo em banco que ja as tenha.
-- =====================================================================

CREATE EXTENSION IF NOT EXISTS vector;
CREATE EXTENSION IF NOT EXISTS unaccent;
CREATE EXTENSION IF NOT EXISTS pg_trgm;
