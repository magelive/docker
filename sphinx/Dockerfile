FROM ubuntu

RUN ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
RUN echo "Asia/Shanghai" > /etc/timezone


RUN ["apt", "update"]
RUN ["apt", "install", "-y", "python3", "python3-pip", "python3-sphinx", "doxygen", "plantuml"]
RUN ["pip3", "install", "--upgrade", "breathe", "recommonmark", "sphinx_markdown_tables", "sphinxcontrib-plantuml", "sphinxcontrib-markdown", "sphinx_rtd_theme", "myst_parser"]





