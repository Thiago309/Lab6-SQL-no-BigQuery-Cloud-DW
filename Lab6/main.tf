provider "google" {
  project     = "modelagem-dw-Lab6"
  region      = "us-west1"
}

resource "google_bigquery_dataset" "lab6_dataset" {
  dataset_id                  = "lab6_dw_dataset"
  friendly_name               = "Lab 6"
  description                 = "Lab 6 do Curso de Modelagem de DW"
  location                    = "US"
}

resource "google_bigquery_table" "lab6_table_1" {
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.lab6_dataset.dataset_id
  table_id            = "tbCliente"

  schema = jsonencode([
    {
      "name": "tbCliente_id",
      "type": "INTEGER",
      "mode": "REQUIRED"
    },
    {
      "name": "Nome_Cliente",
      "type": "STRING",
      "mode": "REQUIRED"
    },
    {
      "name": "Tipo_Cliente",
      "type": "STRING",
      "mode": "REQUIRED"
    }
  ])
}

resource "google_bigquery_table" "lab6_table_2" {
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.lab6_dataset.dataset_id
  table_id            = "tbProduto"

  schema = jsonencode([
    {
      "name": "tbProduto_id",
      "type": "INTEGER",
      "mode": "REQUIRED"
    },
    {
      "name": "Nome_Produto",
      "type": "STRING",
      "mode": "REQUIRED"
    },
    {
      "name": "Categoria_Produto",
      "type": "STRING",
      "mode": "REQUIRED"
    }
  ])
}

resource "google_bigquery_table" "lab6_table_3" {
  deletion_protection = false
  dataset_id          = google_bigquery_dataset.lab6_dataset.dataset_id
  table_id            = "tbFato"

  schema = jsonencode([
    {
      "name": "fato_id",
      "type": "INTEGER",
      "mode": "REQUIRED"
    },
    {
      "name": "tbCliente_id",
      "type": "INTEGER",
      "mode": "REQUIRED"
    },
    {
      "name": "tbProduto_id",
      "type": "INTEGER",
      "mode": "REQUIRED"
    },
    {
      "name": "valor_venda",
      "type": "FLOAT",
      "mode": "REQUIRED"
    },
    {
      "name": "data",
      "type": "TIMESTAMP",
      "mode": "REQUIRED"
    }
  ])
}

/*Esse recurso evita conflitos de nomes na execução dos jobs na GCP. Senão, a execução sempre recriará os arquivos com o mesmo nome, causando conflitos.*/
resource "random_string" "random_id" {
  length  = 8
  special = false
  upper   = false
}

resource "google_bigquery_job" "job_sql_1" {
  job_id = "lab6_job_${random_string.random_id.result}_1"

  labels = {
    "lab6_job" = "job_sql_1"
  }

  load {
    source_uris = [
      "gs://lab6-modeling-p1/tbCliente.csv",
    ]

    destination_table {
      project_id = google_bigquery_table.lab6_table_1.project
      dataset_id = google_bigquery_table.lab6_table_1.dataset_id
      table_id   = google_bigquery_table.lab6_table_1.table_id
    }

    skip_leading_rows = 1
    schema_update_options = ["ALLOW_FIELD_RELAXATION", "ALLOW_FIELD_ADDITION"]
    write_disposition = "WRITE_APPEND"
    autodetect = true
  }
}

resource "google_bigquery_job" "job_sql_2" {
  job_id = "lab6_job_${random_string.random_id.result}_2"

  labels = {
    "lab6_job" = "job_sql_2"
  }

  load {
    source_uris = [
      "gs://lab6-modeling-p1/tbProduto.csv",
    ]

    destination_table {
      project_id = google_bigquery_table.lab6_table_2.project
      dataset_id = google_bigquery_table.lab6_table_2.dataset_id
      table_id   = google_bigquery_table.lab6_table_2.table_id
    }

    skip_leading_rows = 1
    schema_update_options = ["ALLOW_FIELD_RELAXATION", "ALLOW_FIELD_ADDITION"]
    write_disposition = "WRITE_APPEND"
    autodetect = true
  }
}

resource "google_bigquery_job" "job_sql_3" {
  job_id = "lab6_job_${random_string.random_id.result}_3"

  labels = {
    "lab6_job" = "job_sql_3"
  }

  load {
    source_uris = [
      "gs://lab6-modeling-p1/tbFato.csv",
    ]

    destination_table {
      project_id = google_bigquery_table.lab6_table_3.project
      dataset_id = google_bigquery_table.lab6_table_3.dataset_id
      table_id   = google_bigquery_table.lab6_table_3.table_id
    }

    skip_leading_rows = 1
    schema_update_options = ["ALLOW_FIELD_RELAXATION", "ALLOW_FIELD_ADDITION"]
    write_disposition = "WRITE_APPEND"
    autodetect = true
  }
}
