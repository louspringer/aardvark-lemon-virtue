# Start from a core stack version
FROM jupyter/pyspark-notebook:2022-04-11
# Install from requirements.txt file
COPY --chown=${NB_UID}:${NB_GID} requirements.txt /tmp/
# RUN rm /usr/local/spark/jars/guava-14.0.1.jar
# COPY aws-hadoop-jars/* /usr/local/spark/jars
RUN pip install --quiet --no-cache-dir --requirement /tmp/requirements.txt && \
    fix-permissions "${CONDA_DIR}" && \
    fix-permissions "/home/${NB_USER}"

ENTRYPOINT ["tini", "-g", "--"]
CMD ["start-notebook.sh  --ip=*"]

# Add local files as late as possible to avoid cache busting
COPY start.sh /usr/local/bin/
COPY start-notebook.sh /usr/local/bin/
COPY start-singleuser.sh /usr/local/bin/