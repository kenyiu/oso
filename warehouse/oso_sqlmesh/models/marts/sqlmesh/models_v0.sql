MODEL (
  name oso.models_v0,
  kind FULL,
  tags (
    'export',
    'model_type=full',
    'model_category=sqlmesh',
    'model_stage=mart'
  ),
  audits (
    has_at_least_n_rows(threshold := 0)
  ),
  description 'Each row represents a versioned machine learning model, including its unique identifier, name, and the SQL code used to generate its outputs, along with the timestamp when it was rendered. This data can be used to track model deployments, analyze model usage, and audit changes over time for governance or performance monitoring. Business questions that can be answered include: Which models are most frequently updated or deployed? What types of analyses or aggregations are being automated with machine learning models? How has the SQL logic or configuration of a specific model changed over time?',
  column_descriptions (
    model_id = 'The unique identifier for the model, as generated by OSO.',
    model_name = 'The name of the model.',
    rendered_sql = 'The rendered SQL for the model.',
    rendered_at = 'The timestamp when the model was rendered.'
  )
);

WITH all_models AS (
  SELECT
    @oso_id('OSO', 'sqlmesh', model_name) AS model_id,
    model_name,
    rendered_sql,
    rendered_at,
  FROM oso.stg_sqlmesh__rendered_models
)
SELECT
    model_id::TEXT,
    model_name::TEXT,
    rendered_sql::TEXT,
    rendered_at::TIMESTAMP
FROM all_models
