-- liquibase formatted sql

-- changeset lou:1715476947149-1
CREATE TABLE RAW_JOBS (JOB_PK VARCHAR(36) NOT NULL, REQUEST_PK VARCHAR(36) NOT NULL, JSON_RESPONSE VARCHAR(16777216), CREATED_AT TIMESTAMPNTZ(9) NOT NULL, CONSTRAINT PK_RAW_JOBS PRIMARY KEY (JOB_PK));
COMMENT ON TABLE RAW_JOBS IS 'Table for storing raw job data.';
COMMENT ON COLUMN RAW_JOBS.JOB_PK IS 'Primary key for raw job records.';
COMMENT ON COLUMN RAW_JOBS.REQUEST_PK IS 'Foreign key referencing the request table.';
COMMENT ON COLUMN RAW_JOBS.JSON_RESPONSE IS 'JSON response data for raw job records.';
COMMENT ON COLUMN RAW_JOBS.CREATED_AT IS 'Timestamp indicating when the raw job record was created.';

-- changeset lou:1715476947149-2
CREATE TABLE REQUEST (REQUEST_PK VARCHAR(36) NOT NULL, QUERY_PARAMETERS VARCHAR(16777216), STATUS_CODE NUMBER(38), ERROR_MESSAGE VARCHAR(16777216), CREATED_AT TIMESTAMPNTZ(9) NOT NULL, CONSTRAINT PK_REQUEST PRIMARY KEY (REQUEST_PK));
COMMENT ON TABLE REQUEST IS 'Table for storing request data.';
COMMENT ON COLUMN REQUEST.REQUEST_PK IS 'Primary key for request records.';
COMMENT ON COLUMN REQUEST.QUERY_PARAMETERS IS 'Query parameters for the request.';
COMMENT ON COLUMN REQUEST.STATUS_CODE IS 'Status code for the request.';
COMMENT ON COLUMN REQUEST.ERROR_MESSAGE IS 'Error message for the request, if any.';
COMMENT ON COLUMN REQUEST.CREATED_AT IS 'Timestamp indicating when the request record was created.';

