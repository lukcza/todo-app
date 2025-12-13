BEGIN;


--
-- MIGRATION VERSION FOR todo_app
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('todo_app', '20251213144232941', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251213144232941', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
