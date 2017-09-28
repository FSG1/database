SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

ALTER DATABASE fmms OWNER TO fmms;

DROP SCHEMA IF EXISTS public;
DROP SCHEMA IF EXISTS descriptions;
DROP SCHEMA IF EXISTS study;
DROP SCHEMA IF EXISTS users;