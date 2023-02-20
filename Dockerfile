# For more information, please refer to https://aka.ms/vscode-docker-python
# FROM nvcr.io/nvidia/cuda:11.8.0-runtime-ubuntu22.04
# FROM nvcr.io/nvidia/pytorch:22.11-py3
FROM nvcr.io/nvidia/pytorch:23.01-py3
# FROM nvcr.io/nvidia/cuda:11.7.0-cudnn8-runtime-ubuntu22.04

# # Keeps Python from generating .pyc files in the container
ENV PYTHONDONTWRITEBYTECODE=1

# # Turns off buffering for easier container logging
ENV PYTHONUNBUFFERED=1


RUN apt update && apt install -y libfreetype6-dev git sudo python3-pip 
RUN apt install -y python-is-python3 libgl1-mesa-glx libglib2.0-0
# Install pip requirements
RUN pip install --upgrade pip
RUN pip install --upgrade fastapi gradio

# COPY requirements_versions.txt .
# RUN python -m pip install -r requirements_versions.txt

WORKDIR /app
COPY . /app

# # install requirements of Stable Diffusion
# RUN pip install transformers==4.19.2 diffusers invisible-watermark --prefer-binary

# # install k-diffusion
# RUN pip install git+https://github.com/crowsonkb/k-diffusion.git --prefer-binary

# # (optional) install GFPGAN (face restoration)
# RUN pip install git+https://github.com/TencentARC/GFPGAN.git --prefer-binary

# # install requirements of web ui
# RUN pip install -r requirements.txt  --prefer-binary

# # update numpy to latest version
# RUN pip install -U numpy  --prefer-binary


# # clone repositories for Stable Diffusion and (optionally) CodeFormer
# RUN mkdir repositories
# RUN git clone https://github.com/CompVis/stable-diffusion.git repositories/stable-diffusion-stability-ai
# RUN git clone https://github.com/CompVis/taming-transformers.git repositories/taming-transformers
# RUN git clone https://github.com/sczhou/CodeFormer.git repositories/CodeFormer
# RUN git clone https://github.com/salesforce/BLIP.git repositories/BLIP
# RUN git clone https://github.com/crowsonkb/k-diffusion.git repositories/k-diffusion
# RUN git clone https://github.com/Hafiidz/latent-diffusion.git repositories/latent-diffusion


# # (optional) install requirements for CodeFormer (face restoration)
# RUN pip install -r repositories/CodeFormer/requirements.txt --prefer-binary


ARG user_id
ARG group_id
# Creates a non-root user with an explicit UID and adds permission to access the /app folder
# For more info, please refer to https://aka.ms/vscode-docker-python-configure-containers
RUN addgroup --gid ${group_id} group
RUN adduser --uid ${user_id} --gid ${group_id} --disabled-password --gecos "" user && chown -R user.group /app
USER user
ENV HOME=/home/user

RUN python launch.py --exit --skip-torch-cuda-test