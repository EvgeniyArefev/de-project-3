# Project «ETL и автоматизации подготовки данных»

### Описание

В данном проекте реализован `DAG` в `Airflow` для загрузки данных по API в хранилище `PostgeSQL`

### Как работать с репозиторием

1. В папке `migrations` находится ddl код создания витрины `mart.f_customer_retention`
2. В папке `src\dags` хранятся файлы для запуска `DAG`

### Структура репозитория

1. Папка `migrations` хранит файлы миграции с расширением `.sql`.
2. В папке `src` хранятся все необходимые исходники:
   - Папка `dags` содержит DAG's Airflow.

### Запуск контейнера

```
docker run -d --rm -p 3000:3000 -p 15432:5432 --name=de-project-sprint-3-server sindb/project-sprint-3:latest
```

После того как запустится контейнер, у вас будут доступны:

1. Visual Studio Code
2. Airflow
3. Database
