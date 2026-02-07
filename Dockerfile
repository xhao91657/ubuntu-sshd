# 使用 NVIDIA CUDA Ubuntu 24.04 基础镜像
FROM nvidia/cuda:12.4.0-base-ubuntu24.04

# 设置环境变量以避免交互式提示
ENV DEBIAN_FRONTEND=noninteractive

# 更新包列表并安装 SSH 服务器
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    openssh-server \
    net-tools \
    iproute2 \
    && rm -rf /var/lib/apt/lists/*

# 创建 SSH 目录并生成主机密钥
RUN mkdir /var/run/sshd && \
    ssh-keygen -A

# 配置 SSH：允许 root 登录并设置密码验证
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# 设置 root 密码为 "12345678"
RUN echo 'root:12345678' | chpasswd

# 暴露 SSH 端口
EXPOSE 22

# 启动 SSH 服务
CMD ["/usr/sbin/sshd", "-D"]
