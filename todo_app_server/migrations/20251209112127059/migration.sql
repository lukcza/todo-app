BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "tasks" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "tasks" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "description" text NOT NULL,
    "isCompleted" boolean NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "sortOrder" bigint NOT NULL
);


--
-- MIGRATION VERSION FOR todo_app
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('todo_app', '20251209112127059', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251209112127059', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
