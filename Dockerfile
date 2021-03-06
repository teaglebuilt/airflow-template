FROM apache/airflow:2.0.0-python3.8

USER root

# Install cmd utils
RUN apt-get update -yqq \
    && apt-get install -y git \
                          libsasl2-dev \
                          procps \ 
                          vim \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install MS SQL Support (ODBC Driver)
RUN apt-get update \
    && apt-get install -y gnupg curl \
    && curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add --no-tty - \
    && curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list \
    && apt-get update \
    && ACCEPT_EULA=Y apt-get install -y msodbcsql17 unixodbc-dev g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

USER airflow

# Install airflow packages
RUN pip install --user apache-airflow[apache.hive]
RUN pip install --user apache-airflow[odbc]
RUN pip install --user apache-airflow[microsoft.mssql]
RUN pip install --user apache-airflow[presto]
RUN pip install --user apache-airflow[postgres]

# Install bossruji's plugin dependencies
RUN pip install --user pandas