--
-- PostgreSQL database dump
--

-- Dumped from database version 9.6.5
-- Dumped by pg_dump version 9.6.5

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: descriptions; Type: SCHEMA; Schema: -; Owner: fmms
--

CREATE SCHEMA descriptions;


ALTER SCHEMA descriptions OWNER TO fmms;

--
-- Name: SCHEMA descriptions; Type: COMMENT; Schema: -; Owner: fmms
--

COMMENT ON SCHEMA descriptions IS 'Schema contains all module description and their history.';


--
-- Name: study; Type: SCHEMA; Schema: -; Owner: fmms
--

CREATE SCHEMA study;


ALTER SCHEMA study OWNER TO fmms;

--
-- Name: SCHEMA study; Type: COMMENT; Schema: -; Owner: fmms
--

COMMENT ON SCHEMA study IS 'Schema contains all data about study programs.';


--
-- Name: users; Type: SCHEMA; Schema: -; Owner: fmms
--

CREATE SCHEMA users;


ALTER SCHEMA users OWNER TO fmms;

--
-- Name: SCHEMA users; Type: COMMENT; Schema: -; Owner: fmms
--

COMMENT ON SCHEMA users IS 'Schema contains alls user data which are needed to use the software.';


--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

-- IS 'PL/pgSQL procedural language';


SET search_path = study, pg_catalog;

--
-- Name: learninggoal_create(); Type: FUNCTION; Schema: study; Owner: fmms
--

CREATE FUNCTION learninggoal_create() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    r RECORD;
BEGIN
    -- check if sequence number does exists
    select * into r from study.learninggoal where module_id = NEW.module_id and sequenceno = NEW.sequenceno;

    IF found THEN
        return OLD;
    END IF;

    -- check if weights does not add up below 100%
    select sum(weight) as sum into r from study.learninggoal where module_id = NEW.module_id;
    if ((r.sum + NEW.weight) > 1.0) THEN
        return OLD;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION study.learninggoal_create() OWNER TO fmms;

--
-- Name: learninggoal_update(); Type: FUNCTION; Schema: study; Owner: fmms
--

CREATE FUNCTION learninggoal_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
    r RECORD;
BEGIN
    -- check if sequence number does exists
    select * into r from study.learninggoal where module_id = NEW.module_id and id != NEW.id and sequenceno = NEW.sequenceno;

    IF found THEN
        return OLD;
    END IF;

    -- check if weights does not add up below 100%
    select sum(weight) as sum into r from study.learninggoal where module_id = NEW.module_id;
    if (r.sum > 1.0) THEN
        return OLD;
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION study.learninggoal_update() OWNER TO fmms;

SET search_path = descriptions, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: author; Type: TABLE; Schema: descriptions; Owner: fmms
--

CREATE TABLE author (
    id integer NOT NULL,
    moduledescription_id integer NOT NULL,
    orig_employee_id integer,
    name text NOT NULL
);


ALTER TABLE author OWNER TO fmms;

--
-- Name: authors_id_seq; Type: SEQUENCE; Schema: descriptions; Owner: fmms
--

CREATE SEQUENCE authors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE authors_id_seq OWNER TO fmms;

--
-- Name: authors_id_seq; Type: SEQUENCE OWNED BY; Schema: descriptions; Owner: fmms
--

ALTER SEQUENCE authors_id_seq OWNED BY author.id;


--
-- Name: competence; Type: TABLE; Schema: descriptions; Owner: fmms
--

CREATE TABLE competence (
    id integer NOT NULL,
    learninggoal_id integer NOT NULL,
    architecturallayer text,
    activiy text NOT NULL,
    levelofskill smallint NOT NULL,
    orig_learninggoal_qualification_id integer
);


ALTER TABLE competence OWNER TO fmms;

--
-- Name: COLUMN competence.levelofskill; Type: COMMENT; Schema: descriptions; Owner: fmms
--

COMMENT ON COLUMN competence.levelofskill IS 'Skill Level value for activitiy entry';


--
-- Name: competence_id_seq; Type: SEQUENCE; Schema: descriptions; Owner: fmms
--

CREATE SEQUENCE competence_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE competence_id_seq OWNER TO fmms;

--
-- Name: competence_id_seq; Type: SEQUENCE OWNED BY; Schema: descriptions; Owner: fmms
--

ALTER SEQUENCE competence_id_seq OWNED BY competence.id;


--
-- Name: dependency; Type: TABLE; Schema: descriptions; Owner: fmms
--

CREATE TABLE dependency (
    id integer NOT NULL,
    moduledescription_id integer NOT NULL,
    name text NOT NULL,
    required boolean NOT NULL,
    concurrent boolean NOT NULL,
    orig_module_dependency_id integer
);


ALTER TABLE dependency OWNER TO fmms;

--
-- Name: dependency_id_seq; Type: SEQUENCE; Schema: descriptions; Owner: fmms
--

CREATE SEQUENCE dependency_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE dependency_id_seq OWNER TO fmms;

--
-- Name: dependency_id_seq; Type: SEQUENCE OWNED BY; Schema: descriptions; Owner: fmms
--

ALTER SEQUENCE dependency_id_seq OWNED BY dependency.id;


--
-- Name: learninggoal; Type: TABLE; Schema: descriptions; Owner: fmms
--

CREATE TABLE learninggoal (
    id integer NOT NULL,
    moduledescription_id integer NOT NULL,
    sequenceno smallint,
    description text NOT NULL,
    orig_learninggoal_id integer
);


ALTER TABLE learninggoal OWNER TO fmms;

--
-- Name: learninggoal_id_seq; Type: SEQUENCE; Schema: descriptions; Owner: fmms
--

CREATE SEQUENCE learninggoal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE learninggoal_id_seq OWNER TO fmms;

--
-- Name: learninggoal_id_seq; Type: SEQUENCE OWNED BY; Schema: descriptions; Owner: fmms
--

ALTER SEQUENCE learninggoal_id_seq OWNED BY learninggoal.id;


--
-- Name: moduleassessment; Type: TABLE; Schema: descriptions; Owner: fmms
--

CREATE TABLE moduleassessment (
    id integer NOT NULL,
    learninggoal_id integer NOT NULL,
    assessmenttypes text[] NOT NULL,
    grading text NOT NULL,
    weight numeric(3,2) NOT NULL,
    moduledescription_id integer NOT NULL
);


ALTER TABLE moduleassessment OWNER TO fmms;

--
-- Name: moduleassessment_id_seq; Type: SEQUENCE; Schema: descriptions; Owner: fmms
--

CREATE SEQUENCE moduleassessment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE moduleassessment_id_seq OWNER TO fmms;

--
-- Name: moduleassessment_id_seq; Type: SEQUENCE OWNED BY; Schema: descriptions; Owner: fmms
--

ALTER SEQUENCE moduleassessment_id_seq OWNED BY moduleassessment.id;


--
-- Name: moduledescription; Type: TABLE; Schema: descriptions; Owner: fmms
--

CREATE TABLE moduledescription (
    id integer NOT NULL,
    version smallint,
    module_id integer,
    creator_employee_id integer,
    created timestamp without time zone,
    semester smallint,
    credits smallint,
    validof date,
    lecturesperweek smallint,
    practicalperweek smallint,
    totaleffort smallint,
    credentials text,
    introduction text,
    teachingmaterial text,
    additionalinfo text,
    orig_moduledescription_id integer,
    architectuallayers text[] NOT NULL,
    activities text[] NOT NULL,
    assessmenttypes text[] NOT NULL,
    gradings text[] NOT NULL
);


ALTER TABLE moduledescription OWNER TO fmms;

--
-- Name: COLUMN moduledescription.architectuallayers; Type: COMMENT; Schema: descriptions; Owner: fmms
--

COMMENT ON COLUMN moduledescription.architectuallayers IS 'All possible architectual layers at the point in time when this moduledescription has been created.';


--
-- Name: COLUMN moduledescription.activities; Type: COMMENT; Schema: descriptions; Owner: fmms
--

COMMENT ON COLUMN moduledescription.activities IS 'All possible activities at the point in time when this moduledescription has been created.';


--
-- Name: COLUMN moduledescription.assessmenttypes; Type: COMMENT; Schema: descriptions; Owner: fmms
--

COMMENT ON COLUMN moduledescription.assessmenttypes IS 'All possible assessment types at the point in time this moduledescription has been created.';


--
-- Name: COLUMN moduledescription.gradings; Type: COMMENT; Schema: descriptions; Owner: fmms
--

COMMENT ON COLUMN moduledescription.gradings IS 'All possible values for grading at the time this module description is created.';


--
-- Name: moduledescription_id_seq; Type: SEQUENCE; Schema: descriptions; Owner: fmms
--

CREATE SEQUENCE moduledescription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE moduledescription_id_seq OWNER TO fmms;

--
-- Name: moduledescription_id_seq; Type: SEQUENCE OWNED BY; Schema: descriptions; Owner: fmms
--

ALTER SEQUENCE moduledescription_id_seq OWNED BY moduledescription.id;


--
-- Name: topic; Type: TABLE; Schema: descriptions; Owner: fmms
--

CREATE TABLE topic (
    id integer NOT NULL,
    moduledescription_id integer NOT NULL,
    name text NOT NULL,
    orig_module_topic_id integer
);


ALTER TABLE topic OWNER TO fmms;

--
-- Name: topic_id_seq; Type: SEQUENCE; Schema: descriptions; Owner: fmms
--

CREATE SEQUENCE topic_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE topic_id_seq OWNER TO fmms;

--
-- Name: topic_id_seq; Type: SEQUENCE OWNED BY; Schema: descriptions; Owner: fmms
--

ALTER SEQUENCE topic_id_seq OWNED BY topic.id;


SET search_path = study, pg_catalog;

--
-- Name: activity; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE activity (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text
);


ALTER TABLE activity OWNER TO fmms;

--
-- Name: activity_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE activity_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE activity_id_seq OWNER TO fmms;

--
-- Name: activity_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE activity_id_seq OWNED BY activity.id;


--
-- Name: architecturallayer; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE architecturallayer (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text
);


ALTER TABLE architecturallayer OWNER TO fmms;

--
-- Name: architectural_layer_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE architectural_layer_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE architectural_layer_id_seq OWNER TO fmms;

--
-- Name: architectural_layer_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE architectural_layer_id_seq OWNED BY architecturallayer.id;


--
-- Name: moduleassessment; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE moduleassessment (
    id integer NOT NULL,
    code character varying(10) NOT NULL,
    weight numeric(3,2),
    minimumgrade numeric(2,1) DEFAULT 5.5,
    remarks text,
    module_id integer NOT NULL,
    description text NOT NULL,
    CONSTRAINT assessment_minimum_grade_check CHECK (((minimumgrade IS NULL) OR ((minimumgrade > 0.0) AND (minimumgrade <= 10.0)))),
    CONSTRAINT assessment_weight_check CHECK (((weight >= 0.0) AND (weight <= 1.0)))
);


ALTER TABLE moduleassessment OWNER TO fmms;

--
-- Name: assessment_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE assessment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE assessment_id_seq OWNER TO fmms;

--
-- Name: assessment_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE assessment_id_seq OWNED BY moduleassessment.id;


--
-- Name: moduleasssementtype; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE moduleasssementtype (
    id integer NOT NULL,
    name character varying(100) NOT NULL
);


ALTER TABLE moduleasssementtype OWNER TO fmms;

--
-- Name: asssementtype_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE asssementtype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE asssementtype_id_seq OWNER TO fmms;

--
-- Name: asssementtype_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE asssementtype_id_seq OWNED BY moduleasssementtype.id;


--
-- Name: curriculum; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE curriculum (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text,
    startcohort smallint NOT NULL,
    owner_employee_id integer NOT NULL,
    department_id integer NOT NULL
);


ALTER TABLE curriculum OWNER TO fmms;

--
-- Name: module; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE module (
    id integer NOT NULL,
    code character varying(10) NOT NULL,
    name text NOT NULL,
    credits smallint NOT NULL,
    lecturesperweek smallint,
    practicalperweek smallint,
    totaleffort smallint NOT NULL,
    CONSTRAINT module_credits_check CHECK (((credits >= 0) AND (credits <= 30))),
    CONSTRAINT module_lectureperweek_check CHECK (((lecturesperweek IS NULL) OR (lecturesperweek >= 0))),
    CONSTRAINT module_practicalperweek_check CHECK (((practicalperweek IS NULL) OR (practicalperweek >= 0))),
    CONSTRAINT module_totalefforts_check CHECK (((totaleffort >= 0) AND (totaleffort <= (credits * 30))))
);


ALTER TABLE module OWNER TO fmms;

--
-- Name: module_profile; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE module_profile (
    id integer NOT NULL,
    module_id integer NOT NULL,
    profile_id integer NOT NULL,
    semester smallint NOT NULL,
    CONSTRAINT moduleprofile_semester_check CHECK (((semester > 0) AND (semester <= 8)))
);


ALTER TABLE module_profile OWNER TO fmms;

--
-- Name: profile; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE profile (
    id integer NOT NULL,
    curriculum_id integer,
    studyprogramme_id integer
);


ALTER TABLE profile OWNER TO fmms;

--
-- Name: studyprogramme; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE studyprogramme (
    id integer NOT NULL,
    code character varying(10) NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE studyprogramme OWNER TO fmms;

--
-- Name: curriculum_overview; Type: VIEW; Schema: study; Owner: fmms
--

CREATE VIEW curriculum_overview AS
 SELECT c.name,
    sp.code AS study_programme,
    mp.semester,
    m.code AS module_code,
    m.name AS module_name,
    m.credits,
    sp.id AS study_programme_id
   FROM profile p,
    module_profile mp,
    module m,
    curriculum c,
    studyprogramme sp
  WHERE ((p.id = mp.profile_id) AND (m.id = mp.module_id) AND (p.curriculum_id = c.id) AND (p.studyprogramme_id = sp.id))
  ORDER BY p.id, mp.semester, m.code;


ALTER TABLE curriculum_overview OWNER TO fmms;

--
-- Name: curriculum_differentiation; Type: VIEW; Schema: study; Owner: fmms
--

CREATE VIEW curriculum_differentiation AS
( SELECT curriculum_overview.name,
    curriculum_overview.semester,
    curriculum_overview.module_code,
    curriculum_overview.module_name,
    'SEBI'::text AS differentiation
   FROM curriculum_overview
  GROUP BY curriculum_overview.name, curriculum_overview.semester, curriculum_overview.module_code, curriculum_overview.module_name
 HAVING (count(*) = 2)
  ORDER BY (count(*)))
UNION
 SELECT curriculum_overview.name,
    curriculum_overview.semester,
    curriculum_overview.module_code,
    curriculum_overview.module_name,
    'SE'::text AS differentiation
   FROM curriculum_overview
  GROUP BY curriculum_overview.name, curriculum_overview.semester, curriculum_overview.module_code, curriculum_overview.module_name
 HAVING ((count(*) = 1) AND ((curriculum_overview.module_code)::text IN ( SELECT cn.module_code
           FROM curriculum_overview cn
          WHERE (((cn.name)::text = (cn.name)::text) AND ((cn.study_programme)::text = 'SE'::text)))))
UNION
 SELECT curriculum_overview.name,
    curriculum_overview.semester,
    curriculum_overview.module_code,
    curriculum_overview.module_name,
    'BI'::text AS differentiation
   FROM curriculum_overview
  GROUP BY curriculum_overview.name, curriculum_overview.semester, curriculum_overview.module_code, curriculum_overview.module_name
 HAVING ((count(*) = 1) AND ((curriculum_overview.module_code)::text IN ( SELECT cn.module_code
           FROM curriculum_overview cn
          WHERE (((cn.name)::text = (cn.name)::text) AND ((cn.study_programme)::text = 'BI'::text)))))
  ORDER BY 2, 5, 3;


ALTER TABLE curriculum_differentiation OWNER TO fmms;

--
-- Name: learninggoal; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE learninggoal (
    id integer NOT NULL,
    module_id integer NOT NULL,
    description text,
    sequenceno smallint DEFAULT 1 NOT NULL,
    weight numeric(3,2) DEFAULT NULL::numeric,
    grading_id integer,
    groupgoal boolean DEFAULT false NOT NULL,
    CONSTRAINT learninggoal_sequence_checl CHECK ((sequenceno > 0)),
    CONSTRAINT learninggoal_weight_check CHECK (((weight >= 0.0) AND (weight <= 1.0))),
    CONSTRAINT module_id_nn CHECK ((module_id IS NOT NULL))
);


ALTER TABLE learninggoal OWNER TO fmms;

--
-- Name: learninggoal_qualification; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE learninggoal_qualification (
    id integer NOT NULL,
    learninggoal_id integer,
    qualification_id integer
);


ALTER TABLE learninggoal_qualification OWNER TO fmms;

--
-- Name: levelofskill; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE levelofskill (
    id integer NOT NULL,
    level smallint NOT NULL,
    autonomy text,
    behaviour text,
    context text,
    CONSTRAINT levelofskill_level_check CHECK (((level > 0) AND (level <= 5)))
);


ALTER TABLE levelofskill OWNER TO fmms;

--
-- Name: qualification; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE qualification (
    id integer NOT NULL,
    architecturallayer_id integer,
    activity_id integer,
    levelofskill_id integer
);


ALTER TABLE qualification OWNER TO fmms;

--
-- Name: TABLE qualification; Type: COMMENT; Schema: study; Owner: fmms
--

COMMENT ON TABLE qualification IS 'Contains all possible combinations of architectural layer, activity and level of skill';


--
-- Name: clots_self_evaluation; Type: VIEW; Schema: study; Owner: fmms
--

CREATE VIEW clots_self_evaluation AS
 SELECT co.name,
    co.study_programme,
    a.name AS activity,
    al.name AS architecturallayer,
    l.level,
    lg.description,
    m.code,
    m.credits,
    co.semester,
    cd.differentiation
   FROM qualification q,
    architecturallayer al,
    activity a,
    levelofskill l,
    learninggoal lg,
    module m,
    learninggoal_qualification lgq,
    curriculum_overview co,
    curriculum_differentiation cd
  WHERE ((lg.id = lgq.learninggoal_id) AND (lgq.qualification_id = q.id) AND (q.architecturallayer_id = al.id) AND (q.activity_id = a.id) AND (q.levelofskill_id = l.id) AND (lg.module_id = m.id) AND ((m.code)::text = (co.module_code)::text) AND ((m.code)::text = (cd.module_code)::text))
  GROUP BY co.name, co.study_programme, al.name, al.id, a.id, a.name, l.level, lg.description, m.code, m.credits, co.semester, cd.differentiation
  ORDER BY co.name, co.study_programme, a.id, al.id, l.level, co.semester, m.code, lg.description, m.credits;


ALTER TABLE clots_self_evaluation OWNER TO fmms;

--
-- Name: curriculum_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE curriculum_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE curriculum_id_seq OWNER TO fmms;

--
-- Name: curriculum_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE curriculum_id_seq OWNED BY curriculum.id;


--
-- Name: department; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE department (
    id integer NOT NULL,
    name character varying(100)
);


ALTER TABLE department OWNER TO fmms;

--
-- Name: department_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE department_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE department_id_seq OWNER TO fmms;

--
-- Name: department_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE department_id_seq OWNED BY department.id;


--
-- Name: employee; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE employee (
    id integer NOT NULL,
    firstname text NOT NULL,
    lastname text NOT NULL,
    pcn integer NOT NULL,
    code character varying(5) NOT NULL,
    mail text NOT NULL,
    initials text
);


ALTER TABLE employee OWNER TO fmms;

--
-- Name: employee_department; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE employee_department (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    department_id integer NOT NULL,
    departmenthead boolean DEFAULT false NOT NULL
);


ALTER TABLE employee_department OWNER TO fmms;

--
-- Name: employee_department_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE employee_department_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE employee_department_id_seq OWNER TO fmms;

--
-- Name: employee_department_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE employee_department_id_seq OWNED BY employee_department.id;


--
-- Name: employee_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE employee_id_seq OWNER TO fmms;

--
-- Name: employee_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE employee_id_seq OWNED BY employee.id;


--
-- Name: grading; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE grading (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE grading OWNER TO fmms;

--
-- Name: grading_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE grading_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE grading_id_seq OWNER TO fmms;

--
-- Name: grading_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE grading_id_seq OWNED BY grading.id;


--
-- Name: professionaltask; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE professionaltask (
    id integer NOT NULL,
    qualification_id integer,
    description text
);


ALTER TABLE professionaltask OWNER TO fmms;

--
-- Name: hboi_matrix; Type: VIEW; Schema: study; Owner: fmms
--

CREATE VIEW hboi_matrix AS
 SELECT pt.id AS task_id,
    al.name AS layer,
    a.name AS activity,
    los.level,
    pt.description AS task
   FROM architecturallayer al,
    activity a,
    levelofskill los,
    qualification q,
    professionaltask pt
  WHERE ((a.id = q.activity_id) AND (al.id = q.architecturallayer_id) AND (los.id = q.levelofskill_id) AND (q.id = pt.qualification_id));


ALTER TABLE hboi_matrix OWNER TO fmms;

--
-- Name: learning_goal_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE learning_goal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE learning_goal_id_seq OWNER TO fmms;

--
-- Name: learning_goal_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE learning_goal_id_seq OWNED BY learninggoal.id;


--
-- Name: learning_goal_qualification_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE learning_goal_qualification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE learning_goal_qualification_id_seq OWNER TO fmms;

--
-- Name: learning_goal_qualification_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE learning_goal_qualification_id_seq OWNED BY learninggoal_qualification.id;


--
-- Name: level_of_skill_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE level_of_skill_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE level_of_skill_id_seq OWNER TO fmms;

--
-- Name: level_of_skill_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE level_of_skill_id_seq OWNED BY levelofskill.id;


--
-- Name: module_employee; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE module_employee (
    id integer NOT NULL,
    module_id integer NOT NULL,
    employee_id integer NOT NULL
);


ALTER TABLE module_employee OWNER TO fmms;

--
-- Name: module_employee_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE module_employee_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE module_employee_id_seq OWNER TO fmms;

--
-- Name: module_employee_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE module_employee_id_seq OWNED BY module_employee.id;


--
-- Name: module_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE module_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE module_id_seq OWNER TO fmms;

--
-- Name: module_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE module_id_seq OWNED BY module.id;


--
-- Name: module_max_qualification; Type: VIEW; Schema: study; Owner: fmms
--

CREATE VIEW module_max_qualification AS
 SELECT m.code,
    m.name,
    al.name AS al_name,
    a.id AS a_id,
    a.name AS a_name,
    max(l.level) AS max
   FROM module m,
    learninggoal lg,
    learninggoal_qualification lgq,
    qualification q,
    architecturallayer al,
    activity a,
    levelofskill l
  WHERE ((m.id = lg.module_id) AND (lg.id = lgq.learninggoal_id) AND (lgq.qualification_id = q.id) AND (q.architecturallayer_id = al.id) AND (q.activity_id = a.id) AND (q.levelofskill_id = l.id))
  GROUP BY m.code, m.name, al.id, al.name, a.id, a.name
  ORDER BY m.code, al.id, a.id;


ALTER TABLE module_max_qualification OWNER TO fmms;

--
-- Name: moduledependency; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE moduledependency (
    id integer NOT NULL,
    module_id integer NOT NULL,
    dependency_module_id integer NOT NULL,
    mandatory boolean DEFAULT false NOT NULL,
    concurrent boolean DEFAULT false NOT NULL,
    CONSTRAINT dependency_concurrent_check CHECK (((concurrent = false) OR (mandatory = false))),
    CONSTRAINT ids_not_null CHECK (((module_id IS NOT NULL) AND (dependency_module_id IS NOT NULL)))
);


ALTER TABLE moduledependency OWNER TO fmms;

--
-- Name: COLUMN moduledependency.module_id; Type: COMMENT; Schema: study; Owner: fmms
--

COMMENT ON COLUMN moduledependency.module_id IS 'The module we are currently talking about.';


--
-- Name: COLUMN moduledependency.dependency_module_id; Type: COMMENT; Schema: study; Owner: fmms
--

COMMENT ON COLUMN moduledependency.dependency_module_id IS 'A module which has to be passed prior to the module in "module id".';


--
-- Name: module_predecessors_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE module_predecessors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE module_predecessors_id_seq OWNER TO fmms;

--
-- Name: module_predecessors_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE module_predecessors_id_seq OWNED BY moduledependency.id;


--
-- Name: module_profile_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE module_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE module_profile_id_seq OWNER TO fmms;

--
-- Name: module_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE module_profile_id_seq OWNED BY module_profile.id;


--
-- Name: moduletopic; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE moduletopic (
    id integer NOT NULL,
    module_id integer,
    sequenceno smallint DEFAULT 1 NOT NULL,
    description text NOT NULL,
    CONSTRAINT module_id_nn CHECK ((module_id IS NOT NULL)),
    CONSTRAINT topic_sequence_check CHECK ((sequenceno > 0))
);


ALTER TABLE moduletopic OWNER TO fmms;

--
-- Name: module_topics_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE module_topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE module_topics_id_seq OWNER TO fmms;

--
-- Name: module_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE module_topics_id_seq OWNED BY moduletopic.id;


--
-- Name: moduleassessment_learninggoal; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE moduleassessment_learninggoal (
    id integer NOT NULL,
    moduleassessment_id integer NOT NULL,
    learninggoal_id integer NOT NULL
);


ALTER TABLE moduleassessment_learninggoal OWNER TO fmms;

--
-- Name: moduleassessment_learninggoal_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE moduleassessment_learninggoal_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE moduleassessment_learninggoal_id_seq OWNER TO fmms;

--
-- Name: moduleassessment_learninggoal_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE moduleassessment_learninggoal_id_seq OWNED BY moduleassessment_learninggoal.id;


--
-- Name: moduleassessment_moduleassessmenttype; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE moduleassessment_moduleassessmenttype (
    id integer NOT NULL,
    moduleassessment_id integer NOT NULL,
    moduleassessmenttype_id integer NOT NULL
);


ALTER TABLE moduleassessment_moduleassessmenttype OWNER TO fmms;

--
-- Name: moduleassessment_moduleassessmenttype_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE moduleassessment_moduleassessmenttype_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE moduleassessment_moduleassessmenttype_id_seq OWNER TO fmms;

--
-- Name: moduleassessment_moduleassessmenttype_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE moduleassessment_moduleassessmenttype_id_seq OWNED BY moduleassessment_moduleassessmenttype.id;


--
-- Name: moduledescription; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE moduledescription (
    id integer NOT NULL,
    module_id integer NOT NULL,
    introduction text,
    teachingmaterial text,
    additionalinfo text,
    credentials text,
    validof date
);


ALTER TABLE moduledescription OWNER TO fmms;

--
-- Name: moduledescription_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE moduledescription_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE moduledescription_id_seq OWNER TO fmms;

--
-- Name: moduledescription_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE moduledescription_id_seq OWNED BY moduledescription.id;


--
-- Name: professional_task_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE professional_task_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE professional_task_id_seq OWNER TO fmms;

--
-- Name: professional_task_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE professional_task_id_seq OWNED BY professionaltask.id;


--
-- Name: profile_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE profile_id_seq OWNER TO fmms;

--
-- Name: profile_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE profile_id_seq OWNED BY profile.id;


--
-- Name: profile_qualification; Type: TABLE; Schema: study; Owner: fmms
--

CREATE TABLE profile_qualification (
    id integer NOT NULL,
    profile_id integer,
    qualification_id integer
);


ALTER TABLE profile_qualification OWNER TO fmms;

--
-- Name: profile_qualification_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE profile_qualification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE profile_qualification_id_seq OWNER TO fmms;

--
-- Name: profile_qualification_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE profile_qualification_id_seq OWNED BY profile_qualification.id;


--
-- Name: qualification_description; Type: VIEW; Schema: study; Owner: fmms
--

CREATE VIEW qualification_description AS
 SELECT q.id AS q_id,
    al.name AS al_name,
    a.name AS a_name,
    l.level
   FROM qualification q,
    architecturallayer al,
    activity a,
    levelofskill l
  WHERE ((q.architecturallayer_id = al.id) AND (q.activity_id = a.id) AND (q.levelofskill_id = l.id));


ALTER TABLE qualification_description OWNER TO fmms;

--
-- Name: qualification_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE qualification_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE qualification_id_seq OWNER TO fmms;

--
-- Name: qualification_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE qualification_id_seq OWNED BY qualification.id;


--
-- Name: qualification_match_learning_goals; Type: VIEW; Schema: study; Owner: fmms
--

CREATE VIEW qualification_match_learning_goals AS
 SELECT q.id AS q_id,
    al.name AS al_name,
    a.name AS a_name,
    l.level,
    lg.description,
    m.code
   FROM qualification q,
    architecturallayer al,
    activity a,
    levelofskill l,
    learninggoal lg,
    module m,
    learninggoal_qualification lgq
  WHERE ((lg.id = lgq.learninggoal_id) AND (lgq.qualification_id = q.id) AND (q.architecturallayer_id = al.id) AND (q.activity_id = a.id) AND (q.levelofskill_id = l.id) AND (lg.module_id = m.id))
  GROUP BY q.id, al.id, al.name, a.id, a.name, l.level, lg.description, m.code
  ORDER BY al.id, a.id, l.level, lg.description, m.code;


ALTER TABLE qualification_match_learning_goals OWNER TO fmms;

--
-- Name: qualification_match_modules; Type: VIEW; Schema: study; Owner: fmms
--

CREATE VIEW qualification_match_modules AS
 SELECT q.id AS q_id,
    al.name AS al_name,
    a.name AS a_name,
    l.level,
    m.code AS module_code,
    m.name AS module_name
   FROM qualification q,
    architecturallayer al,
    activity a,
    levelofskill l,
    learninggoal lg,
    learninggoal_qualification lgq,
    module m
  WHERE ((m.id = lg.module_id) AND (lg.id = lgq.learninggoal_id) AND (lgq.qualification_id = q.id) AND (q.architecturallayer_id = al.id) AND (q.activity_id = a.id) AND (q.levelofskill_id = l.id))
  GROUP BY q.id, al.id, al.name, a.id, a.name, l.level, m.code, m.name
  ORDER BY al.id, a.id, l.level, m.code;


ALTER TABLE qualification_match_modules OWNER TO fmms;

--
-- Name: qualifications_after_semester; Type: VIEW; Schema: study; Owner: fmms
--

CREATE VIEW qualifications_after_semester AS
 SELECT DISTINCT c.name AS curriculum,
    sp.code AS study_programme,
    mp.semester AS after_semester,
    al.id AS al_id,
    al.name,
    ( SELECT max(mmq.max) AS max
           FROM module_max_qualification mmq
          WHERE (((mmq.al_name)::text = (al.name)::text) AND (mmq.a_id = 1) AND ((mmq.code)::text IN ( SELECT co.module_code
                   FROM curriculum_overview co
                  WHERE ((co.semester <= mp.semester) AND ((co.name)::text = (c.name)::text) AND ((co.study_programme)::text = (sp.code)::text)))))) AS manage,
    ( SELECT max(mmq.max) AS max
           FROM module_max_qualification mmq
          WHERE (((mmq.al_name)::text = (al.name)::text) AND (mmq.a_id = 2) AND ((mmq.code)::text IN ( SELECT co.module_code
                   FROM curriculum_overview co
                  WHERE ((co.semester <= mp.semester) AND ((co.name)::text = (c.name)::text) AND ((co.study_programme)::text = (sp.code)::text)))))) AS "analyse",
    ( SELECT max(mmq.max) AS max
           FROM module_max_qualification mmq
          WHERE (((mmq.al_name)::text = (al.name)::text) AND (mmq.a_id = 3) AND ((mmq.code)::text IN ( SELECT co.module_code
                   FROM curriculum_overview co
                  WHERE ((co.semester <= mp.semester) AND ((co.name)::text = (c.name)::text) AND ((co.study_programme)::text = (sp.code)::text)))))) AS advise,
    ( SELECT max(mmq.max) AS max
           FROM module_max_qualification mmq
          WHERE (((mmq.al_name)::text = (al.name)::text) AND (mmq.a_id = 4) AND ((mmq.code)::text IN ( SELECT co.module_code
                   FROM curriculum_overview co
                  WHERE ((co.semester <= mp.semester) AND ((co.name)::text = (c.name)::text) AND ((co.study_programme)::text = (sp.code)::text)))))) AS design,
    ( SELECT max(mmq.max) AS max
           FROM module_max_qualification mmq
          WHERE (((mmq.al_name)::text = (al.name)::text) AND (mmq.a_id = 5) AND ((mmq.code)::text IN ( SELECT co.module_code
                   FROM curriculum_overview co
                  WHERE ((co.semester <= mp.semester) AND ((co.name)::text = (c.name)::text) AND ((co.study_programme)::text = (sp.code)::text)))))) AS implement,
    ( SELECT max(mmq.max) AS max
           FROM module_max_qualification mmq
          WHERE (((mmq.al_name)::text = (al.name)::text) AND (mmq.a_id = 6) AND ((mmq.code)::text IN ( SELECT co.module_code
                   FROM curriculum_overview co
                  WHERE ((co.semester <= mp.semester) AND ((co.name)::text = (c.name)::text) AND ((co.study_programme)::text = (sp.code)::text)))))) AS prof_beh,
    ( SELECT max(mmq.max) AS max
           FROM module_max_qualification mmq
          WHERE (((mmq.al_name)::text = (al.name)::text) AND (mmq.a_id = 7) AND ((mmq.code)::text IN ( SELECT co.module_code
                   FROM curriculum_overview co
                  WHERE ((co.semester <= mp.semester) AND ((co.name)::text = (c.name)::text) AND ((co.study_programme)::text = (sp.code)::text)))))) AS research_skills
   FROM profile p,
    module_profile mp,
    module m,
    curriculum c,
    studyprogramme sp,
    architecturallayer al
  WHERE ((p.id = mp.profile_id) AND (m.id = mp.module_id) AND (p.curriculum_id = c.id) AND (p.studyprogramme_id = sp.id))
  ORDER BY c.name, sp.code, mp.semester, al.id;


ALTER TABLE qualifications_after_semester OWNER TO fmms;

--
-- Name: qualifications_learning_goals; Type: VIEW; Schema: study; Owner: fmms
--

CREATE VIEW qualifications_learning_goals AS
 SELECT qd.q_id,
    qd.al_name,
    qd.a_name,
    qd.level,
    qml.description,
    qml.code
   FROM (qualification_description qd
     LEFT JOIN qualification_match_learning_goals qml ON ((qd.q_id = qml.q_id)))
  ORDER BY qd.q_id, qd.al_name, qd.a_name, qd.level, qml.description, qml.code;


ALTER TABLE qualifications_learning_goals OWNER TO fmms;

--
-- Name: qualifications_modules; Type: VIEW; Schema: study; Owner: fmms
--

CREATE VIEW qualifications_modules AS
 SELECT qd.q_id,
    qd.al_name,
    qd.a_name,
    qd.level,
    qmm.module_code
   FROM (qualification_description qd
     LEFT JOIN qualification_match_modules qmm ON ((qd.q_id = qmm.q_id)))
  ORDER BY qd.q_id, qd.al_name, qd.a_name, qd.level, qmm.module_code;


ALTER TABLE qualifications_modules OWNER TO fmms;

--
-- Name: study_programme_id_seq; Type: SEQUENCE; Schema: study; Owner: fmms
--

CREATE SEQUENCE study_programme_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE study_programme_id_seq OWNER TO fmms;

--
-- Name: study_programme_id_seq; Type: SEQUENCE OWNED BY; Schema: study; Owner: fmms
--

ALTER SEQUENCE study_programme_id_seq OWNED BY studyprogramme.id;


SET search_path = users, pg_catalog;

--
-- Name: accessright; Type: TABLE; Schema: users; Owner: fmms
--

CREATE TABLE accessright (
    id integer NOT NULL,
    role_id integer,
    curriculum boolean DEFAULT false NOT NULL,
    department boolean DEFAULT false NOT NULL,
    modules boolean DEFAULT false NOT NULL
);


ALTER TABLE accessright OWNER TO fmms;

--
-- Name: accessright_id_seq; Type: SEQUENCE; Schema: users; Owner: fmms
--

CREATE SEQUENCE accessright_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE accessright_id_seq OWNER TO fmms;

--
-- Name: accessright_id_seq; Type: SEQUENCE OWNED BY; Schema: users; Owner: fmms
--

ALTER SEQUENCE accessright_id_seq OWNED BY accessright.id;


--
-- Name: role; Type: TABLE; Schema: users; Owner: fmms
--

CREATE TABLE role (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE role OWNER TO fmms;

--
-- Name: role_id_seq; Type: SEQUENCE; Schema: users; Owner: fmms
--

CREATE SEQUENCE role_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE role_id_seq OWNER TO fmms;

--
-- Name: role_id_seq; Type: SEQUENCE OWNED BY; Schema: users; Owner: fmms
--

ALTER SEQUENCE role_id_seq OWNED BY role.id;


--
-- Name: user; Type: TABLE; Schema: users; Owner: fmms
--

CREATE TABLE "user" (
    id integer NOT NULL,
    employee_id integer NOT NULL,
    username text NOT NULL,
    password text,
    lastlogin timestamp without time zone
);


ALTER TABLE "user" OWNER TO fmms;

--
-- Name: user_id_seq; Type: SEQUENCE; Schema: users; Owner: fmms
--

CREATE SEQUENCE user_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE user_id_seq OWNER TO fmms;

--
-- Name: user_id_seq; Type: SEQUENCE OWNED BY; Schema: users; Owner: fmms
--

ALTER SEQUENCE user_id_seq OWNED BY "user".id;


--
-- Name: user_role; Type: TABLE; Schema: users; Owner: fmms
--

CREATE TABLE user_role (
    id integer NOT NULL,
    user_id integer NOT NULL,
    role_id integer NOT NULL
);


ALTER TABLE user_role OWNER TO fmms;

SET search_path = descriptions, pg_catalog;

--
-- Name: author id; Type: DEFAULT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY author ALTER COLUMN id SET DEFAULT nextval('authors_id_seq'::regclass);


--
-- Name: competence id; Type: DEFAULT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY competence ALTER COLUMN id SET DEFAULT nextval('competence_id_seq'::regclass);


--
-- Name: dependency id; Type: DEFAULT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY dependency ALTER COLUMN id SET DEFAULT nextval('dependency_id_seq'::regclass);


--
-- Name: learninggoal id; Type: DEFAULT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY learninggoal ALTER COLUMN id SET DEFAULT nextval('learninggoal_id_seq'::regclass);


--
-- Name: moduleassessment id; Type: DEFAULT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY moduleassessment ALTER COLUMN id SET DEFAULT nextval('moduleassessment_id_seq'::regclass);


--
-- Name: moduledescription id; Type: DEFAULT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY moduledescription ALTER COLUMN id SET DEFAULT nextval('moduledescription_id_seq'::regclass);


--
-- Name: topic id; Type: DEFAULT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY topic ALTER COLUMN id SET DEFAULT nextval('topic_id_seq'::regclass);


SET search_path = study, pg_catalog;

--
-- Name: activity id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY activity ALTER COLUMN id SET DEFAULT nextval('activity_id_seq'::regclass);


--
-- Name: architecturallayer id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY architecturallayer ALTER COLUMN id SET DEFAULT nextval('architectural_layer_id_seq'::regclass);


--
-- Name: curriculum id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY curriculum ALTER COLUMN id SET DEFAULT nextval('curriculum_id_seq'::regclass);


--
-- Name: department id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY department ALTER COLUMN id SET DEFAULT nextval('department_id_seq'::regclass);


--
-- Name: employee id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY employee ALTER COLUMN id SET DEFAULT nextval('employee_id_seq'::regclass);


--
-- Name: employee_department id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY employee_department ALTER COLUMN id SET DEFAULT nextval('employee_department_id_seq'::regclass);


--
-- Name: grading id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY grading ALTER COLUMN id SET DEFAULT nextval('grading_id_seq'::regclass);


--
-- Name: learninggoal id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY learninggoal ALTER COLUMN id SET DEFAULT nextval('learning_goal_id_seq'::regclass);


--
-- Name: learninggoal_qualification id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY learninggoal_qualification ALTER COLUMN id SET DEFAULT nextval('learning_goal_qualification_id_seq'::regclass);


--
-- Name: levelofskill id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY levelofskill ALTER COLUMN id SET DEFAULT nextval('level_of_skill_id_seq'::regclass);


--
-- Name: module id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY module ALTER COLUMN id SET DEFAULT nextval('module_id_seq'::regclass);


--
-- Name: module_employee id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY module_employee ALTER COLUMN id SET DEFAULT nextval('module_employee_id_seq'::regclass);


--
-- Name: module_profile id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY module_profile ALTER COLUMN id SET DEFAULT nextval('module_profile_id_seq'::regclass);


--
-- Name: moduleassessment id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduleassessment ALTER COLUMN id SET DEFAULT nextval('assessment_id_seq'::regclass);


--
-- Name: moduleassessment_learninggoal id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduleassessment_learninggoal ALTER COLUMN id SET DEFAULT nextval('moduleassessment_learninggoal_id_seq'::regclass);


--
-- Name: moduleassessment_moduleassessmenttype id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduleassessment_moduleassessmenttype ALTER COLUMN id SET DEFAULT nextval('moduleassessment_moduleassessmenttype_id_seq'::regclass);


--
-- Name: moduleasssementtype id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduleasssementtype ALTER COLUMN id SET DEFAULT nextval('asssementtype_id_seq'::regclass);


--
-- Name: moduledependency id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduledependency ALTER COLUMN id SET DEFAULT nextval('module_predecessors_id_seq'::regclass);


--
-- Name: moduledescription id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduledescription ALTER COLUMN id SET DEFAULT nextval('moduledescription_id_seq'::regclass);


--
-- Name: moduletopic id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduletopic ALTER COLUMN id SET DEFAULT nextval('module_topics_id_seq'::regclass);


--
-- Name: professionaltask id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY professionaltask ALTER COLUMN id SET DEFAULT nextval('professional_task_id_seq'::regclass);


--
-- Name: profile id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY profile ALTER COLUMN id SET DEFAULT nextval('profile_id_seq'::regclass);


--
-- Name: profile_qualification id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY profile_qualification ALTER COLUMN id SET DEFAULT nextval('profile_qualification_id_seq'::regclass);


--
-- Name: qualification id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY qualification ALTER COLUMN id SET DEFAULT nextval('qualification_id_seq'::regclass);


--
-- Name: studyprogramme id; Type: DEFAULT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY studyprogramme ALTER COLUMN id SET DEFAULT nextval('study_programme_id_seq'::regclass);


SET search_path = users, pg_catalog;

--
-- Name: accessright id; Type: DEFAULT; Schema: users; Owner: fmms
--

ALTER TABLE ONLY accessright ALTER COLUMN id SET DEFAULT nextval('accessright_id_seq'::regclass);


--
-- Name: role id; Type: DEFAULT; Schema: users; Owner: fmms
--

ALTER TABLE ONLY role ALTER COLUMN id SET DEFAULT nextval('role_id_seq'::regclass);


--
-- Name: user id; Type: DEFAULT; Schema: users; Owner: fmms
--

ALTER TABLE ONLY "user" ALTER COLUMN id SET DEFAULT nextval('user_id_seq'::regclass);


SET search_path = descriptions, pg_catalog;

--
-- Name: author authors_pkey; Type: CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY author
    ADD CONSTRAINT authors_pkey PRIMARY KEY (id);


--
-- Name: competence competence_pkey; Type: CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY competence
    ADD CONSTRAINT competence_pkey PRIMARY KEY (id);


--
-- Name: dependency dependency_pkey; Type: CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY dependency
    ADD CONSTRAINT dependency_pkey PRIMARY KEY (id);


--
-- Name: learninggoal learninggoal_pkey; Type: CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY learninggoal
    ADD CONSTRAINT learninggoal_pkey PRIMARY KEY (id);


--
-- Name: moduleassessment moduleassessment_pkey; Type: CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY moduleassessment
    ADD CONSTRAINT moduleassessment_pkey PRIMARY KEY (id);


--
-- Name: moduledescription moduledescription_pkey; Type: CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY moduledescription
    ADD CONSTRAINT moduledescription_pkey PRIMARY KEY (id);


--
-- Name: topic topic_pkey; Type: CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY topic
    ADD CONSTRAINT topic_pkey PRIMARY KEY (id);


SET search_path = study, pg_catalog;

--
-- Name: activity activity_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY activity
    ADD CONSTRAINT activity_pk PRIMARY KEY (id);


--
-- Name: architecturallayer architectural_layer_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY architecturallayer
    ADD CONSTRAINT architectural_layer_pk PRIMARY KEY (id);


--
-- Name: moduleassessment assessment_pkey; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduleassessment
    ADD CONSTRAINT assessment_pkey PRIMARY KEY (id);


--
-- Name: moduleasssementtype asssementtype_pkey; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduleasssementtype
    ADD CONSTRAINT asssementtype_pkey PRIMARY KEY (id);


--
-- Name: curriculum curriculum_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY curriculum
    ADD CONSTRAINT curriculum_pk PRIMARY KEY (id);


--
-- Name: department department_pkey; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY department
    ADD CONSTRAINT department_pkey PRIMARY KEY (id);


--
-- Name: employee_department employee_department_pkey; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY employee_department
    ADD CONSTRAINT employee_department_pkey PRIMARY KEY (id);


--
-- Name: employee employee_pkey; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY employee
    ADD CONSTRAINT employee_pkey PRIMARY KEY (id);


--
-- Name: grading grading_pkey; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY grading
    ADD CONSTRAINT grading_pkey PRIMARY KEY (id);


--
-- Name: learninggoal learning_goal_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY learninggoal
    ADD CONSTRAINT learning_goal_pk PRIMARY KEY (id);


--
-- Name: learninggoal_qualification learning_goal_qualification_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY learninggoal_qualification
    ADD CONSTRAINT learning_goal_qualification_pk PRIMARY KEY (id);


--
-- Name: learninggoal learninggoal_grading_id_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY learninggoal
    ADD CONSTRAINT learninggoal_grading_id_pk UNIQUE (grading_id);


--
-- Name: levelofskill level_of_skill_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY levelofskill
    ADD CONSTRAINT level_of_skill_pk PRIMARY KEY (id);


--
-- Name: module_employee module_employee_pkey; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY module_employee
    ADD CONSTRAINT module_employee_pkey PRIMARY KEY (id);


--
-- Name: module module_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY module
    ADD CONSTRAINT module_pk PRIMARY KEY (id);


--
-- Name: moduledependency module_predecessors_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduledependency
    ADD CONSTRAINT module_predecessors_pk PRIMARY KEY (id);


--
-- Name: module_profile module_profile_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY module_profile
    ADD CONSTRAINT module_profile_pk PRIMARY KEY (id);


--
-- Name: module_profile module_profile_un; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY module_profile
    ADD CONSTRAINT module_profile_un UNIQUE (module_id, profile_id);


--
-- Name: moduletopic module_topics_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduletopic
    ADD CONSTRAINT module_topics_pk PRIMARY KEY (id);


--
-- Name: moduleassessment_learninggoal moduleassessment_learninggoal_pkey; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduleassessment_learninggoal
    ADD CONSTRAINT moduleassessment_learninggoal_pkey PRIMARY KEY (id);


--
-- Name: moduleassessment_moduleassessmenttype moduleassessment_moduleassessmenttype_moduleassessment_id_modul; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduleassessment_moduleassessmenttype
    ADD CONSTRAINT moduleassessment_moduleassessmenttype_moduleassessment_id_modul PRIMARY KEY (moduleassessment_id, moduleassessmenttype_id);


--
-- Name: moduledescription moduledescription_pkey; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduledescription
    ADD CONSTRAINT moduledescription_pkey PRIMARY KEY (id);


--
-- Name: professionaltask professional_task_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY professionaltask
    ADD CONSTRAINT professional_task_pk PRIMARY KEY (id);


--
-- Name: profile profile_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY profile
    ADD CONSTRAINT profile_pk PRIMARY KEY (id);


--
-- Name: profile_qualification profile_qualification_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY profile_qualification
    ADD CONSTRAINT profile_qualification_pk PRIMARY KEY (id);


--
-- Name: qualification qualification_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY qualification
    ADD CONSTRAINT qualification_pk PRIMARY KEY (id);


--
-- Name: profile_qualification qualification_profile_un; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY profile_qualification
    ADD CONSTRAINT qualification_profile_un UNIQUE (profile_id, qualification_id);


--
-- Name: learninggoal sequenceno_un; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY learninggoal
    ADD CONSTRAINT sequenceno_un UNIQUE (module_id, sequenceno);


--
-- Name: moduletopic sequenceno_un2; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduletopic
    ADD CONSTRAINT sequenceno_un2 UNIQUE (module_id, sequenceno);


--
-- Name: profile study_curriculum_un; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY profile
    ADD CONSTRAINT study_curriculum_un UNIQUE (curriculum_id, studyprogramme_id);


--
-- Name: studyprogramme study_programme_pk; Type: CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY studyprogramme
    ADD CONSTRAINT study_programme_pk PRIMARY KEY (id);


SET search_path = users, pg_catalog;

--
-- Name: accessright accessright_pkey; Type: CONSTRAINT; Schema: users; Owner: fmms
--

ALTER TABLE ONLY accessright
    ADD CONSTRAINT accessright_pkey PRIMARY KEY (id);


--
-- Name: role role_pkey; Type: CONSTRAINT; Schema: users; Owner: fmms
--

ALTER TABLE ONLY role
    ADD CONSTRAINT role_pkey PRIMARY KEY (id);


--
-- Name: user user_pkey; Type: CONSTRAINT; Schema: users; Owner: fmms
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_pkey PRIMARY KEY (id);


--
-- Name: user_role user_role_pkey; Type: CONSTRAINT; Schema: users; Owner: fmms
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT user_role_pkey PRIMARY KEY (id);


SET search_path = descriptions, pg_catalog;

--
-- Name: authors_employee_id_index; Type: INDEX; Schema: descriptions; Owner: fmms
--

CREATE INDEX authors_employee_id_index ON author USING btree (orig_employee_id);


--
-- Name: competence_learninggoal_id_index; Type: INDEX; Schema: descriptions; Owner: fmms
--

CREATE INDEX competence_learninggoal_id_index ON competence USING btree (learninggoal_id);


--
-- Name: competence_orig_learninggoal_qualification_id_index; Type: INDEX; Schema: descriptions; Owner: fmms
--

CREATE INDEX competence_orig_learninggoal_qualification_id_index ON competence USING btree (orig_learninggoal_qualification_id);


--
-- Name: dependency_module_dependency_id_index; Type: INDEX; Schema: descriptions; Owner: fmms
--

CREATE INDEX dependency_module_dependency_id_index ON dependency USING btree (orig_module_dependency_id);


--
-- Name: dependency_moduledescription_id_index; Type: INDEX; Schema: descriptions; Owner: fmms
--

CREATE INDEX dependency_moduledescription_id_index ON dependency USING btree (moduledescription_id);


--
-- Name: learninggoal_learninggoal_id_index; Type: INDEX; Schema: descriptions; Owner: fmms
--

CREATE INDEX learninggoal_learninggoal_id_index ON learninggoal USING btree (orig_learninggoal_id);


--
-- Name: learninggoal_moduledescription_id_index; Type: INDEX; Schema: descriptions; Owner: fmms
--

CREATE INDEX learninggoal_moduledescription_id_index ON learninggoal USING btree (moduledescription_id);


--
-- Name: moduleassessment_learninggoal_id_index; Type: INDEX; Schema: descriptions; Owner: fmms
--

CREATE INDEX moduleassessment_learninggoal_id_index ON moduleassessment USING btree (learninggoal_id);


--
-- Name: moduleassessment_moduledescription_id_index; Type: INDEX; Schema: descriptions; Owner: fmms
--

CREATE INDEX moduleassessment_moduledescription_id_index ON moduleassessment USING btree (moduledescription_id);


--
-- Name: moduledescription_module_id_version_uindex; Type: INDEX; Schema: descriptions; Owner: fmms
--

CREATE UNIQUE INDEX moduledescription_module_id_version_uindex ON moduledescription USING btree (module_id, version);


--
-- Name: moduledescription_orig_moduledescription_id_index; Type: INDEX; Schema: descriptions; Owner: fmms
--

CREATE INDEX moduledescription_orig_moduledescription_id_index ON moduledescription USING btree (orig_moduledescription_id);


--
-- Name: topic_module_topic_id_index; Type: INDEX; Schema: descriptions; Owner: fmms
--

CREATE INDEX topic_module_topic_id_index ON topic USING btree (orig_module_topic_id);


--
-- Name: topic_moduledescription_id_index; Type: INDEX; Schema: descriptions; Owner: fmms
--

CREATE INDEX topic_moduledescription_id_index ON topic USING btree (moduledescription_id);


SET search_path = study, pg_catalog;

--
-- Name: assessment_code_uindex; Type: INDEX; Schema: study; Owner: fmms
--

CREATE UNIQUE INDEX assessment_code_uindex ON moduleassessment USING btree (code);


--
-- Name: assessment_module_id_index; Type: INDEX; Schema: study; Owner: fmms
--

CREATE INDEX assessment_module_id_index ON moduleassessment USING btree (module_id);


--
-- Name: curriculum_department_id_index; Type: INDEX; Schema: study; Owner: fmms
--

CREATE INDEX curriculum_department_id_index ON curriculum USING btree (department_id);


--
-- Name: curriculum_owner_employee_id_index; Type: INDEX; Schema: study; Owner: fmms
--

CREATE INDEX curriculum_owner_employee_id_index ON curriculum USING btree (owner_employee_id);


--
-- Name: employee_code_uindex; Type: INDEX; Schema: study; Owner: fmms
--

CREATE UNIQUE INDEX employee_code_uindex ON employee USING btree (code);


--
-- Name: employee_department_department_id_index; Type: INDEX; Schema: study; Owner: fmms
--

CREATE INDEX employee_department_department_id_index ON employee_department USING btree (department_id);


--
-- Name: employee_department_employee_id_index; Type: INDEX; Schema: study; Owner: fmms
--

CREATE INDEX employee_department_employee_id_index ON employee_department USING btree (employee_id);


--
-- Name: employee_pcn_uindex; Type: INDEX; Schema: study; Owner: fmms
--

CREATE UNIQUE INDEX employee_pcn_uindex ON employee USING btree (pcn);


--
-- Name: module_code_uindex; Type: INDEX; Schema: study; Owner: fmms
--

CREATE UNIQUE INDEX module_code_uindex ON module USING btree (code);


--
-- Name: module_dependency_module_id_dependency_module_id_uindex; Type: INDEX; Schema: study; Owner: fmms
--

CREATE UNIQUE INDEX module_dependency_module_id_dependency_module_id_uindex ON moduledependency USING btree (module_id, dependency_module_id);


--
-- Name: module_employee_module_id_employee_id_uindex; Type: INDEX; Schema: study; Owner: fmms
--

CREATE UNIQUE INDEX module_employee_module_id_employee_id_uindex ON module_employee USING btree (module_id, employee_id);


--
-- Name: moduleassessment_learninggoal_moduleassessment_id_learninggoal_; Type: INDEX; Schema: study; Owner: fmms
--

CREATE UNIQUE INDEX moduleassessment_learninggoal_moduleassessment_id_learninggoal_ ON moduleassessment_learninggoal USING btree (moduleassessment_id, learninggoal_id);


--
-- Name: moduledescription_module_id_uindex; Type: INDEX; Schema: study; Owner: fmms
--

CREATE UNIQUE INDEX moduledescription_module_id_uindex ON moduledescription USING btree (module_id);


SET search_path = users, pg_catalog;

--
-- Name: accessright_role_id_uindex; Type: INDEX; Schema: users; Owner: fmms
--

CREATE UNIQUE INDEX accessright_role_id_uindex ON accessright USING btree (role_id);


--
-- Name: user_employee_id_uindex; Type: INDEX; Schema: users; Owner: fmms
--

CREATE UNIQUE INDEX user_employee_id_uindex ON "user" USING btree (employee_id);


--
-- Name: user_role_id_uindex; Type: INDEX; Schema: users; Owner: fmms
--

CREATE UNIQUE INDEX user_role_id_uindex ON user_role USING btree (id);


--
-- Name: user_role_role_id_user_id_uindex; Type: INDEX; Schema: users; Owner: fmms
--

CREATE UNIQUE INDEX user_role_role_id_user_id_uindex ON user_role USING btree (role_id, user_id);


--
-- Name: user_username_uindex; Type: INDEX; Schema: users; Owner: fmms
--

CREATE UNIQUE INDEX user_username_uindex ON "user" USING btree (username);


SET search_path = descriptions, pg_catalog;

--
-- Name: moduledescription protect_final_descriptions_delete; Type: RULE; Schema: descriptions; Owner: fmms
--

CREATE RULE protect_final_descriptions_delete AS
    ON DELETE TO moduledescription DO INSTEAD NOTHING;


--
-- Name: moduledescription protect_final_descriptions_update; Type: RULE; Schema: descriptions; Owner: fmms
--

CREATE RULE protect_final_descriptions_update AS
    ON UPDATE TO moduledescription DO INSTEAD NOTHING;


SET search_path = study, pg_catalog;

--
-- Name: learninggoal trigger_learninggoal_create; Type: TRIGGER; Schema: study; Owner: fmms
--

CREATE TRIGGER trigger_learninggoal_create BEFORE INSERT ON learninggoal FOR EACH ROW EXECUTE PROCEDURE learninggoal_update();


--
-- Name: learninggoal trigger_learninggoal_update; Type: TRIGGER; Schema: study; Owner: fmms
--

CREATE TRIGGER trigger_learninggoal_update BEFORE UPDATE OF sequenceno, weight ON learninggoal FOR EACH ROW EXECUTE PROCEDURE learninggoal_update();


SET search_path = descriptions, pg_catalog;

--
-- Name: author author_moduledescription_id_fk; Type: FK CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY author
    ADD CONSTRAINT author_moduledescription_id_fk FOREIGN KEY (moduledescription_id) REFERENCES moduledescription(id) ON UPDATE CASCADE;


--
-- Name: author authors_employee_id_fk; Type: FK CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY author
    ADD CONSTRAINT authors_employee_id_fk FOREIGN KEY (orig_employee_id) REFERENCES study.employee(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: competence competence_learninggoal_id_fk; Type: FK CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY competence
    ADD CONSTRAINT competence_learninggoal_id_fk FOREIGN KEY (learninggoal_id) REFERENCES learninggoal(id) ON UPDATE CASCADE;


--
-- Name: competence competence_learninggoal_qualification_id_fk; Type: FK CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY competence
    ADD CONSTRAINT competence_learninggoal_qualification_id_fk FOREIGN KEY (orig_learninggoal_qualification_id) REFERENCES study.learninggoal_qualification(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: dependency dependency_module_dependency_id_fk; Type: FK CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY dependency
    ADD CONSTRAINT dependency_module_dependency_id_fk FOREIGN KEY (orig_module_dependency_id) REFERENCES study.moduledependency(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: dependency dependency_moduledescription_id_fk; Type: FK CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY dependency
    ADD CONSTRAINT dependency_moduledescription_id_fk FOREIGN KEY (moduledescription_id) REFERENCES moduledescription(id) ON UPDATE CASCADE;


--
-- Name: learninggoal learninggoal_learninggoal_id_fk; Type: FK CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY learninggoal
    ADD CONSTRAINT learninggoal_learninggoal_id_fk FOREIGN KEY (orig_learninggoal_id) REFERENCES study.learninggoal(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: learninggoal learninggoal_moduledescription_id_fk; Type: FK CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY learninggoal
    ADD CONSTRAINT learninggoal_moduledescription_id_fk FOREIGN KEY (moduledescription_id) REFERENCES moduledescription(id) ON UPDATE CASCADE;


--
-- Name: moduleassessment moduleassessment_learninggoal_id_fk; Type: FK CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY moduleassessment
    ADD CONSTRAINT moduleassessment_learninggoal_id_fk FOREIGN KEY (learninggoal_id) REFERENCES learninggoal(id) ON UPDATE CASCADE;


--
-- Name: moduleassessment moduleassessment_moduledescription_id_fk; Type: FK CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY moduleassessment
    ADD CONSTRAINT moduleassessment_moduledescription_id_fk FOREIGN KEY (moduledescription_id) REFERENCES moduledescription(id) ON UPDATE CASCADE;


--
-- Name: moduledescription moduledescription_module_id_fk; Type: FK CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY moduledescription
    ADD CONSTRAINT moduledescription_module_id_fk FOREIGN KEY (module_id) REFERENCES study.module(id) ON UPDATE CASCADE;


--
-- Name: moduledescription moduledescription_moduledescription_id_fk; Type: FK CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY moduledescription
    ADD CONSTRAINT moduledescription_moduledescription_id_fk FOREIGN KEY (orig_moduledescription_id) REFERENCES study.moduledescription(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: topic topic_module_topic_id_fk; Type: FK CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY topic
    ADD CONSTRAINT topic_module_topic_id_fk FOREIGN KEY (orig_module_topic_id) REFERENCES study.moduletopic(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: topic topic_moduledescription_id_fk; Type: FK CONSTRAINT; Schema: descriptions; Owner: fmms
--

ALTER TABLE ONLY topic
    ADD CONSTRAINT topic_moduledescription_id_fk FOREIGN KEY (moduledescription_id) REFERENCES moduledescription(id) ON UPDATE CASCADE;


SET search_path = study, pg_catalog;

--
-- Name: qualification activity_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY qualification
    ADD CONSTRAINT activity_fk FOREIGN KEY (activity_id) REFERENCES activity(id);


--
-- Name: qualification architectural_layer_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY qualification
    ADD CONSTRAINT architectural_layer_fk FOREIGN KEY (architecturallayer_id) REFERENCES architecturallayer(id);


--
-- Name: moduleassessment assessment_module_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduleassessment
    ADD CONSTRAINT assessment_module_id_fk FOREIGN KEY (module_id) REFERENCES module(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: curriculum curriculum_department_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY curriculum
    ADD CONSTRAINT curriculum_department_id_fk FOREIGN KEY (department_id) REFERENCES department(id) ON UPDATE CASCADE;


--
-- Name: curriculum curriculum_employee_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY curriculum
    ADD CONSTRAINT curriculum_employee_id_fk FOREIGN KEY (owner_employee_id) REFERENCES employee(id) ON UPDATE CASCADE;


--
-- Name: profile curriculum_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY profile
    ADD CONSTRAINT curriculum_id_fk FOREIGN KEY (curriculum_id) REFERENCES curriculum(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: employee_department employee_department_department_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY employee_department
    ADD CONSTRAINT employee_department_department_id_fk FOREIGN KEY (department_id) REFERENCES department(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: employee_department employee_department_employee_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY employee_department
    ADD CONSTRAINT employee_department_employee_id_fk FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: learninggoal_qualification learning_goal_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY learninggoal_qualification
    ADD CONSTRAINT learning_goal_id_fk FOREIGN KEY (learninggoal_id) REFERENCES learninggoal(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: learninggoal learninggoal_grading_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY learninggoal
    ADD CONSTRAINT learninggoal_grading_id_fk FOREIGN KEY (grading_id) REFERENCES grading(id) ON UPDATE CASCADE;


--
-- Name: qualification level_of_skill_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY qualification
    ADD CONSTRAINT level_of_skill_fk FOREIGN KEY (levelofskill_id) REFERENCES levelofskill(id);


--
-- Name: module_employee module_employee_employee_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY module_employee
    ADD CONSTRAINT module_employee_employee_id_fk FOREIGN KEY (employee_id) REFERENCES employee(id) ON UPDATE CASCADE;


--
-- Name: module_employee module_employee_module_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY module_employee
    ADD CONSTRAINT module_employee_module_id_fk FOREIGN KEY (module_id) REFERENCES module(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: module_profile module_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY module_profile
    ADD CONSTRAINT module_id_fk FOREIGN KEY (module_id) REFERENCES module(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: learninggoal module_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY learninggoal
    ADD CONSTRAINT module_id_fk FOREIGN KEY (module_id) REFERENCES module(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: moduledependency module_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduledependency
    ADD CONSTRAINT module_id_fk FOREIGN KEY (module_id) REFERENCES module(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: moduletopic module_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduletopic
    ADD CONSTRAINT module_id_fk FOREIGN KEY (module_id) REFERENCES module(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: moduleassessment_learninggoal moduleassessment_learninggoal_learninggoal_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduleassessment_learninggoal
    ADD CONSTRAINT moduleassessment_learninggoal_learninggoal_id_fk FOREIGN KEY (learninggoal_id) REFERENCES learninggoal(id) ON UPDATE CASCADE;


--
-- Name: moduleassessment_learninggoal moduleassessment_learninggoal_moduleassessment_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduleassessment_learninggoal
    ADD CONSTRAINT moduleassessment_learninggoal_moduleassessment_id_fk FOREIGN KEY (moduleassessment_id) REFERENCES moduleassessment(id) ON UPDATE CASCADE;


--
-- Name: moduleassessment_moduleassessmenttype moduleassessment_moduleassessmenttype_moduleassessment_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduleassessment_moduleassessmenttype
    ADD CONSTRAINT moduleassessment_moduleassessmenttype_moduleassessment_id_fk FOREIGN KEY (moduleassessment_id) REFERENCES moduleassessment(id) ON UPDATE CASCADE;


--
-- Name: moduleassessment_moduleassessmenttype moduleassessment_moduleassessmenttype_moduleasssementtype_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduleassessment_moduleassessmenttype
    ADD CONSTRAINT moduleassessment_moduleassessmenttype_moduleasssementtype_id_fk FOREIGN KEY (moduleassessmenttype_id) REFERENCES moduleasssementtype(id) ON UPDATE CASCADE;


--
-- Name: moduledescription moduledescription_module_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY moduledescription
    ADD CONSTRAINT moduledescription_module_id_fk FOREIGN KEY (module_id) REFERENCES module(id) ON UPDATE CASCADE;


--
-- Name: profile_qualification profile_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY profile_qualification
    ADD CONSTRAINT profile_id_fk FOREIGN KEY (profile_id) REFERENCES profile(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: module_profile profile_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY module_profile
    ADD CONSTRAINT profile_id_fk FOREIGN KEY (profile_id) REFERENCES profile(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: professionaltask qualification_id; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY professionaltask
    ADD CONSTRAINT qualification_id FOREIGN KEY (qualification_id) REFERENCES qualification(id);


--
-- Name: profile_qualification qualification_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY profile_qualification
    ADD CONSTRAINT qualification_id_fk FOREIGN KEY (qualification_id) REFERENCES qualification(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: learninggoal_qualification qualification_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY learninggoal_qualification
    ADD CONSTRAINT qualification_id_fk FOREIGN KEY (qualification_id) REFERENCES qualification(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: profile study_programme_id_fk; Type: FK CONSTRAINT; Schema: study; Owner: fmms
--

ALTER TABLE ONLY profile
    ADD CONSTRAINT study_programme_id_fk FOREIGN KEY (studyprogramme_id) REFERENCES studyprogramme(id) ON UPDATE RESTRICT ON DELETE RESTRICT;


SET search_path = users, pg_catalog;

--
-- Name: user user_employee_id_fk; Type: FK CONSTRAINT; Schema: users; Owner: fmms
--

ALTER TABLE ONLY "user"
    ADD CONSTRAINT user_employee_id_fk FOREIGN KEY (employee_id) REFERENCES study.employee(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: user_role user_role_role_id_fk; Type: FK CONSTRAINT; Schema: users; Owner: fmms
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT user_role_role_id_fk FOREIGN KEY (role_id) REFERENCES role(id) ON UPDATE CASCADE;


--
-- Name: user_role user_role_user_id_fk; Type: FK CONSTRAINT; Schema: users; Owner: fmms
--

ALTER TABLE ONLY user_role
    ADD CONSTRAINT user_role_user_id_fk FOREIGN KEY (user_id) REFERENCES "user"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: study; Type: ACL; Schema: -; Owner: fmms
--

GRANT ALL ON SCHEMA study TO PUBLIC;


--
-- PostgreSQL database dump complete
--

