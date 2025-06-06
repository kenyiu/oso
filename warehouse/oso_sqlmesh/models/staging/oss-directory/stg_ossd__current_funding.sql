MODEL (
  name oso.stg_ossd__current_funding,
  description 'The most recent view of funding information from the OSSD source',
  dialect trino,
  kind FULL,
  audits (
    HAS_AT_LEAST_N_ROWS(threshold := 0)
  )
);

SELECT
  LOWER(funding.to_project_name) AS to_project_name,
  COALESCE(
    TRY_CAST(funding.amount AS DOUBLE),
    0.0
  ) AS amount,
  COALESCE(
    TRY_CAST(funding.funding_date AS TIMESTAMP),
    CAST('1970-01-01' AS TIMESTAMP)
  ) AS funding_date,
  LOWER(funding.from_funder_name) AS from_funder_name,
  LOWER(funding.grant_pool_name) AS grant_pool_name,
  funding.metadata AS metadata,
  funding.file_path
FROM @oso_source('bigquery.ossd.funding') AS funding
