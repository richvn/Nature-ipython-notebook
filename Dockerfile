FROM ipython/scipystack

MAINTAINER IPython Project <ipython-dev@scipy.org>

RUN pip3 install ipython[notebook] --force-reinstall
RUN pip3 install scikit-image

EXPOSE 8888

RUN useradd -m -s /bin/bash jovyan

ADD . /home/jovyan/

RUN chown jovyan:jovyan /home/jovyan -R

USER jovyan
ENV HOME /home/jovyan
ENV SHELL /bin/bash
ENV USER jovyan

WORKDIR /home/jovyan/

RUN find . -name '*.ipynb' -exec ipython trust {} \;

RUN chown -R jovyan:jovyan /home/jovyan

CMD ipython3 notebook --no-browser --port 8888 --ip=0.0.0.0 --NotebookApp.base_url=/$RAND_BASE --NotebookApp.tornado_settings="{'template_path':['/srv/ga/', '/srv/ipython/IPython/html', '/srv/ipython/IPython/html/templates']}"
