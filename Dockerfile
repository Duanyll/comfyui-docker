FROM pytorch/pytorch:2.6.0-cuda12.6-cudnn9-devel

ARG UBUNTU_MIRROR=http://mirrors.bfsu.edu.cn/ubuntu
ARG UBUNTU_SECURITY_MIRROR=http://security.ubuntu.com/ubuntu
ARG PYPI_MIRROR=https://mirrors.bfsu.edu.cn/pypi/web/simple
ARG USER_NAME=comfy
ARG USER_UID=1000
ARG USER_GID=1000
ARG TZ=Asia/Shanghai

COPY scripts/build.sh /scripts/build.sh
RUN bash /scripts/build.sh

USER ${USER_NAME}
ENV PIP_USER=true
ENV PIP_INDEX_URL=${PYPI_MIRROR}
ENV PATH=/home/${USER_NAME}/.local/bin:${PATH}
WORKDIR /workspace
VOLUME /home/${USER_NAME}/.local
VOLUME /home/${USER_NAME}/.cache/huggingface
VOLUME /workspace

COPY scripts/entrypoint.sh scripts/launch.json scripts/healthcheck.sh /scripts/
CMD ["bash", "/scripts/entrypoint.sh"]
EXPOSE 8188
HEALTHCHECK --interval=60s --timeout=10s --start-period=30s --retries=3 CMD ["bash", "/scripts/healthcheck.sh"]