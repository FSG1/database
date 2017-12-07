
CREATE OR REPLACE FUNCTION study.update_owner() RETURNS void AS $$
DECLARE
    statements CURSOR FOR
        SELECT schemaname, tablename FROM pg_tables
        WHERE schemaname IN ('study');
BEGIN
    FOR stmt IN statements LOOP
        EXECUTE 'ALTER TABLE ' || quote_ident(stmt.schemaname) || '.' || quote_ident(stmt.tablename) || ' OWNER TO module;';
    END LOOP;
END;
$$ LANGUAGE plpgsql;

BEGIN;
SELECT study.update_owner();
COMMIT;

DROP FUNCTION study.update_owner();
