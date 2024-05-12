
# Database Schema Documentation for the ALV Project

## Overview
This document outlines the database schema developed for the 'aardvark-linkedin-query' component of the 'aardvark-lemon-virtue' (ALV) project. This component is an AWS Python Lambda function that retrieves job listings from LinkedIn via the Proxycurl service by Nubela, based on provided query parameters. The retrieved data is then stored in the defined schema.

## Schema Design
The schema is designed to support the operational processes and analytical needs of the `aardvark-linkedin-query` component, ensuring efficient data handling and scalability.

### Key Tables

#### RAW_JOBS
- **Description**: Stores raw job data fetched from LinkedIn through Proxycurl.
- **Columns**:
  - `JOB_PK` (VARCHAR(36), PK): Unique identifier for raw job records.
  - `REQUEST_PK` (VARCHAR(36)): Foreign key referencing the request table.
  - `JSON_RESPONSE` (VARCHAR(16777216)): JSON formatted response data.
  - `CREATED_AT` (TIMESTAMPNTZ(9)): Timestamp of record creation.
- **Comments**:
  - The table and each column are documented to clarify their purposes and data sources.

#### REQUEST
- **Description**: Logs details about the requests made to Proxycurl.
- **Columns**:
  - `REQUEST_PK` (VARCHAR(36), PK): Unique identifier for request records.
  - `QUERY_PARAMETERS` (VARCHAR(16777216)): Parameters used in the LinkedIn query.
  - `STATUS_CODE` (NUMBER(38)): HTTP status code of the request.
  - `ERROR_MESSAGE` (VARCHAR(16777216)): Description of any errors that occurred during the request.
  - `CREATED_AT` (TIMESTAMPNTZ(9)): Timestamp when the request was logged.
- **Comments**:
  - Detailed comments included for maintenance and troubleshooting.

### Naming Conventions
- **Prefixes**:
  - `RAW_`: Used for tables storing raw data directly from external sources.
  - `DEV_`: Indicates development environment tables, which helps in separating testing and production stages.

## Technology Stack
- **AWS Lambda**: Hosts the Python function that interacts with the Proxycurl service.
- **Python**: Programming language used for scripting the Lambda function.
- **Liquibase**: Manages database schema changes, ensuring reliable version control.
- **SQL**: Manages and manipulates the database.
- **Markdown**: Used for documenting the database schema.

## Versioning and Changes
- Managed through Liquibase, each schema change is documented with changesets for traceability and rollback capabilities.

## Usage Examples
- **Retrieve Job Data**:
  ```sql
  SELECT * FROM RAW_JOBS;
  ```
- **Check Request Logs**:
  ```sql
  SELECT * FROM REQUEST WHERE STATUS_CODE = 200;
  ```

## Contact and Support
- For more information or support related to the database schema, please contact [Lou Springer](mailto:lou@louspringer.com). For technical issues or contributions, refer to the project's GitHub issue tracker.

## Appendix
- **Iteration History**: Documenting each significant change and the rationale behind updates to provide context and insights for future references.
