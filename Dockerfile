FROM ubuntu:22.04 as NopCommerce
ARG DOWNLOAD_URL="https://github.com/nopSolutions/nopCommerce/releases/download/release-4.60.4/nopCommerce_4.60.4_NoSource_linux_x64.zip"
ADD ${DOWNLOAD_URL} /nop/nopCommerce_4.60.4_NoSource_linux_x64.zip
RUN apt update && \
    apt install unzip && \
    cd /nop && \
    unzip nopCommerce_4.60.4_NoSource_linux_x64.zip && mkdir bin logs \
    && rm nopCommerce_4.60.4_NoSource_linux_x64.zip
## stage-2
FROM mcr.microsoft.com/dotnet/sdk:7.0
ARG LABEL author="shivaji" organization="learningThoughts" project="NopCommerce"
COPY --from=NopCommerce /nop /NopCommerce
WORKDIR /NopCommerce
EXPOSE 5000
ENV DOTNET_URLS="http://0.0.0.0:5000"
ENTRYPOINT [ "dotnet","Nop.Web.dll" ]