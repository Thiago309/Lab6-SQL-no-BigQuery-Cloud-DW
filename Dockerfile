# Use a imagem oficial do Ubuntu como base
FROM ubuntu:latest

# Mantenedor do Dockerfile
LABEL maintainer="Thiago Vinicius"

# Definir a versão do Terraform ultima versão sem ser beta (evita bugs e erros)
ENV TERRAFORM_VERSION=1.14.9

# Atualizar os pacotes do sistema e instalar dependências necessarias (wget, curl, unzip, tree para visualização, git para o realizar o download dos modulos dos serviços Azure no GitHub)
# Adicionei 'lsb-release' e 'gnupg', que são frequentemente exigidos por scripts de instalação da Microsoft
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wget \
    unzip \
    curl \
    tree \
    vim \
    git \
    openssh-client \
    iputils-ping \
    ca-certificates \
    lsb-release \
    gnupg && \
    rm -rf /var/lib/apt/lists/*

# Baixar e instalar Terraform
RUN wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

# Boa Prática: O comando 'apt-key' foi descontinuado no Ubuntu/Debian. 
# Atualizei para o método moderno usando 'gpg --dearmor' para gerenciar a chave do Google Cloud SDK.
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && apt-get install -y google-cloud-sdk && \
    rm -rf /var/lib/apt/lists/*

# Criar a pasta /lab6 como um ponto de montagem para um volume
RUN mkdir /lab6

# Cria um volume no container
VOLUME /lab6

# Definir o diretório de trabalho padrão
WORKDIR /lab6

# Definir o comando padrão para execução quando o container for iniciado
CMD ["/bin/bash"]
