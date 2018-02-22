#!/bin/bash

# re-enable jupyter-scala kernelspec
#cd jupyter-scala
#bash jupyter-scala
#cd ..

bash start-notebook.sh --NotebookApp.keyfile=mycert.pem --NotebookApp.certfile=mycert.pem --NotebookApp.password='sha1:832eed7478e2:4f26774c296b0cb8fa950c11edc8a42e43ead533'
